package alternativa.tanks.models.battlefield.gui.usertitles
{
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.TankData;
   import flash.geom.Vector3D;
   
   public interface UserTitlesRender
   {
       
      
      function render() : void;
      
      function setBattlefield(param1:IBattleField) : void;
      
      function setLocalData(param1:TankData) : void;
      
      function updateTitle(param1:TankData, param2:Vector3D) : void;
      
      function configurateTitle(param1:TankData) : void;
   }
}
