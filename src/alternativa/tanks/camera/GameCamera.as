package alternativa.tanks.camera
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class GameCamera extends Camera3D
   {
      
      private static const m:Matrix3 = new Matrix3();
       
      
      public var pos:Vector3;
      
      public var xAxis:Vector3;
      
      public var yAxis:Vector3;
      
      public var zAxis:Vector3;
	  
	  public var cam:Camera3D;
      
      public function GameCamera()
      {
         this.pos = new Vector3();
         this.xAxis = new Vector3();
         this.yAxis = new Vector3();
         this.zAxis = new Vector3();
         super();
		 cam = this;
         diagramVerticalMargin = 35;
      }
      
      public function calculateAdditionalData() : void
      {
         var cosY:Number = NaN;
         var cosZ:Number = NaN;
         var cosX:Number = Math.cos(rotationX);
         var sinX:Number = Math.sin(rotationX);
         cosY = Math.cos(rotationY);
         var sinY:Number = Math.sin(rotationY);
         cosZ = Math.cos(rotationZ);
         var sinZ:Number = Math.sin(rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         var sinZsinY:Number = sinZ * sinY;
         this.xAxis.x = cosZ * cosY;
         this.yAxis.x = cosZsinY * sinX - sinZ * cosX;
         this.zAxis.x = cosZsinY * cosX + sinZ * sinX;
         this.xAxis.y = sinZ * cosY;
         this.yAxis.y = sinZsinY * sinX + cosZ * cosX;
         this.zAxis.y = sinZsinY * cosX - cosZ * sinX;
         this.xAxis.z = -sinY;
         this.yAxis.z = cosY * sinX;
         this.zAxis.z = cosY * cosX;
         this.pos.x = x;
         this.pos.y = y;
         this.pos.z = z;
      }
      
      public function getGlobalVector(param1:Vector3, param2:Vector3) : void
      {
         m.setRotationMatrix(rotationX,rotationY,rotationZ);
         m.transformVector(param1,param2);
      }
      
      public function updateFov() : void
      {
         fov = CameraFovCalculator.getCameraFov(view.width,view.height);
      }
   }
}
