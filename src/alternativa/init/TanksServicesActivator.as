package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.tanks.bg.BackgroundService;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.help.HelpService;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.loader.LoaderWindow;
   
   public class TanksServicesActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      private var loaderWindow:LoaderWindow;
      
      public function TanksServicesActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         TanksServicesActivator.osgi = osgi;
         var bgService:IBackgroundService = new BackgroundService();
         osgi.registerService(IBackgroundService,bgService);
         osgi.registerService(IHelpService,new HelpService());
         bgService.showBg();
         this.loaderWindow = new LoaderWindow();
         osgi.registerService(ILoaderWindowService,this.loaderWindow);
      }
      
      public function stop(osgi:OSGi) : void
      {
         osgi.unregisterService(IBackgroundService);
         osgi.unregisterService(IHelpService);
         osgi.unregisterService(ILoaderWindowService);
         this.loaderWindow = null;
         TanksServicesActivator.osgi = null;
      }
   }
}
