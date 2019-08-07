package alternativa.tanks.camera
{
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public interface IFollowCameraController extends ICameraController
   {
       
      
      function get cameraHeight() : Number;
      
      function set cameraHeight(param1:Number) : void;
      
      function deactivate() : void;
      
      function activate() : void;
      
      function setLocked(param1:Boolean) : void;
      
      function initByTarget(param1:Vector3, param2:Vector3) : void;
      
      function set tank(param1:Tank) : void;
      
      function get tank() : Tank;
      
      function addModifier(param1:ICameraStateModifier) : void;
      
      function initCameraComponents() : void;
      
      function getCameraState(param1:Vector3, param2:Vector3, param3:Vector3, param4:Vector3) : void;
   }
}
