package alternativa.tanks.engine3d.debug
{
   import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
   import alternativa.tanks.engine3d.MaterialSequence;
   import alternativa.tanks.engine3d.MaterialType;
   import flash.display.BitmapData;
   
   public class MaterialSequenceRegistry implements IMaterialSequenceRegistry
   {
       
      
      private var sequence:MaterialSequence;
      
      public function MaterialSequenceRegistry()
      {
         super();
         var bmp:DebugTexture = new DebugTexture(24,6,8355711,6710784);
         this.sequence = new MaterialSequence(null,bmp,bmp.width,false,false,false,0);
      }
      
      public function set timerInterval(value:int) : void
      {
      }
      
      public function get useMipMapping() : Boolean
      {
         return false;
      }
      
      public function set useMipMapping(value:Boolean) : void
      {
      }
      
      public function getSequence(materialType:MaterialType, sourceImage:BitmapData, frameWidth:int, mipMapResolution:Number, disposeSourceImage:Boolean = false, createMirroredFrames:Boolean = false) : MaterialSequence
      {
         return this.sequence;
      }
      
      public function getSquareSequence(materialType:MaterialType, sourceImage:BitmapData, mipMapResolution:Number, disposeSourceImage:Boolean = false, createMirroredFrames:Boolean = false) : MaterialSequence
      {
         return this.sequence;
      }
      
      public function clear() : void
      {
      }
      
      public function getDump() : String
      {
         return "";
      }
      
      public function disposeSequence(sequence:MaterialSequence) : void
      {
      }
   }
}
