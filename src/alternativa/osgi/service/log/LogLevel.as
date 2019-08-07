package alternativa.osgi.service.log
{
   public class LogLevel
   {
      
      public static const LOG_NONE:int = 0;
      
      public static const LOG_TRACE:int = 1;
      
      public static const LOG_DEBUG:int = 2;
      
      public static const LOG_INFO:int = 3;
      
      public static const LOG_WARNING:int = 4;
      
      public static const LOG_ERROR:int = 5;
      
      private static const strings:Array = ["NONE","TRACE","DEBUG","INFO","WARNING","ERROR"];
       
      
      public function LogLevel()
      {
         super();
      }
      
      public static function toString(level:int) : String
      {
         return strings[level];
      }
   }
}
