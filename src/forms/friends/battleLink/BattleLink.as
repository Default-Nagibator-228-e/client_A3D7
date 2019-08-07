package forms.friends.battleLink
{
   import alternativa.init.Main;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.friends.list.renderer.FriendsAcceptedListRenderer;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import controls.Label;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.ColorConstants;
   
   public class BattleLink extends Sprite
   {
      
      [Inject]
      public static var localeService:ILocaleService;
       
      
      private var _userId:String;
      
      private var _label:Label;
      
      private var _labelCont:Sprite;
      
      private var _availableBattleIcon:Bitmap;
      
      public function BattleLink(param1:String)
      {
         super();
         this._userId = param1;
		 if (param1 != null && param1 != "null" && param1 != "")
		 {
			this.init();
			this.addEventListener(MouseEvent.CLICK,this.onBattleLinkClick,false,0,true);
		 }
      }
	  
	  private function onBattleLinkClick(param1:MouseEvent) : void
      {
         PanelModel(Main.osgi.getService(IPanel)).showBattleSelect(null);
		 Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + this._userId.split("battle")[1]);
      }
      
      private function init() : void
      {
         mouseChildren = true;
         mouseEnabled = true;
		 buttonMode = true;
         tabEnabled = false;
         tabChildren = false;
         this._labelCont = new Sprite();
         addChild(this._labelCont);
         this._label = new Label();
		 this._label.text = this._userId.split("@")[1];
         this._label.color = ColorConstants.WHITE;
         //this._label.mouseEnabled = false;
         this._labelCont.addChild(this._label);
         this._labelCont.y = -1;
		 this._labelCont.useHandCursor = true;
		 //_labelmouseEnabled = true;
      }
	  
      public function removeEvents() : void
      {
		  this.removeEventListener(MouseEvent.CLICK,this.onBattleLinkClick);
      }
      
      public function get labelCont() : Sprite
      {
         return this._labelCont;
      }
   }
}
