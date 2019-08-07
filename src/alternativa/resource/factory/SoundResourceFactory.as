package alternativa.resource.factory
{
   import alternativa.resource.Resource;
   import alternativa.resource.SoundResource;
   
   public class SoundResourceFactory implements IResourceFactory
   {
       
      
      public function SoundResourceFactory()
      {
         super();
      }
      
      public function createResource(resourceType:int) : Resource
      {
         return new SoundResource();
      }
   }
}
