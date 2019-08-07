package forms.garage
{
   import flash.events.Event;
   
   public class GarageWindowEvent extends Event
   {
      
      public static const WAREHOUSE_ITEM_SELECTED:String = "GarageWindowEventWirehouseItemSelected";
      
      public static const STORE_ITEM_SELECTED:String = "GarageWindowEventStoreItemSelected";
      
      public static const BUY_ITEM:String = "GarageWindowEventBuyItem";
	  
	  public static const UP_ITEM:String = "GarageWindowEventUpItem";
      
      public static const SETUP_ITEM:String = "GarageWindowEventSetupItem";
      
      public static const UPGRADE_ITEM:String = "GarageWindowEventUpgradeItem";
      
      public static const ADD_CRYSTALS:String = "GarageWindowEventAddCrystals";
       
      
      public var itemId:String;
      
      public function GarageWindowEvent(type:String, itemId:String)
      {
         super(type,true,false);
         this.itemId = itemId;
      }
   }
}
