package alternativa.resource.factory
{
   import alternativa.resource.ImageResource;
   import alternativa.resource.Resource;
   
   public class ImageResourceFactory implements IResourceFactory
   {
       
      
      public function ImageResourceFactory()
      {
         super();
      }
      
      public function createResource(resourceType:int) : Resource
      {
         return new ImageResource();
      }
   }
}
