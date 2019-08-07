package utils.client.models.tank
{
   import utils.client.commons.types.TankSpecification;
   import utils.client.commons.types.TankState;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class ClientTank
   {
       
      
      public var self:Boolean;
      
      public var teamType:BattleTeamType;
      
      public var incarnationId:int;
      
      public var tankSpecification:TankSpecification;
      
      public var tankState:TankState;
      
      public var spawnState:TankSpawnState;
      
      public var health:int;
      
      public function ClientTank()
      {
         super();
      }
   }
}
