package utils.reygazu.anticheat.variables
{
   import utils.reygazu.anticheat.managers.CheatManager;
   
   public class SecureInt
   {
       
      
      private var secureData:SecureObject;
      
      private var fake:int;
      
      public function SecureInt(name:String = "Unnamed SecureInt", _fake:int = 0)
      {
         super();
         this.fake = _fake;
         this.secureData = new SecureObject(name,_fake);
      }
      
      public function set value(data:int) : void
      {
         if(this.fake != this.secureData.objectValue)
         {
            CheatManager.getInstance().detectCheat(this.secureData.name,this.fake,this.secureData.objectValue);
         }
         this.secureData.objectValue = data;
         this.fake = data;
      }
      
      public function get value() : int
      {
         return this.secureData.objectValue as int;
      }
   }
}
