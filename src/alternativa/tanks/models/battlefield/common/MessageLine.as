package alternativa.tanks.models.battlefield.common
{
   import alternativa.tanks.models.battlefield.event.ChatOutputLineEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class MessageLine extends Sprite
   {
      
      private static const LIFE_TIME:int = 30000;
       
      
      protected var _live:Boolean = true;
      
      private var glowFilter:GlowFilter;
      
      private var fltrs:Array;
      
      private var killTimer:Timer;
      
      private var stop:Boolean = false;
      
      private var runOut:Boolean = false;
      
      public function MessageLine()
      {
         this.glowFilter = new GlowFilter(0,0.8,4,4,3);
         this.fltrs = [this.glowFilter];
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         filters = this.fltrs;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function killStop() : void
      {
         alpha = 1;
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.stop = true;
      }
      
      public function killStart() : void
      {
         this.stop = false;
         if(this.runOut)
         {
            this.killSelf();
         }
      }
      
      public function get live() : Boolean
      {
         return this._live;
      }
      
      private function onAddedToStage(e:Event) : void
      {
         setTimeout(this.timeRunOut,LIFE_TIME);
      }
      
      private function timeRunOut() : void
      {
         this.runOut = true;
         if(!this.stop)
         {
            this.killSelf();
         }
      }
      
      private function killSelf() : void
      {
         this.killTimer = new Timer(50,20);
         this.killTimer.addEventListener(TimerEvent.TIMER,this.onKillTimer);
         this.killTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onKillComplete);
         this.killTimer.start();
      }
      
      private function onKillTimer(e:TimerEvent) : void
      {
         if(!this.stop)
         {
            alpha = alpha - 0.05;
         }
         else
         {
            this.killTimer.stop();
            alpha = 1;
         }
      }
      
      private function onKillComplete(e:TimerEvent) : void
      {
         this._live = false;
         dispatchEvent(new ChatOutputLineEvent(ChatOutputLineEvent.KILL_ME,this));
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.glowFilter.strength = 3;
         filters = this.fltrs;
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.glowFilter.strength = 5;
         filters = this.fltrs;
      }
   }
}
