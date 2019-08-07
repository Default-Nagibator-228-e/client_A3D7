package controls.rangicons
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class RangIcon extends MovieClip
   {
      
      private static const rangs:Array = ["Recruit","Private","Gefreiter","Corporal","Master Corporal","Sergeant","Staff Sergeant","Master Sergeant","First Sergeant","Sergeant-Major","Warrant Officer 1","Warrant Officer 2","Warrant Officer 3","Warrant Officer 4","Warrant Officer 5","Third Lieutenant","Second Lieutenant","First Lieutenant","Captain","Major","Lieutenant Colonel","Colonel","Brigadier","Major General","Lieutenant General","General","Marshal","Field Marshal","Commander","Generallisimo"];
       
      public var _rang:int = 1;
	  
	  [Embed(source="s/1.png")]
      private static const p1:Class;
	  
	  [Embed(source="s/2.png")]
      private static const p2:Class;
	  
	  [Embed(source="s/3.png")]
      private static const p3:Class;
	  
	  [Embed(source="s/4.png")]
      private static const p4:Class;
	  
	  [Embed(source="s/5.png")]
      private static const p5:Class;
	  
	  [Embed(source="s/6.png")]
      private static const p6:Class;
	  
	  [Embed(source="s/7.png")]
      private static const p7:Class;
	  
	  [Embed(source="s/8.png")]
      private static const p8:Class;
	  
	  [Embed(source="s/9.png")]
      private static const p9:Class;
	  
	  [Embed(source="s/10.png")]
      private static const p10:Class;
	  
	  [Embed(source="s/11.png")]
      private static const p11:Class;
	  
	  [Embed(source="s/12.png")]
      private static const p12:Class;
	  
	  [Embed(source="s/13.png")]
      private static const p13:Class;
	  
	  [Embed(source="s/14.png")]
      private static const p14:Class;
	  
	  [Embed(source="s/15.png")]
      private static const p15:Class;
	  
	  [Embed(source="s/16.png")]
      private static const p16:Class;
	  
	  [Embed(source="s/17.png")]
      private static const p17:Class;
	  
	  [Embed(source="s/18.png")]
      private static const p18:Class;
	  
	  [Embed(source="s/19.png")]
      private static const p19:Class;
	  
	  [Embed(source="s/20.png")]
      private static const p20:Class;
	  
	  [Embed(source="s/21.png")]
      private static const p21:Class;
	  
	  [Embed(source="s/22.png")]
      private static const p22:Class;
	  
	  [Embed(source="s/23.png")]
      private static const p23:Class;
	  
	  [Embed(source="s/24.png")]
      private static const p24:Class;
	  
	  [Embed(source="s/25.png")]
      private static const p25:Class;
	  
	  [Embed(source="s/26.png")]
      private static const p26:Class;
	  
	  [Embed(source="s/27.png")]
      private static const p27:Class;
	  
	  [Embed(source="s/28.png")]
      private static const p28:Class;
	  
	  [Embed(source="s/29.png")]
      private static const p29:Class;
	  
	  [Embed(source="s/30.png")]
      private static const p30:Class;
	  
	  public var rangs12:Array = new Array(new p1() as Bitmap,new p2() as Bitmap,new p3() as Bitmap,new p4() as Bitmap,new p5() as Bitmap,new p6() as Bitmap,new p7() as Bitmap,new p8() as Bitmap,new p9() as Bitmap,new p10() as Bitmap,new p11() as Bitmap,new p12() as Bitmap,new p13() as Bitmap,new p14() as Bitmap,new p15() as Bitmap,new p16() as Bitmap,new p17() as Bitmap,new p18() as Bitmap,new p19() as Bitmap,new p20() as Bitmap,new p21() as Bitmap,new p22() as Bitmap,new p23() as Bitmap,new p24() as Bitmap,new p25() as Bitmap,new p26() as Bitmap,new p27() as Bitmap,new p28() as Bitmap,new p29() as Bitmap,new p30() as Bitmap);
      
      public function RangIcon(param1:int = 1)
      {
         super();
		 this.addChild(new Bitmap(rangs12[0].bitmapData));
		 this.rang = param1;
      }
      
      public static function rangName(param1:int) : String
      {
         return rangs[param1 - 1];
      }
      
      public function set rang(param1:int) : void
      {
		 this.removeChildren();
         this._rang = param1;
		 if (param1 > 0)
		 {
			this.addChild(new Bitmap(rangs12[this._rang - 1].bitmapData));
		 }
		 gotoAndStop(0);
      }
      
      public function get rang() : int
      {
         return this._rang;
      }
   }
}
