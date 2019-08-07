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
   
	public class Newsb extends DefaultButton
	{
		[Embed(source="13.png")]
		private static var add:Class;
		private var icon1:MovieClip = new MovieClip();
		private var i:Bitmap = new add();
		private var i1:MainPanelBattlesButton = new MainPanelBattlesButton();
		private var f:Label = new Label();
		
		public function Newsb(s:String) 
		{
			super();
			f.mouseEnabled = false;
			this.width = i1.width;
			this.height = i1.height;
			i.x = 6;
			i.y = 6;
			this.addChild(i);
			f.text = s;
			f.x = i.x + i.width + 11;
			f.y = (this.height / 2 - f.height / 2);
			this.addChild(f);
		}
	}
}