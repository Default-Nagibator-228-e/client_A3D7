package alternativa.protocol.codec
{
   import alternativa.protocol.factory.ICodecFactory;
   import alternativa.protocol.type.Short;
   import alternativa.resource.ResourceInfo;
   import alternativa.types.Long;
   import flash.utils.IDataInput;
   
   public class ResourceCodec extends AbstractCodec
   {
       
      
      private var codecFactory:ICodecFactory;
      
      public function ResourceCodec(codecFactory:ICodecFactory)
      {
         super();
         this.codecFactory = codecFactory;
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         var id:Long = Long(this.codecFactory.getCodec(Long).decode(reader,nullmap,true));
         var version:Long = Long(this.codecFactory.getCodec(Long).decode(reader,nullmap,true));
         var type:int = int(this.codecFactory.getCodec(Short).decode(reader,nullmap,true));
         var isOptional:Boolean = Boolean(this.codecFactory.getCodec(Boolean).decode(reader,nullmap,true));
         return new ResourceInfo(id,version,type,isOptional);
      }
   }
}
