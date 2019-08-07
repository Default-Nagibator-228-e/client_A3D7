package alternativa.engine3d.core
{
   import alternativa.Alternativa3D;
   import alternativa.engine3d.alternativa3d;
   import alternativa.gfx.core.Device;
   import alternativa.init.Main;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display3D.Context3DClearMask;
   import flash.display3D.Context3DRenderMode;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.utils.setTimeout;
   
   use namespace alternativa3d;
   
   public class View extends Canvas
   {
      
      private static const mouse:Point = new Point();
      
      private static const coords:Point = new Point();
      
      private static const branch:Vector.<Object3D> = new Vector.<Object3D>();
      
      private static const overedBranch:Vector.<Object3D> = new Vector.<Object3D>();
      
      private static const changedBranch:Vector.<Object3D> = new Vector.<Object3D>();
      
      private static const functions:Vector.<Function> = new Vector.<Function>();
      
      private static var staticDevice:Device;
      
      private static var views:Vector.<View> = new Vector.<View>();
      
      private static var configured:Boolean = false;
      
      private static var cleared:Boolean = false;
       
      
      private var presented:Boolean = false;
      
      private var globalCoords:Point;
      
      alternativa3d var rect:Rectangle;
      
      alternativa3d var correction:Boolean = true;
      
      public var device:Device;
      
      alternativa3d var quality:Boolean;
      
      alternativa3d var constrained:Boolean;
      
      alternativa3d var camera:Camera3D;
      
      alternativa3d var _width:Number;
      
      alternativa3d var _height:Number;
      
      alternativa3d var canvas:Sprite;
      
      private var lastEvent:MouseEvent;
      
      private var target:Object3D;
      
      private var pressedTarget:Object3D;
      
      private var clickedTarget:Object3D;
      
      private var overedTarget:Object3D;
      
      private var altKey:Boolean;
      
      private var ctrlKey:Boolean;
      
      private var shiftKey:Boolean;
      
      private var delta:int;
      
      private var buttonDown:Boolean;
      
      private var area:Sprite;
      
      private var logo:Logo;
      
      private var bitmap:Bitmap;
      
      private var _logoAlign:String = "BR";
      
      private var _logoHorizontalMargin:Number = 0;
      
      private var _logoVerticalMargin:Number = 0;
      
      public var enableErrorChecking:Boolean = false;
      
      public var zBufferPrecision:int = 16;
      
      public var antiAliasEnabled:Boolean = true;
      
      public var offsetX:Number = 0;
      
      public var offsetY:Number = 0;
      
      public function View(param1:Number, param2:Number, param3:Boolean = false)
      {
         var width:Number = param1;
         var height:Number = param2;
         var constrainedMode:Boolean = param3;
         this.rect = new Rectangle();
         this.canvas = new Sprite();
         super();
         this._width = width;
         this._height = height;
         this.constrained = constrainedMode;
         mouseEnabled = true;
         mouseChildren = true;
         doubleClickEnabled = true;
         buttonMode = true;
         useHandCursor = false;
         tabEnabled = false;
         tabChildren = false;
         var item:ContextMenuItem = new ContextMenuItem("Спасибо Alternativa3D");
         item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(param1:ContextMenuEvent):void
         {
            try
            {
               navigateToURL(new URLRequest("http://alternativaplatform.com"),"_blank");
               return;
            }
            catch(e:Error)
            {
               return;
            }
         });
         var menu:ContextMenu = new ContextMenu();
         menu.customItems = [item];
         contextMenu = menu;
         this.area = new Sprite();
         this.area.graphics.beginFill(16711680);
         this.area.graphics.drawRect(0,0,width,height);
         this.area.mouseEnabled = false;
         this.area.visible = false;
         hitArea = this.area;
         super.addChild(hitArea);
         this.canvas.mouseEnabled = false;
         super.addChild(this.canvas);
         this.showLogo();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(staticDevice == null)
         {
            staticDevice = new Device(stage,Context3DRenderMode.AUTO,this.constrained?"baselineConstrained":"baseline");
         }
         views.push(this);
         this.device = staticDevice;
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.canvas.graphics.clear();
         var _loc2_:int = views.indexOf(this);
         while(_loc2_ < views.length - 1)
         {
            views[_loc2_] = views[int(_loc2_ + 1)];
            _loc2_++;
         }
         views.pop();
         if(views.length == 0)
         {
            staticDevice.dispose();
            staticDevice = null;
         }
         this.device = null;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         this.altKey = param1.altKey;
         this.ctrlKey = param1.ctrlKey;
         this.shiftKey = param1.shiftKey;
         if(this.ctrlKey && this.shiftKey && param1.keyCode == Keyboard.F1 && this.bitmap == null)
         {
            this.bitmap = new Bitmap(Logo.image);
            this.bitmap.x = Math.round((this._width - this.bitmap.width) / 2);
            this.bitmap.y = Math.round((this._height - this.bitmap.height) / 2);
            super.addChild(this.bitmap);
            setTimeout(this.removeBitmap,2048);
         }
      }
      
      private function removeBitmap() : void
      {
         if(this.bitmap != null)
         {
            super.removeChild(this.bitmap);
            this.bitmap = null;
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         this.altKey = param1.altKey;
         this.ctrlKey = param1.ctrlKey;
         this.shiftKey = param1.shiftKey;
      }
      
      private function onMouse(param1:MouseEvent) : void
      {
         this.altKey = param1.altKey;
         this.ctrlKey = param1.ctrlKey;
         this.shiftKey = param1.shiftKey;
         this.buttonDown = param1.buttonDown;
         this.delta = param1.delta;
         this.lastEvent = param1;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.onMouse(param1);
         this.defineTarget(param1);
         if(this.target != null)
         {
            this.propagateEvent(MouseEvent3D.MOUSE_DOWN,this.target,this.branchToVector(this.target,branch));
         }
         this.pressedTarget = this.target;
         this.target = null;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         this.onMouse(param1);
         this.defineTarget(param1);
         if(this.target != null)
         {
            this.propagateEvent(MouseEvent3D.MOUSE_WHEEL,this.target,this.branchToVector(this.target,branch));
         }
         this.target = null;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.onMouse(param1);
         this.defineTarget(param1);
         if(this.target != null)
         {
            this.propagateEvent(MouseEvent3D.MOUSE_UP,this.target,this.branchToVector(this.target,branch));
            if(this.pressedTarget == this.target)
            {
               this.clickedTarget = this.target;
               this.propagateEvent(MouseEvent3D.CLICK,this.target,this.branchToVector(this.target,branch));
            }
         }
         this.pressedTarget = null;
         this.target = null;
      }
      
      private function onDoubleClick(param1:MouseEvent) : void
      {
         this.onMouse(param1);
         this.defineTarget(param1);
         if(this.target != null)
         {
            this.propagateEvent(MouseEvent3D.MOUSE_UP,this.target,this.branchToVector(this.target,branch));
            if(this.pressedTarget == this.target)
            {
               this.propagateEvent(this.clickedTarget == this.target && this.target.doubleClickEnabled?MouseEvent3D.DOUBLE_CLICK:MouseEvent3D.CLICK,this.target,this.branchToVector(this.target,branch));
            }
         }
         this.clickedTarget = null;
         this.pressedTarget = null;
         this.target = null;
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         this.onMouse(param1);
         this.defineTarget(param1);
         if(this.target != null)
         {
            this.propagateEvent(MouseEvent3D.MOUSE_MOVE,this.target,this.branchToVector(this.target,branch));
         }
         if(this.overedTarget != this.target)
         {
            this.processOverOut();
         }
         this.target = null;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.onMouse(param1);
         this.lastEvent = null;
         this.target = null;
         if(this.overedTarget != this.target)
         {
            this.processOverOut();
         }
         this.target = null;
      }
      
      alternativa3d function configure() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:View = null;
         var _loc1_:int = stage.quality == "LOW"?int(int(0)):stage.quality == "MEDIUM"?int(int(2)):int(int(4));
         var _loc2_:int = this.antiAliasEnabled && !this.constrained?int(int(_loc1_)):int(int(0));
         this.quality = _loc1_ > 0;
         if(!configured)
         {
            _loc3_ = 1000000;
            _loc4_ = 1000000;
            _loc5_ = -1000000;
            _loc6_ = -1000000;
            _loc7_ = 0;
            while(_loc7_ < views.length)
            {
               _loc8_ = views[_loc7_];
               coords.x = 0;
               coords.y = 0;
               _loc8_.globalCoords = _loc8_.localToGlobal(coords);
               if(_loc8_.globalCoords.x < _loc3_)
               {
                  _loc3_ = _loc8_.globalCoords.x;
               }
               if(_loc8_.globalCoords.y < _loc4_)
               {
                  _loc4_ = _loc8_.globalCoords.y;
               }
               if(_loc8_.globalCoords.x + _loc8_._width > _loc5_)
               {
                  _loc5_ = _loc8_.globalCoords.x + _loc8_._width;
               }
               if(_loc8_.globalCoords.y + _loc8_._height > _loc6_)
               {
                  _loc6_ = _loc8_.globalCoords.y + _loc8_._height;
               }
               _loc7_++;
            }
            this.device.x = _loc3_;
            this.device.y = _loc4_;
            this.device.width = _loc5_ - _loc3_;
            this.device.height = _loc6_ - _loc4_;
            this.device.antiAlias = _loc2_;
            this.device.enableDepthAndStencil = true;
            this.device.enableErrorChecking = false;
            configured = true;
         }
         if(this.globalCoords == null)
         {
            this.globalCoords = localToGlobal(new Point(0,0));
         }
         this.rect.x = int(this.globalCoords.x) - this.device.x;
         this.rect.y = int(this.globalCoords.y) - this.device.y;
         this.rect.width = int(this._width);
         this.rect.height = int(this._height);
         this.correction = true;
         this.canvas.x = this._width / 2;
         this.canvas.y = this._height / 2;
         this.canvas.graphics.clear();
      }
      
      public function clearArea() : void
      {
         if(!cleared)
         {
            this.device.clear((stage.color >> 16 & 255) / 255,(stage.color >> 8 & 255) / 255,(stage.color & 255) / 255);
            cleared = true;
         }
         else
         {
            this.device.clear((stage.color >> 16 & 255) / 255,(stage.color >> 8 & 255) / 255,(stage.color & 255) / 255,1,1,0,Context3DClearMask.DEPTH | Context3DClearMask.STENCIL);
         }
         if(this.rect.x != 0 || this.rect.y != 0 || this.rect.width != this.device.width || this.rect.height != this.device.height)
         {
            this.device.setScissorRectangle(this.rect);
            this.correction = true;
         }
      }
      
      alternativa3d function present() : void
      {
         var _loc1_:int = 0;
         var _loc2_:View = null;
         this.presented = true;
         this.device.setScissorRectangle(null);
         this.correction = false;
         _loc1_ = 0;
         while(_loc1_ < views.length)
         {
            _loc2_ = views[_loc1_];
            if(!_loc2_.presented)
            {
               break;
            }
            _loc1_++;
         }
         if(_loc1_ == views.length)
         {
            this.device.present();
            configured = false;
            cleared = false;
            _loc1_ = 0;
            while(_loc1_ < views.length)
            {
               _loc2_ = views[_loc1_];
               _loc2_.presented = false;
               _loc1_++;
            }
         }
      }
      
      alternativa3d function onRender(param1:Camera3D) : void
      {
      }
      
      private function processOverOut() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object3D = null;
         this.branchToVector(this.target,branch);
         this.branchToVector(this.overedTarget,overedBranch);
         var _loc1_:int = branch.length;
         var _loc2_:int = overedBranch.length;
         if(this.overedTarget != null)
         {
            this.propagateEvent(MouseEvent3D.MOUSE_OUT,this.overedTarget,overedBranch,true,this.target);
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc6_ = overedBranch[_loc4_];
               _loc5_ = 0;
               while(_loc5_ < _loc1_)
               {
                  if(_loc6_ == branch[_loc5_])
                  {
                     break;
                  }
                  _loc5_++;
               }
               if(_loc5_ == _loc1_)
               {
                  changedBranch[_loc3_] = _loc6_;
                  _loc3_++;
               }
               _loc4_++;
            }
            if(_loc3_ > 0)
            {
               changedBranch.length = _loc3_;
               this.propagateEvent(MouseEvent3D.ROLL_OUT,this.overedTarget,changedBranch,false,this.target);
            }
         }
         if(this.target != null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc6_ = branch[_loc4_];
               _loc5_ = 0;
               while(_loc5_ < _loc2_)
               {
                  if(_loc6_ == overedBranch[_loc5_])
                  {
                     break;
                  }
                  _loc5_++;
               }
               if(_loc5_ == _loc2_)
               {
                  changedBranch[_loc3_] = _loc6_;
                  _loc3_++;
               }
               _loc4_++;
            }
            if(_loc3_ > 0)
            {
               changedBranch.length = _loc3_;
               this.propagateEvent(MouseEvent3D.ROLL_OVER,this.target,changedBranch,false,this.overedTarget);
            }
            this.propagateEvent(MouseEvent3D.MOUSE_OVER,this.target,branch,true,this.overedTarget);
            useHandCursor = this.target.useHandCursor;
         }
         else
         {
            useHandCursor = false;
         }
         Mouse.cursor = Mouse.cursor;
         this.overedTarget = this.target;
      }
      
      private function branchToVector(param1:Object3D, param2:Vector.<Object3D>) : Vector.<Object3D>
      {
         var _loc3_:int = 0;
         while(param1 != null)
         {
            param2[_loc3_] = param1;
            _loc3_++;
            param1 = param1._parent;
         }
         param2.length = _loc3_;
         return param2;
      }
      
      private function propagateEvent(param1:String, param2:Object3D, param3:Vector.<Object3D>, param4:Boolean = true, param5:Object3D = null) : void
      {
         var _loc7_:Object3D = null;
         var _loc8_:Vector.<Function> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:MouseEvent3D = null;
         var _loc6_:int = param3.length;
         _loc10_ = _loc6_ - 1;
         while(_loc10_ > 0)
         {
            _loc7_ = param3[_loc10_];
            if(_loc7_.captureListeners != null)
            {
               _loc8_ = _loc7_.captureListeners[param1];
               if(_loc8_ != null)
               {
                  if(_loc12_ == null)
                  {
                     _loc12_ = new MouseEvent3D(param1,param4,param5,this.altKey,this.ctrlKey,this.shiftKey,this.buttonDown,this.delta);
                     _loc12_._target = param2;
                     _loc12_.calculateLocalRay(mouseX,mouseY,param2,this.camera);
                  }
                  _loc12_._currentTarget = _loc7_;
                  _loc12_._eventPhase = 1;
                  _loc9_ = _loc8_.length;
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     functions[_loc11_] = _loc8_[_loc11_];
                     _loc11_++;
                  }
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     (functions[_loc11_] as Function).call(null,_loc12_);
                     if(_loc12_.stopImmediate)
                     {
                        return;
                     }
                     _loc11_++;
                  }
                  if(_loc12_.stop)
                  {
                     return;
                  }
               }
            }
            _loc10_--;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            _loc7_ = param3[_loc10_];
            if(_loc7_.bubbleListeners != null)
            {
               _loc8_ = _loc7_.bubbleListeners[param1];
               if(_loc8_ != null)
               {
                  if(_loc12_ == null)
                  {
                     _loc12_ = new MouseEvent3D(param1,param4,param5,this.altKey,this.ctrlKey,this.shiftKey,this.buttonDown,this.delta);
                     _loc12_._target = param2;
                     _loc12_.calculateLocalRay(mouseX,mouseY,param2,this.camera);
                  }
                  _loc12_._currentTarget = _loc7_;
                  _loc12_._eventPhase = _loc10_ == 0?uint(uint(2)):uint(uint(3));
                  _loc9_ = _loc8_.length;
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     functions[_loc11_] = _loc8_[_loc11_];
                     _loc11_++;
                  }
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     (functions[_loc11_] as Function).call(null,_loc12_);
                     if(_loc12_.stopImmediate)
                     {
                        return;
                     }
                     _loc11_++;
                  }
                  if(_loc12_.stop)
                  {
                     return;
                  }
               }
            }
            _loc10_++;
         }
      }
      
      private function defineTarget(param1:MouseEvent) : void
      {
         var _loc2_:Object3D = null;
         var _loc3_:Object3D = null;
         var _loc6_:Canvas = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:Object3D = null;
         var _loc9_:Object3D = null;
         mouse.x = param1.localX;
         mouse.y = param1.localY;
         var _loc4_:Array = stage != null?stage.getObjectsUnderPoint(localToGlobal(mouse)):super.getObjectsUnderPoint(mouse);
         var _loc5_:int = _loc4_.length - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = null;
            _loc7_ = _loc4_[_loc5_];
            while(_loc7_.parent != stage)
            {
               _loc6_ = _loc7_ as Canvas;
               if(_loc6_ != null)
               {
                  break;
               }
               _loc7_ = _loc7_.parent;
            }
            if(_loc6_ != null)
            {
               if(_loc3_ != null)
               {
                  _loc8_ = null;
                  _loc9_ = _loc3_;
                  while(_loc9_ != null)
                  {
                     if(_loc9_ is Object3DContainer && !Object3DContainer(_loc9_).mouseChildren)
                     {
                        _loc8_ = null;
                     }
                     if(_loc8_ == null && _loc9_.mouseEnabled)
                     {
                        _loc8_ = _loc9_;
                     }
                     _loc9_ = _loc9_._parent;
                  }
                  if(_loc8_ != null)
                  {
                     if(this.target != null)
                     {
                        _loc9_ = _loc8_;
                        while(_loc9_ != null)
                        {
                           if(_loc9_ == this.target)
                           {
                              _loc2_ = _loc3_;
                              this.target = _loc8_;
                              break;
                           }
                           _loc9_ = _loc9_._parent;
                        }
                     }
                     else
                     {
                        _loc2_ = _loc3_;
                        this.target = _loc8_;
                     }
                     if(_loc2_ == this.target)
                     {
                        break;
                     }
                  }
               }
            }
            _loc5_--;
         }
      }
      
      override public function getObjectsUnderPoint(param1:Point) : Array
      {
         return null;
      }
      
      public function showLogo() : void
      {
         if(this.logo == null)
         {
            this.logo = new Logo();
            super.addChild(this.logo);
            this.resizeLogo();
         }
      }
      
      public function hideLogo() : void
      {
         if(this.logo != null)
         {
            super.removeChild(this.logo);
            this.logo = null;
         }
      }
      
      public function get logoAlign() : String
      {
         return this._logoAlign;
      }
      
      public function set logoAlign(param1:String) : void
      {
         this._logoAlign = param1;
         this.resizeLogo();
      }
      
      public function get logoHorizontalMargin() : Number
      {
         return this._logoHorizontalMargin;
      }
      
      public function set logoHorizontalMargin(param1:Number) : void
      {
         this._logoHorizontalMargin = param1;
         this.resizeLogo();
      }
      
      public function get logoVerticalMargin() : Number
      {
         return this._logoVerticalMargin;
      }
      
      public function set logoVerticalMargin(param1:Number) : void
      {
         this._logoVerticalMargin = param1;
         this.resizeLogo();
      }
      
      private function resizeLogo() : void
      {
         if(this.logo != null)
         {
            if(this._logoAlign == StageAlign.TOP_LEFT || this._logoAlign == StageAlign.LEFT || this._logoAlign == StageAlign.BOTTOM_LEFT)
            {
               this.logo.x = Math.round(this._logoHorizontalMargin);
            }
            if(this._logoAlign == StageAlign.TOP || this._logoAlign == StageAlign.BOTTOM)
            {
               this.logo.x = Math.round((this._width - this.logo.width) / 2);
            }
            if(this._logoAlign == StageAlign.TOP_RIGHT || this._logoAlign == StageAlign.RIGHT || this._logoAlign == StageAlign.BOTTOM_RIGHT)
            {
               this.logo.x = Math.round(this._width - this._logoHorizontalMargin - this.logo.width);
            }
            if(this._logoAlign == StageAlign.TOP_LEFT || this._logoAlign == StageAlign.TOP || this._logoAlign == StageAlign.TOP_RIGHT)
            {
               this.logo.y = Math.round(this._logoVerticalMargin);
            }
            if(this._logoAlign == StageAlign.LEFT || this._logoAlign == StageAlign.RIGHT)
            {
               this.logo.y = Math.round((this._height - this.logo.height) / 2);
            }
            if(this._logoAlign == StageAlign.BOTTOM_LEFT || this._logoAlign == StageAlign.BOTTOM || this._logoAlign == StageAlign.BOTTOM_RIGHT)
            {
               this.logo.y = Math.round(this._height - this._logoVerticalMargin - this.logo.height);
            }
         }
      }
      
      public function clear() : void
      {
         if(this.device != null && this.device.ready)
         {
            this.device.clear((stage.color >> 16 & 255) / 255,(stage.color >> 8 & 255) / 255,(stage.color & 255) / 255);
         }
         this.canvas.graphics.clear();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.area.width = param1;
         this.resizeLogo();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         this.area.height = param1;
         this.resizeLogo();
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function swapChildren(param1:DisplayObject, param2:DisplayObject) : void
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function getChildByName(param1:String) : DisplayObject
      {
         throw new Error("Unsupported operation.");
      }
      
      override public function get numChildren() : int
      {
         return 0;
      }
   }
}

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.net.URLRequest;
import flash.net.navigateToURL;

