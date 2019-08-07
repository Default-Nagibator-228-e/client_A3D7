package alternativa.tanks.camera
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.math.Vector3;
   
   public class CameraControllerBase
   {
       
      
      protected var camera:GameCamera;
	  
	  protected var cont:Object3DContainer;
      
      public function CameraControllerBase(camera:GameCamera,cont:Object3DContainer=null)
      {
         super();
         if(camera == null)
         {
            throw new ArgumentError("Parameter camera cannot be null");
         }
         this.camera = camera;
		 this.cont = cont
      }
      
      protected function setPosition(position:Vector3) : void
      {
			 if (cont == null)
			 {
				this.camera.x = position.x;
				this.camera.y = position.y;
				this.camera.z = position.z;
			 }else{
				 this.camera.x = position.x;
				 this.camera.y = position.y;
			 }
      }
	  
	  protected function setPosition1(position:Vector3) : void
      {
         this.cont.x = position.x;
         this.cont.y = position.y;
         this.cont.z = position.z;
      }
      
      protected function setOrientation(eulerAngles:Vector3) : void
      {
         this.camera.rotationX = eulerAngles.x;
         this.camera.rotationY = eulerAngles.y;
         this.camera.rotationZ = eulerAngles.z;
      }
      
      protected function setOrientationXYZ(rx:Number, ry:Number, rz:Number) : void
      {
         this.camera.rotationX = rx;
         this.camera.rotationY = ry;
         this.camera.rotationZ = rz;
      }
      
      protected function moveBy(dx:Number, dy:Number, dz:Number) : void
      {
         this.camera.x = this.camera.x + dx;
         this.camera.y = this.camera.y + dy;
         this.camera.z = this.camera.z + dz;
      }
      
      protected function rotateBy(rx:Number, ry:Number, rz:Number) : void
      {
         this.camera.rotationX = this.camera.rotationX + rx;
         this.camera.rotationY = this.camera.rotationY + ry;
         this.camera.rotationZ = this.camera.rotationZ + rz;
      }
      
      public function getCamera() : GameCamera
      {
         return this.camera;
      }
   }
}
