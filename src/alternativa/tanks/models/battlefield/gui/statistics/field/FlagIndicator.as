package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class FlagIndicator extends Sprite
   {
      
      public static const STATE_AT_BASE:int = 1;
      
      public static const STATE_CARRIED:int = 2;
      
      public static const STATE_DROPPED:int = 3;
      
      public static const STATE_FLASHING:int = 4;
       
      
      public var normalBitmap:Bitmap;
      
      public var lostBitmap:Bitmap;
      
      public var flashBitmap:Bitmap;
      
      private var states:Dictionary;
      
      private var currentState:IFlagIndicatorState;
      
      public function FlagIndicator(normalBitmap:Bitmap, lostBitmap:Bitmap, flashBitmap:Bitmap, ctfBlinker:CTFScoreIndicatorBlinker)
      {
         this.states = new Dictionary();
         super();
         this.normalBitmap = normalBitmap;
         this.lostBitmap = lostBitmap;
         this.flashBitmap = flashBitmap;
         addChild(normalBitmap);
         addChild(lostBitmap);
         addChild(flashBitmap);
         this.states[STATE_AT_BASE] = new StateAtBase(STATE_AT_BASE,this);
         this.states[STATE_FLASHING] = new StateFlash(STATE_FLASHING,this,10 / 1000,1 / 1000,300);
         this.states[STATE_CARRIED] = new StateLost(STATE_CARRIED,this,ctfBlinker,0);
         this.states[STATE_DROPPED] = new StateLost(STATE_DROPPED,this,ctfBlinker,1);
         this.currentState = this.states[STATE_AT_BASE];
         this.currentState.start();
      }
      
      public function setState(state:int) : void
      {
         if(this.currentState.getType() == state)
         {
            return;
         }
         this.currentState.stop();
         this.currentState = this.states[state];
         this.currentState.start();
      }
      
      public function update(now:int, delta:int) : void
      {
         this.currentState.update(now,delta);
      }
   }
}

interface IFlagIndicatorState
{
    
   
   function getType() : int;
   
   function start() : void;
   
   function stop() : void;
   
   function update(param1:int, param2:int) : void;
}

import alternativa.tanks.models.battlefield.gui.statistics.field.FlagIndicator;

class StateAtBase implements IFlagIndicatorState
{
    
   
   private var type:int;
   
   private var indicator:FlagIndicator;
   
   function StateAtBase(type:int, indicator:FlagIndicator)
   {
      super();
      this.type = type;
      this.indicator = indicator;
   }
   
   public function getType() : int
   {
      return this.type;
   }
   
   public function start() : void
   {
      this.indicator.normalBitmap.visible = true;
      this.indicator.normalBitmap.alpha = 1;
      this.indicator.flashBitmap.visible = false;
      this.indicator.lostBitmap.visible = false;
   }
   
   public function stop() : void
   {
   }
   
   public function update(now:int, delta:int) : void
   {
   }
}

import alternativa.tanks.models.battlefield.gui.statistics.field.FlagIndicator;

class StateFlash implements IFlagIndicatorState
{
   
   private static const STATE_FADE_IN:int = 1;
   
   private static const STATE_WAIT:int = 2;
   
   private static const STATE_FADE_OUT:int = 3;
    
   
   private var type:int;
   
   private var indicator:FlagIndicator;
   
   private var waitTime:int;
   
   private var time:int;
   
   private var fadeInSpeed:Number = 0.01;
   
   private var fadeOutSpeed:Number = 0.001;
   
   private var state:int;
   
   function StateFlash(type:int, indicator:FlagIndicator, fadeInSpeed:Number, fadeOutSpeed:Number, waitTime:int)
   {
      super();
      this.type = type;
      this.indicator = indicator;
      this.fadeInSpeed = fadeInSpeed;
      this.fadeOutSpeed = fadeOutSpeed;
      this.waitTime = waitTime;
   }
   
   public function getType() : int
   {
      return this.type;
   }
   
   public function start() : void
   {
      this.indicator.normalBitmap.visible = true;
      this.indicator.normalBitmap.alpha = 1;
      this.indicator.lostBitmap.visible = false;
      this.indicator.flashBitmap.visible = true;
      this.indicator.flashBitmap.alpha = 0;
      this.state = STATE_FADE_IN;
   }
   
   public function stop() : void
   {
   }
   
   public function update(now:int, delta:int) : void
   {
      var alpha:Number = this.indicator.normalBitmap.alpha;
      switch(this.state)
      {
         case STATE_FADE_IN:
            alpha = alpha - this.fadeInSpeed * delta;
            if(alpha <= 0)
            {
               alpha = 0;
               this.state = STATE_WAIT;
               this.time = this.waitTime;
            }
            break;
         case STATE_WAIT:
            this.time = this.time - delta;
            if(this.time <= 0)
            {
               this.state = STATE_FADE_OUT;
            }
            break;
         case STATE_FADE_OUT:
            alpha = alpha + this.fadeOutSpeed * delta;
            if(alpha >= 1)
            {
               this.indicator.setState(1); //была это переменная STATE_AT_BASE
            }
      }
      this.indicator.normalBitmap.alpha = alpha;
      this.indicator.flashBitmap.alpha = 1 - alpha;
   }
}

import alternativa.tanks.models.battlefield.gui.statistics.field.CTFScoreIndicatorBlinker;
import alternativa.tanks.models.battlefield.gui.statistics.field.FlagIndicator;
import flash.utils.getTimer;

class StateLost implements IFlagIndicatorState
{
    
   
   private var type:int;
   
   private var indicator:FlagIndicator;
   
   private var blinker:CTFScoreIndicatorBlinker;
   
   private var valueIndex:int;
   
   function StateLost(type:int, indicator:FlagIndicator, blinker:CTFScoreIndicatorBlinker, valueIndex:int)
   {
      super();
      this.type = type;
      this.indicator = indicator;
      this.blinker = blinker;
      this.valueIndex = valueIndex;
   }
   
   public function getType() : int
   {
      return this.type;
   }
   
   public function start() : void
   {
      this.blinker.start(getTimer());
      this.indicator.normalBitmap.visible = true;
      this.indicator.normalBitmap.alpha = 1;
      this.indicator.flashBitmap.visible = false;
      this.indicator.lostBitmap.visible = true;
      this.indicator.lostBitmap.alpha = 0;
   }
   
   public function stop() : void
   {
      this.blinker.stop();
   }
   
   public function update(now:int, delta:int) : void
   {
      var value:Number = this.blinker.values[this.valueIndex];
      this.indicator.normalBitmap.alpha = value;
      this.indicator.lostBitmap.alpha = 1 - value;
   }
}
