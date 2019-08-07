package utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import utils.BitmapUtils;
   import utils.ITextureConstructorListener;
   import utils.TextureByteData;
   
   public class TextureConstructor
   {
       
      
      private var loader:Loader;
      
      private var textureData:TextureByteData;
      
      private var _texture:BitmapData;
      
      private var listener:ITextureConstructorListener;
      
      public function TextureConstructor()
      {
         super();
      }
      
      public function get texture() : BitmapData
      {
         return this._texture;
      }
      
      public function createTexture(textureData:TextureByteData, listener:ITextureConstructorListener) : void
      {
         if(this.loader != null)
         {
            throw new Error("Construction in progress");
         }
         if(textureData == null)
         {
            throw new ArgumentError("Parameter textureData is null");
         }
         if(textureData.diffuseData == null)
         {
            throw new ArgumentError("Diffuse data is null");
         }
         this.textureData = textureData;
         this.listener = listener;
         textureData.diffuseData.position = 0;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onDiffuseTextureLoadingComplete);
         this.loader.loadBytes(textureData.diffuseData);
      }
      
      private function onDiffuseTextureLoadingComplete(e:Event) : void
      {
         this._texture = Bitmap(this.loader.content).bitmapData;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onDiffuseTextureLoadingComplete);
         this.loader.unload();
         if(this.textureData.opacityData != null)
         {
            this.textureData.opacityData.position = 0;
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAlphaTextureLoadingComplete);
            this.loader.loadBytes(this.textureData.opacityData);
         }
         else
         {
            this.complete();
         }
      }
      
      private function onAlphaTextureLoadingComplete(e:Event) : void
      {
         var alpha:BitmapData = Bitmap(this.loader.content).bitmapData;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onAlphaTextureLoadingComplete);
         this.loader.unload();
         this._texture = BitmapUtils.mergeBitmapAlpha(this._texture,alpha,true);
         this.complete();
      }
      
      private function complete() : void
      {
         this.loader = null;
         this.textureData = null;
         var listener:ITextureConstructorListener = this.listener;
         this.listener = null;
         listener.onTextureReady(this);
      }
   }
}
