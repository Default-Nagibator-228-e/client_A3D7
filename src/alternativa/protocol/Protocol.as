package alternativa.protocol
{
   import alternativa.init.ProtocolActivator;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.protocol.codec.ICodec;
   import alternativa.protocol.codec.NullMap;
   import alternativa.protocol.factory.ICodecFactory;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class Protocol
   {
      
      private static const INPLACE_MASK_FLAG:int = 128;
      
      private static const MASK_LENGTH_2_BYTES_FLAG:int = 64;
      
      private static const INPLACE_MASK_1_BYTES:int = 32;
      
      private static const INPLACE_MASK_3_BYTES:int = 96;
      
      private static const INPLACE_MASK_2_BYTES:int = 64;
      
      private static const MASK_LENGTH_1_BYTE:int = 128;
      
      private static const MASK_LEGTH_3_BYTE:int = 12582912;
       
      
      private var codecFactory:ICodecFactory;
      
      private var rootTargetClass:Class;
      
      public function Protocol(codecFactory:ICodecFactory, rootTargetClass:Class)
      {
         super();
         this.codecFactory = codecFactory;
         this.rootTargetClass = rootTargetClass;
      }
      
      public function encode(dest:IDataOutput, object:Object) : void
      {
         var codec:ICodec = this.codecFactory.getCodec(this.rootTargetClass);
         var nullMap:NullMap = new NullMap();
         var dataWriter:ByteArray = new ByteArray();
         codec.encode(IDataOutput(dataWriter),object,nullMap,true);
         var nullmapEncoded:ByteArray = this.encodeNullMap(nullMap);
         dataWriter.position = 0;
         nullmapEncoded.position = 0;
         dest.writeBytes(nullmapEncoded,0,nullmapEncoded.length);
         dest.writeBytes(dataWriter,0,dataWriter.length);
      }
      
      public function decode(reader:IDataInput) : Object
      {
         var b:String = null;
         var codec:ICodec = this.codecFactory.getCodec(this.rootTargetClass);
         var nullMap:NullMap = this.decodeNullMap(reader);
         IConsoleService(ProtocolActivator.osgi.getService(IConsoleService)).writeToConsoleChannel("PROTOCOL","Protocol decode nullMap:");
         var map:ByteArray = nullMap.getMap();
         map.position = 0;
         var mapString:String = "";
         while(map.bytesAvailable)
         {
            b = map.readUnsignedByte().toString(2);
            while(b.length < 8)
            {
               b = 0 + b;
            }
            mapString = mapString + (b + " ");
         }
         IConsoleService(ProtocolActivator.osgi.getService(IConsoleService)).writeToConsoleChannel("PROTOCOL","   " + mapString);
         IConsoleService(ProtocolActivator.osgi.getService(IConsoleService)).writeToConsoleChannel("PROTOCOL"," ");
         map.position = 0;
         nullMap.reset();
         return codec.decode(reader,nullMap,true);
      }
      
      private function encodeNullMap(nullMap:NullMap) : ByteArray
      {
         var sizeInBytes:int = 0;
         var firstByte:int = 0;
         var sizeEncoded:int = 0;
         var secondByte:int = 0;
         var thirdByte:int = 0;
         var nullMapSize:int = nullMap.getSize();
         var map:ByteArray = nullMap.getMap();
         var res:ByteArray = new ByteArray();
         if(nullMapSize <= 5)
         {
            res.writeByte(int((map[0] & 255) >>> 3));
            return res;
         }
         if(nullMapSize <= 13)
         {
            res.writeByte(int(((map[0] & 255) >>> 3) + INPLACE_MASK_1_BYTES));
            res.writeByte(((map[1] & 255) >>> 3) + (map[0] << 5));
            return res;
         }
         if(nullMapSize <= 21)
         {
            res.writeByte(int(((map[0] & 255) >>> 3) + INPLACE_MASK_2_BYTES));
            res.writeByte(int(((map[1] & 255) >>> 3) + (map[0] << 5)));
            res.writeByte(int(((map[2] & 255) >>> 3) + (map[1] << 5)));
            return res;
         }
         if(nullMapSize <= 29)
         {
            res.writeByte(int(((map[0] & 255) >>> 3) + INPLACE_MASK_3_BYTES));
            res.writeByte(int(((map[1] & 255) >>> 3) + (map[0] << 5)));
            res.writeByte(int(((map[2] & 255) >>> 3) + (map[1] << 5)));
            res.writeByte(int(((map[3] & 255) >>> 3) + (map[2] << 5)));
            return res;
         }
         if(nullMapSize <= 504)
         {
            sizeInBytes = (nullMapSize >>> 3) + ((nullMapSize & 7) == 0?0:1);
            firstByte = int((sizeInBytes & 255) + MASK_LENGTH_1_BYTE);
            res.writeByte(firstByte);
            res.writeBytes(map,0,sizeInBytes);
            return res;
         }
         if(nullMapSize <= 33554432)
         {
            sizeInBytes = (nullMapSize >>> 3) + ((nullMapSize & 7) == 0?0:1);
            sizeEncoded = sizeInBytes + MASK_LEGTH_3_BYTE;
            firstByte = int((sizeEncoded & 16711680) >>> 16);
            secondByte = int((sizeEncoded & 65280) >>> 8);
            thirdByte = int(sizeEncoded & 255);
            res.writeByte(firstByte);
            res.writeByte(secondByte);
            res.writeByte(thirdByte);
            res.writeBytes(map,0,sizeInBytes);
            return res;
         }
         throw new Error("NullMap overflow");
      }
      
      private function decodeNullMap(reader:IDataInput) : NullMap
      {
         var maskLength:int = 0;
         var firstByteValue:int = 0;
         var isLength22bit:Boolean = false;
         var sizeInBits:int = 0;
         var secondByte:int = 0;
         var thirdByte:int = 0;
         var fourthByte:int = 0;
         var mask:ByteArray = new ByteArray();
         var firstByte:int = reader.readByte();
         var isLongNullMap:Boolean = (firstByte & INPLACE_MASK_FLAG) != 0;
         if(isLongNullMap)
         {
            firstByteValue = firstByte & 63;
            isLength22bit = (firstByte & MASK_LENGTH_2_BYTES_FLAG) != 0;
            if(isLength22bit)
            {
               secondByte = reader.readByte();
               thirdByte = reader.readByte();
               maskLength = (firstByteValue << 16) + ((secondByte & 255) << 8) + (thirdByte & 255);
            }
            else
            {
               maskLength = firstByteValue;
            }
            reader.readBytes(mask,0,maskLength);
            sizeInBits = maskLength << 3;
            return new NullMap(sizeInBits,mask);
         }
         firstByteValue = int(firstByte << 3);
         maskLength = int((firstByte & 96) >> 5);
         switch(maskLength)
         {
            case 0:
               mask.writeByte(firstByteValue);
               return new NullMap(5,mask);
            case 1:
               secondByte = reader.readByte();
               mask.writeByte(int(firstByteValue + ((secondByte & 255) >>> 5)));
               mask.writeByte(int(secondByte << 3));
               return new NullMap(13,mask);
            case 2:
               secondByte = reader.readByte();
               thirdByte = reader.readByte();
               mask.writeByte(int(firstByteValue + ((secondByte & 255) >>> 5)));
               mask.writeByte(int((secondByte << 3) + ((thirdByte & 255) >>> 5)));
               mask.writeByte(int(thirdByte << 3));
               return new NullMap(21,mask);
            case 3:
               secondByte = reader.readByte();
               thirdByte = reader.readByte();
               fourthByte = reader.readByte();
               mask.writeByte(int(firstByteValue + ((secondByte & 255) >>> 5)));
               mask.writeByte(int((secondByte << 3) + ((thirdByte & 255) >>> 5)));
               mask.writeByte(int((thirdByte << 3) + ((fourthByte & 255) >>> 5)));
               mask.writeByte(int(fourthByte << 3));
               return new NullMap(29,mask);
            default:
               return null;
         }
      }
   }
}
