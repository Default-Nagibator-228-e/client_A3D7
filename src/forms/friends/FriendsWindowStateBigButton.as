package forms.friends
{
   import forms.friends.button.friends.RequestCountIndicator;
   import controls.base.ColorButtonBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class FriendsWindowStateBigButton extends ColorButtonBase implements FriendsWindowButtonType
   {
      [Embed(source="fb/1.png")]
      private static const ButtonCenter:Class;
      [Embed(source="fb/2.png")]
      private static const ButtonLeft:Class;
      [Embed(source="fb/3.png")]
      private static const ButtonRight:Class;
      [Embed(source="fb/4.png")]
      private static const ButtonOverCenter:Class;
      [Embed(source="fb/5.png")]
      private static const ButtonOverLeft:Class;
      [Embed(source="fb/6.png")]
      private static const ButtonOverRight:Class;
      [Embed(source="fb/7.png")]
      private static const ButtonDownCenter:Class;
      [Embed(source="fb/8.png")]
      private static const ButtonDownLeft:Class;
      [Embed(source="fb/9.png")]
      private static const ButtonDownRight:Class;
      [Embed(source="fb/10.png")]
      private static const friendsClass:Class;
      
      private static const friendsBitmapData:BitmapData = Bitmap(new friendsClass()).bitmapData;
      
      private static const ICON_X:int = 6;
      
      private static const ICON_Y:int = 5;
       
      
      public var type:FriendsWindowState;
      
      private var requestCounter:RequestCountIndicator;
      
      private var icon:Bitmap;
      
      public function FriendsWindowStateBigButton(param1:FriendsWindowState)
      {
         this.requestCounter = new RequestCountIndicator();
         this.icon = new Bitmap();
         super();
         this.type = param1;
         this.icon.bitmapData = this.getButtonIcon();
         this.icon.x = ICON_X;
         this.icon.y = ICON_Y;
         addChild(this.icon);
         _label.align = TextFormatAlign.LEFT;
         _label.autoSize = TextFieldAutoSize.LEFT;
         _label.x = ICON_X + this.icon.width + 5;
         this.setStyle();
         addChild(this.requestCounter);
         this.requestCounter.y = -6;
      }
      
      public function set text(param1:String) : void
      {
         _label.text = param1;
      }
      
      private function getButtonIcon() : BitmapData
      {
         switch(this.type)
         {
            case FriendsWindowState.ACCEPTED:
               return friendsBitmapData;
            default:
               return friendsBitmapData;
         }
      }
      
      override public function setStyle(param1:String = "def") : void
      {
         stateUP.bmpLeft = new ButtonLeft().bitmapData;
         stateUP.bmpCenter = new ButtonCenter().bitmapData;
         stateUP.bmpRight = new ButtonRight().bitmapData;
         stateOVER.bmpLeft = new ButtonOverLeft().bitmapData;
         stateOVER.bmpCenter = new ButtonOverCenter().bitmapData;
         stateOVER.bmpRight = new ButtonOverRight().bitmapData;
         stateDOWN.bmpLeft = new ButtonDownLeft().bitmapData;
         stateDOWN.bmpCenter = new ButtonDownCenter().bitmapData;
         stateDOWN.bmpRight = new ButtonDownRight().bitmapData;
         stateOFF.bmpLeft = new ButtonDownLeft().bitmapData;
         stateOFF.bmpCenter = new ButtonDownCenter().bitmapData;
         stateOFF.bmpRight = new ButtonDownRight().bitmapData;
      }
      
      override protected function onMouseEvent(param1:MouseEvent) : void
      {
         if(enable)
         {
            switch(param1.type)
            {
               case MouseEvent.MOUSE_OVER:
                  this.setState(2);
                  break;
               case MouseEvent.MOUSE_OUT:
                  this.setState(1);
                  break;
               case MouseEvent.MOUSE_DOWN:
                  this.setState(3);
                  break;
               case MouseEvent.MOUSE_UP:
                  this.setState(1);
            }
         }
      }
      
      override protected function setState(param1:int = 0) : void
      {
         switch(param1)
         {
            case 0:
               stateOFF.alpha = 1;
               stateUP.alpha = 0;
               stateOVER.alpha = 0;
               stateDOWN.alpha = 0;
               _label.y = 7;
               this.icon.y = ICON_Y + 1;
               break;
            case 1:
               stateOFF.alpha = 0;
               stateUP.alpha = 1;
               stateOVER.alpha = 0;
               stateDOWN.alpha = 0;
               _label.y = 6;
               this.icon.y = ICON_Y;
               break;
            case 2:
               stateOFF.alpha = 0;
               stateUP.alpha = 0;
               stateOVER.alpha = 1;
               stateDOWN.alpha = 0;
               _label.y = 6;
               this.icon.y = ICON_Y;
               break;
            case 3:
               stateOFF.alpha = 0;
               stateUP.alpha = 0;
               stateOVER.alpha = 0;
               stateDOWN.alpha = 1;
               _label.y = 7;
               this.icon.y = ICON_Y + 1;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this.requestCounter.x = _width + 3;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      public function setRequestCount(param1:int, param2:int) : void
      {
         this.requestCounter.setRequestCount(param1,param2);
      }
      
      public function set currentRequestCount(param1:int) : void
      {
         this.requestCounter.currentCount = param1;
      }
      
      public function set newRequestCount(param1:int) : void
      {
         this.requestCounter.newCount = param1;
      }
      
      public function getType() : FriendsWindowState
      {
         return this.type;
      }
   }
}
