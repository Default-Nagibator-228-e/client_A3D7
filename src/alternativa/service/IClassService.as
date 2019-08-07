package alternativa.service
{
   import alternativa.register.ClientClass;
   import flash.utils.Dictionary;
   
   public interface IClassService
   {
       
      
      function createClass(param1:String, param2:ClientClass, param3:String, param4:Array, param5:Array) : ClientClass;
      
      function destroyClass(param1:String) : void;
      
      function getClass(param1:String) : ClientClass;
      
      function get classes() : Dictionary;
      
      function get classList() : Array;
   }
}
