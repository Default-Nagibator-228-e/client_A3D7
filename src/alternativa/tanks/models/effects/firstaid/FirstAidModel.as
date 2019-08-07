package alternativa.tanks.models.effects.firstaid
{
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.types.Long;
   import utils.client.warfare.models.effects.firstaid.FirstAidModelBase;
   import utils.client.warfare.models.effects.firstaid.IFirstAidModelBase;
   
   public class FirstAidModel extends FirstAidModelBase implements IFirstAidModelBase
   {
       
      
      public function FirstAidModel()
      {
         super();
         _interfaces.push(IModel,IFirstAidModelBase);
      }
      
      public function activated(clientObject:ClientObject, tankId:Long) : void
      {
      }
   }
}
