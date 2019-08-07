package alternativa.tanks.models.battlefield.logic.updaters
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class LocalHullTransformUpdater implements HullTransformUpdater
   {
      
      private static const position:Vector3 = new Vector3();
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const m3:Matrix3 = new Matrix3();
       
      
      public var tank:Tank;
      
      public function LocalHullTransformUpdater(param1:Tank)
      {
         super();
         this.tank = param1;
      }
      
      public function reset() : void
      {
      }
      
      public function update(param1:Number) : void
      {
         this.tank.interpolatedOrientation.toMatrix3(m3);
         position.vCopy(this.tank.skinCenterOffset);
         position.vTransformBy3(m3);
         position.vAdd(this.tank.interpolatedPosition);
         this.tank.interpolatedOrientation.getEulerAngles(eulerAngles);
         this.tank.skin.updateHullTransform(position,eulerAngles);
      }
   }
}
