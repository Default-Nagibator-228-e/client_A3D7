package alternativa.tanks.camera
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   
   public class CameraBookmark
   {
      
      [Inject]
      public static var battleService:BattlefieldModel;
       
      
      public var position:Vector3;
      
      public var eulerAnlges:Vector3;
      
      public function CameraBookmark()
      {
         this.position = new Vector3();
         this.eulerAnlges = new Vector3();
         battleService = BattlefieldModel(Main.osgi.getService(IBattleField));
         super();
      }
      
      public function saveCurrentPossitionCamera() : void
      {
         var _loc1_:GameCamera = battleService.bfData.viewport.camera;
         this.position.x = _loc1_.x;
         this.position.y = _loc1_.y;
         this.position.z = _loc1_.z;
         this.eulerAnlges.x = _loc1_.rotationX;
         this.eulerAnlges.y = _loc1_.rotationY;
         this.eulerAnlges.z = _loc1_.rotationZ;
      }
   }
}
