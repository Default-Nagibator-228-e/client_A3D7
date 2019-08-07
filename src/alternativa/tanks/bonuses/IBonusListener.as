package alternativa.tanks.bonuses
{
   public interface IBonusListener
   {
       
      
      function onBonusDropped(param1:IBonus) : void;
      
      function onTankCollision(param1:IBonus) : void;
   }
}
