package alternativa.tanks.vehicles.tanks {
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.math.Matrix3;
	import alternativa.math.Vector3;
	import alternativa.physics.Body;
	import alternativa.physics.BodyState;
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.types.RayIntersection;
	import flash.display.Graphics;
	
	use namespace altphysics;
	
	/**
	 * 
	 */
	public class SuspensionRay {
		
		public var next:SuspensionRay;
		
		public var collisionGroup:int;
		
		public var _track:Track;
		
		private var relPos:Vector3;
		private var relDir:Vector3;
		
		public var worldPos:Vector3 = new Vector3();
		public var worldDir:Vector3 = new Vector3();

		public var lastCollided:Boolean = false;
		public var lastIntersection:RayIntersection = new RayIntersection();
		private var prevDisplacement:Number = 100;
		private var predicate:RayPredicate;
		
		private var dynamicFriction:Number = 0;
		private var sideFriction:Number = 0;
		private var powerCoeff:Number = 0;
		private var inner:Boolean;
		private var body:Body;
		private var ta:Tank;

		/**
		 * 
		 * @param chassis
		 * @param relPos
		 * @param relDir
		 */
		public function SuspensionRay(body:Tank, relPos:Vector3, relDir:Vector3) {
			this.relPos = relPos.vClone();
			this.relDir = relDir.vClone();
			this.body = body as Body;
			this.ta = body;
			predicate = new RayPredicate(body);
		}
		
		/**
		 * 
		 */
		public function updateCachedValues(rayIndex:int, numRays:int):void {
			var moveDirection:int = ta.movedir;//chassis._moveDirection;
			var turnDirection:int = ta.turndir;// chassis._turnDirection;
			var pData:TankPhysicsData = ta.tpd;
			var mid:Number = 0.5*(numRays - 1);
			if (moveDirection == 0) {
				if (turnDirection == 0) {
					// Нет управляющих воздействий
					powerCoeff = 0;
					sideFriction = pData.sideFriction;
					dynamicFriction = pData.dynamicFriction;
				} else {
					if ((turnDirection < 0 && relPos.x < 0) || (turnDirection > 0 && relPos.x > 0)) {
						// Внутренняя сторона при повороте на месте
						powerCoeff = -pData.spotTurnPowerCoeff;
					} else {
						// Внешняя сторона при повороте на месте
						powerCoeff = pData.spotTurnPowerCoeff;
					}
					if (rayIndex <= mid) {
						sideFriction = pData.spotTurnSideFriction*rayIndex/mid;
					} else {
						sideFriction = pData.spotTurnSideFriction*(numRays - rayIndex - 1)/mid;
					}
					dynamicFriction = pData.spotTurnDynamicFriction;
				}
			} else {
				// Есть поступательное движение
				if (turnDirection == 0) {
					if (moveDirection < 0) {
						powerCoeff = -1;
					} else {
						powerCoeff = 1;
					}
					sideFriction = pData.sideFriction;
					dynamicFriction = pData.dynamicFriction;
				} else {
					if ((turnDirection < 0 && relPos.x < 0) || (turnDirection > 0 && relPos.x > 0)) {
						inner = true;
						powerCoeff = pData.moveTurnPowerCoeffInner;
						dynamicFriction = pData.moveTurnDynamicFrictionInner;
					} else {
						inner = false;
						powerCoeff = pData.moveTurnPowerCoeffOuter;
						dynamicFriction = pData.moveTurnDynamicFrictionOuter;
					}
					if (moveDirection < 0) {
						powerCoeff = -powerCoeff;
					}
					if (moveDirection > 0) {
						if (rayIndex <= mid) {
							sideFriction = pData.moveTurnSideFriction*rayIndex/mid;
						} else {
							sideFriction = pData.moveTurnSideFriction;
						}
					} else {
						if (rayIndex <= mid) {
							sideFriction = pData.moveTurnSideFriction;
						} else {
							sideFriction = pData.moveTurnSideFriction*(numRays - rayIndex - 1)/mid;
						}
					}
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function calculateIntersection(maxLength:Number) : Boolean
		  {
			 var p:Vector3 = null;
			 this.body.baseMatrix.transformVector(this.relDir,this.worldDir);
			 this.body.baseMatrix.transformVector(this.relPos,this.worldPos);
			 p = this.body.state.pos;
			 this.worldPos.x += p.x;
			 this.worldPos.y += p.y;
			 this.worldPos.z += p.z;
			 if(this.lastCollided)
			 {
				this.prevDisplacement = maxLength - this.lastIntersection.t;
			 }
			 return this.lastCollided = this.body.world.collisionDetector.intersectRay(this.worldPos,this.worldDir,this.collisionGroup,maxLength,this.predicate,this.lastIntersection);
		  }
		  
		  public function debugDraw(g:Graphics, camera:Camera3D, data:SuspensionData) : void
		  {
			  
		  }
		  
		  public function getGlobalOrigin() : Vector3
		  {
			 return this.worldPos;
		  }
		
		/**
		 * Применяет к шасси силу упругости и тяги.
		 * 
		 * @param dt
		 * @param springCoeff
		 * @param power
		 */
		public function addForce(dt:Number, data:SuspensionData, springCoeff:Number, power:Number):void {
			if (!lastCollided) return;
			
			power *= powerCoeff;
			
			var pData:TankPhysicsData = ta.tpd;
			var rot:Vector3 = body.state.rotation;
			var globalMatrix:Matrix3 = body.baseMatrix;
			
			var turnSpeed:Number = rot.x*globalMatrix.c + rot.y*globalMatrix.g + rot.z*globalMatrix.k;
			
//			if (lastIntersection.t > suspensionData.rayOptimalLength) {
//				throttle *= (suspensionData.rayLength - lastIntersection.t)/(suspensionData.rayLength - suspensionData.rayOptimalLength);
//			}
			
			// Базис системы координат точки контакта
			// UP
			var grndUpX:Number = lastIntersection.normal.x;
			var grndUpY:Number = lastIntersection.normal.y;
			var grndUpZ:Number = lastIntersection.normal.z;
			
			// RIGHT
			var x:Number = globalMatrix.b;
			var y:Number = globalMatrix.f;
			var z:Number = globalMatrix.j;
			var grndRightX:Number = y*grndUpZ - z*grndUpY;
			var grndRightY:Number = z*grndUpX - x*grndUpZ;
			var grndRightZ:Number = x*grndUpY - y*grndUpX;
			var len:Number = grndRightX*grndRightX + grndRightY*grndRightY + grndRightZ*grndRightZ;
			if (len == 0) {
				grndRightX = globalMatrix.a;
				grndRightY = globalMatrix.e;
				grndRightZ = globalMatrix.i;
			} else {
				len = 1/Math.sqrt(len);
				grndRightX *= len;
				grndRightY *= len;
				grndRightZ *= len;
			}
			
			// FORWARD
			var grndFwdX:Number = grndUpY*grndRightZ - grndUpZ*grndRightY;
			var grndFwdY:Number = grndUpZ*grndRightX - grndUpX*grndRightZ;
			var grndFwdZ:Number = grndUpX*grndRightY - grndUpY*grndRightX;
			
			// Относительная скорость в точке контакта
			var state:BodyState = body.state;
			x = lastIntersection.pos.x - state.pos.x;
			y = lastIntersection.pos.y - state.pos.y;
			z = lastIntersection.pos.z - state.pos.z;
			var relVelX:Number = rot.y*z - rot.z*y + state.velocity.x;
			var relVelY:Number = rot.z*x - rot.x*z + state.velocity.y;
			var relVelZ:Number = rot.x*y - rot.y*x + state.velocity.z;
			
			if (lastIntersection.primitive.body != null) {
				state = lastIntersection.primitive.body.state;
				x = lastIntersection.pos.x - state.pos.x;
				y = lastIntersection.pos.y - state.pos.y;
				z = lastIntersection.pos.z - state.pos.z;
				rot = state.rotation;
				relVelX -= rot.y*z - rot.z*y + state.velocity.x;
				relVelY -= rot.z*x - rot.x*z + state.velocity.y;
				relVelZ -= rot.x*y - rot.y*x + state.velocity.z;
			}
			var relSpeed:Number = Math.sqrt(relVelX*relVelX + relVelY*relVelY + relVelZ*relVelZ);
			var fwdSpeed:Number = relVelX*grndFwdX + relVelY*grndFwdY + relVelZ*grndFwdZ;

			var fx:Number;
			var fy:Number;
			var fz:Number;
			// Приложение тяги. Тяга прикладывается вдоль оси Y системы координат контакта луча с поверхностью.
			// TODO: Ограничить максимальный угол наклона поверхности
			var drivingForceOffsetZ:Number = pData.drivingForceOffsetZ;

			var moveDirection:int = ta.movedir;//_moveDirection;
			var turnDirection:int = ta.turndir;//_turnDirection;

			var worldUpX:Number = body.baseMatrix.c;
			var worldUpY:Number = body.baseMatrix.g;
			var worldUpZ:Number = body.baseMatrix.k;
			// Сила упругости от подвески
			var t:Number = lastIntersection.t;
			var currDisplacement:Number = pData.rayRestLengthCoeff - t;
			var springForce:Number = springCoeff*currDisplacement*(worldUpX*lastIntersection.normal.x + worldUpY*lastIntersection.normal.y + worldUpZ*lastIntersection.normal.z);
			var upSpeed:Number = (currDisplacement - prevDisplacement)/dt;
//			if (upSpeed > 0) {
				springForce += upSpeed*pData.springDamping;
//			}
			if (springForce < 0) {
				springForce = 0;
			}
			fx = -springForce*worldDir.x;
			fy = -springForce*worldDir.y;
			fz = -springForce*worldDir.z;

			// Учёт силы трения
			if (relSpeed > 0.001) {
				// Боковая сила трения
				var slipSpeed:Number = relVelX*grndRightX + relVelY*grndRightY + relVelZ*grndRightZ;
				var smallVelocity:Number = pData.smallVelocity;
				var frictionForce:Number = sideFriction*springForce*slipSpeed/relSpeed;
				if (slipSpeed > -smallVelocity && slipSpeed < smallVelocity) {
					frictionForce *= slipSpeed/smallVelocity;
					if (slipSpeed < 0) {
						frictionForce = -frictionForce;
					}
				}
				fx -= frictionForce*grndRightX;
				fy -= frictionForce*grndRightY;
				fz -= frictionForce*grndRightZ;
				
				// Продольная сила трения
				var friction:Number;
				if ((fwdSpeed <= 0 && power >= 0) || (fwdSpeed >= 0 && power <= 0)) {
					friction = pData.brakeFriction;
				}	else {
					friction = dynamicFriction;
				}
				frictionForce = friction*springForce*fwdSpeed/relSpeed;
				if (fwdSpeed > -smallVelocity && fwdSpeed < smallVelocity) {
					frictionForce *= fwdSpeed/smallVelocity;
					if (fwdSpeed < 0) {
						frictionForce = -frictionForce;
					}
				}
				fx -= frictionForce*grndFwdX;
				fy -= frictionForce*grndFwdY;
				fz -= frictionForce*grndFwdZ;
			}
			
			x = worldPos.x + drivingForceOffsetZ*worldDir.x;
			y = worldPos.y + drivingForceOffsetZ*worldDir.y;
			z = worldPos.z + drivingForceOffsetZ*worldDir.z;

			if (moveDirection == 0) {
				// При вращении ограничивается угловая скорость
				if ((turnDirection < 0 && turnSpeed > pData.maxTurnSpeed) || (turnDirection > 0 && turnSpeed < -pData.maxTurnSpeed)) {
					power *= 0.1;
				}
			} else {
				// При наличии поступающей составляющей ограничивается линейная скорость
				var k:Number;
				if (turnDirection == 0) {
					k = 1;
				} else {
					k = inner ? pData.moveTurnSpeedCoeffInner : pData.moveTurnSpeedCoeffOuter;
				}
				if ((power > 0 && fwdSpeed > k*pData.maxForwardSpeed) || (power < 0 && -fwdSpeed > k*pData.maxBackwardSpeed)) {
					power *= 0.1;
				}
			}

			fx += power*grndFwdX;
			fy += power*grndFwdY;
			fz += power*grndFwdZ;

			body.addWorldForceXYZ(x, y, z, fx, fy, fz);
		}
	
	}
}
	import alternativa.physics.collision.IRayCollisionPredicate;
	import alternativa.physics.Body;
	
	/**
	 * 
	 */
	class RayPredicate implements IRayCollisionPredicate {
		
		private var body:Body;
		
		/**
		 * 
		 */
		public function RayPredicate(body:Body) {
			this.body = body;
		}
		
		/**
		 * 
		 */
		public function considerBody(body:Body):Boolean {
			return this.body != body;
		}
	}