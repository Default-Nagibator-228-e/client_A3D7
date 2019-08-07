package alternativa.tanks.models.weapon.freeze
{
   import alternativa.engine3d.materials.Material;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import flash.media.Sound;
   
   public class FreezeSFXData
   {
       
      
      public var particleMaterials:Vector.<Material>;
      
      public var planeMaterials:Vector.<Material>;
      
      public var shotSound:Sound;
      
      public var colorTransformPoints:Vector.<ColorTransformEntry>;
      
      public var particleSpeed:Number;
      
      public function FreezeSFXData()
      {
         super();
      }
   }
}
