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
   
	public class FrButton extends BaseButton
	{
		[Embed(source="2.png")]
		private static var add:Class;
		[Embed(source="3.png")]
		private static var add1:Class;
		public var icon1:MovieClip = new MovieClip();
		private var i:Bitmap = new add();
		public var i1:MainPanelBattlesButton = new MainPanelBattlesButton();
		public var i2:Bitmap = new add1();
		
		public function FrButton() 
		{
			super();
			er(i1.bg);
			//i.y = this.width/2;
			icon1.addChild(i);
			er1(icon1, 2);
			addChild(this.i2);
			this.i2.x = this.width - this.i2.width / 1.5;
			this.i2.y -= this.i2.width * 0.25;
			this.i2.visible = false;
		}
	}
}