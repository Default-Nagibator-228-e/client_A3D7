package alternativa.osgi.service.network
{
   public class NetworkService implements INetworkService
   {
       
      
      private var _server:String;
      
      private var _ports:Array;
      
      private var _proxyHost:String;
      
      private var _proxyPort:int;
      
      private var _resourcesPath:String;
      
      private var listeners:Array;
      
      public function NetworkService(server:String, ports:Array, resourcesPath:String, proxyHost:String, proxyPort:int)
      {
         super();
         this.listeners = new Array();
         this._server = server;
         this._ports = ports;
         this._resourcesPath = resourcesPath;
         this._proxyHost = proxyHost;
         this._proxyPort = proxyPort;
      }
      
      public function addEventListener(listener:INetworkListener) : void
      {
         var index:int = this.listeners.indexOf(listener);
         if(index == -1)
         {
            this.listeners.push(listener);
         }
      }
      
      public function removeEventListener(listener:INetworkListener) : void
      {
         var index:int = this.listeners.indexOf(listener);
         if(index != -1)
         {
            this.listeners.splice(index,1);
         }
      }
      
      public function get server() : String
      {
         return this._server;
      }
      
      public function get ports() : Array
      {
         return this._ports;
      }
      
      public function get resourcesPath() : String
      {
         return this._resourcesPath;
      }
      
      public function get proxyHost() : String
      {
         return this._proxyHost;
      }
      
      public function get proxyPort() : int
      {
         return this._proxyPort;
      }
   }
}
