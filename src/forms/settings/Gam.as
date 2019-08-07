package forms.settings 
{
	import alternativa.init.Main;
	import alternativa.osgi.service.locale.ILocaleService;
	import alternativa.tanks.locale.constants.TextConst;
	import controls.Label;
	import controls.Slider;
	import controls.TankCheckBox;
	import controls.TankWindowInner;
	import forms.events.SliderEvent;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	
	public class Gam extends Sprite
	{
		
		private var performanceInner:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
		
		private static const windowMargin:int = 10;
		
		private static const SecondCol:int = 400;
		
		public var _showFPS:TankCheckBox;
      
		public var _adaptiveFPS:TankCheckBox;
		
		public var _showBattleChat:TankCheckBox;
		
		public var _inverseBackDriving:TankCheckBox;
		
		public var _sendNews:TankCheckBox;
		
		public var _showSkyBox:TankCheckBox;
		
		public var volumeLevel:Slider = new Slider();
	        
		public var volumeLabel:Label = new Label();
		
		public var _bgSound:TankCheckBox;
		
		public var so:SettingsWindow;
		
		private var soundInner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
		
		public function Gam(w:int,s:SettingsWindow) 
		{
			so = s;
			var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
			addChild(this.performanceInner);
			 this._showFPS = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SHOW_FPS_CHECKBOX_LABEL_TEXT));
			 addChild(this._showFPS);
			 this._showFPS.x = windowMargin;
			 this._showFPS.y = windowMargin;
			 this._adaptiveFPS = this.createCheckBox(localeService.getText(TextConst.SETTINGS_ENABLE_ADAPTIVE_FPS_CHECKBOX_LABEL_TEXT));
			 addChild(this._adaptiveFPS);
			 this._adaptiveFPS.x = SecondCol;
			 this._adaptiveFPS.y = windowMargin;
			 this._showSkyBox = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SHOW_SKYBOX_CHECKBOX_LABEL_TEXT));
			 this._showSkyBox.type = TankCheckBox.CHECK_SIGN;
			 addChild(this._showSkyBox);
			 this._showSkyBox.x = windowMargin;
			 this._showSkyBox.y = this._showFPS.height + this._showFPS.y + windowMargin;
			 this._showBattleChat = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SHOW_BATTLE_CHAT_CHECKBOX_LABEL_TEXT));
			 addChild(this._showBattleChat);
			 this._showBattleChat.x = SecondCol;
			 this._showBattleChat.y = this._showSkyBox.y;
			 this._inverseBackDriving = this.createCheckBox(localeService.getText(TextConst.SETTINGS_INVERSE_TURN_CONTROL_CHECKBOX_LABEL_TEXT));
			 addChild(this._inverseBackDriving);
			 this._inverseBackDriving.x = windowMargin;
			 this._inverseBackDriving.y = this._showSkyBox.height + this._showSkyBox.y + windowMargin;
			 this._sendNews = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SEND_NEWS_CHECKBOX_LABEL_TEXT));
			 addChild(this._sendNews);
			 this._sendNews.x = SecondCol;
			 this._sendNews.y = this._inverseBackDriving.y;
			 performanceInner.width = w;
			 performanceInner.height = _inverseBackDriving.y + _inverseBackDriving.height + windowMargin;
			 addChild(this.volumeLabel);
			 this.volumeLabel.text = localeService.getText(TextConst.SETTINGS_SOUND_VOLUME_LABEL_TEXT);
			 this.volumeLabel.x = windowMargin;
			 this.volumeLabel.y = performanceInner.height + windowMargin;
			 addChild(soundInner);
			 soundInner.width = w;
			 soundInner.y = this.volumeLabel.y + this.volumeLabel.height;
			 s.volumeLevel = new Slider();
			 addChild(s.volumeLevel);
			 s.volumeLevel.maxValue = 100;
			 s.volumeLevel.minValue = 0;
			 s.volumeLevel.tickInterval = 5;
			 s.volumeLevel.x = windowMargin;
			 s.volumeLevel.y = this.volumeLabel.y + this.volumeLabel.height + windowMargin;
			 s.volumeLevel.width = w - 2 * windowMargin;
			 s.volumeLevel.addEventListener(SliderEvent.CHANGE_VALUE, onChangeVolume);
			 this._bgSound = this.createCheckBox(localeService.getText(TextConst.SETTINGS_BACKGROUND_SOUND_CHECKBOX_LABEL_TEXT));
			 addChild(this._bgSound);
			 this._bgSound.x = windowMargin;
			 this._bgSound.y = s.volumeLevel.y + s.volumeLevel.height + windowMargin;
			 this.soundInner.height = (_bgSound.y + _bgSound.height) - soundInner.y + windowMargin;
		}
		
		private function onChangeVolume(e:SliderEvent) : void
		  {
			 so.dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CHANGE_VOLUME));
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