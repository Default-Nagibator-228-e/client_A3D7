package forms.friends.list.renderer.background
{
   import forms.friends.list.AcceptedList;
   import forms.friends.list.renderer.HeaderAcceptedList;
   import controls.cellrenderer.ButtonState;
   import flash.display.Sprite;
   
   public class RendererBackGroundAcceptedList extends Sprite
   {
       
      
      protected var tabs:Vector.<Number>;
      
      protected var _width:int = 100;
      
      public function RendererBackGroundAcceptedList(param1:Boolean, param2:Boolean = false)
      {
         var _loc3_:ButtonState = null;
         this.tabs = new Vector.<Number>();
         super();
         var _loc4_:int = HeaderAcceptedList.HEADERS.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1)
            {
               if(param2)
               {
                  _loc3_ = new FriendCellSelected();
               }
               else
               {
                  _loc3_ = new FriendCellNormal();
               }
            }
            else if(param2)
            {
               _loc3_ = new UserOfflineCellSelected();
            }
            else
            {
               _loc3_ = new UserOfflineCellNormal();
            }
            addChild(_loc3_);
            _loc5_++;
         }
         this.resize();
      }
      
      protected function resize() : void
      {
         var _loc1_:ButtonState = null;
         if(this.isScroll())
         {
            this.tabs = Vector.<Number>([0,this._width - 224,this._width - 1]);
         }
         else
         {
            this.tabs = Vector.<Number>([0,this._width - 233,this._width - 1]);
         }
         var _loc2_:int = HeaderAcceptedList.HEADERS.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = getChildAt(_loc3_) as ButtonState;
            _loc1_.width = this.tabs[_loc3_ + 1] - this.tabs[_loc3_] - 2;
            _loc1_.height = 18;
            _loc1_.x = this.tabs[_loc3_];
            _loc3_++;
         }
         graphics.clear();
         graphics.beginFill(16711680,0);
         graphics.drawRect(0,0,this._width - 1,18);
         graphics.endFill();
      }
      
      protected function isScroll() : Boolean
      {
         return AcceptedList.SCROLL_ON;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = Math.floor(param1);
         this.resize();
      }
   }
}
