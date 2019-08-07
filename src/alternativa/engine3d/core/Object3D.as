package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   use namespace alternativa3d;
   
   [Event(name="click",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="doubleClick",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseDown",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseUp",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseOver",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseOut",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="rollOver",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="rollOut",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseMove",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseWheel",type="alternativa.engine3d.core.MouseEvent3D")]
   public class Object3D implements IEventDispatcher
   {
      
      alternativa3d static const boundVertexList:Vertex = Vertex.createList(8);
      
      alternativa3d static const tA:Object3D = new Object3D();
      
      alternativa3d static const tB:Object3D = new Object3D();
      
      private static const staticSphere:Vector3D = new Vector3D();
       
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var z:Number = 0;
      
      public var rotationX:Number = 0;
      
      public var rotationY:Number = 0;
      
      public var rotationZ:Number = 0;
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      public var scaleZ:Number = 1;
      
      public var name:String;
      
      public var visible:Boolean = true;
      
      public var alpha:Number = 1;
      
      public var blendMode:String = "normal";
      
      public var colorTransform:ColorTransform = null;
      
      public var filters:Array = null;
      
      public var mouseEnabled:Boolean = true;
      
      public var doubleClickEnabled:Boolean = false;
      
      public var useHandCursor:Boolean = false;
      
      public var depthMapAlphaThreshold:Number = 1;
      
      public var shadowMapAlphaThreshold:Number = 1;
      
      public var softAttenuation:Number = 0;
      
      public var useShadowMap:Boolean = true;
      
      public var useLight:Boolean = true;
      
      public var boundMinX:Number = -1.0E22;
      
      public var boundMinY:Number = -1.0E22;
      
      public var boundMinZ:Number = -1.0E22;
      
      public var boundMaxX:Number = 1.0E22;
      
      public var boundMaxY:Number = 1.0E22;
      
      public var boundMaxZ:Number = 1.0E22;
      
      alternativa3d var ma:Number;
      
      alternativa3d var mb:Number;
      
      alternativa3d var mc:Number;
      
      alternativa3d var md:Number;
      
      alternativa3d var me:Number;
      
      alternativa3d var mf:Number;
      
      alternativa3d var mg:Number;
      
      alternativa3d var mh:Number;
      
      alternativa3d var mi:Number;
      
      alternativa3d var mj:Number;
      
      alternativa3d var mk:Number;
      
      alternativa3d var ml:Number;
      
      alternativa3d var ima:Number;
      
      alternativa3d var imb:Number;
      
      alternativa3d var imc:Number;
      
      alternativa3d var imd:Number;
      
      alternativa3d var ime:Number;
      
      alternativa3d var imf:Number;
      
      alternativa3d var img:Number;
      
      alternativa3d var imh:Number;
      
      alternativa3d var imi:Number;
      
      alternativa3d var imj:Number;
      
      alternativa3d var imk:Number;
      
      alternativa3d var iml:Number;
      
      alternativa3d var _parent:Object3DContainer;
      
      alternativa3d var next:Object3D;
      
      alternativa3d var culling:int = 0;
      
      alternativa3d var transformId:int = 0;
      
      alternativa3d var distance:Number;
      
      alternativa3d var concatenatedAlpha:Number = 1;
      
      alternativa3d var concatenatedBlendMode:String = "normal";
      
      alternativa3d var concatenatedColorTransform:ColorTransform = null;
      
      alternativa3d var bubbleListeners:Object;
      
      alternativa3d var captureListeners:Object;
      
      public var useDepth:Boolean = true;
      
      alternativa3d var transformConst:Vector.<Number>;
      
      alternativa3d var colorConst:Vector.<Number>;
      
      public function Object3D()
      {
         this.transformConst = new Vector.<Number>(12);
         this.colorConst = Vector.<Number>([0,0,0,1,0,0,0,1]);
         super();
      }
      
      public function get matrix() : Matrix3D
      {
         tA.composeMatrixFromSource(this);
         return new Matrix3D(Vector.<Number>([tA.ma,tA.me,tA.mi,0,tA.mb,tA.mf,tA.mj,0,tA.mc,tA.mg,tA.mk,0,tA.md,tA.mh,tA.ml,1]));
      }
      
      public function set matrix(param1:Matrix3D) : void
      {
         var _loc2_:Vector.<Vector3D> = param1.decompose();
         var _loc3_:Vector3D = _loc2_[0];
         var _loc4_:Vector3D = _loc2_[1];
         var _loc5_:Vector3D = _loc2_[2];
         this.x = _loc3_.x;
         this.y = _loc3_.y;
         this.z = _loc3_.z;
         this.rotationX = _loc4_.x;
         this.rotationY = _loc4_.y;
         this.rotationZ = _loc4_.z;
         this.scaleX = _loc5_.x;
         this.scaleY = _loc5_.y;
         this.scaleZ = _loc5_.z;
      }
      
      public function get concatenatedMatrix() : Matrix3D
      {
         tA.composeMatrixFromSource(this);
         var _loc1_:Object3D = this;
         while(_loc1_._parent != null)
         {
            _loc1_ = _loc1_._parent;
            tB.composeMatrixFromSource(_loc1_);
            tA.appendMatrix(tB);
         }
         return new Matrix3D(Vector.<Number>([tA.ma,tA.me,tA.mi,0,tA.mb,tA.mf,tA.mj,0,tA.mc,tA.mg,tA.mk,0,tA.md,tA.mh,tA.ml,1]));
      }
      
      public function localToGlobal(param1:Vector3D) : Vector3D
      {
         var _loc3_:Vector3D = null;
         tA.composeMatrixFromSource(this);
         var _loc2_:Object3D = this;
         while(_loc2_._parent != null)
         {
            _loc2_ = _loc2_._parent;
            tB.composeMatrixFromSource(_loc2_);
            tA.appendMatrix(tB);
         }
         _loc3_ = new Vector3D();
         _loc3_.x = tA.ma * param1.x + tA.mb * param1.y + tA.mc * param1.z + tA.md;
         _loc3_.y = tA.me * param1.x + tA.mf * param1.y + tA.mg * param1.z + tA.mh;
         _loc3_.z = tA.mi * param1.x + tA.mj * param1.y + tA.mk * param1.z + tA.ml;
         return _loc3_;
      }
      
      public function globalToLocal(param1:Vector3D) : Vector3D
      {
         var _loc3_:Vector3D = null;
         tA.composeMatrixFromSource(this);
         var _loc2_:Object3D = this;
         while(_loc2_._parent != null)
         {
            _loc2_ = _loc2_._parent;
            tB.composeMatrixFromSource(_loc2_);
            tA.appendMatrix(tB);
         }
         tA.invertMatrix();
         _loc3_ = new Vector3D();
         _loc3_.x = tA.ma * param1.x + tA.mb * param1.y + tA.mc * param1.z + tA.md;
         _loc3_.y = tA.me * param1.x + tA.mf * param1.y + tA.mg * param1.z + tA.mh;
         _loc3_.z = tA.mi * param1.x + tA.mj * param1.y + tA.mk * param1.z + tA.ml;
         return _loc3_;
      }
      
      public function get parent() : Object3DContainer
      {
         return this._parent;
      }
      
      alternativa3d function setParent(param1:Object3DContainer) : void
      {
         this._parent = param1;
      }
      
      public function calculateBounds() : void
      {
         this.boundMinX = 1.0e22;
         this.boundMinY = 1.0e22;
         this.boundMinZ = 1.0e22;
         this.boundMaxX = -1.0e22;
         this.boundMaxY = -1.0e22;
         this.boundMaxZ = -1.0e22;
         this.updateBounds(this,null);
         if(this.boundMinX > this.boundMaxX)
         {
            this.boundMinX = -1.0e22;
            this.boundMinY = -1.0e22;
            this.boundMinZ = -1.0e22;
            this.boundMaxX = 1.0e22;
            this.boundMaxY = 1.0e22;
            this.boundMaxZ = 1.0e22;
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:Object = null;
         if(param2 == null)
         {
            throw new TypeError("Parameter listener must be non-null.");
         }
         if(param3)
         {
            if(this.captureListeners == null)
            {
               this.captureListeners = new Object();
            }
            _loc6_ = this.captureListeners;
         }
         else
         {
            if(this.bubbleListeners == null)
            {
               this.bubbleListeners = new Object();
            }
            _loc6_ = this.bubbleListeners;
         }
         var _loc7_:Vector.<Function> = _loc6_[param1];
         if(_loc7_ == null)
         {
            _loc7_ = new Vector.<Function>();
            _loc6_[param1] = _loc7_;
         }
         if(_loc7_.indexOf(param2) < 0)
         {
            _loc7_.push(param2);
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc5_:Vector.<Function> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         if(param2 == null)
         {
            throw new TypeError("Parameter listener must be non-null.");
         }
         var _loc4_:Object = !!param3?this.captureListeners:this.bubbleListeners;
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_[param1];
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.indexOf(param2);
               if(_loc6_ >= 0)
               {
                  _loc7_ = _loc5_.length;
                  _loc8_ = _loc6_ + 1;
                  while(_loc8_ < _loc7_)
                  {
                     _loc5_[_loc6_] = _loc5_[_loc8_];
                     _loc8_++;
                     _loc6_++;
                  }
                  if(_loc7_ > 1)
                  {
                     _loc5_.length = _loc7_ - 1;
                  }
                  else
                  {
                     delete _loc4_[param1];
                     for(_loc9_ in _loc4_)
                     {
                     }
                     if(!_loc9_)
                     {
                        if(_loc4_ == this.captureListeners)
                        {
                           this.captureListeners = null;
                        }
                        else
                        {
                           this.bubbleListeners = null;
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.captureListeners != null && this.captureListeners[param1] || this.bubbleListeners != null && this.bubbleListeners[param1];
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         var _loc2_:Object3D = this;
         while(_loc2_ != null)
         {
            if(_loc2_.captureListeners != null && _loc2_.captureListeners[param1] || _loc2_.bubbleListeners != null && _loc2_.bubbleListeners[param1])
            {
               return true;
            }
            _loc2_ = _loc2_._parent;
         }
         return false;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         var _loc4_:Object3D = null;
         var _loc6_:Vector.<Function> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<Function> = null;
         if(param1 == null)
         {
            throw new TypeError("Parameter event must be non-null.");
         }
         if(param1 is MouseEvent3D)
         {
            MouseEvent3D(param1)._target = this;
         }
         var _loc2_:Vector.<Object3D> = new Vector.<Object3D>();
         var _loc3_:int = 0;
         _loc4_ = this;
         while(_loc4_ != null)
         {
            _loc2_[_loc3_] = _loc4_;
            _loc3_++;
            _loc4_ = _loc4_._parent;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_];
            if(param1 is MouseEvent3D)
            {
               MouseEvent3D(param1)._currentTarget = _loc4_;
            }
            if(this.bubbleListeners != null)
            {
               _loc6_ = this.bubbleListeners[param1.type];
               if(_loc6_ != null)
               {
                  _loc8_ = _loc6_.length;
                  _loc9_ = new Vector.<Function>();
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     _loc9_[_loc7_] = _loc6_[_loc7_];
                     _loc7_++;
                  }
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     (_loc9_[_loc7_] as Function).call(null,param1);
                     _loc7_++;
                  }
               }
            }
            if(!param1.bubbles)
            {
               break;
            }
            _loc5_++;
         }
         return true;
      }
      
      public function calculateResolution(param1:int, param2:int, param3:int = 1, param4:Matrix3D = null) : Number
      {
         return 1;
      }
      
      public function intersectRay(param1:Vector3D, param2:Vector3D, param3:Dictionary = null, param4:Camera3D = null) : RayIntersectionData
      {
         return null;
      }
      
      alternativa3d function checkIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Dictionary) : Boolean
      {
         return false;
      }
      
      alternativa3d function boundCheckIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number) : Boolean
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc14_:Number = param1 + param4 * param7;
         var _loc15_:Number = param2 + param5 * param7;
         var _loc16_:Number = param3 + param6 * param7;
         if(param1 >= param8 && param1 <= param11 && param2 >= param9 && param2 <= param12 && param3 >= param10 && param3 <= param13 || _loc14_ >= param8 && _loc14_ <= param11 && _loc15_ >= param9 && _loc15_ <= param12 && _loc16_ >= param10 && _loc16_ <= param13)
         {
            return true;
         }
         if(param1 < param8 && _loc14_ < param8 || param1 > param11 && _loc14_ > param11 || param2 < param9 && _loc15_ < param9 || param2 > param12 && _loc15_ > param12 || param3 < param10 && _loc16_ < param10 || param3 > param13 && _loc16_ > param13)
         {
            return false;
         }
         var _loc21_:Number = 1.0e-6;
         if(param4 > _loc21_)
         {
            _loc17_ = (param8 - param1) / param4;
            _loc18_ = (param11 - param1) / param4;
         }
         else if(param4 < -_loc21_)
         {
            _loc17_ = (param11 - param1) / param4;
            _loc18_ = (param8 - param1) / param4;
         }
         else
         {
            _loc17_ = 0;
            _loc18_ = param7;
         }
         if(param5 > _loc21_)
         {
            _loc19_ = (param9 - param2) / param5;
            _loc20_ = (param12 - param2) / param5;
         }
         else if(param5 < -_loc21_)
         {
            _loc19_ = (param12 - param2) / param5;
            _loc20_ = (param9 - param2) / param5;
         }
         else
         {
            _loc19_ = 0;
            _loc20_ = param7;
         }
         if(_loc19_ >= _loc18_ || _loc20_ <= _loc17_)
         {
            return false;
         }
         if(_loc19_ < _loc17_)
         {
            if(_loc20_ < _loc18_)
            {
               _loc18_ = _loc20_;
            }
         }
         else
         {
            _loc17_ = _loc19_;
            if(_loc20_ < _loc18_)
            {
               _loc18_ = _loc20_;
            }
         }
         if(param6 > _loc21_)
         {
            _loc19_ = (param10 - param3) / param6;
            _loc20_ = (param13 - param3) / param6;
         }
         else if(param6 < -_loc21_)
         {
            _loc19_ = (param13 - param3) / param6;
            _loc20_ = (param10 - param3) / param6;
         }
         else
         {
            _loc19_ = 0;
            _loc20_ = param7;
         }
         if(_loc19_ >= _loc18_ || _loc20_ <= _loc17_)
         {
            return false;
         }
         return true;
      }
      
      public function clone() : Object3D
      {
         var _loc1_:Object3D = new Object3D();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      protected function clonePropertiesFrom(param1:Object3D) : void
      {
         this.name = param1.name;
         this.visible = param1.visible;
         this.alpha = param1.alpha;
         this.blendMode = param1.blendMode;
         this.mouseEnabled = param1.mouseEnabled;
         this.doubleClickEnabled = param1.doubleClickEnabled;
         this.useHandCursor = param1.useHandCursor;
         this.depthMapAlphaThreshold = param1.depthMapAlphaThreshold;
         this.shadowMapAlphaThreshold = param1.shadowMapAlphaThreshold;
         this.softAttenuation = param1.softAttenuation;
         this.useShadowMap = param1.useShadowMap;
         this.useLight = param1.useLight;
         this.transformId = param1.transformId;
         this.distance = param1.distance;
         if(param1.colorTransform != null)
         {
            this.colorTransform = new ColorTransform();
            this.colorTransform.concat(param1.colorTransform);
         }
         if(param1.filters != null)
         {
            this.filters = new Array().concat(param1.filters);
         }
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         this.rotationX = param1.rotationX;
         this.rotationY = param1.rotationY;
         this.rotationZ = param1.rotationZ;
         this.scaleX = param1.scaleX;
         this.scaleY = param1.scaleY;
         this.scaleZ = param1.scaleZ;
         this.boundMinX = param1.boundMinX;
         this.boundMinY = param1.boundMinY;
         this.boundMinZ = param1.boundMinZ;
         this.boundMaxX = param1.boundMaxX;
         this.boundMaxY = param1.boundMaxY;
         this.boundMaxZ = param1.boundMaxZ;
      }
      
      public function toString() : String
      {
         var _loc1_:String = getQualifiedClassName(this);
         return "[" + _loc1_.substr(_loc1_.indexOf("::") + 2) + " " + this.name + "]";
      }
      
      alternativa3d function draw(param1:Camera3D) : void
      {
      }
      
      alternativa3d function getVG(param1:Camera3D) : VG
      {
         return null;
      }
      
      alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
      }
      
      alternativa3d function concat(param1:Object3DContainer) : void
      {
         this.concatenatedAlpha = param1.concatenatedAlpha * this.alpha;
         this.concatenatedBlendMode = param1.concatenatedBlendMode != "normal"?param1.concatenatedBlendMode:this.blendMode;
         if(param1.concatenatedColorTransform != null)
         {
            if(this.colorTransform != null)
            {
               this.concatenatedColorTransform = new ColorTransform();
               this.concatenatedColorTransform.redMultiplier = param1.concatenatedColorTransform.redMultiplier;
               this.concatenatedColorTransform.greenMultiplier = param1.concatenatedColorTransform.greenMultiplier;
               this.concatenatedColorTransform.blueMultiplier = param1.concatenatedColorTransform.blueMultiplier;
               this.concatenatedColorTransform.redOffset = param1.concatenatedColorTransform.redOffset;
               this.concatenatedColorTransform.greenOffset = param1.concatenatedColorTransform.greenOffset;
               this.concatenatedColorTransform.blueOffset = param1.concatenatedColorTransform.blueOffset;
               this.concatenatedColorTransform.concat(this.colorTransform);
            }
            else
            {
               this.concatenatedColorTransform = param1.concatenatedColorTransform;
            }
         }
         else
         {
            this.concatenatedColorTransform = this.colorTransform;
         }
         if(this.concatenatedColorTransform != null)
         {
            this.colorConst[0] = this.concatenatedColorTransform.redMultiplier;
            this.colorConst[1] = this.concatenatedColorTransform.greenMultiplier;
            this.colorConst[2] = this.concatenatedColorTransform.blueMultiplier;
            this.colorConst[3] = this.concatenatedAlpha;
            this.colorConst[4] = this.concatenatedColorTransform.redOffset / 255;
            this.colorConst[5] = this.concatenatedColorTransform.greenOffset / 255;
            this.colorConst[6] = this.concatenatedColorTransform.blueOffset / 255;
         }
         else
         {
            this.colorConst[3] = this.concatenatedAlpha;
         }
      }
      
      alternativa3d function boundIntersectRay(param1:Vector3D, param2:Vector3D, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(param1.x >= param3 && param1.x <= param6 && param1.y >= param4 && param1.y <= param7 && param1.z >= param5 && param1.z <= param8)
         {
            return true;
         }
         if(param1.x < param3 && param2.x <= 0 || param1.x > param6 && param2.x >= 0 || param1.y < param4 && param2.y <= 0 || param1.y > param7 && param2.y >= 0 || param1.z < param5 && param2.z <= 0 || param1.z > param8 && param2.z >= 0)
         {
            return false;
         }
         var _loc13_:Number = 1.0e-6;
         if(param2.x > _loc13_)
         {
            _loc9_ = (param3 - param1.x) / param2.x;
            _loc10_ = (param6 - param1.x) / param2.x;
         }
         else if(param2.x < -_loc13_)
         {
            _loc9_ = (param6 - param1.x) / param2.x;
            _loc10_ = (param3 - param1.x) / param2.x;
         }
         else
         {
            _loc9_ = 0;
            _loc10_ = 1.0e22;
         }
         if(param2.y > _loc13_)
         {
            _loc11_ = (param4 - param1.y) / param2.y;
            _loc12_ = (param7 - param1.y) / param2.y;
         }
         else if(param2.y < -_loc13_)
         {
            _loc11_ = (param7 - param1.y) / param2.y;
            _loc12_ = (param4 - param1.y) / param2.y;
         }
         else
         {
            _loc11_ = 0;
            _loc12_ = 1.0e22;
         }
         if(_loc11_ >= _loc10_ || _loc12_ <= _loc9_)
         {
            return false;
         }
         if(_loc11_ < _loc9_)
         {
            if(_loc12_ < _loc10_)
            {
               _loc10_ = _loc12_;
            }
         }
         else
         {
            _loc9_ = _loc11_;
            if(_loc12_ < _loc10_)
            {
               _loc10_ = _loc12_;
            }
         }
         if(param2.z > _loc13_)
         {
            _loc11_ = (param5 - param1.z) / param2.z;
            _loc12_ = (param8 - param1.z) / param2.z;
         }
         else if(param2.z < -_loc13_)
         {
            _loc11_ = (param8 - param1.z) / param2.z;
            _loc12_ = (param5 - param1.z) / param2.z;
         }
         else
         {
            _loc11_ = 0;
            _loc12_ = 1.0e22;
         }
         if(_loc11_ >= _loc10_ || _loc12_ <= _loc9_)
         {
            return false;
         }
         return true;
      }
      
      alternativa3d function collectPlanes(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector.<Face>, param7:Dictionary = null) : void
      {
      }
      
      alternativa3d function calculateSphere(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector3D = null) : Vector3D
      {
         this.calculateInverseMatrix();
         var _loc7_:Number = this.ima * param1.x + this.imb * param1.y + this.imc * param1.z + this.imd;
         var _loc8_:Number = this.ime * param1.x + this.imf * param1.y + this.img * param1.z + this.imh;
         var _loc9_:Number = this.imi * param1.x + this.imj * param1.y + this.imk * param1.z + this.iml;
         var _loc10_:Number = this.ima * param2.x + this.imb * param2.y + this.imc * param2.z + this.imd;
         var _loc11_:Number = this.ime * param2.x + this.imf * param2.y + this.img * param2.z + this.imh;
         var _loc12_:Number = this.imi * param2.x + this.imj * param2.y + this.imk * param2.z + this.iml;
         var _loc13_:Number = this.ima * param3.x + this.imb * param3.y + this.imc * param3.z + this.imd;
         var _loc14_:Number = this.ime * param3.x + this.imf * param3.y + this.img * param3.z + this.imh;
         var _loc15_:Number = this.imi * param3.x + this.imj * param3.y + this.imk * param3.z + this.iml;
         var _loc16_:Number = this.ima * param4.x + this.imb * param4.y + this.imc * param4.z + this.imd;
         var _loc17_:Number = this.ime * param4.x + this.imf * param4.y + this.img * param4.z + this.imh;
         var _loc18_:Number = this.imi * param4.x + this.imj * param4.y + this.imk * param4.z + this.iml;
         var _loc19_:Number = this.ima * param5.x + this.imb * param5.y + this.imc * param5.z + this.imd;
         var _loc20_:Number = this.ime * param5.x + this.imf * param5.y + this.img * param5.z + this.imh;
         var _loc21_:Number = this.imi * param5.x + this.imj * param5.y + this.imk * param5.z + this.iml;
         var _loc22_:Number = _loc10_ - _loc7_;
         var _loc23_:Number = _loc11_ - _loc8_;
         var _loc24_:Number = _loc12_ - _loc9_;
         var _loc25_:Number = _loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_;
         _loc22_ = _loc13_ - _loc7_;
         _loc23_ = _loc14_ - _loc8_;
         _loc24_ = _loc15_ - _loc9_;
         var _loc26_:Number = _loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_;
         if(_loc26_ > _loc25_)
         {
            _loc25_ = _loc26_;
         }
         _loc22_ = _loc16_ - _loc7_;
         _loc23_ = _loc17_ - _loc8_;
         _loc24_ = _loc18_ - _loc9_;
         _loc26_ = _loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_;
         if(_loc26_ > _loc25_)
         {
            _loc25_ = _loc26_;
         }
         _loc22_ = _loc19_ - _loc7_;
         _loc23_ = _loc20_ - _loc8_;
         _loc24_ = _loc21_ - _loc9_;
         _loc26_ = _loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_;
         if(_loc26_ > _loc25_)
         {
            _loc25_ = _loc26_;
         }
         if(param6 == null)
         {
            param6 = staticSphere;
         }
         param6.x = _loc7_;
         param6.y = _loc8_;
         param6.z = _loc9_;
         param6.w = Math.sqrt(_loc25_);
         return param6;
      }
      
      alternativa3d function boundIntersectSphere(param1:Vector3D, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Boolean
      {
         return param1.x + param1.w > param2 && param1.x - param1.w < param5 && param1.y + param1.w > param3 && param1.y - param1.w < param6 && param1.z + param1.w > param4 && param1.z - param1.w < param7;
      }
      
      alternativa3d function split(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Number) : Vector.<Object3D>
      {
         return new Vector.<Object3D>(2);
      }
      
      alternativa3d function testSplit(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Number) : int
      {
         var _loc5_:Vector3D = this.calculatePlane(param1,param2,param3);
         if(_loc5_.x >= 0)
         {
            if(_loc5_.y >= 0)
            {
               if(_loc5_.z >= 0)
               {
                  if(this.boundMaxX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMaxZ * _loc5_.z <= _loc5_.w + param4)
                  {
                     return -1;
                  }
                  if(this.boundMinX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMinZ * _loc5_.z >= _loc5_.w - param4)
                  {
                     return 1;
                  }
               }
               else
               {
                  if(this.boundMaxX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMinZ * _loc5_.z <= _loc5_.w + param4)
                  {
                     return -1;
                  }
                  if(this.boundMinX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMaxZ * _loc5_.z >= _loc5_.w - param4)
                  {
                     return 1;
                  }
               }
            }
            else if(_loc5_.z >= 0)
            {
               if(this.boundMaxX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMaxZ * _loc5_.z <= _loc5_.w + param4)
               {
                  return -1;
               }
               if(this.boundMinX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMinZ * _loc5_.z >= _loc5_.w - param4)
               {
                  return 1;
               }
            }
            else
            {
               if(this.boundMaxX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMinZ * _loc5_.z <= _loc5_.w + param4)
               {
                  return -1;
               }
               if(this.boundMinX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMaxZ * _loc5_.z >= _loc5_.w - param4)
               {
                  return 1;
               }
            }
         }
         else if(_loc5_.y >= 0)
         {
            if(_loc5_.z >= 0)
            {
               if(this.boundMinX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMaxZ * _loc5_.z <= _loc5_.w + param4)
               {
                  return -1;
               }
               if(this.boundMaxX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMinZ * _loc5_.z >= _loc5_.w - param4)
               {
                  return 1;
               }
            }
            else
            {
               if(this.boundMinX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMinZ * _loc5_.z <= _loc5_.w + param4)
               {
                  return -1;
               }
               if(this.boundMaxX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMaxZ * _loc5_.z >= _loc5_.w - param4)
               {
                  return 1;
               }
            }
         }
         else if(_loc5_.z >= 0)
         {
            if(this.boundMinX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMaxZ * _loc5_.z <= _loc5_.w + param4)
            {
               return -1;
            }
            if(this.boundMaxX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMinZ * _loc5_.z >= _loc5_.w - param4)
            {
               return 1;
            }
         }
         else
         {
            if(this.boundMinX * _loc5_.x + this.boundMinY * _loc5_.y + this.boundMinZ * _loc5_.z <= _loc5_.w + param4)
            {
               return -1;
            }
            if(this.boundMaxX * _loc5_.x + this.boundMaxY * _loc5_.y + this.boundMaxZ * _loc5_.z >= _loc5_.w - param4)
            {
               return 1;
            }
         }
         return 0;
      }
      
      alternativa3d function calculatePlane(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Vector3D
      {
         var _loc4_:Vector3D = new Vector3D();
         var _loc5_:Number = param2.x - param1.x;
         var _loc6_:Number = param2.y - param1.y;
         var _loc7_:Number = param2.z - param1.z;
         var _loc8_:Number = param3.x - param1.x;
         var _loc9_:Number = param3.y - param1.y;
         var _loc10_:Number = param3.z - param1.z;
         _loc4_.x = _loc10_ * _loc6_ - _loc9_ * _loc7_;
         _loc4_.y = _loc8_ * _loc7_ - _loc10_ * _loc5_;
         _loc4_.z = _loc9_ * _loc5_ - _loc8_ * _loc6_;
         var _loc11_:Number = _loc4_.x * _loc4_.x + _loc4_.y * _loc4_.y + _loc4_.z * _loc4_.z;
         if(_loc11_ > 0.0001)
         {
            _loc11_ = Math.sqrt(_loc11_);
            _loc4_.x = _loc4_.x / _loc11_;
            _loc4_.y = _loc4_.y / _loc11_;
            _loc4_.z = _loc4_.z / _loc11_;
         }
         _loc4_.w = param1.x * _loc4_.x + param1.y * _loc4_.y + param1.z * _loc4_.z;
         return _loc4_;
      }
      
      alternativa3d function composeMatrix() : void
      {
         var _loc1_:Number = Math.cos(this.rotationX);
         var _loc2_:Number = Math.sin(this.rotationX);
         var _loc3_:Number = Math.cos(this.rotationY);
         var _loc4_:Number = Math.sin(this.rotationY);
         var _loc5_:Number = Math.cos(this.rotationZ);
         var _loc6_:Number = Math.sin(this.rotationZ);
         var _loc7_:Number = _loc5_ * _loc4_;
         var _loc8_:Number = _loc6_ * _loc4_;
         var _loc9_:Number = _loc3_ * this.scaleX;
         var _loc10_:Number = _loc2_ * this.scaleY;
         var _loc11_:Number = _loc1_ * this.scaleY;
         var _loc12_:Number = _loc1_ * this.scaleZ;
         var _loc13_:Number = _loc2_ * this.scaleZ;
         this.ma = _loc5_ * _loc9_;
         this.mb = _loc7_ * _loc10_ - _loc6_ * _loc11_;
         this.mc = _loc7_ * _loc12_ + _loc6_ * _loc13_;
         this.md = this.x;
         this.me = _loc6_ * _loc9_;
         this.mf = _loc8_ * _loc10_ + _loc5_ * _loc11_;
         this.mg = _loc8_ * _loc12_ - _loc5_ * _loc13_;
         this.mh = this.y;
         this.mi = -_loc4_ * this.scaleX;
         this.mj = _loc3_ * _loc10_;
         this.mk = _loc3_ * _loc12_;
         this.ml = this.z;
      }
      
      alternativa3d function composeMatrixFromSource(param1:Object3D) : void
      {
         var _loc2_:Number = Math.cos(param1.rotationX);
         var _loc3_:Number = Math.sin(param1.rotationX);
         var _loc4_:Number = Math.cos(param1.rotationY);
         var _loc5_:Number = Math.sin(param1.rotationY);
         var _loc6_:Number = Math.cos(param1.rotationZ);
         var _loc7_:Number = Math.sin(param1.rotationZ);
         var _loc8_:Number = _loc6_ * _loc5_;
         var _loc9_:Number = _loc7_ * _loc5_;
         var _loc10_:Number = _loc4_ * param1.scaleX;
         var _loc11_:Number = _loc3_ * param1.scaleY;
         var _loc12_:Number = _loc2_ * param1.scaleY;
         var _loc13_:Number = _loc2_ * param1.scaleZ;
         var _loc14_:Number = _loc3_ * param1.scaleZ;
         this.ma = _loc6_ * _loc10_;
         this.mb = _loc8_ * _loc11_ - _loc7_ * _loc12_;
         this.mc = _loc8_ * _loc13_ + _loc7_ * _loc14_;
         this.md = param1.x;
         this.me = _loc7_ * _loc10_;
         this.mf = _loc9_ * _loc11_ + _loc6_ * _loc12_;
         this.mg = _loc9_ * _loc13_ - _loc6_ * _loc14_;
         this.mh = param1.y;
         this.mi = -_loc5_ * param1.scaleX;
         this.mj = _loc4_ * _loc11_;
         this.mk = _loc4_ * _loc13_;
         this.ml = param1.z;
      }
      
      alternativa3d function appendMatrix(param1:Object3D) : void
      {
         var _loc2_:Number = this.ma;
         var _loc3_:Number = this.mb;
         var _loc4_:Number = this.mc;
         var _loc5_:Number = this.md;
         var _loc6_:Number = this.me;
         var _loc7_:Number = this.mf;
         var _loc8_:Number = this.mg;
         var _loc9_:Number = this.mh;
         var _loc10_:Number = this.mi;
         var _loc11_:Number = this.mj;
         var _loc12_:Number = this.mk;
         var _loc13_:Number = this.ml;
         this.ma = param1.ma * _loc2_ + param1.mb * _loc6_ + param1.mc * _loc10_;
         this.mb = param1.ma * _loc3_ + param1.mb * _loc7_ + param1.mc * _loc11_;
         this.mc = param1.ma * _loc4_ + param1.mb * _loc8_ + param1.mc * _loc12_;
         this.md = param1.ma * _loc5_ + param1.mb * _loc9_ + param1.mc * _loc13_ + param1.md;
         this.me = param1.me * _loc2_ + param1.mf * _loc6_ + param1.mg * _loc10_;
         this.mf = param1.me * _loc3_ + param1.mf * _loc7_ + param1.mg * _loc11_;
         this.mg = param1.me * _loc4_ + param1.mf * _loc8_ + param1.mg * _loc12_;
         this.mh = param1.me * _loc5_ + param1.mf * _loc9_ + param1.mg * _loc13_ + param1.mh;
         this.mi = param1.mi * _loc2_ + param1.mj * _loc6_ + param1.mk * _loc10_;
         this.mj = param1.mi * _loc3_ + param1.mj * _loc7_ + param1.mk * _loc11_;
         this.mk = param1.mi * _loc4_ + param1.mj * _loc8_ + param1.mk * _loc12_;
         this.ml = param1.mi * _loc5_ + param1.mj * _loc9_ + param1.mk * _loc13_ + param1.ml;
      }
      
      alternativa3d function composeAndAppend(param1:Object3D) : void
      {
         var _loc2_:Number = Math.cos(this.rotationX);
         var _loc3_:Number = Math.sin(this.rotationX);
         var _loc4_:Number = Math.cos(this.rotationY);
         var _loc5_:Number = Math.sin(this.rotationY);
         var _loc6_:Number = Math.cos(this.rotationZ);
         var _loc7_:Number = Math.sin(this.rotationZ);
         var _loc8_:Number = _loc6_ * _loc5_;
         var _loc9_:Number = _loc7_ * _loc5_;
         var _loc10_:Number = _loc4_ * this.scaleX;
         var _loc11_:Number = _loc3_ * this.scaleY;
         var _loc12_:Number = _loc2_ * this.scaleY;
         var _loc13_:Number = _loc2_ * this.scaleZ;
         var _loc14_:Number = _loc3_ * this.scaleZ;
         var _loc15_:Number = _loc6_ * _loc10_;
         var _loc16_:Number = _loc8_ * _loc11_ - _loc7_ * _loc12_;
         var _loc17_:Number = _loc8_ * _loc13_ + _loc7_ * _loc14_;
         var _loc18_:Number = this.x;
         var _loc19_:Number = _loc7_ * _loc10_;
         var _loc20_:Number = _loc9_ * _loc11_ + _loc6_ * _loc12_;
         var _loc21_:Number = _loc9_ * _loc13_ - _loc6_ * _loc14_;
         var _loc22_:Number = this.y;
         var _loc23_:Number = -_loc5_ * this.scaleX;
         var _loc24_:Number = _loc4_ * _loc11_;
         var _loc25_:Number = _loc4_ * _loc13_;
         var _loc26_:Number = this.z;
         this.ma = param1.ma * _loc15_ + param1.mb * _loc19_ + param1.mc * _loc23_;
         this.mb = param1.ma * _loc16_ + param1.mb * _loc20_ + param1.mc * _loc24_;
         this.mc = param1.ma * _loc17_ + param1.mb * _loc21_ + param1.mc * _loc25_;
         this.md = param1.ma * _loc18_ + param1.mb * _loc22_ + param1.mc * _loc26_ + param1.md;
         this.me = param1.me * _loc15_ + param1.mf * _loc19_ + param1.mg * _loc23_;
         this.mf = param1.me * _loc16_ + param1.mf * _loc20_ + param1.mg * _loc24_;
         this.mg = param1.me * _loc17_ + param1.mf * _loc21_ + param1.mg * _loc25_;
         this.mh = param1.me * _loc18_ + param1.mf * _loc22_ + param1.mg * _loc26_ + param1.mh;
         this.mi = param1.mi * _loc15_ + param1.mj * _loc19_ + param1.mk * _loc23_;
         this.mj = param1.mi * _loc16_ + param1.mj * _loc20_ + param1.mk * _loc24_;
         this.mk = param1.mi * _loc17_ + param1.mj * _loc21_ + param1.mk * _loc25_;
         this.ml = param1.mi * _loc18_ + param1.mj * _loc22_ + param1.mk * _loc26_ + param1.ml;
      }
      
      alternativa3d function copyAndAppend(param1:Object3D, param2:Object3D) : void
      {
         this.ma = param2.ma * param1.ma + param2.mb * param1.me + param2.mc * param1.mi;
         this.mb = param2.ma * param1.mb + param2.mb * param1.mf + param2.mc * param1.mj;
         this.mc = param2.ma * param1.mc + param2.mb * param1.mg + param2.mc * param1.mk;
         this.md = param2.ma * param1.md + param2.mb * param1.mh + param2.mc * param1.ml + param2.md;
         this.me = param2.me * param1.ma + param2.mf * param1.me + param2.mg * param1.mi;
         this.mf = param2.me * param1.mb + param2.mf * param1.mf + param2.mg * param1.mj;
         this.mg = param2.me * param1.mc + param2.mf * param1.mg + param2.mg * param1.mk;
         this.mh = param2.me * param1.md + param2.mf * param1.mh + param2.mg * param1.ml + param2.mh;
         this.mi = param2.mi * param1.ma + param2.mj * param1.me + param2.mk * param1.mi;
         this.mj = param2.mi * param1.mb + param2.mj * param1.mf + param2.mk * param1.mj;
         this.mk = param2.mi * param1.mc + param2.mj * param1.mg + param2.mk * param1.mk;
         this.ml = param2.mi * param1.md + param2.mj * param1.mh + param2.mk * param1.ml + param2.ml;
      }
      
      alternativa3d function invertMatrix() : void
      {
         var _loc1_:Number = this.ma;
         var _loc2_:Number = this.mb;
         var _loc3_:Number = this.mc;
         var _loc4_:Number = this.md;
         var _loc5_:Number = this.me;
         var _loc6_:Number = this.mf;
         var _loc7_:Number = this.mg;
         var _loc8_:Number = this.mh;
         var _loc9_:Number = this.mi;
         var _loc10_:Number = this.mj;
         var _loc11_:Number = this.mk;
         var _loc12_:Number = this.ml;
         var _loc13_:Number = 1 / (-_loc3_ * _loc6_ * _loc9_ + _loc2_ * _loc7_ * _loc9_ + _loc3_ * _loc5_ * _loc10_ - _loc1_ * _loc7_ * _loc10_ - _loc2_ * _loc5_ * _loc11_ + _loc1_ * _loc6_ * _loc11_);
         this.ma = (-_loc7_ * _loc10_ + _loc6_ * _loc11_) * _loc13_;
         this.mb = (_loc3_ * _loc10_ - _loc2_ * _loc11_) * _loc13_;
         this.mc = (-_loc3_ * _loc6_ + _loc2_ * _loc7_) * _loc13_;
         this.md = (_loc4_ * _loc7_ * _loc10_ - _loc3_ * _loc8_ * _loc10_ - _loc4_ * _loc6_ * _loc11_ + _loc2_ * _loc8_ * _loc11_ + _loc3_ * _loc6_ * _loc12_ - _loc2_ * _loc7_ * _loc12_) * _loc13_;
         this.me = (_loc7_ * _loc9_ - _loc5_ * _loc11_) * _loc13_;
         this.mf = (-_loc3_ * _loc9_ + _loc1_ * _loc11_) * _loc13_;
         this.mg = (_loc3_ * _loc5_ - _loc1_ * _loc7_) * _loc13_;
         this.mh = (_loc3_ * _loc8_ * _loc9_ - _loc4_ * _loc7_ * _loc9_ + _loc4_ * _loc5_ * _loc11_ - _loc1_ * _loc8_ * _loc11_ - _loc3_ * _loc5_ * _loc12_ + _loc1_ * _loc7_ * _loc12_) * _loc13_;
         this.mi = (-_loc6_ * _loc9_ + _loc5_ * _loc10_) * _loc13_;
         this.mj = (_loc2_ * _loc9_ - _loc1_ * _loc10_) * _loc13_;
         this.mk = (-_loc2_ * _loc5_ + _loc1_ * _loc6_) * _loc13_;
         this.ml = (_loc4_ * _loc6_ * _loc9_ - _loc2_ * _loc8_ * _loc9_ - _loc4_ * _loc5_ * _loc10_ + _loc1_ * _loc8_ * _loc10_ + _loc2_ * _loc5_ * _loc12_ - _loc1_ * _loc6_ * _loc12_) * _loc13_;
      }
      
      alternativa3d function calculateInverseMatrix() : void
      {
         var _loc1_:Number = 1 / (-this.mc * this.mf * this.mi + this.mb * this.mg * this.mi + this.mc * this.me * this.mj - this.ma * this.mg * this.mj - this.mb * this.me * this.mk + this.ma * this.mf * this.mk);
         this.ima = (-this.mg * this.mj + this.mf * this.mk) * _loc1_;
         this.imb = (this.mc * this.mj - this.mb * this.mk) * _loc1_;
         this.imc = (-this.mc * this.mf + this.mb * this.mg) * _loc1_;
         this.imd = (this.md * this.mg * this.mj - this.mc * this.mh * this.mj - this.md * this.mf * this.mk + this.mb * this.mh * this.mk + this.mc * this.mf * this.ml - this.mb * this.mg * this.ml) * _loc1_;
         this.ime = (this.mg * this.mi - this.me * this.mk) * _loc1_;
         this.imf = (-this.mc * this.mi + this.ma * this.mk) * _loc1_;
         this.img = (this.mc * this.me - this.ma * this.mg) * _loc1_;
         this.imh = (this.mc * this.mh * this.mi - this.md * this.mg * this.mi + this.md * this.me * this.mk - this.ma * this.mh * this.mk - this.mc * this.me * this.ml + this.ma * this.mg * this.ml) * _loc1_;
         this.imi = (-this.mf * this.mi + this.me * this.mj) * _loc1_;
         this.imj = (this.mb * this.mi - this.ma * this.mj) * _loc1_;
         this.imk = (-this.mb * this.me + this.ma * this.mf) * _loc1_;
         this.iml = (this.md * this.mf * this.mi - this.mb * this.mh * this.mi - this.md * this.me * this.mj + this.ma * this.mh * this.mj + this.mb * this.me * this.ml - this.ma * this.mf * this.ml) * _loc1_;
      }
      
      alternativa3d function cullingInCamera(param1:Camera3D, param2:int) : int
      {
         var _loc4_:Vertex = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:Vertex = null;
         if(param1.occludedAll)
         {
            return -1;
         }
         var _loc3_:int = param1.numOccluders;
         if(param2 > 0 || _loc3_ > 0)
         {
            _loc4_ = boundVertexList;
            _loc4_.x = this.boundMinX;
            _loc4_.y = this.boundMinY;
            _loc4_.z = this.boundMinZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMaxX;
            _loc4_.y = this.boundMinY;
            _loc4_.z = this.boundMinZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMinX;
            _loc4_.y = this.boundMaxY;
            _loc4_.z = this.boundMinZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMaxX;
            _loc4_.y = this.boundMaxY;
            _loc4_.z = this.boundMinZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMinX;
            _loc4_.y = this.boundMinY;
            _loc4_.z = this.boundMaxZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMaxX;
            _loc4_.y = this.boundMinY;
            _loc4_.z = this.boundMaxZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMinX;
            _loc4_.y = this.boundMaxY;
            _loc4_.z = this.boundMaxZ;
            _loc4_ = _loc4_.next;
            _loc4_.x = this.boundMaxX;
            _loc4_.y = this.boundMaxY;
            _loc4_.z = this.boundMaxZ;
            _loc4_ = boundVertexList;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.x;
               _loc6_ = _loc4_.y;
               _loc7_ = _loc4_.z;
               _loc4_.cameraX = this.ma * _loc5_ + this.mb * _loc6_ + this.mc * _loc7_ + this.md;
               _loc4_.cameraY = this.me * _loc5_ + this.mf * _loc6_ + this.mg * _loc7_ + this.mh;
               _loc4_.cameraZ = this.mi * _loc5_ + this.mj * _loc6_ + this.mk * _loc7_ + this.ml;
               _loc4_ = _loc4_.next;
            }
         }
         if(param2 > 0)
         {
            if(param2 & 1)
            {
               _loc10_ = param1.nearClipping;
               _loc4_ = boundVertexList;
               _loc8_ = false;
               _loc9_ = false;
               while(_loc4_ != null)
               {
                  if(_loc4_.cameraZ > _loc10_)
                  {
                     _loc8_ = true;
                     if(_loc9_)
                     {
                        break;
                     }
                  }
                  else
                  {
                     _loc9_ = true;
                     if(_loc8_)
                     {
                        break;
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc9_)
               {
                  if(!_loc8_)
                  {
                     return -1;
                  }
               }
               else
               {
                  param2 = param2 & 62;
               }
            }
            if(param2 & 2)
            {
               _loc11_ = param1.farClipping;
               _loc4_ = boundVertexList;
               _loc8_ = false;
               _loc9_ = false;
               while(_loc4_ != null)
               {
                  if(_loc4_.cameraZ < _loc11_)
                  {
                     _loc8_ = true;
                     if(_loc9_)
                     {
                        break;
                     }
                  }
                  else
                  {
                     _loc9_ = true;
                     if(_loc8_)
                     {
                        break;
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc9_)
               {
                  if(!_loc8_)
                  {
                     return -1;
                  }
               }
               else
               {
                  param2 = param2 & 61;
               }
            }
            if(param2 & 4)
            {
               _loc4_ = boundVertexList;
               _loc8_ = false;
               _loc9_ = false;
               while(_loc4_ != null)
               {
                  if(-_loc4_.cameraX < _loc4_.cameraZ)
                  {
                     _loc8_ = true;
                     if(_loc9_)
                     {
                        break;
                     }
                  }
                  else
                  {
                     _loc9_ = true;
                     if(_loc8_)
                     {
                        break;
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc9_)
               {
                  if(!_loc8_)
                  {
                     return -1;
                  }
               }
               else
               {
                  param2 = param2 & 59;
               }
            }
            if(param2 & 8)
            {
               _loc4_ = boundVertexList;
               _loc8_ = false;
               _loc9_ = false;
               while(_loc4_ != null)
               {
                  if(_loc4_.cameraX < _loc4_.cameraZ)
                  {
                     _loc8_ = true;
                     if(_loc9_)
                     {
                        break;
                     }
                  }
                  else
                  {
                     _loc9_ = true;
                     if(_loc8_)
                     {
                        break;
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc9_)
               {
                  if(!_loc8_)
                  {
                     return -1;
                  }
               }
               else
               {
                  param2 = param2 & 55;
               }
            }
            if(param2 & 16)
            {
               _loc4_ = boundVertexList;
               _loc8_ = false;
               _loc9_ = false;
               while(_loc4_ != null)
               {
                  if(-_loc4_.cameraY < _loc4_.cameraZ)
                  {
                     _loc8_ = true;
                     if(_loc9_)
                     {
                        break;
                     }
                  }
                  else
                  {
                     _loc9_ = true;
                     if(_loc8_)
                     {
                        break;
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc9_)
               {
                  if(!_loc8_)
                  {
                     return -1;
                  }
               }
               else
               {
                  param2 = param2 & 47;
               }
            }
            if(param2 & 32)
            {
               _loc4_ = boundVertexList;
               _loc8_ = false;
               _loc9_ = false;
               while(_loc4_ != null)
               {
                  if(_loc4_.cameraY < _loc4_.cameraZ)
                  {
                     _loc8_ = true;
                     if(_loc9_)
                     {
                        break;
                     }
                  }
                  else
                  {
                     _loc9_ = true;
                     if(_loc8_)
                     {
                        break;
                     }
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc9_)
               {
                  if(!_loc8_)
                  {
                     return -1;
                  }
               }
               else
               {
                  param2 = param2 & 31;
               }
            }
         }
         if(_loc3_ > 0)
         {
            _loc12_ = 0;
            while(true)
            {
               if(_loc12_ < _loc3_)
               {
                  _loc13_ = param1.occluders[_loc12_];
                  while(_loc13_ != null)
                  {
                     _loc4_ = boundVertexList;
                     while(_loc4_ != null)
                     {
                        if(_loc13_.cameraX * _loc4_.cameraX + _loc13_.cameraY * _loc4_.cameraY + _loc13_.cameraZ * _loc4_.cameraZ >= 0)
                        {
                           break;
                        }
                        _loc4_ = _loc4_.next;
                     }
                     if(_loc4_ != null)
                     {
                        break;
                     }
                     _loc13_ = _loc13_.next;
                  }
                  if(_loc13_ == null)
                  {
                     break;
                  }
                  _loc12_++;
               }
            }
            return -1;
         }
         this.culling = param2;
         return param2;
      }
      
      alternativa3d function removeFromParent() : void
      {
         if(this._parent != null)
         {
            this._parent.removeChild(this);
         }
      }
   }
}
