package alternativa.tanks.sfx
{
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   
   public interface ISpecialEffect
   {
       
      
      function play(param1:int, param2:GameCamera) : Boolean;
      
      function destroy() : void;
      
      function kill() : void;
      
      function get owner() : ClientObject;
   }
}
