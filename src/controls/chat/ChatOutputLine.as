package controls.chat
{
   import alternativa.init.Main;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import assets.cellrenderer.battlelist.cell_normal_SELECTED_LEFT;
   import assets.cellrenderer.battlelist.cell_normal_SELECTED_RIGHT;
   import assets.cellrenderer.battlelist.cell_normal_UP_LEFT;
   import assets.cellrenderer.battlelist.cell_normal_UP_RIGHT;
   import assets.icons.ChatArrow;
   import controls.Label;
   import controls.TankWindowInner;
   import controls.rangicons.RangIconSmall;
   import controls.statassets.StatLineBase;
   import controls.statassets.StatLineHeader;
   import controls.statassets.StatLineNormal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import forms.Communic;
   import forms.userlabel.UserLabel;
   
   public class ChatOutputLine extends Sprite
   {
       
      
      public var output:Label;
      
      public var _userName:String;
      
      public var _userNameTo:String;
      
      public var _rang:int;
	  
	  public var _rangTo:int;
      
      private var _light:Boolean = false;
      
      private var _self:Boolean = false;
      
      private var _namesWidth:int = 0;
      
      private var format:TextFormat;
      
      private var arrow:ChatArrow;
      
      private var system:Boolean = false;
      
      private var html:Boolean = false;
      
      private var systemColor:uint = 8454016;
      
      private const lt:Shape = new Shape();
      
      private const rt:Shape = new Shape();
      
      private const lb:Shape = new Shape();
      
      private const rb:Shape = new Shape();
      
      private const c:Shape = new Shape();
      
      private var bmpLeft:BitmapData;
      
      private var bmpRight:BitmapData;
      
      private var bmpLeftS:BitmapData;
      
      private var bmpRightS:BitmapData;
      
      private var bg:Bitmap;
      
      private var defFormat:TextFormat;
      
      private var _width:int;
	  
	  private var chat:Communic;
	  
	  public var bid:String = "";
	  
	  public var from:UserLabel = new UserLabel(new Long(0,1));
	  
	  public var to:UserLabel = new UserLabel(new Long(0,1));
      
      public function ChatOutputLine(w:int, rang:int, name:String, text:String, rangTo:int = 0, nameTo:String = "", _system:Boolean = false, _html:Boolean = false, _systemColor:uint = 8454016, _chat:Communic = null, pa:String = "", pr:Boolean = false)
      {
		 chat = _chat;
         this.output = new Label();
         this.bmpLeft = new cell_normal_UP_LEFT(1,1);
         this.bmpRight = new cell_normal_UP_RIGHT(1,1);
         this.bmpLeftS = new cell_normal_SELECTED_LEFT(1,1);
         this.bmpRightS = new cell_normal_SELECTED_RIGHT(1,1);
         this.bg = new Bitmap();
		 bid = pa;
         super();
		 from.online1(true);
		 to.online1(true);
         mouseEnabled = false;
         addChild(this.bg);
         this.format = new TextFormat("MyriadPro",13);
		 this.from.setRank(rang);
         this._userName = name;
         this._rang = rang;
		 this._rangTo = rangTo;
         this._width = w;
         this.systemColor = _systemColor;
         this.system = _system;
         this.html = _html;
         this.defFormat = this.output.getTextFormat();
         this.output.color = this.system?uint(this.systemColor):uint(16777215);
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.output.selectable = true;
		 this.from.setUid(this.system?"":name,name);
		 this.from.visible = !this.system;
		 addChild(this.from);
         addChild(this.output);
		 this.from.setUid(this.from.uid + (rangTo > 0?"      ": this.system?"":":  "));
		 this._namesWidth = this.from.width;
		 addChild(this.to);
		 this.to.visible = rangTo > 0;
         if(rangTo > 0)
         {
			this.to.setRank(rangTo);
            this.arrow = new ChatArrow();
            this.arrow.y = 8;
            this.arrow.x = this._namesWidth - 10;
            addChild(this.arrow);
			this.to.setUid(nameTo + ":  ", nameTo);
			this.to.x = this.arrow.x + 11;
            this._userNameTo = nameTo;
            this._namesWidth = this._namesWidth + this.to.width;
			this.to.addEventListener(MouseEvent.CLICK, d);
         }
         if(this._namesWidth > this._width / 2)
         {
            this.output.y = 15;
            this.output.x = 0;
            this.output.width = this._width - 5;
         }
         else
         {
            this.output.x = this._namesWidth + 3;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 8;
         }
		 if (this.system)
		 {
			this.output.x = 0;
			this.output.width = this._width - 5;
		 }
         if(!this.html)
         {
            this.output.text = text;
         }
         else
         {
            this.output.htmlText = text;
         }
		 if (pr)
		 {
			this.output.addEventListener(MouseEvent.CLICK, b);
		 }
		 this.from.addEventListener(MouseEvent.CLICK, r);
      }
	  
	  private function b(e:MouseEvent) : void
      {
		if (bid != "")
		{
			PanelModel(Main.osgi.getService(IPanel)).showBattleSelect(null);
			Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + bid.split("battle")[1]);
		}
      }
	  
	  private function r(e:MouseEvent) : void
      {
		var h:String = this.from.uid;
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
				Game.cont.past(_rang,h,"chat",chat);
			});
			tim.start();
		}
      }
	  
	  private function d(e:MouseEvent) : void
      {
		var h:String = this.to.uid;
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
				Game.cont.past(_rangTo,h,"chat",chat);
			});
			tim.start();
		}
      }
      
      public function setData(w:int, rang:int, name:String, text:String, rangTo:int = 0, nameTo:String = "", _system:Boolean = false, _html:Boolean = false, _systemColor:uint = 8454016) : void
      {
		 this.from.setRank(rang);
         this._userName = name;
         this._rang = rang;
         this._width = w;
         this.system = _system;
         this.html = _html;
         this.systemColor = _systemColor;
         this.light = false;
         this.self = false;
         this.bg.bitmapData = new BitmapData(1,1,true,0);
         this.output.defaultTextFormat = this.defFormat;
         this.output.color = this.system?uint(this.systemColor):uint(16777215);
		 this.from.setUid(this.system?"":name,name);
		 this.from.visible = !this.system;
		 this.from.setUid(this.from.uid + (rangTo > 0?"      ":this.system?"":":  "));
         this._namesWidth = this.from.width;
		 this.to.visible = rangTo > 0;
         if(this.arrow == null)
         {
            this.arrow = new ChatArrow();
            addChild(this.arrow);
         }
         this.arrow.visible = rangTo > 0;
         this._userNameTo = nameTo;
         if(rangTo > 0)
         {
			this.to.setRank(rangTo);
            this.arrow.y = 8;
            this.arrow.x = this._namesWidth - 10;
			this.to.x = this.arrow.x + 11;
			this.to.setUid(nameTo + ":  ",nameTo);
            this._namesWidth = this._namesWidth + this.to.width;
         }
         if(this._namesWidth > this._width / 2)
         {
            this.output.y = 15;
            this.output.x = 0;
            this.output.width = this._width - 5;
         }
         else
         {
            this.output.x = this._namesWidth + 3;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 8;
         }
		 if (this.system)
		 {
			this.output.x = 0;
			this.output.width = this._width - 5;
		 }
         if(!this.html)
         {
            this.output.text = text;
         }
         else
         {
            this.output.htmlText = text;
         }
      }
      
      public function get username() : String
      {
         return this._userName;
      }
      
      override public function set width(value:Number) : void
      {
         var baseColor:uint = 0;
         var dr:StatLineBase = null;
         var bmp:BitmapData = null;
         var g:Graphics = null;
         var matr:Matrix = new Matrix();
         var cr:int = 0;
         this._width = int(value);
         if(this._namesWidth > this._width / 2 && this.output.text.length * 8 > this._width - this._namesWidth)
         {
            this.output.y = 19;
            this.output.x = 0;
            this.output.width = this._width - 5;
            cr = 21;
         }
         else
         {
            this.output.x = this._namesWidth;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 5;
            this.output.height = 20;
         }
		 if (this.system)
		 {
			this.output.x = 0;
			this.output.width = this._width - 5;
		 }
         baseColor = this._self?uint(5898034):uint(543488);
         this.bg.bitmapData = new BitmapData(1,Math.max(int(this.output.textHeight + 7.5 + cr),19),true,0);
         dr = this._self?new StatLineHeader():new StatLineNormal();
         if(this._light || this._self)
         {
            dr.width = this._width;
            dr.height = Math.max(int(this.output.textHeight + 5.5 + cr),19);
            dr.y = 2;
            dr.graphics.beginFill(0,0);
            dr.graphics.drawRect(0,0,2,2);
            dr.graphics.endFill();
            bmp = new BitmapData(dr.width,dr.height + 2,true,0);
            bmp.draw(dr);
            this.bg.bitmapData = bmp;
         }
      }
      
      public function set light(value:Boolean) : void
      {
         this._light = value;
         this.width = this._width;
      }
      
      public function set self(value:Boolean) : void
      {
         this._self = value;
         if(!this._self)
         {
            this.output.color = this.system?uint(this.systemColor):uint(16777215);
         }else{
			this.from.setUidColor(0x1244928);
			this.to.setUidColor(0x1244928);
			output.color = 0x1244928;
		 }
         this.width = this._width;
      }
   }
}
