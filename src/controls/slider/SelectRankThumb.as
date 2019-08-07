package controls.slider {
	import controls.rangicons.RangIcon;
	import controls.rangicons.RangIconSmall;
	import flash.display.Bitmap;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;


	public class SelectRankThumb extends SliderThumb {
		[Embed(source="arrow.png")] private static const bitmapArrow:Class;
		private static const arrow:BitmapData = new bitmapArrow().bitmapData;

		private var iconMin:RangIcon = new RangIcon();
		private var iconMax:RangIcon = new RangIcon();
		private var _minRang:int = 1;
		private var _maxRang:int = 1;

		public var leftDrag:Sprite;
		public var centerDrag:Sprite;
		public var rightDrag:Sprite;

		public function SelectRankThumb() {
			super();
			var g:Graphics;
			addChild(iconMax);
			addChild(iconMin);

			iconMin.y = iconMax.y = 9;

			// левая драголка
			leftDrag = new Sprite();

			g = leftDrag.graphics;
			g.beginFill(0, 0);
//			g.lineStyle(0,0x0000ff);
			g.drawRect(0, 0, 10, 30);
			g.endFill();

			// Центральная драголка
			centerDrag = new Sprite();
			centerDrag.x = 10;

			// правая драголка
			rightDrag = new Sprite();

			g = rightDrag.graphics;
			g.beginFill(0, 0);
//			g.lineStyle(0,0x00ff00);
			g.drawRect(0, 0, 10, 30);
			g.endFill();

			addChild(leftDrag);
			addChild(centerDrag);
			addChild(rightDrag);
			
			leftDrag.buttonMode = true;
			centerDrag.buttonMode = true;
			rightDrag.buttonMode = true;


		}

		override protected function draw():void {
			super.draw();

			var rz:int = _maxRang - _minRang;
			var g:Graphics;
			var matrix:Matrix;

			iconMin.rang = _minRang;
			iconMax.rang = _maxRang;

			iconMax.visible = rz > 0;

			if (rz == 0) {
				iconMax.x = iconMin.x = int((_width - iconMin.width) / 2);

			}
			else {
				iconMin.x = 11;
				iconMax.x = _width - iconMax.width - 11;
				
				g = this.graphics;
				
				matrix = new Matrix();
				matrix.translate(5,12);
				
				g.beginBitmapFill(arrow,matrix);
				g.drawRect(5,12,4,7);
				g.endFill();
				
				matrix = new Matrix();
				matrix.rotate(Math.PI);
				matrix.translate(_width-9,12);
				
				g.beginBitmapFill(arrow,matrix);
				g.drawRect(_width-9,12,4,7);
				g.endFill();
				

			}
			iconMin.y = iconMax.y = 9;
			iconMax.y = 8;
			g = centerDrag.graphics;
			g.clear();
			g.beginFill(0, 0);
//			g.lineStyle(0,0xff0000);
			g.drawRect(0, 0, _width - 20, 30);
			g.endFill();
			
			rightDrag.x = _width - 10;


		}

		public function set minRang(minRang:int):void {
			_minRang = minRang;
			draw();
		}

		public function set maxRang(maxRang:int):void {
			_maxRang = maxRang;
			draw();
		}

	}
}