package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class MainMenuHelper extends BubbleHelper
   {
       
      
      public function MainMenuHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_PANEL_MAIN_MENU_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_PANEL_MAIN_MENU_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_CENTER;
         _showLimit = 3;
         _targetPoint.y = 25;
      }
   }
}
