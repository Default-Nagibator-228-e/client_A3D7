package alternativa.network.handler
{
   import alternativa.debug.IDebugCommandProvider;
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import alternativa.network.AlternativaNetworkClient;
   import alternativa.network.ICommandHandler;
   import alternativa.network.ICommandSender;
   import alternativa.network.command.ControlCommand;
   import alternativa.network.command.SpaceCommand;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.loader.ILoaderService;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.network.INetworkListener;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.protocol.Protocol;
   import alternativa.protocol.codec.ICodec;
   import alternativa.protocol.codec.NullMap;
   import alternativa.register.ClassInfo;
   import alternativa.register.ClientClass;
   import alternativa.register.SpaceInfo;
   import alternativa.resource.BatchLoaderManager;
   import alternativa.resource.BatchResourceLoader;
   import alternativa.resource.IResource;
   import alternativa.resource.ResourceInfo;
   import alternativa.service.DummyLogService;
   import alternativa.service.IClassService;
   import alternativa.service.IModelService;
   import alternativa.service.IProtocolService;
   import alternativa.service.IResourceService;
   import alternativa.service.ISpaceService;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   
   public class ControlCommandHandler implements ICommandHandler, INetworkService
   {
       
      
      private var sender:ICommandSender;
      
      private var hashCode:ByteArray;
      
      private var _modelRegister:IModelService;
      
      private var _resourceRegister:IResourceService;
      
      private var _spaceRegister:ISpaceService;
      
      private var spaceClient:AlternativaNetworkClient;
      
      private var batchLoaderManager:BatchLoaderManager;
      
      private var _server:String;
      
      private var _port:int;
      
      private var _proxyHost:String;
      
      private var _proxyPort:int;
      
      private var connected:Boolean = false;
      
      private var _ports:Array;
      
      private var _resourcesPath:String;
      
      private var listeners:Vector.<INetworkListener>;
      
      private var closed:Boolean = false;
      
      private const pingDelay:int = 60000;
      
      private var pingTimer:Timer;
      
      public function ControlCommandHandler(_server:String)
      {
         super();
         this.listeners = new Vector.<INetworkListener>();
         this._server = _server;
         this._resourceRegister = IResourceService(Main.osgi.getService(IResourceService));
         this._modelRegister = IModelService(Main.osgi.getService(IModelService));
         this._spaceRegister = ISpaceService(Main.osgi.getService(ISpaceService));
         var spaceProtocol:Protocol = new Protocol(Main.codecFactory,SpaceCommand);
         this.spaceClient = new AlternativaNetworkClient(_server,spaceProtocol);
         var networkService:INetworkService = Main.osgi.getService(INetworkService) as INetworkService;
         _server = networkService.server;
         this._ports = networkService.ports;
         this._proxyHost = networkService.proxyHost;
         this._proxyPort = networkService.proxyPort;
         this._resourcesPath = networkService.resourcesPath;
         Main.osgi.unregisterService(INetworkService);
         Main.osgi.registerService(INetworkService,this);
      }
      
      public function open() : void
      {
         IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("CONTROLCMD","socket open");
         this.connected = true;
         var loadingProgressId:int = 0;
         var loaderService:ILoaderService = Main.osgi.getService(ILoaderService) as ILoaderService;
         loaderService.loadingProgress.setProgress(loadingProgressId,1);
         loaderService.loadingProgress.stopProgress(loadingProgressId);
         var ports:Array = INetworkService(Main.osgi.getService(INetworkService)).ports;
         this.port = ports[Main.currentPortIndex];
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.port = this._port;
         IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsole("ControlCommandHandler socket opened");
         for(var i:int = 0; i < this.listeners.length; i++)
         {
            INetworkListener(this.listeners[i]).connect();
         }
         this.sender.sendCommand(new ControlCommand(ControlCommand.HASH_REQUEST,"hashRequest",new Array()),false);
         this.pingTimer = new Timer(this.pingDelay,int.MAX_VALUE);
         this.pingTimer.addEventListener(TimerEvent.TIMER,this.ping);
         this.pingTimer.start();
      }
      
      private function ping(e:TimerEvent) : void
      {
         this.sender.sendCommand(new ControlCommand(ControlCommand.LOG,"log",[LogLevel.LOG_INFO,"ping"]));
      }
      
      public function close() : void
      {
         IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("CONTROLCMD","socket closed");
         this.pingTimer.stop();
         this.pingTimer.removeEventListener(TimerEvent.TIMER,this.ping);
         this.pingTimer = null;
         this.registerDummyLogService();
         for(var i:int = 0; i < this.listeners.length; i++)
         {
            INetworkListener(this.listeners[i]).disconnect();
         }
         var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
         alertService.showAlert("Connection to server " + this._server + " closed");
         this.closed = true;
      }
      
      public function disconnect(errorMessage:String) : void
      {
         var alertService:IAlertService = null;
         IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("CONTROLCMD","socket disconnect");
         this.registerDummyLogService();
         if(!this.connected)
         {
            //Main.tryNextPort();
         }
         else if(!this.closed)
         {
            alertService = Main.osgi.getService(IAlertService) as IAlertService;
            alertService.showAlert("Connection to server " + this._server + " failed. ERROR: " + errorMessage);
         }
      }
      
      private function registerDummyLogService() : void
      {
         Main.osgi.unregisterService(ILogService);
         Main.osgi.registerService(ILogService,new DummyLogService());
      }
      
      public function executeCommand(commandsList:Object) : void
      {
         var command:Object = null;
         var controlCommand:ControlCommand = null;
         var handler:ICommandHandler = null;
         var spaceSocket:ICommandSender = null;
         var info:SpaceInfo = null;
         var batchId:int = 0;
         var resources:Array = null;
         var request:String = null;
         var type:int = 0;
         Main.writeToConsole("ControlCommandHandler executeCommand");
         var commands:Array = commandsList as Array;
         var len:int = commands.length;
         for(var i:int = 0; i < len; i++)
         {
            command = commands[i];
            if(command is ByteArray)
            {
               if(this.hashCode == null)
               {
                  this.hashCode = command as ByteArray;
                  this.hashCode.position = 0;
                  Main.writeToConsole("Hash принят (" + this.hashCode.bytesAvailable + " bytes)",204);
                  this.sender.sendCommand(new ControlCommand(ControlCommand.HASH_ACCEPT,"hashAccepted",new Array()),false);
               }
            }
            else if(command is ControlCommand)
            {
               controlCommand = ControlCommand(command);
               Main.writeToConsole("     id: " + controlCommand.id);
               Main.writeToConsole("   name: " + controlCommand.name);
               Main.writeToConsole(" params: " + controlCommand.params);
               switch(controlCommand.id)
               {
                  case ControlCommand.OPEN_SPACE:
                     handler = new SpaceCommandHandler(this.hashCode);
                     spaceSocket = ICommandSender(this.spaceClient.newConnection(this._port,handler));
                     info = new SpaceInfo(handler,spaceSocket,SpaceCommandHandler(handler).objectRegister);
                     ISpaceService(Main.osgi.getService(ISpaceService)).addSpace(info);
                     break;
                  case ControlCommand.LOAD_RESOURCES:
                     batchId = int(controlCommand.params[0]);
                     resources = controlCommand.params[1] as Array;
                     this.dumpResourcesToConsole(batchId,resources);
                     this.batchLoaderManager.addLoader(new BatchResourceLoader(batchId,resources));
                     break;
                  case ControlCommand.UNLOAD_CLASSES_AND_RESOURCES:
                     this.unloadClasses(controlCommand.params[0] as Array);
                     this.unloadResources(controlCommand.params[1] as Array);
                     break;
                  case ControlCommand.COMMAND_REQUEST:
                     request = String(controlCommand.params[0]);
                     this.sender.sendCommand(new ControlCommand(ControlCommand.COMMAND_RESPONCE,"commandResponce",[IDebugCommandProvider(Main.debug).executeCommand(request)]));
                     break;
                  case ControlCommand.SERVER_MESSAGE:
                     type = int(controlCommand.params[0]);
                     Main.debug.showServerMessageWindow(String(controlCommand.params[1]));
                     break;
                  case ControlCommand.LOAD_CLASSES:
                     this.loadClasses(controlCommand);
               }
            }
         }
      }
      
      public function set port(value:int) : void
      {
         this._port = value;
      }
      
      public function get commandSender() : ICommandSender
      {
         return this.sender;
      }
      
      public function set commandSender(sender:ICommandSender) : void
      {
         Main.writeToConsole("ControlCommandHandler set sender: " + sender);
         this.sender = sender;
         this.batchLoaderManager = new BatchLoaderManager(2,sender);
      }
      
      public function addEventListener(listener:INetworkListener) : void
      {
         var index:int = this.listeners.indexOf(listener);
         if(index == -1)
         {
            this.listeners.push(listener);
         }
      }
      
      public function removeEventListener(listener:INetworkListener) : void
      {
         var index:int = this.listeners.indexOf(listener);
         if(index != -1)
         {
            this.listeners.splice(index,1);
         }
      }
      
      public function get server() : String
      {
         return this._server;
      }
      
      public function get ports() : Array
      {
         return this._ports;
      }
      
      public function get resourcesPath() : String
      {
         return this._resourcesPath;
      }
      
      public function get proxyHost() : String
      {
         return this._proxyHost;
      }
      
      public function get proxyPort() : int
      {
         return this._proxyPort;
      }
      
      private function unloadClasses(id:Array) : void
      {
         var classRegister:IClassService = null;
         var length:uint = id.length;
         for(var i:uint = 0; i < length; i++)
         {
            classRegister = IClassService(Main.osgi.getService(IClassService));
            classRegister.destroyClass(id[i]);
         }
      }
      
      private function unloadResources(resources:Array) : void
      {
         var resource:IResource = null;
         var resourceRegister:IResourceService = null;
         var length:uint = resources.length;
         for(var i:uint = 0; i < length; i++)
         {
            resourceRegister = IResourceService(Main.osgi.getService(IResourceService));
            resource = resourceRegister.getResource(ResourceInfo(resources[i]).id);
            resource.unload();
            resourceRegister.unregisterResource(ResourceInfo(resources[i]).id);
         }
      }
      
      private function dumpResourcesToConsole(batchId:int, resources:Array) : void
      {
         var len:int = 0;
         var j:int = 0;
         Main.writeVarsToConsole("\n[ControlCommandHandler.executeCommand] LOAD [%1]",batchId);
         for(var i:int = 0; i < resources.length; i++)
         {
            len = (resources[i] as Array).length;
            for(j = 0; j < len; j++)
            {
               Main.writeToConsole("[ControlCommandHandler.executeCommand] load resource id: " + ResourceInfo(resources[i][j]).id);
            }
         }
      }
      
      private function loadClasses(controlCommand:ControlCommand) : void
      {
         var logger:ILogService = null;
         var classInfo:ClassInfo = null;
         var classRegister:IClassService = null;
         var clientClass:ClientClass = null;
         var models:Vector.<String> = null;
         var numModels:int = 0;
         var m:int = 0;
         var modelId:String = null;
         var model:IModel = null;
         var paramsCodec:ICodec = null;
         var map:NullMap = null;
         var mapString:String = null;
         var modelParams:Object = null;
         var processId:int = int(controlCommand.params[0]);
         var classInfoArray:Array = controlCommand.params[1] as Array;
         Main.writeVarsToConsoleChannel("LOAD CLASSES","ControlCommandHandler LOAD_CLASSES");
         var reader:IDataInput = IDataInput(controlCommand.params[2]);
         var nullMap:NullMap = NullMap(controlCommand.params[3]);
         logger = Main.osgi.getService(ILogService) as ILogService;
         for(var c:int = 0; c < classInfoArray.length; c++)
         {
            classInfo = ClassInfo(classInfoArray[c]);
            Main.writeVarsToConsoleChannel("LOAD CLASSES","   class id: " + classInfo.id);
            classRegister = IClassService(Main.osgi.getService(IClassService));
            if(classInfo.modelsToAdd != null)
            {
               Main.writeVarsToConsoleChannel("LOAD CLASSES","   modelsToAdd: " + classInfo.modelsToAdd);
            }
            if(classInfo.modelsToRemove != null)
            {
               Main.writeVarsToConsoleChannel("LOAD CLASSES","   modelsToRemove: " + classInfo.modelsToRemove);
            }
            models = clientClass.models;
            Main.writeVarsToConsoleChannel("LOAD CLASSES","   models: " + models);
            numModels = models.length;
            for(m = 0; m < numModels; m++)
            {
               modelId = models[m];
               model = this._modelRegister.getModel(modelId);
               paramsCodec = IProtocolService(Main.osgi.getService(IProtocolService)).codecFactory.getCodec(this._modelRegister.getModelsParamsStruct(modelId));
               if(paramsCodec != null)
               {
                  try
                  {
                     Main.writeVarsToConsoleChannel("LOAD CLASSES","decode modelParams");
                     map = nullMap.clone();
                     mapString = "";
                     while(map.hasNextBit())
                     {
                        mapString = mapString + (!!map.getNextBit()?"1":"0");
                     }
                     Main.writeVarsToConsoleChannel("LOAD CLASSES","   nullMap: " + mapString);
                     Main.writeVarsToConsoleChannel("LOAD CLASSES"," ");
                     modelParams = paramsCodec.decode(reader,nullMap,false);
                  }
                  catch(e:Error)
                  {
                     logger.log(LogLevel.LOG_ERROR,"[ControlCommandHandler.executeCommand] Error on model params decoding: " + e.toString() + " " + e.getStackTrace());
                     Main.writeVarsToConsoleChannel("LOAD CLASSES","Error on model params decoding. classInfo.name: " + classInfo.name + "\n" + e.toString());
                  }
                  if(modelParams != null)
                  {
                     Main.writeVarsToConsoleChannel("LOAD CLASSES","   model " + modelId + " params: " + modelParams);
                     clientClass.setModelParams(modelId,modelParams);
                  }
               }
            }
            Main.writeToConsole(clientClass.toString());
         }
         this.sender.sendCommand(new ControlCommand(ControlCommand.CLASSES_LOADED,"classesLoaded",[processId]));
      }
   }
}
