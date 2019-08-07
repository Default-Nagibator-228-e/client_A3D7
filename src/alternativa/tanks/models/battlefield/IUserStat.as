package alternativa.tanks.models.battlefield
{
   public interface IUserStat
   {
       
      
      function getUserName(param1:String) : String;
      
      function getUserRank(param1:String) : int;
      
      function addUserStatListener(param1:IUserStatListener) : void;
      
      function removeUserStatListener(param1:IUserStatListener) : void;
   }
}
