package alternativa.tanks.help
{
   public final class HelperAlign
   {
      
      public static const NONE:int = 0;
      
      public static const TOP_LEFT:int = 9;
      
      public static const TOP_CENTER:int = 17;
      
      public static const TOP_RIGHT:int = 33;
      
      public static const MIDDLE_LEFT:int = 10;
      
      public static const MIDDLE_CENTER:int = 18;
      
      public static const MIDDLE_RIGHT:int = 34;
      
      public static const BOTTOM_LEFT:int = 12;
      
      public static const BOTTOM_CENTER:int = 20;
      
      public static const BOTTOM_RIGHT:int = 36;
      
      public static const TOP_MASK:int = 1;
      
      public static const MIDDLE_MASK:int = 2;
      
      public static const BOTTOM_MASK:int = 4;
      
      public static const LEFT_MASK:int = 8;
      
      public static const CENTER_MASK:int = 16;
      
      public static const RIGHT_MASK:int = 32;
       
      
      public function HelperAlign()
      {
         super();
      }
      
      public static function stringOf(align:int) : String
      {
         var s:String = null;
         switch(align)
         {
            case 0:
               s = "NONE";
               break;
            case 9:
               s = "TOP_LEFT";
               break;
            case 17:
               s = "TOP_CENTER";
               break;
            case 33:
               s = "TOP_RIGHT";
               break;
            case 10:
               s = "MIDDLE_LEFT";
               break;
            case 18:
               s = "MIDDLE_CENTER";
               break;
            case 34:
               s = "MIDDLE_RIGHT";
               break;
            case 12:
               s = "BOTTOM_LEFT";
               break;
            case 20:
               s = "BOTTOM_CENTER";
               break;
            case 36:
               s = "BOTTOM_RIGHT";
         }
         return s;
      }
   }
}
