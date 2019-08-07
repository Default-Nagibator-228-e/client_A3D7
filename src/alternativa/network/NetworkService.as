package alternativa.network
{
   import alternativa.network.INetworkListener;
   import alternativa.network.commands.Command;
   import alternativa.network.commands.Type;
   
   public class NetworkService
   {
      
      private static var listeners:Vector.<INetworkListener>;
      
      public static const DELIM_COMMANDS_SYMBOL:String = "end~";
      
      public static const DELIM_ARGUMENTS_SYMBOL:String = ";";
       
      
      private var badRequest:String = "";
      
      public function NetworkService()
      {
         super();
         listeners = new Vector.<INetworkListener>();
      }
      
      public static function getType(str:String) : Type
      {
         var type:Type = null;
         switch(str)
         {
            case "auth":
               type = Type.AUTH;
               break;
            case "registration":
               type = Type.REGISTRATON;
               break;
            case "chat":
               type = Type.CHAT;
               break;
            case "lobby":
               type = Type.LOBBY;
               break;
            case "garage":
               type = Type.GARAGE;
               break;
            case "battle":
               type = Type.BATTLE;
               break;
            case "ping":
               type = Type.PING;
               break;
            case "lobby_chat":
               type = Type.LOBBY_CHAT;
               break;
            default:
               type = Type.UNKNOWN;
         }
         return type;
      }
      
      public function protocolDecrypt(src:String) : void
      {
         var mass:Array = null;
         var tempType:Type = null;
         var args:String = null;
         var i:int = 0;
         var tempCommand:Command = null;
         src = this.badRequest + src;
         var commands:Array = src.split(DELIM_COMMANDS_SYMBOL);
         for(var j:int = 0; j < commands.length - 1; j++)
         {
            mass = commands[j].split(DELIM_ARGUMENTS_SYMBOL);
            tempType = getType(mass[0]);
            if(tempType == null || tempType == Type.UNKNOWN)
            {
               throw new Error("Что то пошло не так  " + mass[0]);
            }
            args = "";
            for(i = 1; i < mass.length; i++)
            {
               args = args + (mass[i] + DELIM_ARGUMENTS_SYMBOL);
            }
            tempCommand = new Command(tempType,args.split(DELIM_ARGUMENTS_SYMBOL),src);
            this.sendRequestToAllListeners(tempCommand);
         }
         this.badRequest = commands[commands.length - 1];
      }
      
      public function endWith(str:String) : Boolean
      {
         return str.charAt(str.length - 1) == DELIM_COMMANDS_SYMBOL;
      }
      
      public function sendRequestToAllListeners(command:Command) : void
      {
         var listener:INetworkListener = null;
         for each(listener in listeners)
         {
            listener.onData(command);
         }
      }
      
      public function addListener(listener:INetworkListener) : void
      {
         listeners.push(listener);
      }
      
      public function removeListener(listener:INetworkListener) : void
      {
         var list:INetworkListener = null;
         var index:int = 0;
         for each(list in listeners)
         {
            if(list == listener)
            {
               break;
            }
            index++;
         }
         listeners.splice(index,1);
      }
	  
	  public function removeListeners() : void
      {
         listeners = new Vector.<INetworkListener>();
      }
	  
      private function getArray(... args) : Array
      {
         var array:Array = new Array(args);
         return array;
      }
   }
}
