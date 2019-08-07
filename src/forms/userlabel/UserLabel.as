package forms.userlabel
{
   import alternativa.tanks.model.Friend;
   import alternativa.types.Long;
   import controls.base.LabelBase;
   import controls.rangicons.RangIconSmall;
   import flash.display.Sprite;
   import flash.display3D.Context3D;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import forms.ColorConstants;
   import forms.contextmenu.ContextMenu;
   
   public class UserLabel extends Sprite
   {
      
      protected static const RANK_ICON_CONT_WIDTH:int = 20;
      
      private static const RANK_ICON_CONT_HEIGHT:int = 18;
       
      
      protected var shadowContainer:Sprite;
      
      protected var _userId:Long;
      
      protected var _uid:String;
      
      protected var _rank:int;
      
      protected var _uidLabel:LabelBase;
      
      protected var _writeInPublicChat:Boolean;
      
      protected var _writePrivateInChat:Boolean;
      
      protected var _blockUserEnable:Boolean;
      
      protected var _forciblySubscribeFriend:Boolean;
      
      protected var _isInitRank:Boolean;
      
      protected var _isInitUid:Boolean;
      
      protected var _focusOnUserEnabled:Boolean;
      
      protected var _hasPremium:Boolean;
      
      private var _inviteBattleEnable:Boolean;
      
      private var _rankIcon:RangIconSmall;
      
      private var _online:Boolean = false;
	  
	  private var _friend:Boolean = false;
      
      protected var _self:Boolean;
      
      private var _lastUidColor:uint;
      
      private var _ignoreFriendsColor:Boolean;
      
      private var _additionalText:String = "";
      
      protected var _showClanTag:Boolean = true;
      
      private var _showClanProfile:Boolean = true;
      
      private var _showInviteToClan:Boolean = true;
	  
	  private var contextMenuService:ContextMenu = Game.cont;
	  
	  private var nic:String = "";
	  
	  public static var ds:Sprite = new Sprite();
      
      public function UserLabel(param1:Long, param2:Boolean = true)
      {
         this.shadowContainer = new Sprite();
         super();
         if(param1 == null)
         {
            throw Error("UserLabel userId is NULL");
         }
         this._userId = param1;
         this.init();
		 ds.addEventListener("dsf",getlab);
      }
      
      protected function getShadowFilters() : Array
      {
         return null;
      }
      
      private function init() : void
      {
         mouseChildren = false;
         mouseEnabled = true;
         tabEnabled = false;
         tabChildren = false;
         addChild(this.shadowContainer);
         this.shadowContainer.filters = this.getShadowFilters();
         this._lastUidColor = ColorConstants.GREEN_LABEL;
         this.initSelf();
         if(!this._self)
         {
            buttonMode = useHandCursor = true;
         }
         this.createRankIcon();
         this.createAdditionalIcons();
         this.createUidLabel();
         //userInfoService.forciblySubscribe(this._userId);
         //this._userInfoUpdater = userInfoService.getOrCreateUpdater(this._userId);
         //this._friendInfoUpdater = friendInfoService.getOrCreateUpdater(this._userId);
         this.updateProperties();
		 this.friend(false);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function initSelf() : void
      {
         //this._self = userPropertiesService.userId == this._userId;
      }
      
      protected function createAdditionalIcons() : void
      {
      }
      
      protected function updateProperties() : void
      {
		 /*
         if(this._userInfoUpdater.hasData())
         {
            if(this._self)
            {
               this.setRank(userPropertiesService.rank);
            }
            else
            {
               this.setRank(this._userInfoUpdater.rank);
            }
            this.setUid(this._userInfoUpdater.uid);
            this.updateStatusOnline();
         }
         this.setFriendState(this._friendInfoUpdater.state);
		 */
      }
      
      protected function createUidLabel() : void
      {
         this._uidLabel = new LabelBase();
         this._uidLabel.x = RANK_ICON_CONT_WIDTH - 2 + this.getAdditionalIconsWidth();
         this.shadowContainer.addChild(this._uidLabel);
         this._uidLabel.visible = false;
      }
      
      protected function getAdditionalIconsWidth() : Number
      {
         return 0;
      }
      
      private function createRankIcon() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.clear();
         _loc1_.graphics.beginFill(65535,0);
         _loc1_.graphics.drawRect(0,0,RANK_ICON_CONT_WIDTH,RANK_ICON_CONT_HEIGHT);
         _loc1_.graphics.endFill();
         this._rankIcon = new RangIconSmall(0);
         _loc1_.addChild(this._rankIcon);
         this.shadowContainer.addChild(_loc1_);
         this._rankIcon.visible = false;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.setEvent();
         //this._userInfoUpdater.incrementVisibleLabelsCounter();
         //this._friendInfoUpdater.incrementVisibleLabelsCounter();
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.removeEvent();
         //this._userInfoUpdater.decrementVisibleLabelsCounter();
         //this._friendInfoUpdater.decrementVisibleLabelsCounter();
      }
      
      private function setEvent() : void
      {
         if(!this.hasEventListener(MouseEvent.CLICK))
         {
            this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
         //this._userInfoUpdater.addEventListener(UserInfoLabelUpdaterEvent.CHANGE_ONLINE,this.onChangeOnline);
         //this._userInfoUpdater.addEventListener(UserInfoLabelUpdaterEvent.CHANGE_UID,this.onChangeUid);
         //this._userInfoUpdater.addEventListener(UserInfoLabelUpdaterEvent.CHANGE_RANK,this.onChangeRank);
         //premiumService.addEventListener(Event.CHANGE,this.onChangePremiumStatus);
         //this._friendInfoUpdater.addEventListener(FriendInfoLabelUpdaterEvent.CHANGE_STATE,this.onChangeFriendState);
      }
      
      private function removeEvent() : void
      {
         if(this.hasEventListener(MouseEvent.CLICK))
         {
            this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
         //this._userInfoUpdater.removeEventListener(UserInfoLabelUpdaterEvent.CHANGE_ONLINE,this.onChangeOnline);
         //this._userInfoUpdater.removeEventListener(UserInfoLabelUpdaterEvent.CHANGE_UID,this.onChangeUid);
         //this._userInfoUpdater.removeEventListener(UserInfoLabelUpdaterEvent.CHANGE_RANK,this.onChangeRank);
         //premiumService.removeEventListener(Event.CHANGE,this.onChangePremiumStatus);
         //this._friendInfoUpdater.removeEventListener(FriendInfoLabelUpdaterEvent.CHANGE_STATE,this.onChangeFriendState);
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         //if(userPropertiesService.userId == this._userId)
         //{
            //return;
         //}
         if(!this._isInitRank || !this._isInitUid)
         {
            return;
         }
         if(param1.ctrlKey)
         {
            System.setClipboard(this._uid);
         }
         else
         {
            //switch(this._friendState)
            //{
               //case FriendState.ACCEPTED:
                  //_loc3_ = true;
                  //break;
               //case FriendState.INCOMING:
                  //_loc4_ = true;
                  //_loc5_ = true;
                  //break;
               //default:
                  //_loc2_ = true;
            }
			contextMenuService.past(this._rank,this._uid,"bat");
            //contextMenuService.show(this._userId,this._rank,this._uid,_loc2_,_loc3_,_loc4_,_loc5_,this._writeInPublicChat,this._writePrivateInChat,this._blockUserEnable,this._inviteBattleEnable,this._focusOnUserEnabled,this._showClanProfile,this._showInviteToClan);
         }
      
      /*
      private function onChangeOnline(param1:UserInfoLabelUpdaterEvent) : void
      {
         this.updateStatusOnline();
      }
      
      private function updateStatusOnline() : void
      {
         this._online = this._userInfoUpdater.online;
      }
      
      private function onChangeUid(param1:UserInfoLabelUpdaterEvent) : void
      {
         this.setUid(this._userInfoUpdater.uid);
      }
      */
      public function setUid(param1:String,param2:String = "") : void
      {
         if(!this._isInitUid)
         {
            this._isInitUid = true;
            this._uidLabel.visible = true;
         }
         this._uid = param1;
         //var _loc2_:String = this.getUidWithClanTag(this._uid);
         //var _loc3_:String = _loc2_ + this._additionalText;
         //if(this._uidLabel.text == _loc3_)
         //{
            //return;
         //}
         this._uidLabel.text = param1;
		 if (param2 != null && param2 != "")
		 {
			nic = param2;
			getlab();
		 }
         //dispatchEvent(new ChatUpdateEvent(ChatUpdateEvent.UPDATE,true));
      }
	  
	  public function getlab(e:Event = null) : void
      {
		if (nic != null && nic != "")
		{
			var uj1:int = Friend.list.indexOf(nic);
			var uj:Boolean = Friend.list[uj1] == nic?true:false;
			friend(uj);
			if (uj)
			{
				online1(Friend.liston[uj1] == "1"?true:false);
			}
		}
      }
	  
      /*
      public function getUidWithClanTag(param1:String) : String
      {
         var _loc2_:UserClanInfo = clanUserInfoService.userClanInfoByUserId(this.userId);
         var _loc3_:String = "";
         if(this._showClanTag && _loc2_ != null && _loc2_.isInClan)
         {
            _loc3_ = "[" + _loc2_.clanTag + "] ";
         }
         return _loc3_ + param1;
      }
      
      public function setAdditionalText(param1:String) : void
      {
         if(this._additionalText == param1)
         {
            return;
         }
         this._additionalText = param1;
         this.setUid(this._uid);
      }
      
      private function onChangeRank(param1:UserInfoLabelUpdaterEvent) : void
      {
         this.setRank(this._userInfoUpdater.rank);
      }
      
      private function onChangePremiumStatus(param1:Event = null) : void
      {
         this.updateProperties();
      }
      */
      public function setRank(param1:int) : void
      {
         this._rank = param1;
         //this.updateStatusPremium();
         //if(!this._isInitRank)
         //{
            this._isInitRank = true;
			//throw new Error(this._rank);
            this._rankIcon = new RangIconSmall(this._rank);
            this._rankIcon.visible = true;
			this.addChild(_rankIcon);
         //}
         //else
         //{
            //this._rankIcon = new RangIconSmall(this._rank);
         //}
         this.alignRankIcon();
      }
      /*
      protected function updateStatusPremium() : void
      {
         if(this._self)
         {
            this._hasPremium = premiumService.hasPremium();
         }
         else
         {
            this._hasPremium = false;
         }
      }
      */
      private function alignRankIcon() : void
      {
         this._rankIcon.x = RANK_ICON_CONT_WIDTH - this._rankIcon.width >> 1;
         this._rankIcon.y = RANK_ICON_CONT_HEIGHT - this._rankIcon.height >> 1;
      }
      /*
      private function onChangeFriendState(param1:FriendInfoLabelUpdaterEvent) : void
      {
         this.setFriendState(this._friendInfoUpdater.state);
      }
      
      protected function setFriendState(param1:FriendState) : void
      {
         this._friendState = param1;
         this.refreshFriendState();
      }
      
      protected function refreshFriendState() : void
      {
         if(!this._ignoreFriendsColor)
         {
            if(this._friendState == FriendState.ACCEPTED)
            {
               this._uidLabel.color = ColorConstants.FRIEND_COLOR;
               return;
            }
            this._uidLabel.color = this._lastUidColor;
         }
      }
      */
      public function setUidColor(param1:uint, param2:Boolean = false) : void
      {
         this._lastUidColor = param1;
         this._ignoreFriendsColor = param2;
         this._uidLabel.color = param1;
         //this.refreshFriendState();
      }
	  
	  public function online1(v:Boolean) : void
      {
         this._online = v;
		 this.setUidColor(v?(this._friend?uint(ColorConstants.FRIEND_COLOR):uint(ColorConstants.GREEN_LABEL)):uint(ColorConstants.ACCESS_LABEL),true)
      }
	  
	  public function get online() : Boolean
      {
         return this._online;
      }
	  
	  public function get tw() : int
      {
         return this._uidLabel.textWidth;
      }
	  
	  public function friend(v:Boolean) : void
      {
         this._friend = v;
		 if(this._friend)
         {
            this._uidLabel.color = ColorConstants.FRIEND_COLOR;
            return;
         }
      }
      
      public function get userRank() : int
      {
         return this._rank;
      }
      
      public function get self() : Boolean
      {
         return this._self;
      }
      
      public function get uid() : String
      {
         return this._uid;
      }
      
      public function get userId() : Long
      {
         return this._userId;
      }
      
      public function get inviteBattleEnable() : Boolean
      {
         return this._inviteBattleEnable;
      }
      
      public function set inviteBattleEnable(param1:Boolean) : void
      {
         this._inviteBattleEnable = param1;
      }
      
      public function get premium() : Boolean
      {
         return this._hasPremium;
      }
      
      public function get showClanProfile() : Boolean
      {
         return this._showClanProfile;
      }
      
      public function set showClanProfile(param1:Boolean) : void
      {
         this._showClanProfile = param1;
      }
      
      public function get showInviteToClan() : Boolean
      {
         return this._showInviteToClan;
      }
      
      public function set showInviteToClan(param1:Boolean) : void
      {
         this._showInviteToClan = param1;
      }
   }
}
