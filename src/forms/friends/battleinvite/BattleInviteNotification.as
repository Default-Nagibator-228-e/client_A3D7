package forms.friends.battleinvite
{
   import alternativa.init.Main;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextLineMetrics;
   import flash.utils.Timer;
   import forms.ColorConstants;
   import forms.userlabel.UserLabel;
   
   public class BattleInviteNotification extends Sprite
   {
      
      public static var localeService:ILocaleService;
      
      private static const DEFAULT_BUTTON_WIDTH:int = 96;
	  
	  private static const DEFAULT_WIDTH:int = 247;
      
      private static const DEFAULT_HEIGHT:int = 200;
      
      private static const SHOW_ALERT_ABOUT_INACCESSIBLE_IN_STANDALONE:String = "SHOW_ALERT_ABOUT_INACCESSIBLE_IN_STANDALONE";
       
      private var _width:int;
      
      private var _height:int;
      
      private var _innerHeight:int;
	  
	  private var _background:TankWindow;
      
      private var _inner:TankWindowInner;
	  
      private var _userLabel:UserLabel;
      
      private var _baseMessageLabel:LabelBase;
      
      private var _mapAndServerNumberMessageLabel:LabelBase;
      
      private var _rejectButton:DefaultButtonBase;
      
      private var _acceptButton:DefaultButtonBase;
      
      private var _mapAndServerNumberString:String = "";
	  
	  private var ran:int = 0;
	  
	  private var nam:String;
	  
	  private var tim:Timer = new Timer(30000,1);
      
      public function BattleInviteNotification(param1:int,param2:String,param3:String)
      {
		 super();
         this.ran = param1 + 1;
		 this.nam = param2;
         this._mapAndServerNumberString = param3;
		 init();
      }
	  
	  private function getlab() : void
      {
		_userLabel = new UserLabel(new Long(0, 1));
		_userLabel.setRank(ran);
		_userLabel.setUid(nam,nam);
		addChild(_userLabel);
      }
      
      private function init() : void
      {
		 this._width = DEFAULT_WIDTH;
         this._height = DEFAULT_HEIGHT;
         this._innerHeight = this._height - 11 * 2;
		 this._background = new TankWindow();
         addChild(this._background);
         this._inner = new TankWindowInner(DEFAULT_WIDTH,DEFAULT_HEIGHT,TankWindowInner.GREEN);
         addChild(this._inner);
         this._inner.mouseChildren = false;
         this._inner.mouseEnabled = false;
         this._inner.x = this._inner.y = 11;
         this._inner.showBlink = true;
         getlab();
         this._baseMessageLabel = new LabelBase();
         this._baseMessageLabel.color = ColorConstants.GREEN_LABEL;
         this._baseMessageLabel.mouseEnabled = false;
         addChild(this._baseMessageLabel);
         this._baseMessageLabel.htmlText = "пригласил вас в битву";
         this._mapAndServerNumberMessageLabel = new LabelBase();
         this._mapAndServerNumberMessageLabel.color = ColorConstants.GREEN_LABEL;
         this._mapAndServerNumberMessageLabel.mouseEnabled = false;
         addChild(this._mapAndServerNumberMessageLabel);
         this._mapAndServerNumberMessageLabel.htmlText = _mapAndServerNumberString.split("@")[1];
         this._acceptButton = new DefaultButtonBase();
         this._acceptButton.width = DEFAULT_BUTTON_WIDTH;
         this._acceptButton.label = "Принять";
         addChild(this._acceptButton);
         this._rejectButton = new DefaultButtonBase();
         this._rejectButton.width = DEFAULT_BUTTON_WIDTH;
         this._rejectButton.label = "Отказаться";
         addChild(this._rejectButton);
		 resize();
		 setEvents();
      }
      
      private function setEvents() : void
      {
         this._acceptButton.addEventListener(MouseEvent.CLICK,this.onAcceptClick);
         this._rejectButton.addEventListener(MouseEvent.CLICK, this.onRejectClick);
		 Main.stage.addEventListener(Event.RESIZE,resize);
      }
      
      private function removeEvents() : void
      {
         this._acceptButton.removeEventListener(MouseEvent.CLICK,this.onAcceptClick);
         this._rejectButton.removeEventListener(MouseEvent.CLICK, this.onRejectClick);
		 Main.stage.removeEventListener(Event.RESIZE,resize);
      }
      
      private function onAcceptClick(param1:MouseEvent = null) : void
	  {
		 PanelModel(Main.osgi.getService(IPanel)).showBattleSelect(null);
		 Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + _mapAndServerNumberString.split("battle")[1]);
         this.visible = false;
      }
      
      private function onRejectClick(param1:MouseEvent) : void
      {
         this.closeNotification();
      }
      
      private function closeNotification() : void
      {
         this.visible = false;
      }
      
      private function resize(fg:Event = null) : void
      {
         this._userLabel.x = 11 + 7;
         this._userLabel.y = 11 + 5;
         this._baseMessageLabel.x = this._userLabel.x + this._userLabel.width + 11;
         this._baseMessageLabel.y = this._userLabel.y;
         this._mapAndServerNumberMessageLabel.x = 11 + 9;
         var _loc1_:TextLineMetrics = this._baseMessageLabel.getLineMetrics(0);
         this._mapAndServerNumberMessageLabel.y = this._baseMessageLabel.y + _loc1_.height;
         _innerHeight = this._mapAndServerNumberMessageLabel.y + this._mapAndServerNumberMessageLabel.height - 3;
         var _loc2_:int = this._baseMessageLabel.x + this._baseMessageLabel.width + 11 * 2;
         if(_loc2_ > _width)
         {
            _width = _loc2_;
         }
         var _loc3_:int = _innerHeight + 16;
         this._acceptButton.x = 11;
         this._acceptButton.y = _loc3_;
         this._rejectButton.x = _width - this._rejectButton.width - 11;
         this._rejectButton.y = _loc3_;
         _height = this._acceptButton.y + this._acceptButton.height + 11 + 1;
         this._background.width = this._width;
         this._background.height = this._height;
         this._inner.width = this._background.width - 11 * 2;
         this._inner.height = this._innerHeight;
		 this.x = Main.stage.stageWidth - this.width - 11;
		 this.y = 11;
      }
   }
}
