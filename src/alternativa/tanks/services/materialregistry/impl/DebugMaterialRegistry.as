package alternativa.tanks.services.materialregistry.impl
{
   import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
   import alternativa.tanks.engine3d.ITextureMaterialRegistry;
   import alternativa.tanks.engine3d.IndexedTextureConstructor;
   import alternativa.tanks.engine3d.debug.DummyIndexedTextureConstructor;
   import alternativa.tanks.engine3d.debug.MaterialSequenceRegistry;
   import alternativa.tanks.engine3d.debug.SkinTextureRegistry;
   import alternativa.tanks.engine3d.debug.TextureMaterialRegistry;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.vehicles.tanks.ISkinTextureRegistry;
   
   public class DebugMaterialRegistry implements IMaterialRegistry
   {
       
      
      private var _textureMaterialRegistry:ITextureMaterialRegistry;
      
      private var _materialSequenceRegistry:IMaterialSequenceRegistry;
      
      private var _skinTextureRegistry:ISkinTextureRegistry;
      
      public function DebugMaterialRegistry()
      {
         this._textureMaterialRegistry = new TextureMaterialRegistry();
         this._materialSequenceRegistry = new MaterialSequenceRegistry();
         this._skinTextureRegistry = new SkinTextureRegistry();
         super();
      }
      
      public function get useMipMapping() : Boolean
      {
         return false;
      }
      
      public function set useMipMapping(value:Boolean) : void
      {
      }
      
      public function get textureMaterialRegistry() : ITextureMaterialRegistry
      {
         return this._textureMaterialRegistry;
      }
      
      public function get materialSequenceRegistry() : IMaterialSequenceRegistry
      {
         return this._materialSequenceRegistry;
      }
      
      public function get skinTextureRegistry() : ISkinTextureRegistry
      {
         return this._skinTextureRegistry;
      }
      
      public function get mapMaterialRegistry() : ITextureMaterialRegistry
      {
         return this._textureMaterialRegistry;
      }
      
      public function clear() : void
      {
      }
      
      public function createTextureConstructor() : IndexedTextureConstructor
      {
         return new DummyIndexedTextureConstructor();
      }
   }
}
