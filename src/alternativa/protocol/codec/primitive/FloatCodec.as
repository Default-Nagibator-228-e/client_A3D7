package alternativa.protocol.codec.primitive
{
   import alternativa.protocol.codec.AbstractCodec;
   import alternativa.protocol.codec.NullMap;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class FloatCodec extends AbstractCodec
   {
       
      
      public function FloatCodec()
      {
         super();
         nullValue = Number.NEGATIVE_INFINITY;
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         return reader.readFloat();
      }
      
      override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         dest.writeFloat(Number(object));
      }
   }
}
