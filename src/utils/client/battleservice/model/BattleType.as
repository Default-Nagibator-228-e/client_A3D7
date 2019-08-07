package utils.client.battleservice.model
{
   public class BattleType
   {
      
      public static var CTF:BattleType = new BattleType();
      
      public static var TDM:BattleType = new BattleType();
      
      public static var DM:BattleType = new BattleType();
       
      
      public function BattleType()
      {
         super();
      }
      
      public static function getType(value:String) : BattleType
      {
         if(value == "DM")
         {
            return DM;
         }
         if(value == "TDM")
         {
            return TDM;
         }
         if(value == "CTF")
         {
            return CTF;
         }
         return null;
      }
   }
}
