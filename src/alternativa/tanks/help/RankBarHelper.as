package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class RankBarHelper extends BubbleHelper
   {
       
      
      public function RankBarHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_PANEL_RANK_BAR_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_PANEL_RANK_BAR_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_LEFT;
         _showLimit = 3;
         _targetPoint.x = 94;
         _targetPoint.y = 25;
      }
   }
}
