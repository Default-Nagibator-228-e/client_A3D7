package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class RatingIndicatorHelper extends BubbleHelper
   {
       
      
      public function RatingIndicatorHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_PANEL_RATING_INDICATOR_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_PANEL_RATING_INDICATOR_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_CENTER;
         _showLimit = 3;
         _targetPoint.x = 281;
         _targetPoint.y = 25;
      }
   }
}
