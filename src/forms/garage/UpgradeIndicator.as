package forms.garage
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class UpgradeIndicator extends Sprite
   {
      [Embed(source="u/1.png")]
      private static const u1:Class;
      
      private static const ud1:Bitmap = new u1();
      [Embed(source="u/2.png")]
      private static const u2:Class;
      
      private static const ud2:Bitmap = new u2();
       
      [Embed(source="u/3.png")]
      private static const u3:Class;
      
      private static const ud3:Bitmap = new u3();
	  
	  [Embed(source="u/4.png")]
      private static const u4:Class;
      
      private static const ud4:Bitmap = new u4();
	  
      private var cells:Array;
      
      private var space:int = 2;
      
      private var cellsNum:int = 3;
      
      private var _value:int;
      
      public function UpgradeIndicator()
      {
         var cell:Bitmap = null;
         super();
         this.cells = new Array();
		 this.y = - ud4.height / 2;
      }
      
      public function set value(v:int) : void
      {
         switch(v)
         {
            case 0:
                addChild(ud1);
				ud1.y = - ud4.height / 2;
                break;
            case 1:
                addChild(ud2);
				ud2.y = - ud4.height / 2;
                break;
			case 2:
                addChild(ud3);
				ud3.y = - ud4.height / 2;
                break;
			case 3:
                addChild(ud4);
				ud4.y = - ud4.height / 2;
		 }
      }
   }
}
