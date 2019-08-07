package alternativa.tanks.models.weapon.common {
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.math.Vector3;
	import alternativa.osgi.service.log.ILogService;
	import alternativa.osgi.service.log.LogLevel;
	import alternativa.physics.Body;
	import alternativa.tanks.battle.engine.GameObject;
	import alternativa.tanks.battle.weapon.targeting.CommonTargetSystem;
	import alternativa.tanks.battle.weapon.IWeapon;
	import alternativa.tanks.battle.weapon.ShotForces;
	import alternativa.tanks.battle.weapon.smoky.SmokySFXData;
	import alternativa.tanks.battle.weapon.smoky.SmokyWeapon;
	import alternativa.tanks.battle.weapon.targeting.DefaultTargetSystemPredicate;
	import alternativa.tanks.models.battle.GraphicSettings;
	import alternativa.tanks.models.tank.ITankModel;
	import alternativa.tanks.models.tank.TankModelData;
	import alternativa.tanks.models.weapon.IWeaponModel;
	import alternativa.tanks.models.weapon.shared.shot.IShotModel;
	import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
	import alternativa.tanks.models.weapon.weakening.WeaponPowerReducer;
	import alternativa.tanks.resources.ResourceUtils;
	import alternativa.types.Long;

	import flash.media.Sound;
	import flash.utils.Dictionary;

	import platform.client.fp10.core.registry.ResourceRegistry;
	import platform.client.fp10.core.resource.types.ImageResource;
	import platform.client.fp10.core.resource.types.SoundResource;
	import platform.client.fp10.core.resource.types.StubBitmapData;
	import platform.client.fp10.core.type.IGameObject;

	import projects.tanks.client.battlefield.models.weapon.TargetTank;
	import projects.tanks.client.battlefield.models.weapon.shared.shot.constructor.ShotModelConstructor;
	import projects.tanks.client.battlefield.models.weapon.smoky.ISmokyModelBase;
	import projects.tanks.client.battlefield.models.weapon.smoky.SmokyModelBase;
	import projects.tanks.client.battlefield.models.weapon.smoky.constructor.SmokyModelConstructor;
	import projects.tanks.client.garagebattlecommons.models.Vector3d;

	/**
	 *
	 */
	[ModelInfo]
	public class SmokyModel extends SmokyModelBase implements ISmokyModelBase, IWeaponModel, ISmokyModel {

		[Inject]
		public static var resourceRegistry:ResourceRegistry;

		[Inject]
		public static var logger:ILogService;

		private var shotMaterialsRegistry:Dictionary = new Dictionary();
		private var explosionMaterialsRegistry:Dictionary = new Dictionary();

		private var targetTank:TargetTank = new TargetTank(0, null, 0);
		private var vector3d:Vector3d = new Vector3d(0, 0, 0);
		private var vector3:Vector3 = new Vector3();

		/**
		 * 
		 */
		public function SmokyModel() {
		}

		/**
		 * Команда сервера о выстреле без попадания по цели.
		 *
		 * @param hitPoint необязательная точка попадания
		 */
		public function fire(hitPoint:Vector3d):void {
			var weapon:SmokyWeapon = SmokyWeapon(getData(SmokyWeapon));
			if (hitPoint == null) {
				weapon.emulateShot(null, null, 0);
			} else {
				vector3.reset(hitPoint.x, hitPoint.y, hitPoint.z);
				weapon.emulateShot(vector3, null, 0);
			}
		}

		/**
		 * Команда сервера о выстреле с попаданием по цели.
		 *
		 * @param targetTankId идентификатор цели
		 * @param hitPoint точка попадания
		 * @param weakeningCoeff коэффициент ослабления эффектов
		 */
		public function fireTank(targetTankId:Long, hitPoint:Vector3d, weakeningCoeff:Number):void {
			var weapon:SmokyWeapon = SmokyWeapon(getData(SmokyWeapon));
			var targetObject:IGameObject = object.space.getObject(targetTankId);
			// Цель может быть ещё не загружена
			if (targetObject != null) {
				var tankModelData:TankModelData = ITankModel(targetObject.adapt(ITankModel)).getTankModelData();
				var targetBody:Body = tankModelData.tank.chassis.chassisBody;
				vector3.reset(hitPoint.x, hitPoint.y, hitPoint.z);
				// Координаты точки попадания заданы относительно танка, нужно пересчитать их в глобальную систему
				vector3.transform3(targetBody.baseMatrix).add(targetBody.state.pos);
				weapon.emulateShot(vector3, tankModelData.tank, weakeningCoeff);
			} else {
				weapon.emulateShot(null, null, 0);
			}
		}

		/**
		 * Создаёт объект оружия.
		 *
		 * @return объект оружия
		 */
		public function getWeapon():IWeapon {
			var initParam:SmokyModelConstructor = getInitParam();
			var shotInitParam:ShotModelConstructor = IShotModel(object.adapt(IShotModel)).getConstructor();
			var commonTargetSystem:CommonTargetSystem = new CommonTargetSystem(shotInitParam.autoAimingAngleUp, 10, shotInitParam.autoAimingAngleDown, 10, new DefaultTargetSystemPredicate());
			var shotForces:ShotForces = new ShotForces(shotInitParam.kickback, shotInitParam.impactForce);
			var smokySFXData:SmokySFXData = new SmokySFXData(getShotMaterial(initParam.shotTexture), getExplosionMaterials(initParam.explosionTexture), getSound(initParam.shotSound), getSound(initParam.explosionSound));
			var weaponPowerReducer:WeaponPowerReducer = new WeaponPowerReducer(IWeaponWeakeningModel(object.adapt(IWeaponWeakeningModel)).getConstructor());
			var smokyShotListener:SmokyShotListener = new SmokyShotListener(object);
			var smokyWeapon:SmokyWeapon = new SmokyWeapon(shotInitParam.reloadMsec, commonTargetSystem, shotForces, weaponPowerReducer, smokyShotListener, smokySFXData);
			putData(SmokyWeapon, smokyWeapon);
			return smokyWeapon;
		}

		/**
		 * Посылает команду выстрела на сервер.
		 *
		 * @param hitPoint необязательная глобальная точка попадания
		 * @param target необязательная цель
		 * @param distance расстояние до точки попадания по цели
		 */
		public function sendFire(hitPoint:Vector3, target:GameObject, distance:Number):void {
			var targetData:TargetTank;
			if (target != null) {
				targetData = targetTank;
				targetData.distance = 0.01*distance;
				var targetObject:IGameObject = IGameObject(target.getData(IGameObject));
				var tankModelData:TankModelData = ITankModel(targetObject.adapt(ITankModel)).getTankModelData();
				targetData.id = tankModelData.object.id;
				targetData.incarnation = tankModelData.incarnation;
				var body:Body = tankModelData.tank.chassis.chassisBody;
				var pos:Vector3 = body.state.pos;
				// Точка попадания трансформируется в систему координат цели
				hitPoint.subtract(pos).transformTransposed3(body.baseMatrix);
			}
			var hitPoint3d:Vector3d;
			if (hitPoint != null) {
				hitPoint3d = vector3d;
				hitPoint3d.x = hitPoint.x;
				hitPoint3d.y = hitPoint.y;
				hitPoint3d.z = hitPoint.z;
			}
			server.fireCommand(hitPoint3d, targetData);
		}

		/**
		 *
		 * @param resourceId
		 * @return -
		 */
		private function getShotMaterial(resourceId:Long):Material {
			var material:Material = shotMaterialsRegistry[resourceId];
			if (material == null) {
				var res:ImageResource = ImageResource(resourceRegistry.getResource(resourceId));
				material = new TextureMaterial(res != null ? res.data : new StubBitmapData(0xFF0000), false, true, GraphicSettings.mipMappingType, GraphicSettings.mipMappingResolution);
				shotMaterialsRegistry[resourceId] = material;
			}
			return material;
		}

		/**
		 *
		 * @param resourceId
		 * @return -
		 */
		private function getExplosionMaterials(resourceId:Long):Vector.<Material> {
			var materials:Vector.<Material> = explosionMaterialsRegistry[resourceId];
			if (materials == null) {
				materials = ResourceUtils.createMultiframeMaterials(resourceId, GraphicSettings.mipMappingResolution);
				explosionMaterialsRegistry[resourceId] = materials;
			}
			return materials;
		}

		/**
		 *
		 * @param resourceId
		 * @return -
		 */
		private function getSound(resourceId:Long):Sound {
			var res:SoundResource = SoundResource(resourceRegistry.getResource(resourceId));
			if (res != null)
				return res.sound;
			logger.log(LogLevel.LOG_ERROR, "SmokyModel: Missing SoundResource id=" + resourceId);
			return null;
		}

	}
}
