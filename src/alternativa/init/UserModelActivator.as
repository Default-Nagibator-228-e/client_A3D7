package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.TimeCheckerModel;
   import alternativa.tanks.model.UserModel;
   
   public class UserModelActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      public var userModel:UserModel;
      
      private var timeCheckerModel:TimeCheckerModel;
      
      public function UserModelActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         UserModelActivator.osgi = osgi;
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         this.userModel = new UserModel();
         modelRegister.add(this.userModel);
         this.timeCheckerModel = new TimeCheckerModel();
         modelRegister.add(this.timeCheckerModel);
      }
      
      public function stop(osgi:OSGi) : void
      {
         var modelRegister:IModelService = osgi.getService(IModelService) as IModelService;
         modelRegister.remove(this.userModel.id);
         modelRegister.remove(this.timeCheckerModel.id);
         this.userModel = null;
         this.timeCheckerModel = null;
         UserModelActivator.osgi = null;
      }
   }
}
