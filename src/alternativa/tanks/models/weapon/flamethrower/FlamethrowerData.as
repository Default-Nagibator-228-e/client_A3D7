package alternativa.tanks.models.weapon.flamethrower
{
   import utils.reygazu.anticheat.variables.SecureInt;
   import utils.reygazu.anticheat.variables.SecureNumber;
   
   public class FlamethrowerData
   {
       
      
      public var targetDetectionInterval:SecureInt;
      
      public var range:SecureNumber;
      
      public var coneAngle:SecureNumber;
      
      public var heatingSpeed:SecureInt;
      
      public var coolingSpeed:SecureInt;
      
      public var heatLimit:SecureInt;
      
      public function FlamethrowerData()
      {
         this.targetDetectionInterval = new SecureInt("targetDetectionInterval",0);
         this.range = new SecureNumber("range",0);
         this.coneAngle = new SecureNumber("coneAngle",0);
         this.heatingSpeed = new SecureInt("heatingSpeed",0);
         this.coolingSpeed = new SecureInt("coolingSpeed",0);
         this.heatLimit = new SecureInt("heatLimit",0);
         super();
      }
   }
}
