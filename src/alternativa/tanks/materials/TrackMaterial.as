package alternativa.tanks.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.materials.TextureMaterialFragmentShader;
   import alternativa.engine3d.materials.TextureResourcesRegistry;
   import alternativa.engine3d.materials.UVMatrixProvider;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.display.BitmapData;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class TrackMaterial extends TextureMaterial
   {
      
      private static var programs:Array = [];
      
      public static var name:String = "tracks";
       
      
      public var uvMatrixProvider:UVMatrixProvider;
      
      public function TrackMaterial(param1:BitmapData)
      {
         this.uvMatrixProvider = new UVMatrixProvider();
         super(param1,true);
      }
      
      public function update() : void
      {
         uvTransformConst = this.uvMatrixProvider.getValues();
      }
      
      override alternativa3d function get transparent() : Boolean
      {
         return false;
      }
      
      override alternativa3d function drawOpaque(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D) : void
      {
         var _loc7_:BitmapData = texture;
         if(_loc7_ == null)
         {
            return;
         }
         this.update();
         var _loc8_:Device = param1.device;
         var _loc9_:Boolean = param1.fogAlpha > 0 && param1.fogStrength > 0;
         var _loc10_:Boolean = !param1.view.constrained && param1.ssao && param1.ssaoStrength > 0 && param6.useDepth;
         var _loc11_:Boolean = !param1.view.constrained && param1.directionalLight != null && param1.directionalLightStrength > 0 && param6.useLight;
         var _loc12_:Boolean = !param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && param6.useLight && param6.useShadowMap;
         var _loc13_:Boolean = !param1.view.constrained && param1.deferredLighting && param1.deferredLightingStrength > 0 && param6.useDepth && param6.useLight;
         var _loc14_:Boolean = alphaTestThreshold > 0 && this.transparent;
         _loc8_.setProgram(this.getProgram(!_loc14_,false,false,false,param1.view.quality,repeat,_mipMapping > 0,param6.concatenatedColorTransform != null,false,_loc9_,false,_loc10_,_loc11_,_loc12_,_loc7_ == null,false,_loc13_,false,param1.view.correction,param6.concatenatedBlendMode != "normal",_loc14_,false));
         _loc8_.setTextureAt(0,textureResource);
         uvCorrection[0] = textureResource.correctionU;
         uvCorrection[1] = textureResource.correctionV;
         if(_loc10_)
         {
            _loc8_.setTextureAt(1,param1.depthMap);
         }
         else
         {
            _loc8_.setTextureAt(1,null);
         }
         if(_loc12_)
         {
            _loc8_.setTextureAt(2,param1.shadowMap.map);
            _loc8_.setTextureAt(3,param1.shadowMap.noise);
         }
         else
         {
            _loc8_.setTextureAt(2,null);
            _loc8_.setTextureAt(3,null);
         }
         _loc8_.setTextureAt(4,null);
         _loc8_.setTextureAt(6,null);
         if(_loc13_)
         {
            _loc8_.setTextureAt(5,param1.lightMap);
         }
         else
         {
            _loc8_.setTextureAt(5,null);
         }
         _loc8_.setVertexBufferAt(0,param2,0,Context3DVertexBufferFormat.FLOAT_3);
         _loc8_.setVertexBufferAt(1,param2,3,Context3DVertexBufferFormat.FLOAT_2);
         if(_loc11_)
         {
            _loc8_.setVertexBufferAt(2,param2,5,Context3DVertexBufferFormat.FLOAT_3);
         }
         else
         {
            _loc8_.setVertexBufferAt(2,null);
         }
         _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,param6.transformConst,3,false);
         _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvCorrection,1);
         _loc8_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,14,uvTransformConst,2);
         if(param6.concatenatedColorTransform != null)
         {
            _loc8_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,param6.colorConst,2,false);
         }
         if(_loc14_)
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
         var _loc8_:BitmapData = texture;
         if(_loc8_ == null)
         {
            return;
         }
         var _loc9_:Device = param1.device;
         var _loc10_:Boolean = param1.fogAlpha > 0 && param1.fogStrength > 0;
         var _loc11_:Boolean = !param1.view.constrained && param1.softTransparency && param1.softTransparencyStrength > 0 && param6.softAttenuation > 0;
         var _loc12_:Boolean = !param1.view.constrained && param1.ssao && param1.ssaoStrength > 0 && param6.useDepth;
         var _loc13_:Boolean = !param1.view.constrained && param1.directionalLight != null && param1.directionalLightStrength > 0 && param6.useLight;
         var _loc14_:Boolean = !param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && param6.useLight && param6.useShadowMap;
         var _loc15_:Boolean = !param1.view.constrained && param1.deferredLighting && param1.deferredLightingStrength > 0;
         var _loc16_:Boolean = _loc15_ && param6.useDepth && param6.useLight;
         _loc9_.setProgram(this.getProgram(false,false,false,false,param1.view.quality,repeat,_mipMapping > 0,param6.concatenatedColorTransform != null,param6.concatenatedAlpha < 1,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc8_ == null,_loc8_ == null && _textureATFAlpha != null,_loc16_,false,param1.view.correction,param6.concatenatedBlendMode != "normal",false,param7));
         _loc9_.setTextureAt(0,textureResource);
         uvCorrection[0] = textureResource.correctionU;
         uvCorrection[1] = textureResource.correctionV;
         if(_loc12_ || _loc11_)
         {
            _loc9_.setTextureAt(1,param1.depthMap);
         }
         else
         {
            _loc9_.setTextureAt(1,null);
         }
         if(_loc14_)
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
         if(_loc16_)
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
         _loc9_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,param6.transformConst,3,false);
         _loc9_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvCorrection,1);
         if(_loc11_)
         {
            fragmentConst[2] = param6.softAttenuation;
            _loc9_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,14,fragmentConst,1);
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
      
      override protected function getProgram(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:Boolean, param15:Boolean, param16:Boolean, param17:Boolean, param18:Boolean, param19:Boolean, param20:Boolean, param21:Boolean, param22:Boolean) : ProgramResource
      {
         var _loc25_:ByteArray = null;
         var _loc26_:ByteArray = null;
         var _loc23_:int = int(param1) | int(param2) << 1 | int(param3) << 2 | int(param4) << 3 | int(param5) << 4 | int(param6) << 5 | int(param7) << 6 | int(param8) << 7 | int(param9) << 8 | int(param10) << 9 | int(param11) << 10 | int(param12) << 11 | int(param13) << 12 | int(param14) << 13 | int(param15) << 14 | int(param16) << 15 | int(param17) << 16 | int(param18) << 17 | int(param19) << 18 | int(param20) << 19 | int(param21) << 20 | int(param22) << 21;
         var _loc24_:ProgramResource = programs[_loc23_];
         if(_loc24_ == null)
         {
            _loc25_ = new TrackMaterialVertexShader(!param22,param14 || param11 || param12 || param17,param13,param4,param14,param10,param2,param3,param3,param19).agalcode;
            _loc26_ = new TextureMaterialFragmentShader(param6,param5,param7,param15,param16,param21,!param1 && !param16 && !param15,param8,param9,param3,param13,param11,param12,param17,param18,param14,param10,param2,param20).agalcode;
            _loc24_ = new ProgramResource(_loc25_,_loc26_);
            programs[_loc23_] = _loc24_;
         }
         return _loc24_;
      }
      
      override public function set mipMapping(param1:int) : void
      {
         _mipMapping = param1;
         textureResource = TextureResourcesRegistry.getTextureResource(bitmap,true,repeat,_hardwareMipMaps);
      }
   }
}
