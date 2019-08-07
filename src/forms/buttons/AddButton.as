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
   
	public class AddButton extends BaseButton
	{
		[Embed(source="1.png")]
		private static var add:Class;
		[Embed(source="8.png")]
		private static var add1:Class;
		private var icon1:MovieClip = new MovieClip();
		private var i:Bitmap = new add();
		private var i1:MainPanelBattlesButton = new MainPanelBattlesButton();
		
		public function AddButton() 
		{
			super();
			var ff:Bitmap = new add1();
			ff.width = i1.bg.width;
			ff.smoothing = true;
			ff.x = -1;
			er(ff);
			//i.y = this.width/2;
			icon1.addChild(i);
			er1(icon1,2,2);
		}
	}
}