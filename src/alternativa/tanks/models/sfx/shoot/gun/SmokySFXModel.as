package alternativa.tanks.models.sfx.shoot.gun
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.tanks.engine3d.MaterialSequence;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.EffectsPair;
   import alternativa.tanks.sfx.PlaneMuzzleFlashEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import utils.client.warfare.models.sfx.shoot.gun.GunShootSFXModelBase;
   import utils.client.warfare.models.sfx.shoot.gun.IGunShootSFXModelBase;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class SmokySFXModel extends GunShootSFXModelBase implements IGunShootSFXModelBase, ICommonShootSFX
   {
      
      private static const SHOT_SOUND_VOLUME:Number = 1;
      
      private static const EXPLOSION_BASE_SIZE:Number = 300;
      
      private static const EXPLOSION_OFFSET_TO_CAMERA:Number = 135;
      
      private static var objectPoolService:IObjectPoolService;
      
      private static var materialRegistry:IMaterialRegistry;
      
      private static var MIPMAP_RESOLUTION:Number = 2;
      
      private static var position:Vector3 = new Vector3();
       
      
      public function SmokySFXModel()
      {
         super();
         _interfaces.push(IModel,IGunShootSFXModelBase,ICommonShootSFX);
      }
      
      public function initObject(clientObject:ClientObject, explosionResourceId:String, explosionSoundResourceId:String, shotResourceId:String, shotSoundResourceId:String) : void
      {
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         var data:GunShootSFXData = new GunShootSFXData();
         var shotTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,shotResourceId).bitmapData as BitmapData;
         data.shotMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,shotTexture,EXPLOSION_BASE_SIZE / shotTexture.width,false);
         var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,explosionResourceId).bitmapData as BitmapData;
         var sequence:MaterialSequence = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,explosionTexture,explosionTexture.height,MIPMAP_RESOLUTION);
         data.explosionMaterials = sequence.materials;
         data.shotSound = ResourceUtil.getResource(ResourceType.SOUND,"smoky_shot").sound as Sound;
         data.explosionSound = ResourceUtil.getResource(ResourceType.SOUND,"smoky_exp").sound as Sound;
         var animExpl:TextureAnimation = GraphicsUtils.getTextureAnimation(null,explosionTexture,200,200);
         animExpl.fps = 50;
         var animShot:TextureAnimation = GraphicsUtils.getTextureAnimation(null,shotTexture,105,30);
         animShot.fps = 30;
         data.explosionData = animExpl;
         data.shotData = animShot;
         clientObject.putParams(SmokySFXModel,data);
      }

      public function createShotEffects(clientObject:ClientObject, localMuzzlePosition:Vector3, turret:Object3D, camera:Camera3D) : EffectsPair
      {
         var data:GunShootSFXData = null;
         var sound:Sound3D = null;
         data = this.getSfxData(clientObject);
         sound = Sound3D.create(data.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,SHOT_SOUND_VOLUME);
         position.x = turret.x;
         position.y = turret.y;
         position.z = turret.z;
         var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool,null,position,sound);
         var graphicEffect:PlaneMuzzleFlashEffect = PlaneMuzzleFlashEffect(objectPoolService.objectPool.getObject(PlaneMuzzleFlashEffect));
         graphicEffect.init(localMuzzlePosition,turret,data.shotMaterial as TextureMaterial,100,60,210,300,600);
         return new EffectsPair(graphicEffect,soundEffect);
      }
      
      public function createExplosionEffects(clientObject:ClientObject, position:Vector3, camera:Camera3D, weakeningCoeff:Number) : EffectsPair
      {
         var data:GunShootSFXData = this.getSfxData(clientObject);
         var sound:Sound3D = Sound3D.create(data.explosionSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,1);
         var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool,null,position,sound,100);
         var graphicEffect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
         var posProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         posProvider.init(position,EXPLOSION_OFFSET_TO_CAMERA);
         var size:Number = EXPLOSION_BASE_SIZE * weakeningCoeff;
         graphicEffect.init(size,size,data.explosionData,0,posProvider,0.5,0.5,null,130,"normal",0,200,500);
         return new EffectsPair(graphicEffect,soundEffect);
      }
      
      private function getSfxData(clientObject:ClientObject) : GunShootSFXData
      {
         return GunShootSFXData(clientObject.getParams(SmokySFXModel));
      }
   }
}
