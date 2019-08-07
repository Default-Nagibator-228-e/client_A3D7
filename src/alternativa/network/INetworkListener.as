package alternativa.network
{
   import alternativa.network.commands.Command;
   
   public interface INetworkListener
   {
       
      
      function onData(param1:Command) : void;
   }
}
