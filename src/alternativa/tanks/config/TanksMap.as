package alternativa.tanks.config
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.tanks.config.loaders.MapLoader;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   public class TanksMap extends ResourceLoader
   {
       
      
      public var mapContainer:KDContainer;
      
      private var loader:MapLoader;
      
      private var spawnMarkers:Object;
      
      private var ctfFlags:Object;
      
      private var mapId:String;
      
      public function TanksMap(config:Config, idMap:String)
      {
         this.spawnMarkers = {};
         this.ctfFlags = {};
         this.mapId = idMap;
         super("Tank map loader", config);
      }
      
      override public function run() : void
      {
         if(config.xml.map.length() == 0)
         {
            throw new Error("No map found");
         }
         this.loader = new MapLoader();
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.load("maps/" + this.mapId + ".xml",config.propLibRegistry);
      }
      
      public function get collisionPrimitives() : Vector.<CollisionPrimitive>
      {
         return this.loader.collisionPrimitives;
      }
      
      public function showSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(!visible)
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      public function hideSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(visible)
            {
               this.mapContainer.removeChild(marker);
            }
         }
      }
      
      public function toggleSpawnMarkers(type:String) : void
      {
         var marker:Object3D = null;
         var markes:Vector.<Object3D> = this.getSpawnMarkers(type);
         var visible:Boolean = Object3D(markes[0]).parent != null;
         for each(marker in markes)
         {
            if(visible)
            {
               this.mapContainer.removeChild(marker);
            }
            else
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      public function showCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null && marker.parent == null)
         {
            this.mapContainer.addChild(marker);
         }
      }
      
      public function hideCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null && marker.parent != null)
         {
            this.mapContainer.removeChild(marker);
         }
      }
      
      public function toggleCTFFlagMarker(type:String) : void
      {
         var marker:Object3D = this.getCTFFlagMarker(type);
         if(marker != null)
         {
            if(marker.parent != null)
            {
               this.mapContainer.removeChild(marker);
            }
            else
            {
               this.mapContainer.addChild(marker);
            }
         }
      }
      
      private function getCTFFlagMarker(type:String) : Sprite3D
      {
         var pos:Vector3D = null;
         var texture:BitmapData = null;
         var sprite:Sprite3D = this.ctfFlags[type];
         if(sprite == null)
         {
            pos = this.loader.getFlagPosition(type);
            if(pos == null)
            {
               return null;
            }
            texture = config.textureLibrary.getTexture(type + "_flag");
            sprite = new Sprite3D(texture.width,texture.height);
            sprite.originX = 0;
            sprite.originY = 1;
            sprite.clipping = Clipping.FACE_CLIPPING;
            sprite.material = new TextureMaterial(texture);
            sprite.x = pos.x;
            sprite.y = pos.y;
            sprite.z = pos.z;
            this.ctfFlags[type] = sprite;
         }
         return sprite;
      }
      
      private function getSpawnMarkers(type:String) : Vector.<Object3D>
      {
         var texture:BitmapData = null;
         var textureMaterial:TextureMaterial = null;
         var sprite:Sprite3D = null;
         var spawnMarkersData:SpawnMarkersData = this.spawnMarkers[type];
         spawnMarkersData = new SpawnMarkersData();
         texture = config.textureLibrary.getTexture(type + "_spawn_marker");
         textureMaterial = new TextureMaterial(texture);
         spawnMarkersData.markers = new Vector.<Object3D>();
         return null;
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         var sprite:Sprite3D = null;
         this.mapContainer = this.createKDContainer(this.loader.objects,this.loader.occluders);
         this.mapContainer.threshold = 0.1;
         this.mapContainer.ignoreChildrenInCollider = true;
         this.mapContainer.calculateBounds();
         this.mapContainer.name = "Visual Kd-tree";
         for each(sprite in this.loader.sprites)
         {
            this.mapContainer.addChild(sprite);
         }
         BattlefieldModel(Main.osgi.getService(IBattleField)).build(this.mapContainer,this.collisionPrimitives,this.loader.lights);
         completeTask();
      }
      
      private function createKDContainer(objects:Vector.<Object3D>, occluders:Vector.<Occluder>) : KDContainer
      {
         var container:KDContainer = new KDContainer();
         container.createTree(objects, occluders);
		 /*
		 var shad:Shadow = BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.sr;
		 shad.backFadeRange = 1;
		 //var x:Number = -1;
         //var z:Number = -0.5;
         //var matrix:Matrix3 = new Matrix3();
         //matrix.setRotationMatrix(x,0,z);
         //var toPos:Vector3 = new Vector3(0,10000,0);
         //toPos.vTransformBy3(matrix);
         //shad.light.y = 180000;
		 //shad.light.x = container.boundMinX - 1000;
		 var dr:DirectionalLight = new DirectionalLight(0);
		 //dr.lookAt();
		 for (var j:int = 0; j < objects.length; j++)
		 {
			 dr.lookAt(objects[j].x,objects[j].y,objects[j].z);
			 shad.direction = new Vector3D(dr.rotationX + 2.5,dr.rotationY + 1,dr.rotationZ + 40);
			 shad.addCaster(objects[j]);
		 }
		 */
         return container;
      }
   }
}

import alternativa.engine3d.core.Object3D;

class SpawnMarkersData
{
    
   
   public var markers:Vector.<Object3D>;
   
   function SpawnMarkersData()
   {
      super();
   }
}
