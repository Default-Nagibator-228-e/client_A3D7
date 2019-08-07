package alternativa.physics
{
   import alternativa.math.Vector3;
   
   public class ContactPoint
   {
       
      
      public var pos:Vector3;
      
      public var penetration:Number;
      
      public var feature1:int;
      
      public var feature2:int;
      
      public var normalVel:Number;
      
      public var minSepVel:Number;
      
      public var velByUnitImpulseN:Number;
      
      public var angularInertia1:Number;
      
      public var angularInertia2:Number;
      
      public var r1:Vector3;
      
      public var r2:Vector3;
      
      public var accumImpulseN:Number;
      
      public var satisfied:Boolean;
      
      public function ContactPoint()
      {
         this.pos = new Vector3();
         this.r1 = new Vector3();
         this.r2 = new Vector3();
         super();
      }
      
      public function copyFrom(cp:ContactPoint) : void
      {
         this.pos.vCopy(cp.pos);
         this.penetration = cp.penetration;
         this.feature1 = cp.feature1;
         this.feature2 = cp.feature2;
         this.r1.vCopy(cp.r1);
         this.r2.vCopy(cp.r2);
      }
   }
}
