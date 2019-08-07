package alternativa.tanks.turrets
{
   import alternativa.tanks.models.weapon.IWeaponController;
   
   public class TurretModel
   {
       
      
      public var model:IWeaponController;
      
      public var id:String;
      
      public function TurretModel(model:IWeaponController, id:String)
      {
         super();
         this.model = model;
         this.id = id;
      }
   }
}
