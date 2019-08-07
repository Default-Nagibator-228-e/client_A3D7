package alternativa.tanks.models.battlefield.gui
{
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public interface IBattlefieldGUI
   {
       
      
      function logUserAction(param1:String, param2:String, param3:String = null) : void;
      
      function ctfShowFlagAtBase(param1:BattleTeamType) : void;
      
      function ctfShowFlagCarried(param1:BattleTeamType) : void;
      
      function ctfShowFlagDropped(param1:BattleTeamType) : void;
      
      function updateHealthIndicator(param1:Number) : void;
      
      function updateWeaponIndicator(param1:Number) : void;
      
      function showPauseIndicator(param1:Boolean) : void;
      
      function setPauseTimeout(param1:int) : void;
   }
}
