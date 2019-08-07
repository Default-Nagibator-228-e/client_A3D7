package forms.settings 
{
	import alternativa.init.Main;
	import alternativa.osgi.service.locale.ILocaleService;
	import alternativa.osgi.service.storage.IStorageService;
	import controls.TankCheckBox;
	import controls.TankWindowInner;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Graphic extends Sprite
	{
		
		private var performanceInner:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
		
		private static const windowMargin:int = 10;
		
		private static const SecondCol:int = 400;
      
		public var useNewLoader:TankCheckBox;
		
		public var _defferedLighting:TankCheckBox;
		
		public var _softParticle:TankCheckBox;
		
		public var _dust:TankCheckBox;
		
		public var _shadows:TankCheckBox;
		
		public var _useFog:TankCheckBox;
		
		public function Graphic(w:int) 
		{
			var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
			addChild(this.performanceInner);
			this.useNewLoader = this.createCheckBox("Сглаживание");
			 addChild(this.useNewLoader);
			 this.useNewLoader.x = windowMargin;
			 this.useNewLoader.y = windowMargin;
			 this.useNewLoader.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			 {
				IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("SSAO",useNewLoader.checked);
			 });
			 this.useNewLoader.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["SSAO"];
			 this._defferedLighting = this.createCheckBox("Динамическое освещение");
			 this._defferedLighting.x = SecondCol;
			 this._defferedLighting.y = windowMargin;
			 this._defferedLighting.enabled = false;
			 addChild(this._defferedLighting);
			 this._softParticle = this.createCheckBox("Мягкие частицы");
			 this._softParticle.x = windowMargin;
			 this._softParticle.y = this.useNewLoader.y + this.useNewLoader.height + windowMargin;
			 this._softParticle.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			 {
				IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("soft_particle",_softParticle.checked);
				_dust.visible = _softParticle.checked;
			 });
			 this._softParticle.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["soft_particle"];
			 addChild(this._softParticle);
			 this._dust = this.createCheckBox("Пыль под танками");
			 this._dust.x = SecondCol;
			 this._dust.y = this._softParticle.y;
			 this._dust.visible = _softParticle.checked;
			 addChild(this._dust);
			 this._shadows = this.createCheckBox("Динамические тени");
			 this._shadows.x = windowMargin;
			 this._shadows.y = this._softParticle.y + this._softParticle.height + windowMargin;
			 this._shadows.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["shadows"];
			 addChild(this._shadows);
			 this._useFog = this.createCheckBox("Туман");
			 this._useFog.x = SecondCol;
			 this._useFog.y = this._shadows.y;
			 this._useFog.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["fog"];
			 addChild(this._useFog);
			performanceInner.width = w;
			performanceInner.height = _shadows.y + _shadows.height + windowMargin;
		}
		
		private function createCheckBox(labelText:String) : TankCheckBox
		  {
			 var cb:TankCheckBox = new TankCheckBox();
			 cb.type = TankCheckBox.CHECK_SIGN;
			 cb.label = labelText;
			 return cb;
		  }
		
	}

}