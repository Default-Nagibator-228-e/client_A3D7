package forms.shop.shopitems.event
{
   import flash.events.Event;
   
   public class ShopItemChosen extends Event
   {
      
      public static const EVENT_TYPE:String = "ShopItemChosenEVENT";
      
      public function ShopItemChosen()
      {
         super(EVENT_TYPE,true);
         //this.item = param1;
      }
   }
}
