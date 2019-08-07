package forms.garage
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.Tank3D;
   import alternativa.tanks.Tank3DPart;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import controls.TankWindow2;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import alternativa.tanks.gui.resource.tanks.TankResource;
   
   public class TankPreview extends Sprite
   {
      
      private var window:TankWindow2;
      
      private const windowMargin:int = 11;
      
      private var inner:TankWindowInner;
      
      private var rootContainer:Object3DContainer;
      
      private var cameraContainer:Object3DContainer;
      
      public var camera:GameCamera;
      
      private var timer:Timer;
      
      private var tank:Tank3D;
      
      private var rotationSpeed:Number;
      
      private var lastTime:int;
      
      private var loadedCounter:int = 0;
      
      private var holdMouseX:int;
      
      private var lastMouseX:int;
      
      private var prelastMouseX:int;
      
      private var rate:Number;
      
      private var startAngle:Number = -150;
      
      private var holdAngle:Number;
      
      private var slowdownTimer:Timer;
      
      private var resetRateInt:uint;
      
      private var autoRotationDelay:int = 10000;
      
      private var autoRotationTimer:Timer;
      
      public var overlay:Shape;
      
      private var firstAutoRotation:Boolean = true;
      
      private var first_resize:Boolean = true;
	  
	  private var dot : Number = Math.PI / 180;
	  
	  private var dot1:Number = dot * 0.001;
      
      public function TankPreview(garageBoxId:Long, rotationSpeed:Number = 5)
      {
         var box:Mesh = null;
         var material:TextureMaterial = null;
         this.overlay = new Shape();
         super();
         this.rotationSpeed = rotationSpeed;
         this.window = new TankWindow2(400,300);
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			addChild(this.window);
		 }
         this.rootContainer = new Object3DContainer();
         /*var boxResource:TankResource = ResourceUtil.getResource(ResourceType.MODEL,"garage_box_model") as TankResource;
         Main.writeVarsToConsoleChannel("TANK PREVIEW","\tgarageBoxId: %1",garageBoxId);
         Main.writeVarsToConsoleChannel("TANK PREVIEW","\tboxResource: %1",boxResource);
         var boxes:Vector.<Mesh> = new Vector.<Mesh>();
         var numObjects:int = boxResource.objects.length;
         for(var i:int = 0; i < numObjects; i++)
         {
            box = boxResource.objects[i] as Mesh;
            if(box != null)
            {
               material = TextureMaterial(box.alternativa3d::faceList.material);
               Main.writeVarsToConsoleChannel("TEST","TankPreview::TankPreview() box texture=%1","E");
               material.texture = ResourceUtil.getResource(ResourceType.IMAGE,"garage_box_img").bitmapData;
               boxes.push(box);
            }
         }
         this.rootContainer.addChild(boxes[0]);
         this.rootContainer.addChild(boxes[2]);
         this.rootContainer.addChild(boxes[1]);*/
         //this.rootContainer.addChild(boxes[3]);
         this.tank = new Tank3D(null, null, null);
         this.rootContainer.addChild(this.tank);
         this.tank.matrix.appendTranslation(0, 0, 0);//(-17, 0, 0)
		 initGarage();
         this.camera = new GameCamera();
         this.camera.view = new View(100, 100);
         this.camera.view.hideLogo();
         addChild(this.camera.view);
         addChild(this.overlay);
		 this.camera.view.visible = false;
         this.overlay.x = 0;
         this.overlay.y = 9;
         this.overlay.width = 1500;
         this.overlay.height = 1300;
         this.overlay.graphics.clear();
         this.cameraContainer = new Object3DContainer();
         this.rootContainer.addChild(this.cameraContainer);
         this.cameraContainer.addChild(this.camera);
		 this.cameraContainer.z = 220;
         this.camera.z = -850;//-740
         //camera.deferredLighting = true;
		 //camera.ssao = false;
		 //camera.ssaoColor = 0xfdfa9e;
		 //var omni:DirectionalLight = new DirectionalLight(0xfdfa9e);
         //omni.x = boxes[0].boundMaxX-1000;
         //omni.y = boxes[0].boundMaxY-40;
         //omni.z = boxes[0].z;
		 //omni.lookAt(boxes[0].x,boxes[0].y,boxes[0].z);
         //omni.intensity = 0.7;
		 
		 //this.rootContainer.addChild(omni);
		 //camera.directionalLight = omni;
		 /*
		 var omni1:DirectionalLight = new DirectionalLight(8454143);
         omni1.x = boxes[0].boundMinX + 1000;
         omni1.y = boxes[0].boundMaxY-40;
         omni1.z = boxes[0].z;
		 omni1.lookAt(boxes[0].x,boxes[0].y,boxes[0].z);
         omni1.intensity = 1;
		 this.rootContainer.addChild(omni1);
		 var omni2:DirectionalLight = new DirectionalLight(8454143);
         omni2.x = boxes[0].boundMaxX-1000;
         omni2.y = boxes[0].boundMaxY-40;
         omni2.z = boxes[0].boundMaxZ;
		 omni2.lookAt(boxes[0].x,boxes[0].y,boxes[0].z);
         omni2.intensity = 1;
		 this.rootContainer.addChild(omni2);
		 var omni3:DirectionalLight = new DirectionalLight(8454143);
         omni3.x = boxes[0].boundMinX + 1000;
         omni3.y = boxes[0].boundMaxY-40;
         omni3.z = boxes[0].boundMinZ;
		 omni3.lookAt(boxes[0].x,boxes[0].y,boxes[0].z);
         omni3.intensity = 1;
		 this.rootContainer.addChild(omni3);
		 */
         this.cameraContainer.rotationX = -115 * dot;//-135
         this.cameraContainer.rotationZ = this.startAngle * dot;
         this.inner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			addChild(this.inner);
		 }
         this.inner.mouseEnabled = true;
         //this.resize(400,300);
         this.autoRotationTimer = new Timer(this.autoRotationDelay,1);
         this.autoRotationTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.start);
         this.timer = new Timer(50);
         this.slowdownTimer = new Timer(20,1000000);
         this.slowdownTimer.addEventListener(TimerEvent.TIMER,this.slowDown);
         this.inner.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         Main.stage.addEventListener(Event.ENTER_FRAME, this.onRender);
         this.start();
      }
	  
	  private function initGarage() : void
      {
         var obj:Object3D = null;
         var mesh:Mesh = null;
         var texture:BitmapData = null;
         var bytes:TankResource = ResourceUtil.getResource(ResourceType.MODEL,"garage_box_model") as TankResource;
		 var tree:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img1").bitmapData;
		 var obj1:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img3").bitmapData;
		 var obj2:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img4").bitmapData;
		 var obj3:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img6").bitmapData;
		 var obj4:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img8").bitmapData;
		 var obj5:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img9").bitmapData;
		 var obj6:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img10").bitmapData;
		 var obj7:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img11").bitmapData;
		 var tower:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img12").bitmapData;
         var treeMaterial:TextureMaterial = new TextureMaterial(tree, true, true, 1, 1);//mergeBitmapAlpha(tree,tree_alpha),true,true,1,1);
         var obj1m:TextureMaterial = new TextureMaterial(obj1,true,true,1,1);
         var obj2m:TextureMaterial = new TextureMaterial(obj2, true, true, 1, 1);//mergeBitmapAlpha(obj2,obj2_alpha),true,true,1,1);
         var obj3m:TextureMaterial = new TextureMaterial(obj3, true, true, 1, 1);//mergeBitmapAlpha(obj3,obj3_alpha),true,true,1,1);
         var obj4m:TextureMaterial = new TextureMaterial(obj4,true,true,1,1);
         var obj5m:TextureMaterial = new TextureMaterial(obj5,true,true,1,1);
         var obj6m:TextureMaterial = new TextureMaterial(obj6,true,true,1,1);
         var obj7m:TextureMaterial = new TextureMaterial(obj7,true,true,1,1);
         var towerM:TextureMaterial = new TextureMaterial(tower, true, true, 1, 1);//mergeBitmapAlpha(tower,tower_alpha),true,true,1,1);
         for each(obj in bytes.objects)
         {
            mesh = obj as Mesh;
            if(obj.name.indexOf("tree") >= 0)
            {
               mesh.setMaterialToAllFaces(treeMaterial);
            }
            if(obj.name == "Tower")
            {
               mesh.setMaterialToAllFaces(towerM);
            }
            if(obj.name == "bg2")
            {
               mesh.setMaterialToAllFaces(obj7m);
            }
            if(obj.name == "bg")
            {
               mesh.setMaterialToAllFaces(obj7m);
            }
            if(obj.name.indexOf("wall_") >= 0)
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if(obj.name == "wall_10")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if(obj.name == "Object20")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if(obj.name == "Object06")
            {
               mesh.setMaterialToAllFaces(obj6m);
            }
            if(obj.name == "pandus_2")
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if(obj.name == "pandus_1")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "Object105")
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if(obj.name == "Object104")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "Object79")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "Object10" || obj.name == "Object11" || obj.name == "Object12" || obj.name == "Object13")
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if(obj.name == "Object05")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "Object40" || obj.name == "Object41" || obj.name == "Object42" || obj.name == "Object43" || obj.name == "Object36" || obj.name == "Object37" || obj.name == "Object38" || obj.name == "Object81" || obj.name == "Object80" || obj.name == "Object38")
            {
               mesh.setMaterialToAllFaces(obj4m);
            }
            if(obj.name == "Object25" || obj.name == "Object26")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "wall_8")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "wall_6")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "Object23" || obj.name == "Object25" || obj.name == "Object24" || obj.name == "Object22")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if(obj.name == "Object04")
            {
               mesh.setMaterialToAllFaces(obj4m);
            }
            if(obj.name == "Object92" || obj.name == "Object95" || obj.name == "Object89" || obj.name == "Object84" || obj.name == "Object85" || obj.name == "Object88" || obj.name == "Object91" || obj.name == "Object141" || obj.name == "Object142" || obj.name == "Object88" || obj.name == "Object94" || obj.name == "Object93" || obj.name == "Object90" || obj.name == "Object96" || obj.name == "Object02")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if(obj.name == "Object56" || obj.name == "Object57" || obj.name == "Object54" || obj.name == "Object136" || obj.name == "Object146" || obj.name == "Object45" || obj.name == "Object58" || obj.name == "Object49" || obj.name == "Object82" || obj.name == "Object69" || obj.name == "Object70" || obj.name == "Object68" || obj.name == "Object67" || obj.name == "Object77" || obj.name == "Object78" || obj.name == "Object59" || obj.name == "Object60")
            {
               mesh.setMaterialToAllFaces(obj4m);
            }
			mesh.x = 70;
			tank.z = 130;
            this.rootContainer.addChild(mesh);
			this.rootContainer.addChild(createSkyBox());
         }
      }
	  
	  private function createSkyBox() : SkyBox
      {
         var material:TextureMaterial = new TextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE, "cs_2").bitmapData);
         var SKYBOX_SIZE:int = 200000;
         var skyBox:SkyBox = new SkyBox(SKYBOX_SIZE, material, material, material, material, material, material);
         var m:Matrix = new Matrix();
         var sides:Array = [SkyBox.RIGHT,SkyBox.BACK,SkyBox.LEFT,SkyBox.FRONT];
         for(var i:int = 0; i < sides.length; i++)
         {
            m.identity();
            m.scale(1 / 6,1);
            m.translate(i / 6.01,0);
            skyBox.transformUV(sides[i],m);
         }
         m.identity();
         m.scale(-1 / 6.01,-1);
         m.translate(5 / 6,1);
         skyBox.transformUV(SkyBox.TOP,m);
         m.identity();
         m.scale(-1 / 6.01,-1);
         m.translate(1,1);
         skyBox.transformUV(SkyBox.BOTTOM,m);
         return skyBox;
      }
	  
	  /*public function mergeBitmapAlpha(param1:BitmapData, param2:BitmapData) : BitmapData
      {
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height);
         _loc3_.copyPixels(param1,param1.rect,new Point());
         _loc3_.copyChannel(param2,param2.rect,new Point(),1,8);
         param1.dispose();
         param2.dispose();
         return _loc3_;
      }*/
      
      public function hide() : void
      {
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if(bgService != null)
         {
            bgService.drawBg();
         }
         this.stopAll();
         this.window = null;
         this.inner = null;
         this.rootContainer = null;
         this.cameraContainer = null;
         this.camera = null;
         this.timer = null;
         this.tank = null;
         Main.stage.removeEventListener(Event.ENTER_FRAME,this.onRender);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         if(this.autoRotationTimer.running)
         {
            this.autoRotationTimer.stop();
         }
         if(this.timer.running)
         {
            this.stop();
         }
         if(this.slowdownTimer.running)
         {
            this.slowdownTimer.stop();
         }
         this.resetRate();
         this.holdMouseX = Main.stage.mouseX;
         this.lastMouseX = this.holdMouseX;
         this.prelastMouseX = this.holdMouseX;
         this.holdAngle = this.cameraContainer.rotationZ;
         //Main.writeToConsole("TankPreview onMouseMove holdAngle: " + this.holdAngle.toString());
         Main.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         Main.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         this.cameraContainer.rotationZ = this.holdAngle - (Main.stage.mouseX - this.holdMouseX) * 0.01;
         //this.camera.render();
         this.rate = (Main.stage.mouseX - this.prelastMouseX) * 0.5;
         this.prelastMouseX = this.lastMouseX;
         this.lastMouseX = Main.stage.mouseX;
         clearInterval(this.resetRateInt);
         this.resetRateInt = setInterval(this.resetRate,50);
      }
      
      private function resetRate() : void
      {
         this.rate = 0;
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         clearInterval(this.resetRateInt);
         Main.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         Main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         if(Math.abs(this.rate) > 0)
         {
            this.slowdownTimer.reset();
            this.slowdownTimer.start();
         }
         else
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }
      
      private function slowDown(e:TimerEvent) : void
      {
         this.cameraContainer.rotationZ = this.cameraContainer.rotationZ - this.rate * 0.01;
         //this.camera.render();
         this.rate = this.rate * Math.exp(-0.02);
         if(Math.abs(this.rate) < 0.1)
         {
            this.slowdownTimer.stop();
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }
      
      public function setHull(hull:String) : void
      {
         var hullPart:Tank3DPart = new Tank3DPart();
         hullPart.details = ResourceUtil.getResource(ResourceType.IMAGE,hull + "_details").bitmapData;
         hullPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE,hull + "_lightmap").bitmapData;
         hullPart.mesh = ResourceUtil.getResource(ResourceType.MODEL, hull).mesh;
         hullPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL,hull).turretMount;
         this.tank.setHull(hullPart);
         if(this.loadedCounter < 3)
         {
            this.loadedCounter++;
         }
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }
      
      public function setTurret(turret:String) : void
      {
         var turretPart:Tank3DPart = new Tank3DPart();
         turretPart.details = ResourceUtil.getResource(ResourceType.IMAGE,turret + "_details").bitmapData;
         turretPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE,turret + "_lightmap").bitmapData;
         turretPart.mesh = ResourceUtil.getResource(ResourceType.MODEL,turret).mesh;
         turretPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL,turret).turretMount;
         this.tank.setTurret(turretPart);
         if(this.loadedCounter < 3)
         {
            this.loadedCounter++;
         }
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }
      
      public function setColorMap(map:ImageResouce) : void
      {
         this.tank.setColorMap(map);
         if(this.loadedCounter < 3)
         {
            this.loadedCounter++;
         }
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }
      
      public function resize(width:Number, height:Number, i:int = 0, j:int = 0) : void
      {
		 var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
		 Main.stage.removeEventListener(Event.ENTER_FRAME, this.onRender);
		 this.camera.view.width = width - this.windowMargin * 2 - 2;
		 this.camera.view.height = height - this.windowMargin * 2 - 2;
		 this.camera.view.x = this.windowMargin;
		 this.camera.view.y = this.windowMargin;
		 this.camera.render();
         this.window.width = width;
         this.window.height = height;
         this.window.alpha = 1;
		 this.inner.width = width - 22;
         this.inner.height = height - 22;
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         //if(Main.stage.stageWidth >= 800 && !this.first_resize)
		 //if(!this.first_resize)
         //{
            if(bgService != null)
            {
			   //Main.stage.removeEventListener(Event.ENTER_FRAME,this.onRender);
               //bgService.drawBg(new Rectangle(Math.round(int(Math.max(100, Main.stage.stageWidth)) / 3) + this.windowMargin, 71, this.inner.width, this.inner.height));
			   if (PanelModel(Main.osgi.getService(IPanel)).isInBattle)
			   {
				    bgService.drawBg(new Rectangle(0, 0, Main.stage.stageWidth, Main.stage.stageHeight));
			   }else{
					//bgService.drawBg(new Rectangle(Math.round(int(Math.max(100, Main.stage.stageWidth)) / 3) + this.windowMargin, 71, width - this.windowMargin * 2 - 2, height - this.windowMargin * 2 - 2));
					if (this.parent.parent != null)
					{
						bgService.drawBg(new Rectangle(Math.round(int(Math.max(100, Main.stage.stageWidth)) / 3) + this.windowMargin, 71, this.inner.width, this.inner.height));
					}
			   }
			   this.camera.view.visible = true;
			   //Main.stage.addEventListener(Event.ENTER_FRAME,this.onRender);
            }
         //}
		 this.camera.view.width = width - this.windowMargin * 2 - 2;
         this.camera.view.height = height - this.windowMargin * 2 - 2;
         this.camera.view.x = this.windowMargin;
         this.camera.view.y = this.windowMargin;
         this.camera.render();
		 Main.stage.addEventListener(Event.ENTER_FRAME,this.onRender);
         this.first_resize = false;
      }
      
      public function start(e:TimerEvent = null) : void
      {
         if(this.loadedCounter < 3)
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
         else
         {
            this.firstAutoRotation = false;
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.reset();
            this.lastTime = getTimer();
            this.timer.start();
         }
      }
      
      public function onRender(e:Event) : void
      {
         this.camera.render();
      }
      
      public function stop() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function stopAll() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.slowdownTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER,this.slowDown);
         this.autoRotationTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.start);
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         var time:int = this.lastTime;
         this.lastTime = getTimer();
         this.cameraContainer.rotationZ -= this.rotationSpeed * (this.lastTime - time) * dot1;
		 this.camera.render();
      }
   }
}
