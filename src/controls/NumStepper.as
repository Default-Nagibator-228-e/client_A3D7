package controls
{
   import assets.icons.BattleInfoIcons;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.GridFitType;
   import flash.text.TextFieldType;
   import flash.text.TextFormatAlign;
   import forms.events.LoginFormEvent;
   
   public class NumStepper extends MovieClip
   {
       
      
      private var tf:TankInput;
      
      private var button:StepperButton;
      
      private var _value:int = 0;
      
      private var _maxValue:int = 10;
      
      private var _minValue:int = 0;
      
      private var _labell:Label;
      
      private var _enable:Boolean = true;
      
      public function NumStepper()
      {
         this.tf = new TankInput();
         this.button = new StepperButton();
         super();
         addChild(this.tf);
         this.tf.width = 55;
         this.tf.x = 19;
         addChild(this.button);
         this.button.x = 75;
         this.tf.restrict = "0-9";
         this.tf.maxChars = 5;
         this.tf.align = TextFormatAlign.CENTER;
         this.tf.textField.addEventListener(FocusEvent.FOCUS_OUT,this.onTextChange);
         this.tf.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onTextChange);
         this.tf.addEventListener(LoginFormEvent.TEXT_CHANGED,this.onTextChange);
         this.tf.textField.addEventListener(FocusEvent.FOCUS_IN,this.clearTF);
         this.draw();
         this.enabled = true;
      }
      
      public function set minValue(val:int) : void
      {
         this._minValue = val;
         this._value = Math.max(this._value,this._minValue);
         this.draw();
      }
      
      public function set maxValue(val:int) : void
      {
         this._maxValue = val;
         this._value = Math.min(this._value,this._maxValue);
         this.draw();
      }
      
      public function set icon(type:int) : void
      {
         var _icon:BattleInfoIcons = new BattleInfoIcons();
         _icon.type = type;
         _icon.y = 8;
         addChild(_icon);
      }
      
      public function set label(value:String) : void
      {
         if(this._labell == null)
         {
            this._labell = new Label();
            this._labell.x = 18;
            this._labell.y = -18;
            this._labell.gridFitType = GridFitType.SUBPIXEL;
            addChild(this._labell);
         }
         this._labell.text = value;
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function set value(value:int) : void
      {
         this._value = value;
         this.draw();
      }
      
      override public function set enabled(value:Boolean) : void
      {
         this._enable = value;
         if(this._enable)
         {
            this.button.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.button.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.button.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseUp);
            this.tf.textField.selectable = true;
            this.tf.textField.type = TextFieldType.INPUT;
         }
         else
         {
            this.button.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.button.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.button.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseUp);
            this.tf.textField.selectable = false;
            this.tf.textField.type = TextFieldType.DYNAMIC;
         }
      }
      
      override public function get enabled() : Boolean
      {
         return this._enable;
      }
      
      private function clearTF(e:Event) : void
      {
         if(this.tf.value == "—")
         {
            this.tf.clear();
         }
      }
      
      private function onTextChange(event:Event) : void
      {
         var tempValue:int = Number(this.tf.value);
         this._value = Math.max(this._minValue,Math.min(tempValue,this._maxValue));
         this.draw();
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         this.button.gotoAndStop(this.button.mouseY < 15?2:3);
         this._value = Number(this.tf.value);
         this._value = Math.min(this._value,this._maxValue);
         this._value = this._value + (this.button.mouseY > 15?this._value > this._minValue?-1:0:this._value < this._maxValue?1:0);
         this.draw();
      }
      
      private function onMouseUp(event:MouseEvent) : void
      {
         this.button.gotoAndStop(1);
      }
      
      private function draw() : void
      {
         if(stage != null)
         {
            this.tf.value = this._value > 0 || stage.focus == this.tf.textField?String(this.value):"—";
            if(this.enabled)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
         else
         {
            this.tf.value = this._value > 0?String(this.value):"—";
         }
      }
   }
}
