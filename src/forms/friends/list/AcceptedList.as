package forms.friends.list
{
   import forms.friends.IFriendsListState;
   import forms.friends.list.dataprovider.FriendsDataProvider;
   import forms.friends.list.renderer.FriendsAcceptedListRenderer;
   import forms.friends.list.renderer.HeaderAcceptedList;
   import alternativa.tanks.model.Friend;
   
   public class AcceptedList extends FriendsList implements IFriendsListState
   {
      
      public static var SCROLL_ON:Boolean;
       
      
      private var _header:HeaderAcceptedList = new HeaderAcceptedList();
      
      public function AcceptedList()
      {
         super();
		 initList();
         init(FriendsAcceptedListRenderer);
         _dataProvider.getItemAtHandler = this.markAsViewed;
         addChild(this._header);
      }
      
      private function markAsViewed(param1:Object) : void
      {
         if(!isViewed(param1) && param1.isNew)
         {
            //friendInfoService.removeNewAcceptedFriend(param1.id);
            setAsViewed(param1);
         }
      }
      
      public function initList() : void
      {
		  /*
         snFriendsService.addEventListener(SNFriendsServiceEvent.GET_FRIENDS_COMPLETED,this.onGetFriends);
         snFriendsService.requestFriends();
         friendInfoService.addEventListener(FriendStateChangeEvent.CHANGE,this.onChangeFriendState);
         friendInfoService.addEventListener(NewFriendEvent.ACCEPTED_CHANGE,this.onNewFriendChange);
         contextMenuService.addEventListener(ContextMenuServiceEvent.REMOVE_FROM_FRIENDS,this.onRemoveFromFriends);
         onlineNotifierService.addEventListener(OnlineNotifierServiceEvent.SET_ONLINE,this.onSetOnline);
         battleNotifierService.addEventListener(SetBattleNotifierServiceEvent.SET_BATTLE,this.onSetBattle);
         battleNotifierService.addEventListener(LeaveBattleNotifierServiceEvent.LEAVE,this.onLeaveBattle);
         battleInfoService.addEventListener(BattleInfoServiceEvent.SELECTION_BATTLE,this.onSelectBattleInfo);
         battleInfoService.addEventListener(BattleInfoServiceEvent.RESET_SELECTION_BATTLE,this.onResetSelectBattleInfo);
         battleInviteService.addEventListener(BattleInviteServiceEvent.REMOVE_INVITE,this.onRemoveInvite);
		 */
         _dataProvider.sortOn([FriendsDataProvider.IS_NEW,FriendsDataProvider.ONLINE,FriendsDataProvider.IS_BATTLE,FriendsDataProvider.UID],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.CASEINSENSITIVE]);
         fillFriendsList(Friend.list,Friend.r);
         _list.scrollToIndex(2);
         this.resize(_width,_height);
      }
      /*
      private function onGetFriends(param1:SNFriendsServiceEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:SNFriendsServiceData = param1.getResult();
         var _loc3_:int = 0;
         while(_loc3_ < friendInfoService.acceptedFriendsLength)
         {
            _loc4_ = _dataProvider.getItemAt(_loc3_);
            if(_loc4_.snUid != "")
            {
               _dataProvider.setPropertiesById(_loc4_.id,"isSNFriend",_loc2_.areFriends(_loc4_.snUid));
            }
            _loc3_++;
         }
      }
      
      private function onNewFriendChange(param1:NewFriendEvent) : void
      {
         _dataProvider.setUserAsNew(param1.userId);
      }
      
      private function onChangeFriendState(param1:FriendStateChangeEvent) : void
      {
         if(param1.state != FriendState.ACCEPTED)
         {
            _dataProvider.removeUser(param1.userId);
            this.resize(_width,_height);
            return;
         }
         if(_dataProvider.getItemIndexByProperty("id",param1.userId,true) == -1)
         {
            _dataProvider.addUser(param1.userId);
            this.resize(_width,_height);
         }
      }
      
      private function onRemoveFromFriends(param1:ContextMenuServiceEvent) : void
      {
         _dataProvider.removeUser(param1.userId);
         this.resize(_width,_height);
      }
      
      private function onSetOnline(param1:OnlineNotifierServiceEvent) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Vector.<ClientOnlineNotifierData> = param1.users;
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _dataProvider.setOnlineUser(_loc3_[_loc5_],false);
            _loc2_ = _loc2_ || _loc6_ != -1;
            _loc5_++;
         }
         if(_loc2_)
         {
            _dataProvider.reSort();
         }
      }
      
      private function onSetBattle(param1:SetBattleNotifierServiceEvent) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Vector.<BattleLinkData> = param1.users;
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _dataProvider.setBattleUser(_loc3_[_loc5_],false);
            _loc2_ = _loc2_ || _loc6_ != -1;
            _loc5_++;
         }
         if(_loc2_ > 0)
         {
            _dataProvider.reSort();
         }
      }
      
      private function onLeaveBattle(param1:LeaveBattleNotifierServiceEvent) : void
      {
         _dataProvider.clearBattleUser(param1.userId);
      }
      
      private function onResetSelectBattleInfo(param1:BattleInfoServiceEvent) : void
      {
         _dataProvider.updatePropertyAvailableInvite();
      }
      
      private function onSelectBattleInfo(param1:BattleInfoServiceEvent) : void
      {
         _dataProvider.updatePropertyAvailableInvite();
      }
      
      private function onRemoveInvite(param1:BattleInviteServiceEvent) : void
      {
         _dataProvider.updatePropertyAvailableInviteById(param1.userId);
      }
      */
      override public function resize(param1:Number, param2:Number) : void
      {
         _width = param1;
         _height = param2;
         AcceptedList.SCROLL_ON = _list.verticalScrollBar.visible;
         this._header.width = _width;
         _list.y = 20;
         _list.width = !!AcceptedList.SCROLL_ON?Number(_width + 6):Number(_width);
         _list.height = _height - 20;
      }
      
      public function hide() : void
      {
		 /*
         contextMenuService.removeEventListener(ContextMenuServiceEvent.REMOVE_FROM_FRIENDS,this.onRemoveFromFriends);
         friendInfoService.removeEventListener(FriendStateChangeEvent.CHANGE,this.onChangeFriendState);
         friendInfoService.removeEventListener(NewFriendEvent.ACCEPTED_CHANGE,this.onNewFriendChange);
         onlineNotifierService.removeEventListener(OnlineNotifierServiceEvent.SET_ONLINE,this.onSetOnline);
         battleNotifierService.removeEventListener(SetBattleNotifierServiceEvent.SET_BATTLE,this.onSetBattle);
         battleNotifierService.removeEventListener(LeaveBattleNotifierServiceEvent.LEAVE,this.onLeaveBattle);
         battleInfoService.removeEventListener(BattleInfoServiceEvent.SELECTION_BATTLE,this.onSelectBattleInfo);
         battleInfoService.removeEventListener(BattleInfoServiceEvent.RESET_SELECTION_BATTLE,this.onResetSelectBattleInfo);
         battleInviteService.removeEventListener(BattleInviteServiceEvent.REMOVE_INVITE,this.onRemoveInvite);
         snFriendsService.removeEventListener(SNFriendsServiceEvent.GET_FRIENDS_COMPLETED,this.onGetFriends);
		 */
         if(parent.contains(this))
         {
            parent.removeChild(this);
            _dataProvider.removeAll();
         }
      }
      
      public function filter(param1:String, param2:String) : void
      {
         filterByProperty(param1,param2);
         this.resize(_width,_height);
      }
      
      public function resetFilter() : void
      {
         _dataProvider.resetFilter();
         this.resize(_width,_height);
      }
   }
}
