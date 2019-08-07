package alternativa.tanks.service.money
{
   public interface IMoneyService
   {
       
      
      function addListener(param1:IMoneyListener) : void;
      
      function removeListener(param1:IMoneyListener) : void;
      
      function get crystal() : int;
   }
}
