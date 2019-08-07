package forms.cong 
{
	import controls.DefaultButton;
	import controls.Label;
	import controls.TankWindow;
	import controls.TankWindowInner;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Cong extends Sprite
	{
		
		[Embed(source="ru.png")]
		private static const gg:Class;
      
		private static const ggh:Bitmap = new gg();
		
		[Embed(source="icon_crystal_mini.png")]
		private static const gg1:Class;
      
		private static const ggh1:Bitmap = new gg1();
		
		private const windowMargin:int = 12;
		
		private var window:TankWindow = new TankWindow();
		
		private var windowInn:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
		
		private var cry:int = 0; 
		
		private var bat:DefaultButton = new DefaultButton();
		
		private var l:Label = new Label();
		
		private var l1:Label = new Label();
		
		private var l10:Sprite = new Sprite();
		
		public function Cong(p:int) 
		{
			super();
			this.addChild(window);
			this.addChild(windowInn);
			this.addChild(ggh);
			bat.label = "Закрыть";
			this.addChild(bat);
			bat.addEventListener(MouseEvent.CLICK,clos);
			l.text = "Всего начислено кристаллов:";
			l.textColor = 8454016;
			l1.text = p + "";
			l1.textColor = 8454016;
			l10.addChild(l1);
			l10.addChild(ggh1);
			ggh1.x = l1.width;
			ggh1.y = ggh1.height / 4;
			this.addChild(l10);
			this.addChild(l);
			cry = p;
			resize();
		}
		
		public function clos(e:Event):void 
		{
			this.removeChild(window);
			this.removeChild(windowInn);
			this.removeChild(ggh);
			this.removeChild(bat);
			this.removeChild(l10);
			this.removeChild(l);
		}
		
		public function sh():void 
		{
			this.addChild(window);
			this.addChild(windowInn);
			this.addChild(ggh);
			this.addChild(bat);
			this.addChild(l10);
			this.addChild(l);
		}
		
		public function resize():void 
		{
			window.width = ggh.width + windowMargin * 8;
			window.height = 500;
			windowInn.width = window.width - windowMargin * 2;
			windowInn.height = ggh.height + windowMargin * 6;
			windowInn.x = windowMargin;
			windowInn.y = windowMargin;
			ggh.x = windowMargin * 4;
			ggh.y = windowMargin * 4;
			l.x = windowMargin * 4;
			l.y = windowInn.height - windowMargin * 2;
			l10.x = ggh.x + ggh.width - l10.width;
			l10.y = windowInn.height - windowMargin * 2;
			bat.x = window.width / 2 - bat.width/2;
			bat.y = windowInn.y + windowInn.height + windowMargin;
			window.height = bat.y + bat.height + windowMargin;
		}
		
	}

}