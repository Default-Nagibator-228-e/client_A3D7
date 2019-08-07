package forms.buttons 
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.panel.BaseButton;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.events.MainButtonBarEvents;
   import mx.core.BitmapAsset;
   
	public class UprButton extends DefaultButton
	{
		[Embed(source="12.png")]
		private static var add:Class;
		private var i:Bitmap = new add();
		private var f:Label = new Label();
		
		public function UprButton(g:String) 
		{
			super();
			f.text = g;
			f.mouseEnabled = false;
			this.width = 113;
			addChild(i);
			i.y = 6;
			i.x = 8;
			addChild(f);
			f.x = ((this.width - i.x - i.width - f.textWidth)/2) + i.width;
			f.y = 7;
		}
	}
}