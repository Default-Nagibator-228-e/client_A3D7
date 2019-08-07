package alternativa.osgi.service.loaderParams
{
   public class LoaderParamsService implements ILoaderParamsService
   {
       
      
      private var loaderParams:Object;
      
      public function LoaderParamsService(loaderParams:Object)
      {
         super();
         this.loaderParams = loaderParams;
      }
      
      public function get params() : Object
      {
         return this.loaderParams;
      }
   }
}
