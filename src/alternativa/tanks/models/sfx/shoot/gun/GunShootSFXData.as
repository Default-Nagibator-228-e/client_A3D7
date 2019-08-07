package alternativa.tanks.models.sfx.shoot.gun
{
   import alternativa.engine3d.materials.Material;
   import alternativa.tanks.engine3d.TextureAnimation;
   import flash.media.Sound;
   
   public class GunShootSFXData
   {
       
      
      public var shotMaterial:Material;
      
      public var explosionMaterials:Vector.<Material>;
      
      public var shotSound:Sound;
      
      public var explosionSound:Sound;
      
      public var shotData:TextureAnimation;
      
      public var explosionData:TextureAnimation;
      
      public function GunShootSFXData()
      {
         super();
      }
   }
}
