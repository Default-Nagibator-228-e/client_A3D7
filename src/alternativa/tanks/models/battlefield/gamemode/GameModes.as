package alternativa.tanks.models.battlefield.gamemode
{
   public class GameModes
   {
      
      public static const DEFAULT:IGameMode = new DefaultGameModel();
      
      public static const NIGHT:IGameMode = new NightGameMode();
       
      
      public function GameModes()
      {
         super();
      }
      
      public static function getGameMode(id:String) : IGameMode
      {
         if(id == "night")
         {
            return NIGHT;
         }
         return DEFAULT;
      }
   }
}
