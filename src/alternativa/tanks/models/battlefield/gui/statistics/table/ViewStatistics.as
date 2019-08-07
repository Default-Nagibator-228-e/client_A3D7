package alternativa.tanks.models.battlefield.gui.statistics.table
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.scroller.color.ScrollThumbSkinBlue;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollThumbSkinRed;
   import assets.scroller.color.ScrollTrackBlue;
   import assets.scroller.color.ScrollTrackGreen;
   import assets.scroller.color.ScrollTrackRed;
   import controls.Label;
   import controls.resultassets.ResultWindowBase;
   import controls.resultassets.ResultWindowBlue;
   import controls.resultassets.ResultWindowBlueHeader;
   import controls.resultassets.ResultWindowGreen;
   import controls.resultassets.ResultWindowGreenHeader;
   import controls.resultassets.ResultWindowRed;
   import controls.resultassets.ResultWindowRedHeader;
   import fl.controls.List;
   import fl.data.DataProvider;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   
   public class ViewStatistics extends Sprite
   {
      
      public static const BLUE:int = 0;
      
      public static const RED:int = 1;
      
      public static const GREEN:int = 2;
      
      private static const MIN_HEIGHT:int = 52;
      
      private static const TABLE_MARGIN:int = 7;
      
      private static const EXTRA_HEIGHT:int = 12;
      
      private static const EXTRA_WIDTH:int = 20;
      
      private static var scrollBarStyles:Object;
       
      
      private var list:List;
      
      private var dp:DataProvider;
      
      private var inner:ResultWindowBase;
      
      private var type:int;
      
      private var localUserId:String;
      
      private var finish:Boolean;
      
      private var header:Sprite;
      
      private var captionCallsign:String;
      
      private var captionScore:String;
      
      private var captionKills:String;
      
      private var captionDeaths:String;
      
      private var captionKDRatio:String;
      
      private var captionReward:String;
	  
	  private var captionZv:String;
	  
	  private var zer:Boolean;
      
      public function ViewStatistics(type:int, localUserId:String, finish:Boolean, ze:Boolean = true)
      {
         this.dp = new DataProvider();
         super();
         if(scrollBarStyles == null)
         {
            this.initScrollBarStyles();
         }
         this.type = type;
         this.localUserId = localUserId;
         this.finish = finish;
         this.tabEnabled = false;
         this.tabChildren = false;
         var localerService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.captionCallsign = localerService.getText(TextConst.BATTLE_STAT_CALLSIGN);
         this.captionScore = localerService.getText(TextConst.BATTLE_STAT_SCORE);
         this.captionKills = localerService.getText(TextConst.BATTLE_STAT_KILLS);
         this.captionDeaths = localerService.getText(TextConst.BATTLE_STAT_DEATHS);
         this.captionKDRatio = localerService.getText(TextConst.BATTLE_STAT_KDRATIO);
         this.captionReward = localerService.getText(TextConst.BATTLE_STAT_REWARD);
		 zer = ze;
		 if (zer)
		 {
			captionZv = "Звёзды";
		 }
         this.init();
      }
      
      private function initScrollBarStyles() : void
      {
         scrollBarStyles = {};
         this.addScrollBarStyle("downArrowUpSkin",ScrollArrowDownGreen,ScrollArrowDownRed,ScrollArrowDownBlue);
         this.addScrollBarStyle("downArrowDownSkin",ScrollArrowDownGreen,ScrollArrowDownRed,ScrollArrowDownBlue);
         this.addScrollBarStyle("downArrowOverSkin",ScrollArrowDownGreen,ScrollArrowDownRed,ScrollArrowDownBlue);
         this.addScrollBarStyle("downArrowDisabledSkin",ScrollArrowDownGreen,ScrollArrowDownRed,ScrollArrowDownBlue);
         this.addScrollBarStyle("upArrowUpSkin",ScrollArrowUpGreen,ScrollArrowUpRed,ScrollArrowUpBlue);
         this.addScrollBarStyle("upArrowDownSkin",ScrollArrowUpGreen,ScrollArrowUpRed,ScrollArrowUpBlue);
         this.addScrollBarStyle("upArrowOverSkin",ScrollArrowUpGreen,ScrollArrowUpRed,ScrollArrowUpBlue);
         this.addScrollBarStyle("upArrowDisabledSkin",ScrollArrowUpGreen,ScrollArrowUpRed,ScrollArrowUpBlue);
         this.addScrollBarStyle("trackUpSkin",ScrollTrackGreen,ScrollTrackRed,ScrollTrackBlue);
         this.addScrollBarStyle("trackDownSkin",ScrollTrackGreen,ScrollTrackRed,ScrollTrackBlue);
         this.addScrollBarStyle("trackOverSkin",ScrollTrackGreen,ScrollTrackRed,ScrollTrackBlue);
         this.addScrollBarStyle("trackDisabledSkin",ScrollTrackGreen,ScrollTrackRed,ScrollTrackBlue);
         this.addScrollBarStyle("thumbUpSkin",ScrollThumbSkinGreen,ScrollThumbSkinRed,ScrollThumbSkinBlue);
         this.addScrollBarStyle("thumbDownSkin",ScrollThumbSkinGreen,ScrollThumbSkinRed,ScrollThumbSkinBlue);
         this.addScrollBarStyle("thumbOverSkin",ScrollThumbSkinGreen,ScrollThumbSkinRed,ScrollThumbSkinBlue);
         this.addScrollBarStyle("thumbDisabledSkin",ScrollThumbSkinGreen,ScrollThumbSkinRed,ScrollThumbSkinBlue);
      }
      
      private function addScrollBarStyle(styleName:String, greenStyle:Class, redStyle:Class, blueStyle:Class) : void
      {
         var styles:Dictionary = new Dictionary();
         styles[ViewStatistics.GREEN] = greenStyle;
         styles[ViewStatistics.RED] = redStyle;
         styles[ViewStatistics.BLUE] = blueStyle;
         scrollBarStyles[styleName] = styles;
      }
      
      public function updatePlayer(id:Object, name:String, rank:int, kills:int, deaths:int, score:int, reward:int, zt:int) : void
      {
         var dataItem:StatisticsData = new StatisticsData();
         dataItem.id = id;
         dataItem.playerRank = rank;
         dataItem.playerName = name;
         dataItem.kills = kills;
         dataItem.deaths = deaths;
         dataItem.score = score;
         dataItem.reward = reward;
		 dataItem.zt = zt;
         dataItem.type = this.type;
         dataItem.self = id == this.localUserId;
         var index:int = id == null?int(-1):int(this.indexById(id));
         if(index < 0)
         {
            this.dp.addItem(dataItem);
         }
         else
         {
            this.dp.replaceItemAt(dataItem,index);
         }
         if(this.type == GREEN)
         {
            this.dp.sortOn(["kills","deaths"],[Array.DESCENDING | Array.NUMERIC,Array.NUMERIC]);
         }
         else
         {
            this.dp.sortOn(["score","kills","deaths"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.NUMERIC]);
         }
      }
      
      public function removePlayer(id:Object) : void
      {
         var index:int = this.indexById(id);
         this.dp.removeItemAt(index);
      }
      
      public function removeAll() : void
      {
         this.dp.removeAll();
      }
      
      public function resize(maxHeight:Number) : void
      {
         var h:Number = (this.dp.length + 1) * TableConst.ROW_HEIGHT + EXTRA_HEIGHT;
         if(h > maxHeight)
         {
            h = int(maxHeight / this.header.height) * this.header.height + EXTRA_HEIGHT;
         }
         this.inner.height = h < MIN_HEIGHT?Number(MIN_HEIGHT):Number(h);
         this.list.setSize(this.inner.width - 2 * TableConst.TABLE_MARGIN,this.inner.height - this.header.y - this.header.height - 5);
      }
      
      override public function get height() : Number
      {
         return this.inner.height;
      }
      
      public function get rowCount() : int
      {
         return this.dp.length;
      }
      
      private function indexById(id:Object) : int
      {
         var dataItem:StatisticsData = null;
         var len:int = this.dp.length;
         for(var i:int = 0; i < len; i++)
         {
            dataItem = this.dp.getItemAt(i) as StatisticsData;
            if(dataItem != null && dataItem.id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function setScrollbarStyle() : void
      {
         this.setListStyle("downArrowUpSkin");
         this.setListStyle("downArrowDownSkin");
         this.setListStyle("downArrowOverSkin");
         this.setListStyle("downArrowDisabledSkin");
         this.setListStyle("upArrowUpSkin");
         this.setListStyle("upArrowDownSkin");
         this.setListStyle("upArrowOverSkin");
         this.setListStyle("upArrowDisabledSkin");
         this.setListStyle("trackUpSkin");
         this.setListStyle("trackDownSkin");
         this.setListStyle("trackOverSkin");
         this.setListStyle("trackDisabledSkin");
         this.setListStyle("thumbUpSkin");
         this.setListStyle("thumbDownSkin");
         this.setListStyle("thumbOverSkin");
         this.setListStyle("thumbDisabledSkin");
      }
      
      private function setListStyle(styleName:String) : void
      {
         this.list.setStyle(styleName,scrollBarStyles[styleName][this.type]);
      }
      
      private function init() : void
      {
         switch(this.type)
         {
            case RED:
               this.inner = new ResultWindowRed();
               break;
            case GREEN:
               this.inner = new ResultWindowGreen();
               break;
            case BLUE:
               this.inner = new ResultWindowBlue();
         }
         this.inner.width = TableConst.LAST_COLUMN_EXTRA_WIDTH + 2 * TableConst.TABLE_MARGIN + TableConst.LABELS_OFFSET + TableConst.CALLSIGN_WIDTH + TableConst.KILLS_WIDTH + TableConst.DEATHS_WIDTH + TableConst.RATIO_WIDTH + (this.type != GREEN?TableConst.SCORE_WIDTH:0) + (this.finish?TableConst.REWARD_WIDTH:0) + (this.finish && this.zer?TableConst.ZV_WIDTH:0) + EXTRA_WIDTH;
         this.inner.height = MIN_HEIGHT;
         addChild(this.inner);
         this.header = this.getHeader();
         this.inner.addChild(this.header);
         this.header.x = TABLE_MARGIN;
         this.header.y = TABLE_MARGIN;
         this.dp = new DataProvider();
         this.list = new List();
         this.setScrollbarStyle();
         this.inner.addChild(this.list);
         this.list.rowHeight = TableConst.ROW_HEIGHT;
         this.list.x = TABLE_MARGIN;
         this.list.setStyle("cellRenderer",StatisticsListRenderer);
         this.list.y = this.header.y + this.header.height;
         this.list.focusEnabled = false;
         this.list.dataProvider = this.dp;
      }
      
      private function getHeader() : Sprite
      {
         var bg:DisplayObject = null;
         var color:uint = 0;
         var label:Label = null;
         switch(this.type)
         {
            case BLUE:
               bg = new ResultWindowBlueHeader();
               color = 11590;
               break;
            case GREEN:
               bg = new ResultWindowGreenHeader();
               color = 83457;
               break;
            case RED:
               bg = new ResultWindowRedHeader();
               color = 4655104;
         }
         var header:Sprite = new Sprite();
         header.addChild(bg);
         var x:int = TableConst.LABELS_OFFSET;
         label = this.createHeaderLabel(header,this.captionCallsign,color,TextFormatAlign.LEFT,TableConst.CALLSIGN_WIDTH,x);
         x = x + label.width;
         if(this.type != GREEN)
         {
            label = this.createHeaderLabel(header,this.captionScore,color,TextFormatAlign.RIGHT,TableConst.SCORE_WIDTH,x);
            x = x + label.width;
         }
         label = this.createHeaderLabel(header,this.captionKills,color,TextFormatAlign.RIGHT,TableConst.KILLS_WIDTH,x);
         x = x + label.width;
         label = this.createHeaderLabel(header,this.captionDeaths,color,TextFormatAlign.RIGHT,TableConst.DEATHS_WIDTH,x);
         x = x + label.width;
         label = this.createHeaderLabel(header,this.captionKDRatio,color,TextFormatAlign.RIGHT,TableConst.RATIO_WIDTH,x);
         if(this.finish)
         {
			x = x + label.width;
            label = this.createHeaderLabel(header, this.captionReward, color, TextFormatAlign.RIGHT, TableConst.REWARD_WIDTH, x);
			if (zer)
			{
				x = x + label.width;
				label = this.createHeaderLabel(header, captionZv, color, TextFormatAlign.RIGHT, TableConst.ZV_WIDTH, x);
			}
         }
         bg.width = width - 2 * TABLE_MARGIN;
         bg.height = TableConst.ROW_HEIGHT - 2;
         return header;
      }
      
      private function createHeaderLabel(header:Sprite, text:String, color:uint, align:String, width:int, x:int) : Label
      {
         var label:Label = new Label();
         label.autoSize = TextFieldAutoSize.NONE;
         label.text = text;
         label.color = color;
         label.align = align;
         label.x = x;
         label.width = width;
         label.height = TableConst.ROW_HEIGHT;
         header.addChild(label);
         return label;
      }
   }
}
