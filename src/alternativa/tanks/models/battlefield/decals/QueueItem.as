package alternativa.tanks.models.battlefield.decals
{
   public class QueueItem
   {
      
      private static var poolTop:QueueItem;
       
      
      public var next:QueueItem;
      
      public var data:Object;
      
      public function QueueItem(param1:*)
      {
         super();
         this.data = param1;
      }
      
      public static function create(param1:*) : QueueItem
      {
         if(poolTop == null)
         {
            return new QueueItem(param1);
         }
         var _loc2_:QueueItem = poolTop;
         poolTop = poolTop.next;
         _loc2_.data = param1;
         return _loc2_;
      }
      
      public function destroy() : void
      {
         this.data = null;
         this.next = poolTop;
         poolTop = this;
      }
   }
}
