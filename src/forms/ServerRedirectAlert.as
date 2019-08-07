package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import flash.text.TextFormatAlign;
   
   public class ServerRedirectAlert extends ServerStopAlert
   {
       
      
      public function ServerRedirectAlert(time:int)
      {
         super(time);
      }
      
      override protected function init() : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         timeLimitLabel.align = TextFormatAlign.CENTER;
         str = localeService.getText(TextConst.REDIRECT_ALERT_TEXT);
         timeLimitLabel.text = getText(str,"88");
         addChild(bg);
         addChild(timeLimitLabel);
         timeLimitLabel.x = PADDING;
         timeLimitLabel.y = PADDING;
         bg.width = timeLimitLabel.width + PADDING * 2;
         bg.height = timeLimitLabel.height + PADDING * 2;
         showCountDown();
      }
   }
}
