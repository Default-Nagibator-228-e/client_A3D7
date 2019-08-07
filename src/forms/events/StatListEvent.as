package forms.events
{
   import flash.events.Event;
   
   public class StatListEvent extends Event
   {
      
      public static const UPDATE_STAT:String = "StatListUpdate";
      
      public static const UPDATE_SORT:String = "StatListUpdateSort";
       
      
      public var beginPosition:int = 0;
      
      public var numRow:int = 0;
      
      public var sortField:int;
      
      public function StatListEvent(type:String, begin:int, num:int, sort:int = 1)
      {
         super(type,true,false);
         this.beginPosition = begin;
         this.numRow = num;
         this.sortField = sort;
      }
   }
}
