package alternativa.tanks.camera
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class ProjectileHitCameraModifier implements ICameraStateModifier
   {
      
      private static var amplitude:ConsoleVarFloat;
      
      private static var swayAmplitude:ConsoleVarFloat;
      
      private static var time1:ConsoleVarFloat;
      
      private static var time2:ConsoleVarFloat;
      
      private static var m:Matrix3 = new Matrix3();
      
      private static var m1:Matrix3 = new Matrix3();
       
      
      private var hitDirection:Vector3;
      
      private var swayAxis:Vector3;
      
      private var power:Number;
      
      private var t:Number;
      
      private var state:int;
      
      public function ProjectileHitCameraModifier()
      {
         this.hitDirection = new Vector3();
         this.swayAxis = new Vector3();
         super();
      }
      
      public static function initVars() : void
      {
         amplitude = new ConsoleVarFloat("hitcam_ampl",50,-1000,1000);
         swayAmplitude = new ConsoleVarFloat("hitcam_sway",-0.05,-10,10);
         time1 = new ConsoleVarFloat("hitcam_time1",0.1,0,10);
         time2 = new ConsoleVarFloat("hitcam_time2",0.5,0,10);
      }
      
      public function init(direction:Vector3, power:Number) : void
      {
         this.hitDirection.vCopy(direction);
         this.power = power;
         this.swayAxis.vReset(this.hitDirection.y,-this.hitDirection.x,0).vNormalize();
         this.t = 0;
         this.state = 0;
      }
      
      public function update(time:int, delta:int, position:Vector3, rotation:Vector3) : Boolean
      {
         var x:Number = NaN;
         var omega:Number = NaN;
         var alpha:Number = NaN;
         this.t = this.t + delta * 0.001;
         switch(this.state)
         {
            case 0:
               if(this.t > time1.value)
               {
                  this.t = time1.value;
                  this.state = 1;
               }
               x = Math.sin(Math.PI / 2 / time1.value * this.t);
               break;
            case 1:
               if(this.t > time2.value)
               {
                  this.t = time2.value;
                  this.state = 2;
               }
               omega = Math.PI / (time2.value - time1.value);
               alpha = Math.PI * time1.value / (time1.value - time2.value);
               x = 0.5 * (1 + Math.cos(omega * this.t + alpha));
               break;
            case 2:
               return false;
         }
         position.vAddScaled(x * amplitude.value * this.power,this.hitDirection);
         m.setRotationMatrix(rotation.x,rotation.y,rotation.z);
         m1.fromAxisAngle(this.swayAxis,x * swayAmplitude.value * this.power);
         m.append(m1);
         m.getEulerAngles(rotation);
         return true;
      }
      
      public function onAddedToController(controller:IFollowCameraController) : void
      {
      }
      
      public function destroy() : void
      {
      }
   }
}
