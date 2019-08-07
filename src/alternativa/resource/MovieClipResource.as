package alternativa.resource
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class MovieClipResource extends Resource
   {
       
      
      private var loader:Loader;
      
      public function MovieClipResource()
      {
         super("мувик");
         throw new Error("Unimplemented");
      }
      
      override protected function loadResourceData() : void
      {
         var context:LoaderContext = new LoaderContext();
         context.applicationDomain = ApplicationDomain.currentDomain;
         context.securityDomain = SecurityDomain.currentDomain;
         this.loader.load(new URLRequest(url + "mc.swf"),context);
      }
      
      private function onLoadProgress(e:ProgressEvent) : void
      {
         loadingProgress(this.loader.contentLoaderInfo.bytesLoaded,this.loader.contentLoaderInfo.bytesTotal);
      }
      
      protected function onLoadComplete(e:Event = null) : void
      {
         completeLoading();
      }
      
      public function get mc() : MovieClip
      {
         return MovieClip(this.loader.content);
      }
      
      private function onLoadError(e:ErrorEvent) : void
      {
         reportFatalError(e.text);
      }
   }
}
