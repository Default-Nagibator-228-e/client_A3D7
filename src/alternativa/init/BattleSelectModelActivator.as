package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.BattleSelectModel;
   
   public class BattleSelectModelActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      public var battleSelectModel:BattleSelectModel;
      
      public function BattleSelectModelActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         BattleSelectModelActivator.osgi = osgi;
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         this.battleSelectModel = new BattleSelectModel();
         modelRegister.add(this.battleSelectModel);
      }
      
      public function stop(osgi:OSGi) : void
      {
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         modelRegister.remove(this.battleSelectModel.id);
         this.battleSelectModel = null;
         BattleSelectModelActivator.osgi = null;
      }
   }
}
