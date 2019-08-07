package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.panel.BaseButton;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.buttons.AddButton;
   import forms.buttons.FrButton;
   import forms.buttons.FuButton;
   import forms.buttons.GPButton;
   import forms.buttons.ZaButton;
   import forms.checkout.Zv;
   import forms.events.MainButtonBarEvents;
   import mx.core.BitmapAsset;
   
   public class ButtonBar extends Sprite
   {
      
      public var battlesButton:MainPanelBattlesButton;
      
      public var garageButton:MainPanelGarageButton;
      
      public var referalsButton:MainPanelReferalButton;
      
      public var bugsButton:MainPanelBugButton;
      
      public var settingsButton:MainPanelConfigButton;
      
      public var soundButton:MainPanelSoundButton;
      
      public var helpButton:MainPanelHelpButton;
      
      public var closeButton:MainPanelCloseButton;
	  
	  public var closeButton1:GPButton;
	  
	  public var fuButton:FuButton;
	  
	  public var zaButton:ZaButton;
      
      public var addButton:BaseButton;
	  
	  public var frButton:FrButton;
	  
	  public var cas:Zv;
      
      private var _soundOn:Boolean = true;
      
      private var soundIcon:MovieClip;
	  
	  public var zvd:Boolean = false;
      
      public var isTester:Boolean = false;
      
      public function ButtonBar(test:Boolean = false)
      {
         this.battlesButton = new MainPanelBattlesButton();
         this.garageButton = new MainPanelGarageButton();
         this.referalsButton = new MainPanelReferalButton();
         this.bugsButton = new MainPanelBugButton();
         this.settingsButton = new MainPanelConfigButton();
         this.soundButton = new MainPanelSoundButton();
         this.helpButton = new MainPanelHelpButton();
         this.closeButton = new MainPanelCloseButton();
		 this.isTester = test;
		 addButton = new AddButton();
		 frButton = new FrButton();
		 closeButton1 = new GPButton();
		 fuButton = new FuButton();
		 zaButton = new ZaButton();
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		 addChild(this.zaButton);
		 this.zaButton.type = 13;
         this.zaButton.addEventListener(MouseEvent.CLICK, this.listClick);
		 addChild(this.fuButton);
         this.fuButton.addEventListener(MouseEvent.CLICK, this.listClick);
		 addChild(addButton);
         this.addButton.type = 1;
         this.addButton.label = "Магазин";
         this.addButton.addEventListener(MouseEvent.CLICK, this.listClick);
		 addChild(this.frButton);
         this.frButton.type = 12;
         this.frButton.label = "Друзья";
         this.frButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.battlesButton);
         this.battlesButton.type = 2;
         this.battlesButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_BATTLES);
         this.battlesButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.garageButton);
         this.garageButton.type = 3;
         this.garageButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_GARAGE);
         this.garageButton.addEventListener(MouseEvent.CLICK,this.listClick);
         //addChild(this.referalsButton);
         //this.referalsButton.type = 11;
         //this.referalsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         //addChild(this.bugsButton);
         //this.bugsButton.type = 9;
         //this.bugsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.settingsButton);
         this.settingsButton.type = 5;
         this.settingsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.soundButton);
         this.soundButton.type = 6;
         this.soundButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.soundIcon = this.soundButton.getChildByName("icon") as MovieClip;
         addChild(this.helpButton);
         this.helpButton.type = 7;
         this.helpButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.closeButton);
		 //this.closeButton.visible = false;
         this.closeButton.type = 8;
         this.closeButton.addEventListener(MouseEvent.CLICK, this.listClick);
		 addChild(this.closeButton1);
		 this.closeButton1.visible = false;
		 this.closeButton1.type = 8;
         this.closeButton1.addEventListener(MouseEvent.CLICK, this.listClick);
		 //this.bugsButton.visible = false;
		 //this.referalsButton.visible = false;
         this.draw();
      }
	  
	  public function vz(zv:Boolean,cas1:int) : void
      {
         this.zvd = zv;
		 if (this.zvd)
		 {
			cas = new Zv();
			cas.zov = cas1;
			cas.type = 13;
			cas.addEventListener(MouseEvent.CLICK, listClick1);
			addChild(cas);
			draw();
		 }
      }
	  
	  public function dse() : void
      {
         this.fuButton.removeEventListener(MouseEvent.CLICK, this.listClick);
		 removeChild(this.fuButton);
		 fuButton = new FuButton();
		 addChild(this.fuButton);
         this.fuButton.addEventListener(MouseEvent.CLICK, this.listClick);
		 draw();
      }
      
      public function draw() : void
      {
		 if (this.zvd)
		 {
			this.addButton.x = this.cas.width - this.cas.fdds + 8;
		 }
		 //this.frButton.x = this.addButton.x + this.addButton.width;
		 this.battlesButton.x = this.addButton.x + this.addButton.width + 11;
         this.garageButton.x = this.battlesButton.x + this.battlesButton.width;
		 this.frButton.x = this.garageButton.x + this.garageButton.width;
         //this.referalsButton.x = this.garageButton.x + this.garageButton.width + 11;
         //this.bugsButton.visible = this.isTester;
         //if(this.isTester)
         //{
            //this.bugsButton.x = this.referalsButton.x + this.referalsButton.width;
            //this.settingsButton.x = this.bugsButton.x + this.bugsButton.width;
         //}
         //else
         //{
            //this.settingsButton.x = this.referalsButton.x + this.referalsButton.width;
		 this.zaButton.x = this.frButton.x + this.frButton.i1.bg.width + 11;
		 this.settingsButton.x = this.zaButton.x + this.zaButton.width;
         this.soundButton.x = this.settingsButton.x + this.settingsButton.width;
		 this.fuButton.x = this.soundButton.x + this.soundButton.width;
         this.helpButton.x = this.fuButton.x + this.fuButton.width;
         this.closeButton.x = this.helpButton.x + this.helpButton.width + 11;
		 this.closeButton1.x = this.helpButton.x + this.helpButton.width + 11;
         this.soundIcon.gotoAndStop(this.soundOn?1:2);
      }
      
      public function set soundOn(value:Boolean) : void
      {
         this._soundOn = value;
         this.draw();
      }
      
      public function get soundOn() : Boolean
      {
         return this._soundOn;
      }
	  
	  private function listClick1(e:MouseEvent) : void
      {
         var target:Zv = e.currentTarget as Zv;
         dispatchEvent(new MainButtonBarEvents(target.type));
      }
      
      private function listClick(e:MouseEvent) : void
      {
         var target:BaseButton = null;
         //var trget:BaseButton = null;
         var i:int = 0;
         if(e.currentTarget as BaseButton != null)
         {
            target = e.currentTarget as BaseButton;
            if(target.enable)
            {
               dispatchEvent(new MainButtonBarEvents(target.type));
            }
            if(target == this.soundButton)
            {
               this.soundOn = !this.soundOn;
            }
            /*if(target == this.addButton ||target == this.battlesButton || target == this.garageButton)
            {
               for(i = 0; i < 3; i++)
               {
                  trget = getChildAt(i) as BaseButton;
				  if (trget != null)
				  {
					trget.enable = target != trget;
				  }
               }
            }*/
         }
      }
   }
}
