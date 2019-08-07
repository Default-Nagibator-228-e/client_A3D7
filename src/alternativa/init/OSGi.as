package alternativa.init
{
   import alternativa.osgi.bundle.Bundle;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.console.ConsoleService;
   import alternativa.osgi.service.console.DummyConsoleService;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.debug.DebugService;
   import alternativa.osgi.service.debug.IDebugService;
   import alternativa.osgi.service.dump.DumpService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.BundleDumper;
   import alternativa.osgi.service.dump.dumper.ServiceDumper;
   import alternativa.osgi.service.focus.FocusService;
   import alternativa.osgi.service.focus.IFocusService;
   import alternativa.osgi.service.loader.ILoaderService;
   import alternativa.osgi.service.loader.LoaderService;
   import alternativa.osgi.service.loaderParams.ILoaderParamsService;
   import alternativa.osgi.service.loaderParams.LoaderParamsService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.locale.LocaleService;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.mainContainer.MainContainerService;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.osgi.service.network.NetworkService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.osgi.service.storage.StorageService;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.net.SharedObject;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public class OSGi
   {
      
      private static var instance:OSGi;
       
      
      private const REGEXP_TRIM:RegExp = /^\s*(.*?)\s*$/;
      
      private var bundles:Dictionary;
      
      private var _bundleList:Vector.<Bundle>;
      
      private var services:Dictionary;
      
      private var _serviceList:Vector.<Object>;
      
      public function OSGi()
      {
         super();
         this.services = new Dictionary(false);
         this.bundles = new Dictionary(false);
         this._bundleList = new Vector.<Bundle>();
         this._serviceList = new Vector.<Object>();
      }
      
      public static function init(debug:Boolean, _stage:Stage, container:DisplayObjectContainer, server:String, ports:Array, proxyHost:String, proxyPort:int, resources:String, log:Object, sharedObject:SharedObject, language:String, loaderParams:Object) : OSGi
      {
         container.focusRect = false;
         instance = new OSGi();
         instance.registerService(ILoaderParamsService,new LoaderParamsService(loaderParams));
         if(debug)
         {
            instance.registerService(IConsoleService,new ConsoleService(log));
            instance.registerService(IDebugService,new DebugService());
         }
         else
         {
            instance.registerService(IConsoleService,new DummyConsoleService());
         }
         instance.registerService(IFocusService,new FocusService(_stage));
         instance.registerService(IMainContainerService,new MainContainerService(_stage,container));
         instance.registerService(INetworkService,new NetworkService(server,ports,resources,proxyHost,proxyPort));
         instance.registerService(IStorageService,new StorageService(sharedObject));
         var dumpService:IDumpService = new DumpService(instance);
         instance.registerService(IDumpService,dumpService);
         instance.registerService(ILoaderService,new LoaderService());
         instance.registerService(ILocaleService,new LocaleService(language));
         dumpService.registerDumper(new BundleDumper(instance));
         dumpService.registerDumper(new ServiceDumper(instance));
         return instance;
      }
      
      public static function get osgi() : OSGi
      {
         return instance;
      }
      
      public function installBundle(manifest:String) : Bundle
      {
         var consoleService:IConsoleService = this.getService(IConsoleService) as IConsoleService;
         var bundle:Bundle = this.parseManifest(manifest);
         if(bundle != null)
         {
            if(this.bundles[bundle.name] == null)
            {
               this.bundles[bundle.name] = bundle;
               this._bundleList.push(bundle);
               if(bundle.activator != null)
               {
                  bundle.activator.start(this);
               }
               else if(consoleService != null)
               {
                  consoleService.writeToConsoleChannel("OSGI","Bundle activator = null");
               }
            }
            else
            {
               throw new Error("Bundle [" + bundle.name + "] already installed");
            }
         }
         else if(consoleService != null)
         {
            consoleService.writeToConsoleChannel("OSGI","Bundle = null");
         }
         if(consoleService != null)
         {
            consoleService.writeToConsoleChannel("OSGI","Bundle " + bundle.name + " installed");
         }
         return bundle;
      }
      
      private function parseManifest(manifest:String) : Bundle
      {
         var s:String = null;
         var parts:Array = null;
         var value:String = null;
         var activatorClass:Class = null;
         var activator:IBundleActivator = null;
         var manifestStrings:Array = manifest.split(/\r*\n/);
         var manifestParams:Dictionary = new Dictionary(false);
         for(var i:int = 0; i < manifestStrings.length; i++)
         {
            s = manifestStrings[i].replace(this.REGEXP_TRIM,"$1");
            if(s.length != 0)
            {
               parts = s.split(/\s*:\s*/,2);
               value = parts[1].replace(this.REGEXP_TRIM,"$1");
               manifestParams[parts[0]] = value;
            }
         }
         var name:String = manifestParams["Bundle-Name"];
         var activatorClassName:String = manifestParams["Bundle-Activator"];
         if(ApplicationDomain.currentDomain.hasDefinition(activatorClassName))
         {
            activatorClass = Class(ApplicationDomain.currentDomain.getDefinition(activatorClassName));
            activator = IBundleActivator(new activatorClass());
         }
         if(name != "" && name != null)
         {
            return new Bundle(name,activator,manifestParams);
         }
         throw new Error("Manifest not valid");
      }
      
      public function uninstallBundle(bundle:Bundle) : void
      {
         var consoleService:IConsoleService = this.getService(IConsoleService) as IConsoleService;
         if(bundle == null)
         {
            throw new Error("OSGi ERROR: uninstall NULL bundle");
         }
         if(bundle.activator != null)
         {
            bundle.activator.stop(this);
         }
         this._bundleList.splice(this._bundleList.indexOf(bundle),1);
         delete this.bundles[bundle.name];
         if(consoleService != null)
         {
            consoleService.writeToConsoleChannel("OSGI","Bundle " + bundle.name + " uninstalled");
         }
      }
      
      public function registerService(serviceInterface:Class, serviceImplementation:Object) : void
      {
         var consoleService:IConsoleService = this.getService(IConsoleService) as IConsoleService;
         if(this.services[serviceInterface] == null)
         {
            this.services[serviceInterface] = serviceImplementation;
            this._serviceList.push(serviceImplementation);
            if(consoleService != null)
            {
               consoleService.writeToConsoleChannel("OSGI","Service " + serviceInterface + " registered");
            }
         }
         else
         {
            this.services[serviceInterface] = serviceImplementation;
         }
      }
      
      public function unregisterService(serviceInterface:Class) : void
      {
         var consoleService:IConsoleService = this.getService(IConsoleService) as IConsoleService;
         this._serviceList.splice(this._serviceList.indexOf(this.services[serviceInterface]),1);
         delete this.services[serviceInterface];
         if(consoleService != null)
         {
            consoleService.writeToConsoleChannel("OSGI","Service " + serviceInterface + " unregistered");
         }
      }
      
      public function getService(serviceInterface:Class) : Object
      {
         return this.services[serviceInterface];
      }
      
      public function get bundleList() : Vector.<Bundle>
      {
         return this._bundleList;
      }
      
      public function get serviceList() : Vector.<Object>
      {
         return this._serviceList;
      }
   }
}
