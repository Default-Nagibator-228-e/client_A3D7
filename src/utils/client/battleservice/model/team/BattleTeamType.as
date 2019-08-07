package utils.client.battleservice.model.team
{
   public class BattleTeamType
   {
      
      public static var NONE:BattleTeamType = new BattleTeamType("NONE");
      
      public static var RED:BattleTeamType = new BattleTeamType("RED");
      
      public static var BLUE:BattleTeamType = new BattleTeamType("BLUE");
       
      
      private var val:String;
      
      public function BattleTeamType(value:String)
      {
         super();
         this.val = value;
      }
      
      public static function getType(value:String) : BattleTeamType
      {
         if(value == "NONE")
         {
            return NONE;
         }
         if(value == "RED")
         {
            return RED;
         }
         if(value == "BLUE")
         {
            return BLUE;
         }
         return null;
      }
      
      public function toString() : String
      {
         return "{BATTLETEAMTYPE} " + this.val;
      }
      
      public function getValue() : String
      {
         return this.val;
      }
   }
}
