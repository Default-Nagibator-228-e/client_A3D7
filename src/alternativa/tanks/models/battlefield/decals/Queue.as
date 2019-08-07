package alternativa.tanks.models.battlefield.decals
{
   public class Queue
   {
       
      
      private var head:QueueItem;
      
      private var tail:QueueItem;
      
      private var size:int;
      
      public function Queue()
      {
         super();
      }
      
      public function put(param1:*) : void
      {
         this.size++;
         var _loc2_:QueueItem = QueueItem.create(param1);
         if(this.tail == null)
         {
            this.head = _loc2_;
            this.tail = _loc2_;
         }
         else
         {
            this.tail.next = _loc2_;
            this.tail = _loc2_;
         }
      }
      
      public function pop() : *
      {
         if(this.head == null)
         {
            return null;
         }
         this.size--;
         var _loc1_:* = this.head.data;
         var _loc2_:QueueItem = this.head;
         this.head = this.head.next;
         _loc2_.destroy();
         return _loc1_;
      }
      
      public function getSize() : int
      {
         return this.size;
      }
   }
}
