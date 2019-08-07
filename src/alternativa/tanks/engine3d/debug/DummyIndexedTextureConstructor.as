package alternativa.tanks.engine3d.debug
{
   import alternativa.tanks.engine3d.IndexedTextureConstructor;
   import utils.ITextureConstructorListener;
   import utils.TextureByteData;
   import flash.display.BitmapData;
   import flash.utils.setTimeout;
   
   public class DummyIndexedTextureConstructor extends IndexedTextureConstructor
   {
      
      private static var bmp:BitmapData;
       
      
      private var listener:ITextureConstructorListener;
      
      public function DummyIndexedTextureConstructor()
      {
         var size:int = 0;
         var i:int = 0;
         var ii:int = 0;
         var j:int = 0;
         var jj:int = 0;
         super();
         if(bmp == null)
         {
            size = 100;
            bmp = new BitmapData(size,size,false,8355711);
            for(i = 0; i < size; i++)
            {
               ii = i * 5 / size;
               for(j = 0; j < size; j++)
               {
                  jj = j * 5 / size;
                  if(ii + jj & 1 == 1)
                  {
                     bmp.setPixel(i,j,3355443);
                  }
               }
            }
         }
      }
      
      override public function get texture() : BitmapData
      {
         return bmp;
      }
      
      override public function createTexture(textureData:TextureByteData, listener:ITextureConstructorListener) : void
      {
         this.listener = listener;
         setTimeout(this.notify,0);
      }
      
      private function notify() : void
      {
         var lsnr:ITextureConstructorListener = this.listener;
         this.listener = null;
         lsnr.onTextureReady(this);
      }
   }
}
