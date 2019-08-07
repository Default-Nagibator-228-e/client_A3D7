package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class NightGameMode implements IGameMode
   {
       
      
      public function NightGameMode()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         var camera:GameCamera = null;
         camera = viewport.camera;
         camera.directionalLightStrength = 1;
         camera.ambientColor = 1382169;
         camera.deferredLighting = true;
         var light:DirectionalLight = new DirectionalLight(7559484);
         light.useShadowMap = true;
         var x:Number = -1;
         var z:Number = -0.4;
         var matrix:Matrix3 = new Matrix3();
         matrix.setRotationMatrix(x,0,z);
         var toPos:Vector3 = new Vector3(0,1,0);
         toPos.vTransformBy3(matrix);
         light.lookAt(toPos.x,toPos.y,toPos.z);
         light.intensity = 0.3;
         camera.directionalLight = light;
         camera.shadowMap = new ShadowMap(2048,5000,10000,camera,0,0);
         camera.shadowMapStrength = 1;
         camera.shadowMap.bias = 0.5;
         camera.shadowMap.biasMultiplier = 30;
         camera.shadowMap.additionalSpace = 10000;
         camera.shadowMap.alphaThreshold = 0.1;
         camera.useShadowMap = true;
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         var btm:BitmapData = new BitmapData(1,1,false,1382169 + 7559484);
         skybox.colorTransform(skybox.rect,new Bitmap(btm).transform.colorTransform);
         return skybox;
      }
   }
}
