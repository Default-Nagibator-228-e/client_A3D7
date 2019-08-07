package alternativa.tanks.help
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Helper extends Sprite
   {
       
      
      public var showDuration:int = 5000;
      
      protected var _showNum:int = 0;
      
      protected var _showLimit:int = -1;
      
      protected var _size:Point;
      
      protected var _targetPoint:Point;
      
      private var _id:int;
      
      private var _groupKey:String;
      
      private var _timer:HelperTimer;
      
      public function Helper()
      {
         super();
         this._targetPoint = new Point();
      }
      
      public function draw(size:Point) : void
      {
      }
      
      public function align(stageWidth:int, stageHeight:int) : void
      {
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
      
      public function get groupKey() : String
      {
         return this._groupKey;
      }
      
      public function set groupKey(value:String) : void
      {
         this._groupKey = value;
      }
      
      public function get timer() : HelperTimer
      {
         return this._timer;
      }
      
      public function set timer(t:HelperTimer) : void
      {
         this._timer = t;
      }
      
      public function get size() : Point
      {
         return this._size;
      }
      
      public function get showNum() : int
      {
         return this._showNum;
      }
      
      public function set showNum(value:int) : void
      {
         this._showNum = value;
      }
      
      public function get showLimit() : int
      {
         return this._showLimit;
      }
      
      public function get targetPoint() : Point
      {
         return this._targetPoint;
      }
      
      public function set targetPoint(p:Point) : void
      {
         this._targetPoint = p.clone();
      }
   }
}
