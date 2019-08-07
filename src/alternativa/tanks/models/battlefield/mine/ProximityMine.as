package alternativa.tanks.models.battlefield.mine
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.physics.collision.primitives.CollisionSphere;
   import alternativa.service.Logger;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.sfx.Blinker;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class ProximityMine
   {
      
      private static const FLASH_GROW:int = 1;
      
      private static const FLASH_FADE:int = 2;
      
      private static const FLASH_DONE:int = 3;
      
      private static const INITIAL_BLINK_INTERVAL:int = 320;
      
      private static const MIN_BLINK_INTERVAL:int = 22;
      
      private static const BLINK_INTERVAL_DECREMENT:int = 12;
      
      private static const ALPHA_MIN:Number = 0.2;
      
      private static const BLINK_SPEED_COEFF:Number = 10;
      
      private static var _vector:Vector3 = new Vector3();
      
      private static var pool:ProximityMine;
       
      
      public var id:String;
      
      public var ownerId:String;
      
      public var hitCommandSent:Boolean;
      
      public var collisionPrimitive:CollisionSphere;
      
      public var position:Vector3;
      
      public var normal:Vector3;
      
      public var next:ProximityMine;
      
      public var prev:ProximityMine;
      
      private var teamType:BattleTeamType;
      
      private var mesh:Mesh;
      
      private var armed:Boolean;
      
      private var mineModelData:MineModelData;
      
      private var flashBaseTime:int;
      
      private var flashState:int;
      
      private var colorTransform:ColorTransform;
      
      private var blinker:Blinker;
      
      public function ProximityMine(referenceMesh:Mesh)
      {
         this.collisionPrimitive = new CollisionSphere(1,CollisionGroup.WEAPON);
         this.position = new Vector3();
         this.normal = new Vector3();
         this.colorTransform = new ColorTransform();
         this.blinker = new Blinker(INITIAL_BLINK_INTERVAL,MIN_BLINK_INTERVAL,BLINK_INTERVAL_DECREMENT,ALPHA_MIN,1,BLINK_SPEED_COEFF);
         super();
         this.mesh = Mesh(referenceMesh.clone());
      }
      
      public static function create(id:String, ownerId:String, proximityRadius:Number, referenceMesh:Mesh, material:Material, teamType:BattleTeamType, mineModelData:MineModelData) : ProximityMine
      {
         var mine:ProximityMine = null;
         if(pool == null)
         {
            mine = new ProximityMine(referenceMesh);
         }
         else
         {
            mine = pool;
            pool = pool.next;
            mine.next = null;
         }
         mine.init(id,ownerId,proximityRadius,material,teamType,mineModelData);
         return mine;
      }
      
      public function dispose() : void
      {
         this.id = null;
         this.ownerId = null;
         this.mesh.alternativa3d::removeFromParent();
         this.mineModelData = null;
         this.prev = null;
         this.next = pool == null?null:pool;
         pool = this;
      }
      
      public function arm() : void
      {
         this.armed = true;
         this.flashBaseTime = getTimer();
         this.flashState = FLASH_GROW;
         this.mesh.colorTransform = this.colorTransform;
         this.mesh.alpha = 1;
      }
      
      public function setPosition(pos:Vector3, normal:Vector3) : void
      {
         this.position.vCopy(pos);
         this.normal.vCopy(normal);
         this.mesh.x = pos.x;
         this.mesh.y = pos.y;
         this.mesh.z = pos.z;
         _vector.vCross2(Vector3.Z_AXIS,normal).vNormalize();
         var angle:Number = Math.acos(normal.vDot(Vector3.Z_AXIS));
         var matrix:Matrix3 = new Matrix3();
         matrix.fromAxisAngle(_vector,angle);
         matrix.getEulerAngles(_vector);
         this.mesh.rotationX = _vector.x;
         this.mesh.rotationY = _vector.y;
         this.mesh.rotationZ = _vector.z;
         this.collisionPrimitive.transform.setPosition(pos);
         this.collisionPrimitive.calculateAABB();
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.mesh);
      }
      
      public function canExplode(tankData:TankData) : Boolean
      {
         return (this.teamType == BattleTeamType.NONE || this.teamType != tankData.teamType) && this.armed && this.ownerId != tankData.user.id && tankData.enabled;
      }
      
      public function update(now:int, deltaMillis:int, localUserData:TankData) : void
      {
         if(!this.armed)
         {
            this.mesh.alpha = this.blinker.updateValue(now,deltaMillis);
         }
         else if(this.flashState != FLASH_DONE)
         {
            this.updateFlash(now);
         }
         else if(localUserData == null || localUserData.health == 0)
         {
            this.mesh.visible = false;
         }
         else if(this.canExplode(localUserData))
         {
            this.updateVisibility(localUserData);
         }
         else
         {
            this.mesh.visible = true;
         }
      }
      
      public function toString() : String
      {
         return "[ProximityMine id=" + this.id + ", ownerId=" + this.ownerId + ", armed=" + this.armed + "]";
      }
      
      private function init(id:String, ownerId:String, proximityRadius:Number, material:Material, teamType:BattleTeamType, mineModelData:MineModelData) : void
      {
         if(teamType == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"ProximityMine: teamType is null");
         }
         this.id = id;
         this.ownerId = ownerId;
         this.setProximityRadius(proximityRadius);
         this.teamType = teamType;
         this.mineModelData = mineModelData;
         this.mesh.colorTransform = null;
         this.mesh.alpha = 1;
         this.mesh.visible = true;
         this.mesh.setMaterialToAllFaces(material);
         this.armed = false;
         this.hitCommandSent = false;
         this.flashState = FLASH_DONE;
         this.flashBaseTime = getTimer();
         this.blinker.init(this.flashBaseTime);
      }
      
      private function setProximityRadius(value:Number) : void
      {
         this.collisionPrimitive.r = value;
         this.collisionPrimitive.calculateAABB();
      }
      
      private function updateVisibility(localUserData:TankData) : void
      {
         this.mesh.visible = true;
         _vector.vDiff(localUserData.tank.state.pos,this.position);
         var d:Number = _vector.vLength();
         if(d > this.mineModelData.farRadius)
         {
            this.mesh.visible = false;
         }
         else if(d < this.mineModelData.nearRadius)
         {
            this.mesh.alpha = 1;
         }
         else
         {
            this.mesh.alpha = (this.mineModelData.farRadius - d) / (this.mineModelData.farRadius - this.mineModelData.nearRadius);
         }
      }
      
      private function updateFlash(now:int) : void
      {
         switch(this.flashState)
         {
            case FLASH_GROW:
               if(now < this.flashBaseTime + this.mineModelData.armedFlashDuration)
               {
                  this.setColorOffset(this.mineModelData.flashChannelOffset * (now - this.flashBaseTime) / this.mineModelData.armedFlashDuration);
               }
               else
               {
                  this.setColorOffset(this.mineModelData.flashChannelOffset);
                  this.flashBaseTime = this.flashBaseTime + (this.mineModelData.armedFlashDuration + this.mineModelData.armedFlashFadeDuration);
                  this.flashState = FLASH_FADE;
               }
               break;
            case FLASH_FADE:
               if(now < this.flashBaseTime)
               {
                  this.setColorOffset(this.mineModelData.flashChannelOffset * (this.flashBaseTime - now) / this.mineModelData.armedFlashFadeDuration);
               }
               else
               {
                  this.setColorOffset(0);
                  this.flashState = FLASH_DONE;
                  this.mesh.colorTransform = null;
               }
         }
      }
      
      private function setColorOffset(colorOffset:uint) : void
      {
         this.colorTransform.redOffset = colorOffset;
         this.colorTransform.greenOffset = colorOffset;
         this.colorTransform.blueOffset = colorOffset;
         this.mesh.colorTransform = this.colorTransform;
      }
   }
}
