package alternativa.tanks.models.battlefield.gui.statistics.table
{
   import alternativa.types.Long;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import controls.resultassets.ResultWindowBlueNormal;
   import controls.resultassets.ResultWindowBlueSelected;
   import controls.resultassets.ResultWindowGreenNormal;
   import controls.resultassets.ResultWindowGreenSelected;
   import controls.resultassets.ResultWindowRedNormal;
   import controls.resultassets.ResultWindowRedSelected;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import forms.userlabel.UserLabel;
   
   public class StatisticsListRenderer extends CellRenderer
   {
      
      private static const RANK_ICON_X:int = 2;
      
      private static const RANK_ICON_Y:int = 3;
       
      private var dataItem:StatisticsData;
	  
      private var nicon:DisplayObject;
      
      public function StatisticsListRenderer()
      {
         super();
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         this.nicon = this.myIcon(_data);
      }
      
      override public function set listData(value:ListData) : void
      {
         _listData = value;
         label = _listData.label;
         if(this.nicon != null)
         {
            setStyle("icon",this.nicon);
         }
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function drawLayout() : void
      {
      }
      
      override protected function drawIcon() : void
      {
         var oldIcon:DisplayObject = icon;
         var iconStyle:Object = getStyleValue("icon");
         if(iconStyle != null)
         {
            icon = getDisplayObjectInstance(iconStyle);
         }
         if(icon != null)
         {
            addChildAt(icon,1);
         }
         if(oldIcon != null && oldIcon != icon && oldIcon.parent == this)
         {
            removeChild(oldIcon);
         }
      }
      
      private function myIcon(data:Object) : Sprite
      {
		 var from:UserLabel = new UserLabel(new Long(0,1));
         var bg:DisplayObject = null;
         var label:Label = null;
         var rankIcon:RangIconSmall = null;
         dataItem = StatisticsData(data);
         switch(dataItem.type)
         {
            case ViewStatistics.BLUE:
               bg = dataItem.self?new ResultWindowBlueSelected():new ResultWindowBlueNormal();
               break;
            case ViewStatistics.GREEN:
               bg = dataItem.self?new ResultWindowGreenSelected():new ResultWindowGreenNormal();
               break;
            case ViewStatistics.RED:
               bg = dataItem.self?new ResultWindowRedSelected():new ResultWindowRedNormal();
         }
         var container:Sprite = new Sprite();
         container.addChild(bg);
         var color:uint = 16777215;
         if(dataItem.playerRank > 0)
         {
			from.setRank(dataItem.playerRank);
			from.setUid(dataItem.playerName,dataItem.playerName);
			container.addChild(from);
         }
         var x:int = TableConst.LABELS_OFFSET;
		 //if (dataItem.playerName == "")
		 //{
			label = this.createCell(container, dataItem.playerName == ""?"None":dataItem.playerName, color, TextFormatAlign.LEFT, TableConst.CALLSIGN_WIDTH, x + 2,dataItem.playerName == ""?true:false);
		 //}
         x = x + label.width;
         if(dataItem.score > -1)
         {
            label = this.createCell(container,dataItem.score.toString(),color,TextFormatAlign.RIGHT,TableConst.SCORE_WIDTH,x);
            x = x + label.width;
         }
         label = this.createCell(container,dataItem.kills.toString(),color,TextFormatAlign.RIGHT,TableConst.KILLS_WIDTH,x);
         x = x + label.width;
         label = this.createCell(container,dataItem.deaths.toString(),color,TextFormatAlign.RIGHT,TableConst.DEATHS_WIDTH,x);
         x = x + label.width;
         var coeff:Number = dataItem.kills / dataItem.deaths;
         var s:String = dataItem.deaths == 0 || dataItem.kills == 0?"—":coeff.toFixed(2);
         label = this.createCell(container,s,color,TextFormatAlign.RIGHT,TableConst.RATIO_WIDTH,x);
         if(dataItem.reward > -1)
         {
			x = x + label.width;
            label = this.createCell(container,dataItem.reward.toString(),color,TextFormatAlign.RIGHT,TableConst.REWARD_WIDTH,x);
         }
		 if(dataItem.zt > -1)
         {
			x = x + label.width;
            label = this.createCell(container,dataItem.zt.toString(),0xFFA500,TextFormatAlign.RIGHT,TableConst.ZV_WIDTH,x);
         }
         bg.width = width;
         bg.height = TableConst.ROW_HEIGHT - 2;
         return container;
      }
	  
	  private function r12(e:MouseEvent) : void
      {
		 //throw new Error("");
		var h:String = dataItem.playerName;
		while(h.search(":") != -1)
         {
            h = h.replace(":","");
         }
		 while(h.search(" ") != -1)
         {
            h = h.replace(" ","");
         }
		if (!(h == Game.log))
		{
			var tim:Timer = new Timer(100,1);
			tim.addEventListener(TimerEvent.TIMER_COMPLETE, function(param1:Event):void
			{
				Game.cont.visible = true;
				Game.cont.past(dataItem.playerRank, h, "bat");
			});
			tim.start();
		}
      }
      
      private function createCell(container:DisplayObjectContainer, text:String, color:uint, align:String, width:int, x:int,hy:Boolean = true) : Label
      {
         var label:Label = new Label();
         label.autoSize = TextFieldAutoSize.NONE;
         label.text = text;
         label.color = color;
         label.align = align;
         label.x = x;
         label.width = width;
         label.height = TableConst.ROW_HEIGHT;
		 this.addEventListener(MouseEvent.CLICK, r12);
         container.addChild(label);
		 label.visible = hy;
         return label;
      }
   }
}
