package forms.friends
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.types.Long;
   import controls.ValidationIcon;
   import controls.base.LabelBase;
   import controls.base.TankInputBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import forms.ColorConstants;
   import forms.events.LoginFormEvent;
   import alternativa.network.Network;
   
   public class AddRequestView extends Sprite
   {
      
      public static var localeService:ILocaleService;
      
      private static const SEARCH_TIMEOUT:int = 600;
       
      
      private var _searchFriendTextInput:TankInputBase;
      
      private var _searchFriendLabel:LabelBase;
      
      private var _addRequestButton:FriendWindowButton;
      
      public static var _validateCheckUidIcon:ValidationIcon;
      
      private var _searchFriendTimeOut:uint;
      
      private var _searchFriendUid:String;
      
      private var _searchFriendExist:Boolean;
      
      private var _searchUserId:Long;
	  
	  private var fgr:Network;
      
      public function AddRequestView(p:Network)
      {
         super();
		 fgr = p;
         this.init();
      }
      
      private function init() : void
      {
         this._searchFriendTextInput = new TankInputBase();
         this._searchFriendTextInput.maxChars = 20;
         this._searchFriendTextInput.restrict = "0-9.a-zA-z_\\-*";
         addChild(this._searchFriendTextInput);
         this._searchFriendLabel = new LabelBase();
         addChild(this._searchFriendLabel);
         this._searchFriendLabel.mouseEnabled = false;
         this._searchFriendLabel.color = ColorConstants.LIST_LABEL_HINT;
         this._searchFriendLabel.text = "Отправить заявку другу...";
         _validateCheckUidIcon = new ValidationIcon();
         addChild(_validateCheckUidIcon);
         this._addRequestButton = new FriendWindowButton();
         addChild(this._addRequestButton);
         this._addRequestButton.label = "Отправить";
         this._addRequestButton.enable = false;
         this.resize();
      }
      
      public function resize() : void
      {
         this._searchFriendTextInput.width = 235;
         this._searchFriendTextInput.x = FriendsWindow.WINDOW_MARGIN;
         this._searchFriendLabel.x = this._searchFriendTextInput.x + 3;
         this._searchFriendLabel.y = this._searchFriendTextInput.y + 7;
         _validateCheckUidIcon.x = this._searchFriendTextInput.x + this._searchFriendTextInput.width - _validateCheckUidIcon.width - 15;
         _validateCheckUidIcon.y = this._searchFriendTextInput.y + 7;
         this._addRequestButton.width = FriendsWindow.DEFAULT_BUTTON_WIDTH;
         this._addRequestButton.x = this._searchFriendTextInput.width + 8;
      }
      
      public function hide() : void
      {
         clearTimeout(this._searchFriendTimeOut);
         this.removeEvents();
         this.clearSearchFriendTextInput();
         this.visible = false;
      }
      
      private function removeEvents() : void
      {
         this._addRequestButton.removeEventListener(MouseEvent.CLICK,this.onClickAddRequestButton);
         this._searchFriendTextInput.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusInSearchFriend);
         this._searchFriendTextInput.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOutSearchFriend);
         this._searchFriendTextInput.textField.removeEventListener(Event.CHANGE, this.onSearchFriendTextChange);
		 _validateCheckUidIcon.removeEventListener("t", this.dfh);
		 _validateCheckUidIcon.removeEventListener("t1",this.dfh1);
         this._searchFriendTextInput.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
	  
	  private function dfh(param1:Event) : void
      {
         _addRequestButton.enable = true;
      }
	  
	  private function dfh1(param1:Event) : void
      {
         _addRequestButton.enable = false;
      }
      
      public function show() : void
      {
         this.visible = true;
         this.setEvents();
         this._searchFriendTextInput.value = "";
         this.updateVisibleSearchFriendLabel();
      }
      
      private function setEvents() : void
      {
         this._addRequestButton.addEventListener(MouseEvent.CLICK,this.onClickAddRequestButton);
         this._searchFriendTextInput.addEventListener(FocusEvent.FOCUS_IN,this.onFocusInSearchFriend);
         this._searchFriendTextInput.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOutSearchFriend);
         this._searchFriendTextInput.textField.addEventListener(Event.CHANGE, this.onSearchFriendTextChange);
		 _validateCheckUidIcon.addEventListener("t", this.dfh);
		 _validateCheckUidIcon.addEventListener("t1",this.dfh1);
         this._searchFriendTextInput.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onClickAddRequestButton(param1:MouseEvent) : void
      {
         this.addRequest();
      }
      
      private function addRequest() : void
      {
         //if(this._searchFriendExist && this._searchFriendUid != null)
         //{
            //friendsActionService.addByUid(this._searchFriendUid);
			fgr.send("lobby;got_friend;" + _searchFriendTextInput.value + ";");
            this.clearSearchFriendTextInput();
         //}
      }
      
      private function clearSearchFriendTextInput() : void
      {
         this._searchFriendTextInput.value = "";
         this._addRequestButton.enable = false;
         _validateCheckUidIcon.turnOff();
         this._searchFriendExist = false;
         this._searchFriendUid = null;
      }
      
      private function onFocusInSearchFriend(param1:FocusEvent) : void
      {
         this._searchFriendLabel.visible = false;
      }
      
      private function onFocusOutSearchFriend(param1:FocusEvent) : void
      {
         this.updateVisibleSearchFriendLabel();
      }
      
      private function updateVisibleSearchFriendLabel() : void
      {
         if(this._searchFriendTextInput.value.length == 0)
         {
            this._searchFriendLabel.visible = true;
            _validateCheckUidIcon.turnOff();
            this._searchFriendTextInput.validValue = true;
         }
      }
      
      private function onSearchFriendTextChange(param1:Event) : void
      {
         this._searchFriendExist = false;
         this._addRequestButton.enable = false;
		 if ((param1.currentTarget as TextField).text != "")
		 {
			fgr.send("lobby;check_user;" + (param1.currentTarget as TextField).text + ";");
		 }
         _validateCheckUidIcon.startProgress();
         _validateCheckUidIcon.y = this._searchFriendTextInput.y + 5;
         if(this._searchFriendTextInput.value.length > 0)
         {
            this._searchFriendLabel.visible = false;
         }
         clearTimeout(this._searchFriendTimeOut);
         this._searchFriendTimeOut = setTimeout(this.searchFriendTextChange,SEARCH_TIMEOUT);
      }
      
      private function searchFriendTextChange() : void
      {
         if(this._searchFriendTextInput.value.length == 0)
         {
            _validateCheckUidIcon.turnOff();
            this._searchFriendTextInput.validValue = true;
         }
         else
         {
            this._searchFriendUid = this._searchFriendTextInput.value;
            //uidCheckService.exist(this._searchFriendUid,this.checkUid);
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.addRequest();
         }
      }
      
      private function checkUid(param1:Boolean) : *
      {
         this._searchFriendTextInput.validValue = param1;
         if(param1)
         {
            _validateCheckUidIcon.markAsValid();
            //if(userPropertiesService.userName.toLowerCase() != this._searchFriendUid.toLowerCase())
            //{
               //this._searchFriendExist = true;
               //this._addRequestButton.enable = true;
            //}
         }
         else
         {
            this._searchFriendUid = null;
            _validateCheckUidIcon.markAsInvalid();
            this._addRequestButton.enable = false;
         }
         _validateCheckUidIcon.y = this._searchFriendTextInput.y + 7;
      }
   }
}
