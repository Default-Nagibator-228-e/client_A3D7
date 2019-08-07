package alternativa.tanks.models.longterm
{
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.types.Long;
   import utils.client.warfare.models.common.longterm.ILongTermBonusModelBase;
   import utils.client.warfare.models.common.longterm.LongTermBonusModelBase;
   
   public class LongTermBonusModel extends LongTermBonusModelBase implements ILongTermBonusModelBase
   {
       
      
      public function LongTermBonusModel()
      {
         super();
         _interfaces.push(IModel,ILongTermBonusModelBase);
      }
      
      public function effectStart(clientObject:ClientObject, tankId:Long, durationSec:int) : void
      {
      }
      
      public function effectStop(clientObject:ClientObject, tankId:Long) : void
      {
      }
   }
}
