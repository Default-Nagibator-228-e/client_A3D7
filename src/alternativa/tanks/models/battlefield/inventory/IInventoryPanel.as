package alternativa.tanks.models.battlefield.inventory
{
   public interface IInventoryPanel
   {
       
      
      function assignItemToSlot(param1:InventoryItem, param2:int) : void;
      
      function itemActivated(param1:InventoryItem) : void;
   }
}
