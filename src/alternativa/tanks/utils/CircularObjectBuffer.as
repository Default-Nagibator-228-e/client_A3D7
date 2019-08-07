package alternativa.tanks.utils
{
   public class CircularObjectBuffer
   {
       
      
      private var buffer:Array;
      
      private var writeIndex:int;
      
      private var headIndex:int;
      
      public function CircularObjectBuffer(size:int)
      {
         super();
         this.buffer = new Array(size + 1);
      }
      
      public function addObject(object:Object) : void
      {
         this.buffer[this.writeIndex] = object;
         this.writeIndex = this.incIndex(this.writeIndex);
         if(this.headIndex == this.writeIndex)
         {
            this.headIndex = this.incIndex(this.headIndex);
         }
      }
      
      public function clear() : void
      {
         var len:int = this.buffer.length;
         for(var i:int = 0; i < len; i++)
         {
            this.buffer[i] = null;
         }
         this.headIndex = this.writeIndex = 0;
      }
      
      public function getObjects() : Array
      {
         var i:int = 0;
         var j:int = 0;
         var num:int = this.writeIndex - this.headIndex;
         if(num < 0)
         {
            num = num + this.buffer.length;
         }
         var res:Array = new Array(num);
         var len:int = this.buffer.length;
         for(i = 0,j = this.headIndex; i < num; i++,j++)
         {
            if(j == len)
            {
               j = 0;
            }
            res[i] = this.buffer[j];
         }
         return res;
      }
      
      private function incIndex(index:int) : int
      {
         return ++index == this.buffer.length?int(0):int(index);
      }
   }
}
