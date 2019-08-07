package alternativa.tanks.help
{
   import flash.utils.Timer;
   
   public class HelperTimer extends Timer
   {
       
      
      private var _helper:Helper;
      
      public function HelperTimer(delay:Number, repeatCount:int)
      {
         super(delay,repeatCount);
      }
      
      public function get helper() : Helper
      {
         return this._helper;
      }
      
      public function set helper(h:Helper) : void
      {
         this._helper = h;
      }
   }
}
