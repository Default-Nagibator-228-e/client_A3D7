package alternativa.protocol.factory
{
   import alternativa.protocol.codec.ICodec;
   
   public interface ICodecFactory
   {
       
      
      function registerCodec(param1:Class, param2:ICodec) : void;
      
      function unregisterCodec(param1:Class) : void;
      
      function getCodec(param1:Class) : ICodec;
      
      function getArrayCodec(param1:Class, param2:Boolean = true, param3:int = 1) : ICodec;
   }
}
