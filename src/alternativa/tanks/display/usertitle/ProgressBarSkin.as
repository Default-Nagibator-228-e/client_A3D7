package alternativa.tanks.display.usertitle
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class ProgressBarSkin
   {
      
      [Embed (source="assets/hpbar_left_dm.png")] private static var hpLeftDmCls:Class;
		private static var hpLeftDm:BitmapData = new hpLeftDmCls().bitmapData;
		[Embed (source="assets/hpbar_right_dm.png")] private static var hpRightDmCls:Class;
		private static var hpRightDm:BitmapData = new hpRightDmCls().bitmapData;
		[Embed (source="assets/hpbar_left_bg_dm.png")] private static var hpLeftBgDmCls:Class;
		private static var hpLeftBgDm:BitmapData = new hpLeftBgDmCls().bitmapData;
		[Embed (source="assets/hpbar_right_bg_dm.png")] private static var hpRightBgDmCls:Class;
		private static var hpRightBgDm:BitmapData = new hpRightBgDmCls().bitmapData;

		[Embed (source="assets/hpbar_left_blue.png")] private static var hpLeftBlueCls:Class;
		private static var hpLeftBlue:BitmapData = new hpLeftBlueCls().bitmapData;
		[Embed (source="assets/hpbar_right_blue.png")] private static var hpRightBlueCls:Class;
		private static var hpRightBlue:BitmapData = new hpRightBlueCls().bitmapData;
		[Embed (source="assets/hpbar_left_bg_blue.png")] private static var hpLeftBgBlueCls:Class;
		private static var hpLeftBgBlue:BitmapData = new hpLeftBgBlueCls().bitmapData;
		[Embed (source="assets/hpbar_right_bg_blue.png")] private static var hpRightBgBlueCls:Class;
		private static var hpRightBgBlue:BitmapData = new hpRightBgBlueCls().bitmapData;

		[Embed (source="assets/hpbar_left_red.png")] private static var hpLeftRedCls:Class;
		private static var hpLeftRed:BitmapData = new hpLeftRedCls().bitmapData;
		[Embed (source="assets/hpbar_right_red.png")] private static var hpRightRedCls:Class;
		private static var hpRightRed:BitmapData = new hpRightRedCls().bitmapData;
		[Embed (source="assets/hpbar_left_bg_red.png")] private static var hpLeftBgRedCls:Class;
		private static var hpLeftBgRed:BitmapData = new hpLeftBgRedCls().bitmapData;
		[Embed (source="assets/hpbar_right_bg_red.png")] private static var hpRightBgRedCls:Class;
		private static var hpRightBgRed:BitmapData = new hpRightBgRedCls().bitmapData;

		[Embed (source="assets/weaponbar_left.png")] private static var weaponLeftCls:Class;
		private static var weaponLeft:BitmapData = new weaponLeftCls().bitmapData;
		[Embed (source="assets/weaponbar_right.png")] private static var weaponRightCls:Class;
		private static var weaponRight:BitmapData = new weaponRightCls().bitmapData;
		[Embed (source="assets/weaponbar_left_bg.png")] private static var weaponLeftBgCls:Class;
		private static var weaponLeftBg:BitmapData = new weaponLeftBgCls().bitmapData;
		[Embed (source="assets/weaponbar_right_bg.png")] private static var weaponRightBgCls:Class;
		private static var weaponRightBg:BitmapData = new weaponRightBgCls().bitmapData;

		[Embed (source="assets/bar_shadow.png")] private static var barShadowCls:Class;
		private static var barShadow:BitmapData = new barShadowCls().bitmapData;
		[Embed (source="assets/bar_shadow_left.png")] private static var barShadowLeftCls:Class;
		private static var barShadowLeft:BitmapData = new barShadowLeftCls().bitmapData;
		[Embed (source="assets/bar_shadow_right.png")] private static var barShadowRightCls:Class;
		private static var barShadowRight:BitmapData = new barShadowRightCls().bitmapData;
      
      private static const COLOR_DM:uint = 4964125;
      
      private static const COLOR_DM_BG:uint = 2448911;
      
      private static const COLOR_TEAM_BLUE:uint = 4691967;
      
      private static const COLOR_TEAM_BLUE_BG:uint = 2181375;
      
      private static const COLOR_TEAM_RED:uint = 15741974;
      
      private static const COLOR_TEAM_RED_BG:uint = 10556937;
      
      private static const COLOR_WEAPON_BAR:uint = 14207247;
      
      private static const COLOR_WEAPON_BAR_BG:uint = 7758340;
      
      public static const HEALTHBAR_DM:ProgressBarSkin = new ProgressBarSkin(COLOR_DM,COLOR_DM_BG,hpLeftDm,hpLeftBgDm,hpRightDm,hpRightBgDm,barShadow,barShadowLeft,barShadowRight);
      
      public static const HEALTHBAR_BLUE:ProgressBarSkin = new ProgressBarSkin(COLOR_TEAM_BLUE,COLOR_TEAM_BLUE_BG,hpLeftBlue,hpLeftBgBlue,hpRightBlue,hpRightBgBlue,barShadow,barShadowLeft,barShadowRight);
      
      public static const HEALTHBAR_RED:ProgressBarSkin = new ProgressBarSkin(COLOR_TEAM_RED,COLOR_TEAM_RED_BG,hpLeftRed,hpLeftBgRed,hpRightRed,hpRightBgRed,barShadow,barShadowLeft,barShadowRight);
      
      public static const WEAPONBAR:ProgressBarSkin = new ProgressBarSkin(COLOR_WEAPON_BAR,COLOR_WEAPON_BAR_BG,weaponLeft,weaponLeftBg,weaponRight,weaponRightBg,barShadow,barShadowLeft,barShadowRight);
       
      
      public var color:uint;
      
      public var bgColor:uint;
      
      public var leftTipFg:BitmapData;
      
      public var leftTipBg:BitmapData;
      
      public var rightTipFg:BitmapData;
      
      public var rightTipBg:BitmapData;
      
      public var shadowLeftTip:BitmapData;
      
      public var shadowRightTip:BitmapData;
      
      public var shadow:BitmapData;
      
      public function ProgressBarSkin(color:uint, bgColor:uint, leftTipFg:BitmapData, leftTipBg:BitmapData, rightTipFg:BitmapData, rightTipBg:BitmapData, shadow:BitmapData, shadowLeftTip:BitmapData, shadowRightTip:BitmapData)
      {
         super();
         this.color = color;
         this.bgColor = bgColor;
         this.leftTipFg = leftTipFg;
         this.leftTipBg = leftTipBg;
         this.rightTipFg = rightTipFg;
         this.rightTipBg = rightTipBg;
         this.shadow = shadow;
         this.shadowLeftTip = shadowLeftTip;
         this.shadowRightTip = shadowRightTip;
      }
   }
}
