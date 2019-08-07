package forms.friends.list.dataprovider
{
   import alternativa.types.Long;
   import fl.data.DataProvider;
   import flash.utils.Dictionary;
   
   public class FriendsDataProvider extends DataProvider
   {
      
      public static const IS_NEW:String = "isNew";
      
      public static const ID:String = "id";
      
      public static const ONLINE:String = "online";
      
      public static const IS_BATTLE:String = "isBattle";
      
      public static const UID:String = "uid";
      
      public static const AVAILABLE_INVITE:String = "availableInvite";
      
      public static const AVAILABLE_BATTLE:String = "availableBattle";
      
      private static var _escapePattern:RegExp = /\-|\./;
      
      private static var _globSearchPattern:RegExp = /\*/g;
       
      
      private var _getItemAtHandler:Function;
      
      private var _store:Dictionary;
      
      private var _filterPropertyName:String;
      
      private var _filterString:String;
      
      private var _filterPattern:RegExp;
      
      private var _sortFields:Object;
      
      private var _sortFieldsProperties:Object;
	  
	  public var de:Long = new Long(0,10000);
      
      public function FriendsDataProvider()
      {
         this._store = new Dictionary();
         this._filterString = "";
         super();
      }
      
      private static function prepareSearchPattern(param1:String) : RegExp
      {
         param1 = param1.replace(_escapePattern,"\\$&").replace(_globSearchPattern,".*");
         param1 = "^" + param1;
         return new RegExp(param1,"i");
      }
      
      public function get getItemAtHandler() : Function
      {
         return this._getItemAtHandler;
      }
      
      public function set getItemAtHandler(param1:Function) : void
      {
         this._getItemAtHandler = param1;
      }
      
      override public function getItemAt(param1:uint) : Object
      {
         var _loc2_:Object = super.getItemAt(param1);
         if(this.getItemAtHandler != null)
         {
            this.getItemAtHandler(_loc2_);
         }
         return _loc2_;
      }
      
      public function setUserAsNew(param1:Long, param2:Boolean = true) : int
      {
         var _loc3_:int = this.setPropertiesById(param1,IS_NEW,true);
         if(param2 && _loc3_ != -1)
         {
            this.reSort();
         }
         return _loc3_;
      }
      
      public function setOnlineUser(param1:Long, param2:Boolean = true) : int
      {
         var _loc3_:int = this.setPropertiesById(param1,ONLINE,param2);
         if(param2 && _loc3_ != -1)
         {
            this.reSort();
         }
         return _loc3_;
      }
      /*
      public function setBattleUser(param1:BattleLinkData, param2:Boolean = true) : int
      {
         var _loc3_:int = this.setPropertiesById(param1.userId,IS_BATTLE,param1.isShowBattle());
         if(_loc3_ != -1)
         {
            this.setPropertiesById(param1.userId,AVAILABLE_BATTLE,param1.availableRank());
            this.getItemAt(_loc3_).battleData = param1;
         }
         if(param2 && _loc3_ != -1)
         {
            this.reSort();
         }
         return _loc3_;
      }
      */
      public function updatePropertyAvailableInvite() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = this.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = super.getItemAt(_loc3_);
           // _loc1_.availableInvite = battleInfoService.availableRank(_loc1_.rank);
            //super.replaceItemAt(_loc1_,_loc3_);
            //super.invalidateItemAt(_loc3_);
            _loc3_++;
         }
      }
      
      public function updatePropertyAvailableInviteById(param1:Long) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = this.setPropertiesById(param1,AVAILABLE_INVITE,false);
         if(_loc2_ != -1)
         {
            _loc3_ = super.getItemAt(_loc2_);
            //_loc3_.availableInvite = battleInfoService.availableRank(_loc3_.rank);
            //super.replaceItemAt(_loc3_,_loc2_);
            //super.invalidateItemAt(_loc2_);
         }
      }
      
      public function clearBattleUser(param1:Long, param2:Boolean = true) : int
      {
         var _loc3_:int = this.setPropertiesById(param1,IS_BATTLE,false);
         if(_loc3_ != -1)
         {
            this.setPropertiesById(param1,AVAILABLE_BATTLE,false);
         }
         if(param2 && _loc3_ != -1)
         {
            this.reSort();
         }
         return _loc3_;
      }
      
      public function addUser(param1:String, param2:String, param3:int, p:int, p1:Boolean) : void
      {
         var _loc4_:Object = {};
		 var dsf:Long = new Long(0, param3);
         _loc4_.id = dsf;
		 _loc4_.idb = param2;
         _loc4_.uid = param1;
		 _loc4_.gu = param3;
         _loc4_.rank = p;
         _loc4_.online = p1;
         _loc4_.isNew = false;
         _loc4_.availableInvite = false;
         _loc4_.isBattle = false;
         _loc4_.availableBattle = false;
         _loc4_.snUid = param1;
         _loc4_.isSNFriend = false;
         _loc4_.isReferral = false;
         super.addItem(_loc4_);
         this._store[dsf] = _loc4_;
         this.refresh();
      }
      
      public function removeUser(param1:Long) : void
      {
         if(!(param1 in this._store))
         {
            return;
         }
         var _loc2_:int = this.getItemIndexByProperty(ID,param1);
         if(_loc2_ >= 0)
         {
            super.removeItemAt(_loc2_);
         }
         delete this._store[param1];
      }
      
      override public function removeAll() : void
      {
         this._store = new Dictionary();
         super.removeAll();
      }
      
      public function refresh() : void
      {
         this.filter();
         this.reSort();
      }
      
      override public function sortOn(param1:Object, param2:Object = null) : *
      {
         this._sortFields = param1;
         this._sortFieldsProperties = param2;
         super.sortOn(this._sortFields,this._sortFieldsProperties);
      }
      
      public function reSort() : void
      {
         super.sortOn(this._sortFields,this._sortFieldsProperties);
      }
      
      public function setFilter(param1:String, param2:String) : void
      {
         if(param2 == "" && this._filterString != "")
         {
            this.resetFilter();
            return;
         }
         this._filterPropertyName = param1;
         this._filterString = param2;
         this._filterPattern = prepareSearchPattern(this._filterString);
         this.filter();
      }
      
      public function filter() : void
      {
         var _loc1_:Object = null;
         if(this._filterString != "")
         {
            super.removeAll();
            for each(_loc1_ in this._store)
            {
               if(this.isFilteredItem(_loc1_))
               {
                  super.addItem(_loc1_);
               }
            }
         }
         this.reSort();
      }
      
      public function resetFilter(param1:Boolean = true) : void
      {
         var _loc2_:Object = null;
         this._filterString = "";
         if(!param1)
         {
            return;
         }
         super.removeAll();
         for each(_loc2_ in this._store)
         {
            super.addItem(_loc2_);
         }
         this.reSort();
      }
      
      private function isFilteredItem(param1:Object) : Boolean
      {
         return param1.hasOwnProperty(this._filterPropertyName) && param1[this._filterPropertyName].search(this._filterPattern) != -1;
      }
      
      public function setPropertiesById(param1:Long, param2:String, param3:Object) : int
      {
         var _loc5_:Object = null;
         var _loc4_:int = this.getItemIndexByProperty(ID,param1);
         if(_loc4_ != -1)
         {
            _loc5_ = super.getItemAt(_loc4_);
            _loc5_[param2] = param3;
            super.replaceItemAt(_loc5_,_loc4_);
            super.invalidateItemAt(_loc4_);
         }
         if(param1 in this._store)
         {
            this._store[param1][param2] = param3;
         }
         return _loc4_;
      }
      
      public function getItemIndexByProperty(param1:String, param2:*, param3:Boolean = false) : int
      {
         var _loc4_:Object = null;
         var _loc7_:* = undefined;
         var _loc5_:int = this.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = super.getItemAt(_loc6_);
            if(_loc4_ && _loc4_.hasOwnProperty(param1) && _loc4_[param1] == param2)
            {
               return _loc6_;
            }
            _loc6_++;
         }
         if(param3)
         {
            for(_loc7_ in this._store)
            {
               _loc4_ = this._store[_loc7_];
               if(_loc4_.hasOwnProperty(param1) && _loc4_[param1] == param2)
               {
                  return _loc6_;
               }
            }
         }
         return -1;
      }
   }
}
