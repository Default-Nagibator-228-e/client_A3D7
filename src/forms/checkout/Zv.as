package forms.checkout 
{
	import controls.Label;
	import controls.Money;
	import controls.TankWindow;
	import controls.TankWindowInner;
	import controls.panel.Indicators;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class Zv extends Sprite
	{
		
		[Embed(source="1.png")]
		private static var add:Class;
		
		private var zv:Bitmap = new add();
		
		private var ind:Indicators = new Indicators();
		
		private var inc:DisplayObject;
		
		private var br:Bitmap;
		
		private var bl:Bitmap;
		
		private var inl:Sprite = new Sprite();
		
		private var inr:DisplayObject;
		
		private var czv:int;
		
		public var type:int;
		
		public var fdds:int;
		
		private var lzv:Label = new Label();
		
		private var glowAlpha:Array;
      
        private var glowColor:Array;
      
        private var glowDelta:Number = 0.02;
		
		private const normalGlowColor:uint = 1244928;
		
		public function Zv() 
		{
			super();
			inc = ind.CR;
			inc.x = 6.5;
			inc.width = int(ind.CR.width*0.9);
			addChild(inc);
			var m:Matrix = new Matrix();
			br = new Bitmap(new BitmapData(12, ind.C1.height,true,16777215));
			m.scale(1, 1);
			br.bitmapData.draw(ind.C1, m, null, null, new Rectangle(0, 0, ind.C1.width/2, ind.C1.height));//
			inr = br;
			inr.x = inc.x + inc.width;
			m = new Matrix();
			bl = new Bitmap(new BitmapData(ind.C1.width, ind.C1.height,true,16777215));
			m.scale(1, 1);
			var r:Rectangle = new Rectangle(ind.C1.width-8, 0, ind.C1.width-(ind.C1.width-8), ind.C1.height);
			bl.bitmapData.draw(ind.C1, m, null, null, r);//
			bl.x = -bl.width+7;
			fdds = bl.width-8;
			addChild(inl);
			inl.addChild(bl);
			zv.x = (inc.x + inc.width) - zv.width;
			zv.y = inc.height / 2 - zv.height / 1.75;
			lzv.wordWrap = false;
			lzv.width = 10;
			lzv.mouseEnabled = false;
			addChild(lzv);
			addChild(inr);
			addChild(zv);
			lzv.color = normalGlowColor;
			zov = 0;
			this.buttonMode = true;
			this.tabEnabled = false;
		}
		
		public function set zov(value:int) : void
		{
			 if(value != czv && czv != 0)
			 {
				flashLabel(lzv,value > czv?uint(normalGlowColor):uint(normalGlowColor));
			 }
			 czv = value;
			 lzv.text = Money.numToString(czv, false);
			 var de:Number = zv.x - lzv.textWidth - 7;
			 lzv.x = de > 6.5 ? de : 6.5;
			 lzv.y = 4;//inc.height/2 - lzv.textHeight/1.25;
		}
		  
		private function flashLabel(target:Label, color:uint = 16711680) : void
        {
			/*glowAlpha[target.name] = 1;
			//glowColor[target.name] = color;
			target.addEventListener(Event.ENTER_FRAME,glowFrame);*/
        }
      
		private function glowFrame(e:Event) : void
		{
			/*var trgt:Label = e.target as Label;
			var filter:GlowFilter = new GlowFilter(glowColor[trgt.name],glowAlpha[trgt.name],4,4,3,1,false);
			trgt.filters = [filter];
			glowAlpha[trgt.name] = glowAlpha[trgt.name] - glowDelta;
			if(glowAlpha[trgt.name] < 0)
			{
				trgt.filters = [];
				trgt.removeEventListener(Event.ENTER_FRAME,glowFrame);
			}*/
		}
	}

}