package alternativa.gfx.core
{
   import alternativa.gfx.alternativagfx;
   import alternativa.init.Main;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.display.Stage3D;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DClearMask;
   import flash.display3D.Context3DProgramType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.utils.Dictionary;
   
   use namespace alternativagfx;
   
   [Event(name="context3DCreate",type="flash.events.Event")]
   public class Device extends EventDispatcher
   {
      
      private static const RESOURCE_NOT_AVAILABLE_ERROR:String = "Resource is not available.";
       
      
      private var _stage:Stage;
      
      private var _renderMode:String;
      
      private var _profile:String;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _antiAlias:int;
      
      private var _enableDepthAndStencil:Boolean;
      
      private var _enableErrorChecking:Boolean;
      
      public var _stage3D:Stage3D;
	        
      private var _available:Boolean = true;
      
      private var _renderState:RenderState;
      
      private var configured:Boolean = false;
      
      private var backBufferWidth:int = -1;
      
      private var backBufferHeight:int = -1;
      
      private var backBufferAntiAlias:int = -1;
      
      private var backBufferEnableDepthAndStencil:Boolean = false;
      
      private var resourcesToUpload:Dictionary;
      
      public function Device(param1:Stage, param2:String = "auto", param3:String = "baseline")
      {
         this._renderState = new RenderState();
         this.resourcesToUpload = new Dictionary();
         super();
         this._stage = param1;
         this._renderMode = param2;
         this._profile = param3;
         this._stage3D = this._stage.stage3Ds[1];
         this._x = this._stage3D.x;
         this._y = this._stage3D.y;
         this._width = param1.stageWidth;
         this._height = param1.stageHeight;
         this._antiAlias = 0;
         this._enableDepthAndStencil = true;
         this._enableErrorChecking = false;
         this._stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContext3DCreate);
         //if(this._stage3D.requestContext3D.length > 1)
         //{
            //this._stage3D.requestContext3D(param2,param3);
         //}
         //else
         //{
            this._stage3D.requestContext3D(param2);
         //}
      }
      
      private function onContext3DCreate(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc5_:TextureResource = null;
         var _loc6_:VertexBufferResource = null;
         this.configured = false;
         this.backBufferWidth = -1;
         this.backBufferHeight = -1;
         this.backBufferAntiAlias = -1;
         this.backBufferEnableDepthAndStencil = false;
         var _loc2_:Context3D = this._stage3D.context3D;
         _loc2_.enableErrorChecking = this._enableErrorChecking;
         for(_loc3_ in this.resourcesToUpload)
         {
            this.uploadResource(_loc3_);
            delete this.resourcesToUpload[_loc3_];
         }
         _loc2_.setBlendFactors(this._renderState.blendSourceFactor,this._renderState.blendDestinationFactor);
         _loc2_.setColorMask(this._renderState.colorMaskRed,this._renderState.colorMaskGreen,this._renderState.colorMaskBlue,this._renderState.colorMaskAlpha);
         _loc2_.setCulling(this._renderState.culling);
         _loc2_.setDepthTest(this._renderState.depthTestMask,this._renderState.depthTestPassCompareMode);
         if(this._renderState.program != null)
         {
            if(!this._renderState.program.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
            }
            this.prepareResource(_loc2_,this._renderState.program);
            _loc2_.setProgram(this._renderState.program.program);
         }
         if(this._renderState.renderTarget != null)
         {
            if(!this._renderState.renderTarget.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
            }
            this.prepareResource(_loc2_,this._renderState.renderTarget);
            _loc2_.setRenderToTexture(this._renderState.renderTarget.texture,this._renderState.renderTargetEnableDepthAndStencil,this._renderState.renderTargetAntiAlias,this._renderState.renderTargetSurfaceSelector);
         }
         if(this._renderState.scissor)
         {
            _loc2_.setScissorRectangle(this._renderState.scissorRectangle);
         }
         else
         {
            _loc2_.setScissorRectangle(null);
         }
         _loc2_.setStencilActions(this._renderState.stencilActionTriangleFace,this._renderState.stencilActionCompareMode,this._renderState.stencilActionOnBothPass,this._renderState.stencilActionOnDepthFail,this._renderState.stencilActionOnDepthPassStencilFail);
         _loc2_.setStencilReferenceValue(this._renderState.stencilReferenceValue,this._renderState.stencilReadMask,this._renderState.stencilWriteMask);
         var _loc4_:int = 0;
         while(_loc4_ < 8)
         {
            _loc5_ = this._renderState.textures[_loc4_];
            if(_loc5_ != null)
            {
               if(!_loc5_.available)
               {
                  throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
               }
               this.prepareResource(_loc2_,_loc5_);
               _loc2_.setTextureAt(_loc4_,_loc5_.texture);
            }
            _loc6_ = this._renderState.vertexBuffers[_loc4_];
            if(_loc6_ != null)
            {
               if(!_loc6_.available)
               {
                  throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
               }
               this.prepareResource(_loc2_,_loc6_);
               _loc2_.setVertexBufferAt(_loc4_,_loc6_.buffer,this._renderState.vertexBuffersOffsets[_loc4_],this._renderState.vertexBuffersFormats[_loc4_]);
            }
            _loc4_++;
         }
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this._renderState.vertexConstants,128);
         _loc2_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._renderState.fragmentConstants,28);
         dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         this._stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContext3DCreate);
         if(this._stage3D.context3D != null)
         {
            this._stage3D.context3D.dispose();
         }
         for(_loc1_ in this.resourcesToUpload)
         {
            delete this.resourcesToUpload[_loc1_];
         }
         this._renderState = new RenderState();
         this._available = false;
      }
      
      public function reset() : void
      {
         var _loc1_:* = undefined;
         if(this._stage3D.context3D != null)
         {
            this._stage3D.context3D.dispose();
         }
         else
         {
            for(_loc1_ in this.resourcesToUpload)
            {
               delete this.resourcesToUpload[_loc1_];
            }
         }
         this._renderState = new RenderState();
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      public function get ready() : Boolean
      {
         return this._stage3D.context3D != null;
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function get stage3DIndex() : int
      {
         return 0;
      }
      
      public function get renderMode() : String
      {
         return this._renderMode;
      }
      
      public function get profile() : String
      {
         return this._profile;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function set x(param1:int) : void
      {
         this._x = param1;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function set y(param1:int) : void
      {
         this._y = param1;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function set width(param1:int) : void
      {
         this._width = param1;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function set height(param1:int) : void
      {
         this._height = param1;
      }
      
      public function get antiAlias() : int
      {
         return this._antiAlias;
      }
      
      public function set antiAlias(param1:int) : void
      {
         if(param1 != 0 && param1 != 2 && param1 != 4 && param1 != 16)
         {
            throw new Error("Invalid antialiasing value.");
         }
         this._antiAlias = param1;
      }
      
      public function get enableDepthAndStencil() : Boolean
      {
         return this._enableDepthAndStencil;
      }
      
      public function set enableDepthAndStencil(param1:Boolean) : void
      {
         this._enableDepthAndStencil = param1;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return this._enableErrorChecking;
      }
      
      public function set enableErrorChecking(param1:Boolean) : void
      {
         this._enableErrorChecking = param1;
         var _loc2_:Context3D = this._stage3D.context3D;
         if(_loc2_ != null && _loc2_.enableErrorChecking != this._enableErrorChecking)
         {
            _loc2_.enableErrorChecking = this._enableErrorChecking;
         }
      }
      
      public function uploadResource(param1:Resource) : void
      {
         if(!param1.available)
         {
            throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
         }
         var _loc2_:Context3D = this._stage3D.context3D;
         if(_loc2_ != null)
         {
            if(!param1.isCreated(_loc2_))
            {
               param1.create(_loc2_);
            }
            param1.upload();
         }
         else
         {
            this.resourcesToUpload[param1] = true;
         }
      }
      
      private function prepareResource(param1:Context3D, param2:Resource) : void
      {
         if(!param2.isCreated(param1))
         {
            param2.create(param1);
            param2.upload();
         }
      }
      
      public function setBlendFactors(param1:String, param2:String) : void
      {
         var _loc3_:Context3D = null;
         if(param1 != this._renderState.blendSourceFactor || param2 != this._renderState.blendDestinationFactor)
         {
            this._renderState.blendSourceFactor = param1;
            this._renderState.blendDestinationFactor = param2;
            _loc3_ = this._stage3D.context3D;
            if(_loc3_ != null)
            {
               _loc3_.setBlendFactors(param1,param2);
            }
         }
      }
      
      public function setColorMask(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:Context3D = null;
         if(param1 != this._renderState.colorMaskRed || param2 != this._renderState.colorMaskGreen || param3 != this._renderState.colorMaskBlue || param4 != this._renderState.colorMaskAlpha)
         {
            this._renderState.colorMaskRed = param1;
            this._renderState.colorMaskGreen = param2;
            this._renderState.colorMaskBlue = param3;
            this._renderState.colorMaskAlpha = param4;
            _loc5_ = this._stage3D.context3D;
            if(_loc5_ != null)
            {
               _loc5_.setColorMask(param1,param2,param3,param4);
            }
         }
      }
      
      public function setCulling(param1:String) : void
      {
         var _loc2_:Context3D = null;
         if(param1 != this._renderState.culling)
         {
            this._renderState.culling = param1;
            _loc2_ = this._stage3D.context3D;
            if(_loc2_ != null)
            {
               _loc2_.setCulling(param1);
            }
         }
      }
      
      public function setDepthTest(param1:Boolean, param2:String) : void
      {
         var _loc3_:Context3D = null;
         if(param1 != this._renderState.depthTestMask || param2 != this._renderState.depthTestPassCompareMode)
         {
            this._renderState.depthTestMask = param1;
            this._renderState.depthTestPassCompareMode = param2;
            _loc3_ = this._stage3D.context3D;
            if(_loc3_ != null)
            {
               _loc3_.setDepthTest(param1,param2);
            }
         }
      }
      
      public function setProgram(param1:ProgramResource) : void
      {
         var _loc2_:Context3D = null;
         if(param1 != this._renderState.program)
         {
            if(!param1.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
            }
            this._renderState.program = param1;
            _loc2_ = this._stage3D.context3D;
            if(_loc2_ != null)
            {
               this.prepareResource(_loc2_,param1);
               _loc2_.setProgram(param1.program);
            }
         }
      }
      
      public function setRenderToBackBuffer() : void
      {
         var _loc1_:Context3D = null;
         if(this._renderState.renderTarget != null)
         {
            this._renderState.renderTarget = null;
            _loc1_ = this._stage3D.context3D;
            if(_loc1_ != null)
            {
               _loc1_.setRenderToBackBuffer();
            }
         }
      }
      
      public function setRenderToTexture(param1:TextureResource, param2:Boolean = false, param3:int = 0, param4:int = 0) : void
      {
         var _loc5_:Context3D = null;
         if(param1 != this._renderState.renderTarget || param2 != this._renderState.renderTargetEnableDepthAndStencil || param3 != this._renderState.renderTargetAntiAlias || param4 != this._renderState.renderTargetSurfaceSelector)
         {
            if(param1 != null && !param1.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
            }
            this._renderState.renderTarget = param1;
            this._renderState.renderTargetEnableDepthAndStencil = param2;
            this._renderState.renderTargetAntiAlias = param3;
            this._renderState.renderTargetSurfaceSelector = param4;
            _loc5_ = this._stage3D.context3D;
            if(_loc5_ != null)
            {
               if(param1 != null)
               {
                  this.prepareResource(_loc5_,param1);
                  _loc5_.setRenderToTexture(param1.texture,param2,param3,param4);
               }
               else
               {
                  _loc5_.setRenderToBackBuffer();
               }
            }
         }
      }
      
      public function setScissorRectangle(param1:Rectangle) : void
      {
         var _loc2_:Context3D = this._stage3D.context3D;
         if(param1 != null)
         {
            if(this._renderState.scissor)
            {
               if(param1.x != this._renderState.scissorRectangle.x || param1.y != this._renderState.scissorRectangle.y || param1.width != this._renderState.scissorRectangle.width || param1.height != this._renderState.scissorRectangle.height)
               {
                  this._renderState.scissorRectangle.x = param1.x;
                  this._renderState.scissorRectangle.y = param1.y;
                  this._renderState.scissorRectangle.width = param1.width;
                  this._renderState.scissorRectangle.height = param1.height;
                  if(_loc2_ != null)
                  {
                     _loc2_.setScissorRectangle(param1);
                  }
               }
            }
            else
            {
               this._renderState.scissor = true;
               this._renderState.scissorRectangle.x = param1.x;
               this._renderState.scissorRectangle.y = param1.y;
               this._renderState.scissorRectangle.width = param1.width;
               this._renderState.scissorRectangle.height = param1.height;
               if(_loc2_ != null)
               {
                  _loc2_.setScissorRectangle(param1);
               }
            }
         }
         else
         {
            this._renderState.scissor = false;
            if(_loc2_ != null)
            {
               _loc2_.setScissorRectangle(null);
            }
         }
      }
      
      public function setStencilActions(param1:String = "frontAndBack", param2:String = "always", param3:String = "keep", param4:String = "keep", param5:String = "keep") : void
      {
         var _loc6_:Context3D = null;
         if(param1 != this._renderState.stencilActionTriangleFace || param2 != this._renderState.stencilActionCompareMode || param3 != this._renderState.stencilActionOnBothPass || param4 != this._renderState.stencilActionOnDepthFail || param5 != this._renderState.stencilActionOnDepthPassStencilFail)
         {
            this._renderState.stencilActionTriangleFace = param1;
            this._renderState.stencilActionCompareMode = param2;
            this._renderState.stencilActionOnBothPass = param3;
            this._renderState.stencilActionOnDepthFail = param4;
            this._renderState.stencilActionOnDepthPassStencilFail = param5;
            _loc6_ = this._stage3D.context3D;
            if(_loc6_ != null)
            {
               _loc6_.setStencilActions(param1,param2,param3,param4,param5);
            }
         }
      }
      
      public function setStencilReferenceValue(param1:uint, param2:uint = 255, param3:uint = 255) : void
      {
         var _loc4_:Context3D = null;
         if(param1 != this._renderState.stencilReferenceValue || param2 != this._renderState.stencilReadMask || param3 != this._renderState.stencilWriteMask)
         {
            this._renderState.stencilReferenceValue = param1;
            this._renderState.stencilReadMask = param2;
            this._renderState.stencilWriteMask = param3;
            _loc4_ = this._stage3D.context3D;
            if(_loc4_ != null)
            {
               _loc4_.setStencilReferenceValue(param1,param2,param3);
            }
         }
      }
      
      public function setTextureAt(param1:int, param2:TextureResource) : void
      {
         var _loc3_:Context3D = null;
         if(param2 != this._renderState.textures[param1])
         {
            if(param2 != null && !param2.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
            }
            this._renderState.textures[param1] = param2;
            _loc3_ = this._stage3D.context3D;
            if(_loc3_ != null)
            {
               if(param2 != null)
               {
                  this.prepareResource(_loc3_,param2);
                  _loc3_.setTextureAt(param1,param2.texture);
               }
               else
               {
                  _loc3_.setTextureAt(param1,null);
               }
            }
         }
      }
      
      public function setVertexBufferAt(param1:int, param2:VertexBufferResource, param3:int = 0, param4:String = "float4") : void
      {
         var _loc5_:Context3D = null;
         if(param2 != this._renderState.vertexBuffers[param1] || param3 != this._renderState.vertexBuffersOffsets[param1] || param4 != this._renderState.vertexBuffersFormats[param1])
         {
            if(param2 != null && !param2.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
            }
            this._renderState.vertexBuffers[param1] = param2;
            this._renderState.vertexBuffersOffsets[param1] = param3;
            this._renderState.vertexBuffersFormats[param1] = param4;
            _loc5_ = this._stage3D.context3D;
            if(_loc5_ != null)
            {
               if(param2 != null)
               {
                  this.prepareResource(_loc5_,param2);
                  _loc5_.setVertexBufferAt(param1,param2.buffer,param3,param4);
               }
               else
               {
                  _loc5_.setVertexBufferAt(param1,null);
               }
            }
         }
      }
      
      public function setProgramConstantsFromVector(param1:String, param2:int, param3:Vector.<Number>, param4:int = -1, param5:Boolean = true) : void
      {
         var _loc6_:Context3D = null;
         var _loc11_:Boolean = false;
         var _loc12_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = param2 << 2;
         var _loc9_:int = param4 < 0?int(int(param3.length)):int(int(param4 << 2));
         var _loc10_:Vector.<Number> = param1 == "vertex"?this._renderState.vertexConstants:this._renderState.fragmentConstants;
         if(param5)
         {
            _loc11_ = false;
            while(_loc7_ < _loc9_)
            {
               _loc12_ = param3[_loc7_];
               if(_loc12_ != _loc10_[_loc8_])
               {
                  _loc10_[_loc8_] = _loc12_;
                  _loc11_ = true;
               }
               _loc7_++;
               _loc8_++;
            }
            if(_loc11_)
            {
               _loc6_ = this._stage3D.context3D;
               if(_loc6_ != null)
               {
                  _loc6_.setProgramConstantsFromVector(param1,param2,param3,param4);
               }
            }
         }
         else
         {
            while(_loc7_ < _loc9_)
            {
               _loc10_[_loc8_] = param3[_loc7_];
               _loc7_++;
               _loc8_++;
            }
            _loc6_ = this._stage3D.context3D;
            if(_loc6_ != null)
            {
               _loc6_.setProgramConstantsFromVector(param1,param2,param3,param4);
            }
         }
      }
      
      public function clear(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 1, param6:uint = 0, param7:uint = 4.294967295E9) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc8_:Context3D = this._stage3D.context3D;
         if(_loc8_ != null)
         {
            if(!this.configured)
            {
               _loc9_ = 50;
               _loc10_ = this._width;
               _loc11_ = this._height;
               if(this._profile == "baselineConstrained")
               {
                  _loc12_ = this._x;
                  _loc13_ = this._y;
                  if(_loc12_ < 0)
                  {
                     _loc12_ = 0;
                  }
                  if(_loc13_ < 0)
                  {
                     _loc13_ = 0;
                  }
                  if(_loc12_ + _loc10_ > this.stage.stageWidth)
                  {
                     _loc10_ = this.stage.stageWidth - _loc12_;
                  }
                  if(_loc13_ + _loc11_ > this.stage.stageHeight)
                  {
                     _loc11_ = this.stage.stageHeight - _loc13_;
                  }
                  if(_loc12_ != this._stage3D.x || _loc13_ != this._stage3D.y || _loc10_ != this.backBufferWidth || _loc11_ != this.backBufferHeight || this._enableDepthAndStencil != this.backBufferEnableDepthAndStencil)
                  {
                     //_loc8_.configureBackBuffer(_loc9_,_loc9_,0,this._enableDepthAndStencil);
                     this._stage3D.x = _loc12_;
                     this._stage3D.y = _loc13_;
                     _loc8_.configureBackBuffer(_loc10_,_loc11_,0,this._enableDepthAndStencil);
                     this.backBufferWidth = _loc10_;
                     this.backBufferHeight = _loc11_;
                     this.backBufferAntiAlias = this._antiAlias;
                     this.backBufferEnableDepthAndStencil = this._enableDepthAndStencil;
                  }
               }
               else
               {
                  if(this._stage3D.x != this._x)
                  {
                     this._stage3D.x = this._x;
                  }
                  if(this._stage3D.y != this._y)
                  {
                     this._stage3D.y = this._y;
                  }
                  if(_loc10_ < _loc9_)
                  {
                     _loc10_ = _loc9_;
                  }
                  if(_loc11_ < _loc9_)
                  {
                     _loc11_ = _loc9_;
                  }
                  if(_loc10_ != this.backBufferWidth || _loc11_ != this.backBufferHeight || this._antiAlias != this.backBufferAntiAlias || this._enableDepthAndStencil != this.backBufferEnableDepthAndStencil)
                  {
                     _loc8_.configureBackBuffer(_loc10_,_loc11_,this._antiAlias,this._enableDepthAndStencil);
                     this.backBufferWidth = _loc10_;
                     this.backBufferHeight = _loc11_;
                     this.backBufferAntiAlias = this._antiAlias;
                     this.backBufferEnableDepthAndStencil = this._enableDepthAndStencil;
                  }
               }
               this.configured = true;
            }
            _loc8_.clear(param1, param2, param3, param4, param5, param6, param7);
         }
      }
      
      public function drawToBitmapData(param1:BitmapData) : void
      {
         var _loc2_:Context3D = this._stage3D.context3D;
         if(_loc2_ != null)
         {
            _loc2_.drawToBitmapData(param1);
         }
      }
      
      public function drawTriangles(param1:IndexBufferResource, param2:int = 0, param3:int = -1) : void
      {
         if(!param1.available)
         {
            throw new Error(RESOURCE_NOT_AVAILABLE_ERROR);
         }
         var _loc4_:Context3D = this._stage3D.context3D;
         if(_loc4_ != null)
         {
            this.prepareResource(_loc4_,param1);
            try
            {
               _loc4_.drawTriangles(param1.buffer,param2,param3);
               return;
            }
            catch(e:Error)
            {
               return;
            }
            return;
         }
      }
      
      public function present() : void
      {
         this._renderState.renderTarget = null;
         var _loc1_:Context3D = this._stage3D.context3D;
         if(_loc1_ != null)
         {
            _loc1_.present();
         }
         this.configured = false;
      }
   }
}
