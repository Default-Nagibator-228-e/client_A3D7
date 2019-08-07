package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TimeLimitField extends WinkingField
   {
       
      
      private var timer:Timer;
      
      private var targetTime:uint;
      
      private var onlySeconds:Boolean;
      
      public function TimeLimitField(winkLimit:int, iconType:int, winkManager:WinkManager, onlySeconds:Boolean)
      {
         super(winkLimit,iconType,winkManager);
         this.onlySeconds = onlySeconds;
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function initTime(time:int) : void
      {
         this.targetTime = Math.round(getTimer() / 1000 + time);
         value = time;
         if(_value > 0)
         {
            this.timer.stop();
            this.timer.start();
         }
         else
         {
            stopWink();
         }
      }
      
      override protected function updateLabel() : void
      {
         if(this.onlySeconds)
         {
            label.text = _value < 10?"0" + _value.toString():_value.toString();
         }
         else
         {
            label.text = this.getMinutes(_value) + " : " + this.getSeconds(_value);
         }
      }
      
      override protected function onRemovedFromStage(e:Event) : void
      {
         super.onRemovedFromStage(e);
         this.timer.stop();
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         var v:int = 0;
         if(_value > 0)
         {
            v = Math.round(this.targetTime - getTimer() / 1000);
            value = v < 0?int(0):int(v);
         }
         else
         {
            this.timer.stop();
         }
      }
      
      private function getMinutes(seconds:int) : String
      {
         var min:int = seconds / 60;
         return min > 9?min.toString():"0" + min.toString();
      }
      
      private function getSeconds(seconds:int) : String
      {
         var sec:int = seconds % 60;
         return sec > 9?sec.toString():"0" + sec.toString();
      }
   }
}
