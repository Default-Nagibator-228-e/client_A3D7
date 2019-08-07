package alternativa.resource
{
   import alternativa.osgi.service.loader.ILoaderService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.resource.factory.IResourceFactory;
   import alternativa.service.IResourceService;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.types.Long;
   import alternativa.types.LongFactory;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class BatchResourceLoader extends EventDispatcher
   {
       
      
      private var resources:Array;
      
      private var _batchId:int;
      
      private var levelIndex:int;
      
      private var levelResources:Array;
      
      private var resourceIndex:int;
      
      private var resourcesTotalNum:int;
      
      private var resourcesLoadedNum:int;
      
      private var resourceById:Dictionary;
      
      private var resourceRegister:IResourceService;
      
      private var loaderWindowService:ILoaderWindowService;
      
      private var loaderService:ILoaderService;
      
      private var currResource:Resource;
      
      public function BatchResourceLoader(batchId:int, resources:Array)
      {
         super();
         this._batchId = batchId;
         this.resources = resources;
         this.resourceById = new Dictionary();
         this.resourceRegister = null;
      }
      
      public function get batchId() : int
      {
         return this._batchId;
      }
      
      public function load() : void
      {
      }
      
      public function close() : void
      {
         this.currResource.close();
      }
      
      private function loadLevel() : void
      {
         this.levelResources = this.resources[this.levelIndex];
         this.resourceIndex = this.levelResources.length - 1;
         this.loadResource();
      }
      
      private function loadResource() : void
      {
         var resourceFactory:IResourceFactory = null;
         var url:String = null;
         var resourceInfo:ResourceInfo = ResourceInfo(this.levelResources[this.resourceIndex]);
         if(this.resourceRegister.getResource(resourceInfo.id) != null)
         {
            this.log(LogLevel.LOG_ERROR,"An attemt to load an existing resource occurred. Resource id=" + resourceInfo.id);
            this.loaderService.loadingProgress.startProgress(resourceInfo.id);
            this.loaderService.loadingProgress.stopProgress(resourceInfo.id);
            this.onResourceLoaded(null);
         }
         else
         {
            resourceFactory = this.resourceRegister.getResourceFactory(resourceInfo.type);
            if(resourceFactory == null)
            {
               this.onResourceLoadingError(new ErrorEvent(ErrorEvent.ERROR,false,false,"Factory not found. Resource type=" + resourceInfo.type + ", resource id=" + resourceInfo.id));
            }
            this.currResource = resourceFactory.createResource(resourceInfo.type);
            if(this.currResource == null)
            {
               this.onResourceLoadingError(new ErrorEvent(ErrorEvent.ERROR,false,false,"Resource factory has returned null resource. Resource id=" + resourceInfo.id + ", resourceType=" + resourceInfo.type));
            }
            this.currResource.id = resourceInfo.id;
            this.currResource.batchId = this.batchId;
            this.currResource.isOptional = resourceInfo.isOptional;
            this.resourceById[this.currResource.id] = this.currResource;
            url = this.makeResourceUrl(resourceInfo.id,resourceInfo.version);
            if(this.currResource.isOptional)
            {
               this.currResource.url = url;
               this.resourceRegister.registerResource(this.currResource);
               this.loaderService.loadingProgress.startProgress(this.currResource.id);
               this.loaderService.loadingProgress.stopProgress(this.currResource.id);
               this.onResourceLoaded(null);
            }
            else
            {
               this.currResource.addEventListener(Event.COMPLETE,this.onResourceLoaded);
               this.currResource.addEventListener(ErrorEvent.ERROR,this.onResourceLoadingError);
               this.currResource.addEventListener(ProgressEvent.PROGRESS,this.onResourceLoadingProgress);
               this.currResource.load(url);
               this.loaderService.loadingProgress.startProgress(this.currResource.id);
               this.loaderService.loadingProgress.setStatus(this.currResource.id,"Loading resource " + (this.resourcesLoadedNum + 1) + "/" + this.resourcesTotalNum);
            }
         }
      }
      
      private function makeResourceUrl(id:Long, version:Long) : String
      {
         var url:String = null;
         var longId:ByteArray = LongFactory.LongToByteArray(id);
         url = url + ("/" + longId.readUnsignedInt().toString(8));
         url = url + ("/" + longId.readUnsignedShort().toString(8));
         url = url + ("/" + longId.readUnsignedByte().toString(8));
         url = url + ("/" + longId.readUnsignedByte().toString(8));
         url = url + "/";
         var longVersion:ByteArray = LongFactory.LongToByteArray(version);
         var versHigh:int = longVersion.readUnsignedInt();
         var versLow:int = longVersion.readUnsignedInt();
         if(versHigh != 0)
         {
            url = url + versHigh.toString(8);
         }
         url = url + (versLow.toString(8) + "/");
         return url;
      }
      
      private function onResourceLoadingProgress(e:ProgressEvent) : void
      {
         var resource:Resource = Resource(e.target);
         this.loaderService.loadingProgress.setStatus(resource.id,"Loading resource " + (this.resourcesLoadedNum + 1) + "/" + this.resourcesTotalNum + " (" + e.bytesTotal + " bytes)");
         this.loaderService.loadingProgress.setProgress(resource.id,e.bytesLoaded / e.bytesTotal);
      }
      
      private function onResourceLoaded(e:Event) : void
      {
         var resource:Resource = null;
         this.resourcesLoadedNum++;
         if(e != null)
         {
            resource = Resource(e.target);
            resource.removeEventListener(Event.COMPLETE,this.onResourceLoaded);
            resource.removeEventListener(ErrorEvent.ERROR,this.onResourceLoadingError);
            resource.removeEventListener(ProgressEvent.PROGRESS,this.onResourceLoadingProgress);
            this.resourceRegister.registerResource(resource);
            this.loaderService.loadingProgress.stopProgress(resource.id);
         }
         if(this.resourceIndex > 0)
         {
            this.resourceIndex--;
            this.loadResource();
         }
         else if(this.levelIndex > 0)
         {
            this.levelIndex--;
            this.loadLevel();
         }
         else
         {
            this.currResource = null;
            if(hasEventListener(Event.COMPLETE))
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
      }
      
      private function onResourceLoadingError(e:ErrorEvent) : void
      {
         var message:String = null;
         if(hasEventListener(ErrorEvent.ERROR))
         {
            message = "Resource loading error. Batch id=" + this._batchId + ". " + e.text;
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,message));
         }
      }
      
      private function log(logLevel:int, message:String) : void
      {
      }
   }
}
