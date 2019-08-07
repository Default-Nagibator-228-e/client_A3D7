package alternativa.osgi.service.network
{
   public interface INetworkService
   {
       
      
      function addEventListener(param1:INetworkListener) : void;
      
      function removeEventListener(param1:INetworkListener) : void;
      
      function get server() : String;
      
      function get ports() : Array;
      
      function get resourcesPath() : String;
      
      function get proxyHost() : String;
      
      function get proxyPort() : int;
   }
}
