package alternativa.tanks.models.weapon.shaft
{
   import alternativa.engine3d.controllers.SimpleObjectController;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.camera.FlyCameraController;
   import alternativa.tanks.camera.FollowCameraController;
   import alternativa.tanks.display.usertitle.UserTitle;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.HitInfo;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
   import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
   import alternativa.tanks.models.weapon.shared.ICommonTargetEvaluator;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.TankSounds;
   import utils.client.commons.types.Vector3d;
   import utils.client.warfare.models.tankparts.weapon.gun.IGunModelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.ui.Keyboard;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   public class ShaftModel implements IGunModelBase, IObjectLoadListener, IWeaponController
   {
      
      private static const SWITCH_INTERVAL:int = 200;
      
      private static const INDICATOR_SHIFT:Number = 9;
      
      private static const INDICATOR_OFFSET:int = 75;
      
      private static const thousand:int = 1000;
	  
      [Embed(source="s/1.png")]
      private static const p:Class;
       
      
      private var _hitPos:Vector3 = new Vector3();
      
      private var _hitPosLocal:Vector3 = new Vector3();
      
      private var _hitPosGlobal:Vector3 = new Vector3();
      
      private var _gunDirGlobal:Vector3 = new Vector3();
      
      private var _muzzlePosGlobal:Vector3 = new Vector3();
      
      private var _barrelOrigin:Vector3 = new Vector3();
      
      private var _xAxis:Vector3 = new Vector3();
      
      private var _hitPos3d:Vector3d = new Vector3d(0,0,0);
      
      private var _tankPos3d:Vector3d = new Vector3d(0,0,0);
      
      private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
      
      private var localTankData:TankData;
      
      private var localShotData:ShotData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var modelService:IModelService;
      
      private var battlefieldModel:BattlefieldModel;
      
      private var tankModel:TankModel;
      
      private var weaponWeakeningModel:IWeaponWeakeningModel;
      
      private var targetSystem:CommonTargetSystem;
      
      private var hitInfo:HitInfo = new HitInfo();
      
      private var weaponCommonModel:IWeaponCommonModel;
      
      private var _triggerPressed:Boolean;
      
      private var nextReadyTime:int;
	  
	  private var nextShTime:int;
      
      private var targetEvaluator:ICommonTargetEvaluator;
      
      private var maxTargetingDistance:Number = 100000;
      
      private var pressed:Boolean = false;
      
      private var image:Bitmap;
	  
	  private var pr:Boolean = false;
	  
	  private var pr1:Boolean = false;
	  
	  private var pr2:Boolean = false;
	  
	  private var p2:Boolean = false;
	  
	  private var pr3:ClientObject;
	  
	  private var pr4:Boolean = false;
	  
	  private var ty:Number = 0;
	  
	  private var tz:Number = 0;
	  
	  private var ty1:Number = 0;
	  
	  private var tz1:Number = 0;
	  
	  private var ty2:Number = 0;
	  
	  private var tz2:Number = 0;
	  
	  private var ty3:Number = 0;
	  
	  private var tz3:Number = 0;
	  
	  private var t:int = 0;
	  
	  private var currentEnergy:Number = 800;
	  
	  private var lastUpdateTime:int = 0;
	  
	  private var rt:SimpleObjectController;
	  
	  private var et:Bitmap = new Bitmap(new BitmapData(1, 1));
	  
	  private var rotationMatrix:Matrix3 = new Matrix3();
	  
	  private var rotationMatrix1:Matrix3 = new Matrix3();
	  
	  private var matrix:Matrix3 = new Matrix3();
	  
	  private var muzzlePos:Vector3 = new Vector3();
	  
	  private var rayAngle:Number = 0;
	  
	  private var rayDir:Vector3 = new Vector3();
	  
	  private var tur:SoundChannel;
	  
	  private var tur1:Sound;
	  
	  private var u:Boolean = false;
	  
	  private var d:Boolean = false;
	  
	  private var l:Boolean = false;
	  
	  private var r:Boolean = false;
	  
	  private var flr:Boolean = false;
	  
	  private var o:Boolean = true;
	  
	  public var cu:FlyCameraController;
	  
	  public var fov:Number;
	  
	  public var h:Number;
      
      public function ShaftModel()
      {
         super();
         this.image = new Bitmap(new p().bitmapData);
		 tur1 = new Sound(new URLRequest(Game.local?"":"resources/" + "turret.mp3"));
		 et.visible = false;
      }
	  
	  public function fly(p:Vector3) : void
		{
			cu = new FlyCameraController(battlefieldModel.bfData.viewport.camera,new Object3DContainer());
			cu.init1(p, 200);
			battlefieldModel.activeCameraController = null;
			Main.stage.addEventListener(Event.ENTER_FRAME, fl);
			flr = true;
		}
		
	  private function fl(p:Event) : void
		{
			cu.update(1, 3)
			if (cu.distance / cu.totalDistance >= 1)
			{
				flr = false;
				Main.stage.removeEventListener(Event.ENTER_FRAME, fl);
				cu = null;
			}
		}
      
      public function objectLoaded(object:ClientObject) : void
      {
		 pr3 = object;
         this.modelService = IModelService(Main.osgi.getService(IModelService));
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.tankModel = Main.osgi.getService(ITank) as TankModel;
         this.weaponCommonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
		 //tur = this.battlefieldModel.soundManager.playSound(tur1, 10000000, 0, new SoundTransform(0));
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
		  Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPrMened);
      }
      
      public function update(time:int, deltaTime:int) : Number
      {
			var key:* = undefined;
			if (nextShTime > 0 && !this._triggerPressed && time >= this.nextReadyTime)
			{
				 nextShTime = 0;
				 et.visible = false;
				 p2 = false;
				 var yu1:Camera3D = battlefieldModel.bfData.viewport.camera;
				 battlefieldModel.followCameraController.cameraHeight = h;
				 this.currentEnergy = this.localShotData.reloadMsec.value * 0.4;
				 yu1.fov = fov;
				 TankModel(Main.osgi.getService(ITank)).iit = false;
				 if (Main.stage.contains(this.image))
				 {
					Main.stage.removeChild(this.image);
				 }
				 shot(time);
				 return 0;
			 
			}
			if(!this._triggerPressed || time < this.nextReadyTime)
			{
				if (Main.stage.contains(this.image))
				{
					Main.stage.removeChild(this.image);
				}
				if(time < this.nextReadyTime)
				{
					return 1 + (time - this.nextReadyTime) / this.localShotData.reloadMsec.value;
				}
				return 1;
			}
			if (nextShTime == 0 && this._triggerPressed && time >= this.nextReadyTime)
			{
				nextShTime = time + 250;
			}
			if (time >= nextShTime && this._triggerPressed)
			{
				 var yu:Camera3D = this.battlefieldModel.bfData.viewport.camera;
				 var rew:TankModel = TankModel(Main.osgi.getService(ITank));
				 rew.iit = true;
				 TankModel(Main.osgi.getService(ITank)).setControlState(localTankData, 0);
				 p2 = true;
				 this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel],this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal,0,15);
				 tz1 += tz;
				 ty1 += ty;
				 tz3 = tz2 - tz1;
				 ty3 = ty2 - ty1;
				 if (!et.visible)
				 {
					h = battlefieldModel.followCameraController.cameraHeight;
					fov = yu.fov;
					battlefieldModel.followCameraController.cameraHeight = 0;
					//battlefieldModel.followCameraController.deactivate();
					yu.z = this._muzzlePosGlobal.z; 
					et.visible = true;
					var re:BitmapData = (localTankData.tank.title.sprite.material as TextureMaterial).texture;
					et.bitmapData = re;
					et.x = Main.stage.stageWidth / 2 - et.width / 2;
					et.y = Main.stage.stageHeight / 2 - et.height / 2 + this.image.height / 5;
					fly(new Vector3(this._muzzlePosGlobal.x, this._muzzlePosGlobal.y, this._muzzlePosGlobal.z));
				 }
				 if (!Main.stage.contains(this.image) && !flr)
				 {
					Main.stage.addChild(this.image);
					this.image.x = Main.stage.stageWidth / 2 - this.image.width / 2;
					this.image.y = Main.stage.stageHeight / 2 - this.image.height / 2;
				 }
				 if (!flr)
				 {
					//yu.fov = 0.4 - (0.2 * (1 - this.currentEnergy/(this.localShotData.reloadMsec.value * 0.4)));
				 }
				 prycel(yu);
				 this.targetSystem.maxAngleDown = Math.abs(tz1 * 100) - this.localShotData.autoAimingAngleDown.value;
				 this.targetSystem.maxAngleUp = Math.abs(tz1 * 100) + this.localShotData.autoAimingAngleUp.value;
				 tz = 0;
				 ty = 0;
				 if (this.lastUpdateTime != 0 && this.currentEnergy > 0)
				 {
					this.currentEnergy = this.currentEnergy - 80 * (time - this.lastUpdateTime) * 0.001;
				 }
				 if(this.currentEnergy <= 0)
				 {
					this.currentEnergy = 0;
				 }
			 }
			 sound();
			 this.lastUpdateTime = time;
			 return this.currentEnergy/(this.localShotData.reloadMsec.value * 0.4);
	  }
	  
	  private function prycel(yu:Camera3D) : void
      {
			var j:Number = Math.random();
			var j1:Number = Math.random();
			if (tz3 >= 0.001 || tz3 <= -0.001)
			{
				pr1 = !pr1;
			}
			if (ty3 >= 0.001 || ty3 <= -0.001)
			{
				pr2 = !pr2;
			}
			if ((tz3 >= -0.00003 && tz3 <= 0.00003) || (ty3 >= -0.00003 && ty3 <= 0.00003))
			{
				pr1 = j > 0.5?pr1:!pr1;
				pr2 = j1 > 0.5? pr2:!pr2;
				pr = false;
			}
			if (pr1)
			{
				tz2 -= 0.00003;
			}else{
				tz2 += 0.00003;
			}
			if (pr2)
			{
				ty2 -= 0.00003;
			}else{
				ty2 += 0.00003;
			}
			yu.rotationX = 4.7;
			if (tz1 * 100 > -40 || tz1 * 100 < 40)
			{
				yu.rotationX += tz2;
			}
			if (ty1 * 100 > -40 || ty1 * 100 < 40)
			{
				yu.rotationZ += ty2;
			}
      }
	  
	  private function sound() : void
      {
			if (u || l || d || r)
			{
				if (o)
				{
					tur = this.battlefieldModel.soundManager.playSound(tur1, 0, 0, new SoundTransform(0.5));
					o = false;
				}
			}else{
				this.battlefieldModel.soundManager.stopSound(tur);
				o = true;
				t = 0;
			 }
      }
	  
	  private function shot(time:int) : void
      {
			var td:* = null;
			var impactCoeff:Number = NaN;
			this.nextReadyTime = time + this.localShotData.reloadMsec.value;
			this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel],this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal,0,15);
			this.weaponCommonModel.createShotEffects(this.localTankData.turret,this.localTankData.tank,this.localWeaponCommonData.currBarrel,this._muzzlePosGlobal,this._gunDirGlobal);
			var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
			var victimData:TankData = null;
			var hitPos:Vector3d = null;
			var distance:Number = 0;
			this.muzzlePos.vCopy(_barrelOrigin).vAddScaled(1, _gunDirGlobal);
			this.rotationMatrix1.fromAxisAngle(_gunDirGlobal, Math.PI/6);
			rayDir = new Vector3();
			rayAngle = -ty1/1.125;
			this._xAxis.vTransformBy3(this.rotationMatrix1);
			this._xAxis.vTransformBy3(this.rotationMatrix1);
			this._xAxis.vTransformBy3(this.rotationMatrix1);
			matrix.fromAxisAngle(this._xAxis,rayAngle);
			matrix.transformVector(_gunDirGlobal, rayDir);
			if(this.targetSystem.getTarget(muzzlePos,rayDir,new Vector3(0,rayAngle),this.localTankData.tank,this.hitInfo))
			{
				distance = this.hitInfo.distance * 0.01;
				hitPos = this._hitPos3d;
				hitPos.x = this.hitInfo.position.x;
				hitPos.y = this.hitInfo.position.y;
				hitPos.z = this.hitInfo.position.z;
				if(this.hitInfo.body != null)
				{
					for(td in bfData.activeTanks)
					{
						if(this.hitInfo.body == td.tank)
						{
							victimData = td;
							break;
						}
					}
				}
				impactCoeff = this.weaponWeakeningModel.getImpactCoeff(this.localTankData.turret,distance);
				this.weaponCommonModel.createExplosionEffects(this.localTankData.turret,bfData.viewport.camera,false,this.hitInfo.position,rayDir,victimData,impactCoeff);
				if(victimData != null)
				{
					this._hitPosGlobal.vDiff(this.hitInfo.position,victimData.tank.state.pos);
					victimData.tank.baseMatrix.transformVectorInverse(this._hitPosGlobal,this._hitPosLocal);
					hitPos.x = this._hitPosLocal.x;
					hitPos.y = this._hitPosLocal.y;
					hitPos.z = this._hitPosLocal.z;
				}
			}
			tz = 0;
			ty = 0;
			tz1 = 0;
			ty1 = 0;
			tz2 = 0;
			ty2 = 0;
			tz3 = 0;
			ty3 = 0;
			if(victimData != null)
			{
				var v:Vector3 = victimData.tank.state.pos;
				this._tankPos3d.x = v.x;
				this._tankPos3d.y = v.y;
				this._tankPos3d.z = v.z;
				this.fireCommand(this.localTankData.turret, distance, hitPos, victimData.user.id, victimData.incarnation, this._tankPos3d);
			}else{
				this.fireCommand(this.localTankData.turret,distance,hitPos,null,-1,null);
			}
			this.targetSystem.maxAngleDown = this.localShotData.autoAimingAngleDown.value;
			this.targetSystem.maxAngleUp = this.localShotData.autoAimingAngleUp.value;
      }
	  
	  public function fire(clientObject:ClientObject, firingTankId:String, affectedPoint:Vector3d, affectedTankId:String, weakeningCoeff:Number) : void
      {
         var affectedTankObject:ClientObject = null;
         var affectedTankData:TankData = null;
         var firingTank:ClientObject = BattleController.activeTanks[firingTankId];
         if(firingTank == null)
         {
            return;
         }
         if(this.tankModel.localUserData != null)
         {
            if(firingTank.id == this.tankModel.localUserData.user.id)
            {
               return;
            }
         }
         var firingTankData:TankData = this.tankModel.getTankData(firingTank);
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
         var barrelIndex:int = 0;
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[barrelIndex],this._muzzlePosGlobal,this._gunDirGlobal);
         this.weaponCommonModel.createShotEffects(firingTankData.turret,firingTankData.tank,barrelIndex,this._muzzlePosGlobal,this._gunDirGlobal);
         if(affectedPoint == null)
         {
            return;
         }
         this._hitPos.x = affectedPoint.x;
         this._hitPos.y = affectedPoint.y;
         this._hitPos.z = affectedPoint.z;
         if(affectedTankId != null)
         {
            affectedTankObject = BattleController.activeTanks[affectedTankId];
            if(affectedTankObject == null)
            {
               return;
            }
            affectedTankData = this.tankModel.getTankData(affectedTankObject);
            if(affectedTankData == null || affectedTankData.tank == null)
            {
               return;
            }
            this.weaponCommonModel.createExplosionEffects(firingTankData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,true,this._hitPos,this._gunDirGlobal,affectedTankData,weakeningCoeff);
            this.battlefieldModel.tankHit(affectedTankData,this._gunDirGlobal,weakeningCoeff * commonData.impactCoeff);
         }
         else
         {
            this.weaponCommonModel.createExplosionEffects(firingTankData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,false,affectedPoint.toVector3(),this._gunDirGlobal,null,weakeningCoeff * commonData.impactCoeff);
         }
      }
	  
	  private function fireCommand(turret:ClientObject, distance:Number, hitPos:Vector3d, victimId:String, victimInc:int, tankPos:Vector3d) : void
      {
         var js:Object = new Object();
         js.distance = distance;
         js.hitPos = hitPos;
         js.victimId = victimId;
         js.victimInc = victimInc;
         js.tankPos = tankPos;
         js.reloadTime = this.localShotData.reloadMsec.value;
		 js.rel = this.currentEnergy/(this.localShotData.reloadMsec.value * 0.4);
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(js));
      }
	  
	  private function onPrMened(e:KeyboardEvent) : void
      {
		 //if (p2)
		 //{
			 if(e.keyCode == Keyboard.UP)
			 {
				if (tz1 * 100 < 40)
				{
					tz += 0.0001 * t;
					tz2 += 0.0001 * t;
					u = true;
					t < 50?t += 1:t=50;
				}
			 }
			 if(e.keyCode == Keyboard.LEFT)
			 {
				if (ty1 * 100 < 40)
				{
					ty += 0.0001 * t;
					ty2 += 0.0001 * t;
					l = true;
					t < 50?t += 1:t=50;
				}
			 }
			 if(e.keyCode == Keyboard.RIGHT)
			 {
				if (ty1 * 100 > -40)
				{
					ty -= 0.0001 * t;
					ty2 -= 0.0001 * t;
					r = true;
					t < 50?t += 1:t=50;
				}
			 }
			 if(e.keyCode == Keyboard.DOWN)
			 {
				if (tz1 * 100 > -40)
				{
					tz -= 0.0001 * t;
					tz2 -= 0.0001 * t;
					d = true;
					t < 50?t += 1:t=50;
				}
			 }
		 //}
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
      }
      
      public function reset() : void
      {
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.objectLoaded(null);
         this.localTankData = localUserData;
         this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
         this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
         this.targetEvaluator = CommonTargetEvaluator.create(this.localTankData,this.localShotData,this.battlefieldModel,this.weaponWeakeningModel,this.modelService);
         this.targetSystem = new CommonTargetSystem(this.maxTargetingDistance,this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value,this.battlefieldModel.getBattlefieldData().collisionDetector,this.targetEvaluator);
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onPressed);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP, this.onRealised);
		 Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPrMened);
         this.reset();
      }
      
      private function onPressed(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.SPACE)
         {
			Main.stage.addChild(et);
		 }
      }
      
      private function onRealised(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.SPACE)
         {
            if (Main.stage.contains(this.image))
			{
				Main.stage.removeChild(this.image);
			}
         }
		 //if (p2)
		 //{
			 if(e.keyCode == Keyboard.UP)
			 {
				u = false;
			 }
			 if(e.keyCode == Keyboard.LEFT)
			 {
				l = false;
			 }
			 if(e.keyCode == Keyboard.RIGHT)
			 {
				r = false;
			 }
			 if(e.keyCode == Keyboard.DOWN)
			 {
				d = false;
			 }
		 //}
      }
      
      public function clearLocalUser() : void
      {
      }
      
      public function activateWeapon(time:int) : void
      {
         this._triggerPressed = true;
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this._triggerPressed = false;
      }
   }
}
