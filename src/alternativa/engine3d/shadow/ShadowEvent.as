package alternativa.engine3d.shadow 
{
	import alternativa.engine3d.containers.KDContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.BSP;
	import alternativa.engine3d.objects.Decal;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.gfx.agal.FragmentShader;
	import alternativa.gfx.core.BitmapTextureResource;
	import alternativa.gfx.core.Device;
	import alternativa.gfx.core.ProgramResource;
	import alternativa.gfx.core.RenderTargetTextureResource;
	import alternativa.gfx.core.TextureResource;
	import alternativa.init.Main;
	import alternativa.math.Vector3;
	import alternativa.physics.collision.ICollisionDetector;
	import alternativa.physics.collision.types.RayIntersection;
	import alternativa.tanks.models.battlefield.BattlefieldModel;
	import alternativa.tanks.models.battlefield.IBattleField;
	import alternativa.tanks.models.battlefield.decals.RotationState;
	import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
	import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
	import alternativa.tanks.physics.CollisionGroup;
	import utils.adobe.utils.PerspectiveMatrix3D;
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import alternativa.engine3d.alternativa3d;
	import flash.utils.ByteArray;
	
	use namespace alternativa3d;
	
	public class ShadowEvent 
	{
		
	  private static const ANGLE_LIMIT:Number = 85 * Math.PI / 180;
      
      private static const rayHit:RayIntersection = new RayIntersection();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const right:Vector3 = new Vector3();
      
      private static const up:Vector3 = new Vector3();
      
      private static const normal:Vector3 = new Vector3();
      
      private static const origins:Vector.<Vector3> = Vector.<Vector3>([new Vector3(),new Vector3(),new Vector3(),new Vector3(),new Vector3()]);
      
      private static const position3D:Vector3D = new Vector3D();
      
      private static const normal3D:Vector3D = new Vector3D();
      
      private var collisionDetector:ICollisionDetector;
	  
	  private var er:Vector.<Object3D> = new Vector.<Object3D>();
	  
	  private var er1:Vector.<Decal> = new Vector.<Decal>();
	  
	  private var er2:TextureMaterial = new TextureMaterial(new BitmapData(1, 1, false, 0));
	  
	  private var er3:BitmapData = new BitmapData(1024, 1024, false, 0);
	  
	  private var c:Mesh = new Mesh();
	  
	  private var v:Boolean = true;
	  
	  private var rep:SimpleObjectController = new SimpleObjectController(Main.stage, c, 100000000);
	  
	  private var container:KDContainer = new KDContainer();
	  
	  private var volumeProgram:ProgramResource;
	  
	  private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
		private var modelMatrix:Matrix3D = new Matrix3D();
		private var viewMatrix:Matrix3D = new Matrix3D();
		private var modelViewProjection:Matrix3D = new Matrix3D();
		
		alternativa3d var map:RenderTargetTextureResource = new RenderTargetTextureResource(2048, 2048);
		
		public function ShadowEvent()
		{
			projectionMatrix.identity();
			// 45 degrees FOV, 640/480 aspect ratio, 0.1=near, 100=far
			projectionMatrix.perspectiveFieldOfViewRH(45.0, Main.stage.stageWidth / Main.stage.stageHeight, 0.01, 10000.0);
			
			// create a matrix that defines the camera location
			viewMatrix.identity();
			// move the camera back a little so we can see the mesh
			viewMatrix.appendTranslation(0, 0, -8);
		}
		
		public function add(param1:Object3D,param2:Vector3D,param3:Vector3D) : void
		{
			param1.x = param2.x;
			param1.y = param2.y;
			param1.z = param2.z;
			param1.rotationX = param3.x;
			param1.rotationY = param3.y;
			param1.rotationZ = param3.z;
			er.push(param1);
			var _loc8_:Decal = new Decal();
			_loc8_.createGeometry(param1);
			_loc8_.x = param2.x;
			_loc8_.y = param2.y;
			_loc8_.z = param2.z;
			_loc8_.rotationX = param3.x;
			_loc8_.rotationY = param3.y;
			_loc8_.rotationZ = param3.z;
			_loc8_.setMaterialToAllFaces(er2.clone());//_loc8_.setMaterialToAllFaces(new TextureMaterial(er2.clone()));
			//BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.getMapContainer().addChild(_loc8_);
			//container.createTree1(new Vector.<Object3D>([_loc8_]));
			//if (v)
			//{
				//BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.getMapContainer().addChild(container);
				//v = false;
			//}
			er1.push(_loc8_);
		}
		
		private function getVolumeProgram() : ProgramResource
		  {
			 var _loc2_:ByteArray = null;
			 var _loc3_:ByteArray = null;
			 var _loc1_:ProgramResource = volumeProgram;
			 if(_loc1_ == null)
			 {
				_loc2_ = new ShVertex().agalcode;
				_loc3_ = new ShFragment().agalcode;
				_loc1_ = new ProgramResource(_loc2_,_loc3_);
				volumeProgram = _loc1_;
			 }
			 return _loc1_;
		  }
		
		alternativa3d function render(param1:Camera3D) : void
		{
			//if (BattlefieldModel(Main.osgi.getService(IBattleField)) != null)
			//{
				//var gi:Vector3D = new Vector3D();
				//var te:SimpleObjectController = rep;
				var _loc2_:Device = param1.device;
				_loc2_.setRenderToTexture(this.map,true);
				//_loc2_.clear(0,0,0,0);
				//te.setObjectPosXYZ(param12.directionalLight.x, param12.directionalLight.y, param12.directionalLight.z);
				
				//_loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, modelViewProjection.rawData);
				viewMatrix.identity();
				// move the camera back a little so we can see the mesh
				viewMatrix.appendTranslation(param1.x, param1.y, param1.z);
				viewMatrix.appendRotation(param1.rotationX, Vector3D.X_AXIS);
				viewMatrix.appendRotation(param1.rotationY, Vector3D.Y_AXIS);
				viewMatrix.appendRotation(param1.rotationZ, Vector3D.Z_AXIS);
				for (var t:int = 0; t < er.length; t++)
				{
					//te.lookAtXYZ(er[t].x, er[t].y, er[t].z);
					//gi.x = c.rotationX;
					//gi.y = c.rotationY;
					//gi.z = c.rotationZ;
					//KDContainer(BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport._mapContainer).intersectRay(new Vector3D(er[t].x,er[t].boundMaxY + er[t].y,er[t].z),gi,null,param12)
					//FPSText.fps.text = c.rotationX + "	" + c.rotationY + "	" + c.rotationZ;
					if (er[t] is Mesh)
					{
						var hy:Mesh = (er[t] as Mesh);
						//if ((er[t] as Mesh).indexBuffer != null)
						//{
							er1[t].prepareResources();
							_loc2_.setProgram (getVolumeProgram());
							//FPSText.fps.text = "111111111111";
							modelMatrix.identity();
							modelMatrix.appendTranslation(hy.x, hy.y, hy.z);
							modelMatrix.appendRotation(hy.rotationX, Vector3D.X_AXIS);
							modelMatrix.appendRotation(hy.rotationY, Vector3D.Y_AXIS);
							modelMatrix.appendRotation(hy.rotationZ, Vector3D.Z_AXIS);
							modelViewProjection.identity();
							modelViewProjection.append(modelMatrix);
							modelViewProjection.append(viewMatrix);
							modelViewProjection.append(projectionMatrix);
							_loc2_._stage3D.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true);
							_loc2_.setVertexBufferAt(0, er1[t].vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
							_loc2_.setVertexBufferAt(1, er1[t].vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
							//var u:BitmapTextureResource = new BitmapTextureResource(er3,false);//(((er[t]as Mesh).faces[0].material as TextureMaterial).texture,false);
							_loc2_.setTextureAt(0,er1[t].iu)//_loc2_.setTextureAt(0, (new Texture()).uploadFromBitmapData(((er[t]as Mesh).faces[0].material as TextureMaterial).texture));//(Context3DProgramType.VERTEX,0,Vector.<Number>(((er[t]as Mesh).faces[0].material as TextureMaterial).texture.getVector(new Rectangle(0,0,1,1))),5,false);
							_loc2_.drawTriangles(er1[t].indexBuffer, 0, er1[t].numTriangles);
						//}
					}
					//_loc2_.present();
				}
			//}
		}
		
		public function copyToVector3D(param1:Vector3,param2:Vector3D) : Vector3D
		  {
			 return param2 = new Vector3D(param1.x,param1.y,param1.z);
		  }
		
		private function getRotation(param1:RotationState) : Number
		  {
			 switch(param1)
			 {
				case RotationState.WITHOUT_ROTATION:
				   return 0;
				default:
				   return Math.random() * 2 * Math.PI;
			 }
		  }
		
	}

}