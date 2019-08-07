package forms.garage
{
   import forms.upgrade.PropertyIcon;
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   
   public class ItemPropertyIcon extends Sprite
   {
       
      
      public var bmp:Bitmap;
      
      private var label:Label;
      
      private var _module:String;
      
      private const space:int = 8;
      
      private var _text:String;
      
      public function ItemPropertyIcon(icon:BitmapData, module:String)
      {
         super();
         this._module = module;
         this.bmp = new Bitmap(icon);
         addChild(this.bmp);
         this.label = new Label();
         this.label.size = 10;
         addChild(this.label);
         this.label.text = this._module;
         this.label.align = TextFormatAlign.CENTER;
		 this.label.size = 14;
         this.label.sharpness = -100;
         this.label.thickness = 100;
         this.posLabel();
         this.label.y = this.bmp.height + this.space;
      }
      
      public function set labelText(text:String) : void
      {
         if(text != null && text != "null")
         {
            this._text = text;
         }
         else
         {
            this._text = "—";
         }
		 if (_module.search("%") != -1)
		 {
			this.label.text = this._module + "\n" + this._text;
		 }else{
			this.label.text = this._module + this._text;
		 }
         this.posLabel();
      }
	  
	  public function clone() : PropertyIcon
      {
		 return new PropertyIcon(bmp.bitmapData,this.label.text);
      }
      
      private function posLabel() : void
      {
         if(this.bmp.width > this.label.textWidth)
         {
            this.label.x = Math.round((this.bmp.width - this.label.textWidth) * 0.5) - 3;
         }
         else if(this.label.textWidth > this.bmp.width)
         {
            this.label.x = -Math.round((this.label.textWidth - this.bmp.width) * 0.5) - 3;
         }
         else
         {
            this.label.x = -3;
         }
      }
      
      public function get labelCoord() : int
      {
         return this.label.x;
      }
   }
}
