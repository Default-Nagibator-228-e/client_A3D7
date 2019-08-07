package forms.garage
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import forms.garage.ItemPropertyIcon;
   import forms.garage.ModInfoRow;
   import forms.itemscategory.Proporit;
   import forms.itemcategoriesview.ItemCategoriesView;
   import forms.itemscategory.ItemsCategoryView;
   import forms.itemscategory.Ski;
   import forms.shop.components.item.GridItemBase;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IItemEffect;
   import alternativa.tanks.model.ItemParams;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.user.IUserData;
   import alternativa.tanks.model.user.UserData;
   import alternativa.types.Long;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import utils.client.commons.models.itemtype.ItemTypeEnum;
   import utils.client.commons.types.ItemProperty;
   import utils.client.garage.garage.ItemInfo;
   import utils.client.garage.item.ItemPropertyValue;
   import utils.client.garage.item.ModificationInfo;
   import controls.Label;
   import controls.NumStepper;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldType;
   import forms.TankWindowWithHeader;
   import forms.garage.GarageButton;
   import forms.garage.GarageRenewalButton;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class ItemInfoPanel extends Sprite
   {
      
      public static const INVENTORY_MAX_VALUE:int = 9999;
      
      public static const INVENTORY_MIN_VALUE:int = 1;
       
      
      private var resourceRegister:IResourceService;
      
      private var modelRegister:IModelService;
      
      private var localeService:ILocaleService;
      
      private var panelModel:IPanel;
      
      private var window:TankWindowWithHeader;
      
      public var size:Point;
      
      public const margin:int = 11;
      
      private const bottomMargin:int = 64;
            
      private var preview:Bitmap;
      
      private var previewVisible:Boolean;
      
      public var nameTf:Label = new Label();
	  
	  public var named:Label;
	  
	  public static var sk:Ski;
      
      public var descrTf:Label;
      
      public var buttonBuy:GarageButton;
      
      public var buttonEquip:GarageButton;
      
      public var buttonUpgrade:GarageButton;
      
      //public var buttonBuyCrystals:GarageRenewalButton;
      
      public var inventoryNumStepper:NumStepper;
      
      private const buttonSize:Point = new Point(120,50);
      
      private const iconSpace:int = 10;
      
      private var id:String;
      
      private var params:ItemParams;
      
      private var info:ItemInfo;
      
      public var type:ItemTypeEnum;
      
      private var upgradeProperties:Array;
      
      private var area:Shape;
      
      private var area2:Shape;
      
      private var areaRect:Rectangle;
      
      private var areaRect2:Rectangle;
      
      private var horizMargin:int = 12;
      
      private var vertMargin:int = 9;
      
      private var spaceModule:int = 3;
      
      private var cutPreview:int = 0;
      
      private var hidePreviewLimit:int = 275;
      
      private var timeIndicator:Label;
      
      public var requiredCrystalsNum:int;
	  
	  public var cat:ItemCategoriesView = new ItemCategoriesView();
	  
	  public static var por:Proporit;
      
      public function ItemInfoPanel()
      {
         super();
         this.resourceRegister = Main.osgi.getService(IResourceService) as IResourceService;
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.size = new Point(400,300);
         this.window = TankWindowWithHeader.createWindow("ИНФОРМАЦИЯ");
         addChild(this.window);
         var userModel:UserData = Main.osgi.getService(IUserData) as UserData;
         var userName:String = userModel.name;
         this.preview = new Bitmap();
         this.buttonBuy = new GarageButton();
         this.buttonEquip = new GarageButton();
         this.buttonUpgrade = new GarageButton();
         this.buttonBuy.icon = null;
         this.buttonBuy.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_BUY_TEXT);
         this.buttonEquip.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_EQUIP_TEXT);
         this.buttonUpgrade.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_UPGRADE_TEXT);
		 addChild(this.cat);
         addChild(this.buttonBuy);
         addChild(this.buttonEquip);
         addChild(this.buttonUpgrade);
         this.inventoryNumStepper = new NumStepper();
         addChild(this.inventoryNumStepper);
         this.inventoryNumStepper.value = 1;
         this.inventoryNumStepper.minValue = 1;
         this.inventoryNumStepper.maxValue = ItemInfoPanel.INVENTORY_MAX_VALUE;
         this.inventoryNumStepper.visible = false;
         this.inventoryNumStepper.addEventListener(Event.CHANGE,this.inventoryNumChanged);
         this.timeIndicator = new Label();
         this.timeIndicator.size = 18;
         this.timeIndicator.color = 381208;
      }
      
      public function hide() : void
      {
         this.resourceRegister = null;
         this.modelRegister = null;
         this.panelModel = null;
         this.window = null;
         this.id = null;
         this.type = null;
         this.upgradeProperties = null;
         this.buttonBuy = null;
         this.buttonEquip = null;
         this.buttonUpgrade = null;
      }
      
      /*private function hideAllIcons() : void
      {
         var icon:DisplayObject = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","hideAllIcons");
         for(var i:int = 0; i < visibleIcons.length; i++)
         {
            icon = visibleIcons[i] as DisplayObject;
            if(this.propertiesPanel.contains(icon))
            {
               this.propertiesPanel.removeChild(icon);
            }
         }
      }
      
      private function showIcons() : void
      {
         var icon:DisplayObject = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","showIcons");
         for(var i:int = 0; i < visibleIcons.length; i++)
         {
            icon = visibleIcons[i] as DisplayObject;
            if(!this.propertiesPanel.contains(icon))
            {
               this.propertiesPanel.addChild(icon);
            }
            icon.visible = true;
         }
      }*/
      
      public function showItemInfo(itemId:String, itemParams:ItemParams, storeItem:Boolean, itemInfo:ItemInfo = null) : void
      {
         var i:int = 0;
         var p:ItemPropertyValue = null;
         var mods:Array = null;
         var text:Array = null;
         var m:int = 0;
         var modInfo:ModificationInfo = null;
         var row:ModInfoRow = null;
         var maxWidth:int = 0;
         var modProperties:Array = null;
         var rank:int = 0;
         var cost:int = 0;
         var acceptableNum:int = 0;
         var itemEffectModel:IItemEffect = null;
         //Main.writeVarsToConsoleChannel("GARAGE WINDOW"," ");
         //Main.writeVarsToConsoleChannel("GARAGE WINDOW","showItemInfooooo (itemId: %1)",itemId);
         this.id = itemId;
         this.type = itemParams.itemType;
         this.params = itemParams;
         this.info = itemInfo;
		 storeItem = itemParams.storei;
		 this.cat.removea();
		 var f:Long = new Long(0,1);
		 var dsf:ItemsCategoryView = new ItemsCategoryView(itemParams.name, "", f);
         this.nameTf.text = itemParams.name;
         //this.descrTf.text = itemParams.description;
         var previewBd:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,itemId + "_preview").bitmapData;
         this.preview.bitmapData = previewBd;
         var showProperties:Boolean = !(this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON);
		 var gy:Boolean = (this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON || this.type == ItemTypeEnum.COLOR);
		 if (gy)
		 {
			 por = new Proporit(itemParams.itemProperties, itemParams, showProperties);
			dsf.addItem(por);
		 }
		 this.cat.addCategory(dsf);
		 if (gy && itemParams.XT && !storeItem)
		 {
			var dsfg:ItemsCategoryView = new ItemsCategoryView("Улучшения", "", new Long(0, 1));
			sk = new Ski(itemParams.nameXT, itemParams.dXT, itemId);
			dsfg.addItem(sk);
			this.cat.addCategory(dsfg);
		 }
		 if (gy)
		 {
			this.cat.addCategory(new ItemsCategoryView("Описание", itemParams.description, new Long(0, 1)));
		 }else{
			var dse:ItemsCategoryView = new ItemsCategoryView("", itemParams.description, new Long(0, 1));
			var fr:GridItemBase = new GridItemBase();
			fr.addChild(this.preview);
			this.cat.addItem(f,fr);
			this.cat.addCategory(dse);
		 }
         if(storeItem)
         {
            this.buttonBuy.visible = true;
            this.buttonEquip.visible = false;
            this.buttonUpgrade.visible = false;
         }else{
			switch(this.type)
			 {
				 case ItemTypeEnum.INVENTORY:
					this.buttonBuy.visible = true;
					this.buttonEquip.visible = false;
					this.buttonUpgrade.visible = false;
				   break;
				 case ItemTypeEnum.PLUGIN:
					this.buttonBuy.visible = false;
					this.buttonEquip.visible = false;
					this.buttonUpgrade.visible = false;
				   break;
				 case ItemTypeEnum.ARMOR:
					this.buttonBuy.visible = false;
					this.buttonEquip.visible = true;
					this.buttonUpgrade.visible = itemParams.modificationIndex < 3;
				   break;
				 case ItemTypeEnum.WEAPON:
					this.buttonBuy.visible = false;
					this.buttonEquip.visible = true;
					this.buttonUpgrade.visible = itemParams.modificationIndex < 3;
				   break;
				 case ItemTypeEnum.COLOR:
					this.buttonBuy.visible = false;
					this.buttonEquip.visible = true;
					this.buttonUpgrade.visible = false;
			 }
         }
         if(this.buttonBuy.visible)
         {
            rank = this.panelModel.rank >= this.params.rankId?int(this.params.rankId):int(-this.params.rankId);
            if(this.type == ItemTypeEnum.INVENTORY)
            {
               cost = this.panelModel.crystal >= this.inventoryNumStepper.value * this.params.price?int(this.inventoryNumStepper.value * this.params.price):int(-this.inventoryNumStepper.value * this.params.price);
               this.inventoryNumStepper.visible = true;
               acceptableNum = Math.min(ItemInfoPanel.INVENTORY_MAX_VALUE,Math.floor(this.panelModel.crystal / this.params.price));
               if(rank > 0)
               {
                  if(acceptableNum > 0)
                  {
                     this.inventoryNumStepper.enabled = true;
                     this.inventoryNumStepper.alpha = 1;
                  }
                  else
                  {
                     this.inventoryNumStepper.enabled = false;
                     this.inventoryNumStepper.alpha = 0.7;
                  }
               }
               else
               {
                  this.inventoryNumStepper.enabled = false;
                  this.inventoryNumStepper.alpha = 0.7;
               }
            }
            else
            {
               cost = this.panelModel.crystal >= this.params.price?int(this.params.price):int(-this.params.price);
               this.inventoryNumStepper.visible = false;
            }
            this.buttonBuy.setInfo(cost,rank);
            this.buttonBuy.enable = cost >= 0;
            if(rank > 0 && cost < 0)
            {
               this.requiredCrystalsNum = this.panelModel.crystal + cost;
            }
         }
         else if(this.buttonUpgrade.visible)
         {
            this.inventoryNumStepper.visible = false;
            cost = this.params.nextModificationPrice > this.panelModel.crystal?int(-this.params.nextModificationPrice):int(this.params.nextModificationPrice);
            rank = this.panelModel.rank >= this.params.nextModificationRankId?int(this.params.nextModificationRankId):int(-this.params.nextModificationRankId);
            this.buttonUpgrade.setInfo(cost,rank);
            this.buttonUpgrade.enable = cost > 0 && rank > 0;
            if(this.params.nextModificationPrice > this.panelModel.crystal && this.panelModel.rank >= this.params.nextModificationRankId)
            {
               this.requiredCrystalsNum = this.panelModel.crystal + cost;
            }
         }
         else
         {
            this.inventoryNumStepper.visible = false;
         }
         //this.posButtons();
         if(this.type == ItemTypeEnum.PLUGIN && !storeItem)
         {
            itemEffectModel = (this.modelRegister.getModelsByInterface(IItemEffect) as Vector.<IModel>)[0] as IItemEffect;
            this.timeRemaining = new Date(itemEffectModel.getTimeRemaining(itemId));
         }
      }
      
      private function posButtons() : void
      {
         var buttonY:int = this.size.y - this.margin - this.buttonSize.y + 1;
         if(this.buttonBuy.visible)
         {
            this.buttonBuy.y = buttonY;
            if(this.type == ItemTypeEnum.INVENTORY)
            {
               this.inventoryNumStepper.x = -7;
               this.inventoryNumStepper.y = this.buttonBuy.y + Math.round((this.buttonSize.y - this.inventoryNumStepper.height) * 0.5);
               this.buttonBuy.x = this.inventoryNumStepper.x + this.inventoryNumStepper.width + 10;
            }
            else
            {
               this.buttonBuy.x = this.margin;
            }
         }
         if(this.buttonEquip.visible)
         {
            this.buttonEquip.y = buttonY;
            this.buttonEquip.x = this.size.x - this.margin - this.buttonSize.x;
         }
         if(this.buttonUpgrade.visible)
         {
            this.buttonUpgrade.y = buttonY;
            this.buttonUpgrade.x = this.margin;
         }
      }
      
      public function resize(width:int, height:int) : void
      {
         var minContainerHeight:int = 0;
         var iconsNum:int = 0;
         var iconY:int = 0;
         var iconsWidth:int = 0;
         var summWidth:int = 0;
         var leftMargin:int = 0;
         var coords:Array = null;
         var i:int = 0;
         var icon:ItemPropertyIcon = null;
         var m:int = 0;
         var row:ModInfoRow = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemInfoPanel resize width: %1, height: %2",width,height);
         this.size.x = width;
         this.size.y = height;
         this.window.width = width;
         this.window.height = height;
		 this.cat.x = this.margin;
		 this.cat.y = this.margin;
		 this.cat.render(width - this.margin * 2,height - this.margin - this.bottomMargin);
         this.posButtons();
      }
      
      public function hidePreview() : void
      {
         /*if(this.scrollContainer.contains(this.preview))
         {
            this.scrollContainer.removeChild(this.preview);
         }*/
      }
      
      public function showPreview() : void
      {
         var previewId:String = null;
         var previewBd:BitmapData = null;
         /*if(!this.scrollContainer.contains(this.preview))
         {
            this.scrollContainer.addChild(this.preview);
            if(this.id != null)
            {
               previewId = (GarageModel.getItemParams(this.id) as ItemParams).previewId;
               if(previewId != null)
               {
                  previewBd = ResourceUtil.getResource(ResourceType.IMAGE,previewId + "_preview").bitmapData;
                  if(previewBd != null)
                  {
                     this.preview.bitmapData = previewBd;
                  }
               }
            }
         }*/
      }
      
      public function set timeRemaining(time:Date) : void
      {
         var dataString:String = null;
         Main.writeVarsToConsoleChannel("TIME INDICATOR"," ");
         var timeString:String = (time.hours < 10?"0" + String(time.hours):String(time.hours)) + ":" + (time.minutes < 10?"0" + String(time.minutes):String(time.minutes));
         var monthString:String = time.month + 1 < 10?"0" + String(time.month + 1):String(time.month + 1);
         var dayString:String = time.date < 10?"0" + String(time.date):String(time.date);
         if(this.localeService.getText(TextConst.GUI_LANG) == "ru")
         {
            dataString = dayString + "-" + monthString + "-" + String(time.fullYear);
         }
         else
         {
            dataString = monthString + "-" + dayString + "-" + String(time.fullYear);
         }
         this.timeIndicator.text = dayString != "NaN"?timeString + "  " + dataString:" ";
         Main.writeVarsToConsoleChannel("TIME INDICATOR","set remainingDate: " + timeString + " " + dataString);
         this.resize(this.size.x,this.size.y);
      }
      
      private function inventoryNumChanged(e:Event = null) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","inventoryNumChanged");
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","totalPrice: " + this.params.price * this.inventoryNumStepper.value);
         var rank:int = this.panelModel.rank >= this.params.rankId?int(this.params.rankId):int(-this.params.rankId);
         var cost:int = this.panelModel.crystal >= this.params.price * this.inventoryNumStepper.value?int(this.params.price * this.inventoryNumStepper.value):int(-this.params.price * this.inventoryNumStepper.value);
         this.buttonBuy.setInfo(cost,rank);
         this.buttonBuy.enable = cost >= 0 && rank > 0;
         if(rank > 0 && cost < 0)
         {
            this.requiredCrystalsNum = this.panelModel.crystal + cost;
            //this.buttonBuyCrystals.visible = true;
            //this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum,this.requiredCrystalsNum * GarageModel.buyCrystalRate);
         }
         else
         {
            //this.buttonBuyCrystals.visible = false;
         }
         this.posButtons();
      }
   }
}
