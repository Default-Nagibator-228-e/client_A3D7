package alternativa.tanks.engine3d.debug
{
   import alternativa.tanks.vehicles.tanks.ISkinTextureRegistry;
   import alternativa.tanks.vehicles.tanks.TankSkinPart;
   import flash.display.BitmapData;
   
   public class SkinTextureRegistry implements ISkinTextureRegistry
   {
       
      
      public function SkinTextureRegistry()
      {
         super();
      }
      
      public function getTexture(tankPart:TankSkinPart, colormap:BitmapData) : BitmapData
      {
         return null;
      }
      
      public function releaseTexture(tankPart:TankSkinPart, colormap:BitmapData) : void
      {
      }
      
      public function clear() : void
      {
      }
   }
}
