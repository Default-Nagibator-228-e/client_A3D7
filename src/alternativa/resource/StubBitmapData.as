package alternativa.resource
{
   import flash.display.BitmapData;
   
   public class StubBitmapData extends BitmapData
   {
      
      private static const SIZE:int = 20;
       
      
      public function StubBitmapData(color:uint)
      {
         super(SIZE,SIZE,false,0);
         this.init(color);
      }
      
      private function init(color:uint) : void
      {
         var j:int = 0;
         for(var i:int = 0; i < SIZE; i++)
         {
            for(j = 0; j < SIZE; j = j + 2)
            {
               setPixel(Boolean(i % 2)?int(j):int(j + 1),i,color);
            }
         }
      }
   }
}
