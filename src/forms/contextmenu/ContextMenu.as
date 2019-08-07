package forms.contextmenu
{
   import alternativa.init.Main;
   import alternativa.tanks.model.Friend;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import controls.rangicons.RangIconSmall;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.System;
   import forms.Chat;
   import forms.Communic;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import forms.userlabel.UserLabel;
   
   public class ContextMenu extends Sprite
   {
      
	  private var _window:TankWindow = new TankWindow(100, 200);
	  private var _line:Shape = new Shape();
	  private var _uidLabel:UserLabel;
	  private var _windowInner:TankWindowInner = new TankWindowInner(100,100,TankWindowInner.GREEN);
	  private static const WINDOW_MARGIN:int = 11;
	  private static const LINE_COLOR:uint = 1723412;
	  private var _labels:Vector.<ContextMenuLabel> = new Vector.<ContextMenuLabel>();
	  private var _visibleLabels:Vector.<ContextMenuLabel> = new Vector.<ContextMenuLabel>();
	  private var _addToFriendsLabel:ContextMenuLabel = new ContextMenuLabel();
      private var _acceptRequestLabel:ContextMenuLabel = new ContextMenuLabel();
      private var _rejectRequestLabel:ContextMenuLabel = new ContextMenuLabel();
      private var _cancelRequestLabel:ContextMenuLabel = new ContextMenuLabel();
      private var _copyUidLabel:ContextMenuLabel = new ContextMenuLabel();
      private var _writeInChatLabel:ContextMenuLabel = new ContextMenuLabel();
      private var _inviteBattleLabel:ContextMenuLabel = new ContextMenuLabel();
	  private var ignor:ContextMenuLabel = new ContextMenuLabel();
      private var noignor:ContextMenuLabel = new ContextMenuLabel();
	  private var chat:Communic;
      
      public function ContextMenu()
      {
         super();
		 addChild(_window);
		 addChild(_windowInner);
		 addChild(_line);
		 _addToFriendsLabel.text = "Отправить заявку в друзья";
		 _acceptRequestLabel.text = "Принять в друзья";
		 _rejectRequestLabel.text = "Отменить заявку в друзья";
		 _cancelRequestLabel.text = "Удалить из друзей";
		 _copyUidLabel.text = "Скопировать имя";
		 _writeInChatLabel.text = "Написать в чате";
		 _inviteBattleLabel.text = "Пригласить в битву";
		 ignor.text = "Игнорировать";
		 noignor.text = "Показывать";
		 addChild(_addToFriendsLabel);
		 addChild(_acceptRequestLabel);
		 addChild(_rejectRequestLabel);
		 addChild(_cancelRequestLabel);
		 addChild(_copyUidLabel);
		 addChild(_writeInChatLabel);
		 addChild(_inviteBattleLabel);
		 addChild(ignor);
		 addChild(noignor);
		// _addToFriendsLabel.color = 1244928;
		 //_acceptRequestLabel.color = 1244928;
		 //_rejectRequestLabel.color = 1244928;
		//_cancelRequestLabel.color = 1244928;
		 //_copyUidLabel.color = 1244928;
		 //_writeInChatLabel.color = 1244928;
		 //_inviteBattleLabel.color = 1244928;
		 //ignor.color = 1244928;
		 //noignor.color = 1244928;
		 _labels.push(_addToFriendsLabel);
		 _labels.push(_acceptRequestLabel);
		 _labels.push(_rejectRequestLabel);
		 _labels.push(_cancelRequestLabel);
		 _labels.push(_copyUidLabel);
		 _labels.push(_writeInChatLabel);
		 _labels.push(_inviteBattleLabel);
		 _labels.push(ignor);
		 _labels.push(noignor);
		 _addToFriendsLabel.addEventListener(MouseEvent.CLICK, r1);
		 _acceptRequestLabel.addEventListener(MouseEvent.CLICK, r2);
		 _rejectRequestLabel.addEventListener(MouseEvent.CLICK, r3);
		 _cancelRequestLabel.addEventListener(MouseEvent.CLICK, r4);
		 _copyUidLabel.addEventListener(MouseEvent.CLICK, r5);
		 _writeInChatLabel.addEventListener(MouseEvent.CLICK, r6);
		 _inviteBattleLabel.addEventListener(MouseEvent.CLICK, r7);
		 ignor.addEventListener(MouseEvent.CLICK, r8);
		 noignor.addEventListener(MouseEvent.CLICK,r9);
      }
	  
	  private function r1(e:MouseEvent) : void
      {
			Network(Main.osgi.getService(INetworker)).send("lobby;got_friend;" + _uidLabel.uid + ";");
      }
	  
	  private function r2(e:MouseEvent) : void
      {
			Network(Main.osgi.getService(INetworker)).send("lobby;make_friend;" + _uidLabel.uid + ";");
      }
	  
	  private function r3(e:MouseEvent) : void
      {
			Network(Main.osgi.getService(INetworker)).send("lobby;del_infriend;" + _uidLabel.uid + ";");
      }
	  
	  private function r4(e:MouseEvent) : void
      {
			Network(Main.osgi.getService(INetworker)).send("lobby;del_friend;" + _uidLabel.uid + ";");
      }
	  
	  private function r5(e:MouseEvent) : void
      {
		System.setClipboard(_uidLabel.uid);
      }
	  
	  private function r6(e:MouseEvent) : void
      {
		chat.chat.addUser(_uidLabel.uid);
      }
	  
	  private function r7(e:MouseEvent) : void
      {
		Network(Main.osgi.getService(INetworker)).send("lobby;invd;" + _uidLabel.uid + ";");
      }
	  
	  private function r8(e:MouseEvent) : void
      {
		Chat.blockUser(_uidLabel.uid);
      }
	  
	  private function r9(e:MouseEvent) : void
      {
		Chat.unblockUser(_uidLabel.uid);
      }
	  
	  private function getlab(param1:int,param2:String) : void
      {
		_uidLabel = new UserLabel(new Long(0, 1));
		_uidLabel.setRank(param1);
		_uidLabel.setUid(param2,param2);
		_uidLabel.useHandCursor = false;
		addChild(_uidLabel);
      }
	  
	  private function f1(param1:String) : Boolean
      {
			var df:Boolean = false;
			for (var fdg:int = 0; fdg < Friend.list.length; fdg++)
			{
				if (Friend.list[fdg] == param1)
				{
					df = true;
				}
			}
		return df;
      }
	  
	  private function f2(param1:String) : Boolean
      {
			var df:Boolean = false;
			for (var fdg:int = 0; fdg < Friend.listin.length; fdg++)
			{
				if (Friend.listin[fdg] == param1)
				{
					df = true;
				}
			}
		return df;
      }
	  
	  private function f3(param1:String) : Boolean
      {
			var df:Boolean = false;
			for (var fdg:int = 0; fdg < Friend.listot.length; fdg++)
			{
				if (Friend.listot[fdg] == param1)
				{
					df = true;
				}
			}
		return df;
      }
	  
	  public function past(param1:int,param2:String,param3:String,param4:Communic = null) : void
      {
		var _loc13_:int = this._labels.length;
			var _loc14_:int = 0;
			 while(_loc14_ < _loc13_)
			 {
				_labels[_loc14_].visible = false;
				_loc14_++;
			 }
		var fg:int = this._labels.length;
        var fg1:int = 0;
         while(fg1 < fg)
         {
            this._visibleLabels.shift();
            fg1++;
         }
		if (_uidLabel == null)
		{
			
		}else{
			removeChild(_uidLabel);
		}
		getlab(param1,param2);
		if (param3 == "chat")
		{
			chat = param4;
			var _loc131_:int = this._labels.length;
			var _loc141_:int = 0;
			 while(_loc141_ < _loc131_)
			 {
				_labels[_loc141_].visible = true;
				_loc141_++;
			 }
			 _inviteBattleLabel.visible = false;
			 _addToFriendsLabel.visible = true;
			 _acceptRequestLabel.visible = false;
			 _rejectRequestLabel.visible = false;
			 _cancelRequestLabel.visible = false;
			 if(f1(param2))
			 {
				_addToFriendsLabel.visible = false;
				_cancelRequestLabel.visible = true;
			 }
			 if(f2(param2))
			 {
				_addToFriendsLabel.visible = false;
				_rejectRequestLabel.visible = true;
			 }
			 if(f3(param2))
			 {
				_addToFriendsLabel.visible = false;
				_acceptRequestLabel.visible = true;
			 }
			 if (Chat.blocked(_uidLabel.uid))
			 {
				ignor.visible = false;
			 }else{
				noignor.visible = false;
			 }
			 
		}
		if (param3 == "bat")
		{
			var p:int = this._labels.length;
			var p1:int = 0;
			 while(p1 < p)
			 {
				_labels[p1].visible = true;
				p1++;
			 }
			 _addToFriendsLabel.visible = true;
			 _acceptRequestLabel.visible = false;
			 _rejectRequestLabel.visible = false;
			 _cancelRequestLabel.visible = false;
			 if(f1(param2))
			 {
				_addToFriendsLabel.visible = false;
				_cancelRequestLabel.visible = true;
			 }
			 if(f2(param2))
			 {
				_addToFriendsLabel.visible = false;
				_rejectRequestLabel.visible = true;
			 }
			 if(f3(param2))
			 {
				_addToFriendsLabel.visible = false;
				_acceptRequestLabel.visible = true;
			 }
			ignor.visible = false;
			noignor.visible = false;
			_inviteBattleLabel.visible = PanelModel(Main.osgi.getService(IPanel)).isInBattle ? true:false;
			_writeInChatLabel.visible = false;
		}
		var _loc1311_:int = this._labels.length;
        var _loc1411_:int = 0;
         while(_loc1411_ < _loc1311_)
         {
            if(this._labels[_loc1411_].visible)
            {
               this._visibleLabels.push(this._labels[_loc1411_]);
            }
            _loc1411_++;
         }
		resize();
      }
	  
	  private function resize() : void
      {
		 var _loc2_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:ContextMenuLabel = null;
         var _loc8_:int = 0;
		 _uidLabel.x = WINDOW_MARGIN + 7;
         _uidLabel.y = WINDOW_MARGIN + 8;
         var _loc1_:int = _uidLabel.x + _uidLabel.width;
		 var _loc3_:int = this._visibleLabels.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = this._visibleLabels[_loc4_];
            _loc7_.x = WINDOW_MARGIN + 5;
            if(_loc4_ == 0)
            {
               _loc7_.y = Number(42);
            }
            else
            {
               _loc7_.y = this._visibleLabels[_loc4_ - 1].y + 18;
            }
            _loc2_ = _loc7_.y + 18;
            _loc8_ = _loc7_.x + _loc7_.width;
            if(_loc8_ > _loc1_)
            {
               _loc1_ = _loc8_;
            }
            _loc4_++;
         }
         _loc3_ = this._labels.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(!this._labels[_loc5_].visible)
            {
               this._labels[_loc5_].y = 0;
            }
            _loc5_++;
         }
         _line.graphics.clear();
         _line.graphics.beginFill(LINE_COLOR,1);
         var lo:Number = _uidLabel.y + _uidLabel.height + 4;
         _line.graphics.drawRect(WINDOW_MARGIN + 7,lo,_loc1_ - WINDOW_MARGIN - 8,1);
         _line.graphics.endFill();
         _window.width = _loc1_ + WINDOW_MARGIN + 7;
         _window.height = _loc2_ + WINDOW_MARGIN + 8;
         _windowInner.x = WINDOW_MARGIN;
         _windowInner.y = WINDOW_MARGIN;
         _windowInner.width = _window.width - WINDOW_MARGIN * 2;
         _windowInner.height = _window.height - WINDOW_MARGIN * 2;
      }
   }
}
