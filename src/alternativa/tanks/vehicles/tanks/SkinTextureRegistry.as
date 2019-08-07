package alternativa.tanks.vehicles.tanks
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class SkinTextureRegistry implements ISkinTextureRegistry
   {
       
      
      private var textures:Dictionary;
      
      public function SkinTextureRegistry()
      {
         this.textures = new Dictionary();
         super();
      }
      
      public function getTexture(tankPart:TankSkinPart, colormap:BitmapData) : BitmapData
      {
         var partTextures:Dictionary = this.textures[tankPart.partId];
         if(partTextures == null)
         {
            partTextures = new Dictionary();
            this.textures[tankPart.partId] = partTextures;
         }
         var textureEntry:TextureEntry = partTextures[colormap];
         if(textureEntry == null)
         {
            textureEntry = new TextureEntry(tankPart.createTexture(colormap,false));
            partTextures[colormap] = textureEntry;
         }
         textureEntry.refCount++;
         return textureEntry.texture;
      }
      
      public function releaseTexture(tankPart:TankSkinPart, colormap:BitmapData) : void
      {
         var partTextures:Dictionary = this.textures[tankPart.partId];
         if(partTextures == null)
         {
            return;
         }
         var textureEntry:TextureEntry = partTextures[colormap];
         if(textureEntry == null)
         {
            return;
         }
         textureEntry.refCount--;
         if(textureEntry.refCount == 0)
         {
            textureEntry.texture.dispose();
            delete partTextures[colormap];
         }
      }
      
      public function clear() : void
      {
      }
   }
}

import flash.display.BitmapData;

class TextureEntry
{
    
   
   public var refCount:int;
   
   public var texture:BitmapData;
   
   function TextureEntry(texture:BitmapData)
   {
      super();
      this.texture = texture;
   }
}
