package alternativa.tanks.models.sfx.shoot.ricochet
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
   import alternativa.tanks.engine3d.ITextureMaterialRegistry;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.utils.GraphicsUtils;
   import utils.client.warfare.models.sfx.shoot.ricochet.IRicochetSFXModelBase;
   import utils.client.warfare.models.sfx.shoot.ricochet.RicochetSFXModelBase;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class RicochetSFXModel extends RicochetSFXModelBase implements IRicochetSFXModelBase, IObjectLoadListener, IRicochetSFXModel
   {
      
      private static var materialRegistry:IMaterialRegistry;
       
      
      public function RicochetSFXModel()
      {
         super();
         _interfaces.push(IModel,IObjectLoadListener,IRicochetSFXModel);
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
      }
      
      public function initObject(clientObject:ClientObject, bumpFlashTextureId:String, explosionSoundId:String, explosionTextureId:String, ricochetSoundId:String, shotFlashTextureId:String, shotSoundId:String, shotTextureId:String, tailTrailTextureId:String) : void
      {
         var sfxData:RicochetSFXData = new RicochetSFXData();
         var materialSequenceRegistry:IMaterialSequenceRegistry = materialRegistry.materialSequenceRegistry;
         var shotTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,shotTextureId).bitmapData;
         sfxData.shotMaterials = materialSequenceRegistry.getSquareSequence(MaterialType.EFFECT,shotTexture,2).materials;
         var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,explosionTextureId).bitmapData;
         sfxData.explosionMaterials = materialSequenceRegistry.getSquareSequence(MaterialType.EFFECT,explosionTexture,1.33).materials;
         var bumpFlashTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,bumpFlashTextureId).bitmapData;
         sfxData.ricochetFlashMaterials = materialSequenceRegistry.getSquareSequence(MaterialType.EFFECT,bumpFlashTexture,0.4).materials;
         var textureMaterialRegistry:ITextureMaterialRegistry = materialRegistry.textureMaterialRegistry;
         var shotFlashTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,shotFlashTextureId).bitmapData;
         sfxData.shotFlashMaterial = textureMaterialRegistry.getMaterial(MaterialType.EFFECT,shotFlashTexture,1);
         var tailTrailTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,tailTrailTextureId).bitmapData;
         sfxData.tailTrailMaterial = textureMaterialRegistry.getMaterial(MaterialType.EFFECT,tailTrailTexture,2);
         sfxData.shotSound = ResourceUtil.getResource(ResourceType.SOUND,shotSoundId).sound;
         sfxData.ricochetSound = ResourceUtil.getResource(ResourceType.SOUND,ricochetSoundId).sound;
         sfxData.explosionSound = ResourceUtil.getResource(ResourceType.SOUND,explosionSoundId).sound;
         sfxData.dataExplosion = GraphicsUtils.getTextureAnimation(null,explosionTexture,200,200);
         sfxData.dataExplosion.fps = 30;
         sfxData.dataFlash = GraphicsUtils.getTextureAnimation(null,bumpFlashTexture,128,128);
         sfxData.dataFlash.fps = 15;
         sfxData.dataShot = GraphicsUtils.getTextureAnimation(null,shotTexture,150,150);
         sfxData.dataShot.fps = 15;
         clientObject.putParams(RicochetSFXData,sfxData);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var sfxData:RicochetSFXData = null;
         var colorTransforms:Vector.<ColorTransformEntry> = null;
         var ctStruct:ColorTransformEntry = null;
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(object,IColorTransformModel));
         if(colorTransformModel != null)
         {
            sfxData = this.getSfxData(object);
            colorTransforms = colorTransformModel.getModelData(object);
            if(colorTransforms.length > 0)
            {
               ctStruct = colorTransforms[0];
               sfxData.colorTransform = new ColorTransform(ctStruct.redMultiplier,ctStruct.greenMultiplier,ctStruct.blueMultiplier,ctStruct.alphaMultiplier,ctStruct.redOffset,ctStruct.greenOffset,ctStruct.blueOffset,ctStruct.alphaOffset);
            }
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
      }
      
      public function getSfxData(clientObject:ClientObject) : RicochetSFXData
      {
         return RicochetSFXData(clientObject.getParams(RicochetSFXData));
      }
   }
}
