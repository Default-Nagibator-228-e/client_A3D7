package controls.statassets
{
   import controls.Label;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class StatHeaderButton extends Sprite
   {
       
      
      private var _bg:StatLineHeader;
      
      private var _label:Label;
      
      public var numSort:int = 0;
      
      protected var _selected:Boolean = false;
      
      protected var _width:int = 100;
      
      protected var _height:int = 20;
      
      public function StatHeaderButton(right:Boolean = true)
      {
         this._bg = new StatLineHeader();
         this._label = new Label();
         super();
         this._bg.width = this._width;
         this._bg.height = this._height;
         addChild(this._bg);
         addChild(this._label);
         this._label.color = 860685;
         this._label.x = 2;
         this._label.y = 0;
         this._label.mouseEnabled = false;
         this._label.autoSize = TextFieldAutoSize.NONE;
         this._label.align = !!right?TextFormatAlign.RIGHT:TextFormatAlign.LEFT;
         this._label.height = 19;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this._bg.selected = this._selected;
      }
      
      public function set label(text:String) : void
      {
         this._label.text = text;
      }
      
      override public function set width(w:Number) : void
      {
         this._width = Math.floor(w);
         this._bg.width = w;
         this._label.width = this._width - 4;
      }
      
      override public function set height(h:Number) : void
      {
         this._height = Math.floor(h);
         this._bg.height = h;
      }
   }
}
