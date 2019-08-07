package alternativa.network
{
   import flash.events.Event;
   
   public interface INetworker
   {
       
      
      function connect(param1:String, param2:int) : void;
      
      function addEventListener(param1:INetworkListener) : void;
      
      function onConnected(param1:Event) : void;
      
      function onDataSocket(param1:Event) : void;
      
      function onCloseConnecting(param1:Event) : void;
      
      function ioError(param1:Event) : void;
      
      function securityError(param1:Event) : void;
   }
}
