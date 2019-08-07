package alternativa.tanks.models.battlefield
{
   import utils.client.models.ClientObject;
   
   public interface IBattlefieldPlugin
   {
       
      
      function get battlefieldPluginName() : String;
      
      function startBattle() : void;
      
      function restartBattle() : void;
      
      function finishBattle() : void;
      
      function tick(param1:int, param2:int, param3:Number, param4:Number) : void;
      
      function addUser(param1:ClientObject) : void;
      
      function removeUser(param1:ClientObject) : void;
      
      function addUserToField(param1:ClientObject) : void;
      
      function removeUserFromField(param1:ClientObject) : void;
   }
}
