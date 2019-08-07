package alternativa.tanks.models.battlefield.spectator
{
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   
   public interface MovementMethod
   {
       
      
      function getDisplacement(param1:UserInput, param2:GameCamera, param3:Number) : Vector3;
   }
}
