package alternativa.protocol.codec
{
   import alternativa.protocol.codec.complex.ArrayCodec;
   import alternativa.protocol.factory.ICodecFactory;
   import alternativa.register.ClassInfo;
   import alternativa.types.Long;
   import flash.utils.IDataInput;
   
   public class ClassCodec extends AbstractCodec
   {
       
      
      private var codecFactory:ICodecFactory;
      
      public function ClassCodec(codecFactory:ICodecFactory)
      {
         super();
         this.codecFactory = codecFactory;
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         var longCodec:ICodec = this.codecFactory.getCodec(Long);
         var id:Long = Long(longCodec.decode(reader,nullmap,true));
         var parentId:Long = Long(longCodec.decode(reader,nullmap,false));
         var name:String = String(this.codecFactory.getCodec(String).decode(reader,nullmap,true));
         var longArrayCodec:ArrayCodec = ArrayCodec(this.codecFactory.getArrayCodec(Long,false));
         var modelsToAdd:Array = longArrayCodec.decode(reader,nullmap,false) as Array;
         var modelsToRemove:Array = longArrayCodec.decode(reader,nullmap,false) as Array;
         return new ClassInfo(id,parentId,name,modelsToAdd,modelsToRemove);
      }
   }
}
