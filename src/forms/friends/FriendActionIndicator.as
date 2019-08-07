package forms.friends
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class FriendActionIndicator extends Sprite
   {
      [Embed(source="fa/1.png")]
      private static var yesIconClass:Class;
      
      private static var yesIconBitmapData:BitmapData = Bitmap(new yesIconClass()).bitmapData;
      [Embed(source="fa/2.png")]
      private static var noIconClass:Class;
      
      private static var noIconBitmapData:BitmapData = Bitmap(new noIconClass()).bitmapData;
      
      public static const YES:int = 0;
      
      public static const NO:int = 1;
       
      
      public function FriendActionIndicator(param1:int)
      {
         var _loc2_:Bitmap = null;
         super();
         this.tabChildren = false;
         this.tabEnabled = false;
         this.buttonMode = this.useHandCursor = true;
         switch(param1)
         {
            case YES:
               _loc2_ = new Bitmap(yesIconBitmapData);
               break;
            case NO:
               _loc2_ = new Bitmap(noIconBitmapData);
         }
         addChild(_loc2_);
      }
   }
}
