package alternativa.tanks.engine3d.debug
{
   import flash.display.BitmapData;
   
   public class DebugTexture extends BitmapData
   {
       
      
      public function DebugTexture(size:int, numCells:int, bgColor:uint, fgColor:uint)
      {
         var ii:int = 0;
         var j:int = 0;
         var jj:int = 0;
         super(size,size,false,bgColor);
         for(var i:int = 0; i < size; i++)
         {
            ii = i * numCells / size;
            for(j = 0; j < size; j++)
            {
               jj = j * numCells / size;
               if(ii + jj & 1 == 1)
               {
                  setPixel(i,j,fgColor);
               }
            }
         }
      }
   }
}
