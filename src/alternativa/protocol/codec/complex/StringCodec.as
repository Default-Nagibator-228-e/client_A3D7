package alternativa.protocol.codec.complex
{
   import alternativa.protocol.codec.AbstractCodec;
   import alternativa.protocol.codec.NullMap;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class StringCodec extends AbstractCodec
   {
       
      
      public function StringCodec()
      {
         super();
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         var length:int = LengthCodec.decodeLength(reader);
         return reader.readUTFBytes(length);
      }
      
      override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeUTFBytes(String(object));
         var length:int = bytes.length;
         LengthCodec.encodeLength(dest,length);
         dest.writeBytes(bytes,0,length);
      }
   }
}
