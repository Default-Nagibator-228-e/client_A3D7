package alternativa.tanks.models.effects.common {
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.math.Matrix3;
	import alternativa.math.Vector3;
	import alternativa.physics.BodyState;
	import alternativa.physics.PhysicsScene;
	import alternativa.physics.PhysicsUtils;
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.ICollisionPredicate;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.constraints.MaxDistanceConstraint;
	import alternativa.physics.rigid.SkinnedBody3D;
	import alternativa.tanks.bonuses.*;
	import alternativa.tanks.physics.CollisionGroup;
	import alternativa.tanks.physics.TanksCollisionDetector;
	import alternativa.tanks.vehicles.tanks.Tank;
	import alternativa.types.Long;

	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;

	use namespace altphysics;

	public class ParaBonus extends SkinnedBody3D implements IBonus, ICollisionPredicate {

		private static const BOX_MASS:Number = 20;
		private static const BOX_HALF_SIZE:Number = 75;
		private static const PARACHUTE_MASS:Number = 10;
		private static const PARACHUTE_RADIUS:Number = 180;
		private static const CORDS_LENGTH:Number = 400;
		private static const TAKEN_ANIMATION_TIME:int = 2000;
		private static const FLASH_DURATION:int = 300;
		private static const ALPHA_DURATION:int = TAKEN_ANIMATION_TIME - FLASH_DURATION;
		private static const MAX_ADDITIVE_VALUE:int = 0xCC;
		private static const ADDITIVE_SPEED_UP:Number = Number(MAX_ADDITIVE_VALUE)/FLASH_DURATION;
		private static const ADDITIVE_SPEED_DOWN:Number = Number(MAX_ADDITIVE_VALUE)/(TAKEN_ANIMATION_TIME - FLASH_DURATION);
		private static const UP_SPEED:Number = 300;
		private static const ANGLE_SPEED:Number = 2;
		private static const PHYSICS_STATE_FULL:int = 1;
		private static const PHYSICS_STATE_PARABOX:int = 2;
		private static const PHYSICS_STATE_BOX:int = 3;
		private static const WARNING_TIME:int = 8000;
		private static const PARACHUTE_REMOVAL_TIME:int = 2000;
		private static const BLINK_INTERVAL:int = 500;
		private static const DELTA_ALPHA:Number = 0.5;
		private static const MIN_ALPHA:Number = 1 - DELTA_ALPHA;
		private static const COEFF:Number = 10;

		private static const defaultState:BodyState = new BodyState();

		private static var pools:Dictionary = new Dictionary();

		public static function create(bonusData:BonusCommonData):ParaBonus {
			var pool:Pool = pools[bonusData];
			if (pool == null) {
				pool = new Pool();
				pools[bonusData] = pool;
			}
			if (pool.numObjects == 0)
				return new ParaBonus(pool, bonusData.boxMesh, bonusData.parachuteMesh, bonusData.parachuteInnerMesh, bonusData.cordMaterial);
			var bonus:ParaBonus = pool.objects[--pool.numObjects];
			pool.objects[pool.numObjects] = null;
			return bonus;
		}

		public static function deletePool(bonusData:BonusCommonData):void {
			delete pools[bonusData];
		}

		private var _bonusId:Long;
		private var bonusState:int;
		private var bonusListener:IBonusListener;
		private var parachute:Parachute;
		private var cordsMesh:Cords;
		private var cordsConstaints:Vector.<MaxDistanceConstraint>;
		private var timeToLive:int;
		private var currBlinkInterval:int;
		private var visibilitySwitchTime:int;
		private var takenAnimationTime:int;
		private var parachuteTimeLeft:int;
		private var additiveValue:int = 0;
		private var alphaSpeed:Number;
		private var physicsState:int;
		private var pool:Pool;

		public function ParaBonus(pool:Pool, boxMesh:Mesh, parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordMaterial:Material) {
			super(1/BOX_MASS, Matrix3.IDENTITY);
			this.pool = pool;
			var hs:Vector3 = new Vector3(BOX_HALF_SIZE, BOX_HALF_SIZE, BOX_HALF_SIZE);
			PhysicsUtils.getBoxInvInertia(BOX_MASS, hs, invInertia);
			var collisionBox:CollisionBox = new CollisionBox(hs, CollisionGroup.BONUS_WITH_STATIC);
			collisionBox.postCollisionPredicate = this;
			addCollisionPrimitive(collisionBox);
			canFreeze = true;
			skin = boxMesh.clone();
			createParachuteAndCords(parachuteMesh, parachuteInnerMesh, cordMaterial);
		}

		public function init(bonusId:Long, timeToLive:int, isFalling:Boolean):void {
			this._bonusId = bonusId;
			this.timeToLive = timeToLive < 0 ? int.MAX_VALUE : timeToLive;
			bonusState = isFalling ? BonusState.FALLING : BonusState.RESTING;
			collisionPrimitives.head.primitive.collisionGroup |= CollisionGroup.BONUS_WITH_TANK;
			skin.alpha = 1;
			parachute.outerMesh.alpha = 1;
			parachute.innerMesh.alpha = 1;
			cordsMesh.alpha = 1;
			visibilitySwitchTime = 0;
			takenAnimationTime = TAKEN_ANIMATION_TIME;
			parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
			currBlinkInterval = BLINK_INTERVAL;
			frozen = false;
			freezeCounter = 0;
			state.copy(defaultState);
			prevState.copy(defaultState);
			parachute.state.copy(defaultState);
			parachute.prevState.copy(defaultState);
		}

		public function get bonusId():Long {
			return _bonusId;
		}

		public function isFalling():Boolean {
			return bonusState == BonusState.FALLING;
		}

		public function readBonusPosition(result:Vector3):void {
			result.x = state.pos.x;
			result.y = state.pos.y;
			result.z = state.pos.z;
		}

		public function setBonusPosition(x:Number, y:Number, z:Number):void {
			state.pos.vReset(x, y, z);
			prevState.copy(state);
		}

		public function setRestingState(x:Number, y:Number, z:Number):void {
			setPositionXYZ(x, y, z);
			frozen = false;
			freezeCounter = 0;
			if (bonusState != BonusState.RESTING) {
				bonusState = BonusState.RESTING;
				detachParachute();
			}
		}

		public function setTakenState():void {
			takenAnimationTime = TAKEN_ANIMATION_TIME;
			_skin.alpha = 1;
			if (bonusState == BonusState.FALLING)
				detachParachute();
			bonusState = BonusState.TAKEN;
		}

		public function setRemovedState():void {
			bonusState = BonusState.REMOVING;
		}

		public function attach(pos:Vector3, rigidWorld:PhysicsScene, container:Object3DContainer, listener:IBonusListener):void {
			rigidWorld.addBody(this);
			TanksCollisionDetector(rigidWorld.collisionDetector).addBody(this);
			container.addChild(_skin);
			state.pos.x = pos.x + 50;
			state.pos.y = pos.y + 50;
			state.pos.z = pos.z;
			state.rotation.z = 0.15;
			prevState.copy(state);
			if (bonusState == BonusState.FALLING) {
				rigidWorld.addBody(parachute);
				parachute.addToContainer(container);
				for each (var c:MaxDistanceConstraint in cordsConstaints)
					rigidWorld.addConstraint(c);
				parachute.state.pos.vCopy(pos);
				parachute.state.pos.z += 0.5*CORDS_LENGTH;
				parachute.state.rotation.z = 0.3;
				parachute.prevState.copy(parachute.state);
				container.addChild(cordsMesh);
				physicsState = PHYSICS_STATE_FULL;
			} else {
				physicsState = PHYSICS_STATE_BOX;
			}
			updateSkin(1);
			this.bonusListener = listener;
		}

		public function update(time:int, millis:int, interpolationTime:Number):Boolean {
			updateSkin(interpolationTime);
			timeToLive -= millis;

			if (bonusState == BonusState.FALLING)
				return true;

			if (bonusState == BonusState.TAKEN) {
				if (takenAnimationTime < 0)
					return false;
				playTakenAnimation(millis);
			}
			// постепенно растворяется парашют
			if (parachuteTimeLeft > 0) {
				parachuteTimeLeft -= millis;
				if (parachuteTimeLeft <= 0) {
					removeParachuteGraphics();
					removeParachutePhysics();
				} else {
					cordsMesh.alpha = parachute.outerMesh.alpha = parachute.innerMesh.alpha = parachuteTimeLeft/PARACHUTE_REMOVAL_TIME;
				}
			}
			// Анимация, сигнализирующая о скором исчезновении бонуса
			if ((bonusState == BonusState.RESTING || bonusState == BonusState.REMOVING) && timeToLive < WARNING_TIME)
				playWarningAnimation(time, millis);

			if (bonusState == BonusState.REMOVING && timeToLive > WARNING_TIME)
				return false;

			return bonusState != BonusState.REMOVED;
		}

		public function destroy():void {
			_skin.alternativa3d::removeFromParent();
			removeParachuteGraphics();
			removeCordConstraints();
			removeParachutePhysics();
			TanksCollisionDetector(world.collisionDetector).removeBody(this);
			world.removeBody(this);
			pool.objects[pool.numObjects++] = this;
		}

		public function considerCollision(primitive:CollisionPrimitive):Boolean {
			if (primitive.body == null) {
 				if (bonusState == BonusState.FALLING)
					onStaticCollision();
				return true;
			} else {
				if (primitive.body is Tank)
					onTankCollision();
				return false;
			}
		}

		private function onStaticCollision():void {
			bonusState = BonusState.RESTING;
			detachParachute();
			bonusListener.onBonusDropped(this);
		}

		private function detachParachute():void {
			removeCordConstraints();
			startParachuteDissolving();
		}

		private function startParachuteDissolving():void {
			parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
		}

		private function onTankCollision():void {
			collisionPrimitives.head.primitive.collisionGroup &= ~CollisionGroup.BONUS_WITH_TANK;
			bonusListener.onTankCollision(this);
		}

		override public function updateSkin(t:Number):void {
			super.updateSkin(t);
			if (parachute != null) {
				parachute.updateSkin(t);
				cordsMesh.updateVertices();
			}
		}

		private function createParachuteAndCords(parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordsMaterial:Material):void {
			parachute = new Parachute(PARACHUTE_MASS, PARACHUTE_RADIUS, 10, 0.8, 0, parachuteMesh, parachuteInnerMesh);
			cordsMesh = new Cords(266, BOX_HALF_SIZE, 12, skin, parachute.outerMesh);
			cordsMesh.setMaterialToAllFaces(cordsMaterial);
			cordsConstaints = new Vector.<MaxDistanceConstraint>();
			var numStraps:int = 4;
			var angleStep:Number = 2*Math.PI/numStraps;
			for (var i:int = 0; i < numStraps; i++) {
				var angle:Number = i*angleStep;
				var x:Number = PARACHUTE_RADIUS*Math.cos(angle);
				var y:Number = PARACHUTE_RADIUS*Math.sin(angle);
				cordsConstaints.push(new MaxDistanceConstraint(parachute, this, new Vector3(x, y, 0), new Vector3(0, 0, 50), CORDS_LENGTH));
			}
		}

		private function removeParachuteGraphics():void {
			parachute.removeFromContainer();
			cordsMesh.alternativa3d::removeFromParent();
		}

		private function removeCordConstraints():void {
			if (physicsState == PHYSICS_STATE_FULL) {
				for each (var c:MaxDistanceConstraint in cordsConstaints)
					c.altphysics::world.removeConstraint(c);
				parachute.state.rotation.vScale(0.05);
				parachute.altphysics::saveState();
				physicsState = PHYSICS_STATE_PARABOX;
			}
		}

		private function removeParachutePhysics():void {
			if (physicsState == PHYSICS_STATE_PARABOX) {
				parachute.world.removeBody(parachute);
				physicsState = PHYSICS_STATE_BOX;
			}
		}

		/**
		 * Проигрывает анимацию, предупреждающую скорое исчезновение бонуса. Если бонус в невидимой фазе
		 * и находится в состоянии удаления, то он меняет состояние на удалённое.
		 */
		private function playWarningAnimation(time:int, deltaMsec:Number):void {
			if (visibilitySwitchTime == 0) {
				// Первый вызов метода. Бонус прячется и устанавливается время его следующего проявления.
				alphaSpeed = -COEFF*DELTA_ALPHA/currBlinkInterval;
				visibilitySwitchTime = time + currBlinkInterval;
			} else {
				skin.alpha += alphaSpeed*deltaMsec;
				if (bonusState == BonusState.REMOVING && alphaSpeed < 0) {
					if (skin.alpha <= 0)
						bonusState = BonusState.REMOVED;
				} else {
					if (skin.alpha < MIN_ALPHA)
						skin.alpha = MIN_ALPHA;
					// Очередной вызов метода. Меняется видимость бонуса, устанавливается следующее время смены видимости.
					if (time >= visibilitySwitchTime) {
						if (currBlinkInterval > 22)
							currBlinkInterval -= 12;
						visibilitySwitchTime += currBlinkInterval;
						if (alphaSpeed < 0) {
							alphaSpeed = COEFF*DELTA_ALPHA/currBlinkInterval;
							skin.alpha = MIN_ALPHA;
						} else {
							alphaSpeed = -COEFF*DELTA_ALPHA/currBlinkInterval;
							skin.alpha = 1;
						}
					}
				}
			}
		}

		private function playTakenAnimation(millis:int):void {
			// Нейтрализуем силу тяжести
			addForce(new Vector3(0, 0, world._gravity.vLength()/invMass));
			// Подъём и поворот бонуса
			state.velocity.vReset(0, 0, UP_SPEED*takenAnimationTime/TAKEN_ANIMATION_TIME + UP_SPEED*0.1);
			state.rotation.vReset(0, 0, ANGLE_SPEED*takenAnimationTime/TAKEN_ANIMATION_TIME + ANGLE_SPEED*0.1);
			// Вспышка поднятого бонуса
			if (takenAnimationTime > TAKEN_ANIMATION_TIME - FLASH_DURATION) {
				additiveValue += ADDITIVE_SPEED_UP*millis;
				if (additiveValue > MAX_ADDITIVE_VALUE)
					additiveValue = MAX_ADDITIVE_VALUE;
			} else {
				additiveValue -= ADDITIVE_SPEED_DOWN*millis;
				if (additiveValue < 0)
					additiveValue = 0;
			}
			if (skin.colorTransform == null)
				skin.colorTransform = new ColorTransform();
			skin.colorTransform.redOffset = skin.colorTransform.blueOffset = skin.colorTransform.greenOffset = additiveValue;
			if (takenAnimationTime < ALPHA_DURATION)
				skin.alpha = takenAnimationTime/ALPHA_DURATION;
			takenAnimationTime -= millis;
		}

	}
}

import alternativa.tanks.models.effects.common.bonuscommon.ParaBonus;

class Pool {

	public var objects:Vector.<ParaBonus> = new Vector.<ParaBonus>();
	public var numObjects:int;

}
