package alternativa.types
{
   import alternativa.init.OSGi;
   import alternativa.osgi.service.console.IConsoleService;
   
   public final class Long
   {
       
      
      private var _low:int;
      
      private var _high:int;
      
      public function Long(low:int, high:int)
      {
         super();
         this._low = low;
         this._high = high;
      }
      
      public function get low() : int
      {
         return this._low;
      }
      
      public function get high() : int
      {
         return this._high;
      }
      
      public function toString() : String
      {
         return this.intToUhex(this._high) + this.intToUhex(this._low);
      }
      
      private function intToUhex(value:int) : String
      {
         var result:String = null;
         var a:uint = 0;
         var console:IConsoleService = OSGi.osgi.getService(IConsoleService) as IConsoleService;
         if(value >= 0)
         {
            result = value.toString(16);
         }
         else
         {
            a = value & ~2147483648 | 2147483648;
            result = a.toString(16);
         }
         var numZeros:int = 8 - result.length;
         while(numZeros > 0)
         {
            result = "0" + result;
            numZeros--;
         }
         return result;
      }
   }
}
