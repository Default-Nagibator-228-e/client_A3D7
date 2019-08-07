package forms.shop.shopitems.item.utils
{
   public class FormatUtils
   {
       
      
      public function FormatUtils()
      {
         super();
      }
      
      public static function valueToString(param1:Number, param2:int, param3:Boolean) : String
      {
         if(param3)
         {
            param1 = Math.ceil(param1);
         }
         var _loc4_:String = param1.toFixed(param2);
         var _loc5_:String = "";
         if(param2 > 0)
         {
            _loc5_ = _loc4_.substr(_loc4_.length - param2 - 1);
            if(_loc5_ == ".00")
            {
               _loc5_ = "";
            }
            _loc4_ = _loc4_.substr(0,_loc4_.length - param2 - 1);
         }
         while(_loc4_.length > 3)
         {
            _loc5_ = " " + _loc4_.substr(_loc4_.length - 3,3) + _loc5_;
            _loc4_ = _loc4_.substr(0,_loc4_.length - 3);
         }
         _loc5_ = _loc4_ + _loc5_;
         return _loc5_;
      }
   }
}
