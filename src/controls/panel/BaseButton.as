package controls.panel {
	import controls.Label;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import mx.core.BitmapAsset;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	public class BaseButton extends MovieClip {
      
      public var b:MovieClip = new MovieClip();
      
      public var bg:MovieClip = new MovieClip();
	  
	  public var icon:MovieClip = new MovieClip();
      
      private var _label:Label;
      
      private var _short:Boolean = false;
      
      public var type:int = 0;
      
      private var _enable:Boolean = true;
      
      private var _labeltext:String;
      
      public function BaseButton()
      {
         this._label = new Label();
         super();
         this.configUI();
         this.enable = true;
         tabEnabled = false;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enable = param1;
         if(this._enable)
         {
            this.addListeners();
         }
         else
         {
            this.removeListeners();
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
	  
	  public function er(param1:DisplayObject) : void
      {
         super.addChild(param1);
      }
	  
	  public function er1(param1:MovieClip,p3:Number,op:Number = 4) : void
      {
		 param1.y = p3;
		 param1.x = op;
		 super.addChild(param1);
		 addChild(this._label);
      }
      
      public function set short(param1:Boolean) : void
      {
         this._short = param1;
         this._label.visible = !this._short;
         this._label.width = this._short?Number(1):Number(65);
         this._label.text = this._short?"":this._labeltext;
         this.enable = this._enable;
      }
      
      public function set label(param1:String) : void
      {
         this._label.autoSize = TextFieldAutoSize.NONE;
         this._label.align = TextFormatAlign.CENTER;
         this._label.height = 19;
         this._label.x = 23;
         this._label.y = 4;
         this._label.width = 66;
         this._label.mouseEnabled = false;
         //this._label.filters = [new DropShadowFilter(1,45,0,0.7,1,1,1)];
         this._label.text = param1;
         this._labeltext = param1;
      }
      
      private function configUI() : void
      {
         this.bg = getChildByName("b") as MovieClip;
         addChild(this._label);
      }
      
      private function addListeners() : void
      {
         gotoAndStop(2);
		 if (bg != null)
		 {
			this.bg.gotoAndStop(2 + (this._short?4:0));
		 }
         buttonMode = true;
         mouseEnabled = true;
         mouseChildren = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
      }
      
      private function removeListeners() : void
      {
         gotoAndStop(1);
		 if (bg != null)
		 {
			this.bg.gotoAndStop(1 + (this._short?4:0));
		 }
         this._label.y = 4;
         buttonMode = false;
         mouseEnabled = false;
         mouseChildren = false;
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
      }
      
      protected function onMouseEvent(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               this._label.y = 4;
               gotoAndStop(3);
               //this.bg.gotoAndStop(3 + (this._short?4:0));
               break;
            case MouseEvent.MOUSE_OUT:
               this._label.y = 4;
               gotoAndStop(2);
               //this.bg.gotoAndStop(2 + (this._short?4:0));
               break;
            case MouseEvent.MOUSE_DOWN:
               this._label.y = 5;
               gotoAndStop(4);
               //this.bg.gotoAndStop(4 + (this._short?4:0));
               break;
            case MouseEvent.MOUSE_UP:
               this._label.y = 4;
               gotoAndStop(2);
               //this.bg.gotoAndStop(2 + (this._short?4:0));
         }
      }
   }
}