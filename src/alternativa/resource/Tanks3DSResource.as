package alternativa.resource
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.loaders.events.LoaderProgressEvent;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.resource.loaders.BatchTextureLoader;
   import alternativa.resource.loaders.TextureInfo;
   import alternativa.resource.loaders.events.BatchTextureLoaderErrorEvent;
   import flash.display.BitmapData;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class Tanks3DSResource extends Resource
   {
      
      public static const TYPE:int = 9;
      
      private static const LOADING_STATE_TEXTURE_INFO:int = LOADING_STATE_INFO + 1;
      
      private static const LOADING_STATE_TEXTURES:int = LOADING_STATE_INFO + 2;
      
      private static const LOADING_STATE_3DS:int = LOADING_STATE_INFO + 3;
      
      private static const IMAGES_FILE:String = "images.xml";
      
      private static const MODEL_FILE:String = "object.3ds";
       
      
      public var textures:Object;
      
      public var objects:Vector.<Object3D>;
      
      private var loader:URLLoader;
      
      private var infoLoader:URLLoader;
      
      private var batchTextureLoader:BatchTextureLoader;
      
      public function Tanks3DSResource()
      {
         super("Танковый ресурс 3DS",false);
      }
      
      public function getTextureForObject(objectIdx:int) : BitmapData
      {
         var mesh:Mesh = this.objects[objectIdx] as Mesh;
         if(mesh == null || mesh.alternativa3d::faceList == null)
         {
            return null;
         }
         var material:TextureMaterial = mesh.alternativa3d::faceList.material as TextureMaterial;
         if(material == null)
         {
            return null;
         }
         return this.textures[material.diffuseMapURL];
      }
      
      public function getObjectsByName(pattern:RegExp) : Vector.<Object3D>
      {
         var object:Object3D = null;
         var res:Vector.<Object3D> = null;
         var len:int = this.objects.length;
         for(var i:int = 0; i < len; i++)
         {
            object = this.objects[i];
            if(object.name != null && object.name.match(pattern) != null)
            {
               if(res == null)
               {
                  res = new Vector.<Object3D>();
               }
               res.push(object);
            }
         }
         return res;
      }
      
      override protected function doClose() : void
      {
         switch(loadingState)
         {
            case LOADING_STATE_TEXTURE_INFO:
               this.infoLoader.close();
               this.destroyInfoLoader();
               break;
            case LOADING_STATE_TEXTURES:
               this.batchTextureLoader.close();
               break;
            case LOADING_STATE_3DS:
               this.loader.close();
         }
         this.textures = null;
         this.batchTextureLoader = null;
         this.loader = null;
      }
      
      override protected function doUnload() : void
      {
         var bitmapData:BitmapData = null;
         if(this.textures != null)
         {
            for each(bitmapData in this.textures)
            {
               bitmapData.dispose();
            }
         }
      }
      
      override protected function loadResourceData() : void
      {
         this.infoLoader = new URLLoader();
         this.infoLoader.addEventListener(Event.OPEN,this.onImagesXMLLoadingOpen);
         this.infoLoader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.infoLoader.addEventListener(Event.COMPLETE,this.onImagesXMLLoadingComplete);
         this.infoLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onFatalError);
         this.infoLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFatalError);
         this.infoLoader.load(new URLRequest(url + IMAGES_FILE));
         startTimeoutTimer();
         setStatus("Loading images info");
      }
      
      private function onImagesXMLLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_TEXTURE_INFO;
      }
      
      private function onImagesXMLLoadingComplete(e:Event) : void
      {
         var textureCount:int = 0;
         var image:XML = null;
         setIdleLoadingState();
         var xml:XML = XML(this.infoLoader.data);
         this.destroyInfoLoader();
         var batch:Object = {};
         for each(image in xml.image)
         {
            textureCount++;
            batch[image.@name] = new TextureInfo(image.attribute("new-name"),image.@alpha);
         }
         if(textureCount > 0)
         {
            this.batchTextureLoader = new BatchTextureLoader();
            this.batchTextureLoader.addEventListener(Event.OPEN,this.onBitmapsLoadingOpen);
            this.batchTextureLoader.addEventListener(Event.COMPLETE,this.onBitmapsLoadingComplete);
            this.batchTextureLoader.addEventListener(LoaderProgressEvent.LOADER_PROGRESS,this.onProgress);
            this.batchTextureLoader.addEventListener(BatchTextureLoaderErrorEvent.LOADER_ERROR,this.onTextureLoadingError);
            this.batchTextureLoader.load(url,batch,null);
            setStatus("Loading images");
            startTimeoutTimer();
         }
         else
         {
            this.loadModel();
         }
      }
      
      private function onBitmapsLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_TEXTURES;
      }
      
      private function onBitmapsLoadingComplete(e:Event) : void
      {
         setIdleLoadingState();
         setStatus("Images loading complete");
         this.textures = this.batchTextureLoader.textures;
         this.destroyBatchLoader();
         this.loadModel();
      }
      
      private function loadModel() : void
      {
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.loader.addEventListener(Event.OPEN,this.on3DSLoadingOpen);
         this.loader.addEventListener(Event.COMPLETE,this.on3DSLoadingComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onFatalError);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFatalError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.load(new URLRequest(url + MODEL_FILE));
         setStatus("Loading model");
         startTimeoutTimer();
      }
      
      private function on3DSLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_3DS;
      }
      
      private function on3DSLoadingComplete(e:Event) : void
      {
         var mesh:Mesh = null;
         setIdleLoadingState();
         setStatus("Model loading complete");
         var parser:Parser3DS = new Parser3DS();
         parser.parse(this.loader.data);
         this.objects = parser.objects;
         this.destroyModelLoader();
         for(var i:int = 0; i < this.objects.length; i++)
         {
            mesh = this.objects[i] as Mesh;
            if(mesh != null)
            {
               this.initMesh(mesh);
            }
         }
         completeLoading();
      }
      
      private function initMesh(mesh:Mesh) : void
      {
         mesh.weldVertices(0.001,0.001);
         mesh.weldFaces(0.01,0.001,0.01);
         mesh.clipping = Clipping.FACE_CLIPPING;
         mesh.sorting = Sorting.AVERAGE_Z;
         mesh.calculateBounds();
      }
      
      private function onFatalError(e:ErrorEvent) : void
      {
         reportFatalError(e.text);
      }
      
      private function onProgress(e:ProgressEvent) : void
      {
         loadingProgress(e.bytesLoaded,e.bytesTotal);
      }
      
      private function onTextureLoadingError(e:ErrorEvent) : void
      {
      }
      
      private function destroyInfoLoader() : void
      {
         if(this.infoLoader == null)
         {
            return;
         }
         this.infoLoader.removeEventListener(Event.OPEN,this.onImagesXMLLoadingOpen);
         this.infoLoader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.infoLoader.removeEventListener(Event.COMPLETE,this.onImagesXMLLoadingComplete);
         this.infoLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onFatalError);
         this.infoLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFatalError);
         this.infoLoader = null;
      }
      
      private function destroyBatchLoader() : void
      {
         if(this.batchTextureLoader == null)
         {
            return;
         }
         this.batchTextureLoader.removeEventListener(Event.OPEN,this.onBitmapsLoadingOpen);
         this.batchTextureLoader.removeEventListener(Event.COMPLETE,this.onBitmapsLoadingComplete);
         this.batchTextureLoader.removeEventListener(LoaderProgressEvent.LOADER_PROGRESS,this.onProgress);
         this.batchTextureLoader.removeEventListener(BatchTextureLoaderErrorEvent.LOADER_ERROR,this.onTextureLoadingError);
         this.batchTextureLoader = null;
      }
      
      private function destroyModelLoader() : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.loader.removeEventListener(Event.OPEN,this.on3DSLoadingOpen);
         this.loader.removeEventListener(Event.COMPLETE,this.on3DSLoadingComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onFatalError);
         this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFatalError);
         this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader = null;
      }
   }
}
