package alternativa.tanks.models.battlefield 
{
	
   import controls.Label;
   import controls.statassets.BlackRoundRect;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.*;
   
	public class SuicideIndicator extends BlackRoundRect
	{
	
	  [Embed(source="1.png")]
      private static const Sui:Class;
		
	  private var label1:Label;
      
      private var label2:Label;
      
      private var timelLabel:Label;
      
      private var battleLeaveText:String;
      
      private var _seconds:int;
	  
	  private var countDownTimer:Timer;
	  
	  private var timeLimit:int = 0;
	  
	  private var currentTime:int = 0;
	  
	  public var countDown:int = 0;
		
	  private var _timeLimit:int = 0;
		
	  private var setupTime:int;
	  
	  private var dontStartCountDown:Boolean = false;
      
      public function SuicideIndicator(sEnabledText:String)
      {
         super();
         this.battleLeaveText = sEnabledText;
         var topBottomMargin:int = 33;
         var leftRightMargin:int = 33;
         var spacing:int = 5;
         var fontSize:int = 16;
         var icon:Bitmap = new Sui();
         addChild(icon);
         icon.y = topBottomMargin;
         var yy:int = icon.y + icon.height + 2 * spacing;
         this.timelLabel = new Label();
         this.timelLabel.size = fontSize;
         this.timelLabel.autoSize = TextFieldAutoSize.LEFT;
         this.timelLabel.text = sEnabledText + " 99:99";
         this.timelLabel.y = yy;
         addChild(this.timelLabel);
         if(width < this.timelLabel.textWidth)
         {
            width = this.timelLabel.textWidth;
         }
         width += 2 * leftRightMargin;
         icon.x = width - icon.width >> 1;
         height = yy + this.timelLabel.height + topBottomMargin - 5;
      }
	  
	  public function get wi() : int
      {
         return _width;
      }
	  
	  public function get he() : int
      {
         return _height;
      }
      
      public function set seconds(value:int) : void
      {
		 timeLimit = value/1000;
		 if(timeLimit > 0)
		 {
			 this.showCountDown();
		 }
      }
	  
	  private function showCountDown() : void
		  {
			 this.countDownTimer = new Timer(1000);
			 this.countDownTimer.addEventListener(TimerEvent.TIMER,this.showCountDownTick);
			 this.countDownTimer.start();
			 this.showCountDownTick();
		  }
		  
		private function showCountDownTick(e:TimerEvent = null) : void
		  {
			 var str:String = "";
			 timeLimit--;
			 str += timeLimit > 9?timeLimit:"0" + timeLimit;
			 this.timelLabel.text = battleLeaveText + "00:"+str;
			 this.timelLabel.x = width - this.timelLabel.width >> 1;
			 if(this.timeLimit == 0)
			 {
				this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
				this.countDownTimer.stop();
			 }
			 dispatchEvent(new Event(Event.CHANGE));
		  }
		
	}

}