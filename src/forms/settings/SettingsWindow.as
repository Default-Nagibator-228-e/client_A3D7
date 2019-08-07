package forms.settings
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.Slider;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import forms.TankWindowWithHeader;
   import forms.buttons.AccButton;
   import forms.buttons.GameButton;
   import forms.buttons.GraphButton;
   import forms.buttons.UprButton;
   import forms.events.SliderEvent;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import forms.settings.SettingsWindowEvent;
   
   public class SettingsWindow extends Sprite
   {
      
      private static const buttonSize:Point = new Point(104,33);
      
      private static const FIRST_COLUMN_X:int = 21;
      
      private static const SECOND_COLUMN_X:int = 109;
      
      private static const windowMargin:int = 12;
      
      private static const margin:int = 8;
       
      
      private var passwordInput:TankInput;
      
      private var passwordConfirmInput:TankInput;
      
      public var emailInput:TankInput;
      
      private var realNameInput:TankInput;
      
      private var idNumberInput:TankInput;
      
      public var volumeLevel:Slider;
	  
	  private var volumeSLevel:Slider;
      
      private var volumeLabel:Label = new Label();
      
      private var passLabel:Label = new Label();
      
      private var repPassLabel:Label = new Label();
      
      private var emailLabel:Label = new Label();
      
      private var performanceLabel:Label = new Label();
      
      private var accountLabel:Label = new Label();
      
      private var controlLabel:Label = new Label();
      
      private var antiAddictionLabel:Label = new Label();
      
      private var realNameLabel:Label = new Label();
      
      private var idNumberLabel:Label = new Label();
      
      private var _bgSound:TankCheckBox;
      
      private var _showFPS:TankCheckBox;
      
      private var _adaptiveFPS:TankCheckBox;
      
      private var _sendNews:TankCheckBox;
      
      private var _showSkyBox:TankCheckBox;
      
      private var _showBattleChat:TankCheckBox;
      
      private var _inverseBackDriving:TankCheckBox;
      
      private var cbMipMapping:TankCheckBox;
      
      private var useNewLoader:TankCheckBox;
      
      private var _showShadowsTank:TankCheckBox;
      
      private var _useFog:TankCheckBox;
      
      private var _softParticle:TankCheckBox;
      
      private var _dust:TankCheckBox;
      
      private var _shadows:TankCheckBox;
	  
	  private var _shadowsM:Boolean = false;
	  
	  private var _shadowsB:Boolean = false;
      
      private var _defferedLighting:TankCheckBox;
      
      private var _animateTracks:TankCheckBox;
      
      private var _koefV:TankInput;
      
      private var _koefAV:TankInput;
      
      private var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("НАСТРОЙКИ");
      
      private var soundInner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
      
      private var performanceInner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
      
      private var accountInner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
      
      private var controlInner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
      
      private var antiAddictionInner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
      
      private var windowSize:Point = new Point(750,550);
      
      public var confirmEmailButton:DefaultButton = new DefaultButton();
      
      private var cancelButton:DefaultButton = new DefaultButton();
      
      private var okButton:DefaultButton = new DefaultButton();
      
      private var changePasswordButton:DefaultButton = new DefaultButton();
      
      public var state:int;
      
      public const STATE_EMAIL_UNDEFINED:int = 0;
      
      public const STATE_EMAIL_UNCONFIRMED:int = 1;
      
      public const STATE_EMAIL_CHANGE:int = 2;
      
      public var isPasswordChangeDisabled:Boolean = false;
	  
	  public var gam:GameButton = new GameButton("Игра");
      
      private var gr:GraphButton = new GraphButton("Графика");
	  
	  private var g:Gam;
	  
	  private var gp:Graphic;
	  
	  private var mode:Boolean = false;
	  
	  public var ac:AccButton = new AccButton("Аккаунт");
      
      private var upr:UprButton = new UprButton("Управление");
	        
      public function SettingsWindow(mail:String, emailConfirmed:Boolean, antiAddictionEnabled:Boolean, realName:String, idNumber:String)
      {
         super();
         var inputWidth:int = 10;
         this.window.width = this.windowSize.x;
		 this.window.height = this.windowSize.y;
         addChild(this.window);
		 gam.x = 12;
		 gam.y = 11;
		 window.addChild(gam);
		 gam.addEventListener(MouseEvent.CLICK,cl);
		 gr.x = gam.x + gam.width + 10;
		 gr.y = 11;
		 window.addChild(gr);
		 gr.addEventListener(MouseEvent.CLICK, cl1);
		 ac.x = gr.x + gr.width + 10;
		 ac.y = 11;
		 ac.enable = false;
		 window.addChild(ac);
		 upr.x = ac.x + ac.width + 10;
		 upr.y = 11;
		 upr.enable = false;
		 window.addChild(upr);
		 g = new Gam(this.windowSize.x - gam.x - gam.x,this);
		 g.x = 12;
		 g.y = gam.y + gam.height + 11;
		 gam.en();
		 window.addChild(g);
		 gp = new Graphic(this.windowSize.x - gam.x - gam.x);
		 gp.x = 12;
		 gp.y = gam.y + gam.height + 11;
		 window.addChild(gp);
		 gp.visible = false;
		 this.okButton = new DefaultButton();
         addChild(this.okButton);
         this.okButton.label = "Закрыть";
         this.okButton.x = this.windowSize.x - okButton.width - windowMargin;
         this.okButton.y = this.windowSize.y - okButton.height - windowMargin;
         this.okButton.addEventListener(MouseEvent.CLICK,this.onOkClick);
      }
	  
	  private function cl(event:MouseEvent) : void
      {
			gr.enable = true;
			gam.en();
			mode = false;
			changemode();
      }
	  
	  private function cl1(event:MouseEvent) : void
      {
			gam.enable = true;
			gr.en();
			mode = true;
			changemode();
      }
	  
	  public function changemode() : void
      {
			g.visible = !mode;
			gp.visible = mode;
      }
      
      public function get useShadows() : Boolean
      {
         return gp._shadows.checked;
      }
      
      public function set useShadows(v:Boolean) : void
      {
         gp._shadows.checked = v;
      }
	  
	  public function get useShadowsM() : Boolean
      {
         return _shadowsM;
      }
      
      public function set useShadowsM(v:Boolean) : void
      {
         _shadowsM = v;
      }
	  
	  public function get useShadowsB() : Boolean
      {
         return _shadowsB;
      }
	  
	  public function set useShadowsB(v:Boolean) : void
      {
         _shadowsB = v;
      }
      
      public function get useDefferedLighting() : Boolean
      {
         return gp._defferedLighting.checked;
      }
      
      public function set useDefferedLighting(v:Boolean) : *
      {
         gp._defferedLighting.checked = v;
      }
      
      public function get useDust() : Boolean
      {
         return gp._dust.checked;
      }
      
      public function set useDust(v:Boolean) : void
      {
         gp._dust.checked = v;
      }
      
      public function get useSoftParticle() : Boolean
      {
         return gp._softParticle.checked;
      }
      
      public function get useFog() : Boolean
      {
         return gp._useFog.checked;
      }
      
      public function get bgSound() : Boolean
      {
         return g._bgSound.checked;
      }
      
      public function get showShadowsTank() : Boolean
      {
         return false;
      }
      
      public function set bgSound(value:Boolean) : void
      {
         g._bgSound.checked = value;
      }
      
      public function get useAnimTracks() : Boolean
      {
         return true;
      }
      
      public function set useAnimTracks(value:Boolean) : void
      {
		  
      }
      
      public function get showFPS() : Boolean
      {
         return g._showFPS.checked;
      }
      
      public function set showFPS(value:Boolean) : void
      {
         g._showFPS.checked = value;
      }
      
      public function get adaptiveFPS() : Boolean
      {
         return g._adaptiveFPS.checked;
      }
      
      public function set adaptiveFPS(value:Boolean) : void
      {
         g._adaptiveFPS.checked = value;
      }
      
      public function get sendNews() : Boolean
      {
         return g._sendNews.checked;
      }
      
      public function set sendNews(value:Boolean) : void
      {
         g._sendNews.checked = value;
      }
      
      public function get showSkyBox() : Boolean
      {
         return g._showSkyBox.checked;
      }
      
      public function set showSkyBox(value:Boolean) : void
      {
         g._showSkyBox.checked = value;
      }
	  
	  public function get showS() : Boolean
      {
         return gp.useNewLoader.checked;
      }
      
      public function set showS(value:Boolean) : void
      {
         gp.useNewLoader.checked = value;
      }
      
      public function get showBattleChat() : Boolean
      {
         return g._showBattleChat.checked;
      }
      
      public function set showBattleChat(value:Boolean) : void
      {
         g._showBattleChat.checked = value;
      }
      
      public function get inverseBackDriving() : Boolean
      {
         return g._inverseBackDriving.checked;
      }
      
      public function set inverseBackDriving(value:Boolean) : void
      {
         g._inverseBackDriving.checked = value;
      }
      
      public function get enableMipMapping() : Boolean
      {
         return true;
      }
      
      public function set enableMipMapping(value:Boolean) : void
      {
      }
      
      private function restoreInput(event:FocusEvent) : void
      {
         var trgt:TankInput = event.currentTarget as TankInput;
         trgt.validValue = true;
      }
      
      private function validateAddictionID(event:FocusEvent) : void
      {
         var l:int = 0;
         if(this.idNumberInput != null)
         {
            l = this.idNumberInput.value.length;
            this.idNumberInput.validValue = l == 18 || this.trimString(this.idNumberInput.value).length == 0;
         }
      }
      
      private function onChangePasswordClick(event:MouseEvent) : void
      {
         //this.changePasswordButton.enable = false;
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CHANGE_PASSWORD));
      }
      
      public function onChangeVolume(e:SliderEvent) : void
      {
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CHANGE_VOLUME));
      }
	  
	  private function onChangeVolumeS(e:SliderEvent) : void
      {
        _shadowsM = false;// volumeSLevel.value == 0?true:false;
		_shadowsB = true;// volumeSLevel.value == 0?false:true;
      }
      
      public function set visibleDustButton(v:Boolean) : void
      {
         gp._dust.visible = v;
      }
      
      private function onComfirmClick(e:MouseEvent) : void
      {
         //this.confirmEmailButton.enable = false;
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.RESEND_CONFIRMATION));
      }
      
      private function onCancelClick(e:MouseEvent) : void
      {
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CANCEL_SETTINGS));
      }
      
      private function onOkClick(e:MouseEvent) : void
      {
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.ACCEPT_SETTINGS));
		 dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CANCEL_SETTINGS));
      }
      
      private function checkPasswordConfirmation(e:Event) : void
      {
         //if(this.passwordInput.value.length > 0 && this.passwordConfirmInput.value != this.passwordInput.value)
         //{
            //this.okButton.enable = false;
            //this.passwordConfirmInput.validValue = false;
         //}
         //else
         //{
            //this.okButton.enable = true;
            //this.passwordConfirmInput.validValue = true;
         //}
      }
      
      private function checkV(e:Event) : void
      {
         if(isNaN(Number((e.currentTarget as TankInput).value)))
         {
            trace("Плохо");
            return;
         }
         IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("k_V",Number((e.currentTarget as TankInput).value));
      }
      
      private function checkAV(e:Event) : void
      {
         if(isNaN(Number((e.currentTarget as TankInput).value)))
         {
            trace("Плохо");
            return;
         }
         IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("k_AV",Number((e.currentTarget as TankInput).value));
      }
      
      public function get password() : String
      {/*
         if(this.isPasswordChangeDisabled)
         {
            return "";
         }
         var p:String = "";
         if(this.passwordInput.textField.text != "" && this.passwordInput.textField.text != null)
         {
            if(this.passwordInput.textField.text == this.passwordConfirmInput.textField.text)
            {
               p = this.passwordInput.textField.text;
            }
         }*/
         return ""//p;
      }
      
      public function get email() : String
      {
         if(this.isPasswordChangeDisabled)
         {
            return "";
         }
         return ""//this.emailInput.textField.text;
      }
      
      public function get emailNoticeValue() : Boolean
      {
         return true;//this._sendNews.checked;
      }
      
      public function get volume() : Number
      {
         return this.volumeLevel.value / 100;
      }
      
      public function set volume(value:Number) : void
      {
         this.volumeLevel.value = value * 100;
      }
      
      public function get realName() : String
      {
         /*if(this.realNameInput != null && this.realNameInput.value != null && this.trimString(this.realNameInput.value).length > 0)
         {
            return this.realNameInput.value;
         }*/
         return "";
      }
      
      public function get idNumber() : String
      {
         /*if(this.idNumberInput != null && this.idNumberInput.value != null && this.trimString(this.idNumberInput.value).length > 0)
         {
            return this.idNumberInput.value;
         }*/
         return "";
      }
      
      private function trimString(str:String) : String
      {
         if(str.charAt(0) == " ")
         {
            str = this.trimString(str.substring(1));
         }
         if(str.charAt(str.length - 1) == " ")
         {
            str = this.trimString(str.substring(0,str.length - 1));
         }
         return str;
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
