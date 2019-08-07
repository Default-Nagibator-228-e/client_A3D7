package controls.slider {
	import assets.slider.slider_THUMB_CENTER;
	import assets.slider.slider_THUMB_LEFT;
	import assets.slider.slider_THUMB_RIGHT;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class SliderThumb extends Sprite {
		
		protected var thumb_bmpLeft:slider_THUMB_LEFT = new slider_THUMB_LEFT(1,1);
		protected var thumb_bmpCenter:slider_THUMB_CENTER = new slider_THUMB_CENTER(1,1);
		protected var thumb_bmpRight:slider_THUMB_RIGHT = new slider_THUMB_RIGHT(1,1);
		
		protected var _width:int;
		
		public function SliderThumb() {
			
			super();
			buttonMode = true;
		}
		
		override public function set width(w:Number):void {
			_width = w;
			draw();	 
		}
		
		protected function draw() : void {
			var g:Graphics = this.graphics;
			var matrix:Matrix;
			
			g.clear();
			
			g.beginBitmapFill(thumb_bmpLeft);
			g.drawRect(0,0,10,30);
			g.endFill();
			
			matrix = new Matrix();
			matrix.translate(10,0);
			
			g.beginBitmapFill(thumb_bmpCenter,matrix);
			g.drawRect(10,0,_width-20,30);
			g.endFill();
			
			matrix = new Matrix();
			matrix.translate(_width-10,0);
			
			g.beginBitmapFill(thumb_bmpRight,matrix);
			g.drawRect(_width-10,0,10,30);
			g.endFill();
		}

	}
}