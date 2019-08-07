package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextFormatAlign;
   
   public class RestoreEmail extends Sprite
   {
       
      
      public var cancelButton:DefaultButton;
      
      public var recoverButton:DefaultButton;
      
      public var email:TankInput;
      
      public function RestoreEmail()
      {
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var bg:TankWindow = new TankWindow(280,185);
         bg.headerLang = localeService.getText(TextConst.GUI_LANG);
         bg.header = TankWindowHeader.RECOVER;
         var label:Label = new Label();
         addChild(bg);
         addChild(label);
         label.multiline = true;
         label.color = 9759338;
         label.size = 11;
         label.align = TextFormatAlign.CENTER;
         label.text = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_HELP_LABEL_TEXT);
         label.x = int(140 - label.width / 2);
         label.y = 25;
         this.cancelButton = new DefaultButton();
         this.recoverButton = new DefaultButton();
         this.email = new TankInput();
         addChild(this.cancelButton);
         addChild(this.recoverButton);
         addChild(this.email);
         this.cancelButton.x = 153;
         this.cancelButton.y = 115;
         this.recoverButton.x = 30;
         this.recoverButton.y = 115;
         this.email.width = 220;
         this.email.x = 30;
         this.email.y = 70;
         this.cancelButton.label = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_BUTTON_CANCEL_TEXT);
         this.recoverButton.label = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_BUTTON_RECOVER_TEXT);
         this.x = 61;
         this.email.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
      }
      
      private function restoreInput(e:Event) : void
      {
         this.email.validValue = true;
      }
   }
}
