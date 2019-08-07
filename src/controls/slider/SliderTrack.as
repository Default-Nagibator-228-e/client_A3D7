package controls.slider {
	import assets.slider.slider_TRACK_CENTER;
	import assets.slider.slider_TRACK_LEFT;
	import assets.slider.slider_TRACK_RIGHT;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class SliderTrack extends Sprite {

		protected var track_bmpLeft:slider_TRACK_LEFT = new slider_TRACK_LEFT(1, 1);
		protected var track_bmpCenter:slider_TRACK_CENTER = new slider_TRACK_CENTER(1, 1);
		protected var track_bmpRight:slider_TRACK_RIGHT = new slider_TRACK_RIGHT(1, 1);

		protected var _width:int;
		protected var _showTrack:Boolean

		public function SliderTrack(showtrack:Boolean = true) {
			super();
			_showTrack = showtrack;
			
		}

		override public function set width(w:Number):void {
			_width = w;
			draw();
		}

		protected function draw():void {
			var g:Graphics = this.graphics;
			var matrix:Matrix;

			g.clear();

			g.beginBitmapFill(track_bmpLeft);
			g.drawRect(0, 0, 5, 30);
			g.endFill();

			matrix = new Matrix();
			matrix.translate(5, 0);

			g.beginBitmapFill(track_bmpCenter, matrix);
			g.drawRect(5, 0, _width - 11, 30);
			g.endFill();

			matrix = new Matrix();
			matrix.translate(_width - 6, 0);

			g.beginBitmapFill(track_bmpRight, matrix);
			g.drawRect(_width - 6, 0, 6, 30);
			g.endFill();

			
			// ticks
			if (_showTrack) {
				var tickDelta:Number = width / ((_maxValue - _minValue) / _tick);
				var curTickX:Number = tickDelta;

				while (curTickX < _width) {
					g.lineStyle(0, 0xffffff, .4);
					g.moveTo(curTickX, 5);
					g.lineTo(curTickX, 25);

					curTickX += tickDelta;
				}
			}


		}

		protected var _minValue:Number = 0;

		public function set minValue(minValue:Number):void {
			_minValue = minValue;
			draw();
		}

		protected var _maxValue:Number = 100;

		public function set maxValue(maxValue:Number):void {
			_maxValue = maxValue;
			draw();
		}

		protected var _tick:Number = 10;

		public function set tickInterval(tick:Number):void {
			_tick = tick;
			draw();
		}

	}
}