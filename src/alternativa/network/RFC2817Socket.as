package alternativa.network
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   
   public class RFC2817Socket extends Socket
   {
       
      
      private var proxyHost:String = null;
      
      private var host:String = null;
      
      private var proxyPort:int = 0;
      
      private var port:int = 0;
      
      private var deferredEventHandlers:Object;
      
      private var buffer:String;
      
      public function RFC2817Socket(host:String = null, port:int = 0)
      {
         this.deferredEventHandlers = new Object();
         this.buffer = new String();
         super(host,port);
      }
      
      public function setProxyInfo(host:String, port:int) : void
      {
         this.proxyHost = host;
         this.proxyPort = port;
         var deferredSocketDataHandler:Object = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
         var deferredConnectHandler:Object = this.deferredEventHandlers[Event.CONNECT];
         if(deferredSocketDataHandler != null)
         {
            super.removeEventListener(ProgressEvent.SOCKET_DATA,deferredSocketDataHandler.listener,deferredSocketDataHandler.useCapture);
         }
         if(deferredConnectHandler != null)
         {
            super.removeEventListener(Event.CONNECT,deferredConnectHandler.listener,deferredConnectHandler.useCapture);
         }
      }
      
      override public function connect(host:String, port:int) : void
      {
         if(this.proxyHost == null)
         {
            this.redirectConnectEvent();
            this.redirectSocketDataEvent();
            super.connect(host,port);
         }
         else
         {
            this.host = host;
            this.port = port;
            super.addEventListener(Event.CONNECT,this.onConnect);
            super.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
            super.connect(this.proxyHost,this.proxyPort);
         }
      }
      
      private function onConnect(event:Event) : void
      {
         this.writeUTFBytes("CONNECT " + this.host + ":" + this.port + " HTTP/1.1\n\n");
         this.flush();
         this.redirectConnectEvent();
      }
      
      private function onSocketData(event:ProgressEvent) : void
      {
         while(this.bytesAvailable != 0)
         {
            this.buffer = this.buffer + this.readUTFBytes(1);
            if(this.buffer.search(/\r?\n\r?\n$/) != -1)
            {
               this.checkResponse(event);
               break;
            }
         }
      }
      
      private function checkResponse(event:ProgressEvent) : void
      {
         var ioError:IOErrorEvent = null;
         var responseCode:String = this.buffer.substr(this.buffer.indexOf(" ") + 1,3);
         if(responseCode.search(/^2/) == -1)
         {
            ioError = new IOErrorEvent(IOErrorEvent.IO_ERROR);
            ioError.text = "Error connecting to the proxy [" + this.proxyHost + "] on port [" + this.proxyPort + "]: " + this.buffer;
            this.dispatchEvent(ioError);
         }
         else
         {
            this.redirectSocketDataEvent();
            this.dispatchEvent(new Event(Event.CONNECT));
            if(this.bytesAvailable > 0)
            {
               this.dispatchEvent(event);
            }
         }
         this.buffer = null;
      }
      
      private function redirectConnectEvent() : void
      {
         super.removeEventListener(Event.CONNECT,this.onConnect);
         var deferredEventHandler:Object = this.deferredEventHandlers[Event.CONNECT];
         if(deferredEventHandler != null)
         {
            super.addEventListener(Event.CONNECT,deferredEventHandler.listener,deferredEventHandler.useCapture,deferredEventHandler.priority,deferredEventHandler.useWeakReference);
         }
      }
      
      private function redirectSocketDataEvent() : void
      {
         super.removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         var deferredEventHandler:Object = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
         if(deferredEventHandler != null)
         {
            super.addEventListener(ProgressEvent.SOCKET_DATA,deferredEventHandler.listener,deferredEventHandler.useCapture,deferredEventHandler.priority,deferredEventHandler.useWeakReference);
         }
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false) : void
      {
         if(type == Event.CONNECT || type == ProgressEvent.SOCKET_DATA)
         {
            this.deferredEventHandlers[type] = {
               "listener":listener,
               "useCapture":useCapture,
               "priority":priority,
               "useWeakReference":useWeakReference
            };
         }
         else
         {
            super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         }
      }
   }
}
