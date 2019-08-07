package alternativa.tanks.model
{
   import alternativa.init.GarageModelActivator;
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import alternativa.tanks.gui.ConfirmAlert;
   import forms.garage.GarageWindow;
   import forms.garage.GarageWindowEvent;
   import forms.garage.ItemInfoPanel;
   import forms.upgrade.UpgradeWindow;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.help.StoreListHelper;
   import alternativa.tanks.help.WarehouseListHelper;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.service.money.IMoneyListener;
   import alternativa.tanks.service.money.IMoneyService;
   import alternativa.types.Long;
   import utils.client.commons.models.itemtype.ItemTypeEnum;
   import utils.client.commons.types.ItemProperty;
   import utils.client.garage.garage.GarageModelBase;
   import utils.client.garage.garage.IGarageModelBase;
   import utils.client.garage.garage.ItemInfo;
   import utils.client.garage.item.ItemPropertyValue;
   import utils.client.garage.item.ModificationInfo;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   
   public class GarageModel extends GarageModelBase implements IGarageModelBase, IObjectLoadListener, IGarage, IItemListener, IDumper, IMoneyListener, IItemEffectListener
   {
      
      public static var itemsParams:Dictionary;
      
      public static var itemsInfo:Dictionary;
      
      public static var buyCrystalCurrency:String;
      
      public static var buyCrystalRate:Number;
       
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var helpService:IHelpService;
      
      private var modelRegister:IModelService;
      
      private var resourceRegister:IResourceService;
      
      private var panelModel:IPanel;
      
      private var itemModel:IItem;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
	  
	  public var upg:UpgradeWindow = new UpgradeWindow();
      
      public var garageWindow:GarageWindow;
      
      private var itemsForMount:Array;
      
      public var mountedItems:Array;
      
      public var mountedWeaponId:String;
      
      public var mountedWeaponInfo:ItemInfo;
      
      public var mountedWeaponParams:ItemParams;
      
      public var mountedArmorId:String;
      
      public var mountedArmorInfo:ItemInfo;
      
      public var mountedArmorParams:ItemParams;
      
      public var mountedEngineId:String;
      
      public var mountedEngineInfo:ItemInfo;
      
      public var mountedEngineParams:ItemParams;
      
      private var storeSelectedItem:String;
      
      private var warehouseSelectedItem:String;
      
      private var garageBoxId:Long;
      
      private var firstItemId:String;
      
      private var minItemIndex:int = 2147483647;
      
      private var firstItemParams:ItemParams;
      
      private var lockBuy:Boolean = false;
      
      private var lockSell:Boolean = false;
      
      private var lockMount:Boolean = false;
      
      private var lockReplace:Boolean = false;
      
      private var lockUpgrade:Boolean = false;
      
      private var itemDumper:ItemDumper;
      
      private const HELPER_STORE:int = 2;
      
      private const HELPER_WAREHOUSE:int = 3;
      
      private var storeHelper:StoreListHelper;
      
      private var warehouseHelper:WarehouseListHelper;
      
      private const HELPER_GROUP_KEY:String = "GarageModel";
      
      private var confirmAlert:ConfirmAlert;
      
      private var itemWaitingForConfirmation:String;
      
      private var socket:Network;
      
      public var currentItemForUpdate:String;
      
      public var kostil:Boolean = false;
      
      private var items:Dictionary;
      
      private var i:int = 2;
      
      public function GarageModel()
      {
         this.items = new Dictionary();
         super();
         _interfaces.push(IModel);
         _interfaces.push(IGarage);
         _interfaces.push(IGarageModelBase);
         _interfaces.push(IObjectLoadListener);
         _interfaces.push(IItemListener);
         _interfaces.push(IItemEffectListener);
         this.layer = Main.contentUILayer;
         itemsParams = new Dictionary();
         this.resourceRegister = Main.osgi.getService(IResourceService) as IResourceService;
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
      }
      
      public static function getPropertyValue(properties:Array, property:ItemProperty) : String
      {
         var p:ItemPropertyValue = null;
         for(var i:int = 0; i < properties.length; i++)
         {
            p = properties[i] as ItemPropertyValue;
            if(p.property == property)
            {
               return p.value;
            }
         }
         return null;
      }
      
      public static function getItemInfo(itemId:String) : ItemInfo
      {
         return itemsInfo[itemId];
      }
      
      public static function replaceItemInfo(oldId:String, newId:String) : void
      {
         var temp:ItemInfo = itemsInfo[oldId];
         temp.itemId = newId;
         itemsInfo[newId] = temp;
      }
      
      public static function replaceItemParams(oldId:String, newId:String) : void
      {
         var temp:ItemParams = itemsParams[oldId];
         temp.baseItemId = newId;
         itemsParams[newId] = temp;
      }
      
      public static function getItemParams(itemId:String) : ItemParams
      {
         return itemsParams[itemId];
      }
      
      public static function isTankPart(itemType:ItemTypeEnum) : Boolean
      {
         return itemType == ItemTypeEnum.ARMOR || itemType == ItemTypeEnum.WEAPON || itemType == ItemTypeEnum.COLOR;
      }
      
      public function initObject(clientObject:ClientObject, country:String, rate:Number, garageBoxId:Long, networker:Network) : void
      {
         this.garageBoxId = garageBoxId;
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         GarageModel.buyCrystalCurrency = "RUR";
         GarageModel.buyCrystalRate = rate;
         this.socket = networker;
         this.objectLoaded(null);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var timer:Timer = null;
         if(!this.kostil)
         {
            this.kostil = true;
            Main.writeVarsToConsoleChannel("GARAGE MODEL","objectLoaded");
            this.clientObject = object;
            Main.stage.quality = StageQuality.HIGH;
			if (garageWindow == null)
			{
				itemsInfo = new Dictionary();
				this.mountedItems = new Array();
				this.itemsForMount = new Array();
				upg.init();
				this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
				this.itemModel = (this.modelRegister.getModelsByInterface(IItem) as Vector.<IModel>)[0] as IItem;
				this.panelModel = Main.osgi.getService(IPanel) as IPanel;
				this.garageWindow = new GarageWindow(this.garageBoxId,this);
				this.helpService = Main.osgi.getService(IHelpService) as IHelpService;
				this.storeHelper = new StoreListHelper();
				this.warehouseHelper = new WarehouseListHelper();
				this.helpService.registerHelper(this.HELPER_GROUP_KEY,this.HELPER_STORE,this.storeHelper,true);
				this.helpService.registerHelper(this.HELPER_GROUP_KEY,this.HELPER_WAREHOUSE,this.warehouseHelper,true);
				Main.stage.addEventListener(Event.RESIZE, this.alignHelpers);
				this.alignHelpers();
				timer = new Timer(3500,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
				{
				   showWindow();
				   panelModel.partSelected(1);
				   (Main.osgi.getService(ILoader) as CheckLoader).setFullAndClose(null);
				});
				timer.start();
			}
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE MODEL","objectUnloaded");
         var moneyService:IMoneyService = GarageModelActivator.osgi.getService(IMoneyService) as IMoneyService;
         if(moneyService != null)
         {
            moneyService.removeListener(this);
         }
         this.hideWindow();
		 if (upg != null)
		 {
			 if (Main.dialogsLayer.contains(upg))
			 {
				Main.dialogsLayer.removeChild(upg);
			 }
			 upg.destroy();
		 }
		 upg = null;
         Main.stage.removeEventListener(Event.RESIZE,this.alignHelpers);
         this.helpService.unregisterHelper(this.HELPER_GROUP_KEY,this.HELPER_STORE);
         this.helpService.unregisterHelper(this.HELPER_GROUP_KEY,this.HELPER_WAREHOUSE);
         this.storeHelper = null;
         this.warehouseHelper = null;
         this.garageWindow = null;
         this.clientObject = null;
         Main.stage.quality = StageQuality.HIGH;
      }
      
      public function initItem(id:String, item:ItemParams) : void
      {
         this.items[id] = item;
      }
      
      public function initDepot(clientObject:ClientObject, itemsOnSklad:Array) : void
      {
         var info:ItemInfo = null;
         var itemId:String = null;
         var itemParams:ItemParams = null;
         for(var i:int = 0; i < itemsOnSklad.length; i++)
         {
            info = itemsOnSklad[i] as ItemInfo;
            itemId = info.itemId;
            itemParams = this.items[itemId];
            itemsParams[itemId] = itemParams;
            itemsInfo[itemId] = info;
            this.garageWindow.addItemToWarehouse(itemId,itemParams,info);
            if(this.itemsForMount.indexOf(itemId) != -1)
            {
               this.garageWindow.mountItem(itemId);
               this.itemsForMount.splice(this.itemsForMount.indexOf(itemId),1);
               this.mountedItems.push(itemId);
               switch(itemParams.itemType)
               {
                  case ItemTypeEnum.WEAPON:
                     this.mountedWeaponId = itemId;
                     this.mountedWeaponInfo = info;
                     this.mountedWeaponParams = itemParams;
                     break;
                  case ItemTypeEnum.ARMOR:
                     this.mountedArmorId = itemId;
                     this.mountedArmorInfo = info;
                     this.mountedArmorParams = itemParams;
               }
            }
         }
         this.garageWindow.addEventListener(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED,this.onWarehouseListSelect);
         this.garageWindow.addEventListener(GarageWindowEvent.SETUP_ITEM,this.onSetupClick);
         this.garageWindow.addEventListener(GarageWindowEvent.UPGRADE_ITEM,this.onUpgradeClick);
         this.garageWindow.addEventListener(GarageWindowEvent.ADD_CRYSTALS, this.onBuyCrystalsClick);
		 this.garageWindow.addEventListener(GarageWindowEvent.UP_ITEM,this.onUpClick);
         this.garageWindow.selectFirstItemInWarehouse();
      }
      
      public function initMarket(clientObject:ClientObject, itemsOnMarket:Array) : void
      {
         var info:ItemInfo = null;
         var itemId:String = null;
         var itemParams:ItemParams = null;
         Main.writeVarsToConsoleChannel("GARAGE MODEL","initMarket itemsOnMarket: " + itemsOnMarket);
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         for(var i:int = 0; i < itemsOnMarket.length; i++)
         {
            info = itemsOnMarket[i] as ItemInfo;
            itemId = info.itemId;
            itemParams = this.items[itemId];
            itemsParams[itemId] = itemParams;
            if(!itemParams.inventoryItem)
            {
               itemsInfo[itemId] = info;
            }
            this.garageWindow.addItemToWarehouse(itemId,itemParams,null);
         }
         this.garageWindow.addEventListener(GarageWindowEvent.STORE_ITEM_SELECTED,this.onStoreListSelect);
         this.garageWindow.addEventListener(GarageWindowEvent.BUY_ITEM,this.onBuyClick);
      }
      
      public function crystalsChanged(value:int) : void
      {
         var id:String = null;
         Main.writeVarsToConsoleChannel("GARAGE MODEL","crystalsChanged: %1",value);
         if(!this.lockBuy && !this.lockMount && !this.lockReplace && !this.lockSell && !this.lockUpgrade)
         {
            id = this.garageWindow.selectedItemId;
            if(id != null)
            {
               if(this.garageWindow.storeItemSelected)
               {
                  this.garageWindow.selectItemInStore(id);
               }
               else
               {
                  this.garageWindow.selectItemInWarehouse(id);
               }
            }
         }
      }
      
      public function itemLoaded(item:ClientObject, params:ItemParams) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE MODEL","itemLoaded (" + item.id + ")");
         itemsParams[item.id] = params;
      }
      
      private function onWarehouseListSelect(e:GarageWindowEvent) : void
      {
         var itemId:String = e.itemId;
         this.warehouseSelectedItem = itemId;
         var params:ItemParams = itemsParams[itemId] as ItemParams;
         var info:ItemInfo = itemsInfo[itemId] as ItemInfo;
         var itemType:ItemTypeEnum = params.itemType;
         this.garageWindow.showItemInfo(itemId,params,false,info);
         if(itemType == ItemTypeEnum.ARMOR || itemType == ItemTypeEnum.WEAPON || itemType == ItemTypeEnum.COLOR)
         {
            if(this.mountedItems.indexOf(itemId) != -1)
            {
               this.garageWindow.lockMountButton();
            }
            else
            {
               this.garageWindow.unlockMountButton();
            }
         }
      }
      
      private function onStoreListSelect(e:GarageWindowEvent) : void
      {
         var itemId:String = e.itemId;
         this.storeSelectedItem = itemId;
         var params:ItemParams = itemsParams[itemId] as ItemParams;
         var itemType:ItemTypeEnum = params.itemType;
         this.garageWindow.showItemInfo(itemId,params,true);
      }
      
      private function onSetupClick(e:GarageWindowEvent) : void
      {
         if(!this.lockMount)
         {
            this.lockMount = true;
            Main.writeVarsToConsoleChannel("GARAGE MODEL","tryMountItem");
            this.tryMountItem(this.clientObject,this.warehouseSelectedItem);
         }
      }
      
      private function tryMountItem(client:ClientObject, id:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("garage;try_mount_item;" + id);
      }
      
      private function onBuyClick(e:GarageWindowEvent) : void
      {
         var itemParams:ItemParams = null;
         var previewId:String = null;
         var previewBd:BitmapData = null;
         if(!this.lockBuy)
         {
            this.itemWaitingForConfirmation = e.itemId;
            itemParams = itemsParams[e.itemId] as ItemParams;
            previewId = itemParams.previewId;
            previewBd = ResourceUtil.getResource(ResourceType.IMAGE,previewId + "_preview").bitmapData;
            this.showConfirmAlert(itemParams.name,itemParams.itemType == ItemTypeEnum.INVENTORY?int(itemParams.price * this.garageWindow.itemInfoPanel.inventoryNumStepper.value):int(itemParams.price),previewBd,true,itemParams.itemType == ItemTypeEnum.ARMOR || itemParams.itemType == ItemTypeEnum.WEAPON?int(0):int(-1),itemParams.itemType == ItemTypeEnum.INVENTORY?int(this.garageWindow.itemInfoPanel.inventoryNumStepper.value):int(-1));
         }
      }
	  
	  private function onUpClick(e:GarageWindowEvent) : void
      {
			//upg.show();
			Network(Main.osgi.getService(INetworker)).send("garage;mod;" + e.itemId);
			//upg.davay(1, new Array(1,2,3), new Array(4,5,6), new Array(7,8,9), 70000);
      }
      
      private function onUpgradeClick(e:GarageWindowEvent) : void
      {
         var itemParams:ItemParams = null;
         var mods:Array = null;
         var nextModIndex:int = 0;
         var modInfo:ModificationInfo = null;
         var previewId:String = null;
         var previewBd:BitmapData = null;
         if(!this.lockUpgrade)
         {
            this.itemWaitingForConfirmation = e.itemId;
            itemParams = itemsParams[e.itemId] as ItemParams;
            mods = itemParams.modifications;
            nextModIndex = itemParams.modificationIndex + 1;
            modInfo = ModificationInfo(mods[nextModIndex]);
            previewId = modInfo.previewId;
            previewBd = ResourceUtil.getResource(ResourceType.IMAGE,previewId + "_preview").bitmapData;
            this.showConfirmAlert(itemParams.name,itemParams.nextModificationPrice,previewBd,false,nextModIndex);
         }
      }
      
      private function showConfirmAlert(name:String, cost:int, previewBd:BitmapData, buyAlert:Boolean, modIndex:int, inventoryNum:int = -1) : void
      {
         Main.blur();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.confirmAlert = new ConfirmAlert(name,cost,previewBd,buyAlert,modIndex,!!buyAlert?localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_BUY_QEUSTION_TEXT):localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_UPGRADE_QEUSTION_TEXT),inventoryNum);
         this.dialogsLayer.addChild(this.confirmAlert);
         this.confirmAlert.confirmButton.addEventListener(MouseEvent.CLICK,!!buyAlert?this.onBuyAlertConfirm:this.onUpgradeAlertConfirm);
         this.confirmAlert.cancelButton.addEventListener(MouseEvent.CLICK,this.hideConfirmAlert);
         this.alignConfirmAlert();
         Main.stage.addEventListener(Event.RESIZE,this.alignConfirmAlert);
      }
      
      private function alignConfirmAlert(e:Event = null) : void
      {
         this.confirmAlert.x = Math.round((Main.stage.stageWidth - this.confirmAlert.width) * 0.5);
         this.confirmAlert.y = Math.round((Main.stage.stageHeight - this.confirmAlert.height) * 0.5);
      }
      
      private function hideConfirmAlert(e:MouseEvent = null) : void
      {
         Main.stage.removeEventListener(Event.RESIZE,this.alignConfirmAlert);
         this.dialogsLayer.removeChild(this.confirmAlert);
         Main.unblur();
         this.confirmAlert = null;
      }
      
      private function onBuyAlertConfirm(e:MouseEvent) : void
      {
         this.hideConfirmAlert();
         this.lockBuy = true;
         Main.writeVarsToConsoleChannel("GARAGE MODEL","tryBuyItem");
         if((itemsParams[this.itemWaitingForConfirmation] as ItemParams).itemType == ItemTypeEnum.INVENTORY)
         {
            this.tryBuyItem(this.clientObject,this.itemWaitingForConfirmation,this.garageWindow.itemInfoPanel.inventoryNumStepper.value);
         }
         else
         {
            this.tryBuyItem(this.clientObject,this.itemWaitingForConfirmation,1);
         }
      }
      
      public function tryBuyItem(c:ClientObject, id:String, count:int) : void
      {
         Network(Main.osgi.getService(INetworker)).send("garage;try_buy_item;" + id + ";" + count);
      }
      
      private function onUpgradeAlertConfirm(e:MouseEvent) : void
      {
         this.hideConfirmAlert();
         this.lockUpgrade = true;
         Main.writeVarsToConsoleChannel("GARAGE MODEL","tryUpgradeItem");
         this.tryUpgradeItem(this.clientObject,this.itemWaitingForConfirmation);
      }
      
      public function tryUpgradeItem(client:ClientObject, id:String) : void
      {
		 //throw new Error(id);
         this.currentItemForUpdate = id;
         Network(Main.osgi.getService(INetworker)).send("garage;try_update_item;" + id);
      }
      
      public function onBuyCrystalsClick(e:GarageWindowEvent) : void
      {
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.paymentLastInputValue = Math.abs(this.garageWindow.itemInfoPanel.requiredCrystalsNum);
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         storage.flush();
         this.panelModel.goToPayment();
      }
      
      public function mountItem(clientObject:ClientObject, itemToUnmountId:String, itemToMountId:String, p:String) : void
      {
         var index:int = 0;
         //Main.writeVarsToConsoleChannel("GARAGE MODEL","mountItem: " + (itemsParams[itemToMountId] as ItemParams).name);
         var bar3xQuickSet:Boolean = false;
         if(itemToUnmountId != null)
         {
            index = this.mountedItems.indexOf(itemToUnmountId);
            if(index != -1)
            {
               if(itemsParams[itemToUnmountId] != null)
               {
                  this.garageWindow.unmountItem(itemToUnmountId);
               }
               this.mountedItems.splice(index,1);
            }
         }
         else
         {
            bar3xQuickSet = true;
         }
         var params:ItemParams = itemsParams[itemToMountId];
         if(params != null && this.garageWindow != null)
         {
            this.garageWindow.mountItem(itemToMountId);
            this.mountedItems.push(itemToMountId);
            if(params.itemType == ItemTypeEnum.WEAPON || params.itemType == ItemTypeEnum.ARMOR || params.itemType == ItemTypeEnum.COLOR)
            {
               switch(params.itemType)
               {
                  case ItemTypeEnum.WEAPON:
                     this.mountedWeaponId = itemToMountId;
                     this.mountedWeaponInfo = itemsInfo[itemToMountId];
                     this.mountedWeaponParams = params;
                     this.setTurret(p);
                     break;
                  case ItemTypeEnum.ARMOR:
                     this.mountedArmorId = itemToMountId;
                     this.mountedArmorInfo = itemsInfo[itemToMountId];
                     this.mountedArmorParams = itemsParams[itemToMountId];
                     this.setHull(p);
                     break;
                  case ItemTypeEnum.COLOR:
                     this.mountedEngineId = itemToMountId;
                     this.mountedEngineInfo = itemsInfo[itemToMountId];
                     this.mountedEngineParams = itemsParams[itemToMountId];
                     this.setColorMap(ResourceUtil.getResource(ResourceType.IMAGE,itemToMountId) as ImageResouce);
               }
            }
         }
         else
         {
            this.itemsForMount.push(itemToMountId);
         }
         if(this.garageWindow.selectedItemId == itemToMountId)
         {
            this.garageWindow.lockMountButton();
         }
         this.lockMount = false;
      }
      
      public function buyItem(clientObject:ClientObject, info:ItemInfo) : void
      {
         var itemId:String = info.itemId;
		 trace(itemId);
         //Main.writeVarsToConsoleChannel("GARAGE MODEL","buyItem: " + (itemsParams[itemId] as ItemParams).name + "(" + info.itemId + ")");
         var p:ItemParams = this.items[itemId];
			trace(1 + " " + itemId);
            itemsInfo[itemId] = info;
			p.storei = false;
			this.garageWindow.warehouseList.update1(itemId);
            /*this.garageWindow.removeItemFromStore(itemId);
            this.garageWindow.addItemToWarehouse(itemId,p,info);
            this.garageWindow.unselectInStore();
            this.garageWindow.selectItemInWarehouse(itemId);*/
         this.garageWindow.scrollToItemInWarehouse(itemId);
		 if (itemId == "pro_battle_m0")
			   {
				   Lobby.haveSub = true;
			   }
         this.lockBuy = false;
      }
      
      public function upgradeItem(clientObject:ClientObject, oldItem:String, newItemInfo:ItemInfo) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE MODEL","upgradeItem oldItem: " + (itemsParams[oldItem] as ItemParams).name);
         Main.writeVarsToConsoleChannel("GARAGE MODEL","upgradeItem newItemInfo: " + newItemInfo);
         var newItem:String = newItemInfo.itemId;
         itemsInfo[newItem] = newItemInfo;
         this.garageWindow.removeItemFromWarehouse(oldItem);
         var index:int = this.mountedItems.indexOf(oldItem);
         if(index != -1)
         {
            this.mountedItems.splice(index,1);
         }
         var params:ItemParams = itemsParams[newItem];
         params.modificationIndex++;
         params.nextModificationPrice = params.modifications[params.modificationIndex >= 3?params.modificationIndex:params.modificationIndex + 1].crystalPrice;
         params.nextModificationProperties = params.modifications[params.modificationIndex >= 3?params.modificationIndex:params.modificationIndex + 1].itemProperties;
         params.nextModificationRankId = params.modifications[params.modificationIndex >= 3?params.modificationIndex:params.modificationIndex + 1].rankId;
         this.garageWindow.addItemToWarehouse(newItem,itemsParams[newItem],itemsInfo[newItem]);
         this.garageWindow.selectItemInWarehouse(newItem);
         this.warehouseSelectedItem = newItem;
         this.lockUpgrade = false;
         if(params.itemType == ItemTypeEnum.ARMOR || params.itemType == ItemTypeEnum.WEAPON)
         {
            this.tryMountItem(null,params.baseItemId);
         }
      }
      
      public function setHull(resource:String) : void
      {
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			this.garageWindow.tankPreview.setHull(resource);
		 }
      }
      
      public function setTurret(resource:String) : void
      {
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			this.garageWindow.tankPreview.setTurret(resource);
		 }
      }
      
      public function setColorMap(map:ImageResouce) : void
      {
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			this.garageWindow.tankPreview.setColorMap(map);
		 }
      }
      
      public function setTimeRemaining(itemId:String, time:Number) : void
      {
         var date:Date = new Date(time);
         Main.writeVarsToConsoleChannel("TIME INDICATOR"," incoming time " + time + " : " + date);
         if(this.garageWindow != null)
         {
            if(this.garageWindow.selectedItemId != null && !this.garageWindow.storeItemSelected && itemId == this.garageWindow.selectedItemId)
            {
               this.garageWindow.itemInfoPanel.timeRemaining = date;
            }
         }
      }
      
      public function effectStopped(itemId:String) : void
      {
         if(this.garageWindow != null)
         {
            this.garageWindow.removeItemFromWarehouse(itemId);
            if((itemsParams[itemId] as ItemParams).price > 0)
            {
               this.garageWindow.addItemToStore(itemId,itemsParams[itemId]);
               this.garageWindow.selectItemInStore(itemId);
               this.garageWindow.scrollToItemInStore(itemId);
            }
         }
      }
      
      private function showWindow() : void
      {
         if(!this.layer.contains(this.garageWindow))
         {
            Main.contentUILayer.addChild(this.garageWindow);
            Main.stage.addEventListener(Event.RESIZE, this.alignWindow);
			upg.addEventListener("Da",ll);
            this.alignWindow();
         }
      }
      
      private function hideWindow() : void
      {
		 if (this.garageWindow != null)
		 {
			 if(this.layer.contains(this.garageWindow))
			 {
				//throw new Error("df");
				this.garageWindow.hide();
				this.layer.removeChild(this.garageWindow);
				Main.stage.removeEventListener(Event.RESIZE, this.alignWindow);
				upg.addEventListener("Da",ll);
			 }
		 }
      }
	  
	  private function ll(e:Event = null) : void
      {
		 if (this.garageWindow.itemInfoPanel.type == ItemTypeEnum.COLOR)
		 {
			Network(Main.osgi.getService(INetworker)).send("garage;bymod;" + this.garageWindow.itemInfoPanel.nameTf.text + ";" + 0 + ";");
		 }else{
			Network(Main.osgi.getService(INetworker)).send("garage;bymod;" + this.garageWindow.itemInfoPanel.nameTf.text + ";" + ItemInfoPanel.por.modTable.selectedRowIndex + ";");
		 }
      }
      
      public function alignWindow(e:Event = null) : void
      {
         var minWidth:int = int(Math.max(100,Main.stage.stageWidth));
         this.garageWindow.resize(Math.round(minWidth * 2 / 3),Math.max(Main.stage.stageHeight - 60,530));
         this.garageWindow.x = Math.round(minWidth / 3);
         this.garageWindow.y = 60;
		 this.upg.resize();
		 this.upg.x = Math.round((Main.stage.stageWidth - this.upg.window.width) * 0.5);
         this.upg.y = Math.round((Main.stage.stageHeight - this.upg.window.height) * 0.5);
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var s:String = "\n";
         s = s + "\n   ARMOR: ";
         s = s + "\n";
         s = s + "\n   WEAPON: ";
         s = s + "\n";
         return s;
      }
      
      public function get dumperName() : String
      {
         return "mounted";
      }
      
      private function alignHelpers(e:Event = null) : void
      {
         var minWidth:int = int(Math.max(100,Main.stage.stageWidth));
         var minHeight:int = int(Math.max(60,Main.stage.stageHeight));
         this.warehouseHelper.targetPoint = new Point(Math.round(minWidth * (1 / 3)) + 20,minHeight - 169 * 2 + 27);
		 //this.warehouseHelper.targetPoint = new Point(0,minHeight - 169 * 2 + 27);
         this.storeHelper.targetPoint = new Point(Math.round(minWidth * (1 / 3)) + 20,minHeight - 169 + 27);
      }
   }
}
