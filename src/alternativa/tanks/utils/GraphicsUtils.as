package alternativa.tanks.utils
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Vector3;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.engine3d.UVFrame;
   import alternativa.tanks.engine3d.debug.TextureMaterialRegistry;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GraphicsUtils
   {
       
      
      public function GraphicsUtils()
      {
         super();
      }
      
      public static function setObjectTransform(object:Object3D, position:Vector3, rotation:Vector3) : void
      {
         object.x = position.x;
         object.y = position.y;
         object.z = position.z;
         object.rotationX = rotation.x;
         object.rotationY = rotation.y;
         object.rotationZ = rotation.z;
      }
      
      public static function getTextureAnimation(param1:TextureMaterialRegistry, param2:BitmapData, frameWith:int, frameHeight:int, maxFrames:int = 0, param6:Boolean = true) : TextureAnimation
      {
         var _loc8_:BitmapData = null;
         var _loc2_:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();
         var _loc3_:int = param2.height;
         var _loc4_:Rectangle = new Rectangle(0,0,frameWith,frameHeight);
         var _loc5_:Point = new Point();
         var _loc6_:int = param2.width / frameWith;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = new BitmapData(frameWith,frameHeight,true,16777215);
			_loc4_.x = frameWith * _loc7_;
			_loc8_.copyPixels(param2, _loc4_, _loc5_);
			var op:TextureMaterial = new TextureMaterial(_loc8_);
            _loc2_.push(op);
            _loc7_++;
         }
		 if (_loc2_.length == 0)
		 {
			 var op:TextureMaterial = new TextureMaterial(param2);
            _loc2_.push(op);
			var op1:TextureMaterial = new TextureMaterial(param2);
            _loc2_.push(op1);
		 }
         var frames:Vector.<UVFrame> = getUVFramesFromTexture(param2,frameWith,frameHeight,maxFrames);
         return new TextureAnimation(_loc2_,frames);
      }
      
      public static function getSquareUVFramesFromTexture(texture:BitmapData, maxFrames:int = 0) : Vector.<UVFrame>
      {
         var size:int = texture.height;
         return getUVFramesFromTexture(texture,size,size,maxFrames);
      }
      
      public static function getUVFramesFromTexture(texture:BitmapData, frameWidth:int, frameHeight:int, maxFrames:int = 0) : Vector.<UVFrame>
      {
         var topY:int = 0;
         var bottomY:int = 0;
         var columIndex:int = 0;
         var leftX:int = 0;
         var rightX:int = 0;
		 if(texture == null)
		 {
			 return null;
		 }
         var textureWidth:int = texture.width;
         var actualFrameWidth:int = Math.min(frameWidth,textureWidth);
         var numColumns:int = textureWidth / actualFrameWidth;
         var textureHeight:int = texture.height;
         var actualFrameHeight:int = Math.min(frameHeight,textureHeight);
         var numRows:int = textureHeight / actualFrameHeight;
         var numFrames:int = numColumns * numRows;
         var _loc20_:int = 0;
         if(maxFrames > 0 && numFrames > maxFrames)
         {
            numFrames = maxFrames;
         }
         var frames:Vector.<UVFrame> = new Vector.<UVFrame>(numFrames);
         var frameIndex:int = 0;
         for(var rowIndex:int = 0; rowIndex < numRows; rowIndex++)
         {
            topY = rowIndex * actualFrameHeight;
            bottomY = topY + actualFrameHeight;
            for(columIndex = 0; columIndex < numColumns; columIndex++)
            {
               leftX = columIndex * actualFrameWidth;
               rightX = leftX + actualFrameWidth;
			   var _loc21_:int = _loc20_ + 1;
               frames[_loc21_] = new UVFrame(leftX / textureWidth,topY / textureHeight,rightX / textureWidth,bottomY / textureHeight);
               if(frameIndex == numFrames)
               {
                  return frames;
               }
            }
         }
         return frames;
      }
   }
}
