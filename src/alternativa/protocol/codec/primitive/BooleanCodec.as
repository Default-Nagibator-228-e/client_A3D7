package alternativa.protocol.codec.primitive
{
   import alternativa.protocol.codec.AbstractCodec;
   import alternativa.protocol.codec.NullMap;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class BooleanCodec extends AbstractCodec
   {
       
      
      public function BooleanCodec()
      {
         super();
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         return reader.readByte() != 0;
      }
      
      override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         dest.writeByte(!!Boolean(object)?int(int(1)):int(int(0)));
      }
   }
}
