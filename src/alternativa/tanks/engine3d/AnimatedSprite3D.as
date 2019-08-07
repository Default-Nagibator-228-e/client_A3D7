package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class AnimatedSprite3D extends Sprite3D
   {
       
      
      public var looped:Boolean;
      
      private var uvFrames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var fps:Number;
	  
	  private var h:TextureAnimation;
      
      public var currentFrame:Number = 0;
      
      public function AnimatedSprite3D(param1:Number, param2:Number, param3:Material = null)
      {
         super(param1,param2,param3);
         useShadowMap = false;
         useLight = false;
		 useDepth = false;
         super.softAttenuation = 40;
      }
      
      public function setAnimationData(param1:TextureAnimation) : void
      {
		 h = param1;
         material = param1.material[0];
         this.uvFrames = param1.frames;
         this.fps = param1.fps;
         this.numFrames = this.uvFrames.length;
         this.currentFrame = 0;
         this.setFrameIndex(this.currentFrame);
      }
      
      public function getFps() : Number
      {
         return this.fps;
      }
      
      public function getNumFrames() : int
      {
         return this.numFrames;
      }
      
      public function clear() : void
      {
         this.uvFrames = null;
         material = null;
         this.numFrames = 0;
      }
      
      public function setFrameIndex(param1:int) : void
      {
         var _loc2_:int = param1 % this.numFrames;
         //this.setFrame(this.uvFrames[_loc2_]);
		 if (_loc2_ > h.material.length-1)
		 {
			 this.material = h.material[h.material.length-1];
		 }else{
			this.material = h.material[_loc2_];
		 }
      }
      
      private function setFrame(param1:UVFrame) : void
      {
         if(param1 == null)
         {
            return;
         }
         topLeftU = param1.topLeftU;
         topLeftV = param1.topLeftV;
         bottomRightU = param1.bottomRightU;
         bottomRightV = param1.bottomRightV;
      }
      
      public function update(param1:Number) : void
      {
         this.currentFrame = this.currentFrame + this.fps * param1;
         if(this.currentFrame >= this.numFrames)
         {
            if(this.looped)
            {
               this.currentFrame = this.currentFrame % this.numFrames;
            }
            else
            {
               this.currentFrame = this.numFrames - 1;
            }
         }
         //this.setFrame(this.uvFrames[int(this.currentFrame)]);
		 this.material = h.material[int(this.currentFrame)];
      }
   }
}
