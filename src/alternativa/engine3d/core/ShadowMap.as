package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.gfx.core.BitmapTextureResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.RenderTargetTextureResource;
   import alternativa.gfx.core.TextureResource;
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
   import flash.display.BitmapData;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class ShadowMap
   {
      
      private static const sizeLimit:int = 2048;
      
      private static const bigValue:Number = 2048;
      
      public static const numSamples:int = 12;
      
      private var programs:Array = new Array();
      
      private var spriteVertexBuffer:VertexBufferResource = new VertexBufferResource(Vector.<Number>([0,2,4,6]),1);
      
      private var spriteIndexBuffer:IndexBufferResource = new IndexBufferResource(Vector.<uint>([0,1,3,1,2,3]));
      
      alternativa3d var transform:Vector.<Number> = Vector.<Number>([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]);
      
      alternativa3d var params:Vector.<Number> = Vector.<Number>([-255 * bigValue,-bigValue,bigValue,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1]);
      
      private var coords:Vector.<Number> = Vector.<Number>([0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1 / 255,1]);
      
      private var fragment:Vector.<Number> = Vector.<Number>([1 / 255,0,1,1]);
      
      private var alphaTestConst:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      private var scissor:Rectangle = new Rectangle();
      
      alternativa3d var map:RenderTargetTextureResource;
	  
	  alternativa3d var map1:RenderTargetTextureResource;
      
      alternativa3d var noise:BitmapTextureResource;
      
      public var noiseSize:int = 64;
      
      private var noiseAngle:Number = 1.0471975511965976;
      
      public var noiseRadius:Number = 3;
      
      private var noiseRandom:Number = 0.3;
      
      public var mapSize:int;
      
      public var nearDistance:Number;
      
      public var farDistance:Number;
      
      public var bias:Number = 0;
      
      public var biasMultiplier:Number = 30;
      
      public var additionalSpace:Number = 0;
      
      public var alphaThreshold:Number = 0.1;
      
      private var defaultLight:DirectionalLight = new DirectionalLight(8355711);
      
      private var boundVertexList:Vertex = Vertex.createList(8);
      
      private var light:DirectionalLight;
      
      private var dirZ:Number;
      
      private var planeX:Number;
      
      private var planeY:Number;
      
      private var planeSize:Number;
      
      private var pixel:Number;
	        
      alternativa3d var boundMinX:Number;
      
      alternativa3d var boundMinY:Number;
      
      alternativa3d var boundMinZ:Number;
      
      alternativa3d var boundMaxX:Number;
      
      alternativa3d var boundMaxY:Number;
      
      alternativa3d var boundMaxZ:Number;
	  
	  private var cam:Camera3D;
      
      public function ShadowMap(param1:int, param2:Number, param3:Number,param6:Camera3D, param4:Number = 0, param5:Number = 0)
      {
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
		 cam = param6;
         super();
         if(param1 > sizeLimit)
         {
            throw new Error("Value of mapSize too big.");
         }
         var _loc6_:Number = Math.log(param1) / Math.LN2;
         if(_loc6_ != int(_loc6_))
         {
            throw new Error("Value of mapSize must be power of 2.");
         }
         this.mapSize = param1;
         this.nearDistance = param2;
         this.farDistance = param3;
         this.bias = param4;
         this.additionalSpace = param5;
		 this.defaultLight.rotationX = Math.PI;
         this.map = new RenderTargetTextureResource(param1, param1);
		 this.map1 = new RenderTargetTextureResource(param1, param1);
         var _loc7_:Vector.<uint> = new Vector.<uint>();
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < 512)
         {
            _loc10_ = 0;
            while(_loc10_ < 512)
            {
               _loc11_ = Math.random() * this.noiseAngle;
               _loc12_ = Math.sin(_loc11_) * 255;
               _loc13_ = Math.cos(_loc11_) * 255;
               _loc14_ = (this.noiseRandom + Math.random() * (1 - this.noiseRandom)) * 255;
               //_loc7_[_loc8_] = _loc12_ << 16 | _loc13_ << 8 | _loc14_;
			   _loc7_[_loc8_] = _loc12_ << 16 | _loc14_;
               _loc8_++;
               _loc10_++;
            }
            _loc9_++;
         }
         this.noise = new BitmapTextureResource(new BitmapData(512,512,false,0),true);
         this.noise.bitmapData.setVector(this.noise.bitmapData.rect,_loc7_);
      }
      
      alternativa3d function calculateBounds() : void
      {
         if(cam.directionalLight != null)
         {
            this.light = cam.directionalLight;
         }
         else
         {
			 var x:Number = -1;
			 var z:Number = -3.5;//-0.5;
			 var matrix:Matrix3 = new Matrix3();
			 matrix.setRotationMatrix(x,0,z);
			 var toPos:Vector3 = new Vector3(0,1,0);
			 toPos.vTransformBy3(matrix);
			 this.defaultLight.lookAt(toPos.x,toPos.y,toPos.z);
            this.light = this.defaultLight;
         }
		 //this.light.rotationX = Math.PI;
         this.light.composeMatrix();
         this.dirZ = this.light.mk;
		 dirZ *= 1.5;
         this.light.calculateInverseMatrix();
         var _loc2_:Number = this.light.ima;
         var _loc3_:Number = this.light.imb;
         var _loc4_:Number = this.light.imc;
         var _loc5_:Number = this.light.imd;
         var _loc6_:Number = this.light.ime;
         var _loc7_:Number = this.light.imf;
         var _loc8_:Number = this.light.img;
         var _loc9_:Number = this.light.imh;
         var _loc10_:Number = this.light.imi;
         var _loc11_:Number = this.light.imj;
         var _loc12_:Number = this.light.imk;
         var _loc13_:Number = this.light.iml;
         this.light.ima = _loc2_ * cam.gma + _loc3_ * cam.gme + _loc4_ * cam.gmi;
         this.light.imb = _loc2_ * cam.gmb + _loc3_ * cam.gmf + _loc4_ * cam.gmj;
         this.light.imc = _loc2_ * cam.gmc + _loc3_ * cam.gmg + _loc4_ * cam.gmk;
         this.light.imd = _loc2_ * cam.gmd + _loc3_ * cam.gmh + _loc4_ * cam.gml + _loc5_;
         this.light.ime = _loc6_ * cam.gma + _loc7_ * cam.gme + _loc8_ * cam.gmi;
         this.light.imf = _loc6_ * cam.gmb + _loc7_ * cam.gmf + _loc8_ * cam.gmj;
         this.light.img = _loc6_ * cam.gmc + _loc7_ * cam.gmg + _loc8_ * cam.gmk;
         this.light.imh = _loc6_ * cam.gmd + _loc7_ * cam.gmh + _loc8_ * cam.gml + _loc9_;
         this.light.imi = _loc10_ * cam.gma + _loc11_ * cam.gme + _loc12_ * cam.gmi;
         this.light.imj = _loc10_ * cam.gmb + _loc11_ * cam.gmf + _loc12_ * cam.gmj;
         this.light.imk = _loc10_ * cam.gmc + _loc11_ * cam.gmg + _loc12_ * cam.gmk;
         this.light.iml = _loc10_ * cam.gmd + _loc11_ * cam.gmh + _loc12_ * cam.gml + _loc13_;
         var _loc14_:Vertex = this.boundVertexList;
		 
         _loc14_.x = -cam.nearClipping;
         _loc14_.y = -cam.nearClipping;
         _loc14_.z = cam.nearClipping;
         _loc14_ = _loc14_.next;
         _loc14_.x = -cam.nearClipping;
         _loc14_.y = cam.nearClipping;
         _loc14_.z = cam.nearClipping;
         _loc14_ = _loc14_.next;
         _loc14_.x = cam.nearClipping;
         _loc14_.y = cam.nearClipping;
         _loc14_.z = cam.nearClipping;
         _loc14_ = _loc14_.next;
         _loc14_.x = cam.nearClipping;
         _loc14_.y = -cam.nearClipping;
         _loc14_.z = cam.nearClipping;
         _loc14_ = _loc14_.next;
         _loc14_.x = -1000;
         _loc14_.y = -1000;
         _loc14_.z = 1000;
         _loc14_ = _loc14_.next;
         _loc14_.x = -1000;
         _loc14_.y = 1000;
         _loc14_.z = 1000;
         _loc14_ = _loc14_.next;
         _loc14_.x = 1000;
         _loc14_.y = 1000;
         _loc14_.z = 1000;
         _loc14_ = _loc14_.next;
         _loc14_.x = 1000;
         _loc14_.y = -1000;
         _loc14_.z = 1000;
		 
         this.light.boundMinX = 1.0e22;
         this.light.boundMinY = 1.0e22;
         this.light.boundMinZ = 1.0e22;
         this.light.boundMaxX = -1.0e22;
         this.light.boundMaxY = -1.0e22;
         this.light.boundMaxZ = -1.0e22;
         _loc14_ = this.boundVertexList;
         while(_loc14_ != null)
         {
            _loc14_.cameraX = this.light.ima * _loc14_.x + this.light.imb * _loc14_.y + this.light.imc * _loc14_.z + this.light.imd;
            _loc14_.cameraY = this.light.ime * _loc14_.x + this.light.imf * _loc14_.y + this.light.img * _loc14_.z + this.light.imh;
            _loc14_.cameraZ = this.light.imi * _loc14_.x + this.light.imj * _loc14_.y + this.light.imk * _loc14_.z + this.light.iml;
            if(_loc14_.cameraX < this.light.boundMinX)
            {
               this.light.boundMinX = _loc14_.cameraX;
            }
            if(_loc14_.cameraX > this.light.boundMaxX)
            {
               this.light.boundMaxX = _loc14_.cameraX;
            }
            if(_loc14_.cameraY < this.light.boundMinY)
            {
               this.light.boundMinY = _loc14_.cameraY;
            }
            if(_loc14_.cameraY > this.light.boundMaxY)
            {
               this.light.boundMaxY = _loc14_.cameraY;
            }
            if(_loc14_.cameraZ < this.light.boundMinZ)
            {
               this.light.boundMinZ = _loc14_.cameraZ;
            }
            if(_loc14_.cameraZ > this.light.boundMaxZ)
            {
               this.light.boundMaxZ = _loc14_.cameraZ;
            }
            _loc14_ = _loc14_.next;
         }
         //var _loc15_:Vertex = this.boundVertexList;
         //var _loc16_:Vertex = this.boundVertexList.next.next.next.next.next.next;
         //var _loc17_:Vertex = this.boundVertexList.next.next.next.next;
         //var _loc18_:Number = _loc16_.cameraX - _loc15_.cameraX;
         //var _loc19_:Number = _loc16_.cameraY - _loc15_.cameraY;
         //var _loc20_:Number = _loc16_.cameraZ - _loc15_.cameraZ;
         //var _loc21_:Number = _loc17_.cameraX - _loc16_.cameraX;
         //var _loc22_:Number = _loc17_.cameraY - _loc16_.cameraY;
         //var _loc23_:Number = _loc17_.cameraZ - _loc16_.cameraZ;
         //var _loc24_:Number = _loc18_ * _loc18_ + _loc19_ * _loc19_ + _loc20_ * _loc20_;
         //var _loc25_:Number = _loc21_ * _loc21_ + _loc22_ * _loc22_ + _loc23_ * _loc23_;
         var _loc26_:int = Math.ceil(this.noiseRadius);
         //this.planeSize = _loc24_ > _loc25_?Number(Number(Math.sqrt(_loc24_))):Number(Number(Math.sqrt(_loc25_)));
         this.pixel = 0.1;//this.planeSize / (this.mapSize - 1 - this.noiseRadius);
         this.planeSize = 30000;
         this.light.boundMinX = this.light.boundMinX - _loc26_ * this.pixel;
         this.light.boundMaxX = this.light.boundMaxX + _loc26_ * this.pixel;
         this.light.boundMinY = 0;//this.light.boundMinY - _loc26_ * this.pixel;
         this.light.boundMaxY = 10000;//this.light.boundMaxY + _loc26_ * this.pixel;
         this.light.boundMinZ = this.light.boundMinZ - this.additionalSpace;
         _loc14_ = this.boundVertexList;
         _loc14_.x = this.light.boundMinX;
         _loc14_.y = this.light.boundMinY;
         _loc14_.z = this.light.boundMinZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMaxX;
         _loc14_.y = this.light.boundMinY;
         _loc14_.z = this.light.boundMinZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMinX;
         _loc14_.y = this.light.boundMaxY;
         _loc14_.z = this.light.boundMinZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMaxX;
         _loc14_.y = this.light.boundMaxY;
         _loc14_.z = this.light.boundMinZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMinX;
         _loc14_.y = this.light.boundMinY;
         _loc14_.z = this.light.boundMaxZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMaxX;
         _loc14_.y = this.light.boundMinY;
         _loc14_.z = this.light.boundMaxZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMinX;
         _loc14_.y = this.light.boundMaxY;
         _loc14_.z = this.light.boundMaxZ;
         _loc14_ = _loc14_.next;
         _loc14_.x = this.light.boundMaxX;
         _loc14_.y = this.light.boundMaxY;
         _loc14_.z = this.light.boundMaxZ;
         this.boundMinX = 1.0e22;
         this.boundMinY = 1.0e22;
         this.boundMinZ = 1.0e22;
         this.boundMaxX = -1.0e22;
         this.boundMaxY = -1.0e22;
         this.boundMaxZ = -1.0e22;
         _loc14_ = this.boundVertexList;
         while(_loc14_ != null)
         {
            _loc14_.cameraX = this.light.ma * _loc14_.x + this.light.mb * _loc14_.y + this.light.mc * _loc14_.z + this.light.md;
            _loc14_.cameraY = this.light.me * _loc14_.x + this.light.mf * _loc14_.y + this.light.mg * _loc14_.z + this.light.mh;
            _loc14_.cameraZ = this.light.mi * _loc14_.x + this.light.mj * _loc14_.y + this.light.mk * _loc14_.z + this.light.ml;
            if(_loc14_.cameraX < this.boundMinX)
            {
               this.boundMinX = _loc14_.cameraX;
            }
            if(_loc14_.cameraX > this.boundMaxX)
            {
               this.boundMaxX = _loc14_.cameraX;
            }
            if(_loc14_.cameraY < this.boundMinY)
            {
               this.boundMinY = _loc14_.cameraY;
            }
            if(_loc14_.cameraY > this.boundMaxY)
            {
               this.boundMaxY = _loc14_.cameraY;
            }
            if(_loc14_.cameraZ < this.boundMinZ)
            {
               this.boundMinZ = _loc14_.cameraZ;
            }
            if(_loc14_.cameraZ > this.boundMaxZ)
            {
               this.boundMaxZ = _loc14_.cameraZ;
            }
			//FPSText.fps.text = _loc14_.cameraX + "	" + _loc14_.cameraY + "		" + _loc14_.cameraZ;
            _loc14_ = _loc14_.next;
         }
      }
      
      alternativa3d function render() : void
      {
         var _loc12_:Object3D = null;
         var _loc13_:VertexBufferResource = null;
         var _loc14_:IndexBufferResource = null;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:TextureMaterial = null;
         var _loc18_:Sprite3D = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Mesh = null;
         var _loc34_:BSP = null;
         var _loc4_:Device = cam.device;
         this.planeX = -10000;//-20356;//Math.floor(this.light.boundMinX / this.pixel) * this.pixel;
         this.planeY = -10000;//-20356;//Math.floor(this.light.boundMinY / this.pixel) * this.pixel;
		 //FPSText.fps.text = int(this.planeX) + "		" + int(this.planeY);
         this.scissor.width = 2048;//Math.ceil(this.light.boundMaxX / this.pixel) - this.planeX / this.pixel;
         this.scissor.height = 2048;//Math.ceil(this.light.boundMaxY / this.pixel) - this.planeY / this.pixel;
		 //FPSText.fps.text = this.scissor.width + "		" + this.scissor.height;
         var _loc5_:Number = 2 / this.planeSize;
         var _loc6_:Number = -2 / this.planeSize;
         var _loc7_:Number = 0.00020;//(255 / (this.light.boundMaxZ - this.light.boundMinZ));//0.0004175836831365092;//(255 / (this.light.boundMaxZ - this.light.boundMinZ))*2;//0.0043;
         var _loc8_:Number = -(this.planeX + this.planeSize * 0.5) * _loc5_;
         var _loc9_:Number = -(this.planeY + this.planeSize * 0.5) * _loc6_;//this.planeSize * 0.5) * _loc6_;
         var _loc10_:Number =  10;// ( -this.light.boundMinZ * _loc7_);
		 //FPSText.fps.text = _loc7_ + "	" + _loc10_;
         if(this.mapSize != this.map.width)
         {
            this.map.dispose();
            this.map = new RenderTargetTextureResource(this.mapSize, this.mapSize);
			//this.map1 = new RenderTargetTextureResource(this.mapSize,this.mapSize);
         }
         _loc4_.setRenderToTexture(this.map,true);
         _loc4_.clear();
		 //_loc4_ = di.device;
		 //_loc4_.setRenderToTexture(this.map,true);
		 //_loc4_._stage3D.context3D.clear(1);
         _loc4_.setScissorRectangle(this.scissor);
         this.transform[14] = 1 / 255;
         var _loc11_:int = 0;
         while(_loc11_ < cam.casterCount)
         {
            _loc12_ = cam.casterObjects[_loc11_];
            _loc13_ = null;
            _loc14_ = null;
            _loc16_ = false;
            if(_loc12_ is Sprite3D)
            {
               _loc18_ = Sprite3D(_loc12_);
               _loc17_ = TextureMaterial(_loc18_.material);
               _loc19_ = _loc18_.width;
               _loc20_ = _loc18_.height;
               if(_loc18_.autoSize)
               {
                  _loc31_ = _loc18_.bottomRightU - _loc18_.topLeftU;
                  _loc32_ = _loc18_.bottomRightV - _loc18_.topLeftV;
                  _loc19_ = _loc17_.texture.width * _loc31_;
                  _loc20_ = _loc17_.texture.height * _loc32_;
               }
               _loc21_ = Math.tan(Math.asin(-this.dirZ));
               _loc19_ = _loc19_ * _loc18_.scaleX;
               _loc20_ = _loc20_ * _loc18_.scaleY;
               _loc22_ = this.light.ima * _loc12_.md + this.light.imb * _loc12_.mh + this.light.imc * _loc12_.ml + this.light.imd;
               _loc23_ = this.light.ime * _loc12_.md + this.light.imf * _loc12_.mh + this.light.img * _loc12_.ml + this.light.imh;
               _loc24_ = this.light.imi * _loc12_.md + this.light.imj * _loc12_.mh + this.light.imk * _loc12_.ml + this.light.iml;
               _loc23_ = _loc23_ + Math.sin(-this.dirZ) * _loc20_ / 4;
               _loc24_ = _loc24_ - Math.cos(-this.dirZ) * _loc20_ / 4;
               _loc25_ = -_loc19_ * _loc18_.originX;
               _loc26_ = -_loc20_ * _loc18_.originY;
               _loc27_ = -_loc26_ / _loc21_;
               _loc28_ = _loc25_ + _loc19_;
               _loc29_ = _loc26_ + _loc20_;
               _loc30_ = -_loc29_ / _loc21_;
               _loc25_ = (_loc25_ + _loc22_) * _loc5_ + _loc8_;
               _loc26_ = (_loc26_ + _loc23_) * _loc6_ + _loc9_;
               _loc27_ = (_loc27_ + _loc24_) * _loc7_ + _loc10_;
               _loc28_ = (_loc28_ + _loc22_) * _loc5_ + _loc8_;
               _loc29_ = (_loc29_ + _loc23_) * _loc6_ + _loc9_;
               _loc30_ = (_loc30_ + _loc24_) * _loc7_ + _loc10_;
               _loc27_ = _loc27_ - this.bias * this.biasMultiplier * _loc7_ / _loc21_;//_loc27_ - this.bias * this.biasMultiplier * _loc7_ / _loc21_;
               _loc30_ = _loc30_ - this.bias * this.biasMultiplier * _loc7_ / _loc21_;//_loc30_ - this.bias * this.biasMultiplier * _loc7_ / _loc21_;
               this.coords[0] = _loc25_;
               this.coords[1] = _loc26_;
               this.coords[2] = _loc27_;
               this.coords[4] = 0;
               this.coords[5] = 0;
               this.coords[8] = _loc25_;
               this.coords[9] = _loc29_;
               this.coords[10] = _loc30_;
               this.coords[12] = 0;
               this.coords[13] = 1;
               this.coords[16] = _loc28_;
               this.coords[17] = _loc29_;
               this.coords[18] = _loc30_;
               this.coords[20] = 1;
               this.coords[21] = 1;
               this.coords[24] = _loc28_;
               this.coords[25] = _loc26_;
               this.coords[26] = _loc27_;
               this.coords[28] = 1;
               this.coords[29] = 0;
               _loc13_ = this.spriteVertexBuffer;
               _loc14_ = this.spriteIndexBuffer;
               _loc15_ = 2;
               _loc16_ = true;
               _loc4_.setProgram(this.getProgram(true,true));
               _loc4_.setVertexBufferAt(0,_loc13_,0,Context3DVertexBufferFormat.FLOAT_1);
               _loc4_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.coords,9,false);
            }
            else
            {
               this.transform[0] = (this.light.ima * _loc12_.ma + this.light.imb * _loc12_.me + this.light.imc * _loc12_.mi) * _loc5_;
               this.transform[1] = (this.light.ima * _loc12_.mb + this.light.imb * _loc12_.mf + this.light.imc * _loc12_.mj) * _loc5_;
               this.transform[2] = (this.light.ima * _loc12_.mc + this.light.imb * _loc12_.mg + this.light.imc * _loc12_.mk) * _loc5_;
               this.transform[3] = (this.light.ima * _loc12_.md + this.light.imb * _loc12_.mh + this.light.imc * _loc12_.ml + this.light.imd) * _loc5_ + _loc8_;
               this.transform[4] = (this.light.ime * _loc12_.ma + this.light.imf * _loc12_.me + this.light.img * _loc12_.mi) * _loc6_;
               this.transform[5] = (this.light.ime * _loc12_.mb + this.light.imf * _loc12_.mf + this.light.img * _loc12_.mj) * _loc6_;
               this.transform[6] = (this.light.ime * _loc12_.mc + this.light.imf * _loc12_.mg + this.light.img * _loc12_.mk) * _loc6_;
               this.transform[7] = (this.light.ime * _loc12_.md + this.light.imf * _loc12_.mh + this.light.img * _loc12_.ml + this.light.imh) * _loc6_ + _loc9_;
               this.transform[8] = (this.light.imi * _loc12_.ma + this.light.imj * _loc12_.me + this.light.imk * _loc12_.mi) * _loc7_;
               this.transform[9] = (this.light.imi * _loc12_.mb + this.light.imj * _loc12_.mf + this.light.imk * _loc12_.mj) * _loc7_;
               this.transform[10] = (this.light.imi * _loc12_.mc + this.light.imj * _loc12_.mg + this.light.imk * _loc12_.mk) * _loc7_;
               this.transform[11] = (this.light.imi * _loc12_.md + this.light.imj * _loc12_.mh + this.light.imk * _loc12_.ml + this.light.iml) * _loc7_ + 10;
               if(_loc12_ is Mesh)
               {
                  _loc33_ = Mesh(_loc12_);
                  _loc33_.prepareResources();
                  _loc13_ = _loc33_.vertexBuffer;
                  _loc14_ = _loc33_.indexBuffer;
                  _loc15_ = _loc33_.numTriangles;
                  _loc17_ = _loc33_.faceList.material as TextureMaterial;
               }
               else if(_loc12_ is BSP)
               {
                  _loc34_ = BSP(_loc12_);
                  _loc34_.prepareResources();
                  _loc13_ = _loc34_.vertexBuffer;
                  _loc14_ = _loc34_.indexBuffer;
                  _loc15_ = _loc34_.numTriangles;
                  _loc17_ = _loc34_.faces[0].material as TextureMaterial;
               }
               else
               {
                  _loc17_ = null;
               }
               if(_loc17_ != null && _loc17_.transparent)
               {
                  _loc16_ = true;
                  _loc4_.setProgram(this.getProgram(true,false));
                  _loc4_.setVertexBufferAt(1,_loc13_,3,Context3DVertexBufferFormat.FLOAT_2);
               }
               else
               {
                  _loc4_.setProgram(this.getProgram(false,false));
               }
               _loc4_.setVertexBufferAt(0,_loc13_,0,Context3DVertexBufferFormat.FLOAT_3);
               _loc4_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.transform,4,false);
            }
            if(_loc13_ != null && _loc14_ != null)
            {
               _loc4_.setTextureAt(4,null);
               _loc4_.setTextureAt(6,null);
               if(_loc16_)
               {
				  if (_loc17_ != null)
				  {
					_loc4_.setTextureAt(0,_loc17_.textureResource);
					this.alphaTestConst[0] = _loc17_.textureResource.correctionU;
					this.alphaTestConst[1] = _loc17_.textureResource.correctionV;
					this.alphaTestConst[3] = _loc12_ is Sprite3D?Number(Number(0.99)):Number(Number(this.alphaThreshold));
					_loc4_.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, this.alphaTestConst, 1);
				  }
               }
               _loc4_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.fragment,1);
               _loc4_.drawTriangles(_loc14_,0,_loc15_);
            }
            if(_loc16_)
            {
               _loc4_.setTextureAt(0,null);
               _loc4_.setVertexBufferAt(1,null);
            }
            _loc11_++;
         }
         _loc4_.setScissorRectangle(null);
         _loc5_ = 1 / this.planeSize;
         _loc6_ = 1 / this.planeSize;
         _loc8_ = -this.planeX * (_loc5_);
         _loc9_ = -this.planeY * (_loc6_);
         this.transform[0] = this.light.ima * _loc5_;
         this.transform[1] = this.light.imb * _loc5_;
         this.transform[2] = this.light.imc * _loc5_;//0.001;
         this.transform[3] = this.light.imd * _loc5_ + _loc8_;
         this.transform[4] = this.light.ime * _loc6_;
         this.transform[5] = this.light.imf * _loc6_;
         this.transform[6] = this.light.img * _loc6_;
         this.transform[7] = this.light.imh * _loc6_ + _loc9_;
         this.transform[8] = this.light.imi * _loc7_;
         this.transform[9] = this.light.imj * _loc7_;
         this.transform[10] = this.light.imk * _loc7_;
         this.transform[11] = this.light.iml * _loc7_ + _loc10_ - this.bias * this.biasMultiplier * _loc7_;//this.light.iml * _loc7_ + _loc10_ - this.bias * this.biasMultiplier * _loc7_;
         this.transform[12] = this.nearDistance;
         this.transform[13] = this.farDistance - this.nearDistance;
         this.transform[14] = -_loc7_;
         this.params[4] = 10000;
         this.params[5] = 0;
         this.params[6] = this.noiseRadius / this.mapSize;
         this.params[7] = 1 / numSamples;
         this.params[8] = cam.view._width / this.noiseSize;
         this.params[9] = cam.view._height / this.noiseSize;
         this.params[11] = cam.directionalLight != null?Number(Number(cam.directionalLightStrength * cam.shadowMapStrength)):Number(Number(0));
         this.params[12] = Math.cos(this.noiseAngle);
         this.params[13] = Math.sin(this.noiseAngle);
         this.params[16] = -Math.sin(this.noiseAngle);
         this.params[17] = Math.cos(this.noiseAngle);
		 //this.renderBlur(param1);
      }
      
      public function dispose() : void
      {
         this.map.reset();
         this.noise.reset();
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
   }
}
