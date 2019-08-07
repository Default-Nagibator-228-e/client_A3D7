package alternativa.tanks.models.sfx.healing
{
   import alternativa.tanks.sfx.ISpecialEffect;
   
   public interface IHealingGunEffectListener
   {
       
      
      function onEffectDestroyed(param1:ISpecialEffect) : void;
   }
}
