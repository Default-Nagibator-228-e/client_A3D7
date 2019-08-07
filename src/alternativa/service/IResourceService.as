package alternativa.service
{
   import alternativa.resource.IResource;
   import alternativa.resource.factory.IResourceFactory;
   import alternativa.types.Long;
   import flash.utils.Dictionary;
   
   public interface IResourceService
   {
       
      
      function registerResource(param1:IResource) : void;
      
      function unregisterResource(param1:Long) : void;
      
      function getResource(param1:Long) : IResource;
      
      function registerResourceFactory(param1:IResourceFactory, param2:int) : void;
      
      function unregisterResourceFactory(param1:Array) : void;
      
      function getResourceFactory(param1:int) : IResourceFactory;
      
      function get resourcesList() : Vector.<IResource>;
      
      function setResourceStatus(param1:Long, param2:int, param3:String, param4:String, param5:String) : void;
      
      function get batchLoadingHistory() : Array;
      
      function get resourceLoadingHistory() : Dictionary;
      
      function get resourceStatus() : Dictionary;
   }
}
