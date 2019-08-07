package alternativa.tanks.vehicles.tanks
{
   import flash.display.BitmapData;
   
   public interface ISkinTextureRegistry
   {
       
      
      function getTexture(param1:TankSkinPart, param2:BitmapData) : BitmapData;
      
      function releaseTexture(param1:TankSkinPart, param2:BitmapData) : void;
      
      function clear() : void;
   }
}
