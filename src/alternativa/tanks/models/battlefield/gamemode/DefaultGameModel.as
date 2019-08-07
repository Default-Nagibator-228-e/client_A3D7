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
   
   public class DefaultGameModel implements IGameMode
   {
       
      
      public function DefaultGameModel()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         var camera:GameCamera = null;
         camera = viewport.camera;
         camera.directionalLightStrength = 1;
         camera.ambientColor = 0x001829;
         camera.deferredLighting = true;
		 camera.deferredLightingStrength = 1;
		 //camera.shadowsDistanceMultiplier = 4200;
         var light:DirectionalLight = new DirectionalLight(0xFCE3A9);
         light.useShadowMap = true;
		 //light.y = 80000;
		 //light.x = 50;
         var x:Number = -1;
         var z:Number = -3.5;//-0.5;
         var matrix:Matrix3 = new Matrix3();
         matrix.setRotationMatrix(x,0,z);
         var toPos:Vector3 = new Vector3(0,1,0);
         toPos.vTransformBy3(matrix);
         light.lookAt(toPos.x,toPos.y,toPos.z);
         light.intensity = 0.5;
		 camera.shadowsStrength = 0;
         camera.directionalLight = light;
         camera.shadowMap = new ShadowMap(2048, -5000, 30000, camera, 0, 200000);
		 camera.shadowMap.bias = 1;
		 camera.shadowMap.biasMultiplier = 30;
         //camera.shadowMap.bias = -25;
         //camera.shadowMap.biasMultiplier = -10;
		 //camera.softAttenuation = 130;
         //camera.shadowMap.additionalSpace = 10000;
		 camera.shadowMapStrength = 0.5;
		 camera.ssao = false;
		 //camera.ssaoAlpha = 1;
		 camera.ssaoColor = 0; 
		 //camera.ssaoColor = 16777215;
         //camera.shadowMap.alphaThreshold = 0.99;
         camera.useShadowMap = true;
		 //camera.useLight = true;
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         return skybox;
      }
   }
}
