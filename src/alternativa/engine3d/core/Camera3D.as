package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.shadow.ShadowEvent;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.TextureResource;
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DClearMask;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DStencilAction;
   import flash.display3D.Context3DTriangleFace;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import flash.utils.getTimer;
   
   use namespace alternativa3d;
   
   public class Camera3D extends Object3D
   {
      
      alternativa3d static var renderId:int = 0;
      
      private static const constantsAttributesCount:int = 8;
      
      private static const constantsOffset:int = 16;
      
      private static const constantsMaxTriangles:int = 18;
      
      private static const constants:Vector.<Number> = new Vector.<Number>(constantsMaxTriangles * 3 * constantsAttributesCount);
      
      private static const constantsVertexBuffer:VertexBufferResource = createConstantsVertexBuffer(constantsMaxTriangles * 3);
      
      private static const constantsIndexBuffer:IndexBufferResource = createConstantsIndexBuffer(constantsMaxTriangles * 3);
       
      
      public var view:View;
      
      public var fov:Number = 1.58;//1.5707963267948966;
      
      public var nearClipping:Number = 1;
      
      public var farClipping:Number = 1000000;
      
      public var onRender:Function;
      
      alternativa3d var viewSizeX:Number;
      
      alternativa3d var viewSizeY:Number;
      
      alternativa3d var focalLength:Number;
      
      alternativa3d var correctionX:Number;
      
      alternativa3d var correctionY:Number;
      
      alternativa3d var lights:Vector.<Light3D> = new Vector.<Light3D>();
      
      alternativa3d var lightsLength:int = 0;
      
      alternativa3d var occluders:Vector.<Vertex> = new Vector.<Vertex>();
      
      alternativa3d var numOccluders:int;
      
      alternativa3d var occludedAll:Boolean;
      
      alternativa3d var numDraws:int;
      
      alternativa3d var numShadows:int;
      
      alternativa3d var numTriangles:int;
      
      alternativa3d var device:Device;
      
      alternativa3d var projection:Vector.<Number> = new Vector.<Number>(4);
      
      alternativa3d var correction:Vector.<Number> = new Vector.<Number>(4);
      
      alternativa3d var transform:Vector.<Number> = new Vector.<Number>(12);
      
      private var opaqueMaterials:Vector.<Material> = new Vector.<Material>();
      
      private var opaqueVertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>();
      
      private var opaqueIndexBuffers:Vector.<IndexBufferResource>;
      
      private var opaqueFirstIndexes:Vector.<int>;
      
      private var opaqueNumsTriangles:Vector.<int>;
      
      private var opaqueObjects:Vector.<Object3D>;
      
      private var opaqueCount:int = 0;
      
      private var skyMaterials:Vector.<Material>;
      
      private var skyVertexBuffers:Vector.<VertexBufferResource>;
      
      private var skyIndexBuffers:Vector.<IndexBufferResource>;
      
      private var skyFirstIndexes:Vector.<int>;
      
      private var skyNumsTriangles:Vector.<int>;
      
      private var skyObjects:Vector.<Object3D>;
      
      private var skyCount:int = 0;
      
      private var transparentFaceLists:Vector.<Face>;
      
      private var transparentObjects:Vector.<Object3D>;
      
      private var transparentCount:int = 0;
      
      private var transparentOpaqueFaceLists:Vector.<Face>;
      
      private var transparentOpaqueObjects:Vector.<Object3D>;
      
      private var transparentOpaqueCount:int = 0;
      
      private var transparentBatchObjects:Vector.<Object3D>;
      
      private var decals:Vector.<Decal>;
      
      private var decalsCount:int = 0;
      
      alternativa3d var depthObjects:Vector.<Object3D>;
      
      alternativa3d var depthCount:int = 0;
      
      alternativa3d var casterObjects:Vector.<Object3D>;
      
      alternativa3d var casterCount:int = 0;
      
      alternativa3d var shadowAtlases:Array;
      
      alternativa3d var receiversVertexBuffers:Vector.<VertexBufferResource>;
      
      alternativa3d var receiversIndexBuffers:Vector.<IndexBufferResource>;
      
      alternativa3d var gma:Number;
      
      alternativa3d var gmb:Number;
      
      alternativa3d var gmc:Number;
      
      alternativa3d var gmd:Number;
      
      alternativa3d var gme:Number;
      
      alternativa3d var gmf:Number;
      
      alternativa3d var gmg:Number;
      
      alternativa3d var gmh:Number;
      
      alternativa3d var gmi:Number;
      
      alternativa3d var gmj:Number;
      
      alternativa3d var gmk:Number;
      
      alternativa3d var gml:Number;
      
      alternativa3d var fogParams:Vector.<Number>;
      
      alternativa3d var fogFragment:Vector.<Number>;
      
      private var fragmentConst:Vector.<Number>;
      
      private var shadows:Dictionary;
      
      private var shadowList:Vector.<Shadow>;
      
      private var depthRenderer:DepthRenderer;
      
      alternativa3d var depthMap:TextureResource;
      
      alternativa3d var lightMap:TextureResource;
      
      private var depthParams:Vector.<Number>;
      
      private var ssaoParams:Vector.<Number>;
      
      private var lightTransform:Vector.<Number>;
      
      private var lightParams:Vector.<Number>;
      
      alternativa3d var omnies:Vector.<OmniLight>;
      
      alternativa3d var omniesCount:int = 0;
      
      alternativa3d var spots:Vector.<SpotLight>;
      
      alternativa3d var spotsCount:int = 0;
      
      alternativa3d var tubes:Vector.<TubeLight>;
      
      alternativa3d var tubesCount:int = 0;
      
      public var fogNear:Number = 0;
      
      public var fogFar:Number = 1000000;
      
      public var fogAlpha:Number = 0;
      
      public var fogColor:int = 8355711;
      
      public var softTransparency:Boolean = false;
      
      public var depthBufferScale:Number = 1;
      
      public var ssao:Boolean = false;
      
      public var ssaoRadius:Number = 100;
      
      public var ssaoRange:Number = 10;
      
      public var ssaoColor:int = 0;
      
      public var ssaoAlpha:Number = 1.5;
      
      public var directionalLight:DirectionalLight;
      
      public var shadowMap:ShadowMap;
      
      public var ambientColor:int = 0;
      
      public var deferredLighting:Boolean = false;
      
      public var fogStrength:Number = 1;
      
      public var softTransparencyStrength:Number = 1;
      
      public var ssaoStrength:Number = 1;
      
      public var directionalLightStrength:Number = 1;
      
      public var _shadowMapStrength:Number = 1;
      
      public var shadowsStrength:Number = 1;
      
      public var shadowsDistanceMultiplier:Number = 1;
      
      public var deferredLightingStrength:Number = 1;
      
      public var debug:Boolean = false;
      
      private var debugSet:Object;
      
      private var _diagram:Sprite;
      
      public var fpsUpdatePeriod:int = 10;
      
      public var timerUpdatePeriod:int = 10;
      
      private var fpsTextField:TextField;
      
      private var memoryTextField:TextField;
      
      private var drawsTextField:TextField;
      
      private var shadowsTextField:TextField;
      
      private var trianglesTextField:TextField;
      
      private var timerTextField:TextField;
      
      private var graph:Bitmap;
      
      private var rect:Rectangle;
      
      private var _diagramAlign:String = "TR";
      
      private var _diagramHorizontalMargin:Number = 2;
      
      private var _diagramVerticalMargin:Number = 2;
      
      private var fpsUpdateCounter:int;
      
      private var previousFrameTime:int;
      
      private var previousPeriodTime:int;
      
      private var maxMemory:int;
      
      private var timerUpdateCounter:int;
      
      private var timeSum:int;
      
      private var timeCount:int;
      
      private var timer:int;
      
      private var firstVertex:Vertex;
      
      private var firstFace:Face;
      
      private var firstWrapper:Wrapper;
      
      alternativa3d var lastWrapper:Wrapper;
      
      alternativa3d var lastVertex:Vertex;
      
      alternativa3d var lastFace:Face;
	  
	  private var joi:int = 0;
	  
	  public var joinsshad:ShadowEvent;
      
      public function Camera3D()
      {
		 this.opaqueIndexBuffers = new Vector.<IndexBufferResource>();
         this.opaqueFirstIndexes = new Vector.<int>();
         this.opaqueNumsTriangles = new Vector.<int>();
         this.opaqueObjects = new Vector.<Object3D>();
         this.skyMaterials = new Vector.<Material>();
         this.skyVertexBuffers = new Vector.<VertexBufferResource>();
         this.skyIndexBuffers = new Vector.<IndexBufferResource>();
         this.skyFirstIndexes = new Vector.<int>();
         this.skyNumsTriangles = new Vector.<int>();
         this.skyObjects = new Vector.<Object3D>();
         this.transparentFaceLists = new Vector.<Face>();
         this.transparentObjects = new Vector.<Object3D>();
         this.transparentOpaqueFaceLists = new Vector.<Face>();
         this.transparentOpaqueObjects = new Vector.<Object3D>();
         this.transparentBatchObjects = new Vector.<Object3D>();
         this.decals = new Vector.<Decal>();
         this.depthObjects = new Vector.<Object3D>();
         this.casterObjects = new Vector.<Object3D>();
         this.shadowAtlases = new Array();
         this.fogParams = Vector.<Number>([1, 1, 0, 1]);
         this.fogFragment = Vector.<Number>([0, 0, 0, 1]);
         this.fragmentConst = Vector.<Number>([0, 0, 0, 1, 0.5, 0.5, 0, 1 / 4096]);
         this.shadows = new Dictionary();
         this.shadowList = new Vector.<Shadow>();
         this.depthRenderer = new DepthRenderer();
         this.depthParams = Vector.<Number>([0, 0, 0, 1]);
         this.ssaoParams = Vector.<Number>([0, 0, 0, 1]);
         this.lightTransform = Vector.<Number>([0, 0, 0, 1]);
         this.lightParams = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 1]);
         this.omnies = new Vector.<OmniLight>();
         this.spots = new Vector.<SpotLight>();
         this.tubes = new Vector.<TubeLight>();
         this.debugSet = new Object();
         this._diagram = this.createDiagram();
         this.firstVertex = new Vertex();
         this.firstFace = new Face();
         this.firstWrapper = new Wrapper();
         this.lastWrapper = this.firstWrapper;
         this.lastVertex = this.firstVertex;
         this.lastFace = this.firstFace;
         super();
	  }
      
      private static function createConstantsVertexBuffer(param1:int) : VertexBufferResource
      {
         var _loc5_:int = 0;
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_.push((_loc3_ << 1) + constantsOffset);
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1 << 1)
         {
            _loc5_ = _loc4_ * 4 + 3;
            constants[_loc5_] = 1;
            _loc4_++;
         }
         return new VertexBufferResource(_loc2_,1);
      }
      
      private static function createConstantsIndexBuffer(param1:int) : IndexBufferResource
      {
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_.push(_loc3_);
            _loc3_++;
         }
         return new IndexBufferResource(_loc2_);
      }
      
      public function set shadowMapStrength(v:Number) : void
      {
         this._shadowMapStrength = v;
      }
      
      public function get shadowMapStrength() : Number
      {
         return this._shadowMapStrength;
      }
      
      public function addShadow(param1:Shadow) : void
      {
         this.shadows[param1] = true;
      }
      
      public function removeShadow(param1:Shadow) : void
      {
         delete this.shadows[param1];
      }
      
      public function removeAllShadows() : void
      {
         this.shadows = new Dictionary();
      }
      
      public function render() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:Object3D = null;
         var _loc6_:Light3D = null;
         var _loc7_:ShadowAtlas = null;
         var _loc8_:Boolean = false;
         var _loc9_:Material = null;
         var _loc10_:* = undefined;
         var _loc11_:Decal = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:TextureResource = null;
         var _loc16_:Face = null;
         var _loc17_:Object3D = null;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:int = 0;
         var _loc21_:Sprite3D = null;
         var _loc22_:Face = null;
         var _loc23_:Face = null;
         var _loc24_:Object3D = null;
         var _loc25_:Sprite3D = null;
         this.numDraws = 0;
         this.numShadows = 0;
         this.numTriangles = 0;
         if(this.view != null && this.view.device != null && this.view.device.ready)
         {
            renderId++;
            this.device = this.view.device;
            this.view.configure();
            if(this.nearClipping < 1)
            {
               this.nearClipping = 1;
            }
            if(this.farClipping > 1000000)
            {
               this.farClipping = 1000000;
            }
            this.viewSizeX = this.view._width * 0.5;
            this.viewSizeY = this.view._height * 0.5;
            this.focalLength = Math.sqrt(this.viewSizeX * this.viewSizeX + this.viewSizeY * this.viewSizeY) / Math.tan(this.fov * 0.5);
            this.correctionX = this.viewSizeX / this.focalLength;
            this.correctionY = this.viewSizeY / this.focalLength;
            this.projection[0] = 1 << this.view.zBufferPrecision;
            this.projection[1] = 1;
            this.projection[2] = this.farClipping / (this.farClipping - this.nearClipping);
            this.projection[3] = this.nearClipping * this.farClipping / (this.nearClipping - this.farClipping);
            this.composeCameraMatrix();
            _loc5_ = this;
            while(_loc5_._parent != null)
            {
               _loc5_ = _loc5_._parent;
               _loc5_.composeMatrix();
               appendMatrix(_loc5_);
            }
            this.gma = ma;
            this.gmb = mb;
            this.gmc = mc;
            this.gmd = md;
            this.gme = me;
            this.gmf = mf;
            this.gmg = mg;
            this.gmh = mh;
            this.gmi = mi;
            this.gmj = mj;
            this.gmk = mk;
            this.gml = ml;
            invertMatrix();
            this.transform[0] = ma;
            this.transform[1] = mb;
            this.transform[2] = mc;
            this.transform[3] = md;
            this.transform[4] = me;
            this.transform[5] = mf;
            this.transform[6] = mg;
            this.transform[7] = mh;
            this.transform[8] = mi;
            this.transform[9] = mj;
            this.transform[10] = mk;
            this.transform[11] = ml;
            this.numOccluders = 0;
            this.occludedAll = false;
            if(_loc5_ != this && _loc5_.visible)
            {
               this.lightsLength = 0;
               _loc6_ = (_loc5_ as Object3DContainer).lightList;
               while(_loc6_ != null)
               {
                  if(_loc6_.visible)
                  {
                     _loc6_.calculateCameraMatrix(this);
                     if(_loc6_.checkFrustumCulling(this))
                     {
                        this.lights[this.lightsLength] = _loc6_;
                        this.lightsLength++;
                        if(!this.view.constrained && this.deferredLighting && this.deferredLightingStrength > 0)
                        {
                           if(_loc6_ is OmniLight)
                           {
                              this.omnies[this.omniesCount] = _loc6_ as OmniLight;
                              this.omniesCount++;
                           }
                           else if(_loc6_ is SpotLight)
                           {
                              this.spots[this.spotsCount] = _loc6_ as SpotLight;
                              this.spotsCount++;
                           }
                           else if(_loc6_ is TubeLight)
                           {
                              this.tubes[this.tubesCount] = _loc6_ as TubeLight;
                              this.tubesCount++;
                           }
                        }
                     }
                  }
                  _loc6_ = _loc6_.nextLight;
               }
               _loc5_.appendMatrix(this);
               _loc5_.cullingInCamera(this,63);
               if(this.debug)
               {
                  _loc1_ = 0;
                  while(_loc1_ < this.lightsLength)
                  {
                     (this.lights[_loc1_] as Light3D).drawDebug(this);
                     _loc1_++;
                  }
               }
               _loc8_ = false;
			   //joi = 0;
               if(!this.view.constrained && this.shadowsStrength > 0)
               {
                  for(_loc4_ in this.shadows)
                  {
                     if(_loc4_.checkVisibility(this))
                     {
                        _loc2_ = _loc4_.mapSize + _loc4_.blur;
                        _loc7_ = this.shadowAtlases[_loc2_];
                        if(_loc7_ == null)
                        {
                           _loc7_ = new ShadowAtlas(_loc4_.mapSize,_loc4_.blur);
                           this.shadowAtlases[_loc2_] = _loc7_;
                        }
                        _loc7_.shadows[_loc7_.shadowsCount] = _loc4_;
                        _loc7_.shadowsCount++;
                        _loc8_ = true;
						//joi++;
                     }
                  }
               }
			   //FPSText.fps.text = joi + "";
               this.device.setCulling(Context3DTriangleFace.FRONT);
               this.device.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
               this.device.setStencilActions(Context3DTriangleFace.NONE);
               this.device.setStencilReferenceValue(0);
               if(_loc8_)
               {
                  this.device.setCulling(Context3DTriangleFace.BACK);
                  this.device.setDepthTest(true,Context3DCompareMode.GREATER_EQUAL);
                  this.device.setProgram(Shadow.getCasterProgram());
                  for each(_loc7_ in this.shadowAtlases)
                  {
                     if(_loc7_.shadowsCount > 0)
                     {
                        _loc7_.renderCasters(this);
                     }
                  }
                  this.device.setCulling(Context3DTriangleFace.FRONT);
                  this.device.setDepthTest(false,Context3DCompareMode.ALWAYS);
                  for each(_loc7_ in this.shadowAtlases)
                  {
                     if(_loc7_.shadowsCount > 0)
                     {
                        _loc7_.renderBlur(this);
                     }
                  }
                  this.device.setTextureAt(0,null);
                  this.device.setVertexBufferAt(1,null);
               }
               if(this.directionalLight != null)
               {
                  this.directionalLight.composeAndAppend(this);
                  this.directionalLight.calculateInverseMatrix();
               }
               _loc5_.concatenatedAlpha = 1;//_loc5_.alpha;
               _loc5_.concatenatedBlendMode = _loc5_.blendMode;
               _loc5_.concatenatedColorTransform = _loc5_.colorTransform;
               _loc5_.draw(this);
               this.device.setDepthTest(true, Context3DCompareMode.LESS);
			   //this.joinsshad.render(this);
               if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.shadowMap.calculateBounds();
                  this.shadowMap.render();
               }
               this.depthMap = null;
               this.lightMap = null;
               if(!this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0 || this.deferredLighting && this.deferredLightingStrength > 0))
               {
                  this.depthRenderer.render(this,this.view._width,this.view._height,this.depthBufferScale,this.ssao && this.ssaoStrength > 0,this.deferredLighting && this.deferredLightingStrength > 0,this.directionalLight != null && this.directionalLightStrength > 0 || this.shadowMap != null && this.shadowMapStrength > 0?Number(Number(0)):Number(Number(0.5)),this.depthObjects,this.depthCount);
                  if(this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0)
                  {
                     this.depthMap = this.depthRenderer.depthBuffer;
                  }
                  if(this.deferredLighting && this.deferredLightingStrength > 0)
                  {
                     this.lightMap = this.depthRenderer.lightBuffer;
                  }
               }
               else
               {
                  this.depthRenderer.resetResources();
               }
               if(_loc8_ || !this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0 || this.deferredLighting && this.deferredLightingStrength > 0) || !this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.device.setRenderToBackBuffer();
               }
               this.view.clearArea();
               this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,3,this.projection,1);
               this.fragmentConst[0] = this.farClipping;
               this.fragmentConst[1] = this.farClipping / 255;
               this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,17,this.fragmentConst,2);
               this.correction[0] = this.view.rect.width / this.device.width;
               this.correction[1] = this.view.rect.height / this.device.height;
               this.correction[2] = (this.view.rect.x * 2 + this.view.rect.width - this.device.width) / this.device.width;
               this.correction[3] = (this.view.rect.y * 2 + this.view.rect.height - this.device.height) / this.device.height;
               this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13,this.correction,1);
               if(!this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0 || this.deferredLighting && this.deferredLightingStrength > 0 || this.shadowMap != null && this.shadowMapStrength > 0))
               {
                  this.depthParams[0] = this.depthRenderer.correctionX;
                  this.depthParams[1] = this.depthRenderer.correctionY;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,4,this.depthParams,1);
                  if(this.ssao && this.ssaoStrength > 0)
                  {
                     this.ssaoParams[0] = (1 - 2 * (this.ssaoColor >> 16 & 255) / 255) * this.ssaoAlpha * this.ssaoStrength;
                     this.ssaoParams[1] = (1 - 2 * (this.ssaoColor >> 8 & 255) / 255) * this.ssaoAlpha * this.ssaoStrength;
                     this.ssaoParams[2] = (1 - 2 * (this.ssaoColor & 255) / 255) * this.ssaoAlpha * this.ssaoStrength;
                     this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,12,this.ssaoParams,1);
                  }
               }
               if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,6,this.shadowMap.transform,4);
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,5,this.shadowMap.params,5);
               }
               if(this.fogAlpha > 0 && this.fogStrength > 0)
               {
                  this.fogParams[2] = this.fogNear;
                  this.fogParams[3] = this.fogFar - this.fogNear;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,this.fogParams,1);
                  this.fogFragment[0] = (this.fogColor >> 16 & 255) / 255;
                  this.fogFragment[1] = (this.fogColor >> 8 & 255) / 255;
                  this.fogFragment[2] = (this.fogColor & 255) / 255;
                  this.fogFragment[3] = this.fogAlpha * this.fogStrength;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,this.fogFragment,1);
               }
               if(!this.view.constrained && this.directionalLight != null && this.directionalLightStrength > 0)
               {
                  this.lightTransform[0] = -this.directionalLight.imi;
                  this.lightTransform[1] = -this.directionalLight.imj;
                  this.lightTransform[2] = -this.directionalLight.imk;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,10,this.lightTransform,1);
                  this.lightParams[0] = this.directionalLight.intensity * (this.directionalLight.color >> 16 & 255) * 2 * this.directionalLightStrength / 255;
                  this.lightParams[1] = this.directionalLight.intensity * (this.directionalLight.color >> 8 & 255) * 2 * this.directionalLightStrength / 255;
                  this.lightParams[2] = this.directionalLight.intensity * (this.directionalLight.color & 255) * 2 * this.directionalLightStrength / 255;
                  this.lightParams[4] = 1 + ((this.ambientColor >> 16 & 255) * 2 / 255 - 1) * this.directionalLightStrength;
                  this.lightParams[5] = 1 + ((this.ambientColor >> 8 & 255) * 2 / 255 - 1) * this.directionalLightStrength;
                  this.lightParams[6] = 1 + ((this.ambientColor & 255) * 2 / 255 - 1) * this.directionalLightStrength;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,10,this.lightParams,2);
               }
               else if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.lightParams[0] = 0;
                  this.lightParams[1] = 0;
                  this.lightParams[2] = 0;
                  this.lightParams[4] = 1;
                  this.lightParams[5] = 1;
                  this.lightParams[6] = 1;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,10,this.lightParams,2);
               }
               _loc1_ = 0;
               while(_loc1_ < this.opaqueCount)
               {
                  _loc9_ = this.opaqueMaterials[_loc1_];
                  _loc9_.drawOpaque(this,this.opaqueVertexBuffers[_loc1_],this.opaqueIndexBuffers[_loc1_],this.opaqueFirstIndexes[_loc1_],this.opaqueNumsTriangles[_loc1_],this.opaqueObjects[_loc1_]);
                  _loc1_++;
               }
               this.device.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
               _loc1_ = 0;
               while(_loc1_ < this.skyCount)
               {
                  _loc9_ = this.skyMaterials[_loc1_];
                  _loc9_.drawOpaque(this,this.skyVertexBuffers[_loc1_],this.skyIndexBuffers[_loc1_],this.skyFirstIndexes[_loc1_],this.skyNumsTriangles[_loc1_],this.skyObjects[_loc1_]);
                  _loc1_++;
               }
               this.device.setDepthTest(false,Context3DCompareMode.LESS);
               _loc1_ = this.decalsCount - 1;
               while(_loc1_ >= 0)
               {
                  _loc11_ = this.decals[_loc1_];
                  if(_loc11_.concatenatedBlendMode != "normal")
                  {
                     this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
                  }
                  else
                  {
                     this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                  }
                  _loc11_.faceList.material.drawOpaque(this,_loc11_.vertexBuffer,_loc11_.indexBuffer,0,_loc11_.numTriangles,_loc11_);
                  _loc1_--;
               }
               if(_loc8_)
               {
                  this.device.setTextureAt(0,null);
                  this.device.setTextureAt(1,null);
                  this.device.setTextureAt(2,null);
                  this.device.setTextureAt(3,null);
                  this.device.setTextureAt(5,null);
                  this.device.setVertexBufferAt(1,null);
                  this.device.setVertexBufferAt(2,null);
                  _loc12_ = 0;
                  for each(_loc7_ in this.shadowAtlases)
                  {
                     _loc1_ = 0;
                     while(_loc1_ < _loc7_.shadowsCount)
                     {
                        this.shadowList[_loc12_] = _loc7_.shadows[_loc1_];
                        _loc12_++;
                        _loc1_++;
                     }
                  }
                  this.device.setDepthTest(false,Context3DCompareMode.LESS);
                  _loc15_ = null;
                  _loc1_ = 0;/*
                  while(_loc1_ < _loc12_)
                  {
                     if(_loc1_ > 0)
                     {
                        this.device.clear(0,0,0,0,1,0,Context3DClearMask.STENCIL);
                     }
                     this.device.setBlendFactors(Context3DBlendFactor.ZERO,Context3DBlendFactor.ONE);
                     this.device.setCulling(Context3DTriangleFace.NONE);
                     this.device.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.ALWAYS,Context3DStencilAction.INVERT);
                     _loc13_ = _loc1_;
                     _loc14_ = 1;
                     while(_loc13_ < _loc1_ + 8 && _loc13_ < _loc12_)
                     {
                        _loc4_ = this.shadowList[_loc13_];
                        if(!_loc4_.cameraInside)
                        {
                           this.device.setStencilReferenceValue(_loc14_,_loc14_,_loc14_);
                           _loc4_.renderVolume(this);
                        }
                        _loc13_++;
                        _loc14_ = _loc14_ << 1;
                     }
                     this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                     this.device.setCulling(Context3DTriangleFace.FRONT);
                     this.device.setStencilActions(Context3DTriangleFace.BACK,Context3DCompareMode.EQUAL);
                     _loc13_ = _loc1_;
                     _loc14_ = 1;
                     while(_loc13_ < _loc1_ + 8 && _loc13_ < _loc12_)
                     {
                        _loc4_ = this.shadowList[_loc13_];
                        if(_loc4_.texture != _loc15_)
                        {
                           this.device.setTextureAt(0,_loc4_.texture);
                           _loc15_ = _loc4_.texture;
                        }
                        if(!_loc4_.cameraInside)
                        {
                           this.device.setStencilReferenceValue(_loc14_,_loc14_,_loc14_);
                           _loc4_.renderReceivers(this);
                        }
                        else
                        {
                           this.device.setStencilActions(Context3DTriangleFace.BACK,Context3DCompareMode.ALWAYS);
                           _loc4_.renderReceivers(this);
                           this.device.setStencilActions(Context3DTriangleFace.BACK,Context3DCompareMode.EQUAL);
                        }
                        _loc13_++;
                        _loc14_ = _loc14_ << 1;
                     }
                     this.device.setTextureAt(0,null);
                     _loc15_ = null;
                     _loc1_ = _loc1_ + 8;
                  }
                  this.device.setStencilActions();
                  this.device.setStencilReferenceValue(0);*/
               }
               this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13,this.correction,1);
               this.device.setCulling(Context3DTriangleFace.FRONT);
               _loc1_ = 0;
               while(_loc1_ < this.transparentOpaqueCount)
               {
                  if(_loc1_ < this.transparentOpaqueFaceLists.length && _loc1_ < this.transparentOpaqueObjects.length)
                  {
                     this.transparentFaceLists[this.transparentCount] = this.transparentOpaqueFaceLists[_loc1_];
                     this.transparentObjects[this.transparentCount] = this.transparentOpaqueObjects[_loc1_];
                     this.transparentCount++;
                  }
                  _loc1_++;
               }
               this.transparentOpaqueCount = this.transparentCount - this.transparentOpaqueCount;
               this.device.setDepthTest(true,Context3DCompareMode.LESS);
               _loc1_ = this.transparentCount - 1;
               while(_loc1_ >= 0)
               {
                  if(_loc1_ + 1 == this.transparentOpaqueCount)
                  {
                     this.device.setDepthTest(false,Context3DCompareMode.LESS);
                  }
                  _loc16_ = this.transparentFaceLists[_loc1_];
                  _loc17_ = this.transparentObjects[_loc1_];
                  if(_loc17_.concatenatedBlendMode != "normal")
                  {
                     this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
                  }
                  else
                  {
                     this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                  }
                  _loc18_ = _loc17_ is Sprite3D;
                  if(_loc18_)
                  {
                     _loc20_ = 0;
                     _loc21_ = Sprite3D(_loc17_);
                     _loc22_ = _loc16_;
                     while(_loc22_.processNext != null)
                     {
                        _loc22_.distance = _loc20_;
                        _loc22_ = _loc22_.processNext;
                     }
                     _loc22_.distance = _loc20_;
                     this.transparentBatchObjects[_loc20_] = _loc17_;
                     _loc20_++;
                     _loc13_ = _loc1_ - 1;
                     while(_loc13_ >= 0)
                     {
                        _loc23_ = this.transparentFaceLists[_loc13_];
                        if(_loc16_.material != _loc23_.material)
                        {
                           break;
                        }
                        _loc24_ = this.transparentObjects[_loc13_];
                        if(_loc24_ is Sprite3D)
                        {
                           _loc25_ = Sprite3D(_loc24_);
                           if(_loc21_.useLight != _loc25_.useLight || _loc21_.useShadowMap != _loc25_.useShadowMap || _loc21_.lighted || _loc25_.lighted || _loc21_.softAttenuation != _loc25_.softAttenuation || _loc21_.concatenatedAlpha != _loc25_.concatenatedAlpha || _loc21_.concatenatedColorTransform != null || _loc25_.concatenatedColorTransform != null || _loc21_.concatenatedBlendMode != _loc25_.concatenatedBlendMode)
                           {
                              break;
                           }
                           _loc22_.processNext = _loc23_;
                           _loc22_ = _loc23_;
                           while(_loc22_.processNext != null)
                           {
                              _loc22_.distance = _loc20_;
                              _loc22_ = _loc22_.processNext;
                           }
                           _loc22_.distance = _loc20_;
                           this.transparentBatchObjects[_loc20_] = _loc24_;
                           _loc20_++;
                           _loc1_--;
                           _loc13_--;
                           continue;
                        }
                        break;
                     }
                  }
                  _loc19_ = _loc18_ && !Sprite3D(_loc17_).depthTest;
                  if(_loc19_)
                  {
                     this.device.setDepthTest(false,Context3DCompareMode.ALWAYS);
                  }
                  this.drawTransparentList(_loc16_,_loc17_,_loc18_);
                  if(_loc19_)
                  {
                     this.device.setDepthTest(false,Context3DCompareMode.LESS);
                  }
                  _loc1_--;
               }
               this.device.setTextureAt(0,null);
               this.device.setTextureAt(1,null);
               this.device.setTextureAt(2,null);
               this.device.setTextureAt(3,null);
               this.device.setTextureAt(5,null);
               this.device.setTextureAt(6,null);
               this.device.setTextureAt(7,null);
               this.device.setVertexBufferAt(1,null);
               this.device.setVertexBufferAt(2,null);
               this.device.setVertexBufferAt(3,null);
               this.device.setVertexBufferAt(4,null);
               this.device.setVertexBufferAt(5,null);
               this.device.setVertexBufferAt(6,null);
               this.device.setVertexBufferAt(7,null);
               this.opaqueMaterials.length = 0;
               this.opaqueVertexBuffers.length = 0;
               this.opaqueIndexBuffers.length = 0;
               this.opaqueFirstIndexes.length = 0;
               this.opaqueNumsTriangles.length = 0;
               this.opaqueObjects.length = 0;
               this.opaqueCount = 0;
               this.skyMaterials.length = 0;
               this.skyVertexBuffers.length = 0;
               this.skyIndexBuffers.length = 0;
               this.skyFirstIndexes.length = 0;
               this.skyNumsTriangles.length = 0;
               this.skyObjects.length = 0;
               this.skyCount = 0;
               this.transparentFaceLists.length = 0;
               this.transparentObjects.length = 0;
               this.transparentCount = 0;
               this.transparentOpaqueFaceLists.length = 0;
               this.transparentOpaqueObjects.length = 0;
               this.transparentOpaqueCount = 0;
               this.transparentBatchObjects.length = 0;
               this.decals.length = 0;
               this.decalsCount = 0;
               this.depthObjects.length = 0;
               this.depthCount = 0;
               this.casterObjects.length = 0;
               this.casterCount = 0;
               this.omnies.length = 0;
               this.omniesCount = 0;
               this.spots.length = 0;
               this.spotsCount = 0;
               this.tubes.length = 0;
               this.tubesCount = 0;
               for each(_loc7_ in this.shadowAtlases)
               {
                  if(_loc7_.shadowsCount > 0)
                  {
                     _loc7_.clear();
                  }
               }
               this.receiversVertexBuffers = null;
               this.receiversIndexBuffers = null;
               this.deferredDestroy();
               this.clearOccluders();
               this.view.onRender(this);
               if(this.onRender != null)
               {
                  this.onRender();
               }
               this.view.present();
            }
            else
            {
               this.view.clearArea();
               if(this.onRender != null)
               {
                  this.onRender();
               }
               this.view.present();
            }
            this.device = null;
         }
      }
      
      private function drawTransparentList(param1:Face, param2:Object3D, param3:Boolean) : void
      {
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:Wrapper = null;
         var _loc8_:Face = null;
         var _loc12_:int = 0;
         var _loc13_:Object3D = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Material = param1.material;
         while(param1 != null)
         {
            _loc8_ = param1.processNext;
            param1.processNext = null;
            _loc7_ = param1.wrapper;
            _loc4_ = _loc7_.vertex;
            _loc7_ = _loc7_.next;
            _loc5_ = _loc7_.vertex;
            if(param3)
            {
               _loc12_ = param1.distance;
               _loc13_ = this.transparentBatchObjects[_loc12_];
               _loc7_ = _loc7_.next;
               while(_loc7_ != null)
               {
                  if(_loc10_ == constantsMaxTriangles)
                  {
                     if(_loc11_ != null)
                     {
                        this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,constantsOffset,constants,_loc10_ * 6,false);
                        _loc11_.drawTransparent(this,constantsVertexBuffer,constantsIndexBuffer,0,_loc10_,param2,true);
                     }
                     _loc10_ = 0;
                     _loc9_ = 0;
                  }
                  _loc6_ = _loc7_.vertex;
                  constants[_loc9_] = _loc4_.cameraX;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.cameraY;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.cameraZ;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.md;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.u;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.v;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.mh;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.ml;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.cameraX;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.cameraY;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.cameraZ;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.md;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.u;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.v;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.mh;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.ml;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.cameraX;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.cameraY;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.cameraZ;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.md;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.u;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.v;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.mh;
                  _loc9_++;
                  constants[_loc9_] = -_loc13_.ml;
                  _loc9_++;
                  _loc10_++;
                  _loc5_ = _loc6_;
                  _loc7_ = _loc7_.next;
               }
            }
            else
            {
               _loc7_ = _loc7_.next;
               while(_loc7_ != null)
               {
                  if(_loc10_ == constantsMaxTriangles)
                  {
                     if(_loc11_ != null)
                     {
                        this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,constantsOffset,constants,_loc10_ * 6,false);
                        _loc11_.drawTransparent(this,constantsVertexBuffer,constantsIndexBuffer,0,_loc10_,param2,true);
                     }
                     _loc10_ = 0;
                     _loc9_ = 0;
                  }
                  _loc6_ = _loc7_.vertex;
                  constants[_loc9_] = _loc4_.cameraX;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.cameraY;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.cameraZ;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.normalX;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.u;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.v;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.normalY;
                  _loc9_++;
                  constants[_loc9_] = _loc4_.normalZ;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.cameraX;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.cameraY;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.cameraZ;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.normalX;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.u;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.v;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.normalY;
                  _loc9_++;
                  constants[_loc9_] = _loc5_.normalZ;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.cameraX;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.cameraY;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.cameraZ;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.normalX;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.u;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.v;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.normalY;
                  _loc9_++;
                  constants[_loc9_] = _loc6_.normalZ;
                  _loc9_++;
                  _loc10_++;
                  _loc5_ = _loc6_;
                  _loc7_ = _loc7_.next;
               }
            }
            param1 = _loc8_;
         }
         if(_loc10_ > 0 && _loc11_ != null)
         {
            this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,constantsOffset,constants,_loc10_ * 6,false);
            _loc11_.drawTransparent(this,constantsVertexBuffer,constantsIndexBuffer,0,_loc10_,param2,true);
         }
      }
      
      public function lookAt(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = param1 - this.x;
         var _loc5_:Number = param2 - this.y;
         var _loc6_:Number = param3 - this.z;
         rotationX = Math.atan2(_loc6_,Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_)) - Math.PI / 2;
         rotationY = 0;
         rotationZ = -Math.atan2(_loc4_,_loc5_);
      }
      
      public function projectGlobal(param1:Vector3D) : Vector3D
      {
         if(this.view == null)
         {
            throw new Error("It is necessary to have view set.");
         }
         this.viewSizeX = this.view._width * 0.5;
         this.viewSizeY = this.view._height * 0.5;
         this.focalLength = Math.sqrt(this.viewSizeX * this.viewSizeX + this.viewSizeY * this.viewSizeY) / Math.tan(this.fov * 0.5);
         this.composeCameraMatrix();
         var _loc2_:Object3D = this;
         while(_loc2_._parent != null)
         {
            _loc2_ = _loc2_._parent;
            tA.composeMatrixFromSource(_loc2_);
            appendMatrix(tA);
         }
         invertMatrix();
         var _loc3_:Vector3D = new Vector3D();
         _loc3_.x = ma * param1.x + mb * param1.y + mc * param1.z + md;
         _loc3_.y = me * param1.x + mf * param1.y + mg * param1.z + mh;
         _loc3_.z = mi * param1.x + mj * param1.y + mk * param1.z + ml;
         _loc3_.x = _loc3_.x * this.viewSizeX / _loc3_.z + this.viewSizeX;
         _loc3_.y = _loc3_.y * this.viewSizeY / _loc3_.z + this.viewSizeY;
         return _loc3_;
      }
      
      public function calculateRay(param1:Vector3D, param2:Vector3D, param3:Number, param4:Number) : void
      {
         if(this.view == null)
         {
            throw new Error("It is necessary to have view set.");
         }
         this.viewSizeX = this.view._width * 0.5;
         this.viewSizeY = this.view._height * 0.5;
         this.focalLength = Math.sqrt(this.viewSizeX * this.viewSizeX + this.viewSizeY * this.viewSizeY) / Math.tan(this.fov * 0.5);
         param3 = param3 - this.viewSizeX;
         param4 = param4 - this.viewSizeY;
         var _loc5_:Number = param3 * this.focalLength / this.viewSizeX;
         var _loc6_:Number = param4 * this.focalLength / this.viewSizeY;
         var _loc7_:Number = this.focalLength;
         var _loc8_:Number = _loc5_ * this.nearClipping / this.focalLength;
         var _loc9_:Number = _loc6_ * this.nearClipping / this.focalLength;
         var _loc10_:Number = this.nearClipping;
         this.composeCameraMatrix();
         var _loc11_:Object3D = this;
         while(_loc11_._parent != null)
         {
            _loc11_ = _loc11_._parent;
            tA.composeMatrixFromSource(_loc11_);
            appendMatrix(tA);
         }
         param1.x = ma * _loc8_ + mb * _loc9_ + mc * _loc10_ + md;
         param1.y = me * _loc8_ + mf * _loc9_ + mg * _loc10_ + mh;
         param1.z = mi * _loc8_ + mj * _loc9_ + mk * _loc10_ + ml;
         param2.x = ma * _loc5_ + mb * _loc6_ + mc * _loc7_;
         param2.y = me * _loc5_ + mf * _loc6_ + mg * _loc7_;
         param2.z = mi * _loc5_ + mj * _loc6_ + mk * _loc7_;
         var _loc12_:Number = 1 / Math.sqrt(param2.x * param2.x + param2.y * param2.y + param2.z * param2.z);
         param2.x = param2.x * _loc12_;
         param2.y = param2.y * _loc12_;
         param2.z = param2.z * _loc12_;
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Camera3D = new Camera3D();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         var _loc3_:* = undefined;
         super.clonePropertiesFrom(param1);
         var _loc2_:Camera3D = param1 as Camera3D;
         this.fov = _loc2_.fov;
         this.nearClipping = _loc2_.nearClipping;
         this.farClipping = _loc2_.farClipping;
         this.debug = _loc2_.debug;
         this.fogNear = _loc2_.fogNear;
         this.fogFar = _loc2_.fogFar;
         this.fogAlpha = _loc2_.fogAlpha;
         this.fogColor = _loc2_.fogColor;
         this.softTransparency = _loc2_.softTransparency;
         this.depthBufferScale = _loc2_.depthBufferScale;
         this.ssao = _loc2_.ssao;
         this.ssaoRadius = _loc2_.ssaoRadius;
         this.ssaoRange = _loc2_.ssaoRange;
         this.ssaoColor = _loc2_.ssaoColor;
         this.ssaoAlpha = _loc2_.ssaoAlpha;
         this.directionalLight = _loc2_.directionalLight;
         this.shadowMap = _loc2_.shadowMap;
         this.ambientColor = _loc2_.ambientColor;
         this.deferredLighting = _loc2_.deferredLighting;
         this.fogStrength = _loc2_.fogStrength;
         this.softTransparencyStrength = _loc2_.softTransparencyStrength;
         this.ssaoStrength = _loc2_.ssaoStrength;
         this.directionalLightStrength = _loc2_.directionalLightStrength;
         this.shadowMapStrength = _loc2_.shadowMapStrength;
         this.shadowsStrength = _loc2_.shadowsStrength;
         this.shadowsDistanceMultiplier = _loc2_.shadowsDistanceMultiplier;
         this.deferredLightingStrength = _loc2_.deferredLightingStrength;
         for(_loc3_ in _loc2_.shadows)
         {
            this.shadows[_loc3_] = true;
         }
      }
      
      alternativa3d function addOpaque(param1:Material, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D) : void
      {
         this.opaqueMaterials[this.opaqueCount] = param1;
         this.opaqueVertexBuffers[this.opaqueCount] = param2;
         this.opaqueIndexBuffers[this.opaqueCount] = param3;
         this.opaqueFirstIndexes[this.opaqueCount] = param4;
         this.opaqueNumsTriangles[this.opaqueCount] = param5;
         this.opaqueObjects[this.opaqueCount] = param6;
         this.opaqueCount++;
      }
      
      alternativa3d function addSky(param1:Material, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D) : void
      {
         this.skyMaterials[this.skyCount] = param1;
         this.skyVertexBuffers[this.skyCount] = param2;
         this.skyIndexBuffers[this.skyCount] = param3;
         this.skyFirstIndexes[this.skyCount] = param4;
         this.skyNumsTriangles[this.skyCount] = param5;
         this.skyObjects[this.skyCount] = param6;
         this.skyCount++;
      }
      
      alternativa3d function addTransparent(param1:Face, param2:Object3D) : void
      {
         this.transparentFaceLists[this.transparentCount] = param1;
         this.transparentObjects[this.transparentCount] = param2;
         this.transparentCount++;
      }
      
      alternativa3d function addTransparentOpaque(param1:Face, param2:Object3D) : void
      {
         this.transparentOpaqueFaceLists[this.transparentOpaqueCount] = param1;
         this.transparentOpaqueObjects[this.transparentOpaqueCount] = param2;
         this.transparentOpaqueCount++;
      }
      
      alternativa3d function addDecal(param1:Decal) : void
      {
         this.decals[this.decalsCount] = param1;
         this.decalsCount++;
      }
      
      alternativa3d function composeCameraMatrix() : void
      {
         var _loc1_:Number = this.viewSizeX / this.focalLength;
         var _loc2_:Number = this.viewSizeY / this.focalLength;
         var _loc3_:Number = Math.cos(rotationX);
         var _loc4_:Number = Math.sin(rotationX);
         var _loc5_:Number = Math.cos(rotationY);
         var _loc6_:Number = Math.sin(rotationY);
         var _loc7_:Number = Math.cos(rotationZ);
         var _loc8_:Number = Math.sin(rotationZ);
         var _loc9_:Number = _loc7_ * _loc6_;
         var _loc10_:Number = _loc8_ * _loc6_;
         var _loc11_:Number = _loc5_ * scaleX;
         var _loc12_:Number = _loc4_ * scaleY;
         var _loc13_:Number = _loc3_ * scaleY;
         var _loc14_:Number = _loc3_ * scaleZ;
         var _loc15_:Number = _loc4_ * scaleZ;
         ma = _loc7_ * _loc11_ * _loc1_;
         mb = (_loc9_ * _loc12_ - _loc8_ * _loc13_) * _loc2_;
         mc = _loc9_ * _loc14_ + _loc8_ * _loc15_;
         md = x;
         me = _loc8_ * _loc11_ * _loc1_;
         mf = (_loc10_ * _loc12_ + _loc7_ * _loc13_) * _loc2_;
         mg = _loc10_ * _loc14_ - _loc7_ * _loc15_;
         mh = y;
         mi = -_loc6_ * scaleX * _loc1_;
         mj = _loc5_ * _loc12_ * _loc2_;
         mk = _loc5_ * _loc14_;
         ml = z;
         var _loc16_:Number = this.view.offsetX / this.viewSizeX;
         var _loc17_:Number = this.view.offsetY / this.viewSizeY;
         mc = mc - (ma * _loc16_ + mb * _loc17_);
         mg = mg - (me * _loc16_ + mf * _loc17_);
         mk = mk - (mi * _loc16_ + mj * _loc17_);
      }
      
      public function addToDebug(param1:int, param2:*) : void
      {
         if(!this.debugSet[param1])
         {
            this.debugSet[param1] = new Dictionary();
         }
         this.debugSet[param1][param2] = true;
      }
      
      public function removeFromDebug(param1:int, param2:*) : void
      {
         var _loc3_:* = undefined;
         if(this.debugSet[param1])
         {
            delete this.debugSet[param1][param2];
            for(_loc3_ in this.debugSet[param1])
            {
            }
            if(!_loc3_)
            {
               delete this.debugSet[param1];
            }
         }
      }
      
      alternativa3d function checkInDebug(param1:Object3D) : int
      {
         var _loc4_:Class = null;
         var _loc2_:int = 0;
         var _loc3_:int = 1;
         while(_loc3_ <= 512)
         {
            if(this.debugSet[_loc3_])
            {
               if(this.debugSet[_loc3_][Object3D] || this.debugSet[_loc3_][param1])
               {
                  _loc2_ = _loc2_ | _loc3_;
               }
               else
               {
                  _loc4_ = getDefinitionByName(getQualifiedClassName(param1)) as Class;
                  while(_loc4_ != Object3D)
                  {
                     if(this.debugSet[_loc3_][_loc4_])
                     {
                        _loc2_ = _loc2_ | _loc3_;
                        break;
                     }
                     _loc4_ = Class(getDefinitionByName(getQualifiedSuperclassName(_loc4_)));
                  }
               }
            }
            _loc3_ = _loc3_ << 1;
         }
         return _loc2_;
      }
      
      public function startTimer() : void
      {
         this.timer = getTimer();
      }
      
      public function stopTimer() : void
      {
         this.timeSum = this.timeSum + (getTimer() - this.timer);
         this.timeCount++;
      }
      
      public function get diagram() : DisplayObject
      {
         return this._diagram;
      }
      
      public function get diagramAlign() : String
      {
         return this._diagramAlign;
      }
      
      public function set diagramAlign(param1:String) : void
      {
         this._diagramAlign = param1;
         this.resizeDiagram();
      }
      
      public function get diagramHorizontalMargin() : Number
      {
         return this._diagramHorizontalMargin;
      }
      
      public function set diagramHorizontalMargin(param1:Number) : void
      {
         this._diagramHorizontalMargin = param1;
         this.resizeDiagram();
      }
      
      public function get diagramVerticalMargin() : Number
      {
         return this._diagramVerticalMargin;
      }
      
      public function set diagramVerticalMargin(param1:Number) : void
      {
         this._diagramVerticalMargin = param1;
         this.resizeDiagram();
      }
      
      private function createDiagram() : Sprite
      {
         var diagram:Sprite = null;
         diagram = null;
         diagram = new Sprite();
         diagram.mouseEnabled = false;
         diagram.mouseChildren = false;
         diagram.addEventListener(Event.ADDED_TO_STAGE,function():void
         {
            while(diagram.numChildren > 0)
            {
               diagram.removeChildAt(0);
            }
            fpsTextField = new TextField();
            fpsTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421772);
            fpsTextField.autoSize = TextFieldAutoSize.LEFT;
            fpsTextField.text = "FPS:";
            fpsTextField.selectable = false;
            fpsTextField.x = -3;
            fpsTextField.y = -5;
            diagram.addChild(fpsTextField);
            fpsTextField = new TextField();
            fpsTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421772);
            fpsTextField.autoSize = TextFieldAutoSize.RIGHT;
            fpsTextField.text = Number(diagram.stage.frameRate).toFixed(2);
            fpsTextField.selectable = false;
            fpsTextField.x = -3;
            fpsTextField.y = -5;
            fpsTextField.width = 65;
            diagram.addChild(fpsTextField);
            timerTextField = new TextField();
            timerTextField.defaultTextFormat = new TextFormat("Tahoma",10,26367);
            timerTextField.autoSize = TextFieldAutoSize.LEFT;
            timerTextField.text = "MS:";
            timerTextField.selectable = false;
            timerTextField.x = -3;
            timerTextField.y = 4;
            diagram.addChild(timerTextField);
            timerTextField = new TextField();
            timerTextField.defaultTextFormat = new TextFormat("Tahoma",10,26367);
            timerTextField.autoSize = TextFieldAutoSize.RIGHT;
            timerTextField.text = "";
            timerTextField.selectable = false;
            timerTextField.x = -3;
            timerTextField.y = 4;
            timerTextField.width = 65;
            diagram.addChild(timerTextField);
            memoryTextField = new TextField();
            memoryTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421568);
            memoryTextField.autoSize = TextFieldAutoSize.LEFT;
            memoryTextField.text = "MEM:";
            memoryTextField.selectable = false;
            memoryTextField.x = -3;
            memoryTextField.y = 13;
            diagram.addChild(memoryTextField);
            memoryTextField = new TextField();
            memoryTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421568);
            memoryTextField.autoSize = TextFieldAutoSize.RIGHT;
            memoryTextField.text = bytesToString(System.totalMemory);
            memoryTextField.selectable = false;
            memoryTextField.x = -3;
            memoryTextField.y = 13;
            memoryTextField.width = 65;
            diagram.addChild(memoryTextField);
            drawsTextField = new TextField();
            drawsTextField.defaultTextFormat = new TextFormat("Tahoma",10,52224);
            drawsTextField.autoSize = TextFieldAutoSize.LEFT;
            drawsTextField.text = "DRW:";
            drawsTextField.selectable = false;
            drawsTextField.x = -3;
            drawsTextField.y = 22;
            diagram.addChild(drawsTextField);
            drawsTextField = new TextField();
            drawsTextField.defaultTextFormat = new TextFormat("Tahoma",10,52224);
            drawsTextField.autoSize = TextFieldAutoSize.RIGHT;
            drawsTextField.text = "0";
            drawsTextField.selectable = false;
            drawsTextField.x = -3;
            drawsTextField.y = 22;
            drawsTextField.width = 52;
            diagram.addChild(drawsTextField);
            shadowsTextField = new TextField();
            shadowsTextField.defaultTextFormat = new TextFormat("Tahoma",10,16711731);
            shadowsTextField.autoSize = TextFieldAutoSize.LEFT;
            shadowsTextField.text = "SHD:";
            shadowsTextField.selectable = false;
            shadowsTextField.x = -3;
            shadowsTextField.y = 31;
            diagram.addChild(shadowsTextField);
            shadowsTextField = new TextField();
            shadowsTextField.defaultTextFormat = new TextFormat("Tahoma",10,16711731);
            shadowsTextField.autoSize = TextFieldAutoSize.RIGHT;
            shadowsTextField.text = "0";
            shadowsTextField.selectable = false;
            shadowsTextField.x = -3;
            shadowsTextField.y = 31;
            shadowsTextField.width = 52;
            diagram.addChild(shadowsTextField);
            trianglesTextField = new TextField();
            trianglesTextField.defaultTextFormat = new TextFormat("Tahoma",10,16737792);
            trianglesTextField.autoSize = TextFieldAutoSize.LEFT;
            trianglesTextField.text = "TRI:";
            trianglesTextField.selectable = false;
            trianglesTextField.x = -3;
            trianglesTextField.y = 40;
            diagram.addChild(trianglesTextField);
            trianglesTextField = new TextField();
            trianglesTextField.defaultTextFormat = new TextFormat("Tahoma",10,16737792);
            trianglesTextField.autoSize = TextFieldAutoSize.RIGHT;
            trianglesTextField.text = "0";
            trianglesTextField.selectable = false;
            trianglesTextField.x = -3;
            trianglesTextField.y = 40;
            trianglesTextField.width = 52;
            diagram.addChild(trianglesTextField);
            graph = new Bitmap(new BitmapData(60,40,true,553648127));
            rect = new Rectangle(0,0,1,40);
            graph.x = 0;
            graph.y = 54;
            diagram.addChild(graph);
            previousPeriodTime = getTimer();
            previousFrameTime = previousPeriodTime;
            fpsUpdateCounter = 0;
            maxMemory = 0;
            timerUpdateCounter = 0;
            timeSum = 0;
            timeCount = 0;
            diagram.stage.addEventListener(Event.ENTER_FRAME,updateDiagram,false,-1000);
            diagram.stage.addEventListener(Event.RESIZE,resizeDiagram,false,-1000);
            resizeDiagram();
         });
         diagram.addEventListener(Event.REMOVED_FROM_STAGE,function():void
         {
            while(diagram.numChildren > 0)
            {
               diagram.removeChildAt(0);
            }
            fpsTextField = null;
            memoryTextField = null;
            drawsTextField = null;
            shadowsTextField = null;
            trianglesTextField = null;
            timerTextField = null;
            graph.bitmapData.dispose();
            graph = null;
            rect = null;
            diagram.stage.removeEventListener(Event.ENTER_FRAME,updateDiagram);
            diagram.stage.removeEventListener(Event.RESIZE,resizeDiagram);
         });
         return diagram;
      }
      
      private function resizeDiagram(param1:Event = null) : void
      {
         var _loc2_:Point = null;
         if(this._diagram.stage != null)
         {
            _loc2_ = this._diagram.parent.globalToLocal(new Point());
            if(this._diagramAlign == StageAlign.TOP_LEFT || this._diagramAlign == StageAlign.LEFT || this._diagramAlign == StageAlign.BOTTOM_LEFT)
            {
               this._diagram.x = Math.round(_loc2_.x + this._diagramHorizontalMargin);
            }
            if(this._diagramAlign == StageAlign.TOP || this._diagramAlign == StageAlign.BOTTOM)
            {
               this._diagram.x = Math.round(_loc2_.x + this._diagram.stage.stageWidth / 2 - this.graph.width / 2);
            }
            if(this._diagramAlign == StageAlign.TOP_RIGHT || this._diagramAlign == StageAlign.RIGHT || this._diagramAlign == StageAlign.BOTTOM_RIGHT)
            {
               this._diagram.x = Math.round(_loc2_.x + this._diagram.stage.stageWidth - this._diagramHorizontalMargin - this.graph.width);
            }
            if(this._diagramAlign == StageAlign.TOP_LEFT || this._diagramAlign == StageAlign.TOP || this._diagramAlign == StageAlign.TOP_RIGHT)
            {
               this._diagram.y = Math.round(_loc2_.y + this._diagramVerticalMargin);
            }
            if(this._diagramAlign == StageAlign.LEFT || this._diagramAlign == StageAlign.RIGHT)
            {
               this._diagram.y = Math.round(_loc2_.y + this._diagram.stage.stageHeight / 2 - (this.graph.y + this.graph.height) / 2);
            }
            if(this._diagramAlign == StageAlign.BOTTOM_LEFT || this._diagramAlign == StageAlign.BOTTOM || this._diagramAlign == StageAlign.BOTTOM_RIGHT)
            {
               this._diagram.y = Math.round(_loc2_.y + this._diagram.stage.stageHeight - this._diagramVerticalMargin - this.graph.y - this.graph.height);
            }
         }
      }
      
      private function updateDiagram(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = getTimer();
         var _loc6_:int = this._diagram.stage.frameRate;
         if(++this.fpsUpdateCounter == this.fpsUpdatePeriod)
         {
            _loc2_ = 1000 * this.fpsUpdatePeriod / (_loc5_ - this.previousPeriodTime);
            if(_loc2_ > _loc6_)
            {
               _loc2_ = _loc6_;
            }
            _loc3_ = _loc2_ * 100 % 100;
            _loc4_ = _loc3_ >= 10?String(_loc3_):_loc3_ > 0?"0" + String(_loc3_):"00";
            this.fpsTextField.text = int(_loc2_) + "." + _loc4_;
            this.previousPeriodTime = _loc5_;
            this.fpsUpdateCounter = 0;
         }
         _loc2_ = 1000 / (_loc5_ - this.previousFrameTime);
         if(_loc2_ > _loc6_)
         {
            _loc2_ = _loc6_;
         }
         this.graph.bitmapData.scroll(1,0);
         this.graph.bitmapData.fillRect(this.rect,553648127);
         this.graph.bitmapData.setPixel32(0,40 * (1 - _loc2_ / _loc6_),4291611852);
         this.previousFrameTime = _loc5_;
         if(++this.timerUpdateCounter == this.timerUpdatePeriod)
         {
            if(this.timeCount > 0)
            {
               _loc2_ = this.timeSum / this.timeCount;
               _loc3_ = _loc2_ * 100 % 100;
               _loc4_ = _loc3_ >= 10?String(_loc3_):_loc3_ > 0?"0" + String(_loc3_):"00";
               this.timerTextField.text = int(_loc2_) + "." + _loc4_;
            }
            else
            {
               this.timerTextField.text = "";
            }
            this.timerUpdateCounter = 0;
            this.timeSum = 0;
            this.timeCount = 0;
         }
         var _loc7_:int = System.totalMemory;
         _loc2_ = _loc7_ / 1048576;
         _loc3_ = _loc2_ * 100 % 100;
         _loc4_ = _loc3_ >= 10?String(_loc3_):_loc3_ > 0?"0" + String(_loc3_):"00";
         this.memoryTextField.text = int(_loc2_) + "." + _loc4_;
         if(_loc7_ > this.maxMemory)
         {
            this.maxMemory = _loc7_;
         }
         this.graph.bitmapData.setPixel32(0,40 * (1 - _loc7_ / this.maxMemory),4291611648);
         this.drawsTextField.text = String(this.numDraws);
         this.shadowsTextField.text = String(this.numShadows);
         this.trianglesTextField.text = String(this.numTriangles);
      }
      
      private function bytesToString(param1:int) : String
      {
         if(param1 < 1024)
         {
            return param1 + "b";
         }
         if(param1 < 10240)
         {
            return (param1 / 1024).toFixed(2) + "kb";
         }
         if(param1 < 102400)
         {
            return (param1 / 1024).toFixed(1) + "kb";
         }
         if(param1 < 1048576)
         {
            return (param1 >> 10) + "kb";
         }
         if(param1 < 10485760)
         {
            return (param1 / 1048576).toFixed(2);
         }
         if(param1 < 104857600)
         {
            return (param1 / 1048576).toFixed(1);
         }
         return String(param1 >> 20);
      }
      
      alternativa3d function deferredDestroy() : void
      {
         var _loc2_:Wrapper = null;
         var _loc3_:Wrapper = null;
         var _loc1_:Face = this.firstFace.next;
         while(_loc1_ != null)
         {
            _loc2_ = _loc1_.wrapper;
            if(_loc2_ != null)
            {
               _loc3_ = null;
               while(_loc2_ != null)
               {
                  _loc2_.vertex = null;
                  _loc3_ = _loc2_;
                  _loc2_ = _loc2_.next;
               }
               this.lastWrapper.next = _loc1_.wrapper;
               this.lastWrapper = _loc3_;
            }
            _loc1_.material = null;
            _loc1_.wrapper = null;
            _loc1_ = _loc1_.next;
         }
         if(this.firstFace != this.lastFace)
         {
            this.lastFace.next = Face.collector;
            Face.collector = this.firstFace.next;
            this.firstFace.next = null;
            this.lastFace = this.firstFace;
         }
         if(this.firstWrapper != this.lastWrapper)
         {
            this.lastWrapper.next = Wrapper.collector;
            Wrapper.collector = this.firstWrapper.next;
            this.firstWrapper.next = null;
            this.lastWrapper = this.firstWrapper;
         }
         if(this.firstVertex != this.lastVertex)
         {
            this.lastVertex.next = Vertex.collector;
            Vertex.collector = this.firstVertex.next;
            this.firstVertex.next = null;
            this.lastVertex = this.firstVertex;
         }
      }
      
      alternativa3d function clearOccluders() : void
      {
         var _loc2_:Vertex = null;
         var _loc3_:Vertex = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.numOccluders)
         {
            _loc2_ = this.occluders[_loc1_];
            _loc3_ = _loc2_;
            while(_loc3_.next != null)
            {
               _loc3_ = _loc3_.next;
            }
            _loc3_.next = Vertex.collector;
            Vertex.collector = _loc2_;
            this.occluders[_loc1_] = null;
            _loc1_++;
         }
         this.numOccluders = 0;
      }
      
      alternativa3d function sortByAverageZ(param1:Face) : Face
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Wrapper = null;
         var _loc5_:Face = param1;
         var _loc6_:Face = param1.processNext;
         while(_loc6_ != null && _loc6_.processNext != null)
         {
            param1 = param1.processNext;
            _loc6_ = _loc6_.processNext.processNext;
         }
         _loc6_ = param1.processNext;
         param1.processNext = null;
         if(_loc5_.processNext != null)
         {
            _loc5_ = this.sortByAverageZ(_loc5_);
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = _loc5_.wrapper;
            while(_loc4_ != null)
            {
               _loc2_++;
               _loc3_ = _loc3_ + _loc4_.vertex.cameraZ;
               _loc4_ = _loc4_.next;
            }
            _loc5_.distance = _loc3_ / _loc2_;
         }
         if(_loc6_.processNext != null)
         {
            _loc6_ = this.sortByAverageZ(_loc6_);
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = _loc6_.wrapper;
            while(_loc4_ != null)
            {
               _loc2_++;
               _loc3_ = _loc3_ + _loc4_.vertex.cameraZ;
               _loc4_ = _loc4_.next;
            }
            _loc6_.distance = _loc3_ / _loc2_;
         }
         var _loc7_:Boolean = _loc5_.distance > _loc6_.distance;
         if(_loc7_)
         {
            param1 = _loc5_;
            _loc5_ = _loc5_.processNext;
         }
         else
         {
            param1 = _loc6_;
            _loc6_ = _loc6_.processNext;
         }
         var _loc8_:Face = param1;
         while(true)
         {
            if(_loc5_ == null)
            {
               _loc8_.processNext = _loc6_;
               return param1;
            }
            if(_loc6_ == null)
            {
               _loc8_.processNext = _loc5_;
               return param1;
            }
            if(_loc7_)
            {
               if(_loc5_.distance > _loc6_.distance)
               {
                  _loc8_ = _loc5_;
                  _loc5_ = _loc5_.processNext;
               }
               else
               {
                  _loc8_.processNext = _loc6_;
                  _loc8_ = _loc6_;
                  _loc6_ = _loc6_.processNext;
                  _loc7_ = false;
               }
            }
            else if(_loc6_.distance > _loc5_.distance)
            {
               _loc8_ = _loc6_;
               _loc6_ = _loc6_.processNext;
            }
            else
            {
               _loc8_.processNext = _loc5_;
               _loc8_ = _loc5_;
               _loc5_ = _loc5_.processNext;
               _loc7_ = true;
            }
         }
         return null;
      }
      
      alternativa3d function sortByDynamicBSP(param1:Face, param2:Number, param3:Face = null) : Face
      {
         var _loc4_:Wrapper = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc23_:Face = null;
         var _loc24_:Face = null;
         var _loc26_:Face = null;
         var _loc27_:Face = null;
         var _loc28_:Face = null;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Boolean = false;
         var _loc41_:Boolean = false;
         var _loc42_:Number = NaN;
         var _loc43_:Face = null;
         var _loc44_:Face = null;
         var _loc45_:Wrapper = null;
         var _loc46_:Wrapper = null;
         var _loc47_:Wrapper = null;
         var _loc48_:Boolean = false;
         var _loc49_:Number = NaN;
         var _loc9_:Face = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc25_:Face = null;
         var _loc29_:Face = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc23_ = null;
         _loc24_ = null;
         _loc26_ = null;
         _loc27_ = null;
         _loc28_ = null;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         _loc33_ = NaN;
         _loc34_ = NaN;
         _loc35_ = NaN;
         _loc36_ = NaN;
         _loc37_ = NaN;
         _loc38_ = NaN;
         _loc39_ = NaN;
         _loc40_ = false;
         _loc41_ = false;
         _loc42_ = NaN;
         _loc43_ = null;
         _loc44_ = null;
         _loc45_ = null;
         _loc46_ = null;
         _loc47_ = null;
         _loc48_ = false;
         _loc49_ = NaN;
         _loc9_ = param1;
         param1 = _loc9_.processNext;
         _loc4_ = _loc9_.wrapper;
         _loc5_ = _loc4_.vertex;
         _loc4_ = _loc4_.next;
         _loc6_ = _loc4_.vertex;
         _loc10_ = _loc5_.cameraX;
         _loc11_ = _loc5_.cameraY;
         _loc12_ = _loc5_.cameraZ;
         _loc13_ = _loc6_.cameraX - _loc10_;
         _loc14_ = _loc6_.cameraY - _loc11_;
         _loc15_ = _loc6_.cameraZ - _loc12_;
         _loc16_ = 0;
         _loc17_ = 0;
         _loc18_ = 1;
         _loc19_ = _loc12_;
         _loc20_ = 0;
         _loc4_ = _loc4_.next;
         while(_loc4_ != null)
         {
            _loc8_ = _loc4_.vertex;
            _loc30_ = _loc8_.cameraX - _loc10_;
            _loc31_ = _loc8_.cameraY - _loc11_;
            _loc32_ = _loc8_.cameraZ - _loc12_;
            _loc33_ = _loc32_ * _loc14_ - _loc31_ * _loc15_;
            _loc34_ = _loc30_ * _loc15_ - _loc32_ * _loc13_;
            _loc35_ = _loc31_ * _loc13_ - _loc30_ * _loc14_;
            _loc36_ = _loc33_ * _loc33_ + _loc34_ * _loc34_ + _loc35_ * _loc35_;
            if(_loc36_ > param2)
            {
               _loc36_ = 1 / Math.sqrt(_loc36_);
               _loc16_ = _loc33_ * _loc36_;
               _loc17_ = _loc34_ * _loc36_;
               _loc18_ = _loc35_ * _loc36_;
               _loc19_ = _loc10_ * _loc16_ + _loc11_ * _loc17_ + _loc12_ * _loc18_;
               break;
            }
            if(_loc36_ > _loc20_)
            {
               _loc36_ = 1 / Math.sqrt(_loc36_);
               _loc16_ = _loc33_ * _loc36_;
               _loc17_ = _loc34_ * _loc36_;
               _loc18_ = _loc35_ * _loc36_;
               _loc19_ = _loc10_ * _loc16_ + _loc11_ * _loc17_ + _loc12_ * _loc18_;
               _loc20_ = _loc36_;
            }
            _loc4_ = _loc4_.next;
         }
         _loc21_ = _loc19_ - param2;
         _loc22_ = _loc19_ + param2;
         _loc25_ = _loc9_;
         _loc29_ = param1;
         while(_loc29_ != null)
         {
            _loc28_ = _loc29_.processNext;
            _loc4_ = _loc29_.wrapper;
            _loc5_ = _loc4_.vertex;
            _loc4_ = _loc4_.next;
            _loc6_ = _loc4_.vertex;
            _loc4_ = _loc4_.next;
            _loc7_ = _loc4_.vertex;
            _loc4_ = _loc4_.next;
            _loc37_ = _loc5_.cameraX * _loc16_ + _loc5_.cameraY * _loc17_ + _loc5_.cameraZ * _loc18_;
            _loc38_ = _loc6_.cameraX * _loc16_ + _loc6_.cameraY * _loc17_ + _loc6_.cameraZ * _loc18_;
            _loc39_ = _loc7_.cameraX * _loc16_ + _loc7_.cameraY * _loc17_ + _loc7_.cameraZ * _loc18_;
            _loc40_ = _loc37_ < _loc21_ || _loc38_ < _loc21_ || _loc39_ < _loc21_;
            _loc41_ = _loc37_ > _loc22_ || _loc38_ > _loc22_ || _loc39_ > _loc22_;
            while(_loc4_ != null)
            {
               _loc8_ = _loc4_.vertex;
               _loc42_ = _loc8_.cameraX * _loc16_ + _loc8_.cameraY * _loc17_ + _loc8_.cameraZ * _loc18_;
               if(_loc42_ < _loc21_)
               {
                  _loc40_ = true;
               }
               else if(_loc42_ > _loc22_)
               {
                  _loc41_ = true;
               }
               _loc8_.offset = _loc42_;
               _loc4_ = _loc4_.next;
            }
            if(!_loc40_)
            {
               if(!_loc41_)
               {
                  _loc25_.processNext = _loc29_;
                  _loc25_ = _loc29_;
               }
               else
               {
                  if(_loc26_ != null)
                  {
                     _loc27_.processNext = _loc29_;
                  }
                  else
                  {
                     _loc26_ = _loc29_;
                  }
                  _loc27_ = _loc29_;
               }
            }
            else if(!_loc41_)
            {
               if(_loc23_ != null)
               {
                  _loc24_.processNext = _loc29_;
               }
               else
               {
                  _loc23_ = _loc29_;
               }
               _loc24_ = _loc29_;
            }
            else
            {
               _loc5_.offset = _loc37_;
               _loc6_.offset = _loc38_;
               _loc7_.offset = _loc39_;
               _loc43_ = _loc29_.create();
               _loc43_.material = _loc29_.material;
               this.lastFace.next = _loc43_;
               this.lastFace = _loc43_;
               _loc44_ = _loc29_.create();
               _loc44_.material = _loc29_.material;
               this.lastFace.next = _loc44_;
               this.lastFace = _loc44_;
               _loc45_ = null;
               _loc46_ = null;
               _loc4_ = _loc29_.wrapper.next.next;
               while(_loc4_.next != null)
               {
                  _loc4_ = _loc4_.next;
               }
               _loc5_ = _loc4_.vertex;
               _loc37_ = _loc5_.offset;
               _loc48_ = _loc29_.material != null && _loc29_.material.useVerticesNormals;
               _loc4_ = _loc29_.wrapper;
               while(_loc4_ != null)
               {
                  _loc6_ = _loc4_.vertex;
                  _loc38_ = _loc6_.offset;
                  if(_loc37_ < _loc21_ && _loc38_ > _loc22_ || _loc37_ > _loc22_ && _loc38_ < _loc21_)
                  {
                     _loc49_ = (_loc19_ - _loc37_) / (_loc38_ - _loc37_);
                     _loc8_ = _loc6_.create();
                     this.lastVertex.next = _loc8_;
                     this.lastVertex = _loc8_;
                     _loc8_.cameraX = _loc5_.cameraX + (_loc6_.cameraX - _loc5_.cameraX) * _loc49_;
                     _loc8_.cameraY = _loc5_.cameraY + (_loc6_.cameraY - _loc5_.cameraY) * _loc49_;
                     _loc8_.cameraZ = _loc5_.cameraZ + (_loc6_.cameraZ - _loc5_.cameraZ) * _loc49_;
                     _loc8_.u = _loc5_.u + (_loc6_.u - _loc5_.u) * _loc49_;
                     _loc8_.v = _loc5_.v + (_loc6_.v - _loc5_.v) * _loc49_;
                     if(_loc48_)
                     {
                        _loc8_.x = _loc5_.x + (_loc6_.x - _loc5_.x) * _loc49_;
                        _loc8_.y = _loc5_.y + (_loc6_.y - _loc5_.y) * _loc49_;
                        _loc8_.z = _loc5_.z + (_loc6_.z - _loc5_.z) * _loc49_;
                        _loc8_.normalX = _loc5_.normalX + (_loc6_.normalX - _loc5_.normalX) * _loc49_;
                        _loc8_.normalY = _loc5_.normalY + (_loc6_.normalY - _loc5_.normalY) * _loc49_;
                        _loc8_.normalZ = _loc5_.normalZ + (_loc6_.normalZ - _loc5_.normalZ) * _loc49_;
                     }
                     _loc47_ = _loc4_.create();
                     _loc47_.vertex = _loc8_;
                     if(_loc45_ != null)
                     {
                        _loc45_.next = _loc47_;
                     }
                     else
                     {
                        _loc43_.wrapper = _loc47_;
                     }
                     _loc45_ = _loc47_;
                     _loc47_ = _loc4_.create();
                     _loc47_.vertex = _loc8_;
                     if(_loc46_ != null)
                     {
                        _loc46_.next = _loc47_;
                     }
                     else
                     {
                        _loc44_.wrapper = _loc47_;
                     }
                     _loc46_ = _loc47_;
                  }
                  if(_loc38_ <= _loc22_)
                  {
                     _loc47_ = _loc4_.create();
                     _loc47_.vertex = _loc6_;
                     if(_loc45_ != null)
                     {
                        _loc45_.next = _loc47_;
                     }
                     else
                     {
                        _loc43_.wrapper = _loc47_;
                     }
                     _loc45_ = _loc47_;
                  }
                  if(_loc38_ >= _loc21_)
                  {
                     _loc47_ = _loc4_.create();
                     _loc47_.vertex = _loc6_;
                     if(_loc46_ != null)
                     {
                        _loc46_.next = _loc47_;
                     }
                     else
                     {
                        _loc44_.wrapper = _loc47_;
                     }
                     _loc46_ = _loc47_;
                  }
                  _loc5_ = _loc6_;
                  _loc37_ = _loc38_;
                  _loc4_ = _loc4_.next;
               }
               if(_loc23_ != null)
               {
                  _loc24_.processNext = _loc43_;
               }
               else
               {
                  _loc23_ = _loc43_;
               }
               _loc24_ = _loc43_;
               if(_loc26_ != null)
               {
                  _loc27_.processNext = _loc44_;
               }
               else
               {
                  _loc26_ = _loc44_;
               }
               _loc27_ = _loc44_;
               _loc29_.processNext = null;
            }
            _loc29_ = _loc28_;
         }
         if(_loc26_ != null)
         {
            _loc27_.processNext = null;
            if(_loc26_.processNext != null)
            {
               param3 = this.sortByDynamicBSP(_loc26_,param2,param3);
            }
            else
            {
               _loc26_.processNext = param3;
               param3 = _loc26_;
            }
         }
         _loc25_.processNext = param3;
         param3 = _loc9_;
         if(_loc23_ != null)
         {
            _loc24_.processNext = null;
            if(_loc23_.processNext != null)
            {
               param3 = this.sortByDynamicBSP(_loc23_,param2,param3);
            }
            else
            {
               _loc23_.processNext = param3;
               param3 = _loc23_;
            }
         }
         return param3;
      }
      
      alternativa3d function cull(param1:Face, param2:int) : Face
      {
         var _loc3_:Face = null;
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         var _loc6_:Vertex = null;
         var _loc7_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:Wrapper = null;
         var _loc10_:Vertex = null;
         var _loc11_:Wrapper = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:Face = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = NaN;
         _loc13_ = NaN;
         _loc14_ = NaN;
         _loc15_ = NaN;
         _loc16_ = NaN;
         _loc17_ = NaN;
         _loc18_ = NaN;
         _loc19_ = NaN;
         _loc20_ = NaN;
         _loc21_ = (param2 & 1) > 0;
         _loc22_ = (param2 & 2) > 0;
         _loc23_ = (param2 & 4) > 0;
         _loc24_ = (param2 & 8) > 0;
         _loc25_ = (param2 & 16) > 0;
         _loc26_ = (param2 & 32) > 0;
         _loc27_ = this.nearClipping;
         _loc28_ = this.farClipping;
         _loc29_ = _loc23_ || _loc24_;
         _loc30_ = _loc25_ || _loc26_;
         for(_loc31_ = param1; _loc31_ != null; _loc31_ = _loc5_)
         {
            _loc5_ = _loc31_.processNext;
            _loc9_ = _loc31_.wrapper;
            _loc6_ = _loc9_.vertex;
            _loc9_ = _loc9_.next;
            _loc7_ = _loc9_.vertex;
            _loc9_ = _loc9_.next;
            _loc8_ = _loc9_.vertex;
            _loc9_ = _loc9_.next;
            if(_loc29_)
            {
               _loc12_ = _loc6_.cameraX;
               _loc15_ = _loc7_.cameraX;
               _loc18_ = _loc8_.cameraX;
            }
            if(_loc30_)
            {
               _loc13_ = _loc6_.cameraY;
               _loc16_ = _loc7_.cameraY;
               _loc19_ = _loc8_.cameraY;
            }
            _loc14_ = _loc6_.cameraZ;
            _loc17_ = _loc7_.cameraZ;
            _loc20_ = _loc8_.cameraZ;
            if(_loc21_)
            {
               if(_loc14_ <= _loc27_ || _loc17_ <= _loc27_ || _loc20_ <= _loc27_)
               {
                  _loc31_.processNext = null;
                  continue;
               }
               _loc11_ = _loc9_;
               while(_loc11_ != null)
               {
                  if(_loc11_.vertex.cameraZ <= _loc27_)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               if(_loc11_ != null)
               {
                  _loc31_.processNext = null;
                  continue;
               }
            }
            if(_loc22_ && _loc14_ >= _loc28_ && _loc17_ >= _loc28_ && _loc20_ >= _loc28_)
            {
               _loc11_ = _loc9_;
               while(_loc11_ != null)
               {
                  if(_loc11_.vertex.cameraZ < _loc28_)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               if(_loc11_ == null)
               {
                  _loc31_.processNext = null;
                  continue;
               }
            }
            if(_loc23_ && _loc14_ <= -_loc12_ && _loc17_ <= -_loc15_ && _loc20_ <= -_loc18_)
            {
               _loc11_ = _loc9_;
               while(_loc11_ != null)
               {
                  _loc10_ = _loc11_.vertex;
                  if(-_loc10_.cameraX < _loc10_.cameraZ)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               if(_loc11_ == null)
               {
                  _loc31_.processNext = null;
                  continue;
               }
            }
            if(_loc24_ && _loc14_ <= _loc12_ && _loc17_ <= _loc15_ && _loc20_ <= _loc18_)
            {
               _loc11_ = _loc9_;
               while(_loc11_ != null)
               {
                  _loc10_ = _loc11_.vertex;
                  if(_loc10_.cameraX < _loc10_.cameraZ)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               if(_loc11_ == null)
               {
                  _loc31_.processNext = null;
                  continue;
               }
            }
            if(_loc25_ && _loc14_ <= -_loc13_ && _loc17_ <= -_loc16_ && _loc20_ <= -_loc19_)
            {
               _loc11_ = _loc9_;
               while(_loc11_ != null)
               {
                  _loc10_ = _loc11_.vertex;
                  if(-_loc10_.cameraY < _loc10_.cameraZ)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               if(_loc11_ == null)
               {
                  _loc31_.processNext = null;
                  continue;
               }
            }
            if(_loc26_ && _loc14_ <= _loc13_ && _loc17_ <= _loc16_ && _loc20_ <= _loc19_)
            {
               _loc11_ = _loc9_;
               while(_loc11_ != null)
               {
                  _loc10_ = _loc11_.vertex;
                  if(_loc10_.cameraY < _loc10_.cameraZ)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               if(_loc11_ == null)
               {
                  _loc31_.processNext = null;
                  continue;
               }
            }
            if(_loc3_ != null)
            {
               _loc4_.processNext = _loc31_;
            }
            else
            {
               _loc3_ = _loc31_;
            }
            _loc4_ = _loc31_;
         }
         if(_loc4_ != null)
         {
            _loc4_.processNext = null;
         }
         return _loc3_;
      }
      
      alternativa3d function clip(param1:Face, param2:int) : Face
      {
         var _loc3_:Face = null;
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         var _loc6_:Vertex = null;
         var _loc7_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:Wrapper = null;
         var _loc10_:Vertex = null;
         var _loc11_:Wrapper = null;
         var _loc12_:Wrapper = null;
         var _loc13_:Wrapper = null;
         var _loc14_:Wrapper = null;
         var _loc15_:Wrapper = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         var _loc27_:Boolean = false;
         var _loc28_:Boolean = false;
         var _loc29_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Boolean = false;
         var _loc34_:Boolean = false;
         var _loc35_:int = 0;
         var _loc36_:Number = NaN;
         var _loc37_:Face = null;
         var _loc38_:Boolean = false;
         var _loc39_:Face = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         _loc14_ = null;
         _loc15_ = null;
         _loc16_ = NaN;
         _loc17_ = NaN;
         _loc18_ = NaN;
         _loc19_ = NaN;
         _loc20_ = NaN;
         _loc21_ = NaN;
         _loc22_ = NaN;
         _loc23_ = NaN;
         _loc24_ = NaN;
         _loc25_ = false;
         _loc26_ = false;
         _loc27_ = false;
         _loc28_ = false;
         _loc29_ = false;
         _loc30_ = false;
         _loc31_ = NaN;
         _loc32_ = NaN;
         _loc33_ = false;
         _loc34_ = false;
         _loc35_ = 0;
         _loc36_ = NaN;
         _loc37_ = null;
         _loc38_ = false;
         _loc39_ = null;
         _loc25_ = (param2 & 1) > 0;
         _loc26_ = (param2 & 2) > 0;
         _loc27_ = (param2 & 4) > 0;
         _loc28_ = (param2 & 8) > 0;
         _loc29_ = (param2 & 16) > 0;
         _loc30_ = (param2 & 32) > 0;
         _loc31_ = this.nearClipping;
         _loc32_ = this.farClipping;
         _loc33_ = _loc27_ || _loc28_;
         _loc34_ = _loc29_ || _loc30_;
         for(_loc37_ = param1; _loc37_ != null; _loc37_ = _loc5_)
         {
            _loc5_ = _loc37_.processNext;
            _loc9_ = _loc37_.wrapper;
            _loc6_ = _loc9_.vertex;
            _loc9_ = _loc9_.next;
            _loc7_ = _loc9_.vertex;
            _loc9_ = _loc9_.next;
            _loc8_ = _loc9_.vertex;
            _loc9_ = _loc9_.next;
            if(_loc33_)
            {
               _loc16_ = _loc6_.cameraX;
               _loc19_ = _loc7_.cameraX;
               _loc22_ = _loc8_.cameraX;
            }
            if(_loc34_)
            {
               _loc17_ = _loc6_.cameraY;
               _loc20_ = _loc7_.cameraY;
               _loc23_ = _loc8_.cameraY;
            }
            _loc18_ = _loc6_.cameraZ;
            _loc21_ = _loc7_.cameraZ;
            _loc24_ = _loc8_.cameraZ;
            _loc35_ = 0;
            if(_loc25_)
            {
               if(_loc18_ <= _loc31_ && _loc21_ <= _loc31_ && _loc24_ <= _loc31_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     if(_loc11_.vertex.cameraZ > _loc31_)
                     {
                        _loc35_ = _loc35_ | 1;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc11_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               else if(_loc18_ > _loc31_ && _loc21_ > _loc31_ && _loc24_ > _loc31_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     if(_loc11_.vertex.cameraZ <= _loc31_)
                     {
                        _loc35_ = _loc35_ | 1;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
               }
               else
               {
                  _loc35_ = _loc35_ | 1;
               }
            }
            if(_loc26_)
            {
               if(_loc18_ >= _loc32_ && _loc21_ >= _loc32_ && _loc24_ >= _loc32_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     if(_loc11_.vertex.cameraZ < _loc32_)
                     {
                        _loc35_ = _loc35_ | 2;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc11_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               else if(_loc18_ < _loc32_ && _loc21_ < _loc32_ && _loc24_ < _loc32_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     if(_loc11_.vertex.cameraZ >= _loc32_)
                     {
                        _loc35_ = _loc35_ | 2;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
               }
               else
               {
                  _loc35_ = _loc35_ | 2;
               }
            }
            if(_loc27_)
            {
               if(_loc18_ <= -_loc16_ && _loc21_ <= -_loc19_ && _loc24_ <= -_loc22_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(-_loc10_.cameraX < _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 4;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc11_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               else if(_loc18_ > -_loc16_ && _loc21_ > -_loc19_ && _loc24_ > -_loc22_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(-_loc10_.cameraX >= _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 4;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
               }
               else
               {
                  _loc35_ = _loc35_ | 4;
               }
            }
            if(_loc28_)
            {
               if(_loc18_ <= _loc16_ && _loc21_ <= _loc19_ && _loc24_ <= _loc22_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(_loc10_.cameraX < _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 8;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc11_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               else if(_loc18_ > _loc16_ && _loc21_ > _loc19_ && _loc24_ > _loc22_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(_loc10_.cameraX >= _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 8;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
               }
               else
               {
                  _loc35_ = _loc35_ | 8;
               }
            }
            if(_loc29_)
            {
               if(_loc18_ <= -_loc17_ && _loc21_ <= -_loc20_ && _loc24_ <= -_loc23_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(-_loc10_.cameraY < _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 16;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc11_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               else if(_loc18_ > -_loc17_ && _loc21_ > -_loc20_ && _loc24_ > -_loc23_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(-_loc10_.cameraY >= _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 16;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
               }
               else
               {
                  _loc35_ = _loc35_ | 16;
               }
            }
            if(_loc30_)
            {
               if(_loc18_ <= _loc17_ && _loc21_ <= _loc20_ && _loc24_ <= _loc23_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(_loc10_.cameraY < _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 32;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc11_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               else if(_loc18_ > _loc17_ && _loc21_ > _loc20_ && _loc24_ > _loc23_)
               {
                  _loc11_ = _loc9_;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     if(_loc10_.cameraY >= _loc10_.cameraZ)
                     {
                        _loc35_ = _loc35_ | 32;
                        break;
                     }
                     _loc11_ = _loc11_.next;
                  }
               }
               else
               {
                  _loc35_ = _loc35_ | 32;
               }
            }
            if(_loc35_ > 0)
            {
               _loc38_ = _loc37_.material != null && _loc37_.material.useVerticesNormals;
               _loc12_ = null;
               _loc13_ = null;
               _loc11_ = _loc37_.wrapper;
               while(_loc11_ != null)
               {
                  _loc15_ = _loc11_.create();
                  _loc15_.vertex = _loc11_.vertex;
                  if(_loc12_ != null)
                  {
                     _loc13_.next = _loc15_;
                  }
                  else
                  {
                     _loc12_ = _loc15_;
                  }
                  _loc13_ = _loc15_;
                  _loc11_ = _loc11_.next;
               }
               if(_loc35_ & 1)
               {
                  _loc6_ = _loc13_.vertex;
                  _loc18_ = _loc6_.cameraZ;
                  _loc11_ = _loc12_;
                  _loc12_ = null;
                  _loc13_ = null;
                  while(_loc11_ != null)
                  {
                     _loc14_ = _loc11_.next;
                     _loc7_ = _loc11_.vertex;
                     _loc21_ = _loc7_.cameraZ;
                     if(_loc21_ > _loc31_ && _loc18_ <= _loc31_ || _loc21_ <= _loc31_ && _loc18_ > _loc31_)
                     {
                        _loc36_ = (_loc31_ - _loc18_) / (_loc21_ - _loc18_);
                        _loc10_ = _loc7_.create();
                        this.lastVertex.next = _loc10_;
                        this.lastVertex = _loc10_;
                        _loc10_.cameraX = _loc6_.cameraX + (_loc7_.cameraX - _loc6_.cameraX) * _loc36_;
                        _loc10_.cameraY = _loc6_.cameraY + (_loc7_.cameraY - _loc6_.cameraY) * _loc36_;
                        _loc10_.cameraZ = _loc18_ + (_loc21_ - _loc18_) * _loc36_;
                        _loc10_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc36_;
                        _loc10_.y = _loc6_.y + (_loc7_.y - _loc6_.y) * _loc36_;
                        _loc10_.z = _loc6_.z + (_loc7_.z - _loc6_.z) * _loc36_;
                        _loc10_.u = _loc6_.u + (_loc7_.u - _loc6_.u) * _loc36_;
                        _loc10_.v = _loc6_.v + (_loc7_.v - _loc6_.v) * _loc36_;
                        if(_loc38_)
                        {
                           _loc10_.normalX = _loc6_.normalX + (_loc7_.normalX - _loc6_.normalX) * _loc36_;
                           _loc10_.normalY = _loc6_.normalY + (_loc7_.normalY - _loc6_.normalY) * _loc36_;
                           _loc10_.normalZ = _loc6_.normalZ + (_loc7_.normalZ - _loc6_.normalZ) * _loc36_;
                        }
                        _loc15_ = _loc11_.create();
                        _loc15_.vertex = _loc10_;
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc15_;
                        }
                        else
                        {
                           _loc12_ = _loc15_;
                        }
                        _loc13_ = _loc15_;
                     }
                     if(_loc21_ > _loc31_)
                     {
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc11_;
                        }
                        else
                        {
                           _loc12_ = _loc11_;
                        }
                        _loc13_ = _loc11_;
                        _loc11_.next = null;
                     }
                     else
                     {
                        _loc11_.vertex = null;
                        _loc11_.next = Wrapper.collector;
                        Wrapper.collector = _loc11_;
                     }
                     _loc6_ = _loc7_;
                     _loc18_ = _loc21_;
                     _loc11_ = _loc14_;
                  }
                  if(_loc12_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               if(_loc35_ & 2)
               {
                  _loc6_ = _loc13_.vertex;
                  _loc18_ = _loc6_.cameraZ;
                  _loc11_ = _loc12_;
                  _loc12_ = null;
                  _loc13_ = null;
                  while(_loc11_ != null)
                  {
                     _loc14_ = _loc11_.next;
                     _loc7_ = _loc11_.vertex;
                     _loc21_ = _loc7_.cameraZ;
                     if(_loc21_ < _loc32_ && _loc18_ >= _loc32_ || _loc21_ >= _loc32_ && _loc18_ < _loc32_)
                     {
                        _loc36_ = (_loc32_ - _loc18_) / (_loc21_ - _loc18_);
                        _loc10_ = _loc7_.create();
                        this.lastVertex.next = _loc10_;
                        this.lastVertex = _loc10_;
                        _loc10_.cameraX = _loc6_.cameraX + (_loc7_.cameraX - _loc6_.cameraX) * _loc36_;
                        _loc10_.cameraY = _loc6_.cameraY + (_loc7_.cameraY - _loc6_.cameraY) * _loc36_;
                        _loc10_.cameraZ = _loc18_ + (_loc21_ - _loc18_) * _loc36_;
                        _loc10_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc36_;
                        _loc10_.y = _loc6_.y + (_loc7_.y - _loc6_.y) * _loc36_;
                        _loc10_.z = _loc6_.z + (_loc7_.z - _loc6_.z) * _loc36_;
                        _loc10_.u = _loc6_.u + (_loc7_.u - _loc6_.u) * _loc36_;
                        _loc10_.v = _loc6_.v + (_loc7_.v - _loc6_.v) * _loc36_;
                        if(_loc38_)
                        {
                           _loc10_.normalX = _loc6_.normalX + (_loc7_.normalX - _loc6_.normalX) * _loc36_;
                           _loc10_.normalY = _loc6_.normalY + (_loc7_.normalY - _loc6_.normalY) * _loc36_;
                           _loc10_.normalZ = _loc6_.normalZ + (_loc7_.normalZ - _loc6_.normalZ) * _loc36_;
                        }
                        _loc15_ = _loc11_.create();
                        _loc15_.vertex = _loc10_;
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc15_;
                        }
                        else
                        {
                           _loc12_ = _loc15_;
                        }
                        _loc13_ = _loc15_;
                     }
                     if(_loc21_ < _loc32_)
                     {
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc11_;
                        }
                        else
                        {
                           _loc12_ = _loc11_;
                        }
                        _loc13_ = _loc11_;
                        _loc11_.next = null;
                     }
                     else
                     {
                        _loc11_.vertex = null;
                        _loc11_.next = Wrapper.collector;
                        Wrapper.collector = _loc11_;
                     }
                     _loc6_ = _loc7_;
                     _loc18_ = _loc21_;
                     _loc11_ = _loc14_;
                  }
                  if(_loc12_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               if(_loc35_ & 4)
               {
                  _loc6_ = _loc13_.vertex;
                  _loc16_ = _loc6_.cameraX;
                  _loc18_ = _loc6_.cameraZ;
                  _loc11_ = _loc12_;
                  _loc12_ = null;
                  _loc13_ = null;
                  while(_loc11_ != null)
                  {
                     _loc14_ = _loc11_.next;
                     _loc7_ = _loc11_.vertex;
                     _loc19_ = _loc7_.cameraX;
                     _loc21_ = _loc7_.cameraZ;
                     if(_loc21_ > -_loc19_ && _loc18_ <= -_loc16_ || _loc21_ <= -_loc19_ && _loc18_ > -_loc16_)
                     {
                        _loc36_ = (_loc16_ + _loc18_) / (_loc16_ + _loc18_ - _loc19_ - _loc21_);
                        _loc10_ = _loc7_.create();
                        this.lastVertex.next = _loc10_;
                        this.lastVertex = _loc10_;
                        _loc10_.cameraX = _loc16_ + (_loc19_ - _loc16_) * _loc36_;
                        _loc10_.cameraY = _loc6_.cameraY + (_loc7_.cameraY - _loc6_.cameraY) * _loc36_;
                        _loc10_.cameraZ = _loc18_ + (_loc21_ - _loc18_) * _loc36_;
                        _loc10_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc36_;
                        _loc10_.y = _loc6_.y + (_loc7_.y - _loc6_.y) * _loc36_;
                        _loc10_.z = _loc6_.z + (_loc7_.z - _loc6_.z) * _loc36_;
                        _loc10_.u = _loc6_.u + (_loc7_.u - _loc6_.u) * _loc36_;
                        _loc10_.v = _loc6_.v + (_loc7_.v - _loc6_.v) * _loc36_;
                        if(_loc38_)
                        {
                           _loc10_.normalX = _loc6_.normalX + (_loc7_.normalX - _loc6_.normalX) * _loc36_;
                           _loc10_.normalY = _loc6_.normalY + (_loc7_.normalY - _loc6_.normalY) * _loc36_;
                           _loc10_.normalZ = _loc6_.normalZ + (_loc7_.normalZ - _loc6_.normalZ) * _loc36_;
                        }
                        _loc15_ = _loc11_.create();
                        _loc15_.vertex = _loc10_;
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc15_;
                        }
                        else
                        {
                           _loc12_ = _loc15_;
                        }
                        _loc13_ = _loc15_;
                     }
                     if(_loc21_ > -_loc19_)
                     {
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc11_;
                        }
                        else
                        {
                           _loc12_ = _loc11_;
                        }
                        _loc13_ = _loc11_;
                        _loc11_.next = null;
                     }
                     else
                     {
                        _loc11_.vertex = null;
                        _loc11_.next = Wrapper.collector;
                        Wrapper.collector = _loc11_;
                     }
                     _loc6_ = _loc7_;
                     _loc16_ = _loc19_;
                     _loc18_ = _loc21_;
                     _loc11_ = _loc14_;
                  }
                  if(_loc12_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               if(_loc35_ & 8)
               {
                  _loc6_ = _loc13_.vertex;
                  _loc16_ = _loc6_.cameraX;
                  _loc18_ = _loc6_.cameraZ;
                  _loc11_ = _loc12_;
                  _loc12_ = null;
                  _loc13_ = null;
                  while(_loc11_ != null)
                  {
                     _loc14_ = _loc11_.next;
                     _loc7_ = _loc11_.vertex;
                     _loc19_ = _loc7_.cameraX;
                     _loc21_ = _loc7_.cameraZ;
                     if(_loc21_ > _loc19_ && _loc18_ <= _loc16_ || _loc21_ <= _loc19_ && _loc18_ > _loc16_)
                     {
                        _loc36_ = (_loc18_ - _loc16_) / (_loc18_ - _loc16_ + _loc19_ - _loc21_);
                        _loc10_ = _loc7_.create();
                        this.lastVertex.next = _loc10_;
                        this.lastVertex = _loc10_;
                        _loc10_.cameraX = _loc16_ + (_loc19_ - _loc16_) * _loc36_;
                        _loc10_.cameraY = _loc6_.cameraY + (_loc7_.cameraY - _loc6_.cameraY) * _loc36_;
                        _loc10_.cameraZ = _loc18_ + (_loc21_ - _loc18_) * _loc36_;
                        _loc10_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc36_;
                        _loc10_.y = _loc6_.y + (_loc7_.y - _loc6_.y) * _loc36_;
                        _loc10_.z = _loc6_.z + (_loc7_.z - _loc6_.z) * _loc36_;
                        _loc10_.u = _loc6_.u + (_loc7_.u - _loc6_.u) * _loc36_;
                        _loc10_.v = _loc6_.v + (_loc7_.v - _loc6_.v) * _loc36_;
                        if(_loc38_)
                        {
                           _loc10_.normalX = _loc6_.normalX + (_loc7_.normalX - _loc6_.normalX) * _loc36_;
                           _loc10_.normalY = _loc6_.normalY + (_loc7_.normalY - _loc6_.normalY) * _loc36_;
                           _loc10_.normalZ = _loc6_.normalZ + (_loc7_.normalZ - _loc6_.normalZ) * _loc36_;
                        }
                        _loc15_ = _loc11_.create();
                        _loc15_.vertex = _loc10_;
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc15_;
                        }
                        else
                        {
                           _loc12_ = _loc15_;
                        }
                        _loc13_ = _loc15_;
                     }
                     if(_loc21_ > _loc19_)
                     {
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc11_;
                        }
                        else
                        {
                           _loc12_ = _loc11_;
                        }
                        _loc13_ = _loc11_;
                        _loc11_.next = null;
                     }
                     else
                     {
                        _loc11_.vertex = null;
                        _loc11_.next = Wrapper.collector;
                        Wrapper.collector = _loc11_;
                     }
                     _loc6_ = _loc7_;
                     _loc16_ = _loc19_;
                     _loc18_ = _loc21_;
                     _loc11_ = _loc14_;
                  }
                  if(_loc12_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               if(_loc35_ & 16)
               {
                  _loc6_ = _loc13_.vertex;
                  _loc17_ = _loc6_.cameraY;
                  _loc18_ = _loc6_.cameraZ;
                  _loc11_ = _loc12_;
                  _loc12_ = null;
                  _loc13_ = null;
                  while(_loc11_ != null)
                  {
                     _loc14_ = _loc11_.next;
                     _loc7_ = _loc11_.vertex;
                     _loc20_ = _loc7_.cameraY;
                     _loc21_ = _loc7_.cameraZ;
                     if(_loc21_ > -_loc20_ && _loc18_ <= -_loc17_ || _loc21_ <= -_loc20_ && _loc18_ > -_loc17_)
                     {
                        _loc36_ = (_loc17_ + _loc18_) / (_loc17_ + _loc18_ - _loc20_ - _loc21_);
                        _loc10_ = _loc7_.create();
                        this.lastVertex.next = _loc10_;
                        this.lastVertex = _loc10_;
                        _loc10_.cameraX = _loc6_.cameraX + (_loc7_.cameraX - _loc6_.cameraX) * _loc36_;
                        _loc10_.cameraY = _loc17_ + (_loc20_ - _loc17_) * _loc36_;
                        _loc10_.cameraZ = _loc18_ + (_loc21_ - _loc18_) * _loc36_;
                        _loc10_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc36_;
                        _loc10_.y = _loc6_.y + (_loc7_.y - _loc6_.y) * _loc36_;
                        _loc10_.z = _loc6_.z + (_loc7_.z - _loc6_.z) * _loc36_;
                        _loc10_.u = _loc6_.u + (_loc7_.u - _loc6_.u) * _loc36_;
                        _loc10_.v = _loc6_.v + (_loc7_.v - _loc6_.v) * _loc36_;
                        if(_loc38_)
                        {
                           _loc10_.normalX = _loc6_.normalX + (_loc7_.normalX - _loc6_.normalX) * _loc36_;
                           _loc10_.normalY = _loc6_.normalY + (_loc7_.normalY - _loc6_.normalY) * _loc36_;
                           _loc10_.normalZ = _loc6_.normalZ + (_loc7_.normalZ - _loc6_.normalZ) * _loc36_;
                        }
                        _loc15_ = _loc11_.create();
                        _loc15_.vertex = _loc10_;
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc15_;
                        }
                        else
                        {
                           _loc12_ = _loc15_;
                        }
                        _loc13_ = _loc15_;
                     }
                     if(_loc21_ > -_loc20_)
                     {
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc11_;
                        }
                        else
                        {
                           _loc12_ = _loc11_;
                        }
                        _loc13_ = _loc11_;
                        _loc11_.next = null;
                     }
                     else
                     {
                        _loc11_.vertex = null;
                        _loc11_.next = Wrapper.collector;
                        Wrapper.collector = _loc11_;
                     }
                     _loc6_ = _loc7_;
                     _loc17_ = _loc20_;
                     _loc18_ = _loc21_;
                     _loc11_ = _loc14_;
                  }
                  if(_loc12_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               if(_loc35_ & 32)
               {
                  _loc6_ = _loc13_.vertex;
                  _loc17_ = _loc6_.cameraY;
                  _loc18_ = _loc6_.cameraZ;
                  _loc11_ = _loc12_;
                  _loc12_ = null;
                  _loc13_ = null;
                  while(_loc11_ != null)
                  {
                     _loc14_ = _loc11_.next;
                     _loc7_ = _loc11_.vertex;
                     _loc20_ = _loc7_.cameraY;
                     _loc21_ = _loc7_.cameraZ;
                     if(_loc21_ > _loc20_ && _loc18_ <= _loc17_ || _loc21_ <= _loc20_ && _loc18_ > _loc17_)
                     {
                        _loc36_ = (_loc18_ - _loc17_) / (_loc18_ - _loc17_ + _loc20_ - _loc21_);
                        _loc10_ = _loc7_.create();
                        this.lastVertex.next = _loc10_;
                        this.lastVertex = _loc10_;
                        _loc10_.cameraX = _loc6_.cameraX + (_loc7_.cameraX - _loc6_.cameraX) * _loc36_;
                        _loc10_.cameraY = _loc17_ + (_loc20_ - _loc17_) * _loc36_;
                        _loc10_.cameraZ = _loc18_ + (_loc21_ - _loc18_) * _loc36_;
                        _loc10_.x = _loc6_.x + (_loc7_.x - _loc6_.x) * _loc36_;
                        _loc10_.y = _loc6_.y + (_loc7_.y - _loc6_.y) * _loc36_;
                        _loc10_.z = _loc6_.z + (_loc7_.z - _loc6_.z) * _loc36_;
                        _loc10_.u = _loc6_.u + (_loc7_.u - _loc6_.u) * _loc36_;
                        _loc10_.v = _loc6_.v + (_loc7_.v - _loc6_.v) * _loc36_;
                        if(_loc38_)
                        {
                           _loc10_.normalX = _loc6_.normalX + (_loc7_.normalX - _loc6_.normalX) * _loc36_;
                           _loc10_.normalY = _loc6_.normalY + (_loc7_.normalY - _loc6_.normalY) * _loc36_;
                           _loc10_.normalZ = _loc6_.normalZ + (_loc7_.normalZ - _loc6_.normalZ) * _loc36_;
                        }
                        _loc15_ = _loc11_.create();
                        _loc15_.vertex = _loc10_;
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc15_;
                        }
                        else
                        {
                           _loc12_ = _loc15_;
                        }
                        _loc13_ = _loc15_;
                     }
                     if(_loc21_ > _loc20_)
                     {
                        if(_loc12_ != null)
                        {
                           _loc13_.next = _loc11_;
                        }
                        else
                        {
                           _loc12_ = _loc11_;
                        }
                        _loc13_ = _loc11_;
                        _loc11_.next = null;
                     }
                     else
                     {
                        _loc11_.vertex = null;
                        _loc11_.next = Wrapper.collector;
                        Wrapper.collector = _loc11_;
                     }
                     _loc6_ = _loc7_;
                     _loc17_ = _loc20_;
                     _loc18_ = _loc21_;
                     _loc11_ = _loc14_;
                  }
                  if(_loc12_ == null)
                  {
                     _loc37_.processNext = null;
                     continue;
                  }
               }
               _loc37_.processNext = null;
               _loc39_ = _loc37_.create();
               _loc39_.material = _loc37_.material;
               this.lastFace.next = _loc39_;
               this.lastFace = _loc39_;
               _loc39_.wrapper = _loc12_;
               _loc37_ = _loc39_;
            }
            if(_loc3_ != null)
            {
               _loc4_.processNext = _loc37_;
            }
            else
            {
               _loc3_ = _loc37_;
            }
            _loc4_ = _loc37_;
         }
         if(_loc4_ != null)
         {
            _loc4_.processNext = null;
         }
         return _loc3_;
      }
   }
}
