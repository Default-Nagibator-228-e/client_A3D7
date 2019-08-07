package forms.progr
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	public class CProg extends Sprite
	{
	  [Embed(source="d/30.png")]
      private static const bgdLeftClass:Class;
      [Embed(source="d/31.png")]
      private static const bgdRightClass:Class;
      [Embed(source="d/32.png")]
      private static const bgdCenterClass:Class;
      
      private static const bgdCenterBitmapData:BitmapData = new bgdCenterClass().bitmapData;
      [Embed(source="d/33.png")]
      private static const blickClass:Class;
      
      private static const blickBitmapData:BitmapData = new blickClass().bitmapData;
      [Embed(source="d/34.png")]
      private static const progressLineClass:Class;
      
      private static const DEFAULT_WIDTH:int = 585;
      
      private static const MAX_PROGRESS_LINE_WIDTH:int = 581;
      
      private static const DEFAULT_HEIGHT:int = 30;
      
      private static const FAKE_RIGHT_BORDER_IN_PERCENT:Number = 0.98;
      
      private static const MIN_STEP:Number = 0.05;
      
      private static const STEP_DEC:Number = 0.001;
      
      private static const COMPLETE_DELAY:int = 100;
       
      
      private var _progressLineWidth:Number;
      
      private var _fakeRightLimitProgressLineWidth:int;
      
      private var _progressLine:Bitmap;
      
      private var _progressLineBlick:Shape;
      
      private var _bgdLeftIcon:Bitmap;
      
      private var _bgdRightIcon:Bitmap;
      
      private var _bgdCenterIcon:Shape;
      
      private var _blickMatrix:Matrix;
      
      private var _timeOutComplete:uint;
      
      private var _isForciblyFinish:Boolean;
      
      private var _normalStep:Number = 0.05;
      
      private var _forciblyStep:Number;
      
      private var frameTime:int;
      
      public function CProg()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._fakeRightLimitProgressLineWidth = MAX_PROGRESS_LINE_WIDTH * FAKE_RIGHT_BORDER_IN_PERCENT;
         this._bgdLeftIcon = new bgdLeftClass();
         addChild(this._bgdLeftIcon);
         this._bgdRightIcon = new bgdRightClass();
         addChild(this._bgdRightIcon);
         this._bgdCenterIcon = new Shape();
         addChild(this._bgdCenterIcon);
         this._progressLine = new progressLineClass();
         this._progressLine.x = 2;
         this._progressLine.y = 2;
         this._progressLine.width = 0;
         this._progressLine.blendMode = BlendMode.OVERLAY;
         addChild(this._progressLine);
         this._progressLineBlick = new Shape();
         this._progressLineBlick.x = this._progressLine.x;
         this._progressLineBlick.y = this._progressLine.y;
         this._progressLineBlick.blendMode = BlendMode.ADD;
         this._progressLineBlick.alpha = 0.5;
         addChild(this._progressLineBlick);
         this.resize();
      }
      
      private function resize() : void
      {
         this._bgdCenterIcon.graphics.clear();
         this._bgdCenterIcon.graphics.beginBitmapFill(bgdCenterBitmapData);
         this._bgdCenterIcon.graphics.drawRect(0,0,DEFAULT_WIDTH - this._bgdLeftIcon.width - this._bgdRightIcon.width,DEFAULT_HEIGHT);
         this._bgdCenterIcon.graphics.endFill();
         this._bgdCenterIcon.x = this._bgdLeftIcon.width;
         this._bgdRightIcon.x = this._bgdCenterIcon.x + this._bgdCenterIcon.width;
      }
      
      public function start() : void
      {
         clearTimeout(this._timeOutComplete);
         this._isForciblyFinish = false;
         this._progressLine.width = 0;
         this._progressLineBlick.graphics.clear();
         this._progressLineWidth = 0;
         this._blickMatrix = new Matrix();
         this._normalStep = 1;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrameew);
      }
      
      private function onEnterFrameew(param1:Event) : void
      {
         if(getTimer() - this.frameTime < 5)
         {
            return;
         }
         this.frameTime = getTimer();
         if(this._isForciblyFinish)
         {
            this._progressLineWidth = this._progressLineWidth + this._forciblyStep;
            if(this._progressLineWidth >= MAX_PROGRESS_LINE_WIDTH)
            {
               removeEventListener(Event.ENTER_FRAME,this.onEnterFrameew);
               this._progressLineWidth = MAX_PROGRESS_LINE_WIDTH;
               this._timeOutComplete = setTimeout(this.onCompleted,COMPLETE_DELAY);
            }
         }
         else
         {
            this._normalStep = this._normalStep - STEP_DEC;
            if(this._normalStep < MIN_STEP)
            {
               this._normalStep = MIN_STEP;
            }
            this._progressLineWidth = this._progressLineWidth + this._normalStep;
            if(this._progressLineWidth >= this._fakeRightLimitProgressLineWidth)
            {
               this._progressLineWidth = this._fakeRightLimitProgressLineWidth;
            }
         }
         this.redrawProgressLineAndBlick(this._progressLineWidth);
         this._blickMatrix.tx = this._blickMatrix.tx + 3;
         if(this._blickMatrix.tx > blickBitmapData.width)
         {
            this._blickMatrix.tx = -this._blickMatrix.tx % blickBitmapData.width;
         }
      }
      
      public function forciblyFinish() : void
      {
         this._forciblyStep = (MAX_PROGRESS_LINE_WIDTH - this._progressLineWidth) / 10;
         this._isForciblyFinish = true;
      }
      
      private function onCompleted() : void
      {

      }
      
      public function redrawProgressLineAndBlick(param1:int) : void
      {
		 if (param1 >= MAX_PROGRESS_LINE_WIDTH)
		 {
			 param1 = MAX_PROGRESS_LINE_WIDTH;
		 }
         this._progressLine.width = param1;
         this._progressLineBlick.graphics.clear();
         this._progressLineBlick.graphics.beginBitmapFill(blickBitmapData,this._blickMatrix,true,false);
         this._progressLineBlick.graphics.drawRect(0,0,param1,this._progressLine.height);
         this._progressLineBlick.graphics.endFill();
      }
      
      public function forciblyStop() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrameew);
         clearTimeout(this._timeOutComplete);
      }
   }
}