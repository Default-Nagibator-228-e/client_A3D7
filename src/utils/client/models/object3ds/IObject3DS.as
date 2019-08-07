package utils.client.models.object3ds
{
   import utils.client.models.ClientObject;
   import alternativa.resource.Tanks3DSResource;
   
   public interface IObject3DS
   {
       
      
      function getResource3DS(param1:ClientObject) : Tanks3DSResource;
   }
}
