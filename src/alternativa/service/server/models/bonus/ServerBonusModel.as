package alternativa.service.server.models.bonus
{
   import alternativa.init.Main;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.bonus.BonusModel;
   import utils.client.panel.model.bonus.BonusItem;
   import utils.client.panel.model.bonus.IBonusModelBase;
   
   public class ServerBonusModel
   {
       
      
      private var model:BonusModel;
      
      private var modelsService:IModelService;
      
      public function ServerBonusModel()
      {
         super();
         this.modelsService = IModelService(Main.osgi.getService(IModelService));
         this.model = BonusModel(this.modelsService.getModelsByInterface(IBonusModelBase)[0]);
      }
      
      public function showBonuses(data:String) : void
      {
         var item:Object = null;
         var bonusItem:BonusItem = null;
         var array:Array = new Array();
         var parser:Object = JSON.parse(data);
         var i:int = 0;
         for each(item in parser.items)
         {
            bonusItem = new BonusItem(item.id);
            bonusItem.count = item.count;
            array[i] = bonusItem;
            i++;
         }
         this.model.showBonuses(null,array,"RU");
      }
      
      public function showCrystalls(count:int) : void
      {
         this.model.showCrystals(null,count,null);
      }
   }
}
