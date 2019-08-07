package alternativa.osgi
{
   import alternativa.init.OSGi;
   import utils.client.models.IModel;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.service.IModelService;
   
   public class CommonBundleActivator implements IBundleActivator
   {
       
      
      protected var models:Vector.<IModel>;
      
      public function CommonBundleActivator()
      {
         this.models = new Vector.<IModel>();
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
      }
      
      public function stop(osgi:OSGi) : void
      {
         var model:IModel = null;
         var bundleListener:IBundleListener = null;
         var modelService:IModelService = IModelService(osgi.getService(IModelService));
         while((model = this.models.pop()) != null)
         {
            bundleListener = model as IBundleListener;
            if(bundleListener != null)
            {
               bundleListener.bundleStop();
            }
            modelService.remove(model.id);
         }
      }
      
      protected function registerModel(model:IModel, osgi:OSGi) : void
      {
         var modelService:IModelService = IModelService(osgi.getService(IModelService));
         modelService.add(model);
         this.models.push(model);
         var bundleListener:IBundleListener = model as IBundleListener;
         if(bundleListener != null)
         {
            bundleListener.bundleStart();
         }
      }
   }
}
