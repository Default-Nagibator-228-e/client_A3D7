package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class Object3DContainer extends Object3D
   {
       
      
      public var mouseChildren:Boolean = true;
      
      alternativa3d var childrenList:Object3D;
      
      alternativa3d var lightList:Light3D;
      
      alternativa3d var visibleChildren:Vector.<Object3D>;
      
      alternativa3d var numVisibleChildren:int = 0;
      
      public function Object3DContainer()
      {
         this.visibleChildren = new Vector.<Object3D>();
         super();
      }
      
      public function addChild(param1:Object3D) : Object3D
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1 == this)
         {
            throw new ArgumentError("An object cannot be added as a child of itself.");
         }
         var _loc2_:Object3DContainer = _parent;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               throw new ArgumentError("An object cannot be added as a child to one of it\'s children (or children\'s children, etc.).");
            }
            _loc2_ = _loc2_._parent;
         }
         if(param1._parent != null)
         {
            param1._parent.removeChild(param1);
         }
         this.addToList(param1);
         return param1;
      }
      
      public function removeChild(param1:Object3D) : Object3D
      {
         var _loc2_:Object3D = null;
         var _loc3_:Object3D = null;
         if(param1 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1._parent != this)
         {
            trace("Object3DContainer::removeChild The supplied Object3D must be a child of the caller.");
            return null;
         }
         _loc3_ = this.childrenList;
         while(_loc3_ != null)
         {
            if(_loc3_ == param1)
            {
               if(_loc2_ != null)
               {
                  _loc2_.next = _loc3_.next;
               }
               else
               {
                  this.childrenList = _loc3_.next;
               }
               _loc3_.next = null;
               _loc3_.setParent(null);
               return param1;
            }
            _loc2_ = _loc3_;
            _loc3_ = _loc3_.next;
         }
         throw new ArgumentError("Cannot remove child.");
      }
      
      public function addChildAt(param1:Object3D, param2:int) : Object3D
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1 == this)
         {
            throw new ArgumentError("An object cannot be added as a child of itself.");
         }
         if(param2 < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var _loc3_:Object3DContainer = _parent;
         while(_loc3_ != null)
         {
            if(_loc3_ == param1)
            {
               throw new ArgumentError("An object cannot be added as a child to one of it\'s children (or children\'s children, etc.).");
            }
            _loc3_ = _loc3_._parent;
         }
         var _loc4_:Object3D = this.childrenList;
         var _loc5_:int = 0;
         while(_loc5_ < param2)
         {
            if(_loc4_ == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            _loc4_ = _loc4_.next;
            _loc5_++;
         }
         if(param1._parent != null)
         {
            param1._parent.removeChild(param1);
         }
         this.addToList(param1,_loc4_);
         return param1;
      }
      
      public function removeChildAt(param1:int) : Object3D
      {
         if(param1 < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var _loc2_:Object3D = this.childrenList;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            if(_loc2_ == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            _loc2_ = _loc2_.next;
            _loc3_++;
         }
         if(_loc2_ == null)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         this.removeChild(_loc2_);
         return _loc2_;
      }
      
      public function getChildAt(param1:int) : Object3D
      {
         if(param1 < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var _loc2_:Object3D = this.childrenList;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            if(_loc2_ == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            _loc2_ = _loc2_.next;
            _loc3_++;
         }
         if(_loc2_ == null)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         return _loc2_;
      }
      
      public function getChildIndex(param1:Object3D) : int
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         var _loc2_:int = 0;
         var _loc3_:Object3D = this.childrenList;
         while(_loc3_ != null)
         {
            if(_loc3_ == param1)
            {
               return _loc2_;
            }
            _loc2_++;
            _loc3_ = _loc3_.next;
         }
         throw new ArgumentError("Cannot get child index.");
      }
      
      public function setChildIndex(param1:Object3D, param2:int) : void
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         if(param2 < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var _loc3_:Object3D = this.childrenList;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            if(_loc3_ == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            _loc3_ = _loc3_.next;
            _loc4_++;
         }
         this.removeChild(param1);
         this.addToList(param1,_loc3_);
      }
      
      public function swapChildren(param1:Object3D, param2:Object3D) : void
      {
         var _loc3_:Object3D = null;
         if(param1 == null || param2 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1._parent != this || param2._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         if(param1 != param2)
         {
            if(param1.next == param2)
            {
               this.removeChild(param2);
               this.addToList(param2,param1);
            }
            else if(param2.next == param1)
            {
               this.removeChild(param1);
               this.addToList(param1,param2);
            }
            else
            {
               _loc3_ = param1.next;
               this.removeChild(param1);
               this.addToList(param1,param2);
               this.removeChild(param2);
               this.addToList(param2,_loc3_);
            }
         }
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object3D = null;
         var _loc5_:Object3D = null;
         var _loc6_:Object3D = null;
         if(param1 < 0 || param2 < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         if(param1 != param2)
         {
            _loc4_ = this.childrenList;
            _loc3_ = 0;
            while(_loc3_ < param1)
            {
               if(_loc4_ == null)
               {
                  throw new RangeError("The supplied index is out of bounds.");
               }
               _loc4_ = _loc4_.next;
               _loc3_++;
            }
            if(_loc4_ == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            _loc5_ = this.childrenList;
            _loc3_ = 0;
            while(_loc3_ < param2)
            {
               if(_loc5_ == null)
               {
                  throw new RangeError("The supplied index is out of bounds.");
               }
               _loc5_ = _loc5_.next;
               _loc3_++;
            }
            if(_loc5_ == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            if(_loc4_ != _loc5_)
            {
               if(_loc4_.next == _loc5_)
               {
                  this.removeChild(_loc5_);
                  this.addToList(_loc5_,_loc4_);
               }
               else if(_loc5_.next == _loc4_)
               {
                  this.removeChild(_loc4_);
                  this.addToList(_loc4_,_loc5_);
               }
               else
               {
                  _loc6_ = _loc4_.next;
                  this.removeChild(_loc4_);
                  this.addToList(_loc4_,_loc5_);
                  this.removeChild(_loc5_);
                  this.addToList(_loc5_,_loc6_);
               }
            }
         }
      }
      
      public function getChildByName(param1:String) : Object3D
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter name must be non-null.");
         }
         var _loc2_:Object3D = this.childrenList;
         while(_loc2_ != null)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.next;
         }
         return null;
      }
      
      public function contains(param1:Object3D) : Boolean
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(param1 == this)
         {
            return true;
         }
         var _loc2_:Object3D = this.childrenList;
         while(_loc2_ != null)
         {
            if(_loc2_ is Object3DContainer)
            {
               if((_loc2_ as Object3DContainer).contains(param1))
               {
                  return true;
               }
            }
            else if(_loc2_ == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function get numChildren() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Object3D = this.childrenList;
         while(_loc2_ != null)
         {
            _loc1_++;
            _loc2_ = _loc2_.next;
         }
         return _loc1_;
      }
      
      override public function intersectRay(param1:Vector3D, param2:Vector3D, param3:Dictionary = null, param4:Camera3D = null) : RayIntersectionData
      {
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc9_:Object3D = null;
         _loc5_ = null;
         _loc6_ = null;
         var _loc7_:RayIntersectionData = null;
         var _loc10_:RayIntersectionData = null;
         if(param3 != null && param3[this])
         {
            return null;
         }
         if(!boundIntersectRay(param1,param2,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         var _loc8_:Number = 1.0e22;
         _loc9_ = this.childrenList;
         while(_loc9_ != null)
         {
            _loc9_.composeMatrix();
            _loc9_.invertMatrix();
            if(_loc5_ == null)
            {
               _loc5_ = new Vector3D();
               _loc6_ = new Vector3D();
            }
            _loc5_.x = _loc9_.ma * param1.x + _loc9_.mb * param1.y + _loc9_.mc * param1.z + _loc9_.md;
            _loc5_.y = _loc9_.me * param1.x + _loc9_.mf * param1.y + _loc9_.mg * param1.z + _loc9_.mh;
            _loc5_.z = _loc9_.mi * param1.x + _loc9_.mj * param1.y + _loc9_.mk * param1.z + _loc9_.ml;
            _loc6_.x = _loc9_.ma * param2.x + _loc9_.mb * param2.y + _loc9_.mc * param2.z;
            _loc6_.y = _loc9_.me * param2.x + _loc9_.mf * param2.y + _loc9_.mg * param2.z;
            _loc6_.z = _loc9_.mi * param2.x + _loc9_.mj * param2.y + _loc9_.mk * param2.z;
            _loc10_ = _loc9_.intersectRay(_loc5_,_loc6_,param3,param4);
            if(_loc10_ != null && _loc10_.time < _loc8_)
            {
               _loc8_ = _loc10_.time;
               _loc7_ = _loc10_;
            }
            _loc9_ = _loc9_.next;
         }
         return _loc7_;
      }
      
      override alternativa3d function checkIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Dictionary) : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc9_:Object3D = this.childrenList;
         while(_loc9_ != null)
         {
            if(param8 != null && !param8[_loc9_])
            {
               _loc9_.composeMatrix();
               _loc9_.invertMatrix();
               _loc10_ = _loc9_.ma * param1 + _loc9_.mb * param2 + _loc9_.mc * param3 + _loc9_.md;
               _loc11_ = _loc9_.me * param1 + _loc9_.mf * param2 + _loc9_.mg * param3 + _loc9_.mh;
               _loc12_ = _loc9_.mi * param1 + _loc9_.mj * param2 + _loc9_.mk * param3 + _loc9_.ml;
               _loc13_ = _loc9_.ma * param4 + _loc9_.mb * param5 + _loc9_.mc * param6;
               _loc14_ = _loc9_.me * param4 + _loc9_.mf * param5 + _loc9_.mg * param6;
               _loc15_ = _loc9_.mi * param4 + _loc9_.mj * param5 + _loc9_.mk * param6;
               if(boundCheckIntersection(_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,param7,_loc9_.boundMinX,_loc9_.boundMinY,_loc9_.boundMinZ,_loc9_.boundMaxX,_loc9_.boundMaxY,_loc9_.boundMaxZ) && _loc9_.checkIntersection(_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,param7,param8))
               {
                  return true;
               }
            }
            _loc9_ = _loc9_.next;
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector.<Face>, param7:Dictionary = null) : void
      {
         if(param7 != null && param7[this])
         {
            return;
         }
         var _loc8_:Vector3D = calculateSphere(param1,param2,param3,param4,param5);
         if(!boundIntersectSphere(_loc8_,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return;
         }
         var _loc9_:Object3D = this.childrenList;
         while(_loc9_ != null)
         {
            _loc9_.composeAndAppend(this);
            _loc9_.collectPlanes(param1,param2,param3,param4,param5,param6,param7);
            _loc9_ = _loc9_.next;
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Object3DContainer = new Object3DContainer();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         var _loc4_:Object3D = null;
         var _loc5_:Object3D = null;
         super.clonePropertiesFrom(param1);
         var _loc2_:Object3DContainer = param1 as Object3DContainer;
         this.mouseChildren = _loc2_.mouseChildren;
         var _loc3_:Object3D = _loc2_.childrenList;
         while(_loc3_ != null)
         {
            _loc5_ = _loc3_.clone();
            if(this.childrenList != null)
            {
               _loc4_.next = _loc5_;
            }
            else
            {
               this.childrenList = _loc5_;
            }
            _loc4_ = _loc5_;
            _loc5_.setParent(this);
            _loc3_ = _loc3_.next;
         }
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         this.numVisibleChildren = 0;
         var _loc3_:Object3D = this.childrenList;
         while(_loc3_ != null)
         {
            if(_loc3_.visible)
            {
               _loc3_.composeAndAppend(this);
               if(_loc3_.cullingInCamera(param1,culling) >= 0)
               {
                  _loc3_.concat(this);
                  this.visibleChildren[this.numVisibleChildren] = _loc3_;
                  this.numVisibleChildren++;
               }
            }
            _loc3_ = _loc3_.next;
         }
         if(this.numVisibleChildren > 0)
         {
            if(param1.debug && (_loc2_ = param1.checkInDebug(this)) > 0)
            {
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            this.drawVisibleChildren(param1);
         }
      }
      
      alternativa3d function drawVisibleChildren(param1:Camera3D) : void
      {
         var _loc3_:Object3D = null;
         var _loc2_:int = this.numVisibleChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this.visibleChildren[_loc2_];
            _loc3_.draw(param1);
            this.visibleChildren[_loc2_] = null;
            _loc2_--;
         }
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         var _loc2_:VG = null;
         var _loc3_:VG = null;
         var _loc5_:VG = null;
         var _loc4_:Object3D = this.childrenList;
         while(_loc4_ != null)
         {
            if(_loc4_.visible)
            {
               _loc4_.composeAndAppend(this);
               if(_loc4_.cullingInCamera(param1,culling) >= 0)
               {
                  _loc4_.concat(this);
                  _loc5_ = _loc4_.getVG(param1);
                  if(_loc5_ != null)
                  {
                     if(_loc2_ != null)
                     {
                        _loc3_.next = _loc5_;
                     }
                     else
                     {
                        _loc2_ = _loc5_;
                        _loc3_ = _loc5_;
                     }
                     while(_loc3_.next != null)
                     {
                        _loc3_ = _loc3_.next;
                     }
                  }
               }
            }
            _loc4_ = _loc4_.next;
         }
         return _loc2_;
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         var _loc3_:Object3D = this.childrenList;
         while(_loc3_ != null)
         {
            if(param2 != null)
            {
               _loc3_.composeAndAppend(param2);
            }
            else
            {
               _loc3_.composeMatrix();
            }
            _loc3_.updateBounds(param1,_loc3_);
            _loc3_ = _loc3_.next;
         }
      }
      
      override alternativa3d function split(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Number) : Vector.<Object3D>
      {
         var _loc10_:Object3D = null;
         var _loc11_:Object3D = null;
         var _loc13_:Object3D = null;
         var _loc14_:Vector3D = null;
         var _loc15_:Vector3D = null;
         var _loc16_:Vector3D = null;
         var _loc17_:int = 0;
         var _loc18_:Vector.<Object3D> = null;
         var _loc19_:Number = NaN;
         var _loc5_:Vector.<Object3D> = new Vector.<Object3D>(2);
         var _loc6_:Vector3D = calculatePlane(param1,param2,param3);
         var _loc7_:Object3D = this.childrenList;
         this.childrenList = null;
         var _loc8_:Object3DContainer = this.clone() as Object3DContainer;
         var _loc9_:Object3DContainer = this.clone() as Object3DContainer;
         var _loc12_:Object3D = _loc7_;
         while(_loc12_ != null)
         {
            _loc13_ = _loc12_.next;
            _loc12_.next = null;
            _loc12_.setParent(null);
            _loc12_.composeMatrix();
            _loc12_.calculateInverseMatrix();
            _loc14_ = new Vector3D(_loc12_.ima * param1.x + _loc12_.imb * param1.y + _loc12_.imc * param1.z + _loc12_.imd,_loc12_.ime * param1.x + _loc12_.imf * param1.y + _loc12_.img * param1.z + _loc12_.imh,_loc12_.imi * param1.x + _loc12_.imj * param1.y + _loc12_.imk * param1.z + _loc12_.iml);
            _loc15_ = new Vector3D(_loc12_.ima * param2.x + _loc12_.imb * param2.y + _loc12_.imc * param2.z + _loc12_.imd,_loc12_.ime * param2.x + _loc12_.imf * param2.y + _loc12_.img * param2.z + _loc12_.imh,_loc12_.imi * param2.x + _loc12_.imj * param2.y + _loc12_.imk * param2.z + _loc12_.iml);
            _loc16_ = new Vector3D(_loc12_.ima * param3.x + _loc12_.imb * param3.y + _loc12_.imc * param3.z + _loc12_.imd,_loc12_.ime * param3.x + _loc12_.imf * param3.y + _loc12_.img * param3.z + _loc12_.imh,_loc12_.imi * param3.x + _loc12_.imj * param3.y + _loc12_.imk * param3.z + _loc12_.iml);
            _loc17_ = _loc12_.testSplit(_loc14_,_loc15_,_loc16_,param4);
            if(_loc17_ < 0)
            {
               if(_loc10_ != null)
               {
                  _loc10_.next = _loc12_;
               }
               else
               {
                  _loc8_.childrenList = _loc12_;
               }
               _loc10_ = _loc12_;
               _loc12_.setParent(_loc8_);
            }
            else if(_loc17_ > 0)
            {
               if(_loc11_ != null)
               {
                  _loc11_.next = _loc12_;
               }
               else
               {
                  _loc9_.childrenList = _loc12_;
               }
               _loc11_ = _loc12_;
               _loc12_.setParent(_loc9_);
            }
            else
            {
               _loc18_ = _loc12_.split(_loc14_,_loc15_,_loc16_,param4);
               _loc19_ = _loc12_.distance;
               if(_loc18_[0] != null)
               {
                  _loc12_ = _loc18_[0];
                  if(_loc10_ != null)
                  {
                     _loc10_.next = _loc12_;
                  }
                  else
                  {
                     _loc8_.childrenList = _loc12_;
                  }
                  _loc10_ = _loc12_;
                  _loc12_.setParent(_loc8_);
                  _loc12_.distance = _loc19_;
               }
               if(_loc18_[1] != null)
               {
                  _loc12_ = _loc18_[1];
                  if(_loc11_ != null)
                  {
                     _loc11_.next = _loc12_;
                  }
                  else
                  {
                     _loc9_.childrenList = _loc12_;
                  }
                  _loc11_ = _loc12_;
                  _loc12_.setParent(_loc9_);
                  _loc12_.distance = _loc19_;
               }
            }
            _loc12_ = _loc13_;
         }
         if(_loc10_ != null)
         {
            _loc8_.calculateBounds();
            _loc5_[0] = _loc8_;
         }
         if(_loc11_ != null)
         {
            _loc9_.calculateBounds();
            _loc5_[1] = _loc9_;
         }
         return _loc5_;
      }
      
      alternativa3d function addToList(param1:Object3D, param2:Object3D = null) : void
      {
         var _loc3_:Object3D = null;
         param1.next = param2;
         param1.setParent(this);
         if(param2 == this.childrenList)
         {
            this.childrenList = param1;
         }
         else
         {
            _loc3_ = this.childrenList;
            while(_loc3_ != null)
            {
               if(_loc3_.next == param2)
               {
                  _loc3_.next = param1;
                  break;
               }
               _loc3_ = _loc3_.next;
            }
         }
      }
      
      override alternativa3d function setParent(param1:Object3DContainer) : void
      {
         var _loc2_:Object3DContainer = null;
         var _loc3_:Light3D = null;
         if(param1 == null)
         {
            _loc2_ = _parent;
            while(_loc2_._parent != null)
            {
               _loc2_ = _loc2_._parent;
            }
            if(_loc2_.lightList != null)
            {
               this.transferLights(_loc2_,this);
            }
         }
         else if(this.lightList != null)
         {
            _loc2_ = param1;
            while(_loc2_._parent != null)
            {
               _loc2_ = _loc2_._parent;
            }
            _loc3_ = this.lightList;
            while(_loc3_.nextLight != null)
            {
               _loc3_ = _loc3_.nextLight;
            }
            _loc3_.nextLight = _loc2_.lightList;
            _loc2_.lightList = this.lightList;
            this.lightList = null;
         }
         _parent = param1;
      }
      
      private function transferLights(param1:Object3DContainer, param2:Object3DContainer) : void
      {
         var _loc4_:Light3D = null;
         var _loc5_:Light3D = null;
         var _loc6_:Light3D = null;
         var _loc3_:Object3D = this.childrenList;
         while(_loc3_ != null)
         {
            if(_loc3_ is Light3D)
            {
               _loc4_ = _loc3_ as Light3D;
               _loc5_ = null;
               _loc6_ = param1.lightList;
               while(_loc6_ != null)
               {
                  if(_loc6_ == _loc4_)
                  {
                     if(_loc5_ != null)
                     {
                        _loc5_.nextLight = _loc6_.nextLight;
                     }
                     else
                     {
                        param1.lightList = _loc6_.nextLight;
                     }
                     _loc6_.nextLight = param2.lightList;
                     param2.lightList = _loc6_;
                     break;
                  }
                  _loc5_ = _loc6_;
                  _loc6_ = _loc6_.nextLight;
               }
            }
            else if(_loc3_ is Object3DContainer)
            {
               (_loc3_ as Object3DContainer).transferLights(param1,param2);
            }
            if(param1.lightList == null)
            {
               break;
            }
            _loc3_ = _loc3_.next;
         }
      }
   }
}
