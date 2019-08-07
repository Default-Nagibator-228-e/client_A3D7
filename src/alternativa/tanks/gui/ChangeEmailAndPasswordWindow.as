package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.BlueButton;
   import controls.Label;
   import controls.RedButton;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChangeEmailAndPasswordWindow extends Sprite
   {
       
      
      private var windowSize:Point;
      
      private var window:TankWindow;
      
      private var passwordInput:TankInput;
      
      private var passwordConfirmInput:TankInput;
      
      private var emailInput:TankInput;
      
      private var passLabel:Label;
      
      private var passConfirmLabel:Label;
      
      private var emailLabel:Label;
      
      private var localeService:ILocaleService;
      
      private var okButton:BlueButton;
      
      private var cancelButton:RedButton;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      public function ChangeEmailAndPasswordWindow()
      {
         super();
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.initGUI();
         this.initEvents();
      }
      
      public function get password() : String
      {
         if(this.passwordConfirmInput.validValue)
         {
            return this.passwordInput.value;
         }
         return null;
      }
      
      public function get passwordRepeate() : String
      {
         if(this.passwordConfirmInput.validValue)
         {
            return this.passwordConfirmInput.value;
         }
         return null;
      }
      
      public function get email() : String
      {
         if(this.emailInput.validValue)
         {
            return this.emailInput.value;
         }
         return null;
      }
      
      public function set email(value:String) : void
      {
         this.emailInput.value = value;
      }
      
      private function initGUI() : void
      {
         var inputWidth:int = 120;
         this.windowSize = new Point(440,180);
         this.window = new TankWindow(this.windowSize.x,this.windowSize.y);
         this.window.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.CHANGEPASSWORD;
         addChild(this.window);
         this.passwordInput = new TankInput();
         this.passwordInput.hidden = true;
         this.passwordInput.width = inputWidth;
         this.passwordInput.x = 109;
         this.passwordInput.y = 35 + this.margin;
         addChild(this.passwordInput);
         this.passLabel = new Label();
         this.passLabel.text = this.localeService.getText(TextConst.SETTINGS_NEW_PASSWORD_LABEL_TEXT);
         this.passLabel.x = 109 - this.margin - this.passLabel.textWidth;
         this.passLabel.y = this.passwordInput.y + Math.round((this.passwordInput.height - this.passLabel.textHeight) * 0.5) - 2;
         addChild(this.passLabel);
         this.passConfirmLabel = new Label();
         this.passConfirmLabel.text = this.localeService.getText(TextConst.SETTINGS_REENTER_PASSWORD_LABEL_TEXT);
         this.passConfirmLabel.x = this.passwordInput.x + this.passwordInput.width + 7;
         this.passConfirmLabel.y = this.passLabel.y;
         addChild(this.passConfirmLabel);
         this.passwordConfirmInput = new TankInput();
         this.passwordConfirmInput.width = inputWidth;
         this.passwordConfirmInput.hidden = true;
         this.passwordConfirmInput.x = this.passConfirmLabel.x + this.passConfirmLabel.textWidth + this.margin;
         this.passwordConfirmInput.y = this.passwordInput.y;
         addChild(this.passwordConfirmInput);
         this.emailLabel = new Label();
         this.emailLabel.text = this.localeService.getText(TextConst.SETTINGS_EMAIL_LABEL_TEXT);
         this.emailLabel.x = this.passLabel.x;
         this.emailLabel.y = this.passwordConfirmInput.y + this.passwordConfirmInput.height + this.windowMargin + 6;
         addChild(this.emailLabel);
         this.emailInput = new TankInput();
         this.emailInput.x = this.emailLabel.x + this.emailLabel.textWidth + this.margin;
         this.emailInput.y = this.passwordConfirmInput.y + this.passwordConfirmInput.height + this.windowMargin;
         this.emailInput.width = this.windowSize.x - this.margin - this.emailInput.x - 8;
         addChild(this.emailInput);
         this.okButton = new BlueButton();
         this.okButton.label = this.localeService.getText(TextConst.SETTINGS_BUTTON_SAVE_TEXT);
         this.okButton.x = this.windowSize.x - this.buttonSize.x - this.margin - 3;
         this.okButton.y = this.windowSize.y - this.buttonSize.y - this.margin;
         this.okButton.enable = false;
         addChild(this.okButton);
         this.cancelButton = new RedButton();
         this.cancelButton.label = this.localeService.getText(TextConst.SETTINGS_BUTTON_CANCEL_TEXT);
         this.cancelButton.x = this.windowSize.x - this.buttonSize.x * 2 - 5 - this.margin;
         this.cancelButton.y = this.windowSize.y - this.buttonSize.y - this.margin;
         addChild(this.cancelButton);
      }
      
      private function initEvents() : void
      {
         this.passwordInput.addEventListener(FocusEvent.FOCUS_OUT,this.checkPasswordConfirmation);
         this.passwordInput.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.passwordConfirmInput.addEventListener(FocusEvent.FOCUS_OUT,this.checkPasswordConfirmation);
         this.passwordConfirmInput.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.emailInput.addEventListener(FocusEvent.FOCUS_OUT,this.validateEmail);
         this.emailInput.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.okButton.addEventListener(MouseEvent.CLICK,this.onOkClick);
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelClick);
      }
      
      private function onOkClick(e:MouseEvent) : void
      {
         dispatchEvent(new ChangePasswordAndEmailEvent(ChangePasswordAndEmailEvent.CHANGE_PRESSED));
      }
      
      private function onCancelClick(event:MouseEvent) : void
      {
         dispatchEvent(new ChangePasswordAndEmailEvent(ChangePasswordAndEmailEvent.CANCEL_PRESSED));
      }
      
      private function checkPasswordConfirmation(e:Event) : void
      {
         if(this.passwordInput.value.length > 0 && this.passwordConfirmInput.value != this.passwordInput.value)
         {
            this.passwordConfirmInput.validValue = false;
         }
         else
         {
            this.passwordConfirmInput.validValue = true;
         }
         this.switchChangeButton();
      }
      
      private function validateEmail(event:FocusEvent) : void
      {
         var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
         var result:Object = pattern.exec(this.emailInput.value);
         if(this.emailInput.value.length > 0)
         {
            this.emailInput.validValue = result != null;
         }
         else
         {
            this.emailInput.validValue = false;
         }
         this.switchChangeButton();
      }
      
      private function restoreInput(e:Event) : void
      {
         var trgt:TankInput = e.currentTarget as TankInput;
         trgt.validValue = true;
      }
      
      private function switchChangeButton() : void
      {
         this.okButton.enable = this.passwordConfirmInput.validValue && this.emailInput.validValue;
      }
   }
}
