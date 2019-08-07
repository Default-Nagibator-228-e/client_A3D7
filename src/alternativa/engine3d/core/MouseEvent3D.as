package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   use namespace alternativa3d;
   
   public class MouseEvent3D extends Event
   {
      
      public static const CLICK:String = "click3D";
      
      public static const DOUBLE_CLICK:String = "doubleClick3D";
      
      public static const MOUSE_DOWN:String = "mouseDown3D";
      
      public static const MOUSE_UP:String = "mouseUp3D";
      
      public static const MOUSE_OVER:String = "mouseOver3D";
      
      public static const MOUSE_OUT:String = "mouseOut3D";
      
      public static const ROLL_OVER:String = "rollOver3D";
      
      public static const ROLL_OUT:String = "rollOut3D";
      
      public static const MOUSE_MOVE:String = "mouseMove3D";
      
      public static const MOUSE_WHEEL:String = "mouseWheel3D";
       
      
      public var ctrlKey:Boolean;
      
      public var altKey:Boolean;
      
      public var shiftKey:Boolean;
      
      public var buttonDown:Boolean;
      
      public var delta:int;
      
      public var relatedObject:Object3D;
      
      public var localOrigin:Vector3D;
      
      public var localDirection:Vector3D;
      
      alternativa3d var _target:Object3D;
      
      alternativa3d var _currentTarget:Object3D;
      
      alternativa3d var _bubbles:Boolean;
      
      alternativa3d var _eventPhase:uint = 3;
      
      alternativa3d var stop:Boolean = false;
      
      alternativa3d var stopImmediate:Boolean = false;
      
      public function MouseEvent3D(param1:String, param2:Boolean = true, param3:Object3D = null, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:int = 0)
      {
         this.localOrigin = new Vector3D();
         this.localDirection = new Vector3D();
         super(param1,param2);
         this.relatedObject = param3;
         this.altKey = param4;
         this.ctrlKey = param5;
         this.shiftKey = param6;
         this.buttonDown = param7;
         this.delta = param8;
      }
      
      alternativa3d function calculateLocalRay(param1:Number, param2:Number, param3:Object3D, param4:Camera3D) : void
      {
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         param4.calculateRay(this.localOrigin,this.localDirection,param1,param2);
         param3.composeMatrix();
         var _loc5_:Object3D = param3;
         while(_loc5_._parent != null)
         {
            _loc5_ = _loc5_._parent;
            _loc5_.composeMatrix();
            param3.appendMatrix(_loc5_);
         }
         param3.invertMatrix();
         _loc6_ = this.localOrigin.x;
         var _loc7_:Number = this.localOrigin.y;
         _loc8_ = this.localOrigin.z;
         _loc9_ = this.localDirection.x;
         _loc10_ = this.localDirection.y;
         _loc11_ = this.localDirection.z;
         this.localOrigin.x = param3.ma * _loc6_ + param3.mb * _loc7_ + param3.mc * _loc8_ + param3.md;
         this.localOrigin.y = param3.me * _loc6_ + param3.mf * _loc7_ + param3.mg * _loc8_ + param3.mh;
         this.localOrigin.z = param3.mi * _loc6_ + param3.mj * _loc7_ + param3.mk * _loc8_ + param3.ml;
         this.localDirection.x = param3.ma * _loc9_ + param3.mb * _loc10_ + param3.mc * _loc11_;
         this.localDirection.y = param3.me * _loc9_ + param3.mf * _loc10_ + param3.mg * _loc11_;
         this.localDirection.z = param3.mi * _loc9_ + param3.mj * _loc10_ + param3.mk * _loc11_;
      }
      
      override public function get bubbles() : Boolean
      {
         return this._bubbles;
      }
      
      override public function get eventPhase() : uint
      {
         return this._eventPhase;
      }
      
      override public function get target() : Object
      {
         return this._target;
      }
      
      override public function get currentTarget() : Object
      {
         return this._currentTarget;
      }
      
      override public function stopPropagation() : void
      {
         this.stop = true;
      }
      
      override public function stopImmediatePropagation() : void
      {
         this.stopImmediate = true;
      }
      
      override public function clone() : Event
      {
         return new MouseEvent3D(type,this._bubbles,this.relatedObject,this.altKey,this.ctrlKey,this.shiftKey,this.buttonDown,this.delta);
      }
      
      override public function toString() : String
      {
         return formatToString("MouseEvent3D","type","bubbles","eventPhase","relatedObject","altKey","ctrlKey","shiftKey","buttonDown","delta");
      }
   }
}
