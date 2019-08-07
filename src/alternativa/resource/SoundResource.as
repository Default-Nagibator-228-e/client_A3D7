package alternativa.resource
{
   import alternativa.init.Main;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SampleDataEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   
   public class SoundResource extends Resource
   {
      
      private static const LOADING_STATE_SOUND:int = LOADING_STATE_INFO + 1;
       
      
      private var _sound:Sound;
      
      public function SoundResource()
      {
         super("Звук");
      }
      
      public function get sound() : Sound
      {
         return this._sound;
      }
      
      override protected function doUnload() : void
      {
         this._sound = null;
      }
      
      override protected function doClose() : void
      {
         if(loadingState == LOADING_STATE_SOUND)
         {
            this._sound.close();
         }
      }
      
      override protected function loadResourceData() : void
      {
         this._sound = new Sound();
         this._sound.addEventListener(Event.OPEN,this.onLoadingOpen);
         this._sound.addEventListener(ProgressEvent.PROGRESS,this.onLoadingProgress);
         this._sound.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError);
         this._sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadingError);
         this._sound.load(new URLRequest(url + "sound.mp3"),new SoundLoaderContext());
         startTimeoutTimer();
      }
      
      override protected function createDummyData() : Boolean
      {
         this._sound = new Sound();
         this._sound.addEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
         return true;
      }
      
      private function onSampleData(event:SampleDataEvent) : void
      {
      }
      
      private function onLoadingOpen(event:Event) : void
      {
         loadingState = LOADING_STATE_SOUND;
      }
      
      private function onLoadingProgress(e:ProgressEvent) : void
      {
         loadingProgress(e.bytesLoaded,e.bytesTotal);
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         setIdleLoadingState();
         completeLoading();
      }
      
      private function onLoadingError(e:ErrorEvent) : void
      {
         ILogService(Main.osgi.getService(ILogService)).log(LogLevel.LOG_ERROR,e.text);
         this.createDummyData();
         completeLoading();
         setStatus("Dummy sound is used");
      }
   }
}
