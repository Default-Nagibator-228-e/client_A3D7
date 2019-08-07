package alternativa.debug.dump
{
   import alternativa.init.Main;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.resource.IResource;
   import alternativa.resource.ImageResource;
   import alternativa.resource.ResourceStatus;
   import alternativa.service.IResourceService;
   import alternativa.types.Long;
   
   public class ResourceDumper implements IDumper
   {
       
      
      public function ResourceDumper()
      {
         super();
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var resourceRegister:IResourceService = null;
         var p:String = null;
         var batchLoadingHistory:Array = null;
         var i:int = 0;
         var batchId:int = 0;
         var resourcesList:Array = null;
         var j:int = 0;
         var resourceId:Long = null;
         var resourceStatus:ResourceStatus = null;
         var s:String = null;
         var resources:Vector.<IResource> = null;
         var result:String = "\n";
         resourceRegister = Main.osgi.getService(IResourceService) as IResourceService;
         if(params.length > 0)
         {
            p = params[0];
            switch(p)
            {
               case "status":
                  batchLoadingHistory = resourceRegister.batchLoadingHistory;
                  for(i = 0; i < batchLoadingHistory.length; i++)
                  {
                     batchId = batchLoadingHistory[i] as int;
                     result = result + ("\n\n      BatchID: " + batchId + "\n");
                     resourcesList = resourceRegister.resourceLoadingHistory[batchId];
                     for(j = 0; j < resourcesList.length; j++)
                     {
                        resourceId = resourcesList[j];
                        resourceStatus = resourceRegister.resourceStatus[batchId][resourceId] as ResourceStatus;
                        s = "\nid: " + resourceId + "  " + resourceStatus.typeName + " " + resourceStatus.name;
                        s = s + (" status: " + resourceStatus.status);
                        result = result + s;
                     }
                  }
                  break;
               case "images":
                  return this.getImageResourcesDump();
            }
         }
         else
         {
            resources = resourceRegister.resourcesList;
            for(i = 0; i < resources.length; i++)
            {
               result = result + ("   resource id: " + IResource(resources[i]).id + "  " + IResource(resources[i]).name + "\n");
            }
            result = result + "\n";
         }
         return result;
      }
      
      private function getImageResourcesDump() : String
      {
         var s:String = null;
         var count:int = 0;
         var totalSize:int = 0;
         var resource:ImageResource = null;
         var size:int = 0;
         var resourceRegister:IResourceService = IResourceService(Main.osgi.getService(IResourceService));
         var resources:Vector.<IResource> = resourceRegister.resourcesList;
         for(var i:int = 0; i < resources.length; i++)
         {
            resource = resources[i] as ImageResource;
            if(resource != null && resource.data != null)
            {
               count++;
               size = resource.data.width * resource.data.height * 4;
               s = s + ("Image " + count + ": size = " + size + "\n");
               totalSize = totalSize + size;
            }
         }
         s = s + ("Total size: " + totalSize + "\n");
         return s;
      }
      
      public function get dumperName() : String
      {
         return "resource";
      }
   }
}
