package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.gfx.core.BitmapTextureResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.RenderTargetTextureResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.display.BitmapData;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DClearMask;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class DepthRenderer
   {
      
      private static const limit2const:int = 62;
      
      private static const limit5const:int = 24;
       
      
      private var depthPrograms:Array;
      
      private var correction:Vector.<Number>;
      
      private var depthFragment:Vector.<Number>;
      
      private var alphaTestConst:Vector.<Number>;
      
      private var ssaoProgram:ProgramResource;
      
      private var ssaoVertexBuffer:VertexBufferResource;
      
      private var ssaoIndexBuffer:IndexBufferResource;
      
      private var ssaoVertex:Vector.<Number>;
      
      private var ssaoFragment:Vector.<Number>;
      
      private var blurProgram:ProgramResource;
      
      private var blurFragment:Vector.<Number>;
      
      private var omniProgram:ProgramResource;
      
      private var spotProgram:ProgramResource;
      
      private var tubeProgram:ProgramResource;
      
      private var lightConst:Vector.<Number>;
      
      private var lightVertexBuffer:VertexBufferResource;
      
      private var lightIndexBuffer:IndexBufferResource;
      
      alternativa3d var depthBuffer:RenderTargetTextureResource;
      
      alternativa3d var lightBuffer:RenderTargetTextureResource;
      
      private var temporaryBuffer:RenderTargetTextureResource;
      
      private var scissor:Rectangle;
      
      private var table:BitmapTextureResource;
      
      private var noise:BitmapTextureResource;
      
      private var bias:Number = 0.2;
      
      private var tableSize:int = 1;
      
      private var noiseSize:int = 1;
      
      private var blurSamples:int = 16;
      
      private var intensity:Number = 2.5;
      
      private var noiseRandom:Number = 0.1;
      
      private var samples:int = 6;
      
      private var noiseAngle:Number;
      
      alternativa3d var correctionX:Number;
      
      alternativa3d var correctionY:Number;
      
      public function DepthRenderer()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         this.depthPrograms = new Array();
         this.correction = Vector.<Number>([0,0,0,1,0,0,0,1,0,0,0,0.5]);
         this.depthFragment = Vector.<Number>([1 / 255,0,0,1,0.5,0.5,0,1]);
         this.alphaTestConst = Vector.<Number>([0,0,0,1]);
         this.ssaoVertexBuffer = new VertexBufferResource(Vector.<Number>([-1,1,0,0,0,-1,-1,0,0,1,1,-1,0,1,1,1,1,0,1,0]),5);
         this.ssaoIndexBuffer = new IndexBufferResource(Vector.<uint>([0,1,3,2,3,1]));
         this.ssaoVertex = Vector.<Number>([0,0,0,1,0,0,0,1,1,1,0,1]);
         this.ssaoFragment = Vector.<Number>([0,0,0,Math.PI * 2,0,0,0,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,1,0,0,Math.PI * 2,Math.PI * 2]);
         this.blurFragment = Vector.<Number>([0,0,0,1,0,0,0,1]);
         this.lightConst = new Vector.<Number>();
         this.scissor = new Rectangle();
         this.noiseAngle = Math.PI * 2 / this.samples;
         super();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Number> = new Vector.<Number>();
         var _loc6_:Vector.<uint> = new Vector.<uint>();
         _loc1_ = 0;
         while(_loc1_ < limit2const)
         {
            _loc11_ = 4 + _loc1_ * 2;
            _loc12_ = 4 + _loc1_ * 5;
            _loc13_ = _loc1_ * 8;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc14_ = _loc13_ + 1;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc15_ = _loc14_ + 1;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc16_ = _loc15_ + 1;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc17_ = _loc16_ + 1;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc18_ = _loc17_ + 1;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc19_ = _loc18_ + 1;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc20_ = _loc19_ + 1;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = -1;
            _loc3_++;
            _loc5_[_loc3_] = 1;
            _loc3_++;
            _loc5_[_loc3_] = _loc11_;
            _loc3_++;
            _loc5_[_loc3_] = _loc12_;
            _loc3_++;
            _loc6_[_loc4_] = _loc13_;
            _loc4_++;
            _loc6_[_loc4_] = _loc17_;
            _loc4_++;
            _loc6_[_loc4_] = _loc14_;
            _loc4_++;
            _loc6_[_loc4_] = _loc14_;
            _loc4_++;
            _loc6_[_loc4_] = _loc17_;
            _loc4_++;
            _loc6_[_loc4_] = _loc18_;
            _loc4_++;
            _loc6_[_loc4_] = _loc14_;
            _loc4_++;
            _loc6_[_loc4_] = _loc18_;
            _loc4_++;
            _loc6_[_loc4_] = _loc19_;
            _loc4_++;
            _loc6_[_loc4_] = _loc14_;
            _loc4_++;
            _loc6_[_loc4_] = _loc19_;
            _loc4_++;
            _loc6_[_loc4_] = _loc15_;
            _loc4_++;
            _loc6_[_loc4_] = _loc17_;
            _loc4_++;
            _loc6_[_loc4_] = _loc19_;
            _loc4_++;
            _loc6_[_loc4_] = _loc18_;
            _loc4_++;
            _loc6_[_loc4_] = _loc17_;
            _loc4_++;
            _loc6_[_loc4_] = _loc20_;
            _loc4_++;
            _loc6_[_loc4_] = _loc19_;
            _loc4_++;
            _loc6_[_loc4_] = _loc15_;
            _loc4_++;
            _loc6_[_loc4_] = _loc19_;
            _loc4_++;
            _loc6_[_loc4_] = _loc20_;
            _loc4_++;
            _loc6_[_loc4_] = _loc15_;
            _loc4_++;
            _loc6_[_loc4_] = _loc20_;
            _loc4_++;
            _loc6_[_loc4_] = _loc16_;
            _loc4_++;
            _loc6_[_loc4_] = _loc13_;
            _loc4_++;
            _loc6_[_loc4_] = _loc16_;
            _loc4_++;
            _loc6_[_loc4_] = _loc20_;
            _loc4_++;
            _loc6_[_loc4_] = _loc13_;
            _loc4_++;
            _loc6_[_loc4_] = _loc20_;
            _loc4_++;
            _loc6_[_loc4_] = _loc17_;
            _loc4_++;
            _loc6_[_loc4_] = _loc13_;
            _loc4_++;
            _loc6_[_loc4_] = _loc14_;
            _loc4_++;
            _loc6_[_loc4_] = _loc15_;
            _loc4_++;
            _loc6_[_loc4_] = _loc13_;
            _loc4_++;
            _loc6_[_loc4_] = _loc15_;
            _loc4_++;
            _loc6_[_loc4_] = _loc16_;
            _loc4_++;
            _loc1_++;
         }
         this.lightVertexBuffer = new VertexBufferResource(_loc5_,5);
         this.lightIndexBuffer = new IndexBufferResource(_loc6_);
         var _loc7_:Vector.<uint> = new Vector.<uint>();
         var _loc8_:int = 0;
         var _loc9_:Number = Math.PI * 2;
         var _loc10_:int = this.tableSize - 1;
         _loc1_ = 0;
         while(_loc1_ < 256)
         {
            _loc21_ = (_loc1_ / _loc10_ - 0.5) * 2;
            _loc2_ = 0;
            while(_loc2_ < 256)
            {
               _loc22_ = (_loc2_ / _loc10_ - 0.5) * 2;
               _loc23_ = Math.atan2(_loc21_,_loc22_);
               if(_loc23_ < 0)
               {
                  _loc23_ = _loc23_ + _loc9_;
               }
               _loc7_[_loc8_] = Math.round(255 * _loc23_ / _loc9_);
               _loc8_++;
               _loc2_++;
            }
            _loc1_++;
         }
         this.table = new BitmapTextureResource(new BitmapData(256,256,false,0),true);
         this.table.bitmapData.setVector(this.table.bitmapData.rect,_loc7_);
         _loc7_ = new Vector.<uint>();
         _loc8_ = 0;
         _loc1_ = 0;
         while(_loc1_ < 256)
         {
            _loc2_ = 0;
            while(_loc2_ < 256)
            {
               _loc24_ = Math.random() * this.noiseAngle;
               _loc25_ = Math.sin(_loc24_) * 255;
               _loc26_ = Math.cos(_loc24_) * 255;
               _loc27_ = (this.noiseRandom + Math.random() * (1 - this.noiseRandom)) * 255;
               _loc7_[_loc8_] = _loc25_ << 16 | _loc26_ << 8 | _loc27_;
               _loc8_++;
               _loc2_++;
            }
            _loc1_++;
         }
         this.noise = new BitmapTextureResource(new BitmapData(256,256,false,0),true);
         this.noise.bitmapData.setVector(this.noise.bitmapData.rect,_loc7_);
         this.depthBuffer = new RenderTargetTextureResource(1,1);
         this.temporaryBuffer = new RenderTargetTextureResource(1,1);
         this.lightBuffer = new RenderTargetTextureResource(1,1);
      }
      
      alternativa3d function render(param1:Camera3D, param2:Number, param3:Number, param4:Number, param5:Boolean, param6:Boolean, param7:Number, param8:Vector.<Object3D>, param9:int) : void
      {
         var _loc10_:int = 0;
         var _loc14_:Object3D = null;
         var _loc15_:VertexBufferResource = null;
         var _loc16_:IndexBufferResource = null;
         var _loc17_:int = 0;
         var _loc18_:TextureMaterial = null;
         var _loc19_:Mesh = null;
         var _loc20_:BSP = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:OmniLight = null;
         var _loc24_:SpotLight = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:TubeLight = null;
         var _loc11_:Device = param1.device;
         if(param2 > 2048)
         {
            param2 = 2048;
         }
         if(param3 > 2048)
         {
            param3 = 2048;
         }
         if(param4 > 1)
         {
            param4 = 1;
         }
         param2 = Math.round(param2 * param4);
         param3 = Math.round(param3 * param4);
         if(param2 < 1)
         {
            param2 = 1;
         }
         if(param3 < 1)
         {
            param3 = 1;
         }
         this.scissor.width = param2;
         this.scissor.height = param3;
         var _loc12_:int = 1 << Math.ceil(Math.log(param2) / Math.LN2);
         var _loc13_:int = 1 << Math.ceil(Math.log(param3) / Math.LN2);
         if(_loc12_ != this.depthBuffer.width || _loc13_ != this.depthBuffer.height)
         {
            this.depthBuffer.dispose();
            this.depthBuffer = new RenderTargetTextureResource(_loc12_,_loc13_);
            this.temporaryBuffer.dispose();
            this.temporaryBuffer = new RenderTargetTextureResource(_loc12_,_loc13_);
            this.lightBuffer.dispose();
            this.lightBuffer = new RenderTargetTextureResource(_loc12_,_loc13_);
         }
         if(!param5)
         {
            this.noise.reset();
            this.temporaryBuffer.reset();
            this.ssaoVertexBuffer.reset();
            this.ssaoIndexBuffer.reset();
         }
         if(!param6)
         {
            this.lightBuffer.reset();
            this.lightVertexBuffer.reset();
            this.lightIndexBuffer.reset();
         }
         if(!param5 && !param6)
         {
            this.table.reset();
         }
         this.correctionX = param2 / this.depthBuffer.width;
         this.correctionY = param3 / this.depthBuffer.height;
         _loc11_.setRenderToTexture(this.depthBuffer, true);
		 _loc11_.clear(1, 0, 0.25, 1);
         _loc11_.setScissorRectangle(this.scissor);
         this.correction[0] = this.correctionX;
         this.correction[1] = this.correctionY;
         this.correction[2] = 255 / param1.farClipping;
         this.correction[4] = 1 - this.correctionX;
         this.correction[5] = 1 - this.correctionY;
         this.correction[8] = param1.correctionX;
         this.correction[9] = param1.correctionY;
         _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,3,param1.projection,1,false);
         _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this.correction,3,false);
         if(param5 || param6)
         {
            _loc11_.setTextureAt(0,this.table);
         }
         _loc10_ = 0;
         while(_loc10_ < param9)
         {
            _loc14_ = param8[_loc10_];
            if(_loc14_ is Mesh)
            {
               _loc19_ = Mesh(_loc14_);
               _loc15_ = _loc19_.vertexBuffer;
               _loc16_ = _loc19_.indexBuffer;
               _loc17_ = _loc19_.numTriangles;
               _loc18_ = _loc19_.faceList.material as TextureMaterial;
            }
            else if(_loc14_ is BSP)
            {
               _loc20_ = BSP(_loc14_);
               _loc15_ = _loc20_.vertexBuffer;
               _loc16_ = _loc20_.indexBuffer;
               _loc17_ = _loc20_.numTriangles;
               _loc18_ = _loc20_.faces[0].material as TextureMaterial;
            }
            if(_loc18_ != null && _loc18_.alphaTestThreshold > 0 && _loc18_.transparent)
            {
               _loc11_.setProgram(this.getDepthProgram(param5 || param6,true,param1.view.quality,_loc18_.repeat,_loc18_._mipMapping > 0,false,false));
               _loc11_.setVertexBufferAt(2,_loc15_,3,Context3DVertexBufferFormat.FLOAT_2);
               _loc11_.setTextureAt(1,_loc18_.textureResource);
               this.alphaTestConst[0] = _loc18_.textureResource.correctionU;
               this.alphaTestConst[1] = _loc18_.textureResource.correctionV;
               this.alphaTestConst[3] = _loc18_.alphaTestThreshold;
               _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,7,this.alphaTestConst,1);
            }
            else
            {
               _loc11_.setProgram(this.getDepthProgram(param5 || param6,false));
            }
            _loc11_.setVertexBufferAt(0,_loc15_,0,Context3DVertexBufferFormat.FLOAT_3);
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,_loc14_.transformConst,3,false);
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.depthFragment,2);
            if(param5 || param6)
            {
               _loc11_.setVertexBufferAt(1,_loc15_,5,Context3DVertexBufferFormat.FLOAT_3);
            }
            _loc11_.drawTriangles(_loc16_,0,_loc17_);
            _loc11_.setTextureAt(1,null);
            _loc11_.setVertexBufferAt(2,null);
            _loc10_++;
         }
         if(param6)
         {
            _loc11_.setRenderToTexture(this.lightBuffer, false);
            _loc11_.clear(param7,param7,param7,0);
            _loc11_.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE);
            _loc11_.setTextureAt(0,this.depthBuffer);
            _loc11_.setVertexBufferAt(0,this.lightVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            _loc11_.setVertexBufferAt(1,this.lightVertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,param1.projection,1,false);
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,1,this.correction,3,false);
            this.ssaoFragment[0] = param1.farClipping;
            this.ssaoFragment[1] = param1.farClipping / 255;
            this.ssaoFragment[4] = 2 / this.correctionX;
            this.ssaoFragment[5] = 2 / this.correctionY;
            this.ssaoFragment[6] = 0;
            this.ssaoFragment[8] = 1;
            this.ssaoFragment[9] = 1;
            this.ssaoFragment[10] = 0.5;
            this.ssaoFragment[12] = param1.correctionX;
            this.ssaoFragment[13] = param1.correctionY;
            this.ssaoFragment[16] = 0.5;
            this.ssaoFragment[17] = 0.5;
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.ssaoFragment,7,false);
            _loc11_.setProgram(this.getOmniProgram());
            _loc21_ = 0;
            _loc22_ = 0;
            _loc10_ = 0;
            while(_loc10_ < param1.omniesCount)
            {
               _loc23_ = param1.omnies[_loc10_];
               this.lightConst[_loc21_] = _loc23_.cmd * param1.correctionX;
               _loc21_++;
               this.lightConst[_loc21_] = _loc23_.cmh * param1.correctionY;
               _loc21_++;
               this.lightConst[_loc21_] = _loc23_.cml;
               _loc21_++;
               this.lightConst[_loc21_] = _loc23_.attenuationEnd;
               _loc21_++;
               this.lightConst[_loc21_] = _loc23_.intensity * param1.deferredLightingStrength * (_loc23_.color >> 16 & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc23_.intensity * param1.deferredLightingStrength * (_loc23_.color >> 8 & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc23_.intensity * param1.deferredLightingStrength * (_loc23_.color & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = 1 / (_loc23_.attenuationEnd - _loc23_.attenuationBegin);
               _loc21_++;
               _loc22_++;
               if(_loc22_ == limit2const || _loc10_ == param1.omniesCount - 1)
               {
                  _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this.lightConst,_loc22_ * 2,false);
                  _loc11_.drawTriangles(this.lightIndexBuffer,0,_loc22_ * 6 * 2);
                  _loc22_ = 0;
                  _loc21_ = 0;
               }
               _loc10_++;
            }
            _loc11_.setProgram(this.getSpotProgram());
            _loc21_ = 0;
            _loc22_ = 0;
            _loc10_ = 0;
            while(_loc10_ < param1.spotsCount)
            {
               _loc24_ = param1.spots[_loc10_];
               _loc25_ = Math.cos(_loc24_.hotspot * 0.5);
               _loc26_ = Math.cos(_loc24_.falloff * 0.5);
               this.lightConst[_loc21_] = _loc24_.cma;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmb;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmc;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmd;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cme;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmf;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmg;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmh;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmi;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmj;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cmk;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.cml;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.attenuationEnd;
               _loc21_++;
               this.lightConst[_loc21_] = 1 / (_loc24_.attenuationEnd - _loc24_.attenuationBegin);
               _loc21_++;
               this.lightConst[_loc21_] = _loc26_;
               _loc21_++;
               this.lightConst[_loc21_] = 1 / (_loc25_ - _loc26_);
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.intensity * param1.deferredLightingStrength * (_loc24_.color >> 16 & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.intensity * param1.deferredLightingStrength * (_loc24_.color >> 8 & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc24_.intensity * param1.deferredLightingStrength * (_loc24_.color & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = Math.sin(_loc24_.falloff * 0.5) * _loc24_.attenuationEnd;
               _loc21_++;
               _loc22_++;
               if(_loc22_ == limit5const || _loc10_ == param1.spotsCount - 1)
               {
                  _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this.lightConst,_loc22_ * 5,false);
                  _loc11_.drawTriangles(this.lightIndexBuffer,0,_loc22_ * 6 * 2);
                  _loc22_ = 0;
                  _loc21_ = 0;
               }
               _loc10_++;
            }
            _loc11_.setProgram(this.getTubeProgram());
            _loc21_ = 0;
            _loc22_ = 0;
            _loc10_ = 0;
            while(_loc10_ < param1.tubesCount)
            {
               _loc27_ = param1.tubes[_loc10_];
               this.lightConst[_loc21_] = _loc27_.cma;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmb;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmc;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmd;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cme;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmf;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmg;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmh;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmi;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmj;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cmk;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.cml;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.attenuationEnd;
               _loc21_++;
               this.lightConst[_loc21_] = 1 / (_loc27_.attenuationEnd - _loc27_.attenuationBegin);
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.length * 0.5 + _loc27_.falloff;
               _loc21_++;
               this.lightConst[_loc21_] = 1 / _loc27_.falloff;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.intensity * param1.deferredLightingStrength * (_loc27_.color >> 16 & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.intensity * param1.deferredLightingStrength * (_loc27_.color >> 8 & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.intensity * param1.deferredLightingStrength * (_loc27_.color & 255) / 255;
               _loc21_++;
               this.lightConst[_loc21_] = _loc27_.length * 0.5;
               _loc21_++;
               _loc22_++;
               if(_loc22_ == limit5const || _loc10_ == param1.tubesCount - 1)
               {
                  _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this.lightConst,_loc22_ * 5,false);
                  _loc11_.drawTriangles(this.lightIndexBuffer,0,_loc22_ * 6 * 2);
                  _loc22_ = 0;
                  _loc21_ = 0;
               }
               _loc10_++;
            }
            _loc11_.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         }
         if(param5)
         {
            _loc11_.setRenderToTexture(this.temporaryBuffer, false);
            _loc11_.clear(0,0,0,0);
            _loc11_.setProgram(this.getSSAOProgram());
            _loc11_.setTextureAt(0,this.depthBuffer);
            _loc11_.setTextureAt(1,this.noise);
            _loc11_.setVertexBufferAt(0,this.ssaoVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            _loc11_.setVertexBufferAt(1,this.ssaoVertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
            this.ssaoVertex[0] = _loc12_ / this.noiseSize;
            this.ssaoVertex[1] = _loc13_ / this.noiseSize;
            this.ssaoVertex[4] = 2 / this.correctionX;
            this.ssaoVertex[5] = 2 / this.correctionY;
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.ssaoVertex,3,false);
            this.ssaoFragment[0] = param1.farClipping;
            this.ssaoFragment[1] = param1.farClipping / 255;
            this.ssaoFragment[4] = 2 / this.correctionX;
            this.ssaoFragment[5] = 2 / this.correctionY;
            this.ssaoFragment[6] = param1.ssaoRadius;
            this.ssaoFragment[8] = 1;
            this.ssaoFragment[9] = 1;
            this.ssaoFragment[10] = this.bias;
            this.ssaoFragment[11] = 1 * 1 / this.samples;
            this.ssaoFragment[12] = param1.correctionX;
            this.ssaoFragment[13] = param1.correctionY;
            this.ssaoFragment[15] = 1 / param1.ssaoRange;
            this.ssaoFragment[16] = Math.cos(this.noiseAngle);
            this.ssaoFragment[17] = Math.sin(this.noiseAngle);
            this.ssaoFragment[20] = -Math.sin(this.noiseAngle);
            this.ssaoFragment[21] = Math.cos(this.noiseAngle);
            this.ssaoFragment[24] = this.correctionX - 1 / _loc12_;
            this.ssaoFragment[25] = this.correctionY - 1 / _loc13_;
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.ssaoFragment,7,false);
            _loc11_.drawTriangles(this.ssaoIndexBuffer,0,2);
            _loc11_.setTextureAt(1,null);
            _loc11_.setRenderToTexture(this.depthBuffer, false);
            _loc11_.clear(0,0,0,0);
            _loc11_.setProgram(this.getBlurProgram());
            _loc11_.setTextureAt(0,this.temporaryBuffer);
            this.blurFragment[0] = 1 / _loc12_;
            this.blurFragment[1] = 1 / _loc13_;
            this.blurFragment[3] = 1 / this.blurSamples;
            this.blurFragment[4] = this.correctionX - 1 / _loc12_;
            this.blurFragment[5] = this.correctionY - 1 / _loc13_;
            _loc11_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.blurFragment,2,false);
            _loc11_.drawTriangles(this.ssaoIndexBuffer,0,2);
         }
         _loc11_.setVertexBufferAt(1,null);
         _loc11_.setTextureAt(0,null);
         _loc11_.setScissorRectangle(null);
      }
      
      alternativa3d function resetResources() : void
      {
         this.noise.reset();
         this.table.reset();
         this.depthBuffer.reset();
         this.temporaryBuffer.reset();
         this.lightBuffer.reset();
         this.ssaoVertexBuffer.reset();
         this.ssaoIndexBuffer.reset();
         this.lightVertexBuffer.reset();
         this.lightIndexBuffer.reset();
      }
      
      private function getDepthProgram(param1:Boolean, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false) : ProgramResource
      {
         var _loc10_:ByteArray = null;
         var _loc11_:ByteArray = null;
         var _loc8_:int = int(param1) | int(param2) << 1 | int(param3) << 2 | int(param4) << 3 | int(param5) << 4 | int(param6) << 5 | int(param7) << 6;
         var _loc9_:ProgramResource = this.depthPrograms[_loc8_];
         if(_loc9_ == null)
         {
            _loc10_ = new DepthRendererDepthVertexShader(param1,param2).agalcode;
            _loc11_ = new DepthRendererDepthFragmentShader(param1,param2,param3,param4,param5).agalcode;
            _loc9_ = new ProgramResource(_loc10_,_loc11_);
            this.depthPrograms[_loc8_] = _loc9_;
         }
         return _loc9_;
      }
      
      private function getSSAOProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:ByteArray = null;
         var _loc1_:ProgramResource = this.ssaoProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new DepthRendererSSAOVertexShader().agalcode;
            _loc3_ = new DepthRendererSSAOFragmentShader(this.samples).agalcode;
            _loc1_ = new ProgramResource(_loc2_,_loc3_);
            this.ssaoProgram = _loc1_;
         }
         return _loc1_;
      }
      
      private function getBlurProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:ByteArray = null;
         var _loc1_:ProgramResource = this.blurProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new DepthRendererBlurVertexShader().agalcode;
            _loc3_ = new DepthRendererBlurFragmentShader().agalcode;
            _loc1_ = new ProgramResource(_loc2_,_loc3_);
            this.blurProgram = _loc1_;
         }
         return _loc1_;
      }
      
      private function getOmniProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:ByteArray = null;
         var _loc1_:ProgramResource = this.omniProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new DepthRendererLightVertexShader(0).agalcode;
            _loc3_ = new DepthRendererLightFragmentShader(0).agalcode;
            _loc1_ = new ProgramResource(_loc2_,_loc3_);
            this.omniProgram = _loc1_;
         }
         return _loc1_;
      }
      
      private function getSpotProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:ByteArray = null;
         var _loc1_:ProgramResource = this.spotProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new DepthRendererLightVertexShader(1).agalcode;
            _loc3_ = new DepthRendererLightFragmentShader(1).agalcode;
            _loc1_ = new ProgramResource(_loc2_,_loc3_);
            this.spotProgram = _loc1_;
         }
         return _loc1_;
      }
      
      private function getTubeProgram() : ProgramResource
      {
         var _loc2_:ByteArray = null;
         var _loc3_:ByteArray = null;
         var _loc1_:ProgramResource = this.tubeProgram;
         if(_loc1_ == null)
         {
            _loc2_ = new DepthRendererLightVertexShader(2).agalcode;
            _loc3_ = new DepthRendererLightFragmentShader(2).agalcode;
            _loc1_ = new ProgramResource(_loc2_,_loc3_);
            this.tubeProgram = _loc1_;
         }
         return _loc1_;
      }
   }
}
