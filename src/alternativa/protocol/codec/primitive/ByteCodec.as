package alternativa.protocol.codec.primitive
{
   import alternativa.protocol.codec.AbstractCodec;
   import alternativa.protocol.codec.NullMap;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ByteCodec extends AbstractCodec
   {
       
      
      public function ByteCodec()
      {
         super();
         nullValue = int.MIN_VALUE;
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         return reader.readByte();
      }
      
      override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         dest.writeByte(int(object));
      }
   }
}
