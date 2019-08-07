package forms.news 
{
	
	import controls.Label;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.ColorConstants;
	import utils.FontParamsUtil;
	
	public class LineOpr extends Sprite
	{
		
		[Embed(source="3.png")]
		private static var add:Class;
		
		[Embed(source="4.png")]
		private static var add1:Class;
		
		[Embed(source="5.png")]
		private static var add2:Class;
		
		[Embed(source="6.png")]
		private static var add3:Class;
		
		public var ud:Number = 1;
		
		private var gop:Sprite = new Sprite();
		
		private var gop1:Sprite = new Sprite();
		
		private var gop2:Sprite = new Sprite();
		
		private var gop3:Sprite = new Sprite();
		
		private var bi:Bitmap = new add();
		
		private var bi1:Bitmap = new add1();
		
		private var bi2:Bitmap = new add2();
		
		private var bi3:Bitmap = new add3();
		
		private var output:Label = new Label();
		
		private var output1:Label = new Label();
		
		public var de:int = 0;
		
		private var wi:int = 0;
		
		private var gog:int = 0;
		
		public var na:String = "";
		
		public var si:String = "";
		
		public var golu:Boolean = false;
		
		public function LineOpr(nazv:String,siz:String,up:Number,de:int) 
		{
			super();
			this.de = de;
			this.ud = up;
			this.si = siz;
			this.na = nazv;
			gop.graphics.clear();
			gop.graphics.lineStyle(3,0x399822,1,true);
			gop.graphics.beginFill(0x399822);//59ff31
			gop.graphics.drawRoundRect(0, 0, 50, 12, 3, 2);
			gop.graphics.endFill();
			gop.buttonMode = true;
			gop.tabEnabled = false;
			addChild(gop);
			addChild(bi1);
			bi1.y = -1;
			gop1.graphics.clear();
			gop1.graphics.lineStyle(3,0x59ff31,1,true);
			gop1.graphics.beginFill(0x59ff31);//59ff31
			gop1.graphics.drawRoundRect(0, 0, 50, 15, 3, 2);
			gop1.graphics.endFill();
			gop1.mouseEnabled = false;
			addChild(gop1);
			addChild(gop3);
			addChild(gop2);
			gop3.graphics.clear();
			gop3.graphics.lineStyle(3,0x59ff31,1,true);
			gop3.graphics.beginFill(0x4eed12);//59ff31
			gop3.graphics.drawRoundRect(0, 0, 50, 12, 3, 2);
			gop3.graphics.endFill();
			gop3.mouseEnabled = false;
			gop2.visible = false;
			gop1.y = -1;
			addChild(bi);
			output.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			output.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
			output.size = 10;
			output.textColor = ColorConstants.GREEN_LABEL;
			output.text = siz;
			addChild(output);
			output1.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			output1.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
			output1.size = 10;
			output1.textColor = 0x1244928;
			output1.text = nazv;
			addChild(output1);
			gop2.addChild(bi2);
			gop2.addChild(bi3);
			bi3.y = -2;
			bi3.x = 2;
			gop2.mouseEnabled = false;
			output1.mouseEnabled = false;
			gop2.y = (12 / 2 - gop2.height / 2) + 2;
			output.y = gop2.y - 2;
			bi.y = output.y + 4;
			output1.x = 6;
			if (Game.group != "admin")
			{
				bi.visible = false;
				output.visible = false;
				gop1.visible = false;
				bi1.visible = false;
				gop.addEventListener(MouseEvent.MOUSE_OUT, ou);
				gop.addEventListener(MouseEvent.MOUSE_OVER, ov);
			}else{
				golu = true;
			}
			if (up == 0)
			{
				gop1.visible = false;
				bi1.visible = false;
			}
			gop3.visible = false;
		}
		
		public function ch(nazv:String,siz:String,up:Number,de:int) : void 
		{
			output1.text = nazv;
			output.text = siz;
			this.ud = up;
			if (Game.group == "admin" && up > 0)
			{
				gop1.visible = true;
				bi1.visible = true;
			}
			this.de = de;
		}
		
		private function ov(e:Event) : void 
		{
			gop3.visible = true;
			gop.alpha = 0.01;
		}
		
		private function ou(e:Event) : void 
		{
			gop3.visible = false;
			gop.alpha = 1;
		}
		
		public function vgolo() : void 
		{
			bi.visible = true;
			output.visible = true;
			gop.buttonMode = false;
			gop.removeEventListener(MouseEvent.MOUSE_OUT, ou);
			gop.removeEventListener(MouseEvent.MOUSE_OVER, ov);
			golu = true;
			if (this.ud > 0)
			{
				gop1.visible = true;
				bi1.visible = true;
				gop3.visible = false;
				gop.alpha = 1;
			}
			res(wi,gog);
		}
		
		public function golo() : void 
		{
			gop2.visible = true;
		}
		
		public function res(widt:int,gg1:int = 0) : int 
		{
			wi = widt;
			gog = gg1;
			var gg:int = widt - bi.width - 22 - output.textWidth;
			gop.graphics.clear();
			gop.graphics.lineStyle(3,0x399822,1,true);
			gop.graphics.beginFill(0x399822);
			gop.graphics.drawRoundRect(0, 0, golu ? gg1 : widt, 12, 3, 2);
			gop.graphics.endFill();
			gop1.graphics.clear();
			gop1.graphics.lineStyle(3,0x59ff31,1,true);
			gop1.graphics.beginFill(0x59ff31);//59ff31
			gop1.graphics.drawRoundRect(0, 0, gg1*ud, 15, 3, 2);
			gop1.graphics.endFill();
			gop3.graphics.clear();
			gop3.graphics.lineStyle(3,0x59ff31,1,true);
			gop3.graphics.beginFill(0x4eed12);//59ff31
			gop3.graphics.drawRoundRect(0, 0, widt, 12, 3, 2);
			gop3.graphics.endFill();
			bi1.x = (gg1*ud) - 3;
			gop2.x = gg1 - gop2.width;
			bi.x = widt - bi.width;
			output.x = gg1 + 11;
			return gg;
		}
		
	}

}