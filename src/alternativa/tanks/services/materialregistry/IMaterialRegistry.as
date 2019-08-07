package alternativa.tanks.services.materialregistry
{
   import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
   import alternativa.tanks.engine3d.ITextureMaterialRegistry;
   import alternativa.tanks.engine3d.IndexedTextureConstructor;
   import alternativa.tanks.vehicles.tanks.ISkinTextureRegistry;
   
   public interface IMaterialRegistry
   {
       
      
      function get useMipMapping() : Boolean;
      
      function set useMipMapping(param1:Boolean) : void;
      
      function get textureMaterialRegistry() : ITextureMaterialRegistry;
      
      function get materialSequenceRegistry() : IMaterialSequenceRegistry;
      
      function get skinTextureRegistry() : ISkinTextureRegistry;
      
      function get mapMaterialRegistry() : ITextureMaterialRegistry;
      
      function clear() : void;
      
      function createTextureConstructor() : IndexedTextureConstructor;
   }
}
