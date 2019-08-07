package alternativa.tanks.model.user
{
   public class UserData
   {
       
      
      public var id:String;
      
      public var name:String;
      
      public var rank:int;
      
      public function UserData(id:String, name:String, rank:int)
      {
         super();
         this.id = id;
         this.name = name;
         this.rank = rank;
      }
   }
}
