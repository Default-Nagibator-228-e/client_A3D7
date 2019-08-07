package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.containers.ConflictContainer;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.gfx.agal.FragmentShader;
   import alternativa.gfx.agal.Shader;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.TextureResource;
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.init.Main;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Object3DContainerProxy;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class Shadow
   {
      
      private static var casterProgram:ProgramResource;
      
      private static var casterConst:Vector.<Number> = Vector.<Number>([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]);
      
      private static var volumeProgram:ProgramResource;
      
      private static var volumeVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([0,0,0,0,1,0,1,1,0,1,0,0,0,0,1,0,1,1,1,1,1,1,0,1]),3);
      
      private static var volumeIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0,1,3,2,3,1,7,6,4,5,4,6,4,5,0,1,0,5,3,2,7,6,7,2,0,3,4,7,4,3,5,6,1,2,1,6]));
      
      private static var volumeTransformConst:Vector.<Number> = new Vector.<Number>(20);
      
      private static var volumeFragmentConst:Vector.<Number> = Vector.<Number>([1,0,1,0.5]);
      
      private static var receiverPrograms:Array = new Array();
       
      
      public var mapSize:int;
      
      public var blur:int = 6;
      
      public var attenuation:Number;
      
      public var nearDistance:Number;
      
      public var farDistance:Number;
      
      public var color:int;
      
      public var alpha:Number;
      
      public var direction:Vector3D;
      
      public var offset:Number = 0;
      
      public var backFadeRange:Number = 0;
      
      public var casters:Vector.<Object3D>;
      
      public var castersCount:int = 0;
      
      alternativa3d var receiversBuffers:Vector.<int>;
      
      alternativa3d var receiversFirstIndexes:Vector.<int>;
      
      alternativa3d var receiversNumsTriangles:Vector.<int>;
      
      alternativa3d var receiversCount:int = 0;
      
      private var dir:Vector3D;
      
      public var light:DirectionalLight;
      
      private var boundVertexList:Vertex;
      
      private var planeX:Number;
      
      private var planeY:Number;
      
      private var planeSize:Number;
      
      private var minZ:Number;
      
      alternativa3d var boundMinX:Number;
      
      alternativa3d var boundMinY:Number;
      
      alternativa3d var boundMinZ:Number;
      
      alternativa3d var boundMaxX:Number;
      
      alternativa3d var boundMaxY:Number;
      
      alternativa3d var boundMaxZ:Number;
      
      alternativa3d var cameraInside:Boolean;
      
      private var transformConst:Vector.<Number>;
      
      private var uvConst:Vector.<Number>;
      
      private var colorConst:Vector.<Number>;
      
      private var clampConst:Vector.<Number>;
      
      alternativa3d var texture:TextureResource;
      
      alternativa3d var textureScaleU:Number;
      
      alternativa3d var textureScaleV:Number;
      
      alternativa3d var textureOffsetU:Number;
      
      alternativa3d var textureOffsetV:Number;
	  
	  private var programs:Array = new Array();
	  
	  private var spriteVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([0,2,4,6]),1);
      
      private var spriteIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0,1,3,1,2,3]));
	  
	  private var coords:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1 / 255, 1]);
	  
	  private var fk:Vector.<Object3D> = new Vector.<Object3D>();
      
      public function Shadow(param1:int, param2:int, param3:Number, param4:Number, param5:Number, param6:int = 0, param7:Number = 1)
      {
         this.direction = new Vector3D(0,0,-1);
         this.casters = new Vector.<Object3D>();
         this.receiversBuffers = new Vector.<int>();
         this.receiversFirstIndexes = new Vector.<int>();
         this.receiversNumsTriangles = new Vector.<int>();
         this.dir = new Vector3D();
         this.light = new DirectionalLight(0);
         this.boundVertexList = Vertex.createList(8);
         this.transformConst = new Vector.<Number>(12);
         this.uvConst = Vector.<Number>([0,0,0,1,0,0,0,1]);
         this.colorConst = new Vector.<Number>(12);
         this.clampConst = Vector.<Number>([0,0,0,1]);
         super();
         if(param1 > ShadowAtlas.sizeLimit)
         {
            throw new Error("Value of mapSize too big.");
         }
         var _loc8_:Number = Math.log(param1) / Math.LN2;
         if(_loc8_ != int(_loc8_))
         {
            throw new Error("Value of mapSize must be power of 2.");
         }
         this.mapSize = param1;
         this.blur = param2;
         this.attenuation = param3;
         this.nearDistance = param4;
         this.farDistance = param5;
         this.color = param6;
         this.alpha = param7;
      }
      
      alternativa3d static function getCasterProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:FragmentShader = null;
         var _loc1_:ProgramResource = casterProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new ShadowCasterVertexShader().agalcode;
            _loc3_ = new FragmentShader();
            _loc3_.mov(FragmentShader.oc,Shader.v0);
            _loc1_ = new ProgramResource(_loc2_,_loc3_.agalcode);
            casterProgram = _loc1_;
         }
         return _loc1_;
      }
      
      public function addCaster(param1:Object3D,param2:Object3D = null) : void
      {
		this.casters[this.castersCount] = param1;
		this.castersCount++;
      }
      
      public function removeCaster(param1:Mesh, param2:Object3D = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.castersCount)
         {
            if(this.casters[_loc2_] == param2)
            {
               this.castersCount--;
               while(_loc2_ < this.castersCount)
               {
                  this.casters[_loc2_] = this.casters[int(_loc2_ + 1)];
                  _loc2_++;
               }
               this.casters.length = this.castersCount;
               break;
            }
            _loc2_++;
         }
      }
      
      public function removeAllCasters() : void
      {
         this.castersCount = 0;
         this.casters.length = 0;
      }
      
      alternativa3d function checkVisibility(param1:Camera3D) : Boolean
      {
         var _loc24_:Object3D = null;
         var _loc25_:Object3D = null;
         var _loc26_:Vertex = null;
         var _loc27_:Number = NaN;
         if(this.castersCount == 0)
         {
            return false;
         }
         if(this.direction != null)
         {
            this.dir.x = this.direction.x;
            this.dir.y = this.direction.y;
            this.dir.z = this.direction.z;
            this.dir.normalize();
         }
         else
         {
            this.dir.x = 0;
            this.dir.y = 0;
            this.dir.z = -1;
         }
         this.light.rotationX = Math.atan2(this.dir.z,Math.sqrt(this.dir.x * this.dir.x + this.dir.y * this.dir.y)) - Math.PI / 2;
         this.light.rotationY = 0;
         this.light.rotationZ = -Math.atan2(this.dir.x,this.dir.y);
         this.light.composeMatrix();
		 var _loc12_:Number = this.light.mk;
         var _loc2_:Number = this.light.ma;
         var _loc3_:Number = this.light.mb;
         var _loc4_:Number = this.light.mc;
         var _loc5_:Number = this.light.md;
         var _loc6_:Number = this.light.me;
         var _loc7_:Number = this.light.mf;
         var _loc8_:Number = this.light.mg;
         var _loc9_:Number = this.light.mh;
         var _loc10_:Number = this.light.mi;
         var _loc11_:Number = this.light.mj;
         var _loc13_:Number = this.light.ml;
         this.light.invertMatrix();
         this.light.ima = this.light.ma;
         this.light.imb = this.light.mb;
         this.light.imc = this.light.mc;
         this.light.imd = this.light.md;
         this.light.ime = this.light.me;
         this.light.imf = this.light.mf;
         this.light.img = this.light.mg;
         this.light.imh = this.light.mh;
         this.light.imi = this.light.mi;
         this.light.imj = this.light.mj;
         this.light.imk = this.light.mk;
         this.light.iml = this.light.ml;
         this.light.boundMinX = 1.0e22;
         this.light.boundMinY = 1.0e22;
         this.light.boundMinZ = 1.0e22;
         this.light.boundMaxX = -1.0e22;
         this.light.boundMaxY = -1.0e22;
         this.light.boundMaxZ = -1.0e22;
         var _loc14_:int = 0;
         while(_loc14_ < this.castersCount)
         {
            _loc24_ = this.casters[_loc14_];
            _loc24_.composeMatrix();
            _loc25_ = _loc24_._parent;
            while(_loc25_ != null)
            {
               Object3D.tA.composeMatrixFromSource(_loc25_);
               _loc24_.appendMatrix(Object3D.tA);
               _loc25_ = _loc25_._parent;
            }
            _loc24_.appendMatrix(this.light);
            _loc26_ = this.boundVertexList;
            _loc26_.x = _loc24_.boundMinX;
            _loc26_.y = _loc24_.boundMinY;
            _loc26_.z = _loc24_.boundMinZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMaxX;
            _loc26_.y = _loc24_.boundMinY;
            _loc26_.z = _loc24_.boundMinZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMinX;
            _loc26_.y = _loc24_.boundMaxY;
            _loc26_.z = _loc24_.boundMinZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMaxX;
            _loc26_.y = _loc24_.boundMaxY;
            _loc26_.z = _loc24_.boundMinZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMinX;
            _loc26_.y = _loc24_.boundMinY;
            _loc26_.z = _loc24_.boundMaxZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMaxX;
            _loc26_.y = _loc24_.boundMinY;
            _loc26_.z = _loc24_.boundMaxZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMinX;
            _loc26_.y = _loc24_.boundMaxY;
            _loc26_.z = _loc24_.boundMaxZ;
            _loc26_ = _loc26_.next;
            _loc26_.x = _loc24_.boundMaxX;
            _loc26_.y = _loc24_.boundMaxY;
            _loc26_.z = _loc24_.boundMaxZ;
            _loc26_ = this.boundVertexList;
            while(_loc26_ != null)
            {
               _loc26_.cameraX = _loc24_.ma * _loc26_.x + _loc24_.mb * _loc26_.y + _loc24_.mc * _loc26_.z + _loc24_.md;
               _loc26_.cameraY = _loc24_.me * _loc26_.x + _loc24_.mf * _loc26_.y + _loc24_.mg * _loc26_.z + _loc24_.mh;
               _loc26_.cameraZ = _loc24_.mi * _loc26_.x + _loc24_.mj * _loc26_.y + _loc24_.mk * _loc26_.z + _loc24_.ml;
               if(_loc26_.cameraX < this.light.boundMinX)
               {
                  this.light.boundMinX = _loc26_.cameraX;
               }
               if(_loc26_.cameraX > this.light.boundMaxX)
               {
                  this.light.boundMaxX = _loc26_.cameraX;
               }
               if(_loc26_.cameraY < this.light.boundMinY)
               {
                  this.light.boundMinY = _loc26_.cameraY;
               }
               if(_loc26_.cameraY > this.light.boundMaxY)
               {
                  this.light.boundMaxY = _loc26_.cameraY;
               }
               if(_loc26_.cameraZ < this.light.boundMinZ)
               {
                  this.light.boundMinZ = _loc26_.cameraZ;
               }
               if(_loc26_.cameraZ > this.light.boundMaxZ)
               {
                  this.light.boundMaxZ = _loc26_.cameraZ;
               }
               _loc26_ = _loc26_.next;
            }
            _loc14_++;
         }
         var _loc15_:int = this.mapSize - 1 - 1 - this.blur - this.blur;
         var _loc16_:Number = this.light.boundMaxX - this.light.boundMinX;
         var _loc17_:Number = this.light.boundMaxY - this.light.boundMinY;
         var _loc18_:Number = _loc16_ > _loc17_?Number(Number(_loc16_)):Number(Number(_loc17_));
         var _loc19_:Number = _loc18_ / _loc15_;
         var _loc20_:Number = (1 + this.blur) * _loc19_;
         var _loc21_:Number = (1 + this.blur) * _loc19_;
         if(_loc16_ > _loc17_)
         {
            _loc21_ = _loc21_ + (Math.ceil((_loc17_ - 0.01) / (_loc19_ + _loc19_)) * (_loc19_ + _loc19_) - _loc17_) * 0.5;
         }
         else
         {
            _loc20_ = _loc20_ + (Math.ceil((_loc16_ - 0.01) / (_loc19_ + _loc19_)) * (_loc19_ + _loc19_) - _loc16_) * 0.5;
         }
         this.light.boundMinX = this.light.boundMinX - _loc20_;
         this.light.boundMaxX = this.light.boundMaxX + _loc20_;
         this.light.boundMinY = this.light.boundMinY - _loc21_;
         this.light.boundMaxY = this.light.boundMaxY + _loc21_;
         this.light.boundMinZ = this.light.boundMinZ + this.offset;
         this.light.boundMaxZ = this.light.boundMaxZ + this.attenuation;
         this.planeSize = _loc18_ * this.mapSize / _loc15_;
         if(_loc16_ > _loc17_)
         {
            this.planeX = this.light.boundMinX;
            this.planeY = this.light.boundMinY - (this.light.boundMaxX - this.light.boundMinX - (this.light.boundMaxY - this.light.boundMinY)) * 0.5;
         }
         else
         {
            this.planeX = this.light.boundMinX - (this.light.boundMaxY - this.light.boundMinY - (this.light.boundMaxX - this.light.boundMinX)) * 0.5;
            this.planeY = this.light.boundMinY;
         }
         var _loc22_:Number = param1.farClipping;
         param1.farClipping = this.farDistance * param1.shadowsDistanceMultiplier;
         this.light.ma = _loc2_;
         this.light.mb = _loc3_;
         this.light.mc = _loc4_;
         this.light.md = _loc5_;
         this.light.me = _loc6_;
         this.light.mf = _loc7_;
         this.light.mg = _loc8_;
         this.light.mh = _loc9_;
         this.light.mi = _loc10_;
         this.light.mj = _loc11_;
         this.light.mk = _loc12_;
         this.light.ml = _loc13_;
         this.light.appendMatrix(param1);
         var _loc23_:Boolean = this.cullingInCamera(param1);
         param1.farClipping = _loc22_;
         if(_loc23_)
         {
            if(param1.debug && param1.checkInDebug(this.light) & Debug.BOUNDS)
            {
               Debug.drawBounds(param1,this.light,this.light.boundMinX,this.light.boundMinY,this.light.boundMinZ,this.light.boundMaxX,this.light.boundMaxY,this.light.boundMaxZ,16711935);
            }
            this.boundMinX = 1.0e22;
            this.boundMinY = 1.0e22;
            this.boundMinZ = 1.0e22;
            this.boundMaxX = -1.0e22;
            this.boundMaxY = -1.0e22;
            this.boundMaxZ = -1.0e22;
            _loc26_ = this.boundVertexList;
            while(_loc26_ != null)
            {
               _loc26_.cameraX = _loc2_ * _loc26_.x + _loc3_ * _loc26_.y + _loc4_ * _loc26_.z + _loc5_;
               _loc26_.cameraY = _loc6_ * _loc26_.x + _loc7_ * _loc26_.y + _loc8_ * _loc26_.z + _loc9_;
               _loc26_.cameraZ = _loc10_ * _loc26_.x + _loc11_ * _loc26_.y + _loc12_ * _loc26_.z + _loc13_;
               if(_loc26_.cameraX < this.boundMinX)
               {
                  this.boundMinX = _loc26_.cameraX;
               }
               if(_loc26_.cameraX > this.boundMaxX)
               {
                  this.boundMaxX = _loc26_.cameraX;
               }
               if(_loc26_.cameraY < this.boundMinY)
               {
                  this.boundMinY = _loc26_.cameraY;
               }
               if(_loc26_.cameraY > this.boundMaxY)
               {
                  this.boundMaxY = _loc26_.cameraY;
               }
               if(_loc26_.cameraZ < this.boundMinZ)
               {
                  this.boundMinZ = _loc26_.cameraZ;
               }
               if(_loc26_.cameraZ > this.boundMaxZ)
               {
                  this.boundMaxZ = _loc26_.cameraZ;
               }
               _loc26_ = _loc26_.next;
            }
            this.cameraInside = false;
            if(this.minZ <= param1.nearClipping)
            {
               _loc27_ = this.light.ima * param1.gmd + this.light.imb * param1.gmh + this.light.imc * param1.gml + this.light.imd;
               if(_loc27_ - param1.nearClipping <= this.light.boundMaxX && _loc27_ + param1.nearClipping >= this.light.boundMinX)
               {
                  _loc27_ = this.light.ime * param1.gmd + this.light.imf * param1.gmh + this.light.img * param1.gml + this.light.imh;
                  if(_loc27_ - param1.nearClipping <= this.light.boundMaxY && _loc27_ + param1.nearClipping >= this.light.boundMinY)
                  {
                     _loc27_ = this.light.imi * param1.gmd + this.light.imj * param1.gmh + this.light.imk * param1.gml + this.light.iml;
                     if(_loc27_ - param1.nearClipping <= this.light.boundMaxZ && _loc27_ + param1.nearClipping >= this.light.boundMinZ)
                     {
                        this.cameraInside = true;
                     }
                  }
               }
            }
         }
         return _loc23_;
      }
      
      alternativa3d function renderCasters(param1:Camera3D) : void
      {
		 var _loc12_:Object3D = null;
         var _loc2_:Device = param1.device;
         var _loc3_:Number = 2 / this.planeSize;
         var _loc4_:Number = -2 / this.planeSize;
         var _loc5_:Number = 1 / (this.light.boundMaxZ - this.attenuation - (this.light.boundMinZ - this.offset));
         var _loc6_:Number = -(this.light.boundMinZ - this.offset) * _loc5_;
         var _loc7_:Number = (this.light.boundMinX + this.light.boundMaxX) * 0.5;
         var _loc8_:Number = (this.light.boundMinY + this.light.boundMaxY) * 0.5;
         var _loc9_:int = 0;
         while(_loc9_ < this.castersCount)
         {
			_loc12_ = this.casters[_loc9_];
               if(_loc12_ is Mesh)
               {
                    var jol:Mesh = Mesh(_loc12_);
					jol.prepareResources();
					casterConst[0] = jol.ma * _loc3_;
					casterConst[1] = jol.mb * _loc3_;
					casterConst[2] = jol.mc * _loc3_;
					casterConst[3] = (jol.md - _loc7_) * _loc3_;
					casterConst[4] = jol.me * _loc4_;
					casterConst[5] = jol.mf * _loc4_;
					casterConst[6] = jol.mg * _loc4_;
					casterConst[7] = (jol.mh - _loc8_) * _loc4_;
					casterConst[8] = jol.mi * _loc5_;
					casterConst[9] = jol.mj * _loc5_;
					casterConst[10] = jol.mk * _loc5_;
					casterConst[11] = jol.ml * _loc5_ + _loc6_;
					casterConst[12] = this.textureScaleU;
					casterConst[13] = this.textureScaleV;
					casterConst[16] = 2 * this.textureOffsetU - 1 + this.textureScaleU;
					casterConst[17] = -(2 * this.textureOffsetV - 1 + this.textureScaleV);
					_loc2_.setVertexBufferAt(0,jol.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
					_loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,casterConst,5,false);
					_loc2_.drawTriangles(jol.indexBuffer,0,jol.numTriangles);
               }
               if(_loc12_ is BSP)
               {
                  var g4:BSP = BSP(_loc12_);
					g4.prepareResources();
					casterConst[0] = g4.ma * _loc3_;
					casterConst[1] = g4.mb * _loc3_;
					casterConst[2] = g4.mc * _loc3_;
					casterConst[3] = (g4.md - _loc7_) * _loc3_;
					casterConst[4] = g4.me * _loc4_;
					casterConst[5] = g4.mf * _loc4_;
					casterConst[6] = g4.mg * _loc4_;
					casterConst[7] = (g4.mh - _loc8_) * _loc4_;
					casterConst[8] = g4.mi * _loc5_;
					casterConst[9] = g4.mj * _loc5_;
					casterConst[10] = g4.mk * _loc5_;
					casterConst[11] = g4.ml * _loc5_ + _loc6_;
					casterConst[12] = this.textureScaleU;
					casterConst[13] = this.textureScaleV;
					casterConst[16] = 2 * this.textureOffsetU - 1 + this.textureScaleU;
					casterConst[17] = -(2 * this.textureOffsetV - 1 + this.textureScaleV);
					_loc2_.setVertexBufferAt(0,g4.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
					_loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,casterConst,5,false);
					_loc2_.drawTriangles(g4.indexBuffer,0,g4.numTriangles);
			   }
			   _loc9_++;
		 }
         this.clampConst[0] = this.textureOffsetU;
         this.clampConst[1] = this.textureOffsetV;
         this.clampConst[2] = this.textureOffsetU + this.textureScaleU;
         this.clampConst[3] = this.textureOffsetV + this.textureScaleV;
      }
      
      alternativa3d function renderVolume(param1:Camera3D) : void
      {
         var _loc2_:Device = param1.device;
         volumeTransformConst[0] = this.light.ma;
         volumeTransformConst[1] = this.light.mb;
         volumeTransformConst[2] = this.light.mc;
         volumeTransformConst[3] = this.light.md;
         volumeTransformConst[4] = this.light.me;
         volumeTransformConst[5] = this.light.mf;
         volumeTransformConst[6] = this.light.mg;
         volumeTransformConst[7] = this.light.mh;
         volumeTransformConst[8] = this.light.mi;
         volumeTransformConst[9] = this.light.mj;
         volumeTransformConst[10] = this.light.mk;
         volumeTransformConst[11] = this.light.ml;
         volumeTransformConst[12] = this.light.boundMaxX - this.light.boundMinX;
         volumeTransformConst[13] = this.light.boundMaxY - this.light.boundMinY;
         volumeTransformConst[14] = this.light.boundMaxZ - this.light.boundMinZ;
         volumeTransformConst[15] = 1;
         volumeTransformConst[16] = this.light.boundMinX;
         volumeTransformConst[17] = this.light.boundMinY;
         volumeTransformConst[18] = this.light.boundMinZ;
         volumeTransformConst[19] = 1;
         _loc2_.setProgram(this.getVolumeProgram());
         _loc2_.setVertexBufferAt(0,volumeVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,volumeTransformConst,5,false);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,param1.projection,1);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,17,param1.correction,1);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,13,volumeFragmentConst,1);
         _loc2_.drawTriangles(volumeIndexBuffer,0,12);
      }
      
      alternativa3d function renderReceivers(param1:Camera3D) : void
      {
         var _loc21_:int = 0;
         var _loc2_:Device = param1.device;
         var _loc3_:Number = this.light.boundMinZ - this.offset;
         var _loc4_:Number = this.light.boundMaxZ - this.attenuation - _loc3_;
         var _loc5_:Number = this.light.ima / this.planeSize;
         var _loc6_:Number = this.light.imb / this.planeSize;
         var _loc7_:Number = this.light.imc / this.planeSize;
         var _loc8_:Number = (this.light.imd - this.planeX) / this.planeSize;
         var _loc9_:Number = this.light.ime / this.planeSize;
         var _loc10_:Number = this.light.imf / this.planeSize;
         var _loc11_:Number = this.light.img / this.planeSize;
         var _loc12_:Number = (this.light.imh - this.planeY) / this.planeSize;
         var _loc13_:Number = this.light.imi / _loc4_;
         var _loc14_:Number = this.light.imj / _loc4_;
         var _loc15_:Number = this.light.imk / _loc4_;
         var _loc16_:Number = (this.light.iml - _loc3_) / _loc4_;
         this.transformConst[0] = _loc5_ * param1.gma + _loc6_ * param1.gme + _loc7_ * param1.gmi;
         this.transformConst[1] = _loc5_ * param1.gmb + _loc6_ * param1.gmf + _loc7_ * param1.gmj;
         this.transformConst[2] = _loc5_ * param1.gmc + _loc6_ * param1.gmg + _loc7_ * param1.gmk;
         this.transformConst[3] = _loc5_ * param1.gmd + _loc6_ * param1.gmh + _loc7_ * param1.gml + _loc8_;
         this.transformConst[4] = _loc9_ * param1.gma + _loc10_ * param1.gme + _loc11_ * param1.gmi;
         this.transformConst[5] = _loc9_ * param1.gmb + _loc10_ * param1.gmf + _loc11_ * param1.gmj;
         this.transformConst[6] = _loc9_ * param1.gmc + _loc10_ * param1.gmg + _loc11_ * param1.gmk;
         this.transformConst[7] = _loc9_ * param1.gmd + _loc10_ * param1.gmh + _loc11_ * param1.gml + _loc12_;
         this.transformConst[8] = _loc13_ * param1.gma + _loc14_ * param1.gme + _loc15_ * param1.gmi;
         this.transformConst[9] = _loc13_ * param1.gmb + _loc14_ * param1.gmf + _loc15_ * param1.gmj;
         this.transformConst[10] = _loc13_ * param1.gmc + _loc14_ * param1.gmg + _loc15_ * param1.gmk;
         this.transformConst[11] = _loc13_ * param1.gmd + _loc14_ * param1.gmh + _loc15_ * param1.gml + _loc16_;
         this.uvConst[0] = this.textureScaleU;
         this.uvConst[1] = this.textureScaleV;
         this.uvConst[4] = this.textureOffsetU;
         this.uvConst[5] = this.textureOffsetV;
         var _loc17_:Number = this.nearDistance * param1.shadowsDistanceMultiplier;
         var _loc18_:Number = this.farDistance * param1.shadowsDistanceMultiplier;
         var _loc19_:Number = 1 - (this.minZ - _loc17_) / (_loc18_ - _loc17_);
         if(_loc19_ < 0)
         {
            _loc19_ = 0;
         }
         if(_loc19_ > 1)
         {
            _loc19_ = 1;
         }
         this.colorConst[0] = 0;
         this.colorConst[1] = 2048;
         this.colorConst[2] = 1;
         this.colorConst[3] = this.attenuation / _loc4_;
         this.colorConst[4] = 0;
         this.colorConst[5] = this.backFadeRange / _loc4_;
         this.colorConst[6] = this.offset / _loc4_;
         this.colorConst[7] = 1;
         this.colorConst[8] = (this.color >> 16 & 255) / 255;
         this.colorConst[9] = (this.color >> 8 & 255) / 255;
         this.colorConst[10] = (this.color & 255) / 255;
         this.colorConst[11] = this.alpha * 1 * param1.shadowsStrength;
         _loc2_.setProgram(this.getReceiverProgram(param1.view.quality,this.cameraInside,param1.view.correction));
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,param1.transform,3);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,14,param1.projection,1);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,15,this.transformConst,3);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,18,param1.correction,1);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,19,this.uvConst,2);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,13,this.colorConst,3);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,16,this.clampConst,1);
         var _loc20_:int = 0;
         while(_loc20_ < this.receiversCount)
         {
            _loc21_ = this.receiversBuffers[_loc20_];
            _loc2_.setVertexBufferAt(0,param1.receiversVertexBuffers[_loc21_],0,Context3DVertexBufferFormat.FLOAT_3);
            _loc2_.drawTriangles(param1.receiversIndexBuffers[_loc21_],this.receiversFirstIndexes[_loc20_],this.receiversNumsTriangles[_loc20_]);
            param1.numShadows++;
            _loc20_++;
         }
         this.receiversCount = 0;
      }
      
      private function getVolumeProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:FragmentShader = null;
         var _loc1_:ProgramResource = volumeProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new ShadowVolumeVertexShader().agalcode;
            _loc3_ = new FragmentShader();
            _loc3_.mov(FragmentShader.oc,FragmentShader.fc[13]);
            _loc1_ = new ProgramResource(_loc2_,_loc3_.agalcode);
            volumeProgram = _loc1_;
         }
         return _loc1_;
      }
	  
	  private function getProgram(param1:Boolean, param2:Boolean) : ProgramResource
      {
         var _loc5_:ByteArray = null;
         var _loc6_:ByteArray = null;
         var _loc3_:int = int(param1) | int(param2) << 1;
         var _loc4_:ProgramResource = this.programs[_loc3_];
         if(_loc4_ == null)
         {
            _loc5_ = new ShadowMapVertexShader(param1,param2).agalcode;
            _loc6_ = new ShadowMapFragmentShader(param1).agalcode;
            _loc4_ = new ProgramResource(_loc5_,_loc6_);
            this.programs[_loc3_] = _loc4_;
         }
         return _loc4_;
      }
      
      private function getReceiverProgram(param1:Boolean, param2:Boolean, param3:Boolean) : ProgramResource
      {
         var _loc6_:ByteArray = null;
         var _loc7_:ByteArray = null;
         var _loc4_:int = int(param1) | int(param2) << 1 | int(param3) << 2;
         var _loc5_:ProgramResource = receiverPrograms[_loc4_];
         if(_loc5_ == null)
         {
            _loc6_ = new ShadowReceiverVertexShader(param3).agalcode;
            _loc7_ = new ShadowReceiverFragmentShader(param1,param2).agalcode;
            _loc5_ = new ProgramResource(_loc6_,_loc7_);
            receiverPrograms[_loc4_] = _loc5_;
         }
         return _loc5_;
      }
      
      private function cullingInCamera(param1:Camera3D) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc2_:Vertex = this.boundVertexList;
         _loc2_.x = this.light.boundMinX;
         _loc2_.y = this.light.boundMinY;
         _loc2_.z = this.light.boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMaxX;
         _loc2_.y = this.light.boundMinY;
         _loc2_.z = this.light.boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMinX;
         _loc2_.y = this.light.boundMaxY;
         _loc2_.z = this.light.boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMaxX;
         _loc2_.y = this.light.boundMaxY;
         _loc2_.z = this.light.boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMinX;
         _loc2_.y = this.light.boundMinY;
         _loc2_.z = this.light.boundMaxZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMaxX;
         _loc2_.y = this.light.boundMinY;
         _loc2_.z = this.light.boundMaxZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMinX;
         _loc2_.y = this.light.boundMaxY;
         _loc2_.z = this.light.boundMaxZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = this.light.boundMaxX;
         _loc2_.y = this.light.boundMaxY;
         _loc2_.z = this.light.boundMaxZ;
         this.minZ = 1.0e22;
         _loc2_ = this.boundVertexList;
         while(_loc2_ != null)
         {
            _loc2_.cameraX = this.light.ma * _loc2_.x + this.light.mb * _loc2_.y + this.light.mc * _loc2_.z + this.light.md;
            _loc2_.cameraY = this.light.me * _loc2_.x + this.light.mf * _loc2_.y + this.light.mg * _loc2_.z + this.light.mh;
            _loc2_.cameraZ = this.light.mi * _loc2_.x + this.light.mj * _loc2_.y + this.light.mk * _loc2_.z + this.light.ml;
            if(_loc2_.cameraZ < this.minZ)
            {
               this.minZ = _loc2_.cameraZ;
            }
            _loc2_ = _loc2_.next;
         }
         var _loc5_:Number = param1.nearClipping;
         _loc2_ = this.boundVertexList;
         _loc3_ = false;
         _loc4_ = false;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraZ > _loc5_)
            {
               _loc3_ = true;
               if(_loc4_)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = true;
               if(_loc3_)
               {
                  break;
               }
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc4_ && !_loc3_)
         {
            return false;
         }
         var _loc6_:Number = param1.farClipping;
         _loc2_ = this.boundVertexList;
         _loc3_ = false;
         _loc4_ = false;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraZ < _loc6_)
            {
               _loc3_ = true;
               if(_loc4_)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = true;
               if(_loc3_)
               {
                  break;
               }
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc4_ && !_loc3_)
         {
            return false;
         }
         _loc2_ = this.boundVertexList;
         _loc3_ = false;
         _loc4_ = false;
         while(_loc2_ != null)
         {
            if(-_loc2_.cameraX < _loc2_.cameraZ)
            {
               _loc3_ = true;
               if(_loc4_)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = true;
               if(_loc3_)
               {
                  break;
               }
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc4_ && !_loc3_)
         {
            return false;
         }
         _loc2_ = this.boundVertexList;
         _loc3_ = false;
         _loc4_ = false;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraX < _loc2_.cameraZ)
            {
               _loc3_ = true;
               if(_loc4_)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = true;
               if(_loc3_)
               {
                  break;
               }
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc4_ && !_loc3_)
         {
            return false;
         }
         _loc2_ = this.boundVertexList;
         _loc3_ = false;
         _loc4_ = false;
         while(_loc2_ != null)
         {
            if(-_loc2_.cameraY < _loc2_.cameraZ)
            {
               _loc3_ = true;
               if(_loc4_)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = true;
               if(_loc3_)
               {
                  break;
               }
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc4_ && !_loc3_)
         {
            return false;
         }
         _loc2_ = this.boundVertexList;
         _loc3_ = false;
         _loc4_ = false;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraY < _loc2_.cameraZ)
            {
               _loc3_ = true;
               if(_loc4_)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = true;
               if(_loc3_)
               {
                  break;
               }
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc4_ && !_loc3_)
         {
            return false;
         }
         return true;
      }
   }
}
