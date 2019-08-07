package alternativa.tanks.models.sfx.shoot.railgun
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   
   public interface IRailgunSFXModel
   {
       
      
      function getSFXData(param1:ClientObject) : RailgunShootSFXData;
      
      function createGraphicShotEffect(param1:ClientObject, param2:Vector3, param3:Vector3) : IGraphicEffect;
      
      function createChargeEffect(param1:ClientObject, param2:ClientObject, param3:Vector3, param4:Object3D, param5:int) : IGraphicEffect;
      
      function createSoundShotEffect(param1:ClientObject, param2:ClientObject, param3:Vector3) : ISound3DEffect;
   }
}
