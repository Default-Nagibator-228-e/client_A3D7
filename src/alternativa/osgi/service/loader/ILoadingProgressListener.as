package alternativa.osgi.service.loader
{
   public interface ILoadingProgressListener
   {
       
      
      function processStarted(param1:Object) : void;
      
      function processStoped(param1:Object) : void;
      
      function changeStatus(param1:Object, param2:String) : void;
      
      function changeProgress(param1:Object, param2:Number) : void;
   }
}
