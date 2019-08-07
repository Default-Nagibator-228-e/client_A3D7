package alternativa.tanks.models.battlefield.inventory
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.types.Long;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import utils.client.battlefield.gui.models.inventory.item.IInventoryItemModelBase;
   import utils.client.battlefield.gui.models.inventory.item.InventoryItemModelBase;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   
   public class InventoryItemModel extends InventoryItemModelBase implements IInventoryItemModelBase, IInventoryItemModel
   {
       
      
      private var inventoryPanel:IInventoryPanel;
      
      private var itemByObject:Dictionary;
      
      private var tankInterface:TankModel;
      
      public function InventoryItemModel()
      {
         this.itemByObject = new Dictionary();
         super();
         _interfaces.push(IModel,IInventoryItemModelBase,IInventoryItemModel);
      }
      
      public function initObject(clientObject:ClientObject, battleId:Long, count:int, itemEffectTime:int, itemId:int, itemRestSec:int) : void
      {
         var modelService:IModelService = null;
         if(this.inventoryPanel == null)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.inventoryPanel = IInventoryPanel(modelService.getModelsByInterface(IInventoryPanel)[0]);
            this.tankInterface = TankModel(Main.osgi.getService(ITank));
         }
         var item:InventoryItem = new InventoryItem(clientObject,itemId,count,(itemRestSec + itemEffectTime) * 1000);
         this.itemByObject[clientObject] = item;
         var slotIndex:int = itemId - 1;
         this.inventoryPanel.assignItemToSlot(item,slotIndex);
      }
      
      public function activated(clientObject:ClientObject, param1:int) : void
      {
         var item:InventoryItem = this.itemByObject[clientObject];
         if(item == null)
         {
            return;
         }
         item.startCooldown(0);
         item.count -= param1;
         this.inventoryPanel.itemActivated(item);
      }
      
      public function requestActivation(item:InventoryItem) : void
      {
         var v:Vector3D = null;
         if(item.canActivate())
         {
            v = new Vector3D();
            this.tankInterface.readLocalTankPosition(v);
            this.activate(item.getClientObject(),v);
         }
      }
      
      private function activate(clientObject:ClientObject, vector:Vector3D) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;activate_item;" + clientObject.id + ";" + vector.x + ";" + vector.y + ";" + vector.z);
      }
   }
}
