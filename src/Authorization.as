package
{
   import alternativa.init.UserModelActivator;
   
   public class Authorization
   {
       
      
      public var userModel:UserModelActivator;
      
      public function Authorization()
      {
         super();
      }
      
      public function init() : void
      {
		 this.userModel = new UserModelActivator();
         this.userModel.start(Game.getInstance.osgi);
         this.userModel.userModel.initObject(Game.getInstance.classObject,false,false);
         this.userModel.userModel.objectLoaded(Game.getInstance.classObject);
      }
   }
}
