package utils.client.battleselect.types
{
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class UserInfoClient
   {
       
      
      public var id:String;
      
      public var type:BattleTeamType;
      
      public var name:String;
      
      public var rank:int;
      
      public var kills:int;
      
      public function UserInfoClient()
      {
         super();
      }
   }
}
