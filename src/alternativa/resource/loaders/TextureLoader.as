package alternativa.resource.loaders
{
   import alternativa.engine3d.loaders.events.LoaderEvent;
   import alternativa.engine3d.loaders.events.LoaderProgressEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   [Event(name="loaderProgress",type="alternativa.engine3d.loaders.events.LoaderProgressEvent")]
   [Event(name="partComplete",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   [Event(name="partOpen",type="alternativa.engine3d.loaders.events.LoaderEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="open",type="flash.events.Event")]
   public class TextureLoader extends EventDispatcher
   {
      
      private static const IDLE:int = -1;
      
      private static const LOADING_DIFFUSE_MAP:int = 0;
      
      private static const LOADING_ALPHA_MAP:int = 1;
       
      
      private var state:int = -1;
      
      private var bitmapLoader:Loader;
      
      private var loaderContext:LoaderContext;
      
      private var alphaTextureUrl:String;
      
      private var _bitmapData:BitmapData;
      
      public function TextureLoader()
      {
         super();
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function load(diffuseTextureUrl:String, alphaTextureUrl:String = null, loaderContext:LoaderContext = null) : void
      {
         this.unload();
         this.alphaTextureUrl = alphaTextureUrl == ""?null:alphaTextureUrl;
         this.loaderContext = loaderContext;
         this.loadPart(LOADING_DIFFUSE_MAP,diffuseTextureUrl);
      }
      
      public function close() : void
      {
         if(this.state == IDLE)
         {
            return;
         }
         this.state = IDLE;
         this.bitmapLoader.unload();
         this.destroyLoader();
         this.alphaTextureUrl = null;
         this.loaderContext = null;
      }
      
      public function unload() : void
      {
         this.close();
         this._bitmapData = null;
      }
      
      private function cleanup() : void
      {
         this.destroyLoader();
         this.alphaTextureUrl = null;
         this.loaderContext = null;
      }
      
      private function loadPart(state:int, url:String) : void
      {
         this.state = state;
         this.createLoader();
         this.bitmapLoader.load(new URLRequest(url),this.loaderContext);
      }
      
      private function onPartLoadingOpen(e:Event) : void
      {
         if(this._bitmapData == null && hasEventListener(Event.OPEN))
         {
            dispatchEvent(new Event(Event.OPEN));
         }
         if(hasEventListener(LoaderEvent.PART_OPEN))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.PART_OPEN,2,this.state == LOADING_DIFFUSE_MAP?int(0):int(1)));
         }
      }
      
      private function onPartLoadingProgress(e:ProgressEvent) : void
      {
         var partNumber:int = 0;
         var totalProgress:Number = NaN;
         if(hasEventListener(LoaderProgressEvent.LOADER_PROGRESS))
         {
            partNumber = this.state == LOADING_DIFFUSE_MAP?int(0):int(1);
            totalProgress = 0.5 * (partNumber + e.bytesLoaded / e.bytesTotal);
            dispatchEvent(new LoaderProgressEvent(LoaderProgressEvent.LOADER_PROGRESS,2,partNumber,totalProgress,e.bytesLoaded,e.bytesTotal));
         }
      }
      
      private function onPartLoadingComplete(e:Event) : void
      {
         var pt:Point = null;
         var tmpBmd:BitmapData = null;
         var alpha:BitmapData = null;
         switch(this.state)
         {
            case LOADING_DIFFUSE_MAP:
               this._bitmapData = Bitmap(this.bitmapLoader.content).bitmapData;
               this.destroyLoader();
               this.dispatchPartComplete(0);
               if(this.alphaTextureUrl != null)
               {
                  this.loadPart(LOADING_ALPHA_MAP,this.alphaTextureUrl);
               }
               else
               {
                  this.complete();
               }
               break;
            case LOADING_ALPHA_MAP:
               pt = new Point();
               tmpBmd = this._bitmapData;
               this._bitmapData = new BitmapData(this._bitmapData.width,this._bitmapData.height);
               this._bitmapData.copyPixels(tmpBmd,tmpBmd.rect,pt);
               alpha = Bitmap(this.bitmapLoader.content).bitmapData;
               this.destroyLoader();
               if(this._bitmapData.width != alpha.width || this._bitmapData.height != alpha.height)
               {
                  tmpBmd.draw(alpha,new Matrix(this._bitmapData.width / alpha.width,0,0,this._bitmapData.height / alpha.height),null,BlendMode.NORMAL,null,true);
                  alpha.dispose();
                  alpha = tmpBmd;
               }
               else
               {
                  tmpBmd.dispose();
               }
               this._bitmapData.copyChannel(alpha,alpha.rect,pt,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
               alpha.dispose();
               this.dispatchPartComplete(1);
               this.complete();
         }
      }
      
      private function dispatchPartComplete(partNumber:int) : void
      {
         if(hasEventListener(LoaderEvent.PART_COMPLETE))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.PART_COMPLETE,2,partNumber));
         }
      }
      
      private function onLoadError(e:Event) : void
      {
         this.state = IDLE;
         this.cleanup();
         dispatchEvent(e);
      }
      
      private function complete() : void
      {
         this.state = IDLE;
         this.cleanup();
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function createLoader() : void
      {
         this.bitmapLoader = new Loader();
         var loaderInfo:LoaderInfo = this.bitmapLoader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.OPEN,this.onPartLoadingOpen);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onPartLoadingProgress);
         loaderInfo.addEventListener(Event.COMPLETE,this.onPartLoadingComplete);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function destroyLoader() : void
      {
         if(this.bitmapLoader == null)
         {
            return;
         }
         this.bitmapLoader.unload();
         var loaderInfo:LoaderInfo = this.bitmapLoader.contentLoaderInfo;
         loaderInfo.removeEventListener(Event.OPEN,this.onPartLoadingOpen);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onPartLoadingProgress);
         loaderInfo.removeEventListener(Event.COMPLETE,this.onPartLoadingComplete);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.bitmapLoader = null;
      }
   }
}
