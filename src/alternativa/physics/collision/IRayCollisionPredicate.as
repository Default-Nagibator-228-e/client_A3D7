package alternativa.physics.collision
{
   import alternativa.physics.Body;
   
   public interface IRayCollisionPredicate
   {
       
      
      function considerBody(param1:Body) : Boolean;
   }
}
