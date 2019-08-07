package alternativa.tanks.models.battlefield.inventory
{
   import utils.client.models.ClientObject;
   import controls.InventoryIcon;
   import flash.utils.getTimer;
   
   public class InventoryItem
   {
       
      
      private var id:int;
      
      private var _count:int;
      
      private var clientObject:ClientObject;
      
      private var icon:InventoryIcon;
      
      private var cooldownStartTime:int = -1;
      
      private var cooldownTime:int;
      
      public function InventoryItem(clientObject:ClientObject, id:int, quantity:int, coolDownMsec:int)
      {
         super();
         this.clientObject = clientObject;
         this.id = id;
         this.icon = new InventoryIcon(id);
         this._count = quantity;
         this.cooldownTime = coolDownMsec;
      }
      
      public function getClientObject() : ClientObject
      {
         return this.clientObject;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getIcon() : InventoryIcon
      {
         return this.icon;
      }
      
      public function getCooldownStatus(now:int) : Number
      {
         if(this.cooldownStartTime == -1)
         {
            return 1;
         }
         var status:Number = (now - this.cooldownStartTime) / this.cooldownTime;
         if(status > 1)
         {
            status = 1;
            this.clearCooldown();
         }
         return status;
      }
      
      public function clearCooldown() : void
      {
         this.cooldownStartTime = -1;
      }
      
      public function startCooldown(cooldownTime:int) : void
      {
         this.cooldownStartTime = getTimer();
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function canActivate() : Boolean
      {
         return this.cooldownStartTime < 0 && this._count > 0;
      }
   }
}
