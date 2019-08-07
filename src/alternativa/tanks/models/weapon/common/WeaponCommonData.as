package alternativa.tanks.models.weapon.common
{
   import alternativa.math.Vector3;
   import alternativa.tanks.models.weapon.IWeaponController;
   
   public class WeaponCommonData
   {
       
      
      public var kickback:Number = 0;
      
      public var impactCoeff:Number = 0;
      
      public var impactForce:Number = 0;
      
      public var turretRotationAccel:Number = 0;
      
      public var turretRotationSpeed:Number = 0;
      
      public var muzzles:Vector.<Vector3>;
      
      public var currBarrel:int;
      
      public var weaponController:IWeaponController;
      
      public function WeaponCommonData()
      {
         super();
      }
   }
}
