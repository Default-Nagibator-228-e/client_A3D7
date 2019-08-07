package alternativa.tanks.models.weapon.railgun
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.ctf.ICTFModel;
   import alternativa.tanks.models.sfx.shoot.railgun.IRailgunSFXModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponConst;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   import utils.client.commons.types.Vector3d;
   import utils.client.warfare.models.tankparts.weapon.railgun.IRailgunModelBase;
   import utils.client.warfare.models.tankparts.weapon.railgun.RailgunModelBase;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   public class RailgunModel extends RailgunModelBase implements IModel, IRailgunModelBase, IWeaponController, IObjectLoadListener
   {
      
      private static const DECAL_RADIUS:Number = 50;
      [Embed(source="r/1.png")]
      private static const DECAL:Class;
      
      private static var decalMaterial:TextureMaterial;
       
      
      private const INFINITY:Number = 20000;
      
      private var modelService:IModelService;
      
      private var battlefieldModel:IBattleField;
      
      private var tankModel:ITank;
      
      private var commonModel:IWeaponCommonModel;
      
      private var localTankData:TankData;
      
      private var localShotData:ShotData;
      
      private var localRailgunData:RailgunData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var weaponUtils:WeaponUtils;
      
      private var _triggerPressed:Boolean;
      
      private var chargeTimeLeft:int;
      
      private var nextReadyTime:int;
      
      private var targetSystem:RailgunTargetSystem;
      
      private var shotResult:RailgunShotResult;
      
      private var _globalHitPosition:Vector3;
      
      private var _xAxis:Vector3;
      
      private var _globalMuzzlePosition:Vector3;
      
      private var _globalGunDirection:Vector3;
      
      private var _barrelOrigin:Vector3;
      
      private var _hitPos3d:Vector3d;
      
      private var targetPositions:Array;
      
      private var targetIncarnations:Array;
	  
	  private var railgunSfxModel:IRailgunSFXModel = null;
      
      public function RailgunModel()
      {
         this.weaponUtils = WeaponUtils.getInstance();
         this.targetSystem = new RailgunTargetSystem();
         this.shotResult = new RailgunShotResult();
         this._globalHitPosition = new Vector3();
         this._xAxis = new Vector3();
         this._globalMuzzlePosition = new Vector3();
         this._globalGunDirection = new Vector3();
         this._barrelOrigin = new Vector3();
         this._hitPos3d = new Vector3d(0,0,0);
         this.targetPositions = [];
         this.targetIncarnations = [];
         super();
         _interfaces.push(IModel,IRailgunModelBase,IWeaponController,IObjectLoadListener);
         this.objectLoaded(null);
         if(decalMaterial == null)
         {
            decalMaterial = new TextureMaterial(new DECAL().bitmapData);
         }
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         if(this.commonModel == null)
         {
            this.modelService = Main.osgi.getService(IModelService) as IModelService;
            this.battlefieldModel = Main.osgi.getService(IBattleField) as IBattleField;
            this.tankModel = Main.osgi.getService(ITank) as ITank;
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
      }
      
      public function initObject(clientObject:ClientObject, chargingTimeMsec:int, weakeningCoeff:Number) : void
      {
         var railgunData:RailgunData = new RailgunData();
         railgunData.chargingTime = chargingTimeMsec;
         railgunData.weakeningCoeff = weakeningCoeff;
         clientObject.putParams(RailgunModel,railgunData);
         this.objectLoaded(clientObject);
      }
      
      public function startFire(clientObject:ClientObject, firingTankId:String) : void
      {
         var firingTank:ClientObject = clientObject;
         if(firingTank == null)
         {
            return;
         }
         if(this.tankModel == null)
         {
            this.tankModel = Main.osgi.getService(ITank) as ITank;
         }
         var firingTankData:TankData = this.tankModel.getTankData(firingTank);
         if(firingTankData.tank == null || !firingTankData.enabled || firingTankData.local)
         {
            return;
         }
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         var commonData:WeaponCommonData = this.commonModel.getCommonData(firingTankData.turret);
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[0],this._globalMuzzlePosition,this._globalGunDirection);
         var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(firingTankData.turret);
         var railgunData:RailgunData = this.getRailgunData(firingTankData.turret);
         var graphicEffect:IGraphicEffect = railgunSfxModel.createChargeEffect(firingTankData.turret,firingTankData.user,commonData.muzzles[commonData.currBarrel],firingTankData.tank.skin.turretMesh,railgunData.chargingTime);
         if(this.battlefieldModel == null)
         {
            this.battlefieldModel = Main.osgi.getService(IBattleField) as IBattleField;
         }
         this.battlefieldModel.addGraphicEffect(graphicEffect);
         var soundEffect:ISound3DEffect = railgunSfxModel.createSoundShotEffect(firingTankData.turret,firingTankData.user,this._globalMuzzlePosition);
         if(soundEffect != null)
         {
            this.battlefieldModel.addSound3DEffect(soundEffect);
         }
      }
      
      public function fire(clientObject:ClientObject, firingTankId:String, affectedPoints:Array, affectedTankIds:Array) : void
      {
         var firingTankData:TankData = null;
         var commonData:WeaponCommonData = null;
         var railGunData:RailgunData = null;
         var v:Vector3d = null;
         var impactForce:Number = NaN;
         var i:int = 0;
         var affectedTankObject:ClientObject = null;
         var affectedTankData:TankData = null;
         var firingTank:ClientObject = clientObject;
         if(firingTank == null)
         {
            return;
         }
         firingTankData = this.tankModel.getTankData(firingTank);
         if(firingTankData == null || firingTankData.tank == null || !firingTankData.enabled || firingTankData.local)
         {
            return;
         }
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         if(this.battlefieldModel == null)
         {
            this.battlefieldModel = Main.osgi.getService(IBattleField) as IBattleField;
         }
         commonData = this.commonModel.getCommonData(firingTankData.turret);
         railGunData = this.getRailgunData(firingTankData.turret);
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[0],this._globalMuzzlePosition,this._globalGunDirection);
         var numPoints:int = affectedPoints.length;
         impactForce = commonData.impactForce;
         if(affectedTankIds != null)
         {
            for(i = 0; i < numPoints - 1; i++)
            {
               affectedTankObject = BattleController.activeTanks[affectedTankIds[i]];
               if(affectedTankObject != null)
               {
                  affectedTankData = this.tankModel.getTankData(affectedTankObject);
                  if(!(affectedTankData == null || affectedTankData.tank == null))
                  {
                     v = affectedPoints[i];
                     this._globalHitPosition.x = v.x;
                     this._globalHitPosition.y = v.y;
                     this._globalHitPosition.z = v.z;
                     this._globalHitPosition.vTransformBy3(affectedTankData.tank.baseMatrix);
                     this._globalHitPosition.vAdd(affectedTankData.tank.state.pos);
                     affectedTankData.tank.addWorldForceScaled(this._globalHitPosition,this._globalGunDirection,impactForce);
                     this.battlefieldModel.tankHit(affectedTankData,this._globalGunDirection,impactForce / WeaponConst.BASE_IMPACT_FORCE);
                     impactForce = impactForce * railGunData.weakeningCoeff;
                  }
               }
            }
         }
         v = affectedPoints[numPoints - 1];
         this._globalHitPosition.x = v.x;
         this._globalHitPosition.y = v.y;
         this._globalHitPosition.z = v.z;
         firingTankData.tank.addWorldForceScaled(this._globalMuzzlePosition,this._globalGunDirection,-commonData.kickback);
         var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(firingTankData.turret);
         var graphicEffect:IGraphicEffect = railgunSfxModel.createGraphicShotEffect(firingTankData.turret,this._globalMuzzlePosition,this._globalHitPosition);
         if(graphicEffect != null)
         {
            this.battlefieldModel.addGraphicEffect(graphicEffect);
         }
      }
      
      public function activateWeapon(time:int) : void
      {
         this._triggerPressed = true;
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this._triggerPressed = false;
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.localTankData = localUserData;
         this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
         this.localRailgunData = this.getRailgunData(localUserData.turret);
         this.localWeaponCommonData = this.commonModel.getCommonData(localUserData.turret);
         var ctfModel:ICTFModel = null;
         this.battlefieldModel = Main.osgi.getService(IBattleField) as IBattleField;
         this.targetSystem.setParams(this.battlefieldModel.getBattlefieldData().physicsScene.collisionDetector,this.localShotData.autoAimingAngleUp.value,this.localShotData.numRaysUp.value,this.localShotData.autoAimingAngleDown.value,this.localShotData.numRaysDown.value,this.localRailgunData.weakeningCoeff,ctfModel);
         this.reset();
      }
      
      public function clearLocalUser() : void
      {
         this.localTankData = null;
         this.localShotData = null;
         this.localRailgunData = null;
         this.localWeaponCommonData = null;
      }
      
      public function update(time:int, deltaTime:int) : Number
      {
         var muzzleLocalPos:Vector3 = null;
         var graphicEffect:IGraphicEffect = null;
         var soundEffect:ISound3DEffect = null;
		 railgunSfxModel = WeaponsManager.getRailgunSFX(this.localTankData.turret);
         if(this.chargeTimeLeft > 0)
         {
            this.chargeTimeLeft = this.chargeTimeLeft - deltaTime;
            if(this.chargeTimeLeft <= 0)
            {
               this.chargeTimeLeft = 0;
               this.doFire(this.localWeaponCommonData,this.localTankData,time);
            }
            return this.chargeTimeLeft / this.localRailgunData.chargingTime;
         }
         if(time < this.nextReadyTime)
         {
            return 1 - (this.nextReadyTime - time) / this.localShotData.reloadMsec.value;
         }
         if(this._triggerPressed)
         {
            this.chargeTimeLeft = this.localRailgunData.chargingTime;
            muzzleLocalPos = this.localWeaponCommonData.muzzles[0];
            this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,muzzleLocalPos,this._globalMuzzlePosition,this._barrelOrigin,this._xAxis,this._globalGunDirection);
			//throw new Error(this.localTankData.turret + "	" + this.localTankData.user + "	" + muzzleLocalPos + "	" + this.localTankData.tank.skin.turretMesh + "	" + this.localRailgunData.chargingTime + "	" + railgunSfxModel);
            graphicEffect = railgunSfxModel.createChargeEffect(this.localTankData.turret,this.localTankData.user,muzzleLocalPos,this.localTankData.tank.skin.turretMesh,this.localRailgunData.chargingTime);
            if(graphicEffect != null)
            {
               this.battlefieldModel.addGraphicEffect(graphicEffect);
            }
            soundEffect = railgunSfxModel.createSoundShotEffect(this.localTankData.turret,this.localTankData.user,this._globalMuzzlePosition);
            if(soundEffect != null)
            {
               this.battlefieldModel.addSound3DEffect(soundEffect);
            }
            this.startFireCommand(this.localTankData.turret);
         }
         return 1;
      }
      
      private function startFireCommand(turr:ClientObject) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
      }
      
      public function reset() : void
      {
         this.nextReadyTime = this.chargeTimeLeft = 0;
         this._triggerPressed = false;
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
      }
      
      private function getRailgunData(clientObject:ClientObject) : RailgunData
      {
         return clientObject.getParams(RailgunModel) as RailgunData;
      }
      
      private function doFire(commonData:WeaponCommonData, tankData:TankData, time:int) : void
      {
         var len:int = 0;
         var i:int = 0;
         var currHitPoint:Vector3 = null;
         var currTankData:TankData = null;
         var v:Vector3 = null;
         this.nextReadyTime = time + this.localShotData.reloadMsec.value;
         this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh,commonData.muzzles[commonData.currBarrel],this._globalMuzzlePosition,this._barrelOrigin,this._xAxis,this._globalGunDirection);
         var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
         this.targetSystem.getTargets(tankData,this._barrelOrigin,this._globalGunDirection,this._xAxis,bfData.tanks,this.shotResult);
         if(this.shotResult.hitPoints.length == 0)
         {
            this._globalHitPosition.x = this._hitPos3d.x = this._globalMuzzlePosition.x + this.INFINITY * this._globalGunDirection.x;
            this._globalHitPosition.y = this._hitPos3d.y = this._globalMuzzlePosition.y + this.INFINITY * this._globalGunDirection.y;
            this._globalHitPosition.z = this._hitPos3d.z = this._globalMuzzlePosition.z + this.INFINITY * this._globalGunDirection.z;
            this.fireCommand(tankData.turret,null,[this._hitPos3d],null,null);
         }
         else
         {
            this._globalHitPosition.vCopy(this.shotResult.hitPoints[this.shotResult.hitPoints.length - 1]);
            if(this.shotResult.hitPoints.length == this.shotResult.targets.length)
            {
               this._globalHitPosition.vSubtract(this._globalMuzzlePosition).vNormalize().vScale(this.INFINITY).vAdd(this._globalMuzzlePosition);
               this.shotResult.hitPoints.push(this._globalHitPosition);
            }
            this.shotResult.hitPoints[this.shotResult.hitPoints.length - 1] = new Vector3d(this._globalHitPosition.x,this._globalHitPosition.y,this._globalHitPosition.z);
            this.targetPositions.length = 0;
            this.targetIncarnations.length = 0;
            len = this.shotResult.targets.length;
            for(i = 0; i < len; i++)
            {
               currHitPoint = this.shotResult.hitPoints[i];
               currTankData = this.shotResult.targets[i];
               currTankData.tank.addWorldForceScaled(currHitPoint,this.shotResult.dir,commonData.impactForce);
               this.shotResult.targets[i] = currTankData.user.id;
               currHitPoint.vSubtract(currTankData.tank.state.pos).vTransformBy3Tr(currTankData.tank.baseMatrix);
               this.shotResult.hitPoints[i] = new Vector3d(currHitPoint.x,currHitPoint.y,currHitPoint.z);
               v = currTankData.tank.state.pos;
               this.targetPositions[i] = new Vector3d(v.x,v.y,v.z);
               this.targetIncarnations[i] = currTankData.incarnation;
            }
            if(len == 0)
            {
               this.battlefieldModel.addDecal(Vector3d(this.shotResult.hitPoints[0]).toVector3(),this._barrelOrigin,DECAL_RADIUS,decalMaterial);
            }
            this.fireCommand(tankData.turret,this.targetIncarnations,this.shotResult.hitPoints,this.shotResult.targets,this.targetPositions);
         }
         tankData.tank.addWorldForceScaled(this._globalMuzzlePosition,this._globalGunDirection,-commonData.kickback);
         var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(tankData.turret);
         var graphicEffect:IGraphicEffect = railgunSfxModel.createGraphicShotEffect(tankData.turret,this._globalMuzzlePosition,this._globalHitPosition);
         if(graphicEffect != null)
         {
            this.battlefieldModel.addGraphicEffect(graphicEffect);
         }
      }
      
      public function fireCommand(turret:ClientObject, targetInc:Array, hitPoints:Array, targets:Array, targetPostitions:Array) : void
      {
         var firstHitPoints:Vector3d = hitPoints[0] as Vector3d;
         var jsobject:Object = new Object();
         jsobject.hitPoints = hitPoints;
         jsobject.targetInc = targetInc;
         jsobject.targets = targets;
         jsobject.targetPostitions = targetPostitions;
         jsobject.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(jsobject));
      }
   }
}
