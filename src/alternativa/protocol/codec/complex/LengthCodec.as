package alternativa.protocol.codec.complex
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class LengthCodec
   {
       
      
      public function LengthCodec()
      {
         super();
      }
      
      public static function encodeLength(dest:IDataOutput, length:int) : void
      {
         var tmp:Number = NaN;
         if(length < 0)
         {
            throw new Error("Length is incorrect (" + length + ")");
         }
         if(length < 128)
         {
            dest.writeByte(int(length & 127));
         }
         else if(length < 16384)
         {
            tmp = (length & 16383) + 32768;
            dest.writeByte(int((tmp & 65280) >> 8));
            dest.writeByte(int(tmp & 255));
         }
         else if(length < 4194304)
         {
            tmp = (length & 4194303) + 12582912;
            dest.writeByte(int((tmp & 16711680) >> 16));
            dest.writeByte(int((tmp & 65280) >> 8));
            dest.writeByte(int(tmp & 255));
         }
         else
         {
            throw new Error("Length is incorrect (" + length + ")");
         }
      }
      
      public static function decodeLength(reader:IDataInput) : int
      {
         var secondByte:int = 0;
         var doubleByte:Boolean = false;
         var thirdByte:int = 0;
         var firstByte:int = reader.readByte();
         var singleByte:Boolean = (firstByte & 128) == 0;
         if(singleByte)
         {
            return firstByte;
         }
         secondByte = reader.readByte();
         doubleByte = (firstByte & 64) == 0;
         if(doubleByte)
         {
            return ((firstByte & 63) << 8) + (secondByte & 255);
         }
         thirdByte = reader.readByte();
         return ((firstByte & 63) << 16) + ((secondByte & 255) << 8) + (thirdByte & 255);
      }
   }
}
