package alternativa.service
{
   import alternativa.register.SpaceInfo;
   import alternativa.types.Long;
   import flash.utils.Dictionary;
   
   public interface ISpaceService
   {
       
      
      function addSpace(param1:SpaceInfo) : void;
      
      function removeSpace(param1:SpaceInfo) : void;
      
      function get spaces() : Dictionary;
      
      function get spaceList() : Array;
      
      function getSpaceByObjectId(param1:String) : SpaceInfo;
      
      function setIdForSpace(param1:SpaceInfo, param2:Long) : void;
   }
}
