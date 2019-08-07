package alternativa.protocol.codec
{
   import flash.utils.ByteArray;
   
   public class NullMap
   {
       
      
      private var readPosition:int;
      
      private var size:int;
      
      private var map:ByteArray;
      
      public function NullMap(size:int = 0, source:ByteArray = null)
      {
         super();
         this.map = new ByteArray();
         if(source != null)
         {
            this.map.writeBytes(source,0,this.convertSize(size));
         }
         this.size = size;
         this.readPosition = 0;
      }
      
      public function reset() : void
      {
         this.readPosition = 0;
      }
      
      public function addBit(isNull:Boolean) : void
      {
         this.setBit(this.size,isNull);
         this.size++;
      }
      
      public function hasNextBit() : Boolean
      {
         return this.readPosition < this.size;
      }
      
      public function getNextBit() : Boolean
      {
         if(this.readPosition >= this.size)
         {
            throw new Error("Index out of bounds: " + this.readPosition);
         }
         var res:Boolean = this.getBit(this.readPosition);
         this.readPosition++;
         return res;
      }
      
      public function getMap() : ByteArray
      {
         return this.map;
      }
      
      public function getSize() : int
      {
         return this.size;
      }
      
      private function getBit(position:int) : Boolean
      {
         var targetByte:int = position >> 3;
         var targetBit:int = 7 ^ position & 7;
         this.map.position = targetByte;
         return (this.map.readByte() & 1 << targetBit) != 0;
      }
      
      private function setBit(position:int, value:Boolean) : void
      {
         var targetByte:int = position >> 3;
         var targetBit:int = 7 ^ position & 7;
         this.map.position = targetByte;
         if(value)
         {
            this.map.writeByte(int(this.map[targetByte] | 1 << targetBit));
         }
         else
         {
            this.map.writeByte(int(this.map[targetByte] & (255 ^ 1 << targetBit)));
         }
      }
      
      private function convertSize(sizeInBits:int) : int
      {
         var i:int = sizeInBits >> 3;
         var add:int = (sizeInBits & 7) == 0?int(0):int(1);
         return i + add;
      }
      
      public function toString() : String
      {
         var result:String = "readPosition: " + this.readPosition + " size:" + this.getSize() + " mask:";
         var _readPosition:int = this.readPosition;
         for(var i:int = this.readPosition; i < this.getSize(); i++)
         {
            result = result + (!!this.getNextBit()?1:0);
         }
         this.readPosition = _readPosition;
         return result;
      }
      
      public function clone() : NullMap
      {
         var map:NullMap = new NullMap(this.size,this.map);
         map.readPosition = this.readPosition;
         return map;
      }
   }
}
