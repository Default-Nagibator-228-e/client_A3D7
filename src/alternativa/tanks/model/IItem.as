package alternativa.tanks.model
{
   import utils.client.models.ClientObject;
   
   public interface IItem
   {
       
      
      function getParams(param1:ClientObject) : ItemParams;
   }
}
