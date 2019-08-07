package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class PlaneMuzzleFlashEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const gunDirection:Vector3 = new Vector3();
      
      private static const globalMuzzlePosition:Vector3 = new Vector3();
      
      private static const turretMatrix:Matrix4 = new Matrix4();
       
      
      private var plane:SimplePlane;
      
      private var timetoLive:int;
      
      private var turret:Object3D;
      
      private var localMuzzlePosition:Vector3;
      
      private var container:Scene3DContainer;
	  
	  private var light:OmniLight;
      
      public function PlaneMuzzleFlashEffect(param1:ObjectPool)
      {
         this.localMuzzlePosition = new Vector3();
         super(param1);
         this.plane = new SimplePlane(1,1,0.5,0);
         this.plane.setUVs(0,0,0,1,1,1,1,0);
         //this.plane.shadowMapAlphaThreshold = 2;
         //this.plane.depthMapAlphaThreshold = 2;
		 this.plane.useLight = false;
         this.plane.useShadowMap = false;
		 this.plane.useDepth = false;
		 this.light = new OmniLight(16745512, 500, 1000);
		 //this.light.rotationY = 360;
		 //this.light.rotationX = 360;
		 //this.light.rotationZ = 360;
      }
      
      public function init(param1:Vector3, param2:Object3D, param3:TextureMaterial, param4:int, param5:Number, param6:Number,param7:int=0,param8:int=0) : void
      {
         this.localMuzzlePosition.copyFrom(param1);
         this.turret = param2;
         this.timetoLive = param4;
         this.plane.setMaterialToAllFaces(param3);
         this.plane.width = param5;
		 this.light.attenuationBegin = param7;
		 this.light.attenuationEnd = param8;
         this.plane.length = param6;
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         if(this.timetoLive < 0)
         {
            return false;
         }
         this.timetoLive = this.timetoLive - param1;
		 light.attenuationEnd -= param1;
		 light.attenuationBegin -= param1;
         turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         turretMatrix.transformVector(this.localMuzzlePosition,globalMuzzlePosition);
         turretMatrix.getAxis(1,gunDirection);
         SFXUtils.alignObjectPlaneToView(this.plane, globalMuzzlePosition, gunDirection, param2.pos);
		 this.light.x = globalMuzzlePosition.x;
		 this.light.y = globalMuzzlePosition.y;
		 this.light.z = globalMuzzlePosition.z;
		 this.light.rotationX = gunDirection.x;
		 this.light.rotationY = gunDirection.y;
		 this.light.rotationZ = gunDirection.z;
         return true;
      }
      
      public function destroy() : void
      {
         this.container.removeChild(this.plane);
		 this.container.removeChild(this.light);
         this.container = null;
         this.turret = null;
      }
      
      public function kill() : void
      {
         this.timetoLive = -1;
      }
      
      public function addToContainer(param1:Scene3DContainer) : void
      {
         this.container = param1;
         param1.addChild(this.plane);
		 param1.addChild(this.light);
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
   }
}
