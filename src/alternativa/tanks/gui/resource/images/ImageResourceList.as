package alternativa.tanks.gui.resource.images
{
   import flash.utils.Dictionary;
   
   public class ImageResourceList
   {
       
      
      private var images:Dictionary;
      
      public function ImageResourceList()
      {
         super();
         this.images = new Dictionary();
      }
      
      public function add(img:ImageResouce) : void
      {
         if(this.images[img.id] == null)
         {
            if(img.bitmapData != null)
            {
               this.images[img.id] = img;
               return;
            }
            throw new Error("Bitmap null! " + img.id);
         }
         throw new Error("Images arleady registered! " + img.id);
      }
      
      public function getImage(key:String) : ImageResouce
      {
         return this.images[key];
      }
   }
}
