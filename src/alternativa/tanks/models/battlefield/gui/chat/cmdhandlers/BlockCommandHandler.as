package alternativa.tanks.models.battlefield.gui.chat.cmdhandlers
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.models.battlefield.gui.chat.BattleChatOutput;
   import forms.Chat;
   import forms.Communic;
   
   public class BlockCommandHandler implements IChatCommandHandler
   {
       
      
      private var output:BattleChatOutput;
      
      public function BlockCommandHandler(output:BattleChatOutput)
      {
         super();
         this.output = output;
      }
      
      public function handleCommand(args:Array) : Boolean
      {
         if(args.length == 0)
         {
            return false;
         }
         var userName:String = args[0];
         Chat.blockUser(userName);
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.output.addSystemMessage(localeService.getText(TextConst.CHAT_PANEL_COMMAND_BLOCK,userName));
         return true;
      }
   }
}
