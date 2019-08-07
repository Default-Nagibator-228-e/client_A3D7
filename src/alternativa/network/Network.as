package alternativa.network
{
   import alternativa.init.Main;
   import alternativa.network.INetworkListener;
   import alternativa.network.connecting.ServerConnectionService;
   import alternativa.network.connecting.ServerConnectionServiceImpl;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.service.Logger;
   import alternativa.tanks.bg.IBackgroundService;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class Network extends NetworkService
   {
       
      private var socket:NSocket;
      
      private var keys:Array;
	  
	  public var por:int = 0;
	  
	  public var host:String = "";
      
      private var lastKey:int = 1;
	  
	  private var close:Boolean = false;
	  
	  public var cl:Boolean = true;
	  
	  private var tim:Timer = new Timer(1000, 1);
	  
	  private var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
      
      public function Network()
      {
         this.keys = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9);
		 super();
		 this.socket = new NSocket();
		 this.socket.addEventListener(Event.CLOSE,function():void{});
		 this.socket.addEventListener(IOErrorEvent.IO_ERROR,function():void{});
		 this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function():void{});
		 this.socket.init();
      }
      
		public function connect() : void
		{
			close = false;
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onDataSocket);
			this.socket.addEventListener(Event.CONNECT, this.onConnected);
			this.socket.addEventListener(Event.CLOSE,this.onCloseConnecting);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityError);
			this.socket.connect("127.0.0.1", 4894);//127.0.0.1
		}
      
      public function destroy() : void
      {
		 if (this.cl && this.socket != null)
		 {
			 this.socket.close();
			 this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onDataSocket);
			 this.socket.removeEventListener(Event.CONNECT,this.onConnected);
			 this.socket.removeEventListener(Event.CLOSE,this.onCloseConnecting);
			 this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
			 this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityError);
			 close = true;
		 }
      }
      
      public function addEventListener(listener:INetworkListener) : void
      {
         addListener(listener);
      }
      
      public function removeEventListener(listener:INetworkListener) : void
      {
         removeListener(listener);
      }
      
      public function send(str:String) : void
      {
		 if (!close)
		 {
			 str = this.crypt(str);
			 str = str + DELIM_COMMANDS_SYMBOL;
			 this.socket.writeUTFBytes(str);
			 this.socket.flush();
		 }
      }
      
      private function crypt(request:String) : String
      {
         var key:int = (this.lastKey + 1) % this.keys.length;
         if(key <= 0)
         {
            key = 1;
         }
         this.lastKey = key;
         var _array:Array = request.split("");
         for(var i:int = 0; i < request.length; i++)
         {
            _array[i] = String.fromCharCode(request.charCodeAt(i) + key);
         }
         return key + String(_array).replace(/,/g,"");
      }
      
      private function onConnected(e:Event) : void
      {
		 this.cl = false;
		 alertService.hideAlert();
         Logger.log(1, "Connected to server!");
		 Authorization(Main.osgi.getService(IAuthorization)).init();
      }
	  
	  private function guk(e:Event) : void
      {
		 connect();
		if (this.cl)
		{
			tim.reset();
		}else{
			tim = null;
		}
      }
      
      private function onDataSocket(e:Event) : void
      {
         var bytes:ByteArray = new ByteArray();
         var size:int = this.socket.bytesAvailable;
         this.socket.readBytes(bytes,0,size);
         var data:String = bytes.readUTFBytes(size);
         protocolDecrypt(data);
         bytes.clear();
         this.socket.flush();
      }
      
      private function onCloseConnecting(e:Event) : void
      {
		 this.cl = true;
		 destroy();
         alertService.showAlert("Возникли проблемы с подключением к серверу.\nПодключение произойдёт автоматически.");
		 Game.getInstance.destroy();
		 if (tim != null && !tim.running)
		 {
			 tim.addEventListener(TimerEvent.TIMER_COMPLETE,guk);
			 tim.start();
         }
      }
      
      private function ioError(e:Event) : void
      {
		 this.cl = true;
		 destroy();
         alertService.showAlert("В данный момент ведутся технические работы на данном игровом кластере. Подключение произойдёт автоматически.");
		 Game.getInstance.destroy();
		 if (tim != null && !tim.running)
		 {
			 tim.addEventListener(TimerEvent.TIMER_COMPLETE,guk);
			 tim.start();
         }
      }
      
      private function securityError(e:Event) : void
      {
		 this.cl = true;
		 destroy();
         alertService.showAlert("Не удалось подключиться к серверу. Подключение произойдёт автоматически.");
		 Game.getInstance.destroy();
		 if (tim != null && !tim.running)
		 {
			 tim.addEventListener(TimerEvent.TIMER_COMPLETE,guk);
			 tim.start();
         }
      }
   }
}
