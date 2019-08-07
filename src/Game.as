package
{
   import alternativa.init.BattlefieldGUIActivator;
   import alternativa.init.BattlefieldModelActivator;
   import alternativa.init.BattlefieldSharedActivator;
   import alternativa.init.Main;
   import alternativa.init.OSGi;
   import alternativa.init.PanelModelActivator;
   import alternativa.init.TanksFonts;
   import alternativa.init.TanksLocaleActivator;
   import alternativa.init.TanksLocaleEnActivator;
   import alternativa.init.TanksLocaleRuActivator;
   import alternativa.init.TanksServicesActivator;
   import alternativa.init.TanksWarfareActivator;
   import alternativa.tanks.model.BattleSelectModel;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.models.battlefield.gui.chat.ChatModel;
   import utils.client.battlefield.gui.models.inventory.IInventoryModelBase;
   import utils.client.battleselect.IBattleSelectModelBase;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.register.ObjectRegister;
   import alternativa.service.Logger;
   import alternativa.tanks.gui.AlertBugWindow;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.loader.LoaderWindow;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.tank.TankModel;
   import utils.reygazu.anticheat.events.CheatManagerEvent;
   import controls.Label;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.NativeMenu;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.globalization.NationalDigitsType;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import forms.contextmenu.ContextMenu;
   import alternativa.network.SocketListener;
   //import alternativa.tanks.gui.AlertBugWindow;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.network.connecting.ServerConnectionService;
   import alternativa.network.connecting.ServerConnectionServiceImpl;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   [SWF(backgroundColor = "#2b2b1a", frameRate = "60", width = "800", height = "600")]
   public class Game extends MovieClip
   {
      
      public static var getInstance:Game;
      
      public static var currLocale:String;
      
      public static var local:Boolean = false;
      
      public static var _stage:Stage;
       
      public static var cont:ContextMenu = new ContextMenu();
	  
      public var osgi:OSGi;
      
      public var main:Main;
      
      public var battlefieldModel:BattlefieldModelActivator;
      
      public var battlefieldShared:BattlefieldSharedActivator;
      
      public var panel:PanelModelActivator;
      
      public var locale:TanksLocaleActivator;
      
      public var services:TanksServicesActivator;
      
      public var warfare:TanksWarfareActivator;
      
      public var battleGui:BattlefieldGUIActivator;
      
      public var localeRu:TanksLocaleRuActivator;
      
      public var localeEn:TanksLocaleEnActivator;
      
      public var fonts:TanksFonts;
      
      public var classObject:ClientObject;
      
      public var colorMap:BitmapData;
      
      public var battleModel:BattlefieldModel;
      
      public var tankModel:TankModel;
      
      public var loaderObject:Object;
	  
	  public static var log:String;
	  
	  public static var auth:Authorization = new Authorization();
	  
	  private static var st:SharedObject;
	  
	  public static var group:String;
      
      public function Game()
      {
         this.localeRu = new TanksLocaleRuActivator();
         //this.localeEn = new TanksLocaleEnActivator();
         this.fonts = new TanksFonts();
         this.colorMap = new BitmapData(512,512);
         super();
         if(numChildren > 1)
         {
            removeChildAt(0);
            removeChildAt(0);
         }
      }
      
      public static function onUserEntered(e:CheatManagerEvent) : void 
      {
         var network:Network = null;
         var cheaterTextField:TextField = null;
         var osgi:OSGi = Main.osgi;
         if(osgi != null)
         {
            network = osgi.getService(INetworker) as Network;
         }
         if (network == null)
		 {
            while(_stage.numChildren > 0)
            {
               _stage.removeChildAt(0);
            }
            cheaterTextField = new TextField();
            cheaterTextField.textColor = 16711680;
            cheaterTextField.text = "CHEATER!";
            _stage.addChild(cheaterTextField);
		 }
      }
	  
	  public function r(e:MouseEvent) : void
      {
        cont.visible = false;
		cont.x = e.stageX;
		cont.y = e.stageY;
      }
      
      public function activateAllModels() : void
      {
         var localize:String = null;
         this.main.start(this.osgi);
         this.fonts.start(this.osgi);
		 addChild(cont);
		 cont.visible = false;
		 _stage.addEventListener(MouseEvent.CLICK,r);
         try
         {
            localize = root.loaderInfo.url.split("?")[1].split("&")[0].split("=")[1];
         }
         catch(e:Error)
         {
            localize = null;
         }
         //if(localize == null || localize == "ru")
         //{
            this.localeRu.start(this.osgi);
            currLocale = "RU";
         //}
         //else
         //{
            //this.localeEn.start(this.osgi);
            //currLocale = "EN";
         //}
         this.panel.start(this.osgi);
         this.locale.start(this.osgi);
         this.services.start(this.osgi);
      }
      
      public function start(stage:Stage) : void
      {
		 try
         {
			 this.focusRect = false;
			 stage.focus = this;
			 stage.scaleMode = StageScaleMode.NO_SCALE;
			 stage.align = StageAlign.TOP_LEFT;
			 _stage = stage;
			 this.osgi = OSGi.init(false,stage,this,"37.174.16.68",[54],"37.174.16.68",54,"resources/",new Logger(),SharedObject.getLocal("game"),"RU",Object);
			 this.main = new Main();
			 this.battlefieldModel = new BattlefieldModelActivator();
			 this.panel = new PanelModelActivator();
			 this.locale = new TanksLocaleActivator();
			 this.services = new TanksServicesActivator();
			 getInstance = this;
			 this.activateAllModels();
			 var loaderService:CheckLoader = new CheckLoader();
			 this.loaderObject = new Object();
			 var listener:SocketListener = new SocketListener();
			 var objectRegister:ObjectRegister = new ObjectRegister(listener);
			 this.classObject = new ClientObject("1r54g8J2",null,"Game",listener);
			 this.classObject.register = objectRegister;
			 objectRegister.createObject("1r54g8J2",null,"Game");
			 Main.osgi.registerService(ILoader, loaderService);
			 loaderService.setProgress(200);
			 st = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
			 ResourceUtil.loadResource();
			 ResourceUtil.addEventListener(onResourceLoaded);
			 stage.addEventListener(Event.FULLSCREEN,sd);
		 }
         catch(e:Error)
         {
            /*var alert:AlertBugWindow = new AlertBugWindow();
            alert.text = "Произошла ошибка: " + e.getStackTrace();
            Main.stage.addChild(alert);*/
			throw new Error(e.getStackTrace());
         }
      }
	  
	  public function sd(e:Event) : void
      {
		  if (PanelModel(Main.osgi.getService(IPanel)) != null)
		  {
			  PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.dse();
		  }
		  if (stage != null)
		  {
			res(stage);
		  }
		  if (Main.backgroundLayer != null)
		  {
			res(Main.backgroundLayer);
		  }
		  if (Main.contentLayer != null)
		  {
			res(Main.contentLayer);
		  }
		  if (Main.contentUILayer != null)
		  {
			res(Main.contentUILayer);
		  }
		  if (Main.cursorLayer != null)
		  {
			res(Main.cursorLayer);
		  }
		  if (Main.dialogsLayer != null)
		  {
			res(Main.dialogsLayer);
		  }
		  if (Main.noticesLayer != null)
		  {
			res(Main.noticesLayer);
		  }
		  if (Main.systemLayer != null)
		  {
			res(Main.systemLayer);
		  }
		  if (Main.systemUILayer != null)
		  {
			res(Main.systemUILayer);
		  }
		  if (Main.mainContainer != null)
		  {
			res(Main.mainContainer);
		  }
		  if (Main.stage != null)
		  {
			res(Main.stage);
		  }
      }
	  
	  public function destroy(b:Boolean = false) : void
      {
		 if ((Main.osgi.getService(ILoader) as CheckLoader) != null)
		 {
			(Main.osgi.getService(ILoader) as CheckLoader).deactivate();
		 }
		 if (BattleController(Main.osgi.getService(IBattleController)) != null)
		 {
			BattleController(Main.osgi.getService(IBattleController)).destroy();
		 }
		 if (Main.osgi.getService(ILobby) != null)
		 {
			if (Main.osgi.getService(ILobby).chat.chatModel != null)
			 {
				Main.osgi.getService(ILobby).chat.chatModel.objectUnloaded(null);
			 }
		 }
		 if (ChatModel(Main.osgi.getService(IChatBattle)) != null)
		 {
			Main.osgi.getService(IChatBattle).objectUnloaded(null);
		 }
		 if (GarageModel(Main.osgi.getService(IGarage)) != null)
		 {
			GarageModel(Main.osgi.getService(IGarage)).garageWindow.removeaItemFromStore();
			GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
		 }
		 if (BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)) != null)
		 {
			BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)).objectUnloaded(null);
		 }
		 if (PanelModel(Main.osgi.getService(IPanel)) != null)
		 {
			PanelModel(Main.osgi.getService(IPanel)).objectUnloaded(null);
		 }
		 if (Network(Main.osgi.getService(INetworker)) != null)
		 {
			Network(Main.osgi.getService(INetworker)).removeListeners();
			Network(Main.osgi.getService(INetworker)).cl = true;
			try{
			Network(Main.osgi.getService(INetworker)).destroy();
			}catch (e:Error)
			{}
		 }
		 if (Authorization(Main.osgi.getService(IAuthorization)) != null)
		 {
			 if (Authorization(Main.osgi.getService(IAuthorization)).userModel != null && Authorization(Main.osgi.getService(IAuthorization)).userModel.userModel != null)
			 {
				Authorization(Main.osgi.getService(IAuthorization)).userModel.userModel.objectUnloaded(null);
			 }
			 if (Network(Main.osgi.getService(INetworker)) != null)
			 {
				if (b)
				 {
					Network(Main.osgi.getService(INetworker)).connect();
				 }
			 }
		 }
      }
	  
	  private function res(e:*) : void
      {
		e.dispatchEvent(new Event(Event.RESIZE));
      }
      
      private static function onResourceLoaded() : void
      {
         var serverConnectionServie:ServerConnectionService = new ServerConnectionServiceImpl();
         Main.osgi.registerService(IAuthorization, auth);/*
         if(st.data["k_V"] == null)
         {
            st.setProperty("k_V",0.02);
         }
         if(st.data["k_AV"] == null)
         {
            st.setProperty("k_AV",6);
         }*/
      }
   }
}