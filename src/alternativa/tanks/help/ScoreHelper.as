package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class ScoreHelper extends BubbleHelper
   {
       
      
      public function ScoreHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_PANEL_SCORE_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_PANEL_SCORE_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_LEFT;
         _showLimit = 3;
         _targetPoint.x = 79;
         _targetPoint.y = 25;
      }
   }
}
