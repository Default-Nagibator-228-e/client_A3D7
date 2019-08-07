package alternativa.tanks.vehicles.tanks {
	
	/**
	 * 
	 */
	public class TankPhysicsData {

		public static var fields:Array = [
			"mass",
			"springDamping",
			"power",
			"maxForwardSpeed",
			"maxBackwardSpeed",
			"maxTurnSpeed",
			"drivingForceOffsetZ",
			"smallVelocity",
			"rayRestLengthCoeff",
			
			"dynamicFriction",
			"brakeFriction",
			"sideFriction",
			
			"spotTurnPowerCoeff",
			"spotTurnDynamicFriction",
			"spotTurnSideFriction",
			
			"moveTurnPowerCoeffInner",
			"moveTurnPowerCoeffOuter",
			"moveTurnDynamicFrictionInner",
			"moveTurnDynamicFrictionOuter",
			"moveTurnSideFriction",
			"moveTurnSpeedCoeffInner",
			"moveTurnSpeedCoeffOuter"
		];

		// Масса танка
		public var mass:Number = 1000;
		// Мощность двигателя. Абстрактная величина, подбирается опытным путём. 
		public var power:Number = 1000000;
		// Максимальная скорость движения вперёд, ед/с
		public var maxForwardSpeed:Number = 600;
		// Максимальная скорость движения назад, ед/с
		public var maxBackwardSpeed:Number = 600;
		// Маскимальная угловая скорость разворота на месте, рад/с
		public var maxTurnSpeed:Number = 2;
		// Коэффициент демпфирования подвески
		public var springDamping:Number = 1000;
		// Смещение точки приложения силы для каждого луча подвески. Точка смещается вдоль луча, положительное направление совпадает с локальной осью Z луча
		public var drivingForceOffsetZ:Number = 0;
		// Малая скорость, используемая при вычислении силы трения. Сила трения линейно уменьшается в малой окрестности скорости до нуля.
		public var smallVelocity:Number = 100;
		// Коэффициент отношения полной длины луча подвески к его нормальной длине. Нормальная длина, это такая длина лучей подвески, при которой скин танка касается
		// горизонтальной поверхности. Нормальная длина задаётся относительным положением скина танка и точек монтирования лучей подвески.
		public var rayRestLengthCoeff:Number = 1.5;
		
		// Коэффициент продольной силы трения при движении вперёд или назад, когда направления движения и силы тяги совпадают
		public var dynamicFriction:Number = 0.1;
		// Коэффициент продольной силы трения при движении вперёд или назад, когда направления движения и силы тяги не совпадают, либо сила тяги равна нулю
		public var brakeFriction:Number = 2;
		// Коэффициент боковой силы трения при прямолинейном движении или в покое
		public var sideFriction:Number = 3;

		// Коэффициент изменения силы тяги при повороте на месте
		public var spotTurnPowerCoeff:Number = 1;
		//
		public var spotTurnDynamicFriction:Number = 0.1;
		// Коэффициент боковой силы трения при повороте на месте
		public var spotTurnSideFriction:Number = 2;

		// Коэффициент изменения силы тяги внешней гусеницы при повороте во время движения
		public var moveTurnPowerCoeffOuter:Number = 3;
		// Коэффициент изменения силы тяги внутренней гусеницы при повороте во время движения
		public var moveTurnPowerCoeffInner:Number = 0;
		//
		public var moveTurnDynamicFrictionInner:Number = 0.2;
		//
		public var moveTurnDynamicFrictionOuter:Number = 0.1;
		// Коэффициент боковой силы трения при повороте во время движения
		public var moveTurnSideFriction:Number = 2;
		// Коэффициент ограничения скорости для внутренней гусеницы в повороте во время движения
		public var moveTurnSpeedCoeffInner:Number = 0.7;
		// Коэффициент ограничения скорости для внешней гусеницы в повороте во время движения
		public var moveTurnSpeedCoeffOuter:Number = 0.7;
		
		/**
		 * Копирует значения из источника.
		 * 
		 * @param source источник
		 */
		public function copy(source:TankPhysicsData):void {
			mass = source.mass;
			power = source.power;
			maxForwardSpeed = source.maxForwardSpeed;
			maxBackwardSpeed = source.maxBackwardSpeed;
			maxTurnSpeed = source.maxTurnSpeed;
			springDamping = source.springDamping;
			drivingForceOffsetZ = source.drivingForceOffsetZ;
			smallVelocity = source.smallVelocity;
			rayRestLengthCoeff = source.rayRestLengthCoeff;
			
			dynamicFriction = source.dynamicFriction;
			brakeFriction = source.brakeFriction;
			sideFriction = source.sideFriction;
			
			spotTurnPowerCoeff = source.spotTurnPowerCoeff;
			spotTurnDynamicFriction = source.spotTurnDynamicFriction;
			spotTurnSideFriction = source.spotTurnSideFriction;
			
			moveTurnPowerCoeffOuter = source.moveTurnPowerCoeffOuter;
			moveTurnPowerCoeffInner = source.moveTurnPowerCoeffInner;
			moveTurnDynamicFrictionInner = source.moveTurnDynamicFrictionInner;
			moveTurnDynamicFrictionOuter = source.moveTurnDynamicFrictionOuter;
			moveTurnSideFriction = source.moveTurnSideFriction;
			moveTurnSpeedCoeffInner = source.moveTurnSpeedCoeffInner;
			moveTurnSpeedCoeffOuter = source.moveTurnSpeedCoeffOuter;
		}
		
		/**
		 * 
		 */
		public function getXml():XML {
			var xml:XML = <profile></profile>;
			for each (var fieldName:String in fields) {
				xml.appendChild(XML("<" + fieldName + ">" + this[fieldName] + "</" + fieldName + ">"));
			}
			return xml;
		}
		
		/**
		 * 
		 * @param xml
		 */
		public function loadFromXml(xml:XML):void {
			for each (var fieldName:String in fields) {
				this[fieldName] = Number(xml.elements(fieldName)[0]);
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function clone():TankPhysicsData {
			var data:TankPhysicsData = new TankPhysicsData();
			data.copy(this);
			return data;
		}
		
	}
}