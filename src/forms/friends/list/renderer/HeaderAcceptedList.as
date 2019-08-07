package forms.friends.list.renderer
{
   import alternativa.osgi.service.locale.ILocaleService;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   
   public class HeaderAcceptedList extends Sprite
   {
      
      [Inject]
      public static var localeService:ILocaleService;
      
      public static var HEADERS:Vector.<HeaderData>;
       
      
      protected var tabs:Vector.<Number>;
      
      protected var _width:int = 800;
      
      public function HeaderAcceptedList()
      {
         var _loc1_:FriendsHeaderItem = null;
         this.tabs = new Vector.<Number>();
         super();
         HEADERS = Vector.<HeaderData>([new HeaderData("Имя",TextFormatAlign.LEFT,2),new HeaderData("Битвы",TextFormatAlign.LEFT,2)]);
         var _loc2_:int = HEADERS.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = new FriendsHeaderItem(HEADERS[_loc3_].align);
            _loc1_.label = HEADERS[_loc3_].text;
            _loc1_.setLabelPosX(HEADERS[_loc3_].posX);
            _loc1_.height = 18;
            addChild(_loc1_);
            _loc3_++;
         }
         this.draw();
      }
      
      protected function draw() : void
      {
         var _loc1_:FriendsHeaderItem = null;
         this.tabs = Vector.<Number>([0,this._width / 2,this._width - 1]);
         var _loc2_:int = HEADERS.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = getChildAt(_loc3_) as FriendsHeaderItem;
            _loc1_.width = this.tabs[_loc3_ + 1] - this.tabs[_loc3_] - 2;
            _loc1_.x = this.tabs[_loc3_];
            _loc3_++;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = Math.floor(param1);
         this.draw();
      }
   }
}

class HeaderData
{
    
   
   public var text:String;
   
   public var align:String;
   
   public var posX:int;
   
   function HeaderData(param1:String, param2:String, param3:int)
   {
      super();
      this.text = param1;
      this.align = param2;
      this.posX = param3;
   }
}
