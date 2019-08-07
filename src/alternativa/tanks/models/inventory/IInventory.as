package alternativa.tanks.models.inventory
{
   public interface IInventory
   {
       
      
      function lockItem(param1:int, param2:int, param3:Boolean) : void;
      
      function lockItems(param1:int, param2:Boolean) : void;
   }
}
