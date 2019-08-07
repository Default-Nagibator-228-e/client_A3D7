package alternativa.tanks.gui.resource.images
{
	import flash.display.BitmapData;
   public class ImageResouce
   {
       
      
      public var bitmapData:Object;
      
      public var id:String;
      
      public var animatedMaterial:Boolean;
      
      public var multiframeData:MultiframeResourceData;
      
      public function ImageResouce(bitmapData:Object, id:String, animatedMaterial:Boolean, multiframeData:MultiframeResourceData)
      {
         super();
         this.bitmapData = bitmapData;
         this.id = id;
         this.animatedMaterial = animatedMaterial;
         this.multiframeData = multiframeData;
      }
   }
}
