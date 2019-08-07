package forms.events
{
   import flash.events.Event;
   
   public class BattleListEvent extends Event
   {
      
      public static const CREATE_GAME:String = "CreateGame";
      
      public static const START_CREATED_GAME:String = "StartCreatedGame";
      
      public static const START_DM_GAME:String = "StartDeathMatch";
      
      public static const START_TDM_RED:String = "StartTeamDeathMatchRED";
      
      public static const START_TDM_BLUE:String = "StartTeamDeathMatchBLUE";
      
      public static const SELECT_BATTLE:String = "SelectBattle";
      
      public static const NEW_BATTLE_NAME_ADDED:String = "NewBattleNameAdded";
       
      
      public function BattleListEvent(type:String)
      {
         super(type,true,false);
      }
   }
}
