package forms
{
   import alternativa.init.Main;
   import controls.DefaultButton;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.ui.Keyboard;
   import forms.events.LoginFormEvent;
   
   public class LoginForm extends Sprite
   {
       
      
      private var _state:Boolean = false;
      
      public var checkPassword:CheckPassword;
      
      public var registerForm:RegisterForm;
      
      private var _restoreEmailForm:RestoreEmail;
      
      private var antiAddictionEnabled:Boolean = false;
      
      public function LoginForm(antiAddictionEnabled:Boolean)
      {
         this.checkPassword = new CheckPassword();
         this._restoreEmailForm = new RestoreEmail();
         super();
         this.antiAddictionEnabled = antiAddictionEnabled;
         this.registerForm = new RegisterForm(antiAddictionEnabled);
         if(antiAddictionEnabled)
         {
            this.registerForm.y = -110;
         }
		 addChild(this.registerForm.im);
         addChild(this.registerForm);
         addChild(this.checkPassword);
         addChild(this._restoreEmailForm);
         this.checkPassword.visible = false;
         this.registerForm.visible = true;
         this._restoreEmailForm.visible = false;
         this.checkPassword.playButton.addEventListener(MouseEvent.CLICK,this.playClick);
         this.registerForm.playButton.addEventListener(MouseEvent.CLICK,this.playClick);
         this.checkPassword.password.addEventListener(KeyboardEvent.KEY_DOWN,this.playClickKey);
         this.registerForm.rulesButton.addEventListener(TextEvent.LINK, this.onRules);
		 this.registerForm.lf.addEventListener(TextEvent.LINK,this.onP);
         this.checkPassword.registerButton.addEventListener(MouseEvent.CLICK,this.switchState);
         //this.registerForm.loginButton.addEventListener(MouseEvent.CLICK,this.switchState);
         addEventListener(Event.ADDED_TO_STAGE, this.Init);
		 this.addEventListener(LoginFormEvent.CHANGE_STATE, doLayout);
      }
      
      public function get loginState() : Boolean
      {
         return this._state;
      }
      
      public function set loginState(value:Boolean) : void
      {
         this._state = !value;
         this.switchState(null);
      }
      
      public function get callSign() : String
      {
         return this._state?this.checkPassword.callSign.value:this.registerForm.callSign.value;
      }
      
      public function set callSign(value:String) : void
      {
         this.checkPassword.callSign.value = value;
         if(stage != null)
         {
         }
      }
      
      public function get mainPassword() : String
      {
         return this.checkPassword.password.value;
      }
      
      public function get pass1() : String
      {
         return this.registerForm.pass1.value;
      }
      
      public function get pass2() : String
      {
         return this.registerForm.pass2.value;
      }
      
      public function get realName() : String
      {
         if(this.registerForm.realName != null)
         {
            return this.registerForm.realName.value;
         }
         return null;
      }
      
      public function get idNumber() : String
      {
         if(this.registerForm.idNumber != null)
         {
            return this.registerForm.idNumber.value;
         }
         return null;
      }
      
      public function get remember() : Boolean
      {
         return this._state?Boolean(this.checkPassword.checkRemember.checked):Boolean(this.registerForm.chekRemember.checked);
      }
      
      public function set remember(value:Boolean) : void
      {
         this.checkPassword.checkRemember.checked = value;
      }
      
      public function get email() : String
      {
         return null;//!!this.registerForm.confirm.visible?this.registerForm.email.value:null;
      }
      
      public function get restoreEmail() : String
      {
         return this._restoreEmailForm.email.value;
      }
      
      public function clearPassword() : void
      {
         this.checkPassword.password.clear();
      }
      
      private function Init(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.Init);
         Main.stage.addEventListener(Event.RESIZE,this.doLayout);
         this.doLayout(null);
         this.loginState = !this._state;
      }
      
      private function switchState(e:MouseEvent) : void
      {
         this._state = !this._state;
         this.checkPassword.visible = this._state;
         this.registerForm.visible = !this._state;
		 doLayout(null);
         if(stage != null)
         {
            if(this._state)
            {
               stage.focus = this.checkPassword.callSign.textField.length == 0?this.checkPassword.callSign.textField:this.checkPassword.password.textField;
            }
            else
            {
               stage.focus = this.registerForm.callSign.textField;
            }
         }
         dispatchEvent(new LoginFormEvent(LoginFormEvent.CHANGE_STATE));
      }
      
      private function onRules(e:TextEvent) : void
      {
         if(e.text == "rules")
         {
			//throw new Error("");
			addChild(new WindowCondition(Main.stage, 0));
            dispatchEvent(new LoginFormEvent(LoginFormEvent.SHOW_RULES));
         }
         else
         {
            dispatchEvent(new LoginFormEvent(LoginFormEvent.SHOW_TERMS));
         }
      }
	  
	  private function onP(e:TextEvent) : void
      {
         if(e.text == "log")
         {
			this.loginState = true;
         }
      }
      
      private function doLayout(e:Event) : void
      {
		 if (this.checkPassword.visible)
		 {
			this.registerForm.im.visible = false;
			this.x = Main.stage.stageWidth/2 - this.checkPassword.width/2;
			this.y = Main.stage.stageHeight / 2 - this.checkPassword.height / 2;
		 }
		 if (this.registerForm.visible)
		 {
			this.registerForm.im.visible = true;
			this.x = 0;
			this.y = 0;
			this.registerForm.x = Main.stage.stageWidth/2 - 370/2;
			this.registerForm.y = Main.stage.stageHeight / 2 - this.registerForm.height / 2;
			this.registerForm.im.width = Main.stage.stageWidth;
			this.registerForm.im.height = Main.stage.stageHeight;
		 }
		 if (this._restoreEmailForm.visible)
		 {
			this.registerForm.im.visible = false;
			this.x = Main.stage.stageWidth/2 - 280/2;
			this.y = Main.stage.stageHeight / 2 - this._restoreEmailForm.height / 2;
		 }
      }
      
      private function playClick(event:MouseEvent) : void
      {
         var trgt:DefaultButton = event.currentTarget as DefaultButton;
         trgt.enable = false;
         dispatchEvent(new LoginFormEvent(LoginFormEvent.PLAY_PRESSED));
      }
      
      private function playClickKey(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new LoginFormEvent(LoginFormEvent.PLAY_PRESSED));
         }
      }
      
      public function showRestoreForm() : void
      {
         this.checkPassword.visible = false;
         this._restoreEmailForm.visible = true;
         this._restoreEmailForm.email.validValue = true;
         this._restoreEmailForm.cancelButton.addEventListener(MouseEvent.CLICK,this.clickRestoreForm);
         this._restoreEmailForm.recoverButton.addEventListener(MouseEvent.CLICK, this.clickRestoreForm);
		 this.hideRestoreForm();
      }
      
      public function invalidRestoreForm() : void
      {
         this._restoreEmailForm.email.validValue = false;
      }
      
      public function clickRestoreForm(e:MouseEvent) : void
      {
         if(e.currentTarget == this._restoreEmailForm.recoverButton)
         {
            dispatchEvent(new LoginFormEvent(LoginFormEvent.RESTORE_PRESSED));
         }
         else
         {
            this.hideRestoreForm();
         }
      }
      
      public function hideRestoreForm() : void
      {
         this.checkPassword.visible = true;
         this._restoreEmailForm.visible = false;
         this.loginState = true;
         this._restoreEmailForm.cancelButton.removeEventListener(MouseEvent.CLICK,this.clickRestoreForm);
         this._restoreEmailForm.recoverButton.removeEventListener(MouseEvent.CLICK,this.clickRestoreForm);
      }
      
      public function hide() : void
      {
         stage.removeEventListener(Event.RESIZE,this.doLayout);
         this.checkPassword.playButton.removeEventListener(MouseEvent.CLICK,this.playClick);
         this.registerForm.playButton.removeEventListener(MouseEvent.CLICK,this.playClick);
         this.checkPassword.registerButton.removeEventListener(MouseEvent.CLICK,this.switchState);
         //this.registerForm.loginButton.removeEventListener(MouseEvent.CLICK,this.switchState);
         this.checkPassword.password.removeEventListener(KeyboardEvent.KEY_DOWN, this.playClickKey);
		 this.registerForm.lf.removeEventListener(TextEvent.LINK,this.onP);
         this.registerForm.hide();
		 removeChild(this.registerForm.im);
         removeChild(this.registerForm);
         removeChild(this.checkPassword);
         removeChild(this._restoreEmailForm);
      }
   }
}
