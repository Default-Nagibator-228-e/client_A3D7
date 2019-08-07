package alternativa.tanks.models.battlefield.gui.help
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.help.Helper;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.HelpWindow;
   
   public class ControlsHelper extends Helper
   {
      
      public static const GROUP_ID:String = "Tank.ControlsHelper";
      
      public static const HELPER_ID:int = 1;
       
      
      private var helpWindow:HelpWindow;
      
      public function ControlsHelper()
      {
         super();
         this.init();
      }
      
      override public function align(stageWidth:int, stageHeight:int) : void
      {
         this.helpWindow.x = (stageWidth - this.helpWindow.width) / 2;
         this.helpWindow.y = (stageHeight - this.helpWindow.height) / 2;
      }
      
      private function init() : void
      {
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.helpWindow = new HelpWindow(localeService.getText(TextConst.GUI_LANG));
         this.helpWindow.mouseEnabled = false;
         addChild(this.helpWindow);
         _showLimit = 10;
      }
   }
}
