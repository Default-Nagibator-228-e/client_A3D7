package controls.lifeindicator {

	public class LineLife extends HorizontalBar {
		[Embed(source="res/life_indicator_left.png")]
		private static const bitmapLeft:Class;
		[Embed(source="res/life_indicator_center.png")]
		private static const bitmapCenter:Class;
		[Embed(source="res/life_indicator_right.png")]
		private static const bitmapRight:Class;

		public function LineLife() {
			super(new bitmapLeft().bitmapData, new bitmapCenter().bitmapData, new bitmapRight().bitmapData);
		}
	}
}