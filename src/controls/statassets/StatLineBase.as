package controls.statassets
{
   import controls.resultassets.ResultWindowBase;
   import flash.display.Graphics;
   
   public class StatLineBase extends ResultWindowBase
   {
       
      
      protected var frameColor:uint = 0;
      
      public function StatLineBase()
      {
         super();
      }
      
      override protected function draw() : void
      {
         var g:Graphics = null;
         super.draw();
         if(this.frameColor != 0)
         {
            g = this.graphics;
            g.beginFill(this.frameColor);
            g.drawRect(4,0,_width - 8,1);
            g.drawRect(4,_height - 1,_width - 8,1);
            g.drawRect(0,4,1,_height - 8);
            g.drawRect(_width - 1,4,1,_height - 8);
            g.endFill();
         }
      }
   }
}
