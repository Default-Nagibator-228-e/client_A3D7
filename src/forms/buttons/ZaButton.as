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
   
	public class ZaButton extends BaseButton
	{
		[Embed(source="5.png")]
		private static var add:Class;
		private var icon1:MovieClip = new MovieClip();
		private var i:Bitmap = new add();
		private var i1:MainPanelHelpButton = new MainPanelHelpButton();
		
		public function ZaButton() 
		{
			super();
			er(i1.bg);
			icon1.addChild(i);
			er1(icon1, 3.5, 3);
		}
	}
}