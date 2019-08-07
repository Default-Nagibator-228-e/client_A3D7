package alternativa.tanks.models.weapon.shared.shot
{
   import utils.reygazu.anticheat.variables.SecureInt;
   import utils.reygazu.anticheat.variables.SecureNumber;
   
   public class ShotData
   {
       
      
      public var autoAimingAngleDown:SecureNumber;
      
      public var autoAimingAngleUp:SecureNumber;
      
      public var numRaysUp:SecureInt;
      
      public var numRaysDown:SecureInt;
      
      public var reloadMsec:SecureInt;
      
      public function ShotData(reloadMsec:int)
      {
         this.autoAimingAngleDown = new SecureNumber("autoAimingAngleDown ",0);
         this.autoAimingAngleUp = new SecureNumber("autoAimingAngleUp ",0);
         this.numRaysUp = new SecureInt("numRaysUp ",0);
         this.numRaysDown = new SecureInt("numRaysDown ",0);
         this.reloadMsec = new SecureInt("reloadMsec");
         super();
         this.reloadMsec.value = reloadMsec;
      }
   }
}
