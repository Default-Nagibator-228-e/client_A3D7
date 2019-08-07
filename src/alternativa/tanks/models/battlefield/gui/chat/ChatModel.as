package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.init.Main;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.model.user.IUserDataListener;
   import alternativa.tanks.models.battlefield.IUserStat;
   import alternativa.types.Long;
   import flash.display.DisplayObjectContainer;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import utils.client.battlefield.gui.models.chat.ChatModelBase;
   import utils.client.battlefield.gui.models.chat.IChatModelBase;
   import utils.client.battleservice.model.team.BattleTeamType;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   
   public class ChatModel extends ChatModelBase implements IChatModelBase, IObjectLoadListener, IPanelListener, IChatBattle
   {
       
      
      private var userStat:IUserStat;
      
      private var bfClientObject:ClientObject;
      
      private var contentLayer:DisplayObjectContainer;
      
      private var teamOnly:Boolean;
      
      private var battleChat:BattleChat;
      
      private var uiLockCount:int;
      
      public function ChatModel()
      {
         super();
         _interfaces.push(IModel,IChatModelBase,IObjectLoadListener,IUserDataListener,IPanelListener);
         this.contentLayer = Main.contentUILayer;
         this.battleChat = new BattleChat();
         Main.osgi.registerService(IChatBattle,this);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.bfClientObject = object;
         this.battleChat.clear();
         this.contentLayer.addChild(this.battleChat);
         this.battleChat.addEventListener(BattleChatEvent.SEND_MESSAGE,this.onSendMessage);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         var modelService:IModelService = Main.osgi.getService(IModelService) as IModelService;
         this.battleChat.alwaysShow = this.getSettings().showBattleChat;
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.battleChat.removeEventListener(BattleChatEvent.SEND_MESSAGE,this.onSendMessage);
         this.battleChat.clear();
		 rem(this.contentLayer,this.battleChat);
         Main.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.bfClientObject = null;
      }
	  
	  private function rem(d:DisplayObjectContainer,o:DisplayObject) : void
      {
         if (o != null && d != null && d.contains(o))
		 {
			 d.removeChild(o);
		 }
      }
      
      public function bugReportOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function bugReportClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function exchangeOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function exchangeClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function settingsAccepted() : void
      {
         this.updateUILock(-1);
         this.battleChat.alwaysShow = this.getSettings().showBattleChat;
      }
      
      public function settingsOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function settingsCanceled() : void
      {
         this.updateUILock(-1);
      }
      
      public function setMuteSound(mute:Boolean) : void
      {
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case Keyboard.ENTER:
               this.teamOnly = e.ctrlKey;
               this.battleChat.openChat();
               break;
            case 84:
               if(!this.battleChat.chatOpened)
               {
                  this.teamOnly = true;
                  this.battleChat.openChat();
               }
         }
      }
      
      private function onSendMessage(e:BattleChatEvent) : void
      {
         this.sendMessage(this.bfClientObject,e.message,this.teamOnly);
      }
      
      private function sendMessage(cl:ClientObject, msg:String, team:Boolean) : void
      {
         var reg:RegExp = /;/g;
         var reg2:RegExp = /~/g;
         msg = msg.replace(reg," ").replace(reg2," ");
         Network(Main.osgi.getService(INetworker)).send("battle;chat;" + msg + ";" + team);
      }
      
      public function addMessage(clientObject:ClientObject, userId:Long, message:String, type:BattleTeamType, teamOnly:Boolean, nick:String = null, rank:int = 0) : void
      {
         var messageLabel:String = type != BattleTeamType.NONE && teamOnly?"[TEAM]":null;
         var userName:String = nick;
         var userRank:int = rank;
         this.battleChat.addUserMessage(messageLabel,userName,userRank,type,message + "\n");
      }
      
      public function addSpectatorMessage(message:String) : void
      {
         this.battleChat.addSpectatorMessage(message + "\n");
      }
      
      public function addSystemMessage(clientObject:ClientObject, message:String) : void
      {
         this.battleChat.addSystemMessage(message);
      }
      
      private function updateUILock(delta:int) : void
      {
         this.uiLockCount = this.uiLockCount + delta;
         if(this.bfClientObject != null)
         {
            if(this.uiLockCount > 0)
            {
               this.battleChat.closeChat();
               this.battleChat.locked = true;
            }
            else
            {
               this.battleChat.locked = false;
            }
         }
      }
      
      private function getSettings() : IBattleSettings
      {
         return IBattleSettings(Main.osgi.getService(IBattleSettings));
      }
   }
}

import alternativa.types.Long;
import utils.client.battleservice.model.team.BattleTeamType;

class ExpectingMessage
{
    
   
   public var messageLabel:String;
   
   public var userID:Long;
   
   public var message:String;
   
   public var type:BattleTeamType;
   
   function ExpectingMessage(messageLabel:String, userID:Long, type:BattleTeamType, message:String)
   {
      super();
      this.messageLabel = messageLabel;
      this.userID = userID;
      this.message = message;
      this.type = type;
   }
}
