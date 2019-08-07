package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MaterialSequence
   {
      
      private static const FRAME_WIDTH_MASK:int = 65535;
      
      private static const FRAME_INDEX_MASK:int = 16711680;
      
      private static const DISPOSE_SOURCE_MASK:int = 1 << 24;
      
      private static const MIRRORED_FRAMES_MASK:int = 1 << 25;
      
      private static const rect:Rectangle = new Rectangle();
      
      private static const point:Point = new Point();
      
      private static var matrix:Matrix = new Matrix(-1,0,0,1);
       
      
      public var materials:Vector.<Material>;
      
      public var referenceCount:int;
      
      public var sourceImage:BitmapData;
      
      private var registry:IMaterialSequenceRegistry;
      
      private var frameData:int;
      
      public function MaterialSequence(registry:IMaterialSequenceRegistry, sourceImage:BitmapData, frameWidth:int, createMirroredFrames:Boolean, disposeSourceBitmap:Boolean, useMipMapping:Boolean, mipMapResolution:Number)
      {
         super();
         this.registry = registry;
         this.sourceImage = sourceImage;
         this.frameData = frameWidth;
         if(createMirroredFrames)
         {
            this.frameData = this.frameData | MIRRORED_FRAMES_MASK;
         }
         if(disposeSourceBitmap)
         {
            this.frameData = this.frameData | DISPOSE_SOURCE_MASK;
         }
         var numFrames:int = sourceImage.width / frameWidth;
         if(createMirroredFrames)
         {
            numFrames = numFrames * 2;
         }
         this.materials = new Vector.<Material>(numFrames,true);
         for(var i:int = 0; i < numFrames; i++)
         {
            this.materials[i] = new TanksTextureMaterial(null,true,true,useMipMapping?int(1):int(0),mipMapResolution);
         }
         TanksTextureMaterial(this.materials[0]).texture = this.getFrameImage(0);
      }
      
      public function get frameWidth() : int
      {
         return this.frameData & FRAME_WIDTH_MASK;
      }
      
      public function get mipMapResolution() : Number
      {
         if(this.materials != null)
         {
            return TextureMaterial(this.materials[0]).resolution;
         }
         return 1;
      }
      
      public function set mipMapResolution(value:Number) : void
      {
         var i:int = 0;
         if(this.materials != null)
         {
            for(i = 0; i < this.materials.length; i++)
            {
               TextureMaterial(this.materials[i]).resolution = value;
            }
         }
      }
      
      public function release() : void
      {
         if(this.referenceCount > 0)
         {
            this.referenceCount--;
            if(this.referenceCount == 0 && this.registry != null)
            {
               this.registry.disposeSequence(this);
            }
         }
      }
      
      public function dispose() : void
      {
         var material:TanksTextureMaterial = null;
         for(var i:int = 0; i < this.materials.length; i++)
         {
            material = this.materials[i] as TanksTextureMaterial;
            if(material != null)
            {
            }
            material.dispose();
         }
         this.disposeSourceIfNecessary();
         this.materials = null;
         this.registry = null;
         this.referenceCount = 0;
      }
      
      public function tick() : Boolean
      {
         var createMirroredFrames:Boolean = false;
         var previousMaterial:TanksTextureMaterial = null;
         var frameIndex:int = (this.frameData & FRAME_INDEX_MASK) >> 16;
         var material:TanksTextureMaterial = TanksTextureMaterial(this.materials[frameIndex]);
         frameIndex++;
         this.frameData = this.frameData & ~FRAME_INDEX_MASK | frameIndex << 16;
         if(frameIndex == this.materials.length)
         {
            this.disposeSourceIfNecessary();
            return true;
         }
         material = TanksTextureMaterial(this.materials[frameIndex]);
         createMirroredFrames = (this.frameData & MIRRORED_FRAMES_MASK) > 0;
         if(createMirroredFrames)
         {
            if((frameIndex & 1) == 1)
            {
               previousMaterial = TanksTextureMaterial(this.materials[frameIndex - 1]);
               material.texture = this.getMirroredImage(previousMaterial.texture);
            }
            else
            {
               material.texture = this.getFrameImage(frameIndex >> 1);
            }
         }
         else
         {
            material.texture = this.getFrameImage(frameIndex);
         }
         return false;
      }
      
      private function disposeSourceIfNecessary() : void
      {
         if((this.frameData & DISPOSE_SOURCE_MASK) > 0)
         {
            this.sourceImage.dispose();
            this.frameData = this.frameData & ~DISPOSE_SOURCE_MASK;
         }
      }
      
      private function getFrameImage(frameIndex:int) : BitmapData
      {
         var frameWidth:int = this.frameData & 65535;
         var bitmapData:BitmapData = new BitmapData(frameWidth,this.sourceImage.height,this.sourceImage.transparent,0);
         rect.x = frameIndex * frameWidth;
         rect.width = frameWidth;
         rect.height = this.sourceImage.height;
         bitmapData.copyPixels(this.sourceImage,rect,point);
         return bitmapData;
      }
      
      private function getMirroredImage(source:BitmapData) : BitmapData
      {
         var result:BitmapData = new BitmapData(source.width,source.height,source.transparent,0);
         matrix.tx = source.width;
         result.draw(source,matrix);
         return result;
      }
   }
}
