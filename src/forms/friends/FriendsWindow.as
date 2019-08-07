package forms.friends
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.friends.list.AcceptedList;
   import forms.friends.list.IncomingList;
   import alternativa.tanks.model.Friend;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import forms.TankWindowWithHeader;
   import alternativa.network.Network;
   
   public class FriendsWindow extends Sprite
   {
	  
      public static var localeService:ILocaleService;
	  
	  public static var bup:Sprite = new Sprite();
	  
	  public static var bu:Network;
      
      public static const WINDOW_MARGIN:int = 12;
      
      public static const DEFAULT_BUTTON_WIDTH:int = 100;
      
      public static const BUTTON_WITH_ICON_WIDTH:int = 115;
      
      public static const WINDOW_WIDTH:int = 468 + WINDOW_MARGIN * 2 + 4;
      
      private static const WINDOW_HEIGHT:int = 485;
       
      
      private var window:TankWindowWithHeader;
      
      private var windowInner:TankWindowInner;
      
      public var windowSize:Point;
      
      private var incomingButton:FriendsWindowStateSmallButton;
      
      private var acceptedFriendButton:FriendsWindowStateBigButton;
      
      private var closeButton:FriendWindowButton;
      
      private var rejectAllIncomingButton:RejectAllIncomingButton;
      
      private var acceptedList:AcceptedList;
      
      private var incomingList:IncomingList;
      
      private var currentList:IFriendsListState;
      
      private var addRequestView:AddRequestView;
	  
	  private var hh:Boolean = false;
      
      public function FriendsWindow(p:Network)
      {
         super();
		 bu = p;
         this.initWindow();
         this.initButtons();
         this.initLists();
         this.addFriendRequestView(p);
         this.initOthers();
         this.resize(null);
         addEventListener(Event.ADDED_TO_STAGE, this.added);
		 addEventListener(Event.RESIZE,resize);
      }
	  
	  private function added(param1:Event) : void
      {
         this.show(FriendsWindowState.ACCEPTED);
      }
      
      private function initWindow() : void
      {
         this.window = TankWindowWithHeader.createWindow("ДРУЗЬЯ");
         addChild(this.window);
         this.windowSize = new Point(WINDOW_WIDTH,WINDOW_HEIGHT);
         this.windowInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.windowInner);
      }
      
      private function initButtons() : void
      {
         this.acceptedFriendButton = new FriendsWindowStateBigButton(FriendsWindowState.ACCEPTED);
         this.acceptedFriendButton.text = "Друзья";
         this.acceptedFriendButton.addEventListener(MouseEvent.CLICK,this.onChangeState);
         addChild(this.acceptedFriendButton);
         this.incomingButton = new FriendsWindowStateSmallButton(FriendsWindowState.INCOMING);
         this.incomingButton.addEventListener(MouseEvent.CLICK,this.onChangeState);
         addChild(this.incomingButton);
         this.rejectAllIncomingButton = new RejectAllIncomingButton();
         this.rejectAllIncomingButton.label = "Отклонить всех";
         this.rejectAllIncomingButton.addEventListener(MouseEvent.CLICK,this.onClickRejectAllIncoming);
         addChild(this.rejectAllIncomingButton);
         this.closeButton = new FriendWindowButton();
         this.closeButton.label = "Закрыть";
         addChild(this.closeButton);
      }
	  
	  private function rem() : void
      {
		 this.acceptedFriendButton.removeEventListener(MouseEvent.CLICK, this.onChangeState);
		 this.incomingButton.removeEventListener(MouseEvent.CLICK, this.onChangeState);
		 this.rejectAllIncomingButton.removeEventListener(MouseEvent.CLICK,this.onClickRejectAllIncoming);
      }
	  
	  private function ot() : void
      {
		 this.acceptedFriendButton.addEventListener(MouseEvent.CLICK, this.onChangeState);
		 this.incomingButton.addEventListener(MouseEvent.CLICK, this.onChangeState);
		 this.rejectAllIncomingButton.addEventListener(MouseEvent.CLICK,this.onClickRejectAllIncoming);
      }
      
      private function initLists() : void
      {
         this.acceptedList = new AcceptedList();
         this.incomingList = new IncomingList(this.rejectAllIncomingButton);
      }
      
      private function initOthers() : void
      {
         //battleLinkActivatorService.addEventListener(BattleLinkActivatorServiceEvent.ACTIVATE_LINK,this.onBattleLinkClick);
      }
      
      private function addFriendRequestView(p:Network) : void
      {
         this.addRequestView = new AddRequestView(p);
         addChild(this.addRequestView);
         this.addRequestView.show();
      }
      
      private function onClickRejectAllIncoming(param1:MouseEvent) : void
      {
         for (var yi:int = 0; yi < Friend.listot.length; yi++)
		 {
			bu.send("lobby;del_infriend;" + Friend.listot[yi] + ";");
		 }
      }
      
      //private function onConfirmRejectAllIncoming(param1:AlertServiceEvent) : void
      //{
         //alertService.removeEventListener(AlertServiceEvent.ALERT_BUTTON_PRESSED,this.onConfirmRejectAllIncoming);
         //if(param1.typeButton == localeService.getText(TanksLocale.TEXT_ALERT_ANSWER_YES))
         //{
            //friendsActionService.rejectAllIncoming();
         //}
      //}
      
      //private function onBattleLinkClick(param1:BattleLinkActivatorServiceEvent) : void
      //{
         //this.hide();
      //}
      
      private function resize(param1:Event = null) : void
      {
         this.window.width = this.windowSize.x;
         this.window.height = this.windowSize.y;
         this.acceptedFriendButton.x = WINDOW_MARGIN;
         this.acceptedFriendButton.width = BUTTON_WITH_ICON_WIDTH;
         this.acceptedFriendButton.y = WINDOW_MARGIN;
         this.incomingButton.x = this.windowSize.x - WINDOW_MARGIN - this.incomingButton.width;
         this.incomingButton.y = WINDOW_MARGIN;
         this.closeButton.width = DEFAULT_BUTTON_WIDTH;
         this.closeButton.x = this.windowSize.x - this.closeButton.width - WINDOW_MARGIN;
         this.closeButton.y = this.windowSize.y - this.closeButton.height - WINDOW_MARGIN;
         this.rejectAllIncomingButton.width = DEFAULT_BUTTON_WIDTH;
         this.rejectAllIncomingButton.x = this.closeButton.x - this.rejectAllIncomingButton.width - 6;
         this.rejectAllIncomingButton.y = this.windowSize.y - this.rejectAllIncomingButton.height - WINDOW_MARGIN;
         this.windowInner.x = WINDOW_MARGIN;
         this.windowInner.y = this.acceptedFriendButton.y + this.acceptedFriendButton.height + 1;
         this.windowInner.width = this.windowSize.x - WINDOW_MARGIN * 2;
         this.windowInner.height = this.windowSize.y - this.windowInner.y - this.closeButton.height - 18;
         var _loc1_:int = 4;
         var _loc2_:int = this.windowInner.x + _loc1_;
         var _loc3_:int = this.windowInner.y + _loc1_;
         var _loc4_:int = this.windowInner.width - _loc1_ * 2 + 2;
         var _loc5_:int = this.windowInner.height - _loc1_ * 2;
         this.acceptedList.resize(_loc4_,_loc5_);
         this.acceptedList.x = _loc2_;
         this.acceptedList.y = _loc3_;
         this.incomingList.resize(_loc4_,_loc5_);
         this.incomingList.x = _loc2_;
         this.incomingList.y = _loc3_;
         this.addRequestView.y = this.windowSize.y - this.addRequestView.height - WINDOW_MARGIN;
      }
      
      private function onChangeState(param1:MouseEvent) : void
      {
		 hh = !hh;
         this.show(FriendsWindowButtonType(param1.currentTarget).getType());
      }
      
      public function destroy() : void
      {
         this.acceptedFriendButton.removeEventListener(MouseEvent.CLICK,this.onChangeState);
         this.incomingButton.removeEventListener(MouseEvent.CLICK,this.onChangeState);
         //battleLinkActivatorService.removeEventListener(BattleLinkActivatorServiceEvent.ACTIVATE_LINK,this.onBattleLinkClick);
         this.rejectAllIncomingButton.removeEventListener(MouseEvent.CLICK,this.onClickRejectAllIncoming);
         this.hide();
      }
      
      private function hide() : void
      {
         //dialogService.removeDialog(this);
         if(this.closeButton.hasEventListener(MouseEvent.CLICK))
         {
            this.closeButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         }
         if(this.currentList != null)
         {
            this.currentList.hide();
            this.currentList = null;
         }
		 bup.removeEventListener("Пора",job);
         this.addRequestView.hide();
      }
	  private function job(param1:Event) : void
      {
		hide();
		//throw new Error("");
		PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.frButton.i2.visible = true;
		if (hh)
		{
			FriendsWindowState.INCOMING = new FriendsWindowState(1);
			show(FriendsWindowState.INCOMING);
			this.incomingButton.type = FriendsWindowState.INCOMING;
		}else{
			FriendsWindowState.ACCEPTED = new FriendsWindowState(0);
			show(FriendsWindowState.ACCEPTED);
			this.acceptedFriendButton.type = FriendsWindowState.ACCEPTED;
		}
      }
      public function show(param1:FriendsWindowState = null) : void
      {
		if (hh)
		{
			FriendsWindowState.INCOMING = new FriendsWindowState(1);
			param1 = FriendsWindowState.INCOMING;
			this.incomingButton.type = FriendsWindowState.INCOMING;
		}else{
			FriendsWindowState.ACCEPTED = new FriendsWindowState(0);
			param1 = FriendsWindowState.ACCEPTED;
			this.acceptedFriendButton.type = FriendsWindowState.ACCEPTED;
		}
         //this.updateAcceptedCounter();
         //this.updateIncomingCounter();
         //if(param1 != FriendsWindowState.REFERRALS)
         //{
            //this.updateReferralsCounter();
         //}
         //friendInfoService.addEventListener(NewFriendEvent.ACCEPTED_CHANGE,this.onUpdateAcceptedCounter);
         //friendInfoService.addEventListener(NewFriendEvent.INCOMING_CHANGE,this.onUpdateIncomingCounter);
		 bup.addEventListener("Пора",job);
         var _loc2_:IFriendsListState = this.getFriendsListByState(param1);
         this.updateState(param1);
         _loc2_.initList();
         addChild(Sprite(_loc2_));
         this.currentList = _loc2_;
         this.currentList.resetFilter();
		 PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.frButton.i2.visible = false;
      }
      
      private function getFriendsListByState(param1:FriendsWindowState) : IFriendsListState
      {
         switch(param1)
         {
            case FriendsWindowState.ACCEPTED:
               return this.acceptedList;
            case FriendsWindowState.INCOMING:
               return this.incomingList;
            //case FriendsWindowState.CLAN_MEMBERS:
               //return this.clanList;
            default:
               return this.acceptedList;
         }
      }
      
      //private function updateReferralsCounter() : void
      //{
         //newReferralsNotifierService.requestNewReferralsCount();
     // }
      
      private function updateState(param1:FriendsWindowState) : void
      {
         this.currentState = param1;
         if(this.currentList != null)
         {
            this.currentList.hide();
            this.currentList = null;
         }
         //dialogService.addDialog(this);
         if(!this.closeButton.hasEventListener(MouseEvent.CLICK))
         {
            this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         }
      }
      
      private function onCloseButtonClick(param1:MouseEvent = null) : void
      {
         this.closeWindow();
      }
      
      private function closeWindow() : void
      {
         //userChangeGameScreenService.friendWindowClosed();
         //display.stage.focus = null;
		 var panelModel:IPanel = IPanel(Main.osgi.getService(IPanel));
		 panelModel.closeFriend();
		 this.visible = false;
         this.hide();
      }
	  
	  private function curState(param1:FriendsWindowState) : void
      {
         switch(param1)
         {
            case FriendsWindowState.ACCEPTED:
               this.acceptedFriendButton.enable = false;
               this.incomingButton.isPressed = false;
               this.rejectAllIncomingButton.visible = false;
               this.windowInner.visible = true;
               this.addRequestView.show();
               break;
            case FriendsWindowState.INCOMING:
               this.acceptedFriendButton.enable = true;
               this.incomingButton.isPressed = true;
               this.rejectAllIncomingButton.visible = true;
               this.windowInner.visible = true;
               this.addRequestView.hide();
         }
      }
      
      public function set currentState(param1:FriendsWindowState) : void
      {
         switch(param1)
         {
            case FriendsWindowState.ACCEPTED:
               this.acceptedFriendButton.enable = false;
               this.incomingButton.isPressed = false;
               this.rejectAllIncomingButton.visible = false;
               this.windowInner.visible = true;
               this.addRequestView.show();
               break;
            case FriendsWindowState.INCOMING:
               this.acceptedFriendButton.enable = true;
               this.incomingButton.isPressed = true;
               this.rejectAllIncomingButton.visible = true;
               this.windowInner.visible = true;
               this.addRequestView.hide();
         }
      }
      
      //override protected function cancelKeyPressed() : void
      //{
         //this.onCloseButtonClick();
      //}
   }
}
