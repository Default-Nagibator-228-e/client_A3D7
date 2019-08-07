package alternativa.register
{
   import alternativa.init.Main;
   import alternativa.resource.IResource;
   import alternativa.resource.ResourceStatus;
   import alternativa.resource.factory.IResourceFactory;
   import alternativa.service.IResourceService;
   import alternativa.types.Long;
   import flash.utils.Dictionary;
   
   public class ResourceRegister implements IResourceService
   {
       
      
      private var resourceFactories:Dictionary;
      
      private var resources:Dictionary;
      
      private var _resourcesList:Vector.<IResource>;
      
      public var _resourceStatus:Dictionary;
      
      public var _batchLoadingHistory:Array;
      
      public var _resourceLoadingHistory:Dictionary;
      
      public function ResourceRegister()
      {
         super();
         this.resources = new Dictionary();
         this.resourceFactories = new Dictionary();
         this._resourcesList = new Vector.<IResource>();
         this._resourceStatus = new Dictionary();
         this._batchLoadingHistory = new Array();
         this._resourceLoadingHistory = new Dictionary();
      }
      
      public function registerResource(resource:IResource) : void
      {
         this.resources[resource.id] = resource;
         this._resourcesList.push(resource);
         Main.writeVarsToConsoleChannel("RESOURCE","Ресурс %1 id: %2 зарегистрирован",resource.name,resource.id);
      }
      
      public function unregisterResource(id:Long) : void
      {
         Main.writeVarsToConsoleChannel("RESOURCE","Регистрация ресурса " + IResource(this.resources[id]).name + " id:" + id + " удалена",6710886);
         this._resourcesList.splice(this._resourcesList.indexOf(this.resources[id]),1);
         delete this.resources[id];
      }
      
      public function getResource(id:Long) : IResource
      {
         if(this.resources[id] == undefined)
         {
            return null;
         }
         return this.resources[id];
      }
      
      public function registerResourceFactory(resourceFactory:IResourceFactory, resourceType:int) : void
      {
         this.resourceFactories[resourceType] = resourceFactory;
         Main.writeVarsToConsoleChannel("RESOURCE","Loader for resource " + resourceFactory + " registered",6710886);
      }
      
      public function unregisterResourceFactory(resourceTypes:Array) : void
      {
         var i:int = 0;
         for each(i in resourceTypes)
         {
            delete this.resourceFactories[i];
         }
      }
      
      public function setResourceStatus(id:Long, batchId:int, typeName:String, name:String, status:String) : void
      {
         var r:ResourceStatus = null;
         Main.writeVarsToConsoleChannel("RESOURCE","setResourceStatus id: %1, batchId: %2, typeName: %3, name: %4, status: %5",id,batchId,typeName,name,status);
         if(this._batchLoadingHistory.indexOf(batchId) == -1)
         {
            this._batchLoadingHistory.push(batchId);
         }
         if(this._resourceLoadingHistory[batchId] == null)
         {
            this._resourceLoadingHistory[batchId] = new Array();
         }
         if((this._resourceLoadingHistory[batchId] as Array).indexOf(id) == -1)
         {
            (this._resourceLoadingHistory[batchId] as Array).push(id);
         }
         if(this._resourceStatus[batchId] == null)
         {
            this._resourceStatus[batchId] = new Dictionary();
         }
         if((this._resourceStatus[batchId] as Dictionary)[id] == null)
         {
            (this._resourceStatus[batchId] as Dictionary)[id] = new ResourceStatus(id,batchId,typeName,name,status);
         }
         else
         {
            r = (this._resourceStatus[batchId] as Dictionary)[id] as ResourceStatus;
            r.id = id;
            r.batchId = batchId;
            r.typeName = typeName;
            r.name = name;
            r.status = status;
         }
         Main.writeVarsToConsoleChannel("RESOURCE","     resourceStatus[batchId][id]: " + r);
      }
      
      public function get batchLoadingHistory() : Array
      {
         return this._batchLoadingHistory;
      }
      
      public function get resourceLoadingHistory() : Dictionary
      {
         return this._resourceLoadingHistory;
      }
      
      public function get resourceStatus() : Dictionary
      {
         return this._resourceStatus;
      }
      
      public function getResourceFactory(resourceType:int) : IResourceFactory
      {
         return this.resourceFactories[resourceType];
      }
      
      public function get resourcesList() : Vector.<IResource>
      {
         return this._resourcesList;
      }
   }
}
