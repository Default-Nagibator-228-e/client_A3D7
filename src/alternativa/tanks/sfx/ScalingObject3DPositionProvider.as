package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.colliders.BoxBoxCollider;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class ScalingObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
       
      
      private var initialPosition:Vector3;
      
      private var velocity:Vector3;
      
      private var scaleVelocity:Number;
	  
	  private var uy:Boolean;
      
      public function ScalingObject3DPositionProvider(param1:ObjectPool)
      {
         this.initialPosition = new Vector3();
         this.velocity = new Vector3();
         super(param1);
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = this.initialPosition.x;
         param1.y = this.initialPosition.y;
         param1.z = this.initialPosition.z;
         param1.scaleX = 1;
         param1.scaleY = 1;
         param1.scaleZ = 1;
      }
      
      public function init(param1:Vector3, param2:Vector3, param3:Number,param4:Boolean = true) : void
      {
         this.initialPosition.vCopy(param1);
         this.velocity.vCopy(param2);
         this.scaleVelocity = param3;
		 uy = param4;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:GameCamera, param3:int) : void
      {
         var _loc4_:Number = 0.001 * param3;
		 if (uy)
		 {
			 param1.x = param1.x + this.velocity.x * _loc4_;
			 param1.y = param1.y + this.velocity.y * _loc4_;
			 param1.z = param1.z + this.velocity.z * _loc4_;
			 param1.scaleX = param1.scaleX + this.scaleVelocity;
			 param1.scaleY = param1.scaleY + this.scaleVelocity;
			 param1.scaleZ = param1.scaleZ + this.scaleVelocity;
		 }else{
			param1.z += this.velocity.z;
		 }
      }
      
      public function destroy() : void
      {
      }
   }
}
