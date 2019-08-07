package alternativa.tanks.models.battlefield.gui.statistics.table
{
   public class StatisticsData
   {
       
      
      public var label:Object = null;
      
      public var icon:Object = null;
      
      public var id:Object;
      
      public var playerRank:int = 0;
      
      public var playerName:String = "";
      
      public var kills:int = 0;
      
      public var deaths:int = 0;
      
      public var score:int = 0;
      
      public var reward:int = -1;
	  
	  public var zt:int = -1;
      
      public var type:int;
      
      public var self:Boolean;
      
      public function StatisticsData()
      {
         super();
      }
   }
}
