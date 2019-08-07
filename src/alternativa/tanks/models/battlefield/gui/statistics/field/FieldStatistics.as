package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import alternativa.init.Main;
   import alternativa.tanks.models.battlefield.BattleType;
   import assets.icons.BattleInfoIcons;
   import controls.resultassets.WhiteFrame;
   import flash.display.Sprite;
   import flash.events.Event;
   import utils.client.battlefield.gui.models.statistics.BattleStatInfo;
   import utils.client.battlefield.gui.models.statistics.UserStat;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class FieldStatistics extends Sprite
   {
       
      
      private const CTF_SCORE_WINK_LIMIT:int = 1;
      
      private const SCORE_WINK_LIMIT:int = 3;
      
      private const TIME_WINK_LIMIT:int = 30;
      
      private var _timeLimit:int;
      
      private var scoreLimit:int;
      
      private var fund:int;
      
      private var battleType:BattleType;
      
      private var userStatis:Vector.<UserStat>;
      
      private var scoreLimitField:WinkingField;
      
      private var timeLimitField:TimeLimitField;
      
      private var fundField:FundField;
      
      private var playerScoreField:PlayerScoreField;
      
      private var tdmScoreField:TDMScoreField;
      
      private var ctfScoreField:CTFScoreIndicator;
      
      private var fieldsFrame:Sprite;
      
      private var localUserId:String;
      
      private var whiteFrame:WhiteFrame;
      
      public function FieldStatistics(localUserId:String, initData:BattleStatInfo, userStats:Vector.<UserStat>, battleType:BattleType)
      {
         super();
         this.userStatis = userStats;
         this.battleType = battleType;
         this.localUserId = localUserId;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.initFields(initData);
      }
      
      public function set timeLimit(value:int) : void
      {
         this._timeLimit = value;
      }
      
      public function ctfShowFlagAtBase(teamType:BattleTeamType) : void
      {
         if(this.ctfScoreField != null)
         {
            this.ctfScoreField.showFlagAtBase(teamType);
         }
      }
      
      public function ctfShowFlagCarried(teamType:BattleTeamType) : void
      {
         if(this.ctfScoreField != null)
         {
            this.ctfScoreField.showFlagCarried(teamType);
         }
      }
      
      public function ctfShowFlagDropped(teamType:BattleTeamType) : void
      {
         if(this.ctfScoreField != null)
         {
            this.ctfScoreField.showFlagDropped(teamType);
         }
      }
      
      private function onAddedToStage(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.adjustFields();
         this.onResize(null);
      }
      
      private function onRemoveFromStage(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function initFields(initData:BattleStatInfo) : void
      {
         var iconType:int = 0;
         if(initData.scoreLimit > 0 || initData.timeLimit > 0)
         {
            this._timeLimit = initData.timeLimit;
            this.scoreLimit = initData.scoreLimit;
            this.fund = initData.fund;
            this.fieldsFrame = new Sprite();
            this.whiteFrame = new WhiteFrame();
            this.fieldsFrame.addChild(this.whiteFrame);
            this.fundField = new FundField(BattleInfoIcons.MONEY);
            this.fieldsFrame.addChild(this.fundField);
            this.fundField.initFund(this.fund);
            iconType = this.battleType == BattleType.CTF?int(BattleInfoIcons.CTF):int(BattleInfoIcons.KILL_LIMIT);
            if(this.scoreLimit > 0)
            {
               this.scoreLimitField = new WinkingField(this.getScoreWinkLimit(),iconType,WinkManager.instance);
               this.scoreLimitField.value = this.scoreLimit;
               this.fieldsFrame.addChild(this.scoreLimitField);
            }
            if(this._timeLimit > 0)
            {
               this.timeLimitField = new TimeLimitField(this.TIME_WINK_LIMIT,BattleInfoIcons.TIME_LIMIT,WinkManager.instance,false);
               this.timeLimitField.initTime(initData.timeLeft);
               this.fieldsFrame.addChild(this.timeLimitField);
            }
            addChild(this.fieldsFrame);
         }
         switch(this.battleType)
         {
            case BattleType.DM:
               this.playerScoreField = new PlayerScoreField(BattleInfoIcons.KILL_LIMIT);
               addChild(this.playerScoreField);
               break;
            case BattleType.TDM:
               this.tdmScoreField = new TDMScoreField();
               this.setTeamScore(BattleTeamType.BLUE,initData.blueScore);
               this.setTeamScore(BattleTeamType.RED,initData.redScore);
               addChild(this.tdmScoreField);
               break;
            case BattleType.CTF:
               this.ctfScoreField = new CTFScoreIndicator();
               this.setTeamScore(BattleTeamType.BLUE,initData.blueScore);
               this.setTeamScore(BattleTeamType.RED,initData.redScore);
               addChild(this.ctfScoreField);
         }
         this.onResize(null);
      }
      
      public function updateUserKills(userStat:UserStat) : void
      {
         if(this.scoreLimitField != null && this.battleType != BattleType.CTF && userStat.kills >= this.scoreLimit - this.getScoreWinkLimit())
         {
            this.scoreLimitField.startWink();
         }
         if(this.playerScoreField != null && userStat.userId == this.localUserId)
         {
            this.playerScoreField.score = userStat.kills;
         }
         this.adjustFields();
      }
      
      public function setTeamScore(teamType:BattleTeamType, score:int) : void
      {
         if(this.tdmScoreField != null)
         {
            this.tdmScoreField.setTeamScore(teamType,score);
         }
         else
         {
            this.ctfScoreField.setTeamScore(teamType,score);
         }
         if(this.scoreLimit > 0 && score >= this.scoreLimit - this.getScoreWinkLimit())
         {
            this.scoreLimitField.startWink();
         }
         this.adjustFields();
      }
      
      public function updateFund(fund:int) : void
      {
         if(this.fundField)
         {
            this.fundField.initFund(fund);
            this.adjustFields();
         }
      }
      
      public function resetFields() : void
      {
         this.updateFund(0);
         if(this.scoreLimit > 0)
         {
            this.scoreLimitField.value = this.scoreLimit;
         }
         if(this._timeLimit > 0)
         {
            this.timeLimitField.initTime(this._timeLimit);
         }
         if(this.playerScoreField != null)
         {
            this.playerScoreField.score = 0;
         }
         if(this.tdmScoreField != null)
         {
            this.tdmScoreField.setScore(0,0);
         }
         if(this.ctfScoreField != null)
         {
            this.ctfScoreField.initScore(0,0);
         }
         this.adjustFields();
      }
      
      public function finish() : void
      {
         if(this.scoreLimit > 0)
         {
            this.scoreLimitField.stopWink();
         }
         if(this._timeLimit > 0)
         {
            this.timeLimitField.value = 0;
            this.timeLimitField.stopWink();
         }
         this.adjustFields();
      }
      
      public function adjustFields() : void
      {
         var frameWidth:Number = NaN;
         if(this.whiteFrame)
         {
            frameWidth = 0;
            this.fundField.x = 14;
            this.fundField.y = 11;
            frameWidth = this.fundField.width + this.fundField.x;
            if(this.scoreLimitField)
            {
               this.scoreLimitField.x = frameWidth + 6;
               this.scoreLimitField.y = 11;
               frameWidth = this.scoreLimitField.width + this.scoreLimitField.x;
            }
            if(this.timeLimitField)
            {
               this.timeLimitField.x = frameWidth + 10;
               this.timeLimitField.y = 11;
               frameWidth = this.timeLimitField.width + this.timeLimitField.x;
            }
            this.whiteFrame.width = 12 + frameWidth;
            this.onResize(null);
         }
      }
      
      private function onResize(e:Event) : void
      {
         var refX:int = 0;
         if(this.playerScoreField != null)
         {
            this.playerScoreField.y = Main.stage.stageHeight - this.playerScoreField.height - 10;
            this.playerScoreField.x = Main.stage.stageWidth - this.playerScoreField.width - 10;
            refX = this.playerScoreField.x;
         }
         if(this.tdmScoreField != null)
         {
            this.tdmScoreField.y = Main.stage.stageHeight - this.tdmScoreField.height - 10;
            this.tdmScoreField.x = Main.stage.stageWidth - this.tdmScoreField.width - 10;
            refX = this.tdmScoreField.x;
         }
         if(this.ctfScoreField != null)
         {
            this.ctfScoreField.y = Main.stage.stageHeight - this.ctfScoreField.height - 10;
            this.ctfScoreField.x = Main.stage.stageWidth - this.ctfScoreField.width - 10;
            refX = this.ctfScoreField.x;
         }
         if(this.fieldsFrame)
         {
            this.fieldsFrame.y = Main.stage.stageHeight - this.fieldsFrame.height - 10;
            this.fieldsFrame.x = refX - this.fieldsFrame.width - 10;
         }
      }
      
      private function getScoreWinkLimit() : int
      {
         return this.battleType == BattleType.CTF?int(this.CTF_SCORE_WINK_LIMIT):int(this.SCORE_WINK_LIMIT);
      }
   }
}
