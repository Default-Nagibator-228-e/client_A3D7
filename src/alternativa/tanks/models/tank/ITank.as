package alternativa.tanks.models.tank
{
   import utils.client.models.ClientObject;
   import flash.geom.Vector3D;
   
   public interface ITank
   {
       
      
      function getTankData(param1:ClientObject) : TankData;
      
      function update(param1:TankData, param2:int, param3:int, param4:Number, param5:Number, param6:Vector3D) : void;
      
      function disableUserControls(param1:Boolean) : void;
      
      function enableUserControls() : void;
      
      function stop(param1:TankData) : void;
      
      function resetIdleTimer(param1:Boolean) : void;
      
      function get userControlsEnabled() : Boolean;
      
      function readLocalTankPosition(param1:Vector3D) : void;
      
      function effectStarted(param1:ClientObject, param2:int, param3:int) : void;
      
      function effectStopped(param1:ClientObject, param2:int) : void;
   }
}
