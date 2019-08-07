package alternativa.network
{
   import alternativa.init.NetworkActivator;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.protocol.Packet;
   import alternativa.protocol.Protocol;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class CommandSocket implements ICommandSender
   {
      
      private static const CHANNEL:String = "CMDSOCKET";
      
      private static var counter:int;
       
      
      private var socket:Socket;
      
      private var _id:int;
      
      private var packet:Packet;
      
      private var protocol:Protocol;
      
      private var handler:ICommandHandler;
      
      private var dataBuffer:ByteArray;
      
      private var packetCursor:int;
      
      private var host:String;
      
      private var port:uint;
      
      private var proxyHost:String;
      
      private var proxyPort:uint;
      
      public function CommandSocket(host:String, port:uint, packet:Packet, protocol:Protocol, handler:ICommandHandler)
      {
         super();
         this._id = counter++;
         var networkService:INetworkService = NetworkActivator.osgi.getService(INetworkService) as INetworkService;
         this.host = host;
         this.port = port;
         this.proxyHost = networkService.proxyHost;
         this.proxyPort = networkService.proxyPort;
         this.packet = packet;
         this.protocol = protocol;
         this.handler = handler;
         handler.commandSender = this;
         this.dataBuffer = new ByteArray();
         this.packetCursor = 0;
         if(this.proxyHost == "" && this.proxyPort == 0)
         {
            this.socket = new Socket(host,port);
         }
         else
         {
            this.socket = new RFC2817Socket(host,port);
            (this.socket as RFC2817Socket).setProxyInfo(this.proxyHost,this.proxyPort);
         }
         this.socket.timeout = 120000;
         this.configureListeners();
      }
      
      public function connect(host:String, port:int) : void
      {
         this.socket.connect(host,port);
      }
      
      public function sendCommand(command:Object, zipped:Boolean = false) : void
      {
         var encoded:ByteArray = null;
         var dataString:String = null;
         var b:String = null;
         var console:IConsoleService = NetworkActivator.osgi.getService(IConsoleService) as IConsoleService;
         console.writeToConsoleChannel(CHANNEL,"CommandSocket sendCommand");
         try
         {
            encoded = new ByteArray();
            this.protocol.encode(encoded,command);
            encoded.position = 0;
            console.writeToConsoleChannel(CHANNEL,"CommandSocket [id=%1] sendCommand encoded bytes:",this._id);
            dataString = "   ";
            while(encoded.bytesAvailable)
            {
               b = encoded.readUnsignedByte().toString(16).toUpperCase() + " ";
               if(b.length < 3)
               {
                  b = "0" + b;
               }
               dataString = dataString + b;
            }
            console.writeToConsoleChannel(CHANNEL,dataString);
            encoded.position = 0;
            if(zipped)
            {
               this.packet.wrapZippedPacket(encoded,this.socket);
            }
            else
            {
               this.packet.wrapUnzippedPacket(encoded,this.socket);
            }
            this.socket.flush();
         }
         catch(error:Error)
         {
            (NetworkActivator.osgi.getService(ILogService) as ILogService).log(LogLevel.LOG_ERROR,"[CommandSocket] : sendCommand ERROR: " + error.toString());
         }
      }
      
      public function close() : void
      {
         IConsoleService(NetworkActivator.osgi.getService(IConsoleService)).writeToConsoleChannel(CHANNEL,"CLOSE id=%1",this._id);
         this.socket.flush();
         this.socket.close();
         this.handler.close();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      private function configureListeners() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      private function connectHandler(event:Event) : void
      {
         this.handler.open();
         IConsoleService(NetworkActivator.osgi.getService(IConsoleService)).writeToConsoleChannel(CHANNEL,"CommandSocket opened id=%1",this._id);
         ILogService(NetworkActivator.osgi.getService(ILogService)).log(LogLevel.LOG_DEBUG,"CommandSocket opened");
      }
      
      private function closeHandler(event:Event) : void
      {
         this.handler.close();
         IConsoleService(NetworkActivator.osgi.getService(IConsoleService)).writeToConsoleChannel(CHANNEL,"CommandSocket closed id=%1",this._id);
         ILogService(NetworkActivator.osgi.getService(ILogService)).log(LogLevel.LOG_DEBUG,"CommandSocket closed");
      }
      
      private function socketDataHandler(event:ProgressEvent) : void
      {
         var unwrappedData:ByteArray = null;
         var unwrapped:Boolean = false;
         var decodedData:Object = null;
         this.dataBuffer.position = this.dataBuffer.length;
         while(this.socket.bytesAvailable > 0)
         {
            this.dataBuffer.writeByte(this.socket.readByte());
         }
         this.dataBuffer.position = this.packetCursor;
         var readBuffer:Boolean = Boolean(this.dataBuffer.bytesAvailable);
         while(readBuffer)
         {
            unwrappedData = new ByteArray();
            unwrapped = this.packet.unwrapPacket(this.dataBuffer,unwrappedData);
            if(unwrapped)
            {
               unwrappedData.position = 0;
               while(unwrappedData.bytesAvailable)
               {
                  try
                  {
                     decodedData = this.protocol.decode(unwrappedData);
                     this.handler.executeCommand(decodedData);
                  }
                  catch(e:Error)
                  {
                     unwrappedData.clear();
                     continue;
                  }
               }
               if(this.dataBuffer.bytesAvailable == 0)
               {
                  this.dataBuffer.clear();
                  this.packetCursor = 0;
                  readBuffer = false;
               }
               else
               {
                  this.packetCursor = this.dataBuffer.position;
               }
            }
            else
            {
               readBuffer = false;
            }
         }
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         this.handler.disconnect(event.toString());
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         this.handler.disconnect(event.toString());
      }
   }
}
