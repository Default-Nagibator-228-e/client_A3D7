package alternativa.protocol
{
   import alternativa.init.ProtocolActivator;
   import alternativa.osgi.service.console.IConsoleService;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class Packet
   {
      
      private static const ZIP_PACKET_SIZE_DELIMITER:int = 2000;
      
      private static const MAXIMUM_DATA_LENGTH:int = 2147483647;
      
      private static const LONG_SIZE_DELIMITER:int = 16384;
      
      private static const ZIPPED_FLAG:int = int(64);
      
      private static const LENGTH_FLAG:int = int(128);
       
      
      public function Packet()
      {
         super();
      }
      
      private function wrap(src:IDataInput, dst:IDataOutput, zipped:Boolean) : void
      {
         var sizeToWrite:int = 0;
         var hiByte:int = 0;
         var loByte:int = 0;
         var toWrap:ByteArray = new ByteArray();
         while(src.bytesAvailable)
         {
            toWrap.writeByte(src.readByte());
         }
         toWrap.position = 0;
         var longSize:Boolean = this.isLongSize(toWrap);
         if(!zipped && longSize)
         {
            zipped = true;
         }
         if(zipped)
         {
            toWrap.compress();
         }
         var length:int = toWrap.length;
         if(length > MAXIMUM_DATA_LENGTH)
         {
            throw new Error("Packet size too big(" + length + ")");
         }
         if(longSize)
         {
            sizeToWrite = length + (LENGTH_FLAG << 24);
            dst.writeInt(sizeToWrite);
         }
         else
         {
            hiByte = int(((length & 65280) >> 8) + (!!zipped?ZIPPED_FLAG:0));
            loByte = int(length & 255);
            dst.writeByte(hiByte);
            dst.writeByte(loByte);
         }
         dst.writeBytes(toWrap,0,length);
      }
      
      public function wrapPacket(src:IDataInput, dst:IDataOutput) : void
      {
         this.wrap(src,dst,this.determineZipped(src));
      }
      
      public function wrapZippedPacket(src:IDataInput, dst:IDataOutput) : void
      {
         this.wrap(src,dst,true);
      }
      
      public function wrapUnzippedPacket(src:IDataInput, dst:IDataOutput) : void
      {
         this.wrap(src,dst,false);
      }
      
      public function unwrapPacket(src:IDataInput, dst:IDataOutput) : Boolean
      {
         var flagByte:int = 0;
         var longSize:Boolean = false;
         var isZipped:Boolean = false;
         var packetSize:int = 0;
         var readPacket:Boolean = false;
         var hiByte:int = 0;
         var middleByte:int = 0;
         var loByte:int = 0;
         var loByte2:int = 0;
         var toUnwrap:ByteArray = null;
         var i:int = 0;
         var console:IConsoleService = null;
         var s:String = null;
         var b:String = null;
         var result:Boolean = false;
         if(src.bytesAvailable >= 2)
         {
            flagByte = src.readByte();
            longSize = (flagByte & LENGTH_FLAG) != 0;
            readPacket = true;
            if(src.bytesAvailable >= 1)
            {
               if(longSize)
               {
                  if(src.bytesAvailable >= 3)
                  {
                     isZipped = true;
                     hiByte = (flagByte ^ LENGTH_FLAG) << 24;
                     middleByte = (src.readByte() & 255) << 16;
                     loByte = (src.readByte() & 255) << 8;
                     loByte2 = src.readByte() & 255;
                     packetSize = hiByte + middleByte + loByte + loByte2;
                  }
                  else
                  {
                     readPacket = false;
                  }
               }
               else
               {
                  isZipped = (flagByte & ZIPPED_FLAG) != 0;
                  hiByte = (flagByte & 63) << 8;
                  loByte = src.readByte() & 255;
                  packetSize = hiByte + loByte;
               }
               if(src.bytesAvailable < packetSize)
               {
                  readPacket = false;
               }
               if(readPacket)
               {
                  toUnwrap = new ByteArray();
                  for(i = 0; i < packetSize; i++)
                  {
                     toUnwrap.writeByte(src.readByte());
                  }
                  if(isZipped)
                  {
                     toUnwrap.uncompress();
                  }
                  console = ProtocolActivator.osgi.getService(IConsoleService) as IConsoleService;
                  s = "Unwraped data: ";
                  toUnwrap.position = 0;
                  while(toUnwrap.bytesAvailable)
                  {
                     b = toUnwrap.readUnsignedByte().toString(16).toUpperCase() + " ";
                     if(b.length < 3)
                     {
                        b = "0" + b;
                     }
                     s = s + b;
                  }
                  console.writeToConsoleChannel("PROTOCOL",s);
                  toUnwrap.position = 0;
                  dst.writeBytes(toUnwrap,0,toUnwrap.length);
                  result = true;
               }
            }
         }
         return result;
      }
      
      private function isLongSize(reader:IDataInput) : Boolean
      {
         return reader.bytesAvailable >= LONG_SIZE_DELIMITER || reader.bytesAvailable == -1;
      }
      
      private function determineZipped(reader:IDataInput) : Boolean
      {
         return reader.bytesAvailable == -1 || reader.bytesAvailable > ZIP_PACKET_SIZE_DELIMITER;
      }
   }
}
