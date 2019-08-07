package alternativa.tanks.models.battlefield.spectator
{
   import alternativa.tanks.camera.CameraBookmark;
   import alternativa.tanks.camera.CameraBookmarks;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class BookmarksHandler implements KeyboardHandler
   {
       
      
      private var bookmarks:Object;
      
      private var bookmarkKeys:Dictionary;
      
      private var controller:SpectatorCameraController;
      
      public function BookmarksHandler(param1:SpectatorCameraController)
      {
         this.bookmarks = new CameraBookmarks(10);
         this.bookmarkKeys = new Dictionary();
         super();
         this.controller = param1;
         this.initKeyMap();
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:* = this.bookmarkKeys[param1.keyCode];
         if(_loc2_ != null)
         {
            if(param1.ctrlKey)
            {
               this.saveCurrentPositionCameraToBookmark(_loc2_);
            }
            else
            {
               this.goToBookmark(_loc2_);
            }
         }
      }
      
      public function handleKeyUp(param1:KeyboardEvent) : void
      {
      }
      
      private function initKeyMap() : void
      {
         this.bookmarkKeys[Keyboard.NUMBER_0] = 0;
         this.bookmarkKeys[Keyboard.NUMBER_1] = 1;
         this.bookmarkKeys[Keyboard.NUMBER_2] = 2;
         this.bookmarkKeys[Keyboard.NUMBER_3] = 3;
         this.bookmarkKeys[Keyboard.NUMBER_4] = 4;
         this.bookmarkKeys[Keyboard.NUMBER_5] = 5;
         this.bookmarkKeys[Keyboard.NUMBER_6] = 6;
         this.bookmarkKeys[Keyboard.NUMBER_7] = 7;
         this.bookmarkKeys[Keyboard.NUMBER_8] = 8;
         this.bookmarkKeys[Keyboard.NUMBER_9] = 9;
      }
      
      private function saveCurrentPositionCameraToBookmark(param1:int) : void
      {
         this.bookmarks.saveCurrentPositionCameraToBookmark(param1);
      }
      
      private function goToBookmark(param1:int) : void
      {
         var _loc2_:CameraBookmark = this.bookmarks.getBookmark(param1);
         if(_loc2_ != null)
         {
            this.controller.setCameraState(_loc2_.position,_loc2_.eulerAnlges);
         }
      }
   }
}
