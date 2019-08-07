package utils.client.battleselect.types
{
   public class BattleClient
   {
       
      
      public var battleId:String;
      
      public var mapId:String;
      
      public var name:String;
      
      public var team:Boolean;
	  
	  public var type:String;
      
      public var countRedPeople:int;
      
      public var countBluePeople:int;
      
      public var countPeople:int;
      
      public var maxPeople:int;
      
      public var minRank:int;
      
      public var maxRank:int;
      
      public var paid:Boolean;
      
      public function BattleClient()
      {
         super();
      }
   }
}
