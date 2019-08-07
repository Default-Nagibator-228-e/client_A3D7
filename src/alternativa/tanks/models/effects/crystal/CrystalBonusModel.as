package alternativa.tanks.models.effects.crystal
{
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.types.Long;
   import utils.client.warfare.models.effects.crystal.CrystalBonusModelBase;
   import utils.client.warfare.models.effects.crystal.ICrystalBonusModelBase;
   
   public class CrystalBonusModel extends CrystalBonusModelBase implements ICrystalBonusModelBase
   {
       
      
      public function CrystalBonusModel()
      {
         super();
         _interfaces.push(IModel,ICrystalBonusModelBase);
      }
      
      public function activated(clientObject:ClientObject, tankId:Long, crystals:int) : void
      {
      }
   }
}
