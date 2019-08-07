package forms.buttons 
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.panel.BaseButton;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.events.MainButtonBarEvents;
   import mx.core.BitmapAsset;
   
	public class GPButton extends BaseButton
	{
		[Embed(source="4.png")]
		private static var add1:Class;
		public var i2:Bitmap = new add1();
		
		public function GPButton() 
		{
			super();
			addChild(this.i2);
		}
	}
}