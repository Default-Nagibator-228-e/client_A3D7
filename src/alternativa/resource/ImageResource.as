package alternativa.resource
{
   import alternativa.init.Main;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class ImageResource extends Resource
   {
      
      private static const LOADING_STATE_IMAGE_INFO:int = Resource.LOADING_STATE_INFO + 1;
      
      private static const LOADING_STATE_IMAGE:int = Resource.LOADING_STATE_INFO + 2;
      
      private static const IMAGE_INFO_XML:String = "image.xml";
      
      private static const IMAGE_FILE:String = "image.jpg";
      
      private static const ALPHA_FILE:String = "alpha.gif";
      
      private static const LOADING_DIFFUSE:int = 0;
      
      private static const LOADING_ALPHA:int = 1;
       
      
      private var imageLoader:Loader;
      
      private var imageInfoXml:XML;
      
      private var state:int;
      
      private var imageInfoLoader:URLLoader;
      
      private var _data:BitmapData;
      
      public function ImageResource()
      {
         super("Картинка");
      }
      
      public function get data() : BitmapData
      {
         return this._data;
      }
      
      override protected function doUnload() : void
      {
         if(this._data != null)
         {
            this._data.dispose();
            this._data = null;
         }
      }
      
      override protected function doClose() : void
      {
         switch(loadingState)
         {
            case LOADING_STATE_IMAGE_INFO:
               this.imageInfoLoader.close();
               this.destroyImageInfoLoader();
               break;
            case LOADING_STATE_IMAGE:
               this.imageLoader.close();
               this.destroyImageLoader();
         }
         if(this._data != null)
         {
            this._data.dispose();
            this._data = null;
         }
         this.imageInfoXml = null;
      }
      
      override protected function loadResourceData() : void
      {
         this.imageInfoLoader = new URLLoader();
         this.imageInfoLoader.addEventListener(Event.OPEN,this.onImageInfoLoadingOpen);
         this.imageInfoLoader.addEventListener(ProgressEvent.PROGRESS,this.onImageInfoLoadingProgress);
         this.imageInfoLoader.addEventListener(Event.COMPLETE,this.onImageInfoLoadingComplete);
         this.imageInfoLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onImageInfoLoadingError);
         this.imageInfoLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onImageInfoLoadingError);
         this.imageInfoLoader.load(new URLRequest(url + IMAGE_INFO_XML));
         startTimeoutTimer();
      }
      
      override protected function createDummyData() : Boolean
      {
         this._data = new StubBitmapData(16711680);
         return true;
      }
      
      private function onImageInfoLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_IMAGE_INFO;
      }
      
      private function onImageInfoLoadingProgress(e:ProgressEvent) : void
      {
         updateLastActivityType();
      }
      
      private function onImageInfoLoadingComplete(e:Event) : void
      {
         setIdleLoadingState();
         this.imageInfoXml = XML(this.imageInfoLoader.data);
         this.destroyImageInfoLoader();
         setStatus("Loading diffuse map");
         this.state = LOADING_DIFFUSE;
         this.createImageLoader();
         this.imageLoader.load(new URLRequest(url + IMAGE_FILE),new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain));
         startTimeoutTimer();
      }
      
      private function destroyImageInfoLoader() : void
      {
         this.imageInfoLoader.removeEventListener(Event.OPEN,this.onImageInfoLoadingOpen);
         this.imageInfoLoader.removeEventListener(ProgressEvent.PROGRESS,this.onImageInfoLoadingProgress);
         this.imageInfoLoader.removeEventListener(Event.COMPLETE,this.onImageInfoLoadingComplete);
         this.imageInfoLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onImageInfoLoadingError);
         this.imageInfoLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onImageInfoLoadingError);
      }
      
      private function createImageLoader() : void
      {
         this.imageLoader = new Loader();
         var loaderInfo:LoaderInfo = this.imageLoader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.OPEN,this.onImageLoadingOpen);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onImageLoadingProgress);
         loaderInfo.addEventListener(Event.COMPLETE,this.onImageLoadingComplete);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onImageLoadingError);
      }
      
      private function onImageInfoLoadingError(e:ErrorEvent) : void
      {
         ILogService(Main.osgi.getService(ILogService)).log(LogLevel.LOG_ERROR,"Image resource loading error [id=" + id + "]. Using dummy image.");
         setIdleLoadingState();
         this.destroyImageInfoLoader();
         this.createDummyData();
         completeLoading();
      }
      
      private function onImageLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_IMAGE;
      }
      
      private function onImageLoadingProgress(e:ProgressEvent) : void
      {
         loadingProgress(e.bytesLoaded,e.bytesTotal);
      }
      
      private function onImageLoadingComplete(e:Event) : void
      {
         setIdleLoadingState();
         var bitmapData:BitmapData = Bitmap(this.imageLoader.content).bitmapData;
         this.destroyImageLoader();
         switch(this.state)
         {
            case LOADING_DIFFUSE:
               setStatus("Diffuse map loaded");
               this.processDiffuseData(bitmapData);
               break;
            case LOADING_ALPHA:
               setStatus("Alpha map loaded");
               this.processAlphaData(bitmapData);
         }
      }
      
      private function onImageLoadingError(e:ErrorEvent) : void
      {
         setIdleLoadingState();
         this.destroyImageLoader();
         switch(this.state)
         {
            case LOADING_DIFFUSE:
               this.processDiffuseData(new StubBitmapData(16711680));
               break;
            case LOADING_ALPHA:
               this.processAlphaData(new StubBitmapData(16711680));
         }
      }
      
      private function processDiffuseData(bitmapData:BitmapData) : void
      {
         this._data = bitmapData;
         if(this.imageInfoXml.@alpha != "false")
         {
            this.state = LOADING_ALPHA;
            setStatus("Alpha map loading started");
            this.createImageLoader();
            this.imageLoader.load(new URLRequest(url + ALPHA_FILE),new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain));
            startTimeoutTimer();
         }
         else
         {
            this.completeResourceLoading();
         }
      }
      
      private function processAlphaData(alphaData:BitmapData) : void
      {
         this._data = this.mergeBitmapAlpha(this._data,alphaData,true);
         this.completeResourceLoading();
      }
      
      private function mergeBitmapAlpha(bitmapData:BitmapData, alphaBitmapData:BitmapData, dispose:Boolean = false) : BitmapData
      {
         var res:BitmapData = new BitmapData(bitmapData.width,bitmapData.height);
         var pt:Point = new Point();
         res.copyPixels(bitmapData,bitmapData.rect,pt);
         res.copyChannel(alphaBitmapData,alphaBitmapData.rect,pt,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
         if(dispose)
         {
            bitmapData.dispose();
            alphaBitmapData.dispose();
         }
         return res;
      }
      
      private function completeResourceLoading() : void
      {
         this.imageInfoXml = null;
         completeLoading();
      }
      
      private function destroyImageLoader() : void
      {
         if(this.imageLoader == null)
         {
            return;
         }
         this.imageLoader.unload();
         var loaderInfo:LoaderInfo = this.imageLoader.contentLoaderInfo;
         loaderInfo.removeEventListener(Event.OPEN,this.onImageLoadingOpen);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onImageLoadingProgress);
         loaderInfo.removeEventListener(Event.COMPLETE,this.onImageLoadingComplete);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onImageLoadingError);
         this.imageLoader = null;
      }
   }
}
