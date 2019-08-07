package alternativa.tanks.locale.model
{
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import utils.client.models.core.users.model.localized.ILocalizedModelBase;
   import utils.client.models.core.users.model.localized.LocalizedModelBase;
   
   public class LocaleModel extends LocalizedModelBase implements ILocalizedModelBase, IObjectLoadListener
   {
       
      
      public function LocaleModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(ILocalizedModelBase);
         _interfaces.push(IObjectLoadListener);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
      }
   }
}
