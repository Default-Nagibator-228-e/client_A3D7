package utils.client.models
{
   import utils.client.models.ClientObject;
   import alternativa.protocol.codec.NullMap;
   import alternativa.protocol.factory.ICodecFactory;
   import flash.utils.IDataInput;
   
   public interface IModel
   {
       
      
      function _initObject(param1:ClientObject, param2:Object) : void;
      
      function invoke(param1:ClientObject, param2:String, param3:ICodecFactory, param4:IDataInput, param5:NullMap) : void;
      
      function get id() : String;
      
      function get interfaces() : Vector.<Class>;
   }
}
