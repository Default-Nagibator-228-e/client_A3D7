package alternativa.resource.factory
{
   import alternativa.resource.LibraryResource;
   import alternativa.resource.Resource;
   
   public class LibraryResourceFactory implements IResourceFactory
   {
       
      
      public function LibraryResourceFactory()
      {
         super();
      }
      
      public function createResource(resourceType:int) : Resource
      {
         return new LibraryResource();
      }
   }
}
