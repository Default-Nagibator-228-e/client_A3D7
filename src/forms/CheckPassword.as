package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class CheckPassword extends Sprite
   {
       
      
      public var callSign:TankInput;
      
      public var restoreLink:Label;
      
      public var password:TankInput;
      
      public var checkRemember:TankCheckBox;
      
      public var playButton:DefaultButton;
      
      public var registerButton:Label;
      
      public function CheckPassword()
      {
         var label:Label = null;
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var bg:TankWindowWithHeader = TankWindowWithHeader.createWindow("ВХОД В ИГРУ");
		 bg.width = 400;
		 bg.height = 180;
         addChild(bg);
         this.registerButton = new Label();
         this.registerButton.htmlText = localeService.getText(TextConst.CHECK_PASSWORD_FORM_BUTTON_REGISTRATION_TEXT);
         this.registerButton.x = 85;
         this.registerButton.y = 26;
         addChild(this.registerButton);
		 this.restoreLink = new Label();
         this.restoreLink.x = this.registerButton.x + registerButton.width + 50;
         this.restoreLink.y = 26;
         this.restoreLink.htmlText = localeService.getText(TextConst.CHECK_PASSWORD_FORM_RESTORE_LINK_TEXT);
         addChild(this.restoreLink);
         this.callSign = new TankInput();
         this.callSign.width = this.restoreLink.x + this.restoreLink.width-85;
         this.callSign.x = 85;
         this.callSign.y = 53.5;
         this.callSign.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_CALLSIGN);
         this.callSign.tabIndex = 0;
         this.callSign.restrict = ".0-9a-zA-z_\\-";
         this.callSign.maxChars = 30;
         addChild(this.callSign);
         this.password = new TankInput();
         this.password.width = this.restoreLink.x + this.restoreLink.width-85;
         this.password.x = 85;
         this.password.y = 87;
         this.password.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_PASSWORD);
         this.password.hidden = true;
         this.password.tabIndex = 1;
         addChild(this.password);
         this.checkRemember = new TankCheckBox();
         this.checkRemember.x = 85;
         this.checkRemember.y = 133;
         addChild(this.checkRemember);
         label = new Label();
         label.x = 113;
         label.y = 138;
         label.text = localeService.getText(TextConst.CHECK_PASSWORD_FORM_REMEMBER);
         addChild(label);
         var test:GlowFilter = new GlowFilter();
         this.playButton = new DefaultButton();
         this.playButton.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_PLAY_BUTTON);
         this.playButton.x = (this.password.x + (this.restoreLink.x + this.restoreLink.width-85)) - this.playButton.width;
         this.playButton.y = 133;
         addChild(this.playButton);
      }
   }
}
