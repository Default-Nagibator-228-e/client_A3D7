package alternativa.tanks.loader
{
   public interface ILoaderWindowService
   {
       
      
      function setBatchIdForProcess(param1:int, param2:Object) : void;
      
      function showLoaderWindow() : void;
      
      function hideLoaderWindow() : void;
      
      function lockLoaderWindow() : void;
      
      function unlockLoaderWindow() : void;
   }
}
