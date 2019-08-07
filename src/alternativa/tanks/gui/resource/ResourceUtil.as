package alternativa.tanks.gui.resource
{
   import alternativa.init.Main;
   import alternativa.resource.ImageResource;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import alternativa.tanks.gui.resource.images.ImageResourceLoader;
   import alternativa.tanks.gui.resource.listener.ResourceLoaderListener;
   import alternativa.tanks.gui.resource.tanks.TankResourceLoader;
   import alternativa.types.Long;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   
   public class ResourceUtil
   {
      
      private static var loaderSounds:SoundResourceLoader;
      
      private static var loaderModels:TankResourceLoader;
      
      private static var loaderImages:ImageResourceLoader;
      
      private static var resourceLoaded:Boolean;
      
      private static var resourcesLength:int;
       
      
      public function ResourceUtil()
      {
         super();
      }
      
      public static function getResource(type:ResourceType, key:String, f:Function = null) : Object
      {
         var returningResource:Object = null;
         if(!resourceLoaded)
         {
            throw new Error("ресурсы еще не загруженны! " + loaderImages.status + " " + loaderModels.status + " " + loaderSounds.status);
         }
         switch(type)
         {
            case ResourceType.IMAGE:
               returningResource = loaderImages.list.getImage(key);
               break;
            case ResourceType.MODEL:
               returningResource = loaderModels.list.getModel(key);
               break;
            case ResourceType.SOUND:
               returningResource = loaderSounds.list.getSound(key);
         }
         if(returningResource == null)
         {
			trace("Resource with id = " + key + " is null!");
         }
         return returningResource;
      }
      
      public static function loadResource() : void
      {
         loaderSounds = new SoundResourceLoader("resourceSound.json?rand=" + Math.random());
         loaderModels = new TankResourceLoader("resourceModels.json?rand=" + Math.random());
         loaderImages = new ImageResourceLoader("resourceImages.json?rand=" + Math.random());
      }
      
      public static function onCompleteLoading() : void
      {
		 (Main.osgi.getService(ILoader) as CheckLoader).addProgress(200);
         if(loaderImages.status == 1 && loaderSounds.status == 1 && loaderModels.status == 1)
         {
            resourceLoaded = true;
            ResourceLoaderListener.loadedComplete();
         }
      }
      
      public static function addEventListener(src:Function) : void
      {
         ResourceLoaderListener.addEventListener(src);
      }
   }
}
