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
   import flash.display.StageDisplayState;
   import flash.events.MouseEvent;
   import forms.events.MainButtonBarEvents;
   import mx.core.BitmapAsset;
   
	public class FuButton extends BaseButton
	{
		[Embed(source="6.png")]
		private static var add:Class;
		[Embed(source="7.png")]
		private static var add1:Class;
		private var icon1:MovieClip = new MovieClip();
		private var i:Bitmap;
		private var i1:MainPanelHelpButton = new MainPanelHelpButton();
		
		public function FuButton() 
		{
			super();
			i = Game._stage.displayState == StageDisplayState.FULL_SCREEN || Game._stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE? new add1():new add();
			er(i1.bg);
			icon1.addChild(i);
			er1(icon1, 3.5, 3);
			this.type = 14;
		}
	}
}