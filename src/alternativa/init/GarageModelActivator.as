package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.Item3DModel;
   import alternativa.tanks.model.ItemEffectModel;
   import alternativa.tanks.model.ItemModel;
   
   public class GarageModelActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      public var garageModel:GarageModel;
      
      public var itemModel:ItemModel;
      
      public var item3DModel:Item3DModel;
      
      public var itemEffectModel:ItemEffectModel;
      
      public function GarageModelActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         GarageModelActivator.osgi = osgi;
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         this.garageModel = new GarageModel();
         modelRegister.add(this.garageModel);
         this.itemModel = new ItemModel();
         modelRegister.add(this.itemModel);
         this.item3DModel = new Item3DModel();
         modelRegister.add(this.item3DModel);
         this.itemEffectModel = new ItemEffectModel();
         modelRegister.add(this.itemEffectModel);
      }
      
      public function stop(osgi:OSGi) : void
      {
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         modelRegister.remove(this.garageModel.id);
         modelRegister.remove(this.itemModel.id);
         modelRegister.remove(this.itemEffectModel.id);
         this.garageModel = null;
         this.itemModel = null;
         this.item3DModel = null;
         this.itemEffectModel = null;
         GarageModelActivator.osgi = null;
      }
   }
}
