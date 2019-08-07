package forms.shop.components.itemscategory
{
   import forms.shop.components.item.GridItemBase;
   import flash.display.Sprite;
   
   public class ItemsCategoryViewGrid extends Sprite
   {
       
      
      public var columnCount:int = 3;
      
      public var horizontalSpacing:int = 3;
      
      public var verticalSpacing:int = 3;
      
      public var items:Vector.<GridItemBase>;
      
      public function ItemsCategoryViewGrid()
      {
         super();
         this.items = new Vector.<GridItemBase>();
      }
      
      public function addItem(param1:GridItemBase) : void
      {
         this.items.push(param1);
         addChild(param1);
      }
      
      public function render() : void
      {
         var _loc5_:GridItemBase = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in this.items)
         {
            if(_loc5_.forceNewLine || _loc1_ + _loc5_.widthInCells > this.columnCount)
            {
               _loc1_ = 0;
               _loc2_ = 0;
               _loc3_ = _loc3_ + (this.verticalSpacing + _loc4_);
               _loc4_ = 0;
            }
            _loc1_ = _loc1_ + _loc5_.widthInCells;
            _loc5_.x = _loc2_;
            _loc5_.y = _loc3_;
            _loc2_ = _loc2_ + (_loc5_.width + this.horizontalSpacing);
            if(_loc5_.height > _loc4_)
            {
               _loc4_ = _loc5_.height;
            }
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:GridItemBase = null;
         for each(_loc1_ in this.items)
         {
            _loc1_.destroy();
         }
         this.items = null;
      }
      
      public function set spacing(param1:int) : void
      {
         this.horizontalSpacing = param1;
         this.verticalSpacing = param1;
      }
   }
}
