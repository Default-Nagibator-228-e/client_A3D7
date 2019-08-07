package forms.progr
{
   import flash.display.Bitmap;
   
   public class IS
   {
      [Embed(source="d/1.jpg")]
      private static const coldload1:Class;
      [Embed(source="d/2.jpg")]
      private static const coldload2:Class;
      [Embed(source="d/3.jpg")]
      private static const coldload3:Class;
      [Embed(source="d/4.jpg")]
      private static const coldload4:Class;
      [Embed(source="d/5.jpg")]
      private static const coldload5:Class;
      [Embed(source="d/6.jpg")]
      private static const coldload6:Class;
      [Embed(source="d/7.jpg")]
      private static const coldload7:Class;
      [Embed(source="d/8.jpg")]
      private static const coldload8:Class;
      [Embed(source="d/9.jpg")]
      private static const coldload9:Class;
      [Embed(source="d/10.jpg")]
      private static const coldload10:Class;
      [Embed(source="d/11.jpg")]
      private static const coldload11:Class;
      [Embed(source="d/12.jpg")]
      private static const coldload12:Class;
      [Embed(source="d/13.jpg")]
      private static const coldload13:Class;
      [Embed(source="d/14.jpg")]
      private static const coldload14:Class;
      [Embed(source="d/15.jpg")]
      private static const coldload15:Class;
      [Embed(source="d/16.jpg")]
      private static const coldload16:Class;
      [Embed(source="d/17.jpg")]
      private static const coldload17:Class;
      [Embed(source="d/18.jpg")]
      private static const coldload18:Class;
      [Embed(source="d/19.jpg")]
      private static const coldload19:Class;
      [Embed(source="d/20.jpg")]
      private static const coldload20:Class;
	  
      private static var items:Array = new Array(coldload1,coldload3,coldload4,coldload5,coldload6,coldload7,coldload8,coldload9,coldload10,coldload11,coldload12,coldload13,coldload14,coldload16,coldload17,coldload18,coldload19,coldload20);
      
      private static var prev:int;
       
      
      public function IS()
      {
         super();
      }
      
      public static function getRandomPict() : Bitmap
      {
         var r:int = 0;
         //while((r = Math.random() * items.length) == prev)
         //{
         //}
         return new Bitmap(new items[int(Math.random() * items.length)]().bitmapData,"auto",true);
      }
   }
}
