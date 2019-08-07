package alternativa.tanks.models.battlefield.spectator
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class SpectatorBonusRegionController implements KeyboardHandler
   {
      
      [Inject]
      public static var bonusRegionService:Object;
       
      
      public function SpectatorBonusRegionController()
      {
         super();
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.QUOTE)
         {
         }
      }
      
      public function handleKeyUp(param1:KeyboardEvent) : void
      {
      }
   }
}
