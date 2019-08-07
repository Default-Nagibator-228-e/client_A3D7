package alternativa.network.handler
{
   import alternativa.init.Main;
   import alternativa.network.ICommandHandler;
   import alternativa.network.ICommandSender;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.protocol.codec.NullMap;
   import alternativa.register.ClientClass;
   import alternativa.register.ObjectRegister;
   import alternativa.register.SpaceInfo;
   import alternativa.service.IModelService;
   import alternativa.service.ISpaceService;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   
   public class SpaceCommandHandler implements ICommandHandler
   {
      
      private static const CHANNEL:String = "SPACECMD";
       
      
      private var sender:ICommandSender;
      
      private var hashCode:ByteArray;
      
      private var librariesPath:String;
      
      private var modelRegister:IModelService;
      
      private var _objectRegister:ObjectRegister;
      
      private var pingTimer:Timer;
      
      private const pingDelay:int = 60000;
      
      public function SpaceCommandHandler(hashCode:ByteArray)
      {
         super();
         this.hashCode = hashCode;
         this.modelRegister = IModelService(Main.osgi.getService(IModelService));
         this.librariesPath = INetworkService(Main.osgi.getService(INetworkService)).resourcesPath;
         this._objectRegister = new ObjectRegister(this);
         var models:Vector.<String> = new Vector.<String>();
         models.push("");
         var rootObjectClass:ClientClass = new ClientClass("",null,"rootObjectClass",models);
      }
      
      public function open() : void
      {
         if(this.sender != null)
         {
            this.sender.sendCommand(Object(this.hashCode),false);
            this.pingTimer = new Timer(this.pingDelay,int.MAX_VALUE);
            this.pingTimer.addEventListener(TimerEvent.TIMER,this.ping);
            this.pingTimer.start();
         }
      }
      
      private function ping(e:TimerEvent) : void
      {
         if(this.sender != null)
         {
            this.sender.sendCommand(0,false);
         }
      }
      
      public function close() : void
      {
         var object:ClientObject = null;
         var s:SpaceInfo = null;
         Main.writeVarsToConsoleChannel(CHANNEL,"SPACE CLOSED: sender id=%1",this.sender.id);
         if(this.pingTimer != null)
         {
            this.pingTimer.stop();
            this.pingTimer.removeEventListener(TimerEvent.TIMER,this.ping);
            this.pingTimer = null;
         }
         while(this._objectRegister.objectsList.length > 0)
         {
            object = ClientObject(this._objectRegister.objectsList[0]);
         }
         var spaceService:ISpaceService = ISpaceService(Main.osgi.getService(ISpaceService));
         var spaces:Array = spaceService.spaceList;
         for(var i:int = 0; i < spaces.length; i++)
         {
            s = SpaceInfo(spaces[i]);
            if(s.objectRegister == this._objectRegister)
            {
               spaceService.removeSpace(s);
            }
         }
         this._objectRegister = null;
         this.sender = null;
      }
      
      public function disconnect(errorMessage:String) : void
      {
         Main.writeVarsToConsoleChannel(CHANNEL,"SPACE DISCONNECT");
         if(this._objectRegister != null)
         {
            this.close();
         }
      }
      
      public function executeCommand(command:Object) : void
      {
         var data:IDataInput = IDataInput(command[0]);
         var nullMap:NullMap = NullMap(command[1]);
      }
      
      public function get commandSender() : ICommandSender
      {
         return this.sender;
      }
      
      public function set commandSender(sender:ICommandSender) : void
      {
         this.sender = sender;
      }
      
      public function get objectRegister() : ObjectRegister
      {
         return this._objectRegister;
      }
   }
}
