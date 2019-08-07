package alternativa.tanks.models.sfx.flame
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.physics.altphysics;
   import alternativa.service.IModelService;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.flamethrower.FlamethrowerData;
   import alternativa.tanks.models.weapon.flamethrower.IFlamethrower;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.EffectsPair;
   import alternativa.tanks.sfx.MobileSound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.utils.GraphicsUtils;
   import utils.client.warfare.models.sfx.flame.FlameThrowingSFXModelBase;
   import utils.client.warfare.models.sfx.flame.IFlameThrowingSFXModelBase;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   use namespace altphysics;
   
   public class FlamethrowerSFXModel extends FlameThrowingSFXModelBase implements IFlameThrowingSFXModelBase, IFlamethrowerSFXModel, IObjectLoadListener
   {
      
      private static const MIPMAP_RESOLUTION:int = 3;
      
      private static const SOUND_VOLUME:Number = 1;
      
      private static var objectPoolService:IObjectPoolService;
      
      private static var materialRegistry:IMaterialRegistry;
       
      
      private var battlefield:IBattleField;
      
      public function FlamethrowerSFXModel()
      {
         super();
         _interfaces.push(IModel,IFlameThrowingSFXModelBase,IFlamethrowerSFXModel,IObjectLoadListener);
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
      }
      
      public function initObject(clientObject:ClientObject, fireTextureId:String, flameSoundId:String) : void
      {
         if(this.battlefield == null)
         {
            this.battlefield = IBattleField(Main.osgi.getService(IBattleField));
         }
         var data:FlamethrowerSFXData = new FlamethrowerSFXData();
         var fireTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, fireTextureId).bitmapData as BitmapData;
		 var shotTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,"fire_shot").bitmapData as BitmapData;
         data.materials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,fireTexture,fireTexture.height,MIPMAP_RESOLUTION).materials;
         data.flameSound = ResourceUtil.getResource(ResourceType.SOUND,flameSoundId).sound as Sound;
         data.data = GraphicsUtils.getTextureAnimation(null,fireTexture,100,100);
         data.data.fps = 10;
		 data.shot = GraphicsUtils.getTextureAnimation(null,shotTexture,51,232);
         data.shot.fps = 40;
         clientObject.putParams(FlamethrowerSFXModel,data);
      }
      
      public function getSpecialEffects(shooterData:TankData, localMuzzlePosition:Vector3, turret:Object3D, weakeningModel:IWeaponWeakeningModel) : EffectsPair
      {
         var flameModel:IFlamethrower = IFlamethrower(Main.osgi.getService(IFlamethrower));
         var data:FlamethrowerData = flameModel.getFlameData(shooterData.turret);
         var sfxData:FlamethrowerSFXData = this.getData(shooterData.turret);
         var graphicEffect:FlamethrowerGraphicEffect = FlamethrowerGraphicEffect(objectPoolService.objectPool.getObject(FlamethrowerGraphicEffect));
         graphicEffect.init(shooterData,data.range.value,data.coneAngle.value,20,2000,localMuzzlePosition,turret,sfxData,this.battlefield.getBattlefieldData().collisionDetector,weakeningModel);
         var sound3D:Sound3D = Sound3D.create(sfxData.flameSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,SOUND_VOLUME);
         var soundEffect:MobileSound3DEffect = MobileSound3DEffect(objectPoolService.objectPool.getObject(MobileSound3DEffect));
         soundEffect.init(null,sound3D,turret,0,4);
         return new EffectsPair(graphicEffect,soundEffect);
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         var colorTransforms:Vector.<ColorTransformEntry> = null;
         var sfxData:FlamethrowerSFXData = null;
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(clientObject,IColorTransformModel));
         if(colorTransformModel != null)
         {
            colorTransforms = colorTransformModel.getModelData(clientObject);
            if(colorTransforms != null)
            {
               sfxData = this.getData(clientObject);
               sfxData.colorTransformPoints = colorTransforms;
            }
         }
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
      }
      
      private function getData(clientObject:ClientObject) : FlamethrowerSFXData
      {
         return clientObject.getParams(FlamethrowerSFXModel) as FlamethrowerSFXData;
      }
   }
}
