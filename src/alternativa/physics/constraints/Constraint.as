package alternativa.physics.constraints
{
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.altphysics;
   
   public class Constraint
   {
       
      
      altphysics var satisfied:Boolean;
      
      altphysics var world:PhysicsScene;
      
      public function Constraint()
      {
         super();
      }
      
      public function preProcess(dt:Number) : void
      {
      }
      
      public function apply(dt:Number) : void
      {
      }
   }
}
