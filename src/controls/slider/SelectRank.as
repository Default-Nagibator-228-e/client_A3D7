package controls.slider {
	import controls.Slider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Michael
	 */
	public class SelectRank extends Slider {
		private var _minRang:int = 0;
		private var _maxRang:int = 0;
		private var _currentRang:int = 1;
		private var sthumb:SelectRankThumb = new SelectRankThumb();

		public function SelectRank() {

			super();
			removeChild(track);
			track = new SliderTrack(false);
			addChild(track);

			removeChild(thumb);
			addChild(sthumb);

			_thumb_width = 36;
		}

		override protected function UnConfigUI(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragThumb);
		}

		override protected function ConfigUI(e:Event):void {
			sthumb.leftDrag.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			sthumb.rightDrag.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			sthumb.centerDrag.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}


//		override public function set maxValue(maxValue:Number):void {
//			_maxValue = maxValue + 1;
//		}


		public function get minRang():int {
			return _minRang;
		}

		public function set minRang(minRang:int):void {
			_minRang = minRang;
		}

		public function get maxRang():int {
			return _maxRang;
		}

		public function set maxRang(maxRang:int):void {
			_maxRang = maxRang;
		}

		public function get currentRang():int {
			return _currentRang;
		}

		public function set currentRang(currentRang:int):void {
			_currentRang = currentRang; //= _minRang
			value = _minRang = _maxRang = _currentRang;
		}

		protected var _thumbTick:Number;

		override public function set width(w:Number):void {
			super.width = w;
			var rz:int = (_maxValue - _minValue);

			_thumbTick = (_width + 2 - _thumb_width) / rz;

			//	trace('_thumbTick',_thumbTick);

			drawThumb();
		}


		override protected function onMouseUp(e:MouseEvent):void {

			if (e != null) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragThumb);
			}
			//trace("up");
		}

		override protected function dragThumb(e:MouseEvent):void {
			// флаги
			var leftFlag:Boolean = trgt.mouseX < curThumbX;
			var rightFlag:Boolean = trgt.mouseX > curThumbX;
			var maxMinRangFlag:Boolean = _minRang < _currentRang;
			var minMaxRangFlag:Boolean = _maxRang > _currentRang;
			var rz:int=0;

			if (trgt == sthumb.leftDrag && (leftFlag || maxMinRangFlag)) {
				_minRang += int((sthumb.leftDrag.mouseX - curThumbX) / _thumbTick);
				if (_minRang < _minValue) {
					_minRang = _minValue;
				}
			}
			else if (trgt == sthumb.rightDrag && (rightFlag || minMaxRangFlag)) {
				_maxRang += int((sthumb.rightDrag.mouseX - curThumbX) / _thumbTick);
				if (_maxRang > _maxValue) {
					_maxRang = _maxValue;
				}
			}
			else if (trgt == sthumb.centerDrag && ((leftFlag || maxMinRangFlag) && (rightFlag || minMaxRangFlag))) {
				_minRang += int((sthumb.centerDrag.mouseX - curThumbX) / _thumbTick);
				_maxRang += int((sthumb.centerDrag.mouseX - curThumbX) / _thumbTick);
				if (_minRang < _minValue) {
					
					rz=_maxRang - _minRang;
					_minRang = _minValue;
					_maxRang = _minValue + rz;
				}

				if (_maxRang > _maxValue) {
					
					rz=_maxRang - _minRang;
					_maxRang = _maxValue;
					_minRang = _maxRang - rz;
				}
			}

			if (_minRang < _currentRang - 1)
			{
				_minRang = _currentRang - 1;
			}
			
			if (_maxRang > _currentRang + 1)
			{
				_maxRang = _currentRang + 1;
			}
			
			if (_maxRang > 30)
			{
				_maxRang = 30;
			}
			
			if (_minRang < 1)
			{
				_minRang = 1;
			}

			drawThumb();

		}

		private function drawThumb():void {
			var rz:int = this._maxRang - this._minRang;
			if (rz < 0)
			{
				return;
			}
			sthumb.width = _thumb_width + _thumbTick * rz;
			sthumb.x = int(_thumbTick * (_minRang - _minValue));

			sthumb.minRang = _minRang;
			sthumb.maxRang = _maxRang;

		}
	}
}
