package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   
   public class TextureMaterialFactory
   {
       
      
      public function TextureMaterialFactory()
      {
         super();
      }
      
      public static function createTextureMaterial(param1:BitmapData, param2:Boolean) : TextureMaterial
      {
         return new TextureMaterial(param1,false,true,!!param2?int(1):int(0));
      }
   }
}
