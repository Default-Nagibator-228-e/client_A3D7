package forms.events
{
   import flash.events.Event;
   
   public class PartsListEvent extends Event
   {
      
      public static const SELECT_PARTS_LIST_ITEM:String = "SelectPartsListItem";
       
      
      public function PartsListEvent(type:String)
      {
         super(type,true,false);
      }
   }
}
