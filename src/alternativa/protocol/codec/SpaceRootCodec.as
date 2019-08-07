package alternativa.protocol.codec
{
   import alternativa.network.command.SpaceCommand;
   import alternativa.protocol.factory.ICodecFactory;
   import alternativa.protocol.type.Byte;
   import alternativa.types.Long;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class SpaceRootCodec extends AbstractCodec
   {
       
      
      private var codecFactory:ICodecFactory;
      
      public function SpaceRootCodec(codecFactory:ICodecFactory)
      {
         super();
         this.codecFactory = codecFactory;
      }
      
      override protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         return new Array(reader,nullmap);
      }
      
      override protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         var hash:ByteArray = null;
         var byteCodec:ICodec = null;
         var i:int = 0;
         var c:SpaceCommand = null;
         var longCodec:ICodec = null;
         var data:ByteArray = null;
         if(object is ByteArray)
         {
            hash = object as ByteArray;
            byteCodec = this.codecFactory.getCodec(Byte);
            byteCodec.encode(dest,int(0),nullmap,true);
            hash.position = 0;
            for(i = 0; i < 32; i++)
            {
               byteCodec.encode(dest,hash.readByte(),nullmap,true);
            }
         }
         else if(object is SpaceCommand)
         {
            c = SpaceCommand(object);
            longCodec = this.codecFactory.getCodec(Long);
            longCodec.encode(dest,c.objectId,nullmap,true);
            longCodec.encode(dest,c.methodId,nullmap,true);
            data = ByteArray(c.params);
            dest.writeBytes(data,0,data.bytesAvailable);
            c.nullMap.reset();
            for(i = 0; i < c.nullMap.getSize(); i++)
            {
               nullmap.addBit(c.nullMap.getNextBit());
            }
         }
         else
         {
            dest.writeByte(int(object));
         }
      }
   }
}
