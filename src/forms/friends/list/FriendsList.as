package forms.friends.list
{
   import forms.friends.list.dataprovider.FriendsDataProvider;
   import alternativa.tanks.model.Friend;
   import alternativa.types.Long;
   import fl.controls.List;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import utils.ScrollStyleUtils;
   
   public class FriendsList extends Sprite
   {   
      
      protected var _dataProvider:FriendsDataProvider = new FriendsDataProvider();
      
      protected var _list:List = new List();
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _viewed:Dictionary = new Dictionary();
	  
	  private var de:Long = new Long(0,10000);
      
      public function FriendsList()
      {
         super();
      }
      
      protected function init(param1:Object) : void
      {
         this._list.rowHeight = 20;
         this._list.setStyle("cellRenderer",param1);
         this._list.focusEnabled = true;
         this._list.selectable = false;
         ScrollStyleUtils.setGreenStyle(this._list);
         this._list.dataProvider = this._dataProvider;
         addChild(this._list);
         ScrollStyleUtils.setGreenStyle(this._list);
      }
      
      protected function isViewed(param1:Object) : Boolean
      {
         return param1 in this._viewed;
      }
      
      protected function setAsViewed(param1:Object) : void
      {
         this._viewed[param1] = true;
      }
      
      protected function fillFriendsList(param1:Array, p:Array) : void
      {
         this._dataProvider.removeAll();
         this._dataProvider.resetFilter(false);
		 var de:int = 0;
         for (var fg:int = 0; fg < param1.length; fg++)
         {
			//throw new Error(p[fg]);
			//this._dataProvider.setUserAsNew(this._dataProvider.de);
			trace(fg + " " + param1.length);
			var fd:Boolean = Friend.liston[fg] == "1"?true:false;
			this._dataProvider.addUser(param1[fg], fd ? (Friend.listob[de]):"", fg, p[fg], fd);
			if (fd)
			{
				de++;
			}
			this._dataProvider.setOnlineUser(new Long(0, fg),fd);
         }
         this._dataProvider.refresh();
      }
      
      protected function filterByProperty(param1:String, param2:String) : void
      {
         this._dataProvider.setFilter(param1,param2);
         this.resize(this._width,this._height);
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this._width = param1;
         this._height = param2;
         var _loc3_:Boolean = this._list.verticalScrollBar.visible;
         this._list.width = !!_loc3_?Number(this._width + 6):Number(this._width);
         this._list.height = this._height;
      }
   }
}
