package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.locale.model.LocaleModel;
   
   public class TanksLocaleActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      private var localeModel:LocaleModel;
      
      public function TanksLocaleActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         TanksLocaleActivator.osgi = osgi;
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         this.localeModel = new LocaleModel();
         modelRegister.add(this.localeModel);
         TextConst.init(osgi.getService(ILocaleService) as ILocaleService);
      }
      
      public function stop(osgi:OSGi) : void
      {
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         modelRegister.remove(this.localeModel.id);
         this.localeModel = null;
         TanksLocaleActivator.osgi = null;
      }
   }
}
