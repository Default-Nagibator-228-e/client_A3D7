package utils.client.warfare.models.tankparts.weapon.healing.struct
{
   import utils.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   
   public class IsisAction
   {
       
      
      public var shooterId:String;
      
      public var targetId:String;
      
      public var type:IsisActionType;
      
      public function IsisAction()
      {
         super();
      }
   }
}
