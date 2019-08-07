package controls.lifeindicator {

	public class LineCharge extends HorizontalBar {
		[Embed(source="res/reload_indicator_left.png")]
		private static const bitmapLeft:Class;
		[Embed(source="res/reload_indicator_center.png")]
		private static const bitmapCenter:Class;
		[Embed(source="res/reload_indicator_right.png")]
		private static const bitmapRight:Class;

		public function LineCharge() {
			super(new bitmapLeft().bitmapData, new bitmapCenter().bitmapData, new bitmapRight().bitmapData);
		}
	}
}