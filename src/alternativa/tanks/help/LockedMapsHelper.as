package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class LockedMapsHelper extends BubbleHelper
   {
       
      
      public function LockedMapsHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_BATTLE_SELECT_LOCKED_MAP_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_BATTLE_SELECT_LOCKED_MAP_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.MIDDLE_LEFT;
         _showLimit = 5;
      }
   }
}
