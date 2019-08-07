package alternativa.network.connecting
{
   import alternativa.init.Main;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.Socket;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   
   public class ServerConnectionServiceImpl implements ServerConnectionService
   {
       
      
      public var loader:URLLoader;
      
      public var networker:Network;
      
      public function ServerConnectionServiceImpl()
      {
         super();
		 if (Network(Main.osgi.getService(INetworker)) == null)
		 {
			this.networker = new Network();
			this.networker.connect();
		 }else{
			this.networker = Network(Main.osgi.getService(INetworker));
		 }
         Main.osgi.registerService(INetworker,this.networker);
      }
	  
	  public function connect(param1:String) : void
	  {
	  }
   }
}
