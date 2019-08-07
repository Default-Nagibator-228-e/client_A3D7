package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.InputCheckIcon;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextFieldType;
   
   public class RegisterForm extends Sprite
   {
      
      public static const CALLSIGN_STATE_OFF:int = 0;
      
      public static const CALLSIGN_STATE_PROGRESS:int = 1;
      
      public static const CALLSIGN_STATE_VALID:int = 2;
      
      public static const CALLSIGN_STATE_INVALID:int = 3;
       
	  [Embed(source = "image.jpg")]
	  static private var image:Class;
	  public var im:Bitmap = new image();
      
      public var callSign:TankInput;
      
      public var callSignCheckIcon:InputCheckIcon;
      
      public var pass1:TankInput;
      
      public var pass2:TankInput;
      
      public var chekRemember:TankCheckBox;
      
      public var playButton:DefaultButton;
	  
	  public var lf:Label = new Label();
      
      public var rulesButton:Label;
      
      public var realName:TankInput;
      
      public var idNumber:TankInput;
      
      public var confirm:Label;
	  
	  public var ch:Label = new Label();
	  
	  public var invite:TankInput;
	  
	  public var invCheckIcon:InputCheckIcon;
      
      public function RegisterForm(antiAddictionEnabled:Boolean)
      {
         var label:Label = null;
         var antiAddictionInner:TankWindowInner = null;
         var antiAddictionTitle:Label = null;
         super();
		 this.im.smoothing = true;
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var bg:TankWindowWithHeader = TankWindowWithHeader.createWindow("РЕГИСТРАЦИЯ");
		 bg.width = 370;
		 bg.height = 340;
         this.callSign = new TankInput();
         this.callSignCheckIcon = new InputCheckIcon();
		 this.invCheckIcon = new InputCheckIcon();
         this.pass1 = new TankInput();
         this.pass2 = new TankInput();
		 this.invite = new TankInput();
         this.chekRemember = new TankCheckBox();
         this.playButton = new DefaultButton();
         this.confirm = new Label();
		 lf.htmlText = "<a href=\'event:log\'><font color=\'#59ff32\'><u>Авторизуйтесь!</u></font></a>";
		 ch.text = "Уже зарегистрированы?";
         addChild(bg);
		 addChild(this.ch);
		 addChild(this.lf);
         addChild(this.callSign);
         addChild(this.callSignCheckIcon);
         addChild(this.pass1);
         addChild(this.pass2);
		 addChild(this.invite);
         addChild(this.invCheckIcon);
         addChild(this.chekRemember);
         addChild(this.playButton);
         addChild(this.confirm);
		 this.rulesButton = new Label();
         this.rulesButton.x = 22;
         this.rulesButton.htmlText = localeService.getText(TextConst.REGISTER_FORM_AGREEMENT_NOTE_TEXT);
		 this.rulesButton.y = 340 - this.rulesButton.height - 22;
		 addChild(this.rulesButton);
		 ///throw new Error(this.rulesButton.width);
		 ch.x = 22;
		 ch.y = 35 - this.ch.height/2;
		 lf.x = ch.width + 22;
		 lf.y = 35 - this.lf.height/2;
         this.callSign.x = 85;
         this.callSign.y = 65;
         this.callSign.maxChars = 30;
         this.callSign.tabIndex = 0;
         this.callSign.restrict = ".0-9a-zA-z_\\-";
         this.callSign.label = localeService.getText(TextConst.REGISTER_FORM_CALLSIGN_INPUT_LABEL_TEXT);
         this.callSign.validValue = true;
		 this.callSign.width = 326 - this.callSign.x + 22;
         this.callSignCheckIcon.x = this.callSign.width + callSignCheckIcon.width;
         this.callSignCheckIcon.y = 70;
         this.callSignState = CALLSIGN_STATE_OFF;
		 this.inState = CALLSIGN_STATE_OFF;
         this.pass1.x = 85;
         this.pass1.y = 97;
         this.pass1.label = localeService.getText(TextConst.REGISTER_FORM_PASSWORD_INPUT_LABEL_TEXT);
         this.pass1.maxChars = 46;
         this.pass1.hidden = true;
         this.pass1.validValue = true;
         this.pass1.tabIndex = 1;
		 this.pass1.width = 326 - this.pass1.x + 22;
         this.pass2.x = 85;
         this.pass2.y = 129;
         this.pass2.label = localeService.getText(TextConst.REGISTER_FORM_REPEAT_PASSWORD_INPUT_LABEL_TEXT);
         this.pass2.maxChars = 46;
         this.pass2.hidden = true;
         this.pass2.validValue = true;
         this.pass2.tabIndex = 2;
		 this.pass2.width = 326 - this.pass2.x + 22;
		 this.invite.x = 85;
         this.invite.y = 161;
         this.invite.tabIndex = 0;
         this.invite.restrict = ".0-9a-zA-z_\\-";
         this.invite.label = "Инвайт:";
         this.invite.validValue = true;
		 this.invite.width = 326 - this.invite.x + 22;
         this.invCheckIcon.x = this.callSignCheckIcon.x;
         this.invCheckIcon.y = 166;
         this.callSignState = CALLSIGN_STATE_OFF;
		 this.inState = CALLSIGN_STATE_OFF;
         this.confirm.visible = false;
         this.confirm.tabEnabled = false;
         this.confirm.x = 30;
         this.confirm.y = 215;
         this.confirm.size = 11;
         this.confirm.text = localeService.getText(TextConst.REGISTER_FORM_CONFIRM_TEXT);
         label = new Label();
         label.x = 113;
         label.y = antiAddictionEnabled?Number(540):Number(200);
         label.text = localeService.getText(TextConst.REGISTER_FORM_REMEMBER_ME_CHECKBOX_LABEL_TEXT);
         addChild(label);
         this.chekRemember.x = 85;
         this.chekRemember.y = antiAddictionEnabled?Number(535):Number(195);
         this.playButton.y = antiAddictionEnabled?Number(535):Number(195);
         this.playButton.label = localeService.getText(TextConst.REGISTER_FORM_BUTTON_PLAY_TEXT);
         this.playButton.enable = false;
		 this.playButton.x = 22 + 326 - this.playButton.width;
		 this.callSign.textField.addEventListener(Event.CHANGE, this.validateCallSign);
		 this.pass1.textField.addEventListener(Event.CHANGE, this.validatePassword);
		 this.pass2.textField.addEventListener(Event.CHANGE, this.validatePassword);
		 this.invite.textField.addEventListener(Event.CHANGE, this.validateInv);
		 this.invite.validValue = false;
         Main.stage.addEventListener(Event.RESIZE,dsf);
      }
      
      public function set callSignState(value:int) : void
      {
         if(value == CALLSIGN_STATE_OFF)
         {
            this.callSignCheckIcon.visible = false;
         }
         else
         {
            this.callSignCheckIcon.visible = true;
            this.callSignCheckIcon.gotoAndStop(value);
         }
      }
	  
	  public function set inState(value:int) : void
      {
         if(value == CALLSIGN_STATE_OFF)
         {
            this.invCheckIcon.visible = false;
         }
         else
         {
            this.invCheckIcon.visible = true;
            this.invCheckIcon.gotoAndStop(value);
         }
      }
	  
	  private function dsf(event:Event) : void
      {
        im.width = Main.stage.stageWidth;
		im.height = Main.stage.stageHeight;
      }
      
      public function switchPlayButton(event:Event) : void
      {
         this.playButton.enable = this.pass1.validValue && this.pass2.validValue && this.callSign.validValue && this.invite.validValue;
      }
      
      private function validatePassword(event:Event) : void
      {
         var verySimplePassword:Boolean = this.pass1.value == this.callSign.value || this.pass1.value == "123" || this.pass1.value == "1234" || this.pass1.value == "12345" || this.pass1.value == "qwerty";
         if(this.pass1.value != this.pass2.value || this.pass1.value == "" || this.pass1.textField.length < 5)
         {
            this.pass2.validValue = false;
         }
         else
         {
            this.pass1.validValue = !verySimplePassword;
            this.pass2.validValue = true;
         }
         this.switchPlayButton(event);
      }
      
      private function validateAddictionID(event:Event) : void
      {
         var l:int = 0;
         if(this.idNumber != null)
         {
            l = this.idNumber.value.length;
            this.idNumber.validValue = l == 18;
         }
      }
      
      private function validateCallSign(event:Event) : void
      {
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])?$/i;
         var result:Array = this.callSign.value.match(pattern);
         this.callSign.validValue = result != null;
         //this.switchPlayButton(null);
      }
	  
	  private function validateInv(event:Event) : void
      {
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])?$/i;
         var result:Array = this.invite.value.match(pattern);
         //this.invite.validValue = ;
      }
      
      public function playButtonActivate() : void
      {
         this.playButton.enable = true;
      }
      
      public function hide() : void
      {
		 this.callSign.textField.removeEventListener(Event.CHANGE, this.validateCallSign);
		 this.pass1.textField.removeEventListener(Event.CHANGE, this.validatePassword);
		 this.pass2.textField.removeEventListener(Event.CHANGE, this.validatePassword);
		 this.invite.textField.removeEventListener(Event.CHANGE, this.validateInv);
      }
      
      private function restoreInput(e:Event) : void
      {
         var trgt:TankInput = e.currentTarget as TankInput;
         trgt.validValue = true;
      }
   }
}
