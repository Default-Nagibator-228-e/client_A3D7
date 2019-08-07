package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import alternativa.types.Long;
   import utils.client.models.battlefield.IBattlefieldModelBase;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.System;
   import flash.utils.Timer;
   import forms.userlabel.UserLabel;
   
   public class BattleChatLine extends MessageLine
   {
       
      
      private var msgLabel:Label;
      
      private var output:Label;
      
      private var _nameFrom:Label;
      
      private var _rank:int;
      
      private var senderName:String;
      
      private var rankIcon:RangIconSmall;
      
      private var _namesWidth:int = 0;
      
      private var _width:int;
	  
	  public var from:UserLabel = new UserLabel(new Long(0,1));
      
      public function BattleChatLine(lineWidth:int, messageLabel:String, rank:int, name:String, text:String, textColor:uint = 16777215)
      {
         this.output = new Label();
         super();
		 _rank = rank;
		 this.from.setRank(rank);
		 this.output.color = 16777215;
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.output.mouseEnabled = false;
		 this.senderName = name;
		 this.from.setUid(name + ": ", name);
		 from.setUidColor(textColor);
		 addChild(this.from);
		 addChild(this.output);
		 _namesWidth = this.from.width;
         this.output.x = this._namesWidth + 3;
         this.output.y = 0;
         this.output.width = 100;//this._width - this._namesWidth - 8;
		 this.output.text = text;
		 this.addEventListener(MouseEvent.CLICK, r12);
      }
      
      private function r12(e:MouseEvent) : void
      {
		 //throw new Error("");
		var h:String = senderName;
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
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.output.x = this._namesWidth;
         this.output.y = 0;
		 this.output.width = 100;
         //this.output.width = this._width - 5;
         this.output.height = 20;
      }
   }
}