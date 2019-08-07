package utils.client.panel.model.payment
{
   public class Country
   {
       
      
      private var _id:String;
      
      private var _name:String;
      
      public function Country(param1:String = null, param2:String = null)
      {
         super();
         this._id = param1;
         this._name = param2;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "Country [";
         _loc1_ = _loc1_ + ("id = " + this.id + " ");
         _loc1_ = _loc1_ + ("name = " + this.name + " ");
         _loc1_ = _loc1_ + "]";
         return _loc1_;
      }
   }
}
