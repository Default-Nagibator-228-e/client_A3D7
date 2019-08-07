package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.resource.StubBitmapData;
   import alternativa.tanks.engine3d.ITextureMaterialRegistry;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.materials.TrackMaterial;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   
   public class TankSkin
   {
      
      private static const STATE_NORMAL:int = 1;
      
      private static const STATE_DEAD:int = 2;
      
      private static const MAX_COLOR_TRANSFORM:ColorTransform = new ColorTransform(0.8,1,1.2,1,40,60,70);
      
      private static var compositions:Dictionary = new Dictionary();
      
      private static var colorTranformPercentSpeed:Number = 0.4;
      
      private static var hullMatrix:Matrix4 = new Matrix4();
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var vector:Vector3 = new Vector3();
      
      private static var textureRegistry:ITextureMaterialRegistry;
	  
      [Embed(source="t/1.png")]
      private var details:Class;
      
      private var leftTrackSkin:TrackSkin;
      
      private var rightTrackSkin:TrackSkin;
      
      public var turretDirection:Number = 0;
      
      public var targetColorTransformOffset:Number = 0;
      
      private var skinState:int;
      
      private var normalMaterials:SkinStateMaterials;
      
      private var deadMaterials:SkinStateMaterials;
      
      private var _hullDescriptor:TankSkinHull;
      
      private var _hullMesh:Mesh;
      
      private var _turretDescriptor:TankSkinTurret;
      
      private var _turretMesh:Mesh;
      
      private var colorTransform:ColorTransform;
      
      private var colorTransformOffset:Number = 0;
      
      private var container:Scene3DContainer;
      
      private var detailsID:String = "";
      
      public function TankSkin(hull:TankSkinHull, turret:TankSkinTurret, normalColoring:ImageResouce, deadColoring:BitmapData, lightmapHullId:String, detailsHullId:String, lightmapTurretid:String, detailsTurretId:String, textureMaterialRegistry:ITextureMaterialRegistry)
      {
         this.colorTransform = new ColorTransform();
         super();
         if(hull == null)
         {
            throw new ArgumentError("Hull is null");
         }
         if(turret == null)
         {
            throw new ArgumentError("Turret is null");
         }
         if(normalColoring == null)
         {
            throw new ArgumentError("Coloring is null");
         }
         if(deadColoring == null)
         {
            throw new ArgumentError("Dead coloring is null");
         }
         if(textureRegistry == null)
         {
            textureRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry)).textureMaterialRegistry;
         }
         this._hullMesh = this.initHull(hull);
         this._turretMesh = this.initTurret(turret);
         this.detailsID = detailsHullId;
         this.normalMaterials = this.createStateMaterials(normalColoring,textureRegistry,lightmapHullId,detailsHullId,lightmapTurretid,detailsTurretId);
         this.deadMaterials = this.createStateMaterials(normalColoring,textureRegistry,lightmapHullId,detailsHullId,lightmapTurretid,detailsTurretId,true);
      }
      
      public function updateTurretTransform(param1:Number) : void
      {
         var turretMountPoint:Vector3 = null;
         if(this.hullDescriptor != null && this.turretDescriptor != null)
         {
            hullMatrix.setMatrix(this.hullMesh.x,this.hullMesh.y,this.hullMesh.z,this.hullMesh.rotationX,this.hullMesh.rotationY,this.hullMesh.rotationZ);
            turretMountPoint = this._hullDescriptor.turretMountPoint;
            turretMatrix.setMatrix(turretMountPoint.x,turretMountPoint.y,turretMountPoint.z + 1,0,0,this.turretDirection);
            turretMatrix.append(hullMatrix);
            turretMatrix.getEulerAngles(vector);
            this._turretMesh.x = turretMatrix.d;
            this._turretMesh.y = turretMatrix.h;
            this._turretMesh.z = turretMatrix.l;
            this._turretMesh.rotationX = vector.x;
            this._turretMesh.rotationY = vector.y;
            this._turretMesh.rotationZ = vector.z;
         }
      }
      
      public function updateHullTransform(param1:Vector3, param2:Vector3) : void
      {
         if(this.hullDescriptor != null)
         {
            this.hullMesh.x = param1.x;
            this.hullMesh.y = param1.y;
            this.hullMesh.z = param1.z;
            this.hullMesh.rotationX = param2.x;
            this.hullMesh.rotationY = param2.y;
            this.hullMesh.rotationZ = param2.z;
         }
      }
      
      public function dispose() : void
      {
      }
      
      public function setNormalState() : void
      {
         this.skinState = STATE_NORMAL;
         this._hullMesh.setMaterialToAllFaces(this.normalMaterials.hullMaterial);
         this._turretMesh.setMaterialToAllFaces(this.normalMaterials.turretMaterial);
         this.createTrackSkins();
      }
      
      public function setDeadState() : void
      {
         this.skinState = STATE_DEAD;
         this._hullMesh.setMaterialToAllFaces(this.deadMaterials.hullMaterial);
         this._turretMesh.setMaterialToAllFaces(this.deadMaterials.turretMaterial);
      }
      
      public function resetColorTransform() : void
      {
         this.colorTransformOffset = 0;
         this.targetColorTransformOffset = 0;
         this.colorTransform.redMultiplier = 1;
         this.colorTransform.greenMultiplier = 1;
         this.colorTransform.blueMultiplier = 1;
         this.colorTransform.redOffset = 0;
         this.colorTransform.greenOffset = 0;
         this.colorTransform.blueOffset = 0;
      }
      
      public function updateColorTransform(dt:Number) : void
      {
         if(this.colorTransformOffset == this.targetColorTransformOffset)
         {
            return;
         }
         if(this.colorTransformOffset > this.targetColorTransformOffset)
         {
            this.colorTransformOffset = this.colorTransformOffset - colorTranformPercentSpeed * dt;
            if(this.colorTransformOffset < this.targetColorTransformOffset)
            {
               this.colorTransformOffset = this.targetColorTransformOffset;
            }
         }
         else
         {
            this.colorTransformOffset = this.colorTransformOffset + colorTranformPercentSpeed * dt;
            if(this.colorTransformOffset > this.targetColorTransformOffset)
            {
               this.colorTransformOffset = this.targetColorTransformOffset;
            }
         }
         this.colorTransform.redMultiplier = 1 + this.colorTransformOffset * (MAX_COLOR_TRANSFORM.redMultiplier - 1);
         this.colorTransform.greenMultiplier = 1 + this.colorTransformOffset * (MAX_COLOR_TRANSFORM.greenMultiplier - 1);
         this.colorTransform.blueMultiplier = 1 + this.colorTransformOffset * (MAX_COLOR_TRANSFORM.blueMultiplier - 1);
         this.colorTransform.redOffset = this.colorTransformOffset * MAX_COLOR_TRANSFORM.redOffset;
         this.colorTransform.greenOffset = this.colorTransformOffset * MAX_COLOR_TRANSFORM.greenOffset;
         this.colorTransform.blueOffset = this.colorTransformOffset * MAX_COLOR_TRANSFORM.blueOffset;
      }
      
      public function setAlpha(value:Number) : void
      {
         this.turretMesh.alpha = value;
         this.hullMesh.alpha = value;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         if(this.container == null)
         {
            this.container = container;
            container.addChild(this._hullMesh);
            container.addChild(this._turretMesh);
         }
         else
         {
            this._hullMesh.visible = true;
            this._turretMesh.visible = true;
         }
      }
      
      public function removeFromContainer() : void
      {
         this._hullMesh.visible = false;
         this._turretMesh.visible = false;
      }
      
      public function getTurretEulerAngles(result:Vector3) : void
      {
         result.x = this._turretMesh.x;
         result.y = this._turretMesh.y;
         result.z = this._turretMesh.z;
      }
      
      public function get hullMesh() : Mesh
      {
         return this._hullMesh;
      }
      
      public function get turretMesh() : Mesh
      {
         return this._turretMesh;
      }
      
      public function get hullDescriptor() : TankSkinHull
      {
         return this._hullDescriptor;
      }
      
      public function get turretDescriptor() : TankSkinTurret
      {
         return this._turretDescriptor;
      }
      
      public function updateTransform(pos:Vector3, orientation:Quaternion) : void
      {
         this.updateTurretTransform(this.turretDirection);
      }
      
      private function initHull(hullDescriptor:TankSkinHull) : Mesh
      {
         this._hullDescriptor = hullDescriptor;
         return this.createMesh(hullDescriptor.mesh);
      }
      
      private function initTurret(turretDescriptor:TankSkinTurret) : Mesh
      {
         this._turretDescriptor = turretDescriptor;
         return this.createMesh(turretDescriptor.mesh);
      }
      
      private function createMesh(referenceMesh:Mesh) : Mesh
      {
         var mesh:Mesh = Mesh(referenceMesh.clone());
         mesh.colorTransform = this.colorTransform;
         return mesh;
      }
      
      private function createStateMaterials(coloring:ImageResouce, textureMaterialRegistry:ITextureMaterialRegistry, ligthmapHull:String, detailsHull:String, ligthmapTurret:String, detailsTurret:String, isDeadTexture:Boolean = false) : SkinStateMaterials
      {
         var hullMaterial:Material = null;
         var turretMaterial:Material = null;
         var lh:BitmapData = null;
         var dh:BitmapData = null;
         var lt:BitmapData = null;
         var dt:BitmapData = null;
         var useMipMapping:Boolean = IBattleSettings(Main.osgi.getService(IBattleSettings)).enableMipMapping;
         var idCompositionHull:String = coloring.id + "_" + ligthmapHull + "_" + detailsHull + "_" + "_" + isDeadTexture;
         var idCompositionTurret:String = coloring.id + "_" + ligthmapTurret + "_" + detailsTurret + "_" + "_" + isDeadTexture;
         var hullComposition:BitmapData = compositions[idCompositionHull];
         if(hullComposition == null)
         {
            lh = ResourceUtil.getResource(ResourceType.IMAGE,ligthmapHull).bitmapData;
            dh = ResourceUtil.getResource(ResourceType.IMAGE,detailsHull).bitmapData;
            trace(detailsHull);
            hullComposition = isDeadTexture?this.createTexture(ResourceUtil.getResource(ResourceType.IMAGE,"deadTank").bitmapData,lh,dh):this.createTexture(coloring.bitmapData as BitmapData,lh,dh);
            compositions[idCompositionHull] = hullComposition;
         }
         var turretComposition:BitmapData = compositions[idCompositionTurret];
         if(turretComposition == null)
         {
            lt = ResourceUtil.getResource(ResourceType.IMAGE,ligthmapTurret).bitmapData;
            dt = ResourceUtil.getResource(ResourceType.IMAGE,detailsTurret).bitmapData;
            turretComposition = isDeadTexture?this.createTexture(ResourceUtil.getResource(ResourceType.IMAGE,"deadTank").bitmapData,lt,dt):this.createTexture(coloring.bitmapData as BitmapData,lt,dt);
            compositions[idCompositionTurret] = turretComposition;
         }
         if(coloring.animatedMaterial && !isDeadTexture)
         {
            hullMaterial = textureMaterialRegistry.getAnimatedPaint(coloring,ResourceUtil.getResource(ResourceType.IMAGE,ligthmapHull).bitmapData,ResourceUtil.getResource(ResourceType.IMAGE,detailsHull).bitmapData,detailsHull);
         }
         else
         {
            hullMaterial = textureMaterialRegistry.getMaterial(MaterialType.TANK,hullComposition,1);
         }
         if(coloring.animatedMaterial && !isDeadTexture)
         {
            turretMaterial = textureMaterialRegistry.getAnimatedPaint(coloring,ResourceUtil.getResource(ResourceType.IMAGE,ligthmapTurret).bitmapData,ResourceUtil.getResource(ResourceType.IMAGE,detailsTurret).bitmapData,detailsTurret);
         }
         else
         {
            turretMaterial = textureMaterialRegistry.getMaterial(MaterialType.TANK,turretComposition,1);
         }
         return new SkinStateMaterials(coloring.bitmapData as BitmapData,hullMaterial,turretMaterial);
      }
      
      private function createTexture(colormap:BitmapData, lightmap:BitmapData, details1:BitmapData) : BitmapData
      {
         return this.createTexture1(colormap,lightmap,details1);
      }
      
      private function createTexture1(colormap:BitmapData, lightmap:BitmapData, details1:BitmapData) : BitmapData
      {
         var texture:BitmapData = null;
         var shape:Shape = null;
         try
         {
            texture = new BitmapData(lightmap.width,lightmap.height,false,0);
            shape = new Shape();
            shape.graphics.beginBitmapFill(colormap);
            shape.graphics.drawRect(0,0,lightmap.width,lightmap.height);
            texture.draw(shape);
            texture.draw(lightmap,null,null,BlendMode.HARDLIGHT);
            texture.draw(details1);
            return texture;
         }
         catch(e:Error)
         {
            return new StubBitmapData(16711680);
         }
         return null;
      }
      
      public function updateTracks(param1:Number, param2:Number) : void
      {
         this.leftTrackSkin.move(param1);
         this.rightTrackSkin.move(param2);
      }
      
      public function createTrackSkins() : void
      {
         var _details:BitmapData = null;
         var param1:Mesh = this._hullMesh;
         var _loc2_:Face;
         this.leftTrackSkin = new TrackSkin();
         this.rightTrackSkin = new TrackSkin();
         for each(_loc2_ in param1.faces)
         {
            if(_loc2_.material.name == "tracks")
            {
               this.addFaceToTrackSkin(_loc2_);
            }
         }
         this.leftTrackSkin.init();
         this.rightTrackSkin.init();
         _details = ResourceUtil.getResource(ResourceType.IMAGE,this.detailsID).bitmapData;
         this.leftTrackSkin.setMaterial(new TrackMaterial(_details));
         this.rightTrackSkin.setMaterial(new TrackMaterial(_details));
      }
      
      private function addFaceToTrackSkin(param1:Face) : void
      {
         var _loc2_:Vertex = param1.vertices[0];
         if(_loc2_.x < 0)
         {
            this.leftTrackSkin.addFace(param1);
         }
         else
         {
            this.rightTrackSkin.addFace(param1);
         }
      }
   }
}

import alternativa.engine3d.materials.Material;
import flash.display.BitmapData;

class SkinStateMaterials
{
    
   
   public var coloring:BitmapData;
   
   public var hullMaterial:Material;
   
   public var turretMaterial:Material;
   
   function SkinStateMaterials(coloring:BitmapData, hullMaterial:Material, turretMaterial:Material)
   {
      super();
      this.coloring = coloring;
      this.hullMaterial = hullMaterial;
      this.turretMaterial = turretMaterial;
   }
   
   public function release() : void
   {
      this.hullMaterial = null;
      this.turretMaterial = null;
   }
}
