package alternativa.tanks.model.payment
{
   public interface IPaymentListener
   {
       
      
      function setInitData(param1:Array, param2:Array, param3:String, param4:int, param5:String) : void;
      
      function setOperators(param1:String, param2:Array) : void;
      
      function setNumbers(param1:int, param2:Array) : void;
   }
}
