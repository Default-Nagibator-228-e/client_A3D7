package alternativa.tanks.model.payment
{
   public interface IPayment
   {
       
      
      function getData() : void;
      
      function getOperatorsList(param1:String) : void;
      
      function getNumbersList(param1:int) : void;
      
      function get accountId() : String;
      
      function get projectId() : int;
      
      function get formId() : String;
      
      function get currentLocaleCurrency() : String;
   }
}
