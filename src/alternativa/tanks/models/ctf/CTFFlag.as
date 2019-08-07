package alternativa.tanks.models.ctf
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.engine3d.AnimatedSprite3D;
   import alternativa.tanks.engine3d.MaterialSequence;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.engine3d.UVFrame;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class CTFFlag
   {
      
      public static const Z_DISPLACEMENT:Number = -200;
      
      private static const SKIN_BASE_SIZE:int = 100;
      
      private static const SKIN_HEIGHT:int = 400;
      
      private static var intersection:RayIntersection = new RayIntersection();
      
      private static var rayDirection:Vector3 = new Vector3(0,0,-20000);
      
      private static var matrix:Matrix3 = new Matrix3();
      
      private static var flagPosition:Vector3 = new Vector3();
       
      
      public var teamType:BattleTeamType;
      
      public var takeCommandSent:Boolean;
      
      public var triggerCollisionPrimitive:CollisionPrimitive;
      
      private var _carrierData:TankData;
      
      private var _carrierId:String;
      
      private var _state:CTFFlagState;
      
      private var _basePosition:Vector3 = new Vector3();
	  
	  private var _basePosition1:Vector3 = new Vector3();
      
      private var skin:AnimatedSprite3D;
      
      private var container:Scene3DContainer;
      
      private var startTime:int;
      
      private var frameInterval:int = 1000;
      
      private var originalTexture:BitmapData;
      
      public function CTFFlag(teamType:BattleTeamType, basePos:Vector3, frameWidth:int, frameHeight:int, materials:Vector.<Material>, originalTexture:BitmapData, collisionDetector:TanksCollisionDetector)
      {
         super();
         this.teamType = teamType;
         this._basePosition = basePos.vClone();
         this._state = CTFFlagState.AT_BASE;
         this.originalTexture = originalTexture;
         this.createSkin(frameWidth,frameHeight,materials);
         this._basePosition.z = this._basePosition.z + Z_DISPLACEMENT;
         if(collisionDetector.intersectRayWithStatic(this._basePosition,rayDirection,CollisionGroup.STATIC,1,null,intersection))
         {
            this._basePosition.vCopy(intersection.pos);
         }
         //this._basePosition.z = this._basePosition.z + Z_DISPLACEMENT;
		 this._basePosition1.vCopy(this._basePosition);
		 this._basePosition1.z += 150;
         this.setPosition(this._basePosition1);
         this.startTime = this.frameInterval * Math.random();
      }
      
      public function get carrierData() : TankData
      {
         return this._carrierData;
      }
      
      public function get carrierId() : String
      {
         return this._carrierId;
      }
      
      public function get basePosition() : Vector3
      {
         return this._basePosition;
      }
      
      private function setPosition(value:Vector3D, boo:Boolean = false) : void
      {
         this.skin.x = value.x;
         this.skin.y = value.y;
         this.skin.z = value.z;
		 if (!boo)
		 {
			 this.skin.z += 100;
		 }
         this.triggerCollisionPrimitive.transform.d = value.x;
         this.triggerCollisionPrimitive.transform.h = value.y;
         this.triggerCollisionPrimitive.transform.l = value.z + 0.5 * SKIN_HEIGHT;
         this.triggerCollisionPrimitive.calculateAABB();
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         this.container = container;
         this.container.addChild(this.skin);
      }
      
      public function get state() : CTFFlagState
      {
         return this._state;
      }
      
      public function setCarrier(carrierId:String, carrierData:TankData) : void
      {
         this._carrierId = carrierId;
         this._carrierData = carrierData;
         this.skin.visible = carrierData != null;
         this.takeCommandSent = false;
         if(carrierData != null)
         {
            this.skin.alpha = carrierData == TankData.localTankData?Number(0.5):Number(1);
         }
         this._state = CTFFlagState.CARRIED;
      }
      
      public function returnToBase() : void
      {
         this.reset();
         this.setPosition(this._basePosition1);
         this._state = CTFFlagState.AT_BASE;
      }
      
      public function dropAt(dropPos:Vector3, collisionDetector:TanksCollisionDetector) : void
      {
         this.reset();
         if(collisionDetector.intersectRayWithStatic(dropPos,rayDirection,CollisionGroup.STATIC,1,null,intersection))
         {
            this.setPosition(intersection.pos);
         }
         else
         {
			if(this._carrierData != null)
			 {
				dropPos.z -= this._carrierData.tank.skin.turretMesh.boundMinZ + this._carrierData.tank.skin.turretMesh.boundMaxZ;
			 }
            this.setPosition(dropPos);
         }
         this._state = CTFFlagState.DROPPED;
      }
      
      public function toString() : String
      {
         return "[CTFFlag teamType=" + this.teamType + ", state=" + this._state + ", carrierId=" + this._carrierId + ", takeCommandSent=" + this.takeCommandSent + "]";
      }
      
      public function dispose() : void
      {
         this.skin.alternativa3d::removeFromParent();
      }
      
      public function update(time:int) : void
      {
         var carrierTank:Tank = null;
         var turretMesh:Mesh = null;
         if(this._carrierData != null)
         {
            carrierTank = this._carrierData.tank;
            turretMesh = carrierTank.skin.turretMesh;
            matrix.setRotationMatrix(turretMesh.rotationX,turretMesh.rotationY,turretMesh.rotationZ);
            matrix.transformVector(carrierTank.skin.turretDescriptor.flagMountPoint,flagPosition);
            flagPosition.x = flagPosition.x + turretMesh.x;
            flagPosition.y = flagPosition.y + turretMesh.y;
            flagPosition.z = flagPosition.z + (turretMesh.z - 40);
            this.setPosition(flagPosition,true);
         }
      }
      
      private function createSkin(frameWidth:int, frameHeight:int, materials:Vector.<Material>) : void
      {
         var w:Number = frameWidth * SKIN_HEIGHT / frameHeight;
		 var animSprite:AnimatedSprite3D = new AnimatedSprite3D(w, SKIN_HEIGHT);
		 var d:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();
		 for (var ft:int = 0; ft < materials.length; ft++)
		 {
			d.push(materials[ft] as TextureMaterial);
		 }
         var animation:TextureAnimation = GraphicsUtils.getTextureAnimation(null, this.originalTexture, frameWidth, frameHeight, 1);
		 animation = new TextureAnimation(d,animation.frames);
         animation.fps = 1;
         animSprite.setAnimationData(animation);
         animSprite.setFrameIndex(1);
         animSprite.originY = 1;
         animSprite.looped = true;
         this.skin = animSprite;
         this.triggerCollisionPrimitive = new CollisionBox(new Vector3(0.5 * SKIN_BASE_SIZE,0.5 * SKIN_BASE_SIZE,0.5 * SKIN_HEIGHT),CollisionGroup.TANK);
      }
      
      private function reset() : void
      {
         this._carrierId = null;
         this._carrierData = null;
         this.skin.alpha = 1;
         this.skin.visible = true;
         this.takeCommandSent = false;
      }
   }
}
