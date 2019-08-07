package utils.client.models
{
   import alternativa.resource.IResource;
   import alternativa.types.Long;
   
   public interface IResourceLoadListener
   {
       
      
      function resourceLoaded(param1:IResource) : void;
      
      function resourceUnloaded(param1:Long) : void;
   }
}
