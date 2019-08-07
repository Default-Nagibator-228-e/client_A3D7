package alternativa.tanks.models.weapon.healing
{
   import utils.reygazu.anticheat.variables.SecureInt;
   import utils.reygazu.anticheat.variables.SecureNumber;
   
   public class HealingGunData
   {
       
      
      public var capacity:SecureInt;
      
      public var chargeRate:SecureInt;
      
      public var dischargeRate:SecureInt;
      
      public var tickPeriod:SecureInt;
      
      public var lockAngle:SecureNumber;
      
      public var lockAngleCos:SecureNumber;
      
      public var maxAngle:SecureNumber;
      
      public var maxAngleCos:SecureNumber;
      
      public var maxRadius:SecureNumber;
      
      public function HealingGunData()
      {
         this.capacity = new SecureInt("capacity isida",0);
         this.chargeRate = new SecureInt("chargeRate isida",0);
         this.dischargeRate = new SecureInt("dischargeRate isida",0);
         this.tickPeriod = new SecureInt("capacity isida",0);
         this.lockAngle = new SecureNumber("lockAngle isida",0);
         this.lockAngleCos = new SecureNumber("lockAngleCos isida",0);
         this.maxAngle = new SecureNumber("maxAngle isida",0);
         this.maxAngleCos = new SecureNumber("maxAngleCos isida",0);
         this.maxRadius = new SecureNumber("maxRadius isida",0);
         super();
      }
   }
}
