package alternativa.tanks.models.battlefield.mine
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.console.ConsoleVarInt;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.ICameraStateModifier;
   import alternativa.tanks.camera.IFollowCameraController;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.utils.getTimer;
   
   public class MineExplosionCameraEffect implements ICameraStateModifier
   {
      
      private static var amplitude:ConsoleVarFloat;
      
      private static var yawAmplitude:ConsoleVarFloat;
      
      private static var rollAmplitude:ConsoleVarFloat;
      
      private static var duration:ConsoleVarInt;
      
      private static var m1:Matrix3 = new Matrix3();
      
      private static var m2:Matrix3 = new Matrix3();
      
      private static var axis:Vector3 = new Vector3();
       
      
      private var sign:int;
      
      private var time:int;
      
      private var tank:Tank;
      
      public function MineExplosionCameraEffect()
      {
         super();
      }
      
      public static function initVars() : void
      {
         amplitude = new ConsoleVarFloat("minecam_ampl",0,-10000,10000);
         yawAmplitude = new ConsoleVarFloat("minecam_yaw",-0.02,-10,10);
         rollAmplitude = new ConsoleVarFloat("minecam_roll",0.03,-10,10);
         duration = new ConsoleVarInt("minecam_time",800,0,10000);
      }
      
      public function update(time:int, delta:int, position:Vector3, rotation:Vector3) : Boolean
      {
         if(time - this.time > duration.value)
         {
            return false;
         }
         this.sign = -this.sign;
         var f:Number = 0.5 * (1 + Math.cos((time - this.time) * Math.PI / duration.value));
         position.z = position.z + amplitude.value * this.sign * f;
         m1.setRotationMatrix(rotation.x,rotation.y,rotation.z);
         axis.vDiff(this.tank.state.pos,position).vNormalize();
         m2.fromAxisAngle(axis,rollAmplitude.value * this.sign * f);
         m1.append(m2);
         m2.fromAxisAngle(Vector3.Z_AXIS,yawAmplitude.value * this.sign * f);
         m1.append(m2);
         m1.getEulerAngles(rotation);
         return true;
      }
      
      public function onAddedToController(controller:IFollowCameraController) : void
      {
         this.time = getTimer();
         this.sign = 1;
         this.tank = controller.tank;
      }
      
      public function destroy() : void
      {
      }
   }
}
