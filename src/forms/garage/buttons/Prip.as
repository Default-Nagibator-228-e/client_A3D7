package forms.garage.buttons 
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
   
	public class Prip extends DefaultButton
	{
		[Embed(source="b/4.png")]
		private static var add:Class;
		private var icon1:MovieClip = new MovieClip();
		private var i:Bitmap = new add();
		private var i1:MainPanelBattlesButton = new MainPanelBattlesButton();
		private var f:Label = new Label();
		
		public function Prip() 
		{
			super();
			f.mouseEnabled = false;
			this.width = 100;
			this.height = i1.height;
			i.x = 6;
			i.y = 6;
			this.addChild(i);
			f.text = "Припасы";
			f.x = i.x + i.width + 8;
			f.y = (this.height / 2 - f.height / 2);
			this.addChild(f);
		}
	}
}