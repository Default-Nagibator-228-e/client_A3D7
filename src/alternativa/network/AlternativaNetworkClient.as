package alternativa.network
{
   import alternativa.init.NetworkActivator;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.protocol.Packet;
   import alternativa.protocol.Protocol;
   
   public class AlternativaNetworkClient
   {
      
      private static const CHANNEL:String = "NETCLIENT";
       
      
      private var host:String;
      
      private var protocol:Protocol;
      
      private var packet:Packet;
      
      public function AlternativaNetworkClient(host:String, protocol:Protocol)
      {
         super();
         this.host = host;
         this.protocol = protocol;
         this.packet = new Packet();
      }
      
      public function newConnection(port:int, handler:ICommandHandler) : CommandSocket
      {
         var console:IConsoleService = NetworkActivator.osgi.getService(IConsoleService) as IConsoleService;
         console.writeToConsoleChannel(CHANNEL,"New connection: host=%1, port=%2",this.host,port);
         var s:CommandSocket = new CommandSocket(this.host,port,this.packet,this.protocol,handler);
         s.connect(this.host,port);
         return s;
      }
   }
}
