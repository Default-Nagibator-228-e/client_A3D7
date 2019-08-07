package forms.shop.components.item
{
   import flash.display.Sprite;
   
   public class GridItemBase extends Sprite
   {
       
      
      public function GridItemBase()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function get widthInCells() : int
      {
         return 1;
      }
      
      public function get forceNewLine() : Boolean
      {
         return false;
      }
   }
}
