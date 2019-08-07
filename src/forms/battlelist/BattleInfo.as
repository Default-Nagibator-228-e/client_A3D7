package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.BattleSelectModel;
   import assets.icons.BattleInfoIcons;
   import assets.icons.InputCheckIcon;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindowInner;
   import controls.rangicons.RangIconSmall;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import forms.RegisterForm;
   import utils.client.battleselect.IBattleSelectModelBase;
   
   public class BattleInfo extends Sprite
   {
      
      private static var waitIcon:InputCheckIcon = new InputCheckIcon();
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var iconBar:Sprite;
      
      private var iconAB:BattleInfoIcons;
      
      private var iconFF:BattleInfoIcons;
      
      private var iconTL:BattleInfoIcons;
      
      private var iconKL:BattleInfoIcons;
      
      private var iconCTF:BattleInfoIcons;
      
      private var iconPayd:BattleInfoIcons;
      
      private var iconInventory:BattleInfoIcons;
      
      private var killLimitLabel:Label;
      
      private var timeLimitLabel:Label;
      
      public var countDown:int = 0;
      
      private var countDownTimer:Timer;
      
      private var _timeLimit:int = 0;
      
      private var rangBar:Sprite;
      
      private var bg:TankWindowInner;
      
      private var nameTF:Label;
      
      private var preview:Sprite;
      
      private var rect:Rectangle;
      
      private var urlString:TankInput;
      
      private var urlCopyButton:DefaultButton;
      
      private var dontStartCountDown:Boolean = false;
      
      private var copyLinkText:String;
      
      private var setupTime:int;
      
      private var spectatorBtn:DefaultButton;
      
      public var killlimit:int = 0;
      
      public function BattleInfo()
      {
         this.iconBar = new Sprite();
         this.iconAB = new BattleInfoIcons();
         this.iconFF = new BattleInfoIcons();
         this.iconTL = new BattleInfoIcons();
         this.iconKL = new BattleInfoIcons();
         this.iconCTF = new BattleInfoIcons();
         this.iconPayd = new BattleInfoIcons();
         this.iconInventory = new BattleInfoIcons();
         this.killLimitLabel = new Label();
         this.timeLimitLabel = new Label();
         this.rangBar = new Sprite();
         this.bg = new TankWindowInner(100,100,TankWindowInner.TRANSPARENT);
         this.nameTF = new Label();
         this.preview = new Sprite();
         this.rect = new Rectangle(0,0,400,300);
         this.spectatorBtn = new DefaultButton();
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var filt:Array = [new GlowFilter(0,1,6,6)];
         addChild(this.preview);
         addChild(this.bg);
         addChild(this.nameTF);
         addChild(this.rangBar);
         addChild(this.iconBar);
         addChild(this.spectatorBtn);
         this.spectatorBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            var battleSelect:BattleSelectModel = Main.osgi.getService(IBattleSelectModelBase) as BattleSelectModel;
            if(battleSelect == null)
            {
               return;
            }
            battleSelect.enterInBattleSpectator();
         });
         this.hideSpectatorButton();
         this.iconAB.type = BattleInfoIcons.AUTO_BALANCE;
         this.iconFF.type = BattleInfoIcons.FRIENDLY_FIRE;
         this.iconTL.type = BattleInfoIcons.TIME_LIMIT;
         this.iconKL.type = BattleInfoIcons.KILL_LIMIT;
         this.iconCTF.type = BattleInfoIcons.CTF;
         this.iconPayd.type = BattleInfoIcons.PAYD;
         this.iconInventory.type = BattleInfoIcons.INVENTORY;
         this.nameTF.size = 18;
         this.nameTF.height = 25;
         this.nameTF.thickness = 0;
         this.nameTF.autoSize = TextFieldAutoSize.NONE;
         this.spectatorBtn.label = "Спектатор";
         this.nameTF.filters = filt;
         this.iconBar.filters = filt;
         this.preview.scrollRect = this.rect;
         this.copyLinkText = localeService.getText(TextConst.BATTLEINFO_PANEL_COPY_LINK_TEXT);
      }
      
      public function setPreview(img:BitmapData) : void
      {
         if(this.preview.numChildren > 0)
         {
            this.preview.removeChildAt(0);
         }
         if(img == null)
         {
            this.preview.addChild(waitIcon);
            waitIcon.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
            waitIcon.x = int(375 - waitIcon.width / 2);
            waitIcon.y = int(250 - waitIcon.height / 2);
            this.preview.scrollRect = this.rect;
            Main.writeToConsole("");
            Main.writeVarsToConsoleChannel("BATTLE INFO","BattleInfo: no Preview");
         }
         else
         {
            this.preview.addChild(new Bitmap(img));
            this.preview.scrollRect = this.rect;
            Main.writeVarsToConsoleChannel("BATTLE INFO","Preview width=%1 height=%2",img.width,img.height);
         }
         this.width = this._width;
         this.height = this._height;
      }
      
      public function setUp(gameName:String, minRang:int, maxRang:int, killLimit:int = 0, timeLimit:int = 0, currentTime:int = 0, img:BitmapData = null, IO:Boolean = false, AB:Boolean = false, FF:Boolean = false, url:String = "", CTF:Boolean = false, payd:Boolean = false, inventory:Boolean = false) : void
      {
         var rang:RangIconSmall = null;
         var i:int = 0;
         var col:int = 0;
         var row:int = 0;
         var curWidth:int = 0;
         this.countDown = 0;
         while(this.rangBar.numChildren > 0)
         {
            this.rangBar.removeChildAt(0);
         }
         if(minRang != 0 && maxRang != 0)
         {
            for(i = maxRang; i >= minRang; i--)
            {
               rang = new RangIconSmall(i);
               rang.x = col * 14;
               rang.y = row * 14;
               this.rangBar.addChild(rang);
               col--;
			   //col--;
               if(col < -15)
               {
                  row--;
                  col = 0;
               }
            }
         }
         if(url.length > 0 && this.urlString == null)
         {
            this.urlString = new TankInput();
            this.urlCopyButton = new DefaultButton();
            addChild(this.urlString);
            addChild(this.urlCopyButton);
         }
         if(url.length > 0)
         {
            this.urlString.value = "http://legendtanks.com/battle/index.html" + url;
            this.urlString.textField.type = TextFieldType.DYNAMIC;
            this.urlCopyButton.width = this.copyLinkText.length * 7;
            this.urlCopyButton.label = this.copyLinkText;
            this.urlCopyButton.addEventListener(MouseEvent.CLICK,this.copyURL);
         }
         this.nameTF.text = gameName;
         while(this.iconBar.numChildren > 0)
         {
            this.iconBar.removeChildAt(0);
         }
         if(this.countDownTimer != null)
         {
            this.countDownTimer.stop();
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
         }
         if(timeLimit > 0)
         {
            this.setupTime = getTimer();
            this.iconBar.addChild(this.iconTL);
            this.iconBar.addChild(this.timeLimitLabel);
            this.timeLimitLabel.x = 18;
            this.timeLimitLabel.y = -2;
            this.timeLimitLabel.autoSize = TextFieldAutoSize.NONE;
            this.timeLimitLabel.size = 14;
            this.timeLimitLabel.width = 50;
            this.timeLimitLabel.height = 20;
            this.countDown = currentTime > 0?int(currentTime):int(timeLimit);
            this.dontStartCountDown = currentTime == 0;
            this._timeLimit = this.countDown;
            this.showCountDown();
            curWidth = int(this.iconBar.width);
         }
         if(killLimit > 0)
         {
            this.iconBar.addChild(this.iconKL);
            this.iconBar.addChild(this.killLimitLabel);
            this.iconKL.type = !!CTF?int(BattleInfoIcons.CTF):int(BattleInfoIcons.KILL_LIMIT);
            this.killLimitLabel.autoSize = TextFieldAutoSize.NONE;
            this.killLimitLabel.size = 14;
            this.killLimitLabel.width = 40;
            this.killLimitLabel.height = 20;
            this.iconKL.x = curWidth;
			//throw new Error(curWidth + "	" + killLimit);
            this.killLimitLabel.x = this.iconKL.x + 16;
            this.killLimitLabel.y = -2;
            this.killLimitLabel.text = String(killLimit);
            curWidth = int(this.iconBar.width);
         }
         this.killlimit = killLimit;
         if(FF)
         {
            this.iconBar.addChild(this.iconFF);
            this.iconFF.x = curWidth;
            curWidth = int(this.iconBar.width);
         }
         if(AB)
         {
            this.iconBar.addChild(this.iconAB);
            this.iconAB.x = curWidth + 12;
            curWidth = int(this.iconBar.width);
         }
         if(CTF)
         {
            this.iconBar.addChild(this.iconCTF);
            this.iconCTF.x = curWidth + 12;
            curWidth = int(this.iconBar.width);
         }
         if(payd)
         {
            this.iconBar.addChild(this.iconPayd);
            this.iconPayd.x = curWidth + 12;
            curWidth = int(this.iconBar.width);
         }
         if(inventory)
         {
            this.iconBar.addChild(this.iconInventory);
            this.iconInventory.x = curWidth + 12;
            curWidth = int(this.iconBar.width);
         }
         this.width = this._width;
         this.height = this._height;
      }
      
      private function showCountDown() : void
      {
         this.countDownTimer = new Timer(500);
         this.countDownTimer.addEventListener(TimerEvent.TIMER,this.showCountDownTick);
         this.countDownTimer.start();
         this.showCountDownTick();
      }
      
      public function restartCountDown() : void
      {
         this.countDown = this._timeLimit;
         this.setupTime = getTimer();
         if(this.countDownTimer != null)
         {
            this.countDownTimer.stop();
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
         }
         this.showCountDown();
      }
      
      public function stopCountDown() : void
      {
         this.countDown = 0;
         this.showCountDownTick();
         if(this.countDownTimer != null)
         {
            this.countDownTimer.stop();
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
         }
      }
      
      private function showCountDownTick(e:TimerEvent = null) : void
      {
         var str:String = null;
         var currentTimer:int = getTimer();
         var min:int = int(this.countDown / 60);
         var sec:int = this.countDown - min * 60;
         str = String(min) + ":" + (sec > 9?String(sec):"0" + String(sec));
         this.timeLimitLabel.text = str;
         if((this.countDown < 0 || this.dontStartCountDown) && this.countDownTimer != null)
         {
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
            this.countDownTimer.stop();
            this.dontStartCountDown = false;
         }
         this.countDown = this._timeLimit - (currentTimer - this.setupTime) / 1000;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function copyURL(e:MouseEvent) : void
      {
         System.setClipboard(this.urlString.value);
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.bg.width = this._width;
         this.preview.x = 1;
         this.rect.x = int(375 - this._width / 2);
         this.rect.width = this._width - 2;
         this.preview.scrollRect = this.rect;
         this.rangBar.x = this._width - 23;
         this.nameTF.x = 10;
         this.nameTF.width = this._width - 20;
         this.iconBar.x = 12;
         this.spectatorBtn.x = value - this.spectatorBtn.width - 10;
         if(this.urlString != null)
         {
            this.urlString.width = this._width - this.urlCopyButton.width - 3;
            this.urlCopyButton.x = this._width - this.urlCopyButton.width;
         }
      }
      
      override public function set height(value:Number) : void
      {
         this._height = int(value);
         this.bg.height = this.urlString != null?Number(this._height - this.urlString.height - 3):Number(this._height);
         this.preview.y = 1;
         this.rect.y = int(250 - this._height / 2);
         this.rect.height = this.bg.height - 2;
         this.preview.scrollRect = this.rect;
         this.rangBar.y = this.bg.height - 23;
         this.nameTF.y = 10;
         this.iconBar.y = 40;
         this.spectatorBtn.y = 10;
         if(this.urlString != null)
         {
            this.urlString.y = this._height - this.urlCopyButton.height;
            this.urlCopyButton.y = this._height - this.urlCopyButton.height;
         }
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function showSpectatorButton() : void
      {
         this.spectatorBtn.visible = true;
      }
      
      public function hideSpectatorButton() : void
      {
         this.spectatorBtn.visible = false;
      }
   }
}
