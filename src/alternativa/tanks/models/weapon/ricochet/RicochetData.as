package alternativa.tanks.models.weapon.ricochet
{
   public class RicochetData
   {
       
      
      public var shotRadius:Number;
      
      public var shotSpeed:Number;
      
      public var energyCapacity:int;
      
      public var energyPerShot:int;
      
      public var energyRechargeSpeed:Number;
      
      public var shotDistance:Number;
      
      public function RicochetData(shotRadius:Number, shotSpeed:Number, energyCapacity:int, energyPerShot:int, energyRechargeSpeed:int, shotDistance:Number)
      {
         super();
         this.shotRadius = shotRadius;
         this.shotSpeed = shotSpeed;
         this.energyCapacity = energyCapacity;
         this.energyPerShot = energyPerShot;
         this.energyRechargeSpeed = energyRechargeSpeed;
         this.shotDistance = shotDistance;
      }
   }
}
