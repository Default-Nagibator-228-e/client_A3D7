package forms
{
   import controls.PlayerInfo;
   import controls.rangicons.RangIconNormal;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import forms.events.MainButtonBarEvents;
   
   public class MainPanel extends Sprite
   {
       
      
      public var rangIcon:RangIconNormal;
      
      public var playerInfo:PlayerInfo;
      
      public var buttonBar:ButtonBar;
      
      private var _rang:int;
      
      private var _isTester:Boolean = false;
      
      public function MainPanel(isTester:Boolean = false)
      {
         this.rangIcon = new RangIconNormal();
         this.playerInfo = new PlayerInfo();
         this.buttonBar = new ButtonBar();
         super();
         this._isTester = isTester;
         addEventListener(Event.ADDED_TO_STAGE,this.configUI);
      }
      
      public function set rang(value:int) : void
      {
         this._rang = value;
         this.playerInfo.rang = value;
         this.rangIcon.rang1 = this._rang;
      }
      
      public function get rang() : int
      {
         return this._rang;
      }
      
      private function configUI(e:Event) : void
      {
         this.y = 3;
         addChild(this.rangIcon);
         addChild(this.playerInfo);
         addChild(this.buttonBar);
         this.rangIcon.y = -2;
         this.rangIcon.x = 2;
         removeEventListener(Event.ADDED_TO_STAGE,this.configUI);
		 this.playerInfo.indicators.changeButton.visible = false;
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize();
      }
      
      public function onResize(e:Event = null) : void
      {
         var minWidth:int = int(Math.max(100, stage.stageWidth));
		 if (this.buttonBar.cas != null)
		 {
			 this.buttonBar.x = minWidth - this.buttonBar.width - 9 + this.buttonBar.cas.fdds;
			 this.playerInfo.width = minWidth - this.buttonBar.width + this.buttonBar.cas.fdds;
		 }else{
			 this.buttonBar.x = minWidth - this.buttonBar.width - 9;
			 this.playerInfo.width = minWidth - this.buttonBar.width;
		 }
      }
	  
	  public function show() : void
      {
         stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      public function hide() : void
      {
		 if (stage != null)
		 {
			stage.removeEventListener(Event.RESIZE, this.onResize);
		 }
      }
      
      public function get isTester() : Boolean
      {
         return this._isTester;
      }
      
      public function set isTester(value:Boolean) : void
      {
         this._isTester = value;
         this.buttonBar.isTester = this._isTester;
         this.buttonBar.draw();
         this.onResize();
      }
   }
}
