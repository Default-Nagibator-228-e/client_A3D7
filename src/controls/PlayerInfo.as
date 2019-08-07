package controls
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.panel.Indicators;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class PlayerInfo extends Sprite
   {
       
      
      private const normalGlowColor:uint = 1244928;
      
      private const minusGlowColor:uint = 16728064;
      
      private var _playerName:String;
      
      private var _rang:int;
      
      private var _score:int = 0;
      
      private var _scoreRemain:int = 0;
      
      private var _progress:int = 0;
      
      private var _newProgress:int;
      
      private var _deltaProgress:Number;
      
      private var _rating:Number = 0;
      
      private var _ratingChange:int = 0;
      
      private var _position:int;
      
      private var _shield:int = 5000;
      
      private var _weapon:int = 7500;
      
      private var _engine:int = 6000;
      
      private var _money:int = 0;
      
      private var _crystals:int = 0;
      
      public var indicators:Indicators;
      
      private var glowAlpha:Array;
      
      private var glowColor:Array;
      
      private var glowDelta:Number = 0.02;
      
      private var _width:int;
	  
	  private var _width1:int;
	  
	  private var ins:Sprite = new Sprite();
      
      public function PlayerInfo()
      {
         this.indicators = new Indicators();
         this.glowAlpha = new Array();
         this.glowColor = new Array();
         super();
         addChild(this.indicators);
         addEventListener(Event.ADDED_TO_STAGE,this.configUI);
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      public function set playerName(name:String) : void
      {
         this._playerName = name;
         this.updateInfo();
      }
      
      public function get rang() : int
      {
         return this._rang;
      }
      
      public function set rang(value:int) : void
      {
         this._rang = value;
         this.updateInfo();
      }
      
      public function updateScore(scoreValue:int, scoreRemainValue:int) : void
      {
         if(scoreValue != this._score && this._score != 0)
         {
            this.flashLabel(this.indicators.playerInfo,scoreValue > this._score?uint(this.normalGlowColor):uint(this.minusGlowColor));
         }
         this._score = scoreValue;
         this._scoreRemain = scoreRemainValue;
         this.updateInfo();
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function set progress(value:int) : void
      {
         if(this._progress == 0)
         {
            this._progress = value;
         }
         else
         {
            this._newProgress = value;
            this._progress = value;
            this.indicators.newprogress = value;
         }
         this.updateInfo();
      }
      
      public function get rating() : Number
      {
         return this._rating;
      }
      
      public function set rating(rating:Number) : void
      {
         if(int(rating) != this._rating && this._rating != 0)
         {
            this.flashLabel(this.indicators.kdRatio,int(rating) > this._rating?uint(this.normalGlowColor):uint(this.minusGlowColor));
         }
         this._rating = int(rating);
         this.updateInfo();
      }
      
      public function get ratingChange() : int
      {
         return this._rating;
      }
      
      public function set ratingChange(change:int) : void
      {
         this._ratingChange = change;
         this.updateInfo();
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(pos:int) : void
      {
         if(pos != this._position && this._position != 0)
         {
            this.flashLabel(this.indicators.scoreLabel,pos > this._position?uint(this.minusGlowColor):uint(this.normalGlowColor));
         }
         this._position = pos;
         this.updateInfo();
      }
      
      public function get shield() : int
      {
         return this._shield;
      }
      
      public function set shield(value:int) : void
      {
         this._shield = value;
         this.updateInfo();
      }
      
      public function get weapon() : int
      {
         return this._weapon;
      }
      
      public function set weapon(value:int) : void
      {
         this._weapon = value;
         this.updateInfo();
      }
      
      public function get engine() : int
      {
         return this._engine;
      }
      
      public function set engine(value:int) : void
      {
         this._engine = value;
         this.updateInfo();
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function set money(value:int) : void
      {
      }
      
      public function get crystals() : int
      {
         return this._engine;
      }
      
      public function set crystals(value:int) : void
      {
         if(value != this._crystals && this._crystals != 0)
         {
            this.flashLabel(this.indicators.crystalInfo,value > this._crystals?uint(this.normalGlowColor):uint(this.minusGlowColor));
         }
         this._crystals = value;
         this.updateInfo();
      }
      
      private function configUI(e:Event) : void
      {
         this.indicators.x = 59;
         removeEventListener(Event.ADDED_TO_STAGE,this.configUI);
      }
	  
	  public function rot(p:int,p1:int) : void
      {
		 var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		 this._position = p;
		 var de:int = p - p1;
		 this._rating = Math.abs(de);
		 this._ratingChange = de > 0 ? -1 : de == 0 ? 0 : 1;
		 if (this._position == 0)
		 {
			this.indicators.scoreLabel.visible = false;
			this.indicators.kdRatio.visible = false;
			this.indicators.kd_icon.visible = false;
		 }
         this.indicators.scoreLabel.text = localeService.getText(TextConst.MAIN_PANEL_RATING_LABEL) + String(this._position);
		 this.indicators.kdRatio.text = String(int(this._rating));
		 switch(this._ratingChange)
         {
            case -1:
               this.indicators.kdRatio.color = 16717056;
			   this.indicators.kd_icon.gotoAndStop(1);
               break;
            case 0:
               this.indicators.kdRatio.color = 11711154;
			   this.indicators.kd_icon.gotoAndStop(2);
               break;
            case 1:
               this.indicators.kdRatio.color = 1244928;
			   this.indicators.kd_icon.gotoAndStop(3);
         }
		 this.width = this._width;
      }
      
      private function updateInfo() : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.indicators.playerInfo.text = String(this._score) + " / " + String(this._scoreRemain) + "   " + Rank.name(this._rang) + " " + this._playerName;
         this.indicators.progress = this._progress;
         this.indicators.kdRatio.text = String(int(this._rating));
         this.indicators.kd_icon.gotoAndStop(this._ratingChange + 2);
         this.indicators.scoreLabel.text = localeService.getText(TextConst.MAIN_PANEL_RATING_LABEL) + String(this._position);
         switch(this._ratingChange)
         {
            case -1:
               this.indicators.kdRatio.color = 16717056;
			   this.indicators.kd_icon.gotoAndStop(1);
               break;
            case 0:
               this.indicators.kdRatio.color = 11711154;
			   this.indicators.kd_icon.gotoAndStop(2);
               break;
            case 1:
               this.indicators.kdRatio.color = 1244928;
			   this.indicators.kd_icon.gotoAndStop(3);
         }
         this.indicators.crystalInfo.text = Money.numToString(this._crystals,false);
         this.width = this._width;
      }
      
      private function flashLabel(target:Label, color:uint = 16711680) : void
      {
         this.glowAlpha[target.name] = 1;
         this.glowColor[target.name] = color;
         target.addEventListener(Event.ENTER_FRAME,this.glowFrame);
      }
      
      private function glowFrame(e:Event) : void
      {
         var trgt:Label = e.target as Label;
         var filter:GlowFilter = new GlowFilter(this.glowColor[trgt.name],this.glowAlpha[trgt.name],4,4,3,1,false);
         trgt.filters = [filter];
         this.glowAlpha[trgt.name] = this.glowAlpha[trgt.name] - this.glowDelta;
         if(this.glowAlpha[trgt.name] < 0)
         {
            trgt.filters = [];
            trgt.removeEventListener(Event.ENTER_FRAME,this.glowFrame);
         }
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.indicators.width = value;
		 _width1 = this.indicators.kdRatio.x + this.indicators.kdRatio.textWidth + 5;
		 //throw new Error(this.indicators.kd_icon.x - this.indicators.playerInfo.textWidth);
		 this.indicators.kdRatio.x = (_width1 - this.indicators.kdRatio.textWidth - 5) <= 0 ? 0 : (_width1 - this.indicators.kdRatio.textWidth - 5);
		 this.indicators.scoreLabel.width = (this.indicators.kd_icon.x - this.indicators.playerInfo.textWidth - 15) <= 0 ? 0 : (this.indicators.kd_icon.x - this.indicators.playerInfo.textWidth - 15);
		 this.indicators.scoreLabel.x = this.indicators.kd_icon.x - this.indicators.scoreLabel.width - 5;
		 //this.indicators.kdRatio.width = 1;//value - (this.indicators.playerInfo.x + this.indicators.playerInfo.width);
		 //ins.x = this.indicators.kdRatio.x;
		 //this.indicators.kdRatio.x = 0;
		 //this.indicators.kdRatio.text = "100";
		 /*
		  var _loc2_:int = 0;
         this._width = param1;
         _loc2_ = int(this._width - 180);
         this.b_name.width = _loc2_;
         this.b_conn1.x = this.b_name.width + this.b_left.width;
         this.b_crystal.width = 67;
         this.b_crystal.x = this.b_conn1.x + this.b_conn1.width;
         this.b_right.x = this.b_crystal.x + this.b_crystal.width;
         this.changeButton.x = this.b_right.x + 9;
         this.crystalInfo.x = this.b_crystal.x - 2;
         this.kdRatio.x = int(this.b_conn1.x - this.kdRatio.textWidth - 3);
         this.kd_icon.x = int(this.b_conn1.x - this.kdRatio.textWidth - 10);
         this.scoreLabel.x = this.kd_icon.x - 205;
         this.playerInfo.width = this.b_name.width - this.kdRatio.width - this.kd_icon.width - 5;
         this.progress = this._progress;
		 */
      }
   }
}
