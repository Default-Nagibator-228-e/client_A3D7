package alternativa.tanks.models.weapon.flamethrower
{
   import alternativa.physics.Body;
   import alternativa.tanks.models.weapon.shared.ITargetValidator;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class FlamethrowerTargetValidator implements ITargetValidator
   {
       
      
      public function FlamethrowerTargetValidator()
      {
         super();
      }
      
      public function isValidTarget(targetBody:Body) : Boolean
      {
         var tank:Tank = targetBody as Tank;
         return tank != null && tank.tankData.health > 0;
      }
   }
}