class Logo extends Sprite
{
   
   public static const image:BitmapData = createBMP();
    
   
   private var border:int = 5;
   
   private var over:Boolean = false;
   
   private var press:Boolean;
   
   function Logo()
   {
      super();
      graphics.beginFill(16711680,0);
      graphics.drawRect(0,0,image.width + this.border + this.border,image.height + this.border + this.border);
      graphics.drawRect(this.border,this.border,image.width,image.height);
      graphics.beginBitmapFill(image,new Matrix(1,0,0,1,this.border,this.border),false,true);
      graphics.drawRect(this.border,this.border,image.width,image.height);
      tabEnabled = false;
      buttonMode = true;
      useHandCursor = true;
      addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      addEventListener(MouseEvent.CLICK,this.onClick);
      addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
      addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      addEventListener(MouseEvent.MOUSE_OVER,this.onMouseMove);
      addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
   }
   
   private static function createBMP() : BitmapData
   {
      var _loc1_:BitmapData = new BitmapData(103,22,true,0);
      _loc1_.setVector(_loc1_.rect,Vector.<uint>([0,0,0,0,0,0,0,0,0,0,0,0,0,0,1040187392,2701131776,2499805184,738197504,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,2516582400,0,0,0,0,2516582400,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,771751936,2533359616,4282199055,4288505883,4287716373,4280949511,2298478592,234881024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294892416,4278190080,0,0,0,0,4278190080,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1728053248,4279504646,4287917866,4294285341,4294478345,4294478346,4293626391,4285810708,4278387201,1291845632,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,2516582400,2516582400,4278190080,2516582400,2516582400,4278190080,2516582400,2516582400,4278190080,2516582400,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,2516582400,4278190080,2516582400,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,4294892416,4278190080,0,0,0,0,4278190080,4294892416,4278190080,4278190080,4278190080,2516582400,2516582400,4278190080,2516582400,0,2516582400,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2197815296,4280753934,4291530288,4294412558,4294411013,4294411784,4294411784,4294411271,4294411790,4289816858,4279635461,1711276032,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,4278190080,4294892416,4294892416,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,2516582400,4278190080,4294892416,4278190080,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,4278190080,4294892416,4294892416,4294892416,4294892416,4278190080,0,0,0,0,4278190080,4294892416,4294892416,4294892416,4294892416,4278190080,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2332033024,4283252258,4293301553,4294409478,4294409991,4294410761,4294476552,4294476296,4294410249,4294344200,4294343945,4291392799,4280752908,2030043136,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4278190080,4278190080,2516582400,0,0,0,0,2516582400,4278190080,4278190080,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2281701376,4283186471,4293692972,4294276097,4294343176,4294409225,4294475017,4293554194,4293817874,4294408967,4294342921,4294342664,4294341895,4292640548,4281936662,2197815296,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4294892416,4294892416,4294892416,4278190080,4294892416,4278190080,2516582400,4278190080,4294892416,4278190080,4294892416,4294892416,4294892416,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,0,0,0,0,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2030043136,4282068512,4293561399,4294208769,4294210313,4294407689,4294210313,4290530057,4281734151,4282851341,4291913754,4294275848,4294275591,4294275592,4294208517,4293164329,4282133785,2080374784,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,4278190080,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4278190080,4278190080,4278190080,4294892416,4278190080,0,4278190080,4294892416,4278190080,4278190080,4278190080,4278190080,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,0,0,0,0,4278190080,4294892416,4278190080,4278190080,4278190080,4294892416,4278190080,4294892416,4278190080,4278190080,4278190080,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1627389952,4280293393,4292577349,4294272769,4294208264,4294471177,4293617417,4286918406,4279502337,1912602624,2030043136,4280422919,4289945382,4294009867,4293875462,4293743369,4293610244,4292440624,4280950288,1761607680,0,0,0,0,0,0,0,0,0,4278190080,4294892416,4294892416,4294892416,4294892416,4278190080,2516582400,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,2516582400,4278190080,4294892416,4278190080,4278190080,4294892416,4294892416,4278190080,4278190080,4294892416,4294892416,4294892416,4278190080,4278190080,4294892416,4278190080,0,2516582400,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,0,0,0,0,2516582400,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,4278190080,4294892416,4294892416,4294892416,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,788529152,4279044359,4291067728,4294075141,4294075143,4294338057,4293352968,4284490243,4278321408,1291845632,0,0,1476395008,4278781187,4288236848,4293610511,4293609221,4293610249,4293609989,4291261239,4279241478,1291845632,0,0,0,0,0,0,0,0,4278190080,4294892416,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,2516582400,4278190080,2516582400,2516582400,4278190080,4278190080,2516582400,2516582400,4278190080,4278190080,4278190080,2516582400,2516582400,4278190080,2516582400,0,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,0,0,0,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,2550136832,4287849288,4294009360,4293941509,4294007817,4293679113,4284620803,2852126720,822083584,0,0,0,0,989855744,2751463424,4288172857,4293610511,4293543429,4293543943,4293611019,4289621050,4278649858,620756992,0,0,0,0,0,0,0,4278190080,4294892416,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294892416,4294892416,4294892416,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,2030043136,4283380775,4294011945,4293873409,4293939977,4293808649,4285867012,4278649344,1090519040,0,0,0,0,0,0,939524096,4278255872,4288764223,4293609227,4293543175,4293542917,4293677843,4287124784,2516582400,0,0,0,0,0,0,0,2516582400,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,805306368,4279569674,4292243009,4293609217,4293676041,4293937929,4288687621,4279305216,1543503872,0,0,0,0,0,0,0,452984832,2214592512,4278781188,4290602054,4293410821,4293477384,4293476868,4293745950,4283773466,2181038080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2566914048,4287714107,4293543949,4293542919,4293673225,4291834377,4280879106,2080374784,0,0,0,0,0,0,0,1962934272,4279898124,4286467380,4278846980,4280686612,4292961598,4293343745,4293411081,4293476100,4292566822,4280357128,1140850688,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,2516582400,2516582400,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,2516582400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,0,0,2516582400,4278190080,2516582400,0,0,1207959552,4281539862,4293417771,4293343234,4293277193,4292947466,4284880134,2483027968,0,0,0,0,0,0,989855744,2751463424,4282917657,4291648314,4293346067,4288303409,2734686208,4284299053,4293479197,4293343493,4293409801,4293410569,4288759582,2902458368,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4294967295,4278190080,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4278190080,4293141248,4293141248,4293141248,4278190080,2516582400,0,0,0,4278190080,4293141248,4278190080,0,0,2969567232,4289023795,4293211656,4293144328,4293143305,4290389514,4279108353,536870912,0,0,0,335544320,1543503872,2986344448,4281076999,4287967257,4293213977,4293078532,4293078275,4293412634,4284428061,2986344448,4289023285,4293277192,4293343240,4293277191,4293412372,4282850829,1711276032,0,0,0,0,0,0,0,2516582400,4278190080,2516582400,0,0,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,2516582400,4278190080,2516582400,4278190080,4278190080,4278190080,4278190080,2516582400,0,0,0,2516582400,4278190080,2516582400,0,2516582400,4278190080,4294967295,4278190080,4278190080,2516582400,4278190080,2516582400,0,0,0,2516582400,4278190080,2516582400,0,2516582400,4278190080,2516582400,0,0,2516582400,4278190080,4278190080,4278190080,4293141248,4278190080,2516582400,4278190080,4278190080,4278190080,4293141248,4278190080,0,956301312,4281604366,4293149982,4293077253,4293078025,4292684810,4282912516,1979711488,1660944384,1778384896,2130706432,3204448256,4279371011,4283635982,4288752661,4292621844,4293078537,4293078022,4293078537,4293210121,4293144583,4290726433,4278518273,4280422668,4292691489,4293210117,4293276937,4293276680,4290592536,4278649601,134217728,0,0,0,0,0,2516582400,4278190080,4294967295,4278190080,2516582400,0,4278190080,4294967295,4278190080,4294967295,4294967295,4278190080,4278190080,4294967295,4294967295,4294967295,4278190080,2516582400,2516582400,4278190080,4294967295,4278190080,4294967295,4294967295,4294967295,4294967295,4278190080,2516582400,0,2516582400,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4294967295,4278190080,4294967295,4278190080,4294967295,4278190080,0,0,0,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,2516582400,0,0,4278190080,4293141248,4293141248,4278190080,2516582400,4278190080,4293141248,4293141248,4293141248,4293141248,4278190080,0,2717908992,4287903514,4293078538,4293078280,4293143817,4290652684,4281666563,4281797635,4283831561,4284292110,4285670934,4289475868,4291769878,4293079566,4293078281,4293078023,4293078280,4293209609,4293275145,4292357130,4287900432,4280290309,1728053248,2432696320,4286854178,4293145355,4293144584,4293144328,4293212431,4283636492,1610612736,0,0,0,0,2516582400,4278190080,4294967295,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4294967295,4278190080,4294967295,4278190080,2516582400,0,2516582400,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,2516582400,0,2516582400,4278190080,4278190080,4293141248,4278190080,4293141248,4278190080,4278190080,4278190080,4278190080,2516582400,520093696,4280027652,4292426772,4293078279,4293079049,4293144329,4292751115,4292555019,4292948491,4293079819,4293146126,4293211917,4293210888,4293145095,4293210632,4293144841,4293210633,4293275913,4292685578,4288618760,4282584324,2969567232,1207959552,0,671088640,4279896839,4292362526,4293078022,4293078793,4293078536,4290065172,4278780673,167772160,0,0,2516582400,4278190080,4294967295,4278190080,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4294967295,4294967295,4294967295,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,0,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4278190080,4294967295,4278190080,2516582400,0,0,4278190080,4293141248,4278190080,4293141248,4278190080,0,4278190080,4293141248,4278190080,1811939328,4284620297,4293211403,4293210888,4293211145,4293276937,4293277193,4293277961,4293344265,4293410056,4293344776,4293344776,4293345033,4293410569,4293475848,4293344265,4292819211,4289276169,4283437573,4278714880,1828716544,0,0,0,0,2516582400,4287181084,4293078538,4293078025,4293143560,4293211664,4283110665,1409286144,0,0,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4278190080,4278190080,4278190080,4294967295,4278190080,0,4278190080,4294967295,4278190080,0,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4278190080,4278190080,4278190080,4293141248,4278190080,4293141248,4278190080,4278190080,4278190080,4293141248,4278190080,3087007744,4289148172,4293345035,4293345034,4293411080,4293476870,4293477893,4293544453,4293611013,4293677063,4293677833,4293677833,4293612298,4293218572,4292102669,4287771145,4282651909,4278714880,1912602624,218103808,0,0,0,0,0,771751936,4280880904,4292621585,4293143048,4292685067,4290916111,4284160266,1811939328,0,0,4278190080,4294967295,4294967295,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4278190080,4294967295,4278190080,4294967295,4278190080,4278190080,4294967295,4294967295,4294967295,4278190080,4278190080,4294967295,4278190080,0,4278190080,4294967295,4278190080,0,4278190080,4294967295,4278190080,4294967295,4294967295,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4294967295,4278190080,4294967295,4278190080,0,2516582400,4278190080,4294967295,4278190080,2516582400,4278190080,4294967295,4294967295,4294967295,4278190080,2516582400,4278190080,4294967295,4278190080,4293141248,4293141248,4293141248,4278190080,2516582400,4278190080,4293141248,4293141248,4293141248,4278190080,2516582400,1325400064,4280618243,4284819723,4287709972,4289877530,4293028892,4293948702,4293883680,4293818144,4292045341,4289484568,4288433169,4286856717,4282916870,4279831042,3036676096,1526726656,184549376,0,0,0,0,0,0,0,0,3305111552,4289014285,4288159495,4283372037,4279370753,2164260864,50331648,0,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,2516582400,2516582400,4278190080,2516582400,4278190080,2516582400,2516582400,4278190080,4278190080,4278190080,2516582400,2516582400,4278190080,2516582400,0,2516582400,4278190080,2516582400,0,2516582400,4278190080,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,2516582400,4278190080,2516582400,4278190080,2516582400,0,0,2516582400,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,2516582400,4278190080,4278190080,4278190080,2516582400,0,2516582400,4278190080,4278190080,4278190080,2516582400,0,0,671088640,1828716544,2600468480,3170893824,4026531840,4261412864,4261412864,4261412864,3808428032,3170893824,2969567232,2667577344,1526726656,553648128,0,0,0,0,0,0,0,0,0,0,0,1543503872,3305111552,3120562176,1811939328,385875968,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]));
      return _loc1_;
   }
   
   private function onMouseDown(param1:MouseEvent) : void
   {
      param1.stopPropagation();
   }
   
   private function onClick(param1:MouseEvent) : void
   {
      param1.stopPropagation();
      try
      {
         navigateToURL(new URLRequest("http://alternativaplatform.com"),"_blank");
         return;
      }
      catch(e:Error)
      {
         return;
      }
   }
   
   private function onDoubleClick(param1:MouseEvent) : void
   {
      param1.stopPropagation();
   }
   
   private function onMouseMove(param1:MouseEvent) : void
   {
      param1.stopPropagation();
   }
   
   private function onMouseOut(param1:MouseEvent) : void
   {
      param1.stopPropagation();
   }
   
   private function onMouseWheel(param1:MouseEvent) : void
   {
      param1.stopPropagation();
   }
}
