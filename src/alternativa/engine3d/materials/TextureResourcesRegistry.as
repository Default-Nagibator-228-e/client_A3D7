package alternativa.engine3d.materials
{
   import alternativa.gfx.core.BitmapTextureResource;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class TextureResourcesRegistry
   {
      
      public static var texture2Resource:Dictionary = new Dictionary();
       
      
      public function TextureResourcesRegistry()
      {
         super();
      }
      
      public static function getTextureResource(param1:BitmapData, param2:Boolean, param3:Boolean, param4:Boolean) : BitmapTextureResource
      {
         var _loc5_:BitmapTextureResource = null;
         if(param1 in texture2Resource)
         {
            _loc5_ = texture2Resource[param1];
            _loc5_.increaseReferencesCount();
            return _loc5_;
         }
         var _loc6_:BitmapTextureResource = new BitmapTextureResource(param1,param2,param3,true);
         texture2Resource[param1] = _loc6_;
         return _loc6_;
      }
      
      public static function releaseTextureResources() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:BitmapTextureResource = null;
         for(_loc1_ in texture2Resource)
         {
            _loc2_ = texture2Resource[_loc1_];
            _loc2_.forceDispose();
         }
      }
      
      public static function release(param1:BitmapData) : void
      {
         if(param1 in texture2Resource)
         {
            delete texture2Resource[param1];
         }
      }
   }
}
