package alternativa.tanks.models.ctf
{
   import alternativa.math.Vector3;
   import alternativa.tanks.models.tank.TankData;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public interface ICTFModel
   {
       
      
      function isPositionInFlagProximity(param1:Vector3, param2:Number, param3:BattleTeamType) : Boolean;
      
      function isFlagCarrier(param1:TankData) : Boolean;
   }
}
