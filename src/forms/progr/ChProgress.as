package forms.progr 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
   
	public class ChProgress extends Sprite
	{
		
		[Embed(source="d/35.png")]
		private static const n:Class;
		[Embed(source="d/36.png")]
		private static const p:Class;
		
		private var na:Bitmap = new n();
		private var pa:Bitmap = new p();
		public static var MAX_WIDTH:int = 0;
		private var dpa:Bitmap = new Bitmap();
		private var spa:Sprite = new Sprite();
		  
		public function ChProgress() 
		{
			super();
			addChild(na);
			addChild(spa);
			spa.addChild(dpa);
			redr(1);
			MAX_WIDTH = pa.width;
		}
		  
		public function redr(param1:int) : void
		{
			spa.removeChild(dpa);
			if (param1 <= 0)
			{
				param1 = 1;
			}
			if (param1>pa.width)
			{
				param1 = pa.width;
			}
			var m:Matrix = new Matrix();
			dpa = new Bitmap(new BitmapData(param1, pa.height,true,16777215));
			m.scale(1, 1);
			dpa.bitmapData.draw(pa, m);
			spa.addChild(dpa);
		}
	}
}