package forms.friends.button.friends
{
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class RequestCountIndicator extends Sprite
   {
      [Embed(source="r/1.png")]
      private static var leftIconClass:Class;
      
      private static var leftIconBitmapData:BitmapData = Bitmap(new leftIconClass()).bitmapData;
      [Embed(source="r/2.png")]
      private static var centerIconClass:Class;
      
      private static var centerIconBitmapData:BitmapData = Bitmap(new centerIconClass()).bitmapData;
      [Embed(source="r/3.png")]
      private static var rightIconClass:Class;
      
      private static var rightIconBitmapData:BitmapData = Bitmap(new rightIconClass()).bitmapData;
       
      
      private var _leftIcon:Bitmap;
      
      private var _centerIcon:Bitmap;
      
      private var _rightIcon:Bitmap;
      
      private var indicatorLabel:LabelBase;
      
      private var _currentCount:int = 0;
      
      private var _newCount:int = 0;
      
      public function RequestCountIndicator()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._leftIcon = new Bitmap(leftIconBitmapData);
         addChild(this._leftIcon);
         this._centerIcon = new Bitmap(centerIconBitmapData);
         addChild(this._centerIcon);
         this._rightIcon = new Bitmap(rightIconBitmapData);
         addChild(this._rightIcon);
         this.indicatorLabel = new LabelBase();
         addChild(this.indicatorLabel);
         this.setRequestCount(this._currentCount,this._newCount);
         this.resize();
      }
      
      public function setRequestCount(param1:int, param2:int) : void
      {
         this._currentCount = param1;
         this._newCount = param2;
         this.visible = param2 != 0;
         this.indicatorLabel.text = String(param2);
         this.resize();
      }
      
      private function resize() : void
      {
         this._rightIcon.x = -5;
         this.indicatorLabel.x = -int(this.indicatorLabel.width) - 1;
         this._centerIcon.width = this.getCenterIconWidth();
         this._centerIcon.x = this._rightIcon.x - this._centerIcon.width;
         this._leftIcon.x = this._centerIcon.x - this._leftIcon.width;
      }
      
      private function getCenterIconWidth() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.indicatorLabel.text.length;
         if(_loc2_ == 1)
         {
            _loc1_ = 1;
         }
         else if(_loc2_ > 1)
         {
            _loc1_ = (_loc2_ - 1) * 6;
         }
         return _loc1_;
      }
      
      public function set currentCount(param1:int) : void
      {
         this.setRequestCount(param1,this._newCount);
      }
      
      public function set newCount(param1:int) : void
      {
         this.setRequestCount(this._currentCount,param1);
      }
   }
}
