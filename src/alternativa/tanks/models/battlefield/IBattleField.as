package alternativa.tanks.models.battlefield
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.ICameraStateModifier;
   import alternativa.tanks.models.battlefield.decals.RotationState;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public interface IBattleField
   {
       
      
      function addDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null) : void;
      
      function getBattlefieldData() : BattlefieldData;
      
      function addTank(param1:TankData) : void;
      
      function removeTank(param1:TankData) : void;
      
      function addGraphicEffect(param1:IGraphicEffect) : void;
      
      function addSound3DEffect(param1:ISound3DEffect) : void;
      
      function setLocalUser(param1:ClientObject) : void;
      
      function initFlyCamera(param1:Vector3, param2:Vector3) : void;
      
      function initFollowCamera(param1:Vector3, param2:Vector3) : void;
      
      function setCameraTarget(param1:Tank) : void;
      
      function removeTankFromField(param1:TankData) : void;
      
      function showSuicideIndicator(param1:int) : void;
      
      function hideSuicideIndicator() : void;
      
      function getRespawnInvulnerabilityPeriod() : int;
      
      function printDebugValue(param1:String, param2:String) : void;
      
      function addPlugin(param1:IBattlefieldPlugin) : void;
      
      function removePlugin(param1:IBattlefieldPlugin) : void;
      
      function get soundManager() : ISoundManager;
      
      function tankHit(param1:TankData, param2:Vector3, param3:Number) : void;
      
      function addFollowCameraModifier(param1:ICameraStateModifier) : void;
   }
}
