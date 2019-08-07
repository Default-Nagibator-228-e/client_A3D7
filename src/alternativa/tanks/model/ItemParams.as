package alternativa.tanks.model
{
   import utils.client.commons.models.itemtype.ItemTypeEnum;
   
   public class ItemParams
   {
       
      
      public var baseItemId:String;
      
      public var description:String;
      
      public var inventoryItem:Boolean;
	  
	  public var XT:Boolean = true;
	  
	  public var nameXT:String = "Рельса ХТ";
	  
	  public var dXT:String = "Это специальная версия рельсы";
      
      public var itemIndex:int;
      
      public var itemProperties:Array;
      
      public var itemType:ItemTypeEnum;
      
      public var modificationIndex:int;
      
      public var name:String;
      
      public var nextModificationPrice:int;
      
      public var nextModificationProperties:Array;
      
      public var nextModificationRankId:int;
      
      public var previewId:String;
      
      public var price:int;
      
      public var rankId:int;
      
      public var modifications:Array;
	  
	  public var storei:Boolean;
      
      public function ItemParams(baseItemId:String, description:String, inventoryItem:Boolean, itemIndex:int, itemProperties:Array, itemType:ItemTypeEnum, modificationIndex:int, name:String, nextModificationPrice:int, nextModificationProperties:Array, nextModificationRankId:int, previewId:String, price:int, rankId:int, modifications:Array,nX:String, dX:String, T:Boolean, store:Boolean)
      {
         super();
         this.baseItemId = baseItemId;
         this.description = description;
         this.inventoryItem = inventoryItem;
         this.itemIndex = itemIndex;
         this.itemProperties = itemProperties;
         this.itemType = itemType;
         this.modificationIndex = modificationIndex;
         this.name = name;
         this.nextModificationPrice = nextModificationPrice;
         this.nextModificationProperties = nextModificationProperties;
         this.nextModificationRankId = nextModificationRankId;
         this.previewId = previewId;
         this.price = price;
         this.rankId = rankId;
         this.modifications = modifications;
		 dXT = dX;
		 nameXT = nX;
		 XT = T;
		 storei = store;
      }
   }
}
