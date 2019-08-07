package alternativa.tanks.models.sfx.shoot.snowman
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.sfx.SpriteShotEffect;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
   import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
   import alternativa.tanks.models.weapon.snowman.SnowmanShot;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.EffectsPair;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class SnowmanSFXModel implements ICommonShootSFX, ISnowmanSFX, IObjectLoadListener
   {
      
      private static var materialRegistry:IMaterialRegistry;
      
      private static var objectPoolService:IObjectPoolService;
      
      private static var turretPosition:Vector3 = new Vector3();
       
      
      public function SnowmanSFXModel()
      {
         super();
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
      }
      
      public function initObject(clientObject:ClientObject, explosionSoundId:String, explosionTextureId:String, plasmaTextureId:String, shotSoundId:String, shotTextureId:String) : void
      {
         var data:SnowmanSFXData = new SnowmanSFXData();
         var flashTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,shotTextureId).bitmapData;
         data.shotFlashMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,flashTexture,1,false);
         var plasmaTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,plasmaTextureId).bitmapData;
         data.shotMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,plasmaTexture,plasmaTexture.height,SnowmanShot.SIZE / plasmaTexture.height).materials;
         var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,explosionTextureId).bitmapData;
         data.explosionMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,explosionTexture,explosionTexture.height,3).materials;
         data.shotSound = ResourceUtil.getResource(ResourceType.SOUND,shotSoundId).sound;
         data.explosionSound = ResourceUtil.getResource(ResourceType.SOUND,explosionSoundId).sound;
         data.explosionData = GraphicsUtils.getTextureAnimation(null,explosionTexture,200,200);
         data.explosionData.fps = 30;
         data.shotData = GraphicsUtils.getTextureAnimation(null,plasmaTexture,150,150);
         data.shotData.fps = 30;
         clientObject.putParams(SnowmanSFXModel,data);
      }
      
      public function createShotEffects(clientObject:ClientObject, muzzleLocalPos:Vector3, turret:Object3D, camera:Camera3D) : EffectsPair
      {
         var sound:Sound3D = null;
         var data:SnowmanSFXData = this.getSnowmanSFXData(clientObject);
         var shotEffect:SpriteShotEffect = SpriteShotEffect(objectPoolService.objectPool.getObject(SpriteShotEffect));
         shotEffect.init(data.shotFlashMaterial,muzzleLocalPos,turret,10,80,50,50,data.colorTransform);
         var soundEffect:Sound3DEffect = null;
         if(data.shotSound != null)
         {
            sound = Sound3D.create(data.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.8);
            turretPosition.x = turret.x;
            turretPosition.y = turret.y;
            turretPosition.z = turret.z;
            soundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,turretPosition,sound);
         }
         return new EffectsPair(shotEffect,soundEffect);
      }
      
      public function createExplosionEffects(clientObject:ClientObject, pos:Vector3, camera:Camera3D, weakeningCoeff:Number) : EffectsPair
      {
         var data:SnowmanSFXData = this.getSnowmanSFXData(clientObject);
         var size:Number = 180 * (1 + weakeningCoeff);
         var explosionEffect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
         var animation:TextureAnimation = data.explosionData;
         var position:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         position.init(pos,50);
         explosionEffect.init(size,size,animation,6.28 * Math.random(),position);
         return new EffectsPair(explosionEffect,null);
      }
      
      public function getSnowmanSFXData(clientObject:ClientObject) : SnowmanSFXData
      {
         return SnowmanSFXData(clientObject.getParams(SnowmanSFXModel));
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         var sfxData:SnowmanSFXData = null;
         var colorTransforms:Vector.<ColorTransformEntry> = null;
         var ctStruct:ColorTransformEntry = null;
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(clientObject,IColorTransformModel));
         if(colorTransformModel != null)
         {
            sfxData = this.getSnowmanSFXData(clientObject);
            colorTransforms = colorTransformModel.getModelData(clientObject);
            ctStruct = colorTransforms[0];
            sfxData.colorTransform = new ColorTransform(ctStruct.redMultiplier,ctStruct.greenMultiplier,ctStruct.blueMultiplier,ctStruct.alphaMultiplier,ctStruct.redOffset,ctStruct.greenOffset,ctStruct.blueOffset,ctStruct.alphaOffset);
         }
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
      }
   }
}
