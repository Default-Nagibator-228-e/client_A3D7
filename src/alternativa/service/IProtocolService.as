package alternativa.service
{
   import alternativa.protocol.factory.ICodecFactory;
   
   public interface IProtocolService
   {
       
      
      function get codecFactory() : ICodecFactory;
   }
}
