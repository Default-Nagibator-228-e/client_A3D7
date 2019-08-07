package utils
{
   public class StringUtils
   {
       
      
      public function StringUtils()
      {
         super();
      }
      
      public static function makeCorrectBaseUrl(url:String) : String
      {
         if(url && url.charAt(url.length - 1) != "/")
         {
            return url + "/";
         }
         return url;
      }
   }
}
