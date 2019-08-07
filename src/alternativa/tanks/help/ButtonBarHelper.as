package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class ButtonBarHelper extends BubbleHelper
   {
       
      
      public function ButtonBarHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_PANEL_BUTTON_BAR_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_PANEL_BUTTON_BAR_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_RIGHT;
         _showLimit = 3;
         _targetPoint.y = 25;
      }
   }
}
