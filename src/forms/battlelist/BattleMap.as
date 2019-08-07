package forms.battlelist
{
   import flash.display.BitmapData;
   
   public class BattleMap
   {
       
      
      private var _id:Object;
      
      private var _gameName:String;
      
      private var _minRank:int;
      
      private var _maxRank:int;
      
      private var _maxPeople:int;
      
      private var _preview:BitmapData;
      
      private var _ctf:Boolean;
      
      private var _tdm:Boolean;
      
      private var _themeName:String;
      
      public function BattleMap()
      {
         super();
      }
      
      public function get id() : Object
      {
         return this._id;
      }
      
      public function set id(id:Object) : void
      {
         this._id = id;
      }
      
      public function get gameName() : String
      {
         return this._gameName;
      }
      
      public function set gameName(gameName:String) : void
      {
         this._gameName = gameName;
      }
      
      public function get minRank() : int
      {
         return this._minRank;
      }
      
      public function set minRank(minRank:int) : void
      {
         this._minRank = minRank;
      }
      
      public function get maxRank() : int
      {
         return this._maxRank;
      }
      
      public function set maxRank(maxRank:int) : void
      {
         this._maxRank = maxRank;
      }
      
      public function get maxPeople() : int
      {
         return this._maxPeople;
      }
      
      public function set maxPeople(maxPeople:int) : void
      {
         this._maxPeople = maxPeople;
      }
      
      public function get preview() : BitmapData
      {
         return this._preview;
      }
      
      public function set preview(preview:BitmapData) : void
      {
         this._preview = preview;
      }
      
      public function get ctf() : Boolean
      {
         return this._ctf;
      }
      
      public function set ctf(ctf:Boolean) : void
      {
         this._ctf = ctf;
      }
      
      public function get tdm() : Boolean
      {
         return this._tdm;
      }
      
      public function set tdm(value:Boolean) : void
      {
         this._tdm = value;
      }
      
      public function set themeName(themeName:String) : void
      {
         this._themeName = themeName;
      }
      
      public function get themeName() : String
      {
         return this._themeName;
      }
      
      public function draw() : void
      {
      }
   }
}
