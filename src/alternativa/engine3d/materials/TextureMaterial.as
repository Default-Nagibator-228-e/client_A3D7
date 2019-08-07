package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.gfx.core.BitmapTextureResource;
   import alternativa.gfx.core.CompressedTextureResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.display.BitmapData;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class TextureMaterial extends Material
   {
      
      protected static const skyFogConst:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      protected static const correctionConst:Vector.<Number> = Vector.<Number>([0,0,0,1,0,0,0,1]);
      
      protected static const uvCorrection:Vector.<Number> = Vector.<Number>([1,1,0,1]);
      
      protected static const fragmentConst:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      private static var programs:Array = new Array();
       
      
      protected var uvTransformConst:Vector.<Number>;
      
      public var diffuseMapURL:String;
      
      public var opacityMapURL:String;
      
      public var repeat:Boolean = false;
      
      public var smooth:Boolean = true;
      
      public var resolution:Number = 1;
      
      public var threshold:Number = 0.01;
      
      public var correctUV:Boolean = false;
      
      alternativa3d var _textureATF:ByteArray;
      
      alternativa3d var _textureATFAlpha:ByteArray;
      
      alternativa3d var _mipMapping:int = 0;
      
      alternativa3d var _hardwareMipMaps:Boolean = true;
      
      alternativa3d var textureResource:BitmapTextureResource;
      
      alternativa3d var textureATFResource:CompressedTextureResource;
      
      alternativa3d var textureATFAlphaResource:CompressedTextureResource;
      
      protected var bitmap:BitmapData;
      
      public function TextureMaterial(param1:BitmapData = null, param2:Boolean = false, param3:Boolean = true, param4:int = 0, param5:Number = 1)
      {
         this.uvTransformConst = Vector.<Number>([1,0,0,0,0,1,0,0]);
         super();
         this.repeat = param2;
         this.smooth = param3;
         this._mipMapping = param4;
         this.resolution = param5;
         if(param1 != null)
         {
            this.bitmap = param1;
            this.textureResource = TextureResourcesRegistry.getTextureResource(param1,this._mipMapping > 0,param2,this._hardwareMipMaps);
         }
      }
      
      public function get texture() : BitmapData
      {
         if(this.textureResource != null)
         {
            return this.textureResource.bitmapData;
         }
         return null;
      }
      
      public function set texture(param1:BitmapData) : void
      {
         var _loc2_:BitmapData = this.texture;
         if(param1 != _loc2_)
         {
            if(_loc2_ != null)
            {
               this.textureResource.dispose();
               this.textureResource = null;
            }
            if(param1 != null)
            {
               this.textureResource = TextureResourcesRegistry.getTextureResource(param1,this._mipMapping > 0,this.repeat,this._hardwareMipMaps);
            }
         }
      }
      
      public function get textureATF() : ByteArray
      {
         return this._textureATF;
      }
      
      public function set textureATF(param1:ByteArray) : void
      {
         if(param1 != this._textureATF)
         {
            if(this._textureATF != null)
            {
               this.textureATFResource.dispose();
               this.textureATFResource = null;
            }
            this._textureATF = param1;
            if(this._textureATF != null)
            {
               this.textureATFResource = new CompressedTextureResource(this._textureATF);
            }
         }
      }
      
      public function get textureATFAlpha() : ByteArray
      {
         return this._textureATFAlpha;
      }
      
      public function set textureATFAlpha(param1:ByteArray) : void
      {
         if(param1 != this._textureATFAlpha)
         {
            if(this._textureATFAlpha != null)
            {
               this.textureATFAlphaResource.dispose();
               this.textureATFAlphaResource = null;
            }
            this._textureATFAlpha = param1;
            if(this._textureATFAlpha != null)
            {
               this.textureATFAlphaResource = new CompressedTextureResource(this._textureATFAlpha);
            }
         }
      }
      
      public function get mipMapping() : int
      {
         return this._mipMapping;
      }
      
      public function set mipMapping(param1:int) : void
      {
         this._mipMapping = param1;
         if(this.bitmap != null)
         {
            this.textureResource = TextureResourcesRegistry.getTextureResource(this.bitmap,this._mipMapping > 0,this.repeat,this._hardwareMipMaps);
         }
      }
      
      public function disposeResource() : void
      {
         if(this.textureResource != null)
         {
            this.textureResource.dispose();
            this.textureResource = null;
         }
      }
      
      public function get hardwareMipMaps() : Boolean
      {
         return this._hardwareMipMaps;
      }
      
      public function set hardwareMipMaps(param1:Boolean) : void
      {
         if(param1 != this._hardwareMipMaps)
         {
            this._hardwareMipMaps = param1;
            if(this.texture != null)
            {
               this.textureResource.calculateMipMapsUsingGPU = this._hardwareMipMaps;
            }
         }
      }
      
      override public function clone() : Material
      {
         var _loc1_:TextureMaterial = new TextureMaterial(this.texture,this.repeat,this.smooth,this._mipMapping,this.resolution);
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Material) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:TextureMaterial = param1 as TextureMaterial;
         this.diffuseMapURL = _loc2_.diffuseMapURL;
         this.opacityMapURL = _loc2_.opacityMapURL;
         this.threshold = _loc2_.threshold;
         this.correctUV = _loc2_.correctUV;
         this.textureATF = _loc2_.textureATF;
         this.textureATFAlpha = _loc2_.textureATFAlpha;
         this.hardwareMipMaps = _loc2_.hardwareMipMaps;
      }
      
      override alternativa3d function get transparent() : Boolean
      {
         if(super.transparent)
         {
            return true;
         }
         if(this.texture != null)
         {
            return this.texture.transparent;
         }
         if(this._textureATF != null)
         {
            return this._textureATFAlpha != null;
         }
         return false;
      }
      
      override alternativa3d function drawOpaque(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D) : void
      {
         var _loc7_:BitmapData = this.texture;
         if(_loc7_ == null && this._textureATF == null)
         {
            return;
         }
         var _loc8_:Device = param1.device;
         var _loc9_:Boolean = param6 is Decal;
         var _loc10_:Boolean = !_loc9_ && zOffset;
         var _loc11_:Boolean = param6 is SkyBox && SkyBox(param6).autoSize;
         var _loc12_:Boolean = param1.fogAlpha > 0 && param1.fogStrength > 0;
         var _loc13_:Boolean = !param1.view.constrained && param1.ssao && param1.ssaoStrength > 0 && param6.useDepth && !_loc11_;
         var _loc14_:Boolean = !param1.view.constrained && param1.directionalLight != null && param1.directionalLightStrength > 0 && param6.useLight && !_loc11_;
         var _loc15_:Boolean = !param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && param6.useLight && param6.useShadowMap && !_loc11_;
         var _loc16_:Boolean = !param1.view.constrained && param1.deferredLighting && param1.deferredLightingStrength > 0 && param6.useDepth && param6.useLight && !_loc11_;
         var _loc17_:Boolean = alphaTestThreshold > 0 && this.transparent;
         _loc8_.setProgram(this.getProgram(!_loc9_ && !_loc17_,_loc11_,_loc9_ || _loc10_,false,param1.view.quality,this.repeat,this._mipMapping > 0,param6.concatenatedColorTransform != null,_loc9_ && param6.concatenatedAlpha < 1,_loc12_,false,_loc13_,_loc14_,_loc15_,_loc7_ == null,false,_loc16_,false,param1.view.correction,param6.concatenatedBlendMode != "normal",_loc17_,false));
         if(_loc7_ != null)
         {
            if(uploadEveryFrame && drawId != Camera3D.renderId)
            {
               _loc8_.uploadResource(this.textureResource);
               drawId = Camera3D.renderId;
            }
            _loc8_.setTextureAt(0,this.textureResource);
            uvCorrection[0] = this.textureResource.correctionU;
            uvCorrection[1] = this.textureResource.correctionV;
         }
         else
         {
            _loc8_.setTextureAt(0,this.textureATFResource);
            uvCorrection[0] = 1;
            uvCorrection[1] = 1;
         }
         if(_loc13_)
         {
            _loc8_.setTextureAt(1,param1.depthMap);
         }
         else
         {
            _loc8_.setTextureAt(1,null);
         }
         if(_loc15_)
         {
            _loc8_.setTextureAt(2,param1.shadowMap.map);
            _loc8_.setTextureAt(3,param1.shadowMap.noise);
         }
         else
         {
            _loc8_.setTextureAt(2,null);
            _loc8_.setTextureAt(3,null);
         }
		 //if(param1.joinsshad.map != null)
         //{
            //_loc8_.setTextureAt(2,param1.joinsshad.map);
         //}
         _loc8_.setTextureAt(4,null);
         _loc8_.setTextureAt(6,null);
         if(_loc16_)
         {
            _loc8_.setTextureAt(5,param1.lightMap);
         }
         else
         {
            _loc8_.setTextureAt(5,null);
         }
         _loc8_.setVertexBufferAt(0,param2,0,Context3DVertexBufferFormat.FLOAT_3);
         _loc8_.setVertexBufferAt(1,param2,3,Context3DVertexBufferFormat.FLOAT_2);
         if(_loc14_)
         {
            _loc8_.setVertexBufferAt(2,param2,5,Context3DVertexBufferFormat.FLOAT_3);
         }
         else
         {
            _loc8_.setVertexBufferAt(2,null);
         }
         _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,param6.transformConst,3,false);
         _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvCorrection,1);
         if(_loc9_)
         {
            correctionConst[0] = param6.md * param1.correctionX;
            correctionConst[1] = param6.mh * param1.correctionY;
            correctionConst[2] = param6.ml;
            correctionConst[3] = param1.correctionX;
            correctionConst[4] = param6.mc * param1.correctionX / Decal(param6).attenuation;
            correctionConst[5] = param6.mg * param1.correctionY / Decal(param6).attenuation;
            correctionConst[6] = param6.mk / Decal(param6).attenuation;
            correctionConst[7] = param1.correctionY;
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,2,false);
         }
         else if(_loc10_)
         {
            correctionConst[0] = 0;
            correctionConst[1] = 0;
            correctionConst[2] = 0;
            correctionConst[3] = param1.correctionX;
            correctionConst[4] = 0;
            correctionConst[5] = 0;
            correctionConst[6] = 0;
            correctionConst[7] = param1.correctionY;
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,2,false);
         }
         else if(_loc11_)
         {
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,SkyBox(param6).reduceConst,1);
            if(_loc12_)
            {
               skyFogConst[0] = param1.fogFragment[0] * param1.fogFragment[3];
               skyFogConst[1] = param1.fogFragment[1] * param1.fogFragment[3];
               skyFogConst[2] = param1.fogFragment[2] * param1.fogFragment[3];
               skyFogConst[3] = 1 - param1.fogFragment[3];
               _loc8_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,13,skyFogConst,1);
            }
         }
         if(param6.concatenatedColorTransform != null)
         {
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,param6.colorConst,2,false);
         }
         else if(_loc9_ && param6.concatenatedAlpha < 1)
         {
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,param6.colorConst,1);
         }
         if(_loc17_)
         {
            fragmentConst[3] = alphaTestThreshold;
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,14,fragmentConst,1,false);
         }
         _loc8_.drawTriangles(param3,param4,param5);
         param1.numDraws++;
         param1.numTriangles = param1.numTriangles + param5;
      }
      
      override alternativa3d function drawTransparent(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D, param7:Boolean = false) : void
      {
         var _loc8_:BitmapData = this.texture;
         if(_loc8_ == null && this._textureATF == null)
         {
            return;
         }
         var _loc9_:Device = param1.device;
         var _loc10_:Boolean = zOffset;
         var _loc11_:Boolean = param1.fogAlpha > 0 && param1.fogStrength > 0;
         var _loc12_:Boolean = param6 is Sprite3D;
         var _loc13_:Boolean = !param1.view.constrained && param1.softTransparency && param1.softTransparencyStrength > 0 && param6.softAttenuation > 0;
         var _loc14_:Boolean = !param1.view.constrained && param1.ssao && param1.ssaoStrength > 0 && param6.useDepth;
         var _loc15_:Boolean = !param1.view.constrained && param1.directionalLight != null && param1.directionalLightStrength > 0 && param6.useLight;
         var _loc16_:Boolean = !param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && param6.useLight && param6.useShadowMap;
         var _loc17_:Boolean = !param1.view.constrained && param1.deferredLighting && param1.deferredLightingStrength > 0;
         var _loc18_:Boolean = _loc17_ && param6.useDepth && param6.useLight && !_loc12_;
         var _loc19_:Boolean = _loc17_ && _loc12_ && param6.useLight;
         _loc9_.setProgram(this.getProgram(false,false,_loc10_,_loc12_,param1.view.quality,this.repeat,this._mipMapping > 0,param6.concatenatedColorTransform != null,param6.concatenatedAlpha < 1,_loc11_,_loc13_,_loc14_,_loc15_,_loc16_,_loc8_ == null,_loc8_ == null && this._textureATFAlpha != null,_loc18_,_loc19_,param1.view.correction,param6.concatenatedBlendMode != "normal",false,param7));
         if(_loc8_ != null)
         {
            if(uploadEveryFrame && drawId != Camera3D.renderId)
            {
               _loc9_.uploadResource(this.textureResource);
               drawId = Camera3D.renderId;
            }
            _loc9_.setTextureAt(0,this.textureResource);
            uvCorrection[0] = this.textureResource.correctionU;
            uvCorrection[1] = this.textureResource.correctionV;
         }
         else
         {
            _loc9_.setTextureAt(0,this.textureATFResource);
            if(this._textureATFAlpha != null)
            {
               _loc9_.setTextureAt(4,this.textureATFAlphaResource);
            }
            else
            {
               _loc9_.setTextureAt(4,null);
            }
            uvCorrection[0] = 1;
            uvCorrection[1] = 1;
         }
         if(_loc14_ || _loc13_)
         {
            _loc9_.setTextureAt(1,param1.depthMap);
         }
         else
         {
            _loc9_.setTextureAt(1,null);
         }
         if(_loc16_)
         {
            _loc9_.setTextureAt(2,param1.shadowMap.map);
            _loc9_.setTextureAt(3,param1.shadowMap.noise);
         }
         else
         {
            _loc9_.setTextureAt(2,null);
            _loc9_.setTextureAt(3,null);
         }
         _loc9_.setTextureAt(4,null);
         _loc9_.setTextureAt(6,null);
         if(_loc18_)
         {
            _loc9_.setTextureAt(5,param1.lightMap);
         }
         else
         {
            _loc9_.setTextureAt(5,null);
         }
         _loc9_.setVertexBufferAt(0,param2,0,Context3DVertexBufferFormat.FLOAT_1);
         _loc9_.setVertexBufferAt(1,null);
         _loc9_.setVertexBufferAt(2,null);
         if(!_loc12_)
         {
            _loc9_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,param6.transformConst,3,false);
         }
         _loc9_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvCorrection,1);
         if(_loc13_)
         {
            fragmentConst[2] = param6.softAttenuation;
            _loc9_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,14,fragmentConst,1);
         }
         if(_loc10_)
         {
            correctionConst[0] = 0;
            correctionConst[1] = 0;
            correctionConst[2] = 0;
            correctionConst[3] = param1.correctionX;
            correctionConst[4] = 0;
            correctionConst[5] = 0;
            correctionConst[6] = 0;
            correctionConst[7] = param1.correctionY;
            _loc9_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,2,false);
         }
         else if(_loc12_)
         {
            if(_loc15_)
            {
               correctionConst[0] = param1.correctionX;
               correctionConst[1] = param1.correctionY;
               correctionConst[2] = 1;
               correctionConst[3] = 0.5;
               _loc9_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,1,false);
            }
            if(_loc19_)
            {
               _loc9_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,13,Sprite3D(param6).lightConst,1,false);
            }
         }
         if(param6.concatenatedColorTransform != null)
         {
            _loc9_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,param6.colorConst,2,false);
         }
         else if(param6.concatenatedAlpha < 1)
         {
            _loc9_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,param6.colorConst,1);
         }
         _loc9_.drawTriangles(param3,param4,param5);
         param1.numDraws++;
         param1.numTriangles = param1.numTriangles + param5;
      }
      
      protected function getProgram(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:Boolean, param15:Boolean, param16:Boolean, param17:Boolean, param18:Boolean, param19:Boolean, param20:Boolean, param21:Boolean, param22:Boolean) : ProgramResource
      {
         var _loc25_:ByteArray = null;
         var _loc26_:ByteArray = null;
         var _loc23_:int = int(param1) | int(param2) << 1 | int(param3) << 2 | int(param4) << 3 | int(param5) << 4 | int(param6) << 5 | int(param7) << 6 | int(param8) << 7 | int(param9) << 8 | int(param10) << 9 | int(param11) << 10 | int(param12) << 11 | int(param13) << 12 | int(param14) << 13 | int(param15) << 14 | int(param16) << 15 | int(param17) << 16 | int(param18) << 17 | int(param19) << 18 | int(param20) << 19 | int(param21) << 20 | int(param22) << 21;
         var _loc24_:ProgramResource = programs[_loc23_];
         if(_loc24_ == null)
         {
            _loc25_ = new TextureMaterialVertexShader(!param22,param14 || param11 || param12 || param17,param13,param4,param14,param10,param2,param3,param3,param19).agalcode;
            _loc26_ = new TextureMaterialFragmentShader(param6,param5,param7,param15,param16,param21,!param1 && !param16 && !param15,param8,param9,param3,param13,param11,param12,param17,param18,param14,param10,param2,param20).agalcode;
            _loc24_ = new ProgramResource(_loc25_,_loc26_);
            programs[_loc23_] = _loc24_;
         }
         return _loc24_;
      }
      
      override public function dispose() : void
      {
         this.disposeResource();
      }
   }
}
