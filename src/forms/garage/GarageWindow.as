package forms.garage
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import forms.friends.button.friends.NewRequestIndicator;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.model.ItemParams;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonModel;
   import alternativa.types.Long;
   import forms.garage.buttons.Centerr;
   import utils.client.commons.models.itemtype.ItemTypeEnum;
   import utils.client.garage.garage.ItemInfo;
   import controls.DefaultButton;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import forms.TankWindowWithHeader;
   import forms.events.PartsListEvent;
   import forms.garage.GarageWindowEvent;
   import forms.garage.ItemInfoPanel;
   import forms.garage.PartsList;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import forms.garage.TankPreview;
   
   public class GarageWindow extends Sprite
   {
       
      
      private var resourceRegister:IResourceService;
      
      private var modelRegister:IModelService;
      
      private var localeService:ILocaleService;
      
      public var windowSize:Point;
      
      private const windowMargin:int = 11;
      
      private const buttonSize:Point = new Point(104,33);
      
      private var myItemsWindow:TankWindow;
      
      private var myItemsInner:TankWindowInner;
      
      public var warehouseList:PartsList;
      
      public var itemInfoPanel:ItemInfoPanel;
      
      public var inventorySelected:Boolean;
      
      public var storeItemSelected:Boolean;
      
      public var selectedItemId:String = "";
      
      public var itemsInWarehouse:Array;
      
      public var tankPreview:TankPreview;
      
      public const itemInfoPanelWidth:int = 410;
      
      private var i:int = 0;
      
      private var j:int = 0;
	  
	  private var gmo:GarageModel;
	  
	  private var cens:Centerr = new Centerr();
	  
	  public var itms1:Array = new Array();
	  
	  public var itms2:Array = new Array();
	  
	  public var itms3:Array = new Array();
	  
	  public var itms4:Array = new Array();
	  
	  public var itms5:Array = new Array();
	  
	  public var itms6:Array = new Array();
	  
	  public var itms7:Array = new Array();
	  
	  public var itms8:Array = new Array();
	  
	  public var itms9:Array = new Array();
	  
	  public var itms10:Array = new Array();
	  
	  public var itms11:Array = new Array();
	  
	  public var itms12:Array = new Array();
      
      public function GarageWindow(garageBoxId:Long,gws:GarageModel)
      {
         super();
		 gmo = gws;
         this.resourceRegister = Main.osgi.getService(IResourceService) as IResourceService;
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.itemsInWarehouse = new Array();
         this.windowSize = new Point(880, 737);
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			this.tankPreview = new TankPreview(garageBoxId);
			addChild(this.tankPreview);
		 }
         this.itemInfoPanel = new ItemInfoPanel();
         addChild(this.itemInfoPanel);
         this.myItemsWindow = new TankWindow();
         addChild(this.myItemsWindow);
         this.myItemsInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.myItemsInner.showBlink = true;
         addChild(this.myItemsInner);
         this.warehouseList = new PartsList();
         addChild(this.warehouseList);
		 addChild(this.cens);
		 if (PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.closeButton.visible = false;
			PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.closeButton1.visible = true;
			(BattleController(Main.osgi.getService(IBattleController))).removeKeyboardListeners();
		 }
         this.warehouseList.addEventListener(PartsListEvent.SELECT_PARTS_LIST_ITEM,this.onWarehouseItemSelect);
         this.itemInfoPanel.buttonBuy.addEventListener(MouseEvent.CLICK, this.onButtonBuyClick);
         this.itemInfoPanel.buttonEquip.addEventListener(MouseEvent.CLICK,this.onButtonEquipClick);
         this.itemInfoPanel.buttonUpgrade.addEventListener(MouseEvent.CLICK, this.onModButtonClick);
		 cens.cn.addEventListener(MouseEvent.CLICK, c1);
		 cens.cn1.addEventListener(MouseEvent.CLICK, c2);
		 cens.cn2.addEventListener(MouseEvent.CLICK, c3);
		 cens.cn3.addEventListener(MouseEvent.CLICK, c4);
		 cens.cn4.addEventListener(MouseEvent.CLICK, c5);
         //this.itemInfoPanel.buttonBuyCrystals.addEventListener(MouseEvent.CLICK, this.onButtonBuyCrystalsClick);
		 resize(880, 737);
		 cens.cn1.enable = true;
		 cens.cn2.enable = true;
		 cens.cn3.enable = true;
		 cens.cn4.enable = true;
		 cens.cn.en();
      }
	  
	  private function c1(e:Event) : void//пушки
      {
		 cens.cn1.enable = true;
		 cens.cn2.enable = true;
		 cens.cn3.enable = true;
		 cens.cn4.enable = true;
		 cens.cn.en();
		 this.removeaItemFromWarehouse();
		 gmo.initMarket(null, this.itms6);
		 gmo.initDepot(null, this.itms12);
		 this.mountItem(gmo.mountedWeaponId);
		 this.selectItemInWarehouse(gmo.mountedWeaponId);
		 resize(windowSize.x,windowSize.y);
      }
	  
	  private function c2(e:Event) : void//корпуса
      {
		 cens.cn.enable = true;
		 cens.cn2.enable = true;
		 cens.cn3.enable = true;
		 cens.cn4.enable = true;
		 cens.cn1.en();
		 this.removeaItemFromWarehouse();
		 gmo.initMarket(null, this.itms1);
		 gmo.initDepot(null, this.itms7);
		 this.mountItem(gmo.mountedArmorId);
		 this.selectItemInWarehouse(gmo.mountedArmorId);
		 resize(windowSize.x,windowSize.y);
      }
	  
	  private function c3(e:Event) : void//краски
      {
		 cens.cn1.enable = true;
		 cens.cn3.enable = true;
		 cens.cn.enable = true;
		 cens.cn4.enable = true;
		 cens.cn2.en();
		 this.removeaItemFromWarehouse();
		 gmo.initMarket(null, this.itms2);
		 gmo.initDepot(null, this.itms8);
		 this.mountItem(gmo.mountedEngineId);
		 this.selectItemInWarehouse(gmo.mountedEngineId);
		 resize(windowSize.x,windowSize.y);
      }
	  
	  private function c4(e:Event) : void
      {
		 cens.cn1.enable = true;
		 cens.cn2.enable = true;
		 cens.cn4.enable = true;
		 cens.cn.enable = true;
		 cens.cn3.en();
		 this.removeaItemFromWarehouse();
		 gmo.initMarket(null, this.itms3);
		 gmo.initDepot(null, this.itms9);
		 gmo.initMarket(null, this.itms5);
		 gmo.initDepot(null, this.itms11);
		 resize(windowSize.x,windowSize.y);
      }
	  
	  private function c5(e:Event) : void
      {
		 cens.cn1.enable = true;
		 cens.cn2.enable = true;
		 cens.cn3.enable = true;
		 cens.cn.enable = true;
		 cens.cn4.en();
		 this.removeaItemFromWarehouse();
		 gmo.initMarket(null, this.itms4);
		 resize(windowSize.x,windowSize.y);
      }
      
      public function hide() : void
      {
		 if (this.tankPreview != null)
		 {
			 this.tankPreview.hide();
		 }
         this.itemInfoPanel.hide();
         this.tankPreview = null;
         this.itemInfoPanel = null;
         this.resourceRegister = null;
         this.modelRegister = null;
         this.myItemsWindow = null;
         this.myItemsInner = null;
         this.warehouseList = null;
         this.selectedItemId = null;
         this.itemsInWarehouse = null;
      }
      
      public function resize(width:int, height:int) : void
      {
         var leftHeaderWidth:int = 0;
         this.windowSize = new Point(width,height);
         leftHeaderWidth = (int(Math.max(100,Main.stage.stageWidth)))/3;
         this.myItemsWindow.height = 205; 
		 this.myItemsInner.height = 169 - this.windowMargin * 2;
		 this.warehouseList.height = 169 - this.windowMargin * 2 + 1;
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			this.tankPreview.resize(width - itemInfoPanelWidth, height - this.myItemsWindow.height, this.x, this.y);
			this.myItemsWindow.width = width;
			this.myItemsInner.width = width - this.windowMargin * 2;
			this.myItemsInner.x = this.windowMargin;
			this.warehouseList.width = this.myItemsWindow.width - this.windowMargin * 2 - 8;
			this.warehouseList.x = this.windowMargin + 4;
			this.cens.x = this.windowMargin + 4;
		 }else{
			this.myItemsWindow.width = width + leftHeaderWidth;
			this.myItemsWindow.x = -leftHeaderWidth;
			this.myItemsInner.width = width - this.windowMargin * 2 + leftHeaderWidth;
			this.myItemsInner.x = this.windowMargin - leftHeaderWidth;
			this.warehouseList.width = this.myItemsWindow.width - this.windowMargin * 2 - 8;
			this.warehouseList.x = this.windowMargin + 4 - leftHeaderWidth;
			this.cens.x = this.windowMargin + 4 - leftHeaderWidth;
		 }
         this.itemInfoPanel.resize(itemInfoPanelWidth,height - this.myItemsWindow.height);
         this.itemInfoPanel.x = width - itemInfoPanelWidth;
         this.myItemsWindow.y = height - this.myItemsWindow.height;
         this.myItemsInner.y = this.myItemsWindow.y + 12;
         this.warehouseList.y = this.myItemsInner.y + 4;
		 this.cens.y = this.warehouseList.y + this.warehouseList.height;
      }
      
      public function selectFirstItemInWarehouse() : void
      {
         this.warehouseList.selectByIndex(0);
      }
      
      public function selectItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.select(itemId);
      }
      
      public function unselectInWarehouse() : void
      {
         this.warehouseList.unselect();
      }
      
      public function selectItemInStore(itemId:String) : void
      {
      }
      
      public function unselectInStore() : void
      {
      }
      
      public function addItemToWarehouse(itemId:String, itemParams:ItemParams, itemInfo:ItemInfo) : void
      {
         this.itemsInWarehouse.push(itemId);
         var previewBd:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, itemId + "_preview").bitmapData;
		 if (itemInfo != null)
		 {
			 if (itemParams.itemType.value == 5)
			 {
				this.warehouseList.addItem(itemId,itemParams.name,4,itemParams.itemIndex,itemParams.price,itemParams.rankId,false,true,itemInfo.count,previewBd,true,itemParams.modificationIndex);
			 }else{
				this.warehouseList.addItem(itemId,itemParams.name,itemParams.itemType.value,itemParams.itemIndex,itemParams.price,itemParams.rankId,false,true,itemInfo.count,previewBd,true,itemParams.modificationIndex);
			 }
		 }else{
			 var panelModel:IPanel = Main.osgi.getService(IPanel) as IPanel;
			 var userRank:int = panelModel.rank;
			 if (itemParams.itemType.value == 5)
			 {
				this.warehouseList.addItem(itemId, itemParams.name, 4, itemParams.itemIndex, itemParams.price, (userRank >= itemParams.rankId?int(0):int(itemParams.rankId)), false, false, 0, previewBd,false, 0);
			 }else{
				this.warehouseList.addItem(itemId, itemParams.name, itemParams.itemType.value, itemParams.itemIndex, itemParams.price, userRank >= itemParams.rankId?int(0):int(itemParams.rankId), false, false, 0, previewBd,false, 0);
			 }
		 }
      }
      
      public function addItemToStore(itemId:String, itemParams:ItemParams) : void
      {

      }
      
      public function removeItemFromWarehouse(itemId:String) : void
      {
         this.warehouseList.deleteItem(itemId);
         var index:int = this.itemsInWarehouse.indexOf(itemId);
         this.itemsInWarehouse.splice(index,1);
      }
	  
	  public function removeaItemFromWarehouse() : void
      {
		 removeChild(this.warehouseList);
		 this.warehouseList = new PartsList();
		 addChild(this.warehouseList);
		 this.warehouseList.addEventListener(PartsListEvent.SELECT_PARTS_LIST_ITEM,this.onWarehouseItemSelect);
		 this.itemsInWarehouse = new Array();
      }
	  
	  public function removeaItemFromStore() : void
      {
      }
      
      public function removeItemFromStore(itemId:String) : void
      {
      }
      
      public function lockItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.lock(itemId);
      }
      
      public function unlockItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.unlock(itemId);
      }
      
      public function lockItemInStore(itemId:String) : void
      {
      }
      
      public function unlockItemInStore(itemId:String) : void
      {
      }
      
      public function unmountItem(itemId:String) : void
      {
         this.warehouseList.unmount(itemId);
      }
      
      public function mountItem(itemId:String) : void
      {
         this.warehouseList.mount(itemId);
      }
      
      public function showItemInfo(itemId:String, itemParams:ItemParams, storeItem:Boolean, itemInfo:ItemInfo = null) : void
      {
         this.storeItemSelected = storeItem;
         this.inventorySelected = itemParams.itemType == ItemTypeEnum.INVENTORY;
         if(itemParams.inventoryItem && itemInfo != null && !storeItem)
         {
            this.warehouseList.updateCount(itemInfo.itemId,itemInfo.count);
         }
         this.itemInfoPanel.showItemInfo(itemId, itemParams, storeItem, itemInfo);
		 this.itemInfoPanel.resize(itemInfoPanelWidth, windowSize.y - 205);
		 //this.resize(windowSize.x,windowSize.y);
         //this.itemInfoPanel.resize(this.tankPreview.width,this.windowSize.y - this.myItemsWindow.height - this.shopItemsWindow.height);
      }
      
      public function showOtherItemInfo(lastSelectedItemId:Long) : void
      {
         var index:int = this.itemsInWarehouse.indexOf(lastSelectedItemId);
         if(this.itemsInWarehouse[int(index + 1)] != null)
         {
            this.selectedItemId = this.itemsInWarehouse[int(index + 1)];
            this.warehouseList.select(this.selectedItemId);
         }
         else if(this.itemsInWarehouse[int(index - 1)] != null)
         {
            this.selectedItemId = this.itemsInWarehouse[int(index - 1)];
            this.warehouseList.select(this.selectedItemId);
         }
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED,this.selectedItemId));
      }
      
      public function updateItemInfo(itemId:Long, itemInfo:ItemInfo, itemParams:ItemParams) : void
      {
         if(itemParams.inventoryItem)
         {
            this.warehouseList.updateCount(itemId,itemInfo.count);
         }
      }
      
      public function scrollToItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.scrollTo(itemId);
      }
      
      public function scrollToItemInStore(itemId:String) : void
      {
      }
      
      public function lockBuyButton() : void
      {
         this.itemInfoPanel.buttonBuy.enable = false;
      }
      
      public function lockUpgradeButton() : void
      {
         this.itemInfoPanel.buttonUpgrade.enable = false;
      }
      
      public function lockMountButton() : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","lockMountButton storeItemSelected: " + this.storeItemSelected);
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","lockMountButton inventorySelected: " + this.inventorySelected);
         if(!this.storeItemSelected && !this.inventorySelected)
         {
            this.itemInfoPanel.buttonEquip.enable = false;
         }
      }
      
      public function unlockBuyButton1() : void
      {
         this.itemInfoPanel.buttonBuy.enable = true;
      }
      
      public function unlockUpgradeButton() : void
      {
         this.itemInfoPanel.buttonUpgrade.enable = true;
      }
      
      public function unlockMountButton() : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","unlockMountButton storeItemSelected: " + this.storeItemSelected);
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","unlockMountButton inventorySelected: " + this.inventorySelected);
         if(!this.storeItemSelected && !this.inventorySelected)
         {
            this.itemInfoPanel.buttonEquip.enable = true;
         }
      }
      
      public function setMountButtonInfo(icon:BitmapData) : void
      {
         this.itemInfoPanel.buttonEquip.icon = icon;
      }
      
      public function setBuyButtonInfo(reset:Boolean, crystal:int = 0, rank:int = 0) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","setBuyButtonInfo reset: %1, crystal: %2, rank: %3",reset,crystal,rank);
         if(reset)
         {
            this.itemInfoPanel.buttonBuy.icon = null;
         }
         else
         {
            this.itemInfoPanel.buttonBuy.setInfo(crystal,rank);
         }
      }
      
      private function onWarehouseItemSelect(e:Event) : void
      {
         this.selectedItemId = this.warehouseList.selectedItemID as String;
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED,this.selectedItemId));
      }
      
      private function onButtonBuyClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.BUY_ITEM,this.selectedItemId));
      }
	  
	  private function onButtonUpClick(e:MouseEvent) : void
      {
		 if (itemInfoPanel.type == ItemTypeEnum.COLOR)
		 {
			dispatchEvent(new GarageWindowEvent(GarageWindowEvent.UP_ITEM, itemInfoPanel.nameTf.text + ";" + 0 + ";"));
		 }else{
			dispatchEvent(new GarageWindowEvent(GarageWindowEvent.UP_ITEM, itemInfoPanel.nameTf.text + ";" + ItemInfoPanel.por.modTable.selectedRowIndex + ";"));
		 }
      }
      
     // private function onButtonBuyCrystalsClick(e:MouseEvent) : void
      //{
         //dispatchEvent(new GarageWindowEvent(GarageWindowEvent.ADD_CRYSTALS,this.selectedItemId));
      //}
      
      private function onButtonEquipClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.SETUP_ITEM,this.selectedItemId));
      }
      
      private function onModButtonClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.UPGRADE_ITEM,this.selectedItemId));
      }
   }
}
