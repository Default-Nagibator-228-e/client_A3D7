package alternativa.tanks.models.weapon.shared.shot
{
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import utils.client.warfare.models.tankparts.weapon.shot.IShotModelBase;
   import utils.client.warfare.models.tankparts.weapon.shot.ShotModelBase;
   
   public class ShotModel extends ShotModelBase implements IShotModelBase, IShot
   {
       
      
      public function ShotModel()
      {
         super();
         _interfaces.push(IModel,IShotModelBase,IShot);
      }
      
      public function initObject(clientObject:ClientObject, autoAimingAngleDown:Number, autoAimingAngleUp:Number, reloadMsec:int) : void
      {
         var data:ShotData = new ShotData(reloadMsec);
         data.autoAimingAngleDown.value = autoAimingAngleDown;
         data.numRaysDown.value = 2 * 180 * autoAimingAngleDown / Math.PI;
         data.autoAimingAngleUp.value = autoAimingAngleUp;
         data.numRaysUp.value = 2 * 180 * autoAimingAngleUp / Math.PI;
         clientObject.putParams(ShotModel,data);
      }
      
      public function getShotData(clientObject:ClientObject) : ShotData
      {
         return clientObject.getParams(ShotModel) as ShotData;
      }
   }
}
