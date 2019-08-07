package alternativa.tanks.models.battlefield.gui.statistics.messages
{
   import alternativa.tanks.models.battlefield.common.MessageContainer;
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import alternativa.types.Long;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.System;
   import flash.utils.Timer;
   import forms.userlabel.UserLabel;
   import utils.client.battlefield.gui.models.statistics.UserStat;
   
   public class UserActionOutputLine extends MessageLine
   {
       
      
      private var userName:String;
	  
	  private var _rank:int;
	  
	  private var userName1:String;
	  
	  private var _rank1:int;
      
      public function UserActionOutputLine(userStat:UserStat, actionText:String, affectedUserSrat:UserStat = null)
      {
		 var from:UserLabel = new UserLabel(new Long(0, 1));
		 var to:UserLabel = new UserLabel(new Long(0,1));
         var label:Label = null;
         var rankIcon:RangIconSmall = null;
         super();
         var nickLabelThickness:int = 50;
         var nickLabelSharpness:int = 0;
         if(userStat != null)
         {
			from.online1(true);
			_rank = userStat.rank;
			from.setRank(userStat.rank);
            this.userName = userStat.name;
			from.setUid(userStat.name,userStat.name);
            from.x = width + 4;
            //from.y = 3;
            from.setUidColor(MessageContainer.getTeamFontColor(userStat.teamType));
            addChild(from);
            from.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
         label = this.createLabel(actionText);
         label.x = width + 4;
         addChild(label);
         if(affectedUserSrat != null)
         {
			to.online1(true);
			_rank1 = affectedUserSrat.rank;
			to.setRank(affectedUserSrat.rank);
            this.userName1 = affectedUserSrat.name;
			to.setUid(affectedUserSrat.name,affectedUserSrat.name);
            to.x = width + 4;
            //to.y = 3;
            to.setUidColor(MessageContainer.getTeamFontColor(affectedUserSrat.teamType));
            addChild(to);
            to.addEventListener(MouseEvent.CLICK,this.onMouseClick1);
         }
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         var h:String = userName;
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
				Game.cont.past(_rank, h, "bat");
			});
			tim.start();
		}
      }
	  
	  private function onMouseClick1(event:MouseEvent) : void
      {
         var h:String = userName1;
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
				Game.cont.past(_rank1, h, "bat");
			});
			tim.start();
		}
      }
      
      private function createLabel(text:String) : Label
      {
         var label:Label = new Label();
         label.mouseEnabled = false;
         label.text = text;
         return label;
      }
   }
}
