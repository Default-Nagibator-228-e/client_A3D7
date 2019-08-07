package alternativa.tanks.models.battlefield.hp
{
   import alternativa.debug.dump.SpaceDumper;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.sfx.LimitedDistanceAnimatedSpriteEffect;
   import alternativa.tanks.sfx.ScalingObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.tanks.vehicles.tanks.SuspensionRay;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.vehicles.tanks.Track;
   import utils.client.models.tank.TankSpawnState;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class HP
   {
      
      private var battleService:BattlefieldModel;
	  
	  private var sp:Sprite3D;
	  
	  private var s:Boolean = true;
	  
	  private var tim:Timer = new Timer(1000, 1);
	  
	  private var tim1:Timer = new Timer(10, 1);
	  
	  private var s1:int;
      
      public function HP(param1:BattlefieldModel)
      {
         super();
         this.battleService = param1;
      }
      
      public function init(param1:BitmapData, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
		  var df:TextureMaterial = new TextureMaterial(param1);
		  sp = new Sprite3D(param1.width, param1.height, df);
		  sp.perspectiveScale = false;
		  sp.sorting = 0;
		  sp.useDepth = false;
		  sp.useLight = false;
		  sp.useShadowMap = false;
		  s1 = (Math.random() > 0.5 ? 1:-1) + (Math.random() * 10);
      }
      
      public function update(param1:Event) : void
      {
			if (s)
			{
				sp.z += 5;
				sp.x += s1;
				tim1.start();
			}else{
				tim1.stop();
			}
      }
      
      public function addTankHP(param1:TankData, param2:Number = 100, param3:Number = 0.2) : void
      {
		  sp.x = param1.tank._skin.turretMesh.x;
		  sp.y = param1.tank._skin.turretMesh.y;
		  sp.z = param1.tank._skin.turretMesh.z + 100;
		  KDContainer(battleService.bfData.viewport._mapContainer).addChildAt(sp, 0);
			tim.addEventListener(TimerEvent.TIMER_COMPLETE, function(param1:Event):void
			{
				tim1.stop();
				sp.visible = false;
				sp = null;
			});
			tim.start();
			tim1.addEventListener(TimerEvent.TIMER_COMPLETE, update);
			tim1.start();
      }
   }
}
