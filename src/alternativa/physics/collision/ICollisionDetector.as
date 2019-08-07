package alternativa.physics.collision
{
   import alternativa.math.Vector3;
   import alternativa.physics.Contact;
   import alternativa.physics.collision.types.RayIntersection;
   
   public interface ICollisionDetector
   {
       
      
      function getAllContacts(param1:Contact) : Contact;
      
      function intersectRay(param1:Vector3, param2:Vector3, param3:int, param4:Number, param5:IRayCollisionPredicate, param6:RayIntersection) : Boolean;
      
      function intersectRayWithStatic(param1:Vector3, param2:Vector3, param3:int, param4:Number, param5:IRayCollisionPredicate, param6:RayIntersection) : Boolean;
      
      function getContact(param1:CollisionPrimitive, param2:CollisionPrimitive, param3:Contact) : Boolean;
      
      function testCollision(param1:CollisionPrimitive, param2:CollisionPrimitive) : Boolean;
   }
}
