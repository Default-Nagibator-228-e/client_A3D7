package alternativa.service.server.models.inventory
{
   import alternativa.init.Main;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.inventory.IInventoryItemModel;
   import alternativa.tanks.models.battlefield.inventory.InventoryItemModel;
   import alternativa.tanks.models.battlefield.inventory.InventoryModel;
   import alternativa.tanks.models.effectsvisualization.EffectsVisualizationModel;
   import alternativa.tanks.models.effectsvisualization.IEffectsVisualizationModel;
   import alternativa.tanks.models.inventory.IInventory;
   import flash.utils.Dictionary;
   
   public class ServerInventoryModel
   {
       
      
      public var inventoryModel:InventoryModel;
      
      private var inventoryItemModel:InventoryItemModel;
      
      private var effectModel:EffectsVisualizationModel;
      
      private var modelsService:IModelService;
      
      private var _objects:Dictionary;
      
      public function ServerInventoryModel()
      {
         super();
      }
      
      public function init() : void
      {
		 if (modelsService == null)
		 {
			 this.modelsService = IModelService(Main.osgi.getService(IModelService));
			 this.inventoryModel = InventoryModel(this.modelsService.getModelsByInterface(IInventory)[0]);
			 this.inventoryItemModel = InventoryItemModel(this.modelsService.getModelsByInterface(IInventoryItemModel)[0]);
			 this.effectModel = EffectsVisualizationModel(this.modelsService.getModelsByInterface(IEffectsVisualizationModel)[0]);
			 this._objects = new Dictionary();
		 }
      }
      
      public function initInventory(items:Array) : void
      {
         var data:ServerInventoryData = null;
         var clientObject:ClientObject = null;
         this.inventoryModel.objectLoaded(null);
         for each(data in items)
         {
            clientObject = this.getClientObject(data.id);
            this.inventoryItemModel.initObject(clientObject,null,data.count,data.itemEffectTime,data.slotId,data.itemRestSec);
            this._objects[data.id] = clientObject;
         }
      }
      
      public function activateItem(id:String) : void
      {
         this.inventoryItemModel.activated(this._objects[id],1);
      }
	  
	  public function activateItemb(id:String) : void
      {
         this.inventoryItemModel.activated(this._objects[id],0);
      }
      
      public function enableEffects(effects:Array) : void
      {
		 if (this.effectModel == null)
		 {
			this.init();
		 }
		 this.effectModel.initObject(effects);
      }
      
      public function enableEffect(clientObject:ClientObject, itemIndex:int, duration:int) : void
      {
         this.effectModel.effectActivated(clientObject,clientObject.id,itemIndex,duration);
      }
      
      public function disnableEffect(clientObject:ClientObject, itemIndex:int) : void
      {
         this.effectModel.effectStopped(clientObject,clientObject.id,itemIndex);
      }
      
      public function localTankKilled() : void
      {
         this.inventoryModel.killCurrentUser(null);
      }
      
      private function getClientObject(id:String) : ClientObject
      {
         return new ClientObject(id,null,id,null);
      }
   }
}
