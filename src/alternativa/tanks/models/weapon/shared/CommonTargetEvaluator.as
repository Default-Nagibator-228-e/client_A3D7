package alternativa.tanks.models.weapon.shared
{
   import alternativa.physics.Body;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.ctf.ICTFModel;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.vehicles.tanks.Tank;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class CommonTargetEvaluator implements ICommonTargetEvaluator
   {
      
      private static const DISTANCE_WEIGHT:Number = 0.65;
      
      private static const MAX_PRIORITY:Number = 1000;
       
      
      private var localTankData:TankData;
      
      private var ctfModel:ICTFModel;
      
      private var fullDamageDistance:Number;
      
      private var maxAngle:Number;
      
      public function CommonTargetEvaluator(localTankData:TankData, ctfModel:ICTFModel, fullDamageDistance:Number, maxAngle:Number)
      {
         super();
         this.localTankData = localTankData;
         this.ctfModel = ctfModel;
         this.fullDamageDistance = fullDamageDistance;
         this.maxAngle = maxAngle;
      }
      
      public static function create(localTankData:TankData, localShotData:ShotData, battlefieldModel:IBattleField, weaponWeakeningModel:IWeaponWeakeningModel, modelService:IModelService) : CommonTargetEvaluator
      {
         var baseDistance:Number = NaN;
         if(weaponWeakeningModel != null)
         {
            baseDistance = weaponWeakeningModel.getFullDamageRadius(localTankData.turret);
         }
         else
         {
            baseDistance = 10000;
         }
         var maxAngle:Number = localShotData.autoAimingAngleUp.value > localShotData.autoAimingAngleDown.value?Number(localShotData.autoAimingAngleUp.value):Number(localShotData.autoAimingAngleDown.value);
         return new CommonTargetEvaluator(localTankData,null,baseDistance,maxAngle);
      }
      
      public function getTargetPriority(target:Body, distance:Number, angle:Number) : Number
      {
         var targetTank:Tank = target as Tank;
         if(targetTank == null)
         {
            return 0;
         }
         if(targetTank.tankData.health == 0)
         {
            return 0;
         }
         var targetTeamType:BattleTeamType = targetTank.tankData.teamType;
         if(targetTeamType == BattleTeamType.NONE)
         {
            return this.getPriority(distance,angle);
         }
         if(targetTeamType == this.localTankData.teamType)
         {
            return 0;
         }
         var priority:Number = this.getPriority(distance,angle);
         if(this.ctfModel != null && this.ctfModel.isFlagCarrier(targetTank.tankData))
         {
            priority = priority + MAX_PRIORITY;
         }
         return priority;
      }
      
      private function getPriority(distance:Number, angle:Number) : Number
      {
         return MAX_PRIORITY - (DISTANCE_WEIGHT * distance / this.fullDamageDistance + (1 - DISTANCE_WEIGHT) * angle / this.maxAngle);
      }
   }
}
