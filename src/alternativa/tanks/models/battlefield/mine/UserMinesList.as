package alternativa.tanks.models.battlefield.mine
{
   public class UserMinesList
   {
       
      
      public var head:ProximityMine;
      
      public var tail:ProximityMine;
      
      public function UserMinesList()
      {
         super();
      }
      
      public function addMine(mine:ProximityMine) : void
      {
         if(this.head == null)
         {
            this.head = this.tail = mine;
         }
         else
         {
            this.tail.next = mine;
            mine.prev = this.tail;
            this.tail = mine;
         }
      }
      
      public function removeMine(mine:ProximityMine) : void
      {
         if(this.head == null)
         {
            return;
         }
         if(mine == this.head)
         {
            if(mine == this.tail)
            {
               this.head = this.tail = null;
            }
            else
            {
               this.head = this.head.next;
               this.head.prev = null;
            }
         }
         else if(mine == this.tail)
         {
            this.tail = this.tail.prev;
            this.tail.next = null;
         }
         else
         {
            mine.prev.next = mine.next;
            mine.next.prev = mine.prev;
         }
         mine.dispose();
      }
      
      public function clearMines() : void
      {
         while(this.head != null)
         {
            this.removeMine(this.head);
         }
      }
   }
}
