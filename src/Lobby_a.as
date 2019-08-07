package
{
   import alternativa.debug.Debug;
   import alternativa.init.BattleSelectModelActivator;
   import alternativa.init.ChatModelActivator;
   import alternativa.init.GarageModelActivator;
   import alternativa.init.Main;
   import alternativa.network.connecting.ServerConnectionService;
   import alternativa.network.connecting.ServerConnectionServiceImpl;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.osgi.service.storage.StorageService;
   import alternativa.tanks.gui.ILoader;
   import alternativa.tanks.model.UserModel;
   import flash.display.Loader;
   import forms.itemscategory.ItemsCategoryView;
   import forms.news.AddLine;
   import forms.news.NewsOutput;
   import forms.news.OprosOutputLine;
   import forms.progr.CheckLoader;
   import utils.clips.Newes;
   import flash.system.System;
   import forms.garage.ItemInfoPanel;
   import alternativa.tanks.gui.StatisticWindow;
   import forms.friends.AddRequestView;
   import forms.friends.FriendsWindow;
   import forms.friends.battleinvite.BattleInviteNotification;
   import alternativa.tanks.model.BattleSelectModel;
   import alternativa.tanks.model.ChatModel;
   import alternativa.tanks.model.Friend;
   import alternativa.tanks.model.FriendIn;
   import alternativa.tanks.model.FriendOt;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.model.Item3DModel;
   import alternativa.tanks.model.ItemParams;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.model.top.TopModel;
   import alternativa.tanks.model.user.IUserData;
   import alternativa.tanks.model.user.UserData;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.types.Long;
   import utils.client.models.core.community.chat.types.ChatMessage;
   import utils.client.models.core.community.chat.types.UserChat;
   import utils.client.models.core.users.model.entrance.IEntranceModelBase;
   import utils.client.commons.models.itemtype.ItemTypeEnum;
   import utils.client.commons.types.ItemProperty;
   import utils.client.garage.garage.IGarageModelBase;
   import utils.client.garage.garage.ItemInfo;
   import utils.client.garage.item.ItemPropertyValue;
   import utils.client.garage.item.ModificationInfo;
   import utils.client.garage.item3d.IItem3DModelBase;
   import flash.events.Event;
   import flash.net.SharedObject;
   import forms.news.NewsOutputLine;
   import forms.userlabel.UserLabel;
   import utils.client.models.core.community.chat.IChatModelBase;
   import utils.client.battleselect.IBattleSelectModelBase;
   import utils.client.battleselect.types.BattleClient;
   import utils.client.battleselect.types.MapClient;
   import utils.client.battleselect.types.UserInfoClient;
   import utils.client.battleservice.model.BattleType;
   import utils.client.battleservice.model.team.BattleTeamType;
   import utils.client.panel.model.ITopModelBase;
   import utils.client.panel.model.User;
   import alternativa.tanks.gui.AlertBugWindow;
   import alternativa.network.INetworkListener;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.network.commands.Command;
   import alternativa.network.commands.Type;
   import alternativa.service.server.models.bonus.ServerBonusModel;
   
   public class Lobby_a implements INetworkListener
   {
      
      public static var firstInit:Boolean = true;
      
      public var chat:ChatModelActivator;
      
      public var battleSelect:BattleSelectModelActivator;
      
      public var garage:GarageModelActivator;
      
      private var networker:Network;
      
      private var nullCommand:String;
      
      private var chatInited:Boolean = false;
      
      private const greenColor:uint = 8454016;
      
      private const yellowColor:uint = 15335168;
      
      private var bonusModel:ServerBonusModel;
      
      private var listInited:Boolean = false;
	  
	  public static var haveSub:Boolean = false;
	  
	  public static var nami:String = "";
	  
	  private var modelPanel:PanelModel;
	  
	  private var inv:BattleInviteNotification = new BattleInviteNotification(0, "User", "#battle0@Песочница DM@#0");
      
      public function Lobby_a()
      {
         this.bonusModel = new ServerBonusModel();
         super();
         this.chat = new ChatModelActivator();
         this.battleSelect = new BattleSelectModelActivator();
         this.garage = new GarageModelActivator();
      }
      
      public function onData(param1:Command) : void
      {
         var _loc2_:Object = null;
         var _loc3_:UserInfoClient = null;
         var _loc4_:BattleController = null;
         var _loc5_:ItemParams = null;
         var _loc6_:String = null;
         var _loc7_:ItemParams = null;
         var _loc8_:ItemInfo = null;
         var _loc9_:Object = null;
		 if (param1 == null)
		 {
			 return;
		 }
		 try
         {
			 switch(param1.type)
			 {
				case Type.LOBBY_CHAT:
				   if(param1.args[0] == "system")
				   {
					  if(!this.chatInited)
					  {
						 this.chatInited = true;
					  }
					  this.chat.chatModel.chatPanel.chat.addMessage("",0,param1.args[1],0,"",true,param1.args[2] == "yellow"?uint(this.yellowColor):uint(this.greenColor));
				   }
				   else if(param1.args[0] != "init_chat")
				   {
					  if(param1.args[0] == "clear_all")
					  {
						 if(!this.chatInited)
						 {
							this.chatInited = true;
						 }
						 this.chat.chatModel.cleanUsersMessages(null, "");
					  }
					  else if(param1.args[0] == "init_messages")
					  {
						 Main.osgi.registerService(IChatModelBase,this.chat.chatModel);
						 this.chat.chatModel.initObject(Game.getInstance.classObject,[""],(Main.osgi.getService(IUserData) as UserData).name);
						 this.chat.chatModel.objectLoaded(Game.getInstance.classObject);
						 this.parseChatMessages(param1.args[1]);
					  }
					  else if(param1.args[0] == "clean_by")
					  {
						 this.chat.chatModel.cleanUsersMessages(null,param1.args[1]);
					  }
					  else if(param1.args[0] == "clean_by_text")
					  {
						 this.chat.chatModel.cleanMessages(param1.args[1]);
					  }
					  else
					  {
						 if(!this.chatInited)
						 {
							this.chatInited = true;
						 }
						 this.parseAndAddMessageToChat(param1.args[0]);
					  }
				   }
				   break;
				case Type.LOBBY:
				   if(param1.args[0] == "init_panel")
				   {
					  this.parseAndInitPanelInfo(param1.args[1]);
				   }
				   else if(param1.args[0] == "init_f")
				   {
					  parseFr(param1.args[1]);
				   }
				   else if(param1.args[0] == "init_ch")
				   {
					  parseCh(param1.args[1]);
				   }
				   else if(param1.args[0] == "pa")
				   {
					  parsePa(param1.args[1]);
				   }
				   else if(param1.args[0] == "inv")
				   {
					  parseInv(param1.args[1]);
				   }
				   else if(param1.args[0] == "addno")
				   {
					  this.chat.chatModel.chatPanel.news.output.cat.scrollContainer.visible = false;
					  var parser:Object = JSON.parse(param1.args[1]);
					  var nd:Array = parser.n as Array;
					  var od:Array = parser.o as Array;
					  var oy:Object = null;
					  for each(oy in nd)
					  {
						 this.chat.chatModel.chatPanel.news.output.addLine(oy.da,oy.ou,oy.out,oy.b);
					  }
					  var ox:Object = null;
					  for each(ox in od)
					  {
						 this.chat.chatModel.chatPanel.news.output.addOpLine(ox.da,ox.ou,ox.out,ox.b,ox.j);
					  }
					  this.chat.chatModel.chatPanel.news.output.cat.scrollContainer.visible = true;
				   }
				   else if(param1.args[0] == "nami")
				   {
					  nami = param1.args[1];
					  this.modelPanel.sob.news.lod(param1.args[1]);
				   }
				   else if(param1.args[0] == "dno")
				   {
					  this.chat.chatModel.chatPanel.news.output.copg(param1.args[1]);
				   }
				   else if(param1.args[0] == "omi")
				   {
					  nami = param1.args[1];
					  this.modelPanel.sob.opros.lod(param1.args[1]);
				   }
				   else if(param1.args[0] == "pao")
				   {
					  this.chat.chatModel.chatPanel.news.output.golos(param1.args[1]);
				   }
				   else if(param1.args[0] == "co")
				   {
					  this.chat.chatModel.chatPanel.news.output.cop(param1.args[1], param1.args[2], param1.args[3], param1.args[4], param1.args[5]);
				   }
				   else if(param1.args[0] == "remn")
				   {
					  try{
						this.chat.chatModel.chatPanel.news.output.ct = new Vector.<NewsOutputLine>();
						this.chat.chatModel.chatPanel.news.output.ct1 = new Vector.<OprosOutputLine>();
						this.chat.chatModel.chatPanel.news.output.cat.removea();
						var fdg:ItemsCategoryView = new ItemsCategoryView("", "", new Long(0, 1));
						//this.chat.chatModel.chatPanel.news.output.al = new AddLine();
						fdg.addItem(this.chat.chatModel.chatPanel.news.output.al);
						this.chat.chatModel.chatPanel.news.output.cat.addCategory(fdg);
						this.chat.chatModel.chatPanel.news.output.setSize(NewsOutput.dr.x,NewsOutput.dr.y);
					  }catch (e:Error)
					  {
					  }
				   }
				   else if(param1.args[0] == "add_crystall")
				   {
					  PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null,int(param1.args[1]));
				   }
				   else if(param1.args[0] == "add_score")
				   {
					  PanelModel(Main.osgi.getService(IPanel)).updateScore(null,int(param1.args[1]));
				   }
				   else if(param1.args[0] == "update_rang_progress")
				   {
					  PanelModel(Main.osgi.getService(IPanel)).updateRankProgress(null,int(param1.args[1]));
				   }
				   else if(param1.args[0] == "update_rang")
				   {
					  PanelModel(Main.osgi.getService(IPanel)).updateRang(null,int(param1.args[1]),int(param1.args[2]));
				   }
				   else if(param1.args[0] == "init_battle_select")
				   {
					  this.parseAndInitBattlesList(param1.args[1]);
				   }
				   else if(param1.args[0] == "create_battle")
				   {
					  this.parseBattle(param1.args[1]);
				   }
				   else if(param1.args[0] == "rang")
				   {
					  this.parseRangs(param1.args[1]);
				   }
				   else if(param1.args[0] == "check_battle_name")
				   {
					  this.battleSelect.battleSelectModel.setFilteredBattleName(null,param1.args[1]);
				   }
				   else if(param1.args[0] == "ret")
				   {
					  this.rety(param1.args[1],param1.args[2]);
				   }
				   else if(param1.args[0] == "show_battle_info")
				   {
					  this.parseBattleInfo(param1.args[1]);
				   }
				   else if(param1.args[0] == "update_count_users_in_dm_battle")
				   {
					  this.battleSelect.battleSelectModel.updateUsersCountForDM(null,param1.args[1],param1.args[2]);
				   }
				   else if(param1.args[0] == "update_count_users_in_team_battle")
				   {
					  _loc2_ = JSON.parse(param1.args[1]);
					  this.battleSelect.battleSelectModel.updateUsersCountForTeam(null,_loc2_.battleId,_loc2_.redPeople,_loc2_.bluePeople);
				   }
				   else if(param1.args[0] == "remove_battle")
				   {
					  this.battleSelect.battleSelectModel.removeBattle(null,param1.args[1]);
				   }
				   else if(param1.args[0] == "add_player_to_battle")
				   {
					  _loc2_ = JSON.parse(param1.args[1]);
					  if(_loc2_.battleId != this.battleSelect.battleSelectModel.selectedBattleId)
					  {
						 return;
					  }
					  _loc3_ = new UserInfoClient();
					  _loc3_.id = _loc2_.id;
					  _loc3_.kills = _loc2_.kills;
					  _loc3_.name = _loc2_.name;
					  _loc3_.rank = _loc2_.rank;
					  _loc3_.type = BattleTeamType.getType(_loc2_.type);
					  this.battleSelect.battleSelectModel.currentBattleAddUser(null,_loc3_);
				   }
				   else if(param1.args[0] == "remove_player_from_battle")
				   {
					  _loc2_ = JSON.parse(param1.args[1]);
					  if(_loc2_.battleId != this.battleSelect.battleSelectModel.selectedBattleId)
					  {
						 return;
					  }
					  this.battleSelect.battleSelectModel.currentBattleRemoveUser(null,_loc2_.id);
				   }
				   else if(param1.args[0] == "server_message")
				   {
					  Main.debug.showServerMessageWindow(param1.args[1]);
				   }
				   else if(param1.args[0] == "val")
				   {
					  this.val(param1.args[1]);
				   }
				   else if(param1.args[0] == "show_bonuses")
				   {
					  this.bonusModel.showBonuses(param1.args[1]);
				   }
				   else if(param1.args[0] == "show_crystalls")
				   {
					  this.bonusModel.showCrystalls(int(param1.args[1]));
				   }
				   else if(param1.args[0] == "init_battlecontroller")
				   {
					  PanelModel(Main.osgi.getService(IPanel)).isInBattle = true;
					  PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
					  if(BattleController(Main.osgi.getService(IBattleController)) == null)
					  {
						 _loc4_ = new BattleController();
						 Main.osgi.registerService(IBattleController,_loc4_);
					  }
					  Network(Main.osgi.getService(INetworker)).addEventListener(Main.osgi.getService(IBattleController) as BattleController);
				   }
				   else if(param1.args[0] == "server_halt")
				   {
					  PanelModel(Main.osgi.getService(IPanel)).serverHalt(null,50,0,0,null);
				   }
				   break;
				case Type.GARAGE:
				   if(param1.args[0] == "skins")
				   {
					  parseSkin(param1.args[1]);
				   }
				   else if(param1.args[0] == "mount_item")
				   {
					  _loc5_ = GarageModel.getItemParams(param1.args[1]);
					  if(_loc5_.itemType == ItemTypeEnum.ARMOR)
					  {
						 _loc6_ = this.garage.garageModel.mountedArmorId;
					  }
					  else if(_loc5_.itemType == ItemTypeEnum.WEAPON)
					  {
						 _loc6_ = this.garage.garageModel.mountedWeaponId;
					  }
					  else if(_loc5_.itemType == ItemTypeEnum.COLOR)
					  {
						 _loc6_ = this.garage.garageModel.mountedEngineId;
					  }
					  this.garage.garageModel.mountItem(null,_loc6_,param1.args[1],param1.args[2]);
				   }
				   else if(param1.args[0] == "update_item")
				   {
					  GarageModel.replaceItemInfo(param1.args[1],this.getNextId(param1.args[1]));
					  GarageModel.replaceItemParams(param1.args[1],this.getNextId(param1.args[1]));
					  this.garage.garageModel.upgradeItem(null,param1.args[1],GarageModel.getItemInfo(this.getNextId(param1.args[1])));
				   }
				   else if(param1.args[0] == "lod")
				   {
					  this.lod(param1.args[1]);
				   }
				   else if(param1.args[0] == "init_mounted_item")
				   {
					  _loc7_ = GarageModel.getItemParams(param1.args[1]);
					  this.garage.garageModel.mountItem(null,null,param1.args[1],param1.args[2]);
				   }
				   else if(param1.args[0] == "init_market1")
				   {
					  if (this.garage.garageModel != null)
					 {
						 if(this.garage.garageModel.garageWindow == null)
						 {
							this.garage.start(Main.osgi);
							this.garage.garageModel.initObject(Game.getInstance.classObject, "russia", 1000000, new Long(100, 100), this.networker);
						 }
					 }else{
						 this.garage.start(Main.osgi);
						 this.garage.garageModel.initObject(Game.getInstance.classObject, "russia", 1000000, new Long(100, 100), this.networker);
					 }
					 this.garage.garageModel.garageWindow.itms1 = new Array();
					 this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseMarket(param1.args[1],this.garage.garageModel.garageWindow.itms1);
				   }
				   else if(param1.args[0] == "init_market2")
				   {
					  this.garage.garageModel.garageWindow.itms2 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseMarket(param1.args[1],this.garage.garageModel.garageWindow.itms2);
				   }
				   else if(param1.args[0] == "init_market3")
				   {
					  this.garage.garageModel.garageWindow.itms3 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseMarket(param1.args[1],this.garage.garageModel.garageWindow.itms3);
				   }
				   else if(param1.args[0] == "init_market4")
				   {
					  this.garage.garageModel.garageWindow.itms4 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseMarket(param1.args[1],this.garage.garageModel.garageWindow.itms4);
				   }
				   else if(param1.args[0] == "init_market5")
				   {
					  this.garage.garageModel.garageWindow.itms5 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseMarket(param1.args[1],this.garage.garageModel.garageWindow.itms5);
				   }
				   else if(param1.args[0] == "init_market6")
				   {
					  this.garage.garageModel.garageWindow.itms6 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseMarket(param1.args[1],this.garage.garageModel.garageWindow.itms6);
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.garage.garageModel.garageWindow.resize(this.garage.garageModel.garageWindow.windowSize.x,this.garage.garageModel.garageWindow.windowSize.y);
					  this.garage.garageModel.objectLoaded(Game.getInstance.classObject);
				   }
				   else if(param1.args[0] == "init_garage_items1")
				   {
					  this.garage.garageModel.garageWindow.itms7 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseGarageItems(param1.args[1],this.garage.garageModel.garageWindow.itms7,param1.src);
				   }
				   else if(param1.args[0] == "init_garage_items2")
				   {
					  this.garage.garageModel.garageWindow.itms8 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseGarageItems(param1.args[1],this.garage.garageModel.garageWindow.itms8,param1.src);
				   }
				   else if(param1.args[0] == "init_garage_items3")
				   {
					  this.garage.garageModel.garageWindow.itms9 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseGarageItems(param1.args[1],this.garage.garageModel.garageWindow.itms9,param1.src);
				   }
				   else if(param1.args[0] == "init_garage_items4")
				   {
					  this.garage.garageModel.garageWindow.itms10 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseGarageItems(param1.args[1],this.garage.garageModel.garageWindow.itms10,param1.src);
				   }
				   else if(param1.args[0] == "init_garage_items5")
				   {
					  this.garage.garageModel.garageWindow.itms11 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseGarageItems(param1.args[1],this.garage.garageModel.garageWindow.itms11,param1.src);
				   }
				   else if(param1.args[0] == "init_garage_items6")
				   {
					  this.garage.garageModel.garageWindow.itms12 = new Array();
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.parseGarageItems(param1.args[1], this.garage.garageModel.garageWindow.itms12, param1.src);
					  this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.itms7);
					  this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.itms8);
					  this.garage.garageModel.garageWindow.removeaItemFromWarehouse();
					  this.garage.garageModel.initMarket(null,this.garage.garageModel.garageWindow.itms6);
					  this.garage.garageModel.initDepot(null, this.garage.garageModel.garageWindow.itms12);
					  Network(Main.osgi.getService(INetworker)).send("garage;get_garage_data");
					  PanelModel(Main.osgi.getService(IPanel)).addListener(this.garage.garageModel);
					  Main.osgi.registerService(IGarage,this.garage.garageModel);
					  PanelModel(Main.osgi.getService(IPanel)).isGarageSelect = true;
					  this.garage.garageModel.garageWindow.resize(this.garage.garageModel.garageWindow.windowSize.x,this.garage.garageModel.garageWindow.windowSize.y);
					  this.garage.garageModel.objectLoaded(Game.getInstance.classObject);
				   }
				   else if(param1.args[0] == "buy_item")
				   {
					  _loc8_ = new ItemInfo();
					  _loc9_ = JSON.parse(param1.args[2]);
					  _loc8_.count = _loc9_.count;
					  _loc8_.itemId = param1.args[1];
					  //throw new Error(_loc8_.itemId);
					  this.garage.garageModel.buyItem(null, _loc8_);
				   }
			 }
		 }
		 catch(e:Error)
         {
			throw new Error(e.getStackTrace());
			//while(e.getStackTrace().search("2130") == -1)
			//{
				var alert:AlertBugWindow = new AlertBugWindow();
				alert.text = "Произошла ошибка: " + e.getStackTrace();
				//Main.stage.addChild(alert);
			//}
         }
      }
      
      private function parseChatMessages(json:String) : void
      {
         var obj:Object = null;
         var user:UserChat = null;
         var userTo:UserChat = null;
         var msg:ChatMessage = null;
         var parser:Object = JSON.parse(json);
         var msgs:Array = new Array();
         for each(obj in parser.messages)
         {
            user = new UserChat();
            user.rankIndex = obj.rang;
            user.uid = obj.name;
            if(obj.addressed)
            {
               userTo = new UserChat();
               userTo.uid = obj.nameTo;
               userTo.rankIndex = obj.rangTo;
            }
            msg = new ChatMessage();
            msg.sourceUser = user;
            msg.system = obj.system;
            msg.targetUser = userTo;
            msg.text = obj.message;
            msg.sysCollor = Boolean(obj.yellow)?uint(this.yellowColor):uint(this.greenColor);
            msgs.push(msg);
         }
         this.chat.chatModel.showMessages(null, msgs);
      }
	  
	  private function parseCh(json:String) : void
      {
         var obj:Object = null;
         var parser:Object = JSON.parse(json);
		 modelPanel.mainPanel.buttonBar.vz(parser.ye, parser.zv);
		 if (parser.ye)
		 {
			 modelPanel.zad.ch.list.prem = parser.bp;
			 modelPanel.zad.ch.list.part = parser.pa;
			 modelPanel.zad.ch.inf(parser.zv,parser.mzv,parser.pa);
			 modelPanel.zad.ch.chas(parser.cu, parser.ti);
			 var ar:Array = parser.part as Array;
			 ar.sort(sorting);
			 for (var sd:int = 0; sd < ar.length; sd++)
			 {
				obj = ar[sd];
				modelPanel.zad.ch.list.addItem(obj.id, obj.nazv, obj.type, obj.sort, obj.count, obj.prew,obj.id1, obj.nazv1, obj.type1, obj.sort1, obj.count1, obj.prew1);
			 }
		 }
		 modelPanel.mainPanel.onResize();
      }
	  
	  private function sorting(a:Object,b:Object) : int
      {
         return int(b.id) - int(a.id);
      }
      
      private function parseBattleInfo(json:String) : void
      {
         var user_obj:Object = null;
         var usr:UserInfoClient = null;
         var obj:Object = JSON.parse(json);
         if(obj.null_battle)
         {
            return;
         }
         var users:Array = new Array();
         for each(user_obj in obj.users_in_battle)
         {
            usr = new UserInfoClient();
            usr.id = String(user_obj.nickname);
            usr.kills = int(user_obj.kills);
            usr.name = String(user_obj.nickname);
            usr.rank = int(user_obj.rank);
            usr.type = BattleTeamType.getType(user_obj.team_type);
            users.push(usr);
         }
         this.battleSelect.battleSelectModel.showBattleInfo(null,obj.name,obj.maxPeople,BattleType.getType(obj.type),obj.battleId,obj.previewId,obj.minRank,obj.maxRank,obj.timeLimit,obj.timeCurrent,obj.killsLimt,obj.scoreRed,obj.scoreBlue,obj.autobalance,obj.friendlyFire,users,obj.paidBattle,obj.withoutBonuses,obj.userAlreadyPaid,obj.fullCash,obj.spectator);
         this.battleSelect.battleSelectModel.selectedBattleId = obj.battleId;
      }
	  
	  private function rety(json:String,json1:String) : void
      {
         PanelModel(Main.osgi.getService(IPanel)).mainPanel.playerInfo.rot(int(json), int(json1));
      }
      
      private function parseBattle(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var battle:BattleClient = new BattleClient();
         battle.battleId = parser.battleId;
         battle.mapId = parser.mapId;
         battle.name = parser.name;
         battle.team = parser.team;
         battle.countRedPeople = parser.redPeople;
         battle.countBluePeople = parser.bluePeople;
         battle.countPeople = parser.countPeople;
         battle.maxPeople = parser.maxPeople;
         battle.minRank = parser.minRank;
         battle.maxRank = parser.maxRank;
         battle.paid = parser.isPaid;
		 battle.type = parser.vid;
         this.battleSelect.battleSelectModel.addBattle(null,battle);
      }
	  
	  private function parseInv(json:String) : void
      {
         var parser:Object = JSON.parse(json);
		 if (Main.systemLayer.contains(inv))
		 {
			Main.systemLayer.removeChild(inv);
		 }
		 //throw new Error(parser.r);
		 inv = new BattleInviteNotification(int(parser.r), parser.n, parser.id);
		 Main.systemLayer.addChild(inv);
		 inv.visible = true;
      }
	  
	  private function parsePa(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var cry:int = parser.s;
		 modelPanel.showCo(cry);
      }
      
      private function parseMarket(json:String,are:Array) : void
      {
         var obj:Object = null;
         var modifications:Array = null;
         var obj2:Object = null;
         var id:int = 0;
         var item:ItemParams = null;
         var infoItem:ItemInfo = null;
         var props:Array = null;
         var properts:Object = null;
         var info:ModificationInfo = null;
         var pid:String = null;
         var p:ItemPropertyValue = null;
		 //throw new Error(json);
		 //trace(json);
         var parser:Object = JSON.parse(json);
         for each(obj in parser.items)
         {
            modifications = new Array();
            for each(obj2 in obj.modification)
            {
               props = new Array();
               for each(properts in obj2.properts)
               {
                  p = new ItemPropertyValue();
                  p.property = this.getItemProperty(properts.property);
                  p.value = properts.value;
                  props.push(p);
               }
               info = new ModificationInfo();
               info.crystalPrice = obj2.price;
               info.rankId = obj2.rank;
               info.previewId = obj2.previewId;
               pid = obj2.previewId;
               info.itemProperties = props;
               modifications.push(info);
            }
            item = new ItemParams(obj.id + "_m" + id,obj.description,obj.isInventory,obj.index,props,this.getTypeItem(obj.type),obj.modificationID,obj.name,obj.next_price,null,obj.next_rank,modifications[id].previewId,obj.price,obj.rank,modifications,obj.nx,obj.dx,obj.xt,true);
            infoItem = new ItemInfo();
            infoItem.count = item.price;
            infoItem.itemId = item.baseItemId;
            this.garage.garageModel.initItem(item.baseItemId, item);
			are.push(infoItem);
         }
      }
      
      private function getNextId(oldId:String) : String
      {
         var temp:String = oldId.substring(0,oldId.length - 1);
         var mod:int = int(oldId.substring(oldId.length - 1,oldId.length));
         temp = temp + (mod + 1);
         return temp;
      }
      
      public function parseGarageItems(json:String, are:Array, src:String = null) : void
      {
		 haveSub = false;
         var parser:Object = null;
         var items:Array = null;
         var obj:Object = null;
         var modifications:Array = null;
         var obj2:Object = null;
         var id:int = 0;
         var item:ItemParams = null;
         var infoItem:ItemInfo = null;
         var props:Array = null;
         var prop:Object = null;
         var info:ModificationInfo = null;
         var pid:String = null;
         var p:ItemPropertyValue = null;
         try
         {
            parser = JSON.parse(json);
            items = new Array();
            for each(obj in parser.items)
            {
               modifications = new Array();
               for each(obj2 in obj.modification)
               {
                  props = new Array();
                  for each(prop in obj2.properts)
                  {
                     p = new ItemPropertyValue();
                     p.property = this.getItemProperty(prop.property);
                     p.value = prop.value;
                     props.push(p);
                  }
                  info = new ModificationInfo();
                  info.crystalPrice = obj2.price;
                  info.rankId = obj2.rank;
                  info.previewId = obj2.previewId;
                  pid = obj2.previewId;
                  info.itemProperties = props;
                  modifications.push(info);
               }
               id = obj.modificationID;
			   //throw new Error(obj.id);
			   if (obj.id == "pro_battle")
			   {
				   haveSub = true;
			   }
               item = new ItemParams(obj.id + "_m" + id,obj.description,obj.isInventory,obj.index,props,this.getTypeItem(obj.type),obj.modificationID,obj.name,obj.next_price,null,obj.next_rank,modifications[id].previewId,obj.price,obj.rank,modifications,obj.nx,obj.dx,obj.xt,false);
               infoItem = new ItemInfo();
               infoItem.count = obj.count;
               infoItem.itemId = item.baseItemId;
               this.garage.garageModel.initItem(item.baseItemId, item);
			   are.push(infoItem);
            }
         }
         catch(e:Error)
         {
            //throw new Error("Ошибка " + e.getStackTrace());
			var alert:AlertBugWindow = new AlertBugWindow();
			alert.text = "Произошла ошибка: " + e.getStackTrace();
			Main.stage.addChild(alert);
         }
      }
      
      public function parseAndInitBattlesList(json:String) : void
      {
		 if(PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			 PanelModel(Main.osgi.getService(IPanel)).isBattleSelect = false;
			 return;
		 }
         var obj1:Object = null;
         var btl:Object = null;
         var map:MapClient = null;
         var battle:BattleClient = null;
         Main.osgi.registerService(IBattleSelectModelBase,this.battleSelect.battleSelectModel);
         var maps:Array = new Array();
         var battles:Array = new Array();
         var js:Object = JSON.parse(json);
         for each(obj1 in js.items)
         {
            map = new MapClient();
            map.ctf = obj1.ctf;
            map.gameName = obj1.gameName;
            map.id = obj1.id;
            map.maxPeople = obj1.maxPeople;
            map.maxRank = obj1.maxRank;
            map.minRank = obj1.minRank;
            map.name = obj1.name;
            map.previewId = obj1.id + "_preview";
            map.tdm = obj1.tdm;
            map.themeName = obj1.themeName;
            maps.push(map);
         }
         for each(btl in js.battles)
         {
            battle = new BattleClient();
            battle.battleId = btl.battleId;
            battle.mapId = btl.mapId;
            battle.name = btl.name;
            battle.team = btl.team;
            battle.countRedPeople = btl.redPeople;
            battle.countBluePeople = btl.bluePeople;
            battle.countPeople = btl.countPeople;
            battle.maxPeople = btl.maxPeople;
            battle.minRank = btl.minRank;
            battle.maxRank = btl.maxRank;
            battle.paid = btl.isPaid;
			battle.type = btl.vid;
            battles.push(battle);
         }
		 haveSub = js.pro == "1" ? true:false;
         this.battleSelect.battleSelectModel.initObject(null,10,js.pro == "1" ? true:false,maps);
         this.battleSelect.battleSelectModel.initBattleList(null, battles, null, false);
		 PanelModel(Main.osgi.getService(IPanel)).isBattleSelect = true;
         if(!this.listInited)
         {
            this.listInited = true;
         }
		 if (js.bat != null)
		 {
			 var user_obj:Object = null;
			 var usr:UserInfoClient = null;
			 var obj:Object = js.bat;
			 if(obj.null_battle)
			 {
				return;
			 }
			 var users:Array = new Array();
			 for each(user_obj in obj.users_in_battle)
			 {
				usr = new UserInfoClient();
				usr.id = String(user_obj.nickname);
				usr.kills = int(user_obj.kills);
				usr.name = String(user_obj.nickname);
				usr.rank = int(user_obj.rank);
				usr.type = BattleTeamType.getType(user_obj.team_type);
				users.push(usr);
			 }
			 //this.battleSelect.battleSelectModel.showBattleInfo(null,obj.name,obj.maxPeople,BattleType.getType(obj.type),obj.battleId,obj.previewId,obj.minRank,obj.maxRank,obj.timeLimit,obj.timeCurrent,obj.killsLimt,obj.scoreRed,obj.scoreBlue,obj.autobalance,obj.friendlyFire,users,obj.paidBattle,obj.withoutBonuses,obj.userAlreadyPaid,obj.fullCash,obj.spectator);
			 this.battleSelect.battleSelectModel.selectedBattleId = obj.battleId;
		 }
      }
	  
	  public function parseSkin(json:String) : void
      {
         var parser:Object = JSON.parse(json);
		 ItemInfoPanel.sk.sde.davay(parser.obj,parser.ct)
		 ItemInfoPanel.sk.sde.show();
	  }
      
      public function parseAndAddMessageToChat(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         this.chat.chatModel.chatPanel.chat.addMessage(parser.name,parser.rang,parser.message,parser.rangTo,parser.nameTo == "NULL"?"":parser.nameTo,parser.system);
      }
	  
	  public function lod(p:String) : void
      {
        var obj:Object = JSON.parse(p);
		var fgt:String = null;
		var fgt1:String = "";
		var hh:Array = obj.f.split("э");
		var hh1:Array = obj.s.split("э");
		var hh2:Array = obj.t.split("э");
		//throw new Error(obj.prog + "	" + obj.cost);
		if (hh.length == 1 && hh[0] == "")
		{
			hh = new Array();
		}
		if (hh1.length == 1 && hh1[0] == "")
		{
			hh1 = new Array();
		}
		if (hh2.length == 1 && hh2[0] == "")
		{
			hh2 = new Array();
		}
		for (var gh:int = 0; gh < hh.length; gh++)
		{
			if (hh[gh] == fgt || hh[gh] == fgt1 && hh.length != 0)
			{
				hh.splice(gh,1);
			}
			//hh[gh] = (Number) (hh[gh]);
		}
		for (var gh1:int = 0; gh1 < hh1.length; gh1++)
		{
			if (hh1[gh1] == fgt || hh1[gh] == fgt1 && hh1.length != 0)
			{
				hh1.splice(gh1,1);
			}
			//hh1[gh1] = (Number) (hh1[gh1]);
		}
		for (var gh2:int = 0; gh2 < hh2.length; gh2++)
		{
			if (hh2[gh2] == fgt || hh2[gh2] == fgt1 && hh2.length != 0)
			{
				hh2.splice(gh2,1);
			}
			//hh2[gh2] = (Number) (hh2[gh2]);
		}
		garage.garageModel.upg.davay(obj.prog, hh, hh1, hh2, obj.cost);
		garage.garageModel.alignWindow();
		Main.blur();
		Main.dialogsLayer.addChild(garage.garageModel.upg);
		garage.garageModel.upg.show();
      }
      
      public function parseAndInitPanelInfo(json:String) : void
      {
         var obj:Object = JSON.parse(json);
         this.initPanel(obj.crystall,obj.email,obj.tester,obj.name,obj.next_score,obj.place,obj.rang,obj.rating,obj.score);
      }
	  
	  public function parseRangs(p:String) : void
      {
		var parser:Object = JSON.parse(p);
		 if (parser.type == 0)
		 {
			Friend.r[parser.id] = (int)(parser.r) + 1;
		 }else{
			Friend.rot[parser.id] = (int)(parser.r) + 1;
		 }
		 UserLabel.ds.dispatchEvent(new Event("dsf"));
		FriendsWindow.bup.dispatchEvent(new Event("Пора"));
      }
	  
	  public function val(p:String) : void
      {
		var parser:Object = JSON.parse(p);
		if (parser.h == 0)
		{
			AddRequestView._validateCheckUidIcon.markAsValid();
			AddRequestView._validateCheckUidIcon.dispatchEvent(new Event("t"));
		}else{
			AddRequestView._validateCheckUidIcon.markAsInvalid();
			AddRequestView._validateCheckUidIcon.dispatchEvent(new Event("t1"));
		}
      }
	  
	  public function parseFr(p:String) : void
      {
		//throw new Error(p);
        var obj:Object = JSON.parse(p);
        Friend.list = obj.d.split("э");
        Friend.listin = obj.i.split("э");
        Friend.listot = obj.o.split("э");
        Friend.liston = obj.l.split("э");
        Friend.listob = obj.b.split("э");
		//trace(Friend.list + " s " + Friend.listin + " s " + Friend.listob + " s " + Friend.liston + " s " + Friend.listot);
		
		if (Friend.list.length == 1 && Friend.list[0] == "")
		{
			Friend.list = new Array();
		}
		if (Friend.listin.length == 1 && Friend.listin[0] == "")
		{
			Friend.listin = new Array();
		}
		if (Friend.listot.length == 1 && Friend.listot[0] == "")
		{
			Friend.listot = new Array();
		}
		if (Friend.liston.length == 1 && Friend.liston[0] == "")
		{
			Friend.liston = new Array();
		}
		/*
		for (var gh:int = 0; gh < Friend.list.length; gh++)
		{
			if (Friend.list[gh] == fgt || Friend.list[gh] == fgt1 && Friend.list.length != 0)
			//if (Friend.list[gh] == fgt || Friend.list[gh] == fgt1 && Friend.list.length != 1 && Friend.list.length != 0)
			//if (Friend.list[gh] == fgt1)
			{
				Friend.list.splice(gh,1);
			}
		}
		for (var gh1:int = 0; gh1 < Friend.listin.length; gh1++)
		{
			if (Friend.listin[gh1] == fgt || Friend.listin[gh] == fgt1 && Friend.listin.length != 0)
			//if (Friend.listin[gh] == fgt || Friend.listin[gh] == fgt1 && Friend.listin.length != 1 && Friend.listin.length != 0)
			//if (Friend.listin[gh] == fgt1)
			{
				Friend.listin.splice(gh1,1);
			}
		}
		for (var gh2:int = 0; gh2 < Friend.listot.length; gh2++)
		{
			if (Friend.listot[gh2] == fgt || Friend.listot[gh2] == fgt1 && Friend.listot.length != 0)
			//if (Friend.listot[gh] == fgt || Friend.listot[gh] == fgt1 && Friend.listot.length != 1 && Friend.listot.length != 0)
			//if (Friend.listot[gh] == fgt1)
			{
				Friend.listot.splice(gh2,1);
			}
		}
		for (var gh2:int = 0; gh2 < Friend.liston.length; gh2++)
		{
			if (Friend.liston[gh2] == fgt || Friend.liston[gh2] == fgt1 && Friend.liston.length != 0)
			//if (Friend.listot[gh] == fgt || Friend.listot[gh] == fgt1 && Friend.listot.length != 1 && Friend.listot.length != 0)
			//if (Friend.listot[gh] == fgt1)
			{
				Friend.liston.splice(gh2,1);
			}
		}
		*/
		for (var gh3:int = 0; gh3 < Friend.list.length; gh3++)
		{
			this.networker.send("lobby;get_rank;" + gh3 + ";" + Friend.list[gh3] + ";0;");
		}
		for (var gh4:int = 0; gh4 < Friend.listin.length; gh4++)
		{
			//this.networker.send("garage;get_rangi" + gh + ";" + Friend.listin[gh] + ";");
		}
		for (var gh5:int = 0; gh5 < Friend.listot.length; gh5++)
		{
			this.networker.send("lobby;get_rank;" + gh5 + ";" + Friend.listot[gh5] + ";1;");
		}
		var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
		if (storage.data.fff1 != null && storage.data.fff2 != null)
		{
			if (storage.data.fff1 != Friend.list.length || storage.data.fff2 != Friend.listot.length)
			{
				//throw new Error(storage.data.fff1 + "	" + Friend.list.length + "	" + storage.data.fff2 + "	" + Friend.listot.length);
				PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.frButton.i2.visible = true;
			}
		}
		//throw new Error(storage.data.fff2);
		storage.data.fff1 = Friend.list.length;
		//storage.flush();
		storage.data.fff2 = Friend.listot.length;
		//storage.flush();
		//throw new Error(storage.data.fff2);
      }
      
      public function initPanel(crystall:int, email:String, tester:Boolean, name:String, nextScore:int, place:int, rang:int, rating:int, score:int) : void
      {
         modelPanel = PanelModel(Main.osgi.getService(IPanel));
         modelPanel.initObject(Game.getInstance.classObject,crystall,email,tester,name,nextScore,place,rang,rating,score);
         modelPanel.lock();
         var user1:UserData = new UserData(name,name,rang);
         Main.osgi.registerService(IUserData,user1);
         this.init();
      }
      
      public function beforeAuth() : void
      {
         this.networker = Main.osgi.getService(INetworker) as Network;
         this.networker.addEventListener(this);
      }
      
      private function init() : void
      {
         this.chat.start(Game.getInstance.osgi);
         this.battleSelect.start(Game.getInstance.osgi);
		 if (!modelPanel.isInBattle)
		 {
			modelPanel.networker.send("lobby;get_data_init_battle_select");
			modelPanel.isBattleSelect = true;
		 }
		 //new Newes(this.chat.chatModel);
      }
      
      public function getItemProperty(src:String) : ItemProperty
      {
         switch(src)
         {
            case "damage":
               return ItemProperty.DAMAGE;
            case "damage_per_second":
               return ItemProperty.DAMAGE_PER_SECOND;
            case "aiming_error":
               return ItemProperty.AIMING_ERROR;
            case "cone_angle":
               return ItemProperty.CONE_ANGLE;
            case "shot_force":
               return ItemProperty.SHOT_FORCE;
			case "per_kr":
               return ItemProperty.PER_KR;
			case "t_gor":
               return ItemProperty.T_GOR;
			case "krit":
               return ItemProperty.KRIT;
			case "per_prost":
               return ItemProperty.PER_PROST;
			case "mass":
               return ItemProperty.MASS;
			case "power":
               return ItemProperty.POWER;
            case "shot_frequency":
               return ItemProperty.SHOT_FREQUENCY;
            case "shot_range":
               return ItemProperty.SHOT_RANGE;
            case "turn_speed":
               return ItemProperty.TURN_SPEED;
            case "mech_resistance":
               return ItemProperty.MECH_RESISTANCE;
            case "plasma_resistance":
               return ItemProperty.PLASMA_RESISTANCE;
            case "rail_resistance":
               return ItemProperty.RAIL_RESISTANCE;
            case "vampire_resistance":
               return ItemProperty.VAMPIRE_RESISTANCE;
            case "armor":
               return ItemProperty.ARMOR;
            case "turret_turn_speed":
               return ItemProperty.TURRET_TURN_SPEED;
            case "fire_resistance":
               return ItemProperty.FIRE_RESISTANCE;
            case "thunder_resistance":
               return ItemProperty.THUNDER_RESISTANCE;
            case "freeze_resistance":
               return ItemProperty.FREEZE_RESISTANCE;
            case "ricochet_resistance":
               return ItemProperty.RICOCHET_RESISTANCE;
            case "healing_radius":
               return ItemProperty.HEALING_RADUIS;
            case "heal_rate":
               return ItemProperty.HEAL_RATE;
            case "vampire_rate":
               return ItemProperty.VAMPIRE_RATE;
            case "speed":
               return ItemProperty.SPEED;
            default:
               return null;
         }
      }
      
      public function getTypeItem(sct:int) : ItemTypeEnum
      {
         switch(sct)
         {
            case 2:
               return ItemTypeEnum.ARMOR;
            case 1:
               return ItemTypeEnum.WEAPON;
            case 3:
               return ItemTypeEnum.COLOR;
            case 4:
               return ItemTypeEnum.INVENTORY;
            case 5:
               return ItemTypeEnum.PLUGIN;
            default:
               return null;
         }
      }
   }
}
