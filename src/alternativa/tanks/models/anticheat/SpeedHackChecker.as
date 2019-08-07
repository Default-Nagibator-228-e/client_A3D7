package alternativa.tanks.models.anticheat
{
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class SpeedHackChecker
   {
       
      
      private const checkInterval:int = 5000;
      
      private const threshold:int = 300;
      
      private const maxErrors:int = 3;
      
      private var errorCounter:int = 0;
      
      private var battleEventDispatcher:BattlefieldModel;
      
      private var timer:Timer;
      
      private var localTime:int;
      
      private var systemTime:Number;
      
      private var deltas:Array;
      
      public function SpeedHackChecker(param1:BattlefieldModel)
      {
         super();
         this.deltas = [];
         this.battleEventDispatcher = param1;
         this.localTime = getTimer();
         this.systemTime = new Date().time;
         this.timer = new Timer(this.checkInterval);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      public function stop() : void
      {
         this.timer.stop();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _timer:int = getTimer();
         var _systemTime:Number = new Date().time;
         var delta:Number = _timer - this.localTime - _systemTime + this.systemTime;
         if(Math.abs(delta) > this.threshold)
         {
            this.deltas.push(delta);
            this.errorCounter = this.errorCounter + 1;
            if(this.errorCounter >= this.maxErrors)
            {
               this.stop();
               this.battleEventDispatcher.cheatDetected();
            }
         }
         else
         {
            this.errorCounter = 0;
            this.deltas.length = 0;
         }
         this.localTime = _timer;
         this.systemTime = _systemTime;
      }
   }
}
