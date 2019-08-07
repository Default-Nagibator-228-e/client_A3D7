package controls.rangicons
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.DisplayObject;
   
   public class RangIconNormal extends RangIcon
   {
       
      public var g:MovieClip;
      
      private var gl:DisplayObject;
	  
	  [Embed(source="n/1.png")]
      private static const p1:Class;
	  
	  [Embed(source="n/2.png")]
      private static const p2:Class;
	  
	  [Embed(source="n/3.png")]
      private static const p3:Class;
	  
	  [Embed(source="n/4.png")]
      private static const p4:Class;
	  
	  [Embed(source="n/5.png")]
      private static const p5:Class;
	  
	  [Embed(source="n/6.png")]
      private static const p6:Class;
	  
	  [Embed(source="n/7.png")]
      private static const p7:Class;
	  
	  [Embed(source="n/8.png")]
      private static const p8:Class;
	  
	  [Embed(source="n/9.png")]
      private static const p9:Class;
	  
	  [Embed(source="n/10.png")]
      private static const p10:Class;
	  
	  [Embed(source="n/11.png")]
      private static const p11:Class;
	  
	  [Embed(source="n/12.png")]
      private static const p12:Class;
	  
	  [Embed(source="n/13.png")]
      private static const p13:Class;
	  
	  [Embed(source="n/14.png")]
      private static const p14:Class;
	  
	  [Embed(source="n/15.png")]
      private static const p15:Class;
	  
	  [Embed(source="n/16.png")]
      private static const p16:Class;
	  
	  [Embed(source="n/17.png")]
      private static const p17:Class;
	  
	  [Embed(source="n/18.png")]
      private static const p18:Class;
	  
	  [Embed(source="n/19.png")]
      private static const p19:Class;
	  
	  [Embed(source="n/20.png")]
      private static const p20:Class;
	  
	  [Embed(source="n/21.png")]
      private static const p21:Class;
	  
	  [Embed(source="n/22.png")]
      private static const p22:Class;
	  
	  [Embed(source="n/23.png")]
      private static const p23:Class;
	  
	  [Embed(source="n/24.png")]
      private static const p24:Class;
	  
	  [Embed(source="n/25.png")]
      private static const p25:Class;
	  
	  [Embed(source="n/26.png")]
      private static const p26:Class;
	  
	  [Embed(source="n/27.png")]
      private static const p27:Class;
	  
	  [Embed(source="n/28.png")]
      private static const p28:Class;
	  
	  [Embed(source="n/29.png")]
      private static const p29:Class;
	  
	  [Embed(source="n/30.png")]
      private static const p30:Class;
	  
	  private var rangs1:Array = [new p1(),new p2(),new p3(),new p4(),new p5(),new p6(),new p7(),new p8(),new p9(),new p10(),new p11(),new p12(),new p13(),new p14(),new p15(),new p16(),new p17(),new p18(),new p19(),new p20(),new p21(),new p22(),new p23(),new p24(),new p25(),new p26(),new p27(),new p28(),new p29(),new p30()];
      
      public function RangIconNormal(param1:int = 1)
      {
         addFrameScript(0, this.frame1);
         super(param1);
		 this.removeChildren();
		 this._rang = param1;
		 this.addChild(new Bitmap(rangs1[param1-1].bitmapData));
         //this.gl = getChildByName("g");
         //this.gl.visible = false;
      }
      
      public function set glow(param1:Boolean) : void
      {
         this.gl.visible = param1;
      }
	  
	  public function set rang1(param1:int) : void
      {
         this.removeChildren();
		 this._rang = param1;
		 this.addChild(new Bitmap(rangs1[param1-1].bitmapData));
      }
      
      private function frame1() : void
      {
         stop();
      }
   }
}
