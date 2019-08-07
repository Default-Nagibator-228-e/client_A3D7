package utils.client.models
{
   import utils.client.models.ClientObject;
   
   public interface IObjectLoadListener
   {
       
      
      function objectLoaded(param1:ClientObject) : void;
      
      function objectUnloaded(param1:ClientObject) : void;
   }
}
