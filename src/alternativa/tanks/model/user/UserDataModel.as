package alternativa.tanks.model.user
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import flash.utils.Dictionary;
   import utils.client.panel.model.IUserDataModelBase;
   import utils.client.panel.model.UserDataModelBase;
   
   public class UserDataModel extends UserDataModelBase implements IUserDataModelBase, IObjectLoadListener, IUserData
   {
       
      
      private var clientObject:ClientObject;
      
      private var data:Dictionary;
      
      private var _userId:String;
      
      private var _userName:String;
      
      public function UserDataModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IUserData);
         _interfaces.push(IObjectLoadListener);
         _interfaces.push(IUserDataModelBase);
         this.data = new Dictionary(false);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.clientObject = object;
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.clientObject = null;
      }
      
      public function initObject(clientObject:ClientObject, uid:String, userId:String) : void
      {
         this._userId = userId;
         this._userName = uid;
      }
      
      public function setUserData(clientObject:ClientObject, userId:String, uid:String, index:int) : void
      {
         var i:int = 0;
         this.data[userId] = new UserData(userId,uid,index);
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IUserDataListener);
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IUserDataListener).userDataChanged(userId);
            }
         }
      }
      
      public function getData(userId:String) : UserData
      {
         var result:UserData = null;
         Main.writeToConsole("UserDataModel getData userId: " + userId);
         if(this.data[userId] != null)
         {
            result = this.data[userId];
         }
         return result;
      }
      
      public function get userId() : String
      {
         return this._userId;
      }
      
      public function get userName() : String
      {
         return this._userName;
      }
   }
}
