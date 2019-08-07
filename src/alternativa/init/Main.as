package alternativa.init
{
   import alternativa.console.Console;
   import alternativa.console.IConsole;
   import alternativa.debug.Debug;
   import alternativa.debug.dump.ClassDumper;
   import alternativa.debug.dump.ModelDumper;
   import alternativa.debug.dump.ObjectDumper;
   import alternativa.debug.dump.ResourceDumper;
   import alternativa.debug.dump.SpaceDumper;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import utils.client.models.general.dispatcher.DispatcherModel;
   import alternativa.network.AlternativaNetworkClient;
   import alternativa.network.CommandSocket;
   import alternativa.network.command.ControlCommand;
   import alternativa.network.command.SpaceCommand;
   import alternativa.network.handler.ControlCommandHandler;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.debug.IDebugService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.loader.ILoaderService;
   import alternativa.osgi.service.loader.LoadingProgress;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.protocol.Protocol;
   import alternativa.protocol.codec.ClassCodec;
   import alternativa.protocol.codec.ControlRootCodec;
   import alternativa.protocol.codec.ResourceCodec;
   import alternativa.protocol.codec.SpaceRootCodec;
   import alternativa.protocol.factory.CodecFactory;
   import alternativa.protocol.factory.ICodecFactory;
   import alternativa.register.ClassInfo;
   import alternativa.register.ClassRegister;
   import alternativa.register.ModelsRegister;
   import alternativa.register.ResourceRegister;
   import alternativa.register.SpaceRegister;
   import alternativa.resource.ResourceInfo;
   import alternativa.resource.ResourceType;
   import alternativa.resource.ResourceWrapper;
   import alternativa.resource.factory.ImageResourceFactory;
   import alternativa.resource.factory.LibraryResourceFactory;
   import alternativa.resource.factory.MovieClipResourceFactory;
   import alternativa.resource.factory.SoundResourceFactory;
   import alternativa.service.AddressService;
   import alternativa.service.DummyLogService;
   import alternativa.service.IAddressService;
   import alternativa.service.IClassService;
   import alternativa.service.IModelService;
   import alternativa.service.IProtocolService;
   import alternativa.service.IResourceService;
   import alternativa.service.ISpaceService;
   import alternativa.service.Logger;
   import alternativa.service.ProtocolService;
   import alternativa.service.ServerLogService;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.types.Long;
   import alternativa.types.LongFactory;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.net.SharedObject;
   import utils.SWFAddressEvent;
   
   public class Main implements IBundleActivator
   {
      
      public static var stage:Stage;
      
      public static var mainContainer:DisplayObjectContainer;
      
      public static var backgroundLayer:DisplayObjectContainer;
      
      public static var contentLayer:DisplayObjectContainer;
      
      public static var contentUILayer:DisplayObjectContainer;
      
      public static var systemLayer:DisplayObjectContainer;
      
      public static var systemUILayer:DisplayObjectContainer;
      
      public static var dialogsLayer:DisplayObjectContainer;
      
      public static var noticesLayer:DisplayObjectContainer;
      
      public static var cursorLayer:DisplayObjectContainer;
      
      public static var controlHandler:ControlCommandHandler;
      
      public static var codecFactory:ICodecFactory;
      
      public static var loadingProgress:LoadingProgress;
      
      public static var debug:Debug;
      
      public static var osgi:OSGi;
      
      public static var currentPortIndex:int;
      
      public static var logger:ILogService;
      
      private static const SHOW_LOG_MSGS:String = "show_log_msgs";
      
      private static const SHOW_ALL_LOG_MSGS:String = "show_all_log_msgs";
      
      private static var controlSocket:CommandSocket;
      
      private static var networkClient:AlternativaNetworkClient;
	  
	  private static var blurBmp:Bitmap;
      
      private static var blurBmpContainer:Sprite;
	  
	  private static var blurBmpContainer1:Sprite = new Sprite();
      
      public static var blured:Boolean;
	  
	  private static var bg:Shape;
	  
	  public static var sl:Array = new Array();
	  
	  private static var bl:int = 0;
	  
	  public static var bbq:Boolean = false;
      
      public function Main()
      {
         super();
		 bg = new Shape();
         blurBmpContainer = new Sprite();
         blurBmp = new Bitmap();
		 blurBmp.smoothing = true;
         blurBmpContainer.addChild(blurBmp);
         blurBmpContainer.mouseEnabled = true;
		 var ge:Bitmap = new Bitmap(new BitmapData(2048, 2048, false, 0));
		 ge.alpha = 0.5;
		 blurBmpContainer.addChild(ge);
		 blurBmpContainer1.addChild(blurBmp);
         blurBmpContainer1.mouseEnabled = true
		 var ge1:Bitmap = new Bitmap(new BitmapData(2048, 2048, false, 0));
		 ge1.alpha = 0.5;
		 blurBmpContainer1.addChild(ge1);
		 //mainPanel.buttonBar.addButton.visible = false;
         blured = false;
      }
      
      public static function writeToConsole(message:String, color:uint = 0) : void
      {
      }
      
      public static function writeVarsToConsole(message:String, ... vars) : void
      {
         for(var i:int = 0; i < vars.length; i++)
         {
            message = message.replace("%" + (i + 1),vars[i]);
         }
      }
	  
	  public static function blur3() : void
      {
         var minWidth:int = 0;
         var minHeight:int = 0;
         var bd:BitmapData = null;
         if(!blured)
         {
            minWidth = Math.max(Main.stage.stageWidth,100);
            minHeight = Math.max(Main.stage.stageHeight,60);
            bd = new BitmapData(minWidth,minHeight,false,0);
            //bd.draw(Lobby(Main.osgi.getService(ILobby)).garage.garageModel.garageWindow.tankPreview.camera.view.stage);
            blurBmp.bitmapData = bd;
			blurBmp.alpha = 0;
            Main.contentLayer.addChild(blurBmpContainer1);
            Main.stage.addEventListener(Event.RESIZE,resizeBlur);
            resizeBlur();
            blured = true;
			bbq = true;
         }
      }
	  
	  public static function blur() : void
      {
         var minWidth:int = 0;
         var minHeight:int = 0;
         var bd:BitmapData = null;
         //if(!this.blured)
         //{
            minWidth = Math.max(Main.stage.stageWidth,100);
            minHeight = Math.max(Main.stage.stageHeight,60);
            bd = new BitmapData(minWidth,minHeight,false,0);
            //bd.draw(Lobby(Main.osgi.getService(ILobby)).garage.garageModel.garageWindow.tankPreview.camera.view.stage);
            blurBmp.bitmapData = bd;
			blurBmp.alpha = 0;
			if (Main.contentLayer.contains(blurBmpContainer1))
			{
				blurBmpContainer1.visible = false;
			}
            Main.dialogsLayer.addChild(blurBmpContainer);
			sl.push(Main.dialogsLayer.getChildIndex(blurBmpContainer));
			bl++;
            Main.stage.addEventListener(Event.RESIZE,resizeBlur);
            resizeBlur();
            blured = true;
         //}
      }
      
      private static function resizeBlur(e:Event = null) : void
      {
		 blurBmp.width = Math.max(Main.stage.stageWidth,100);
         blurBmp.height = Math.max(Main.stage.stageHeight,60);
      }
      
      public static function unblur() : void
      {
         //if(this.blured)
         //{
			//throw new Error("1");
			if (Main.dialogsLayer.contains(blurBmpContainer))
			{
				if (bl == 1)
				{
					Main.dialogsLayer.removeChildAt(Main.dialogsLayer.getChildIndex(blurBmpContainer));
					bl--;
					sl.pop();
				}else{
					bl--;
					sl.pop();
					Main.dialogsLayer.setChildIndex(blurBmpContainer,sl.pop());
				}
				trace(bl);
				if (!Main.contentLayer.contains(blurBmpContainer1))
				{
					blurBmp.bitmapData.dispose();
					Main.stage.removeEventListener(Event.RESIZE,resizeBlur);
					blured = false;
				}else{
					blurBmpContainer1.visible = true;
				}
				return;
			}
			if (Main.contentLayer.contains(blurBmpContainer1))
			{
				Main.contentLayer.removeChild(blurBmpContainer1);
				if (!Main.dialogsLayer.contains(blurBmpContainer))
				{
					blurBmp.bitmapData.dispose();
					Main.stage.removeEventListener(Event.RESIZE,resizeBlur);
					blured = false;
					bbq = false;
				}
			}
		 //}
      }
      
      public static function writeVarsToConsoleChannel(channel:String, message:String, ... vars) : void
      {
         for(var i:int = 0; i < vars.length; i++)
         {
            message = message.replace("%" + (i + 1),vars[i]);
         }
         Logger.log(1,message);
      }
      
      public static function hideConsole() : void
      {
         IConsoleService(Main.osgi.getService(IConsoleService)).hideConsole();
      }
      
      public static function showConsole() : void
      {
         IConsoleService(Main.osgi.getService(IConsoleService)).showConsole();
      }
      
      private static function onAddressChange(e:Event) : void
      {
      }
      
      public function start(_osgi:OSGi) : void
      {
         osgi = _osgi;
         osgi.registerService(IClassService,new ClassRegister());
         osgi.registerService(ISpaceService,new SpaceRegister());
         var modelsRegister:IModelService = new ModelsRegister();
         osgi.registerService(IModelService,modelsRegister);
         var resourceRegister:IResourceService = new ResourceRegister();
         osgi.registerService(IResourceService,resourceRegister);
         var addressService:IAddressService = new AddressService();
         osgi.registerService(IAddressService,addressService);
         if(addressService.getBaseURL() != "" && addressService.getBaseURL() != "undefined")
         {
            addressService.addEventListener(SWFAddressEvent.CHANGE,onAddressChange);
         }
         else
         {
            osgi.unregisterService(IAddressService);
         }
         var dumpService:IDumpService = IDumpService(osgi.getService(IDumpService));
         dumpService.registerDumper(new SpaceDumper());
         dumpService.registerDumper(new ObjectDumper());
         dumpService.registerDumper(new ClassDumper());
         dumpService.registerDumper(new ResourceDumper());
         dumpService.registerDumper(new ModelDumper());
         codecFactory = new CodecFactory();
         osgi.registerService(IProtocolService,new ProtocolService(codecFactory));
         codecFactory.registerCodec(ControlCommand,new ControlRootCodec(codecFactory));
         codecFactory.registerCodec(SpaceCommand,new SpaceRootCodec(codecFactory));
         codecFactory.registerCodec(ResourceInfo,new ResourceCodec(codecFactory));
         codecFactory.registerCodec(ClassInfo,new ClassCodec(codecFactory));
         var controlProtocol:Protocol = new Protocol(codecFactory,ControlCommand);
         var server:String = INetworkService(osgi.getService(INetworkService)).server;
         networkClient = new AlternativaNetworkClient(server,controlProtocol);
         controlHandler = new ControlCommandHandler(server);
         modelsRegister.register("0","0");
         modelsRegister.register("0","1");
         modelsRegister.register("0","2");
         modelsRegister.add(new DispatcherModel());
         stage = IMainContainerService(osgi.getService(IMainContainerService)).stage;
         mainContainer = IMainContainerService(osgi.getService(IMainContainerService)).mainContainer;
         backgroundLayer = IMainContainerService(osgi.getService(IMainContainerService)).backgroundLayer;
         contentLayer = IMainContainerService(osgi.getService(IMainContainerService)).contentLayer;
         contentUILayer = IMainContainerService(osgi.getService(IMainContainerService)).contentUILayer;
         systemLayer = IMainContainerService(osgi.getService(IMainContainerService)).systemLayer;
         systemUILayer = IMainContainerService(osgi.getService(IMainContainerService)).systemUILayer;
         dialogsLayer = IMainContainerService(osgi.getService(IMainContainerService)).dialogsLayer;
         noticesLayer = IMainContainerService(osgi.getService(IMainContainerService)).noticesLayer;
         cursorLayer = IMainContainerService(osgi.getService(IMainContainerService)).cursorLayer;
         resourceRegister.registerResourceFactory(new LibraryResourceFactory(),ResourceType.LIBRARY);
         resourceRegister.registerResourceFactory(new SoundResourceFactory(),ResourceType.MP3);
         resourceRegister.registerResourceFactory(new MovieClipResourceFactory(),ResourceType.MOVIE_CLIP);
         resourceRegister.registerResourceFactory(new ImageResourceFactory(),ResourceType.IMAGE);
         loadingProgress = ILoaderService(osgi.getService(ILoaderService)).loadingProgress;
         debug = new Debug();
         osgi.registerService(IAlertService,debug);
         var debugService:Object = osgi.getService(IDebugService);
         var console:Console = new Console(stage,debugService != null);
         osgi.registerService(IConsole,console);
         if(logger == null)
         {
            logger = new Logger();
         }
         osgi.registerService(ILogService,logger);
      }
      
      public function stop(osgi:OSGi) : void
      {
      }
   }
}
