package alternativa.tanks.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class CreateMapHelper extends BubbleHelper
   {
       
      
      public function CreateMapHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_BATTLE_SELECT_CREATE_MAP_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_BATTLE_SELECT_CREATE_MAP_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.BOTTOM_RIGHT;
         _showLimit = 3;
      }
   }
}
