package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.MaterialEntry;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.materials.AnimatedPaintMaterial;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import alternativa.tanks.gui.resource.images.MultiframeResourceData;
   
   public class TextureMaterialRegistry implements ITextureMaterialRegistry
   {
       
      
      private var _useMipMapping:Boolean;
      
      private var materialStat:CachedEntityStat;
      
      private var mipMappingEnabled:Boolean = true;
      
      private const materials:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();
      
      private const entryForTexture:Dictionary = new Dictionary();
      
      private const entryForMaterial:Dictionary = new Dictionary();
      
      public function TextureMaterialRegistry(value:int)
      {
         this.materialStat = new CachedEntityStat();
         super();
      }
      
      public function set timerInterval(value:int) : void
      {
      }
      
      public function getAnimatedPaint(imageResource:ImageResouce, lightmap:BitmapData, details:BitmapData, objId:String) : AnimatedPaintMaterial
      {
         var _loc7_:MaterialEntry = null;
         this.materialStat.requestCount++;
         var _loc3_:String = imageResource.id + objId;
         if(_loc3_ in this.entryForTexture)
         {
            _loc7_ = this.entryForTexture[_loc3_];
            _loc7_.referenceCount++;
            return _loc7_.material as AnimatedPaintMaterial;
         }
         var multiframeData:MultiframeResourceData = imageResource.multiframeData;
         var _loc4_:int = imageResource.bitmapData.width / multiframeData.widthFrame;
         var _loc5_:int = imageResource.bitmapData.height / multiframeData.heigthFrame;
         var _loc6_:AnimatedPaintMaterial = new AnimatedPaintMaterial(imageResource.bitmapData as BitmapData,lightmap,details,_loc4_,_loc5_,multiframeData.fps,multiframeData.numFrames,!!this.mipMappingEnabled?int(1):int(0));
         _loc7_ = this.createPaintMaterialEntry(_loc3_,_loc6_);
         _loc7_.referenceCount++;
         this.materials.push(_loc6_);
         this.materialStat.createCount++;
         return _loc6_;
      }
      
      private function createPaintMaterialEntry(param1:String, param2:TextureMaterial) : MaterialEntry
      {
         var _loc3_:MaterialEntry = new MaterialEntry(param1,param2);
         this.entryForTexture[param1] = _loc3_;
         this.entryForMaterial[param2] = _loc3_;
         return _loc3_;
      }
      
      public function set resoluion(value:Number) : void
      {
         var material:TextureMaterial = null;
         for each(material in this.materials)
         {
            material.resolution = value;
         }
      }
      
      public function get useMipMapping() : Boolean
      {
         return this._useMipMapping;
      }
      
      public function set useMipMapping(value:Boolean) : void
      {
         this._useMipMapping = value;
      }
      
      public function getMaterial(materialType:MaterialType, param1:BitmapData, mipMapResolution:Number, param2:Boolean = true) : TextureMaterial
      {
         if(param1 == null)
         {
            throw new ArgumentError("Texture is null");
         }
         this.materialStat.requestCount++;
         var _loc3_:MaterialEntry = this.getOrCreateEntry(param1,param2);
         _loc3_.referenceCount++;
         return _loc3_.material;
      }
      
      private function getOrCreateEntry(param1:BitmapData, param2:Boolean) : MaterialEntry
      {
         var _loc4_:TextureMaterial = null;
         var _loc3_:MaterialEntry = this.entryForTexture[param1];
         if(_loc3_ == null)
         {
            _loc4_ = this.createMaterial(param1,param2);
            _loc3_ = this.createMaterialEntry(param1,_loc4_);
         }
         return _loc3_;
      }
      
      private function createMaterial(param1:BitmapData, param2:Boolean) : TextureMaterial
      {
         var _loc3_:BitmapData = this.getTexture(param1,param2);
         var _loc4_:TextureMaterial = TextureMaterialFactory.createTextureMaterial(_loc3_,this.mipMappingEnabled);
         this.materials.push(_loc4_);
         this.materialStat.createCount++;
         return _loc4_;
      }
      
      private function createMaterialEntry(param1:BitmapData, param2:TextureMaterial) : MaterialEntry
      {
         var _loc3_:MaterialEntry = new MaterialEntry(param1,param2);
         this.entryForTexture[param1] = _loc3_;
         this.entryForMaterial[param2] = _loc3_;
         return _loc3_;
      }
      
      public function addMaterial(param1:TextureMaterial) : void
      {
         var _loc2_:MaterialEntry = this.createMaterialEntry(null,param1);
         _loc2_.referenceCount++;
         this.entryForMaterial[param1] = _loc2_;
         this.materials.push(param1);
      }
      
      protected function getTexture(param1:BitmapData, param2:Boolean) : BitmapData
      {
         return param1;
      }
      
      public function getDump() : String
      {
         var totalBitmapSize:int = 0;
         var numMaterials:int = 0;
         var numMaps:int = 0;
         var s:String = "=== TextureMaterialRegistry ===\n";
         s = s + ("Total mipmaps: " + numMaps + "\n" + "Total size: " + totalBitmapSize + "\n" + "Scheduled materials: " + 0 + "\n");
         return s;
      }
      
      public function disposeMaterial(material:TextureMaterial) : void
      {
         if(material == null)
         {
            return;
         }
         var _loc2_:MaterialEntry = this.entryForMaterial[material];
         if(_loc2_ != null)
         {
            this.materialStat.releaseCount++;
            _loc2_.referenceCount--;
            if(_loc2_.referenceCount == 0)
            {
               this.removeMaterialEntry(_loc2_);
            }
         }
      }
      
      private function removeMaterialEntry(param1:MaterialEntry) : void
      {
         this.materialStat.destroyCount++;
         var _loc2_:TextureMaterial = param1.material;
         if(param1.keyData in this.entryForTexture)
         {
            delete this.entryForTexture[param1.keyData];
         }
         delete this.entryForMaterial[_loc2_];
         param1.material = null;
         var _loc3_:int = this.materials.indexOf(_loc2_);
         this.materials.splice(_loc3_,1);
         _loc2_.dispose();
      }
      
      protected function forEachMaterial(param1:Function) : void
      {
         var _loc2_:TextureMaterial = null;
         for each(_loc2_ in this.materials)
         {
            param1(_loc2_);
         }
      }
      
      public function clear() : void
      {
         this.forEachMaterial(this._clearTexture);
         this.materials.length = 0;
         clearDictionary(this.entryForTexture);
         clearDictionary(this.entryForMaterial);
         this.materialStat.clear();
      }
      
      private function _clearTexture(param1:TextureMaterial) : void
      {
         param1.texture = null;
      }
      
      protected function getEntry(param1:TextureMaterial) : MaterialEntry
      {
         return this.entryForMaterial[param1];
      }
   }
}
