package alternativa.physics.collision.types
{
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   
   public class RayIntersection
   {
       
      
      public var primitive:CollisionPrimitive;
      
      public var pos:Vector3;
      
      public var normal:Vector3;
      
      public var t:Number = 0;
      
      public function RayIntersection()
      {
         this.pos = new Vector3();
         this.normal = new Vector3();
         super();
      }
      
      public function copy(source:RayIntersection) : void
      {
         this.primitive = source.primitive;
         this.pos.vCopy(source.pos);
         this.normal.vCopy(source.normal);
         this.t = source.t;
      }
   }
}
