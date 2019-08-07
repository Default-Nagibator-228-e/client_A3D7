package alternativa.register
{
   import utils.client.models.ClientObject;
   import alternativa.service.ISpaceService;
   import alternativa.types.Long;
   import flash.utils.Dictionary;
   
   public class SpaceRegister implements ISpaceService
   {
       
      
      private var _spaceList:Array;
      
      private var _spaces:Dictionary;
      
      public function SpaceRegister()
      {
         super();
         this._spaceList = new Array();
         this._spaces = new Dictionary();
      }
      
      public function addSpace(space:SpaceInfo) : void
      {
         this._spaceList.push(space);
      }
      
      public function removeSpace(space:SpaceInfo) : void
      {
         this._spaceList.splice(this._spaceList.indexOf(space),1);
         this._spaces[space.id] = null;
      }
      
      public function get spaceList() : Array
      {
         return this._spaceList;
      }
      
      public function get spaces() : Dictionary
      {
         return this._spaces;
      }
      
      public function getSpaceByObjectId(id:String) : SpaceInfo
      {
         var info:SpaceInfo = null;
         var space:SpaceInfo = null;
         var objectRegister:ObjectRegister = null;
         var stopSearch:Boolean = false;
         var objects:Dictionary = null;
         var object:ClientObject = null;
         var i:int = 0;
         while(info == null && i < this._spaceList.length)
         {
            space = this._spaceList[i] as SpaceInfo;
            objectRegister = space.objectRegister;
            stopSearch = false;
            objects = objectRegister.getObjects();
            for each(object in objects)
            {
               if(object.id == id)
               {
                  stopSearch = true;
                  break;
               }
            }
            if(stopSearch)
            {
               info = space;
            }
            else
            {
               i++;
            }
         }
         return info;
      }
      
      public function setIdForSpace(space:SpaceInfo, id:Long) : void
      {
         space.id = id;
         this._spaces[id] = space;
      }
   }
}
