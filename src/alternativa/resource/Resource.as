package alternativa.resource
{
   import alternativa.init.Main;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.types.Long;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class Resource extends EventDispatcher implements IResource
   {
      
      public static const LOADING_STATE_IDLE:int = 0;
      
      public static const LOADING_STATE_INFO:int = 1;
      
      private static const INFO_XML:String = "info.xml";
      
      private static const LOADING_TIMEOUT:int = 10000;
      
      private static const MAX_RELOAD_ATTEMPTS:int = 3;
       
      
      public var batchId:int;
      
      public var isOptional:Boolean;
      
      public var loaded:Boolean;
      
      public var url:String;
      
      protected var _name:String;
      
      protected var locale_postfix:String;
      
      protected var loadingState:int;
      
      private var _id:Long;
      
      private var _version:int;
      
      private var _typeName:String;
      
      private var infoLoader:URLLoader;
      
      private var timer:Timer;
      
      private var lastActivityTime:int;
      
      private var reloadAttemptCount:int;
      
      public function Resource(typeName:String, isOptional:Boolean = false)
      {
         super();
         this._typeName = typeName;
         this.isOptional = isOptional;
         this.timer = new Timer(LOADING_TIMEOUT >> 1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function get name() : String
      {
         return this._typeName + (this._name == null?"":" " + this._name);
      }
      
      public function get id() : Long
      {
         return this._id;
      }
      
      public function set id(value:Long) : void
      {
         this._id = value;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function set version(value:int) : void
      {
         this._version = value;
      }
      
      public final function load(url:String) : void
      {
         if(this.loaded)
         {
            return;
         }
         this.url = url;
         this.loadingState = LOADING_STATE_IDLE;
         this.infoLoader = new URLLoader();
         this.infoLoader.addEventListener(Event.OPEN,this.onInfoLoadingOpen);
         this.infoLoader.addEventListener(ProgressEvent.PROGRESS,this.onInfoLoadingProgress);
         this.infoLoader.addEventListener(Event.COMPLETE,this.onInfoLoadingComplete);
         this.infoLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onInfoLoadingError);
         this.infoLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onInfoLoadingError);
         this.infoLoader.load(new URLRequest(url + INFO_XML));
         this.setStatus(ResourceStatus.INFO_REQUESTED);
      }
      
      public final function unload() : void
      {
         this.doUnload();
         this.loaded = false;
      }
      
      public final function close() : void
      {
         this._name = null;
         if(this.loadingState == LOADING_STATE_INFO)
         {
            this.infoLoader.close();
            this.destroyInfoLoader();
         }
         else
         {
            this.doClose();
         }
         this.setIdleLoadingState();
      }
      
      protected function doUnload() : void
      {
      }
      
      protected function doClose() : void
      {
      }
      
      protected function loadResourceData() : void
      {
      }
      
      protected final function loadingProgress(bytesLoaded:int, bytesTotal:int) : void
      {
         this.lastActivityTime = getTimer();
         if(hasEventListener("progress"))
         {
            dispatchEvent(new ProgressEvent("progress",false,false,bytesLoaded,bytesTotal));
         }
      }
      
      protected final function completeLoading() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         this.loadingState = LOADING_STATE_IDLE;
         this.loaded = true;
         this.setStatus(ResourceStatus.LOADED);
         if(hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected final function reportFatalError(message:String) : void
      {
         this.setIdleLoadingState();
         message = "Resource type=" + this._typeName + ", id=" + this._id + ". " + message;
         this.setStatus(ResourceStatus.LOAD_ERROR + " " + message);
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,message));
      }
      
      protected function setStatus(status:String) : void
      {
      }
      
      protected function startTimeoutTimer() : void
      {
         this.timer.start();
         this.lastActivityTime = getTimer();
      }
      
      protected function stopTimeoutTimer() : void
      {
         this.timer.stop();
         this.lastActivityTime = getTimer();
      }
      
      protected function updateLastActivityType() : void
      {
         this.lastActivityTime = getTimer();
      }
      
      protected function createDummyData() : Boolean
      {
         return false;
      }
      
      protected function setIdleLoadingState() : void
      {
         this.loadingState = LOADING_STATE_IDLE;
         this.stopTimeoutTimer();
      }
      
      private function destroyInfoLoader() : void
      {
         this.infoLoader.removeEventListener(Event.OPEN,this.onInfoLoadingOpen);
         this.infoLoader.removeEventListener(ProgressEvent.PROGRESS,this.onInfoLoadingProgress);
         this.infoLoader.removeEventListener(Event.COMPLETE,this.onInfoLoadingComplete);
         this.infoLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoLoadingError);
         this.infoLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onInfoLoadingError);
         this.infoLoader = null;
      }
      
      private function onInfoLoadingOpen(event:Event) : void
      {
         this.loadingState = LOADING_STATE_INFO;
         this.setStatus("Info XML loading started");
      }
      
      private function onInfoLoadingProgress(e:ProgressEvent) : void
      {
         this.lastActivityTime = getTimer();
      }
      
      private function onInfoLoadingComplete(e:Event) : void
      {
         this.setIdleLoadingState();
         var infoXml:XML = XML(this.infoLoader.data);
         this.destroyInfoLoader();
         this._name = infoXml.@name;
         var localeList:XMLList = infoXml.locales.locale;
         if(localeList.length() > 0)
         {
         }
         this.setStatus(ResourceStatus.REQUESTED);
         this.loadResourceData();
      }
      
      private function onInfoLoadingError(e:ErrorEvent) : void
      {
         this.destroyInfoLoader();
         this.reportFatalError(e.text);
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         if(getTimer() - this.lastActivityTime < LOADING_TIMEOUT)
         {
            return;
         }
         this.timer.stop();
         var logService:ILogService = ILogService(Main.osgi.getService(ILogService));
         logService.log(LogLevel.LOG_WARNING,"Resource loading timed out. Resource id=" + this._id);
         this.close();
         if(this.reloadAttemptCount < MAX_RELOAD_ATTEMPTS)
         {
            logService.log(LogLevel.LOG_WARNING,"Trying to reload resource [id=" + this._id + "] (attempt " + this.reloadAttemptCount + "/" + MAX_RELOAD_ATTEMPTS + ").");
            this.reloadAttemptCount++;
            this.load(this.url);
         }
         else if(this.createDummyData())
         {
            this.completeLoading();
            this.setStatus("Dummy data is used");
         }
         else
         {
            this.reportFatalError("Unable to load resource [id=" + this._id + ", type=" + this._typeName + "]");
         }
      }
   }
}
