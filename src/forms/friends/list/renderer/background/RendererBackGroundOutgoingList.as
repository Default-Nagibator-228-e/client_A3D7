package forms.friends.list.renderer.background
{
   import controls.cellrenderer.ButtonState;
   import flash.display.Sprite;
   
   public class RendererBackGroundOutgoingList extends Sprite
   {
       
      
      private var _width:int = 100;
      
      public function RendererBackGroundOutgoingList(param1:Boolean)
      {
         var _loc2_:ButtonState = null;
         super();
         if(param1)
         {
            _loc2_ = new FriendCellSelected();
         }
         else
         {
            _loc2_ = new FriendCellNormal();
         }
         addChild(_loc2_);
         this.resize();
      }
      
      protected function resize() : void
      {
         var _loc1_:ButtonState = getChildAt(0) as ButtonState;
         _loc1_.width = this._width - 3;
         _loc1_.height = 18;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = Math.floor(param1);
         this.resize();
      }
   }
}
