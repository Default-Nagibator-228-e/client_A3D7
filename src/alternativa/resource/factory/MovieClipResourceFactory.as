package alternativa.resource.factory
{
   import alternativa.resource.MovieClipResource;
   import alternativa.resource.Resource;
   
   public class MovieClipResourceFactory implements IResourceFactory
   {
       
      
      public function MovieClipResourceFactory()
      {
         super();
      }
      
      public function createResource(resourceType:int) : Resource
      {
         return new MovieClipResource();
      }
   }
}
