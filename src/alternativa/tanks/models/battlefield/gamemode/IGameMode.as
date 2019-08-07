package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.BitmapData;
   
   public interface IGameMode
   {
       
      
      function applyChanges(param1:BattleView3D) : void;
      
      function applyColorchangesToSkybox(param1:BitmapData) : BitmapData;
   }
}
