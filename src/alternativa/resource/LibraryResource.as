package alternativa.resource
{
   import alternativa.init.Main;
   import alternativa.osgi.bundle.Bundle;
   import alternativa.osgi.service.debug.IDebugService;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class LibraryResource extends Resource
   {
      
      private static const LOADING_STATE_MANIFEST:int = LOADING_STATE_INFO + 1;
      
      private static const LOADING_STATE_LIBRARY:int = LOADING_STATE_INFO + 2;
      
      private static const LIB_FILE_NAME:String = "library";
      
      private static const LIB_FILE_NAME_DEBUG:String = "debug";
       
      
      private var libraryLoader:Loader;
      
      private var manifestLoader:URLLoader;
      
      private var bundle:Bundle;
      
      public function LibraryResource()
      {
         super("Библиотека");
      }
      
      override protected function doUnload() : void
      {
         if(this.libraryLoader == null)
         {
            return;
         }
         this.libraryLoader.unload();
         this.destroyLibraryLoader();
         this.destroyManifestLoader();
         Main.osgi.uninstallBundle(this.bundle);
         this.bundle = null;
      }
      
      override protected function doClose() : void
      {
         switch(loadingState)
         {
            case LOADING_STATE_MANIFEST:
               this.manifestLoader.close();
               this.destroyManifestLoader();
               this.libraryLoader.unload();
               this.destroyLibraryLoader();
               break;
            case LOADING_STATE_LIBRARY:
               this.libraryLoader.close();
               this.destroyLibraryLoader();
         }
      }
      
      override protected function loadResourceData() : void
      {
         this.libraryLoader = new Loader();
         this.libraryLoader.contentLoaderInfo.addEventListener(Event.OPEN,this.onLibraryLoadingOpen);
         this.libraryLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadingProgress);
         this.libraryLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLibraryLoadingComplete);
         this.libraryLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError);
         this.libraryLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadingError);
         var isDebug:Boolean = Main.osgi.getService(IDebugService) != null;
         var libFileName:String = !!isDebug?LIB_FILE_NAME_DEBUG:LIB_FILE_NAME;
         if(locale_postfix != null)
         {
            libFileName = libFileName + locale_postfix;
         }
         var libUrl:String = url + libFileName + ".swf";
         this.libraryLoader.load(new URLRequest(libUrl),new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain));
         startTimeoutTimer();
      }
      
      private function onLibraryLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_LIBRARY;
      }
      
      private function onLibraryLoadingComplete(e:Event) : void
      {
         setIdleLoadingState();
         this.manifestLoader = new URLLoader();
         this.manifestLoader.addEventListener(Event.OPEN,this.onManifestLoadingOpen);
         this.manifestLoader.addEventListener(ProgressEvent.PROGRESS,this.onLoadingProgress);
         this.manifestLoader.addEventListener(Event.COMPLETE,this.onManifestLoadingComplete);
         this.manifestLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError);
         this.manifestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadingError);
         var manifestFileName:String = locale_postfix == null?"MANIFEST.MF":"MANIFEST" + locale_postfix + ".MF";
         this.manifestLoader.load(new URLRequest(url + manifestFileName));
         startTimeoutTimer();
      }
      
      private function onManifestLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_MANIFEST;
      }
      
      private function onManifestLoadingComplete(e:Event) : void
      {
         setIdleLoadingState();
         this.bundle = Main.osgi.installBundle(this.manifestLoader.data);
         this.destroyManifestLoader();
         completeLoading();
      }
      
      private function onLoadingProgress(e:ProgressEvent) : void
      {
         loadingProgress(e.bytesLoaded,e.bytesTotal);
      }
      
      private function onLoadingError(e:ErrorEvent) : void
      {
         reportFatalError(e.text);
      }
      
      private function destroyManifestLoader() : void
      {
         if(this.manifestLoader == null)
         {
            return;
         }
         this.manifestLoader.removeEventListener(Event.OPEN,this.onManifestLoadingOpen);
         this.manifestLoader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadingProgress);
         this.manifestLoader.removeEventListener(Event.COMPLETE,this.onManifestLoadingComplete);
         this.manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError);
         this.manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadingError);
         this.manifestLoader = null;
      }
      
      private function destroyLibraryLoader() : void
      {
         if(this.libraryLoader == null)
         {
            return;
         }
         this.libraryLoader.contentLoaderInfo.removeEventListener(Event.OPEN,this.onLibraryLoadingOpen);
         this.libraryLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadingProgress);
         this.libraryLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLibraryLoadingComplete);
         this.libraryLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError);
         this.libraryLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadingError);
         this.libraryLoader = null;
      }
   }
}
