package alternativa.protocol.codec
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public interface ICodec
   {
       
      
      function encode(param1:IDataOutput, param2:Object, param3:NullMap, param4:Boolean) : void;
      
      function decode(param1:IDataInput, param2:NullMap, param3:Boolean) : Object;
   }
}
