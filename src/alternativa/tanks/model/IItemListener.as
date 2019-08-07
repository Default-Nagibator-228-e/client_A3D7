package alternativa.tanks.model
{
   import utils.client.models.ClientObject;
   
   public interface IItemListener
   {
       
      
      function itemLoaded(param1:ClientObject, param2:ItemParams) : void;
   }
}
