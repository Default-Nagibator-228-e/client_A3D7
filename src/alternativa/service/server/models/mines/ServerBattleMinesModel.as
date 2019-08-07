package alternativa.service.server.models.mines
{
   import alternativa.init.Main;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.mine.BattleMinesModel;
   import utils.client.models.battlefield.mine.BattleMine;
   import utils.client.models.battlefield.mine.IBattleMinesModelBase;
   
   public class ServerBattleMinesModel
   {
      
      private static const __object:ClientObject = new ClientObject("ServerBattleMinesModel_obj",null,"ServerBattleMinesModel_obj",null);
       
      
      private var model:BattleMinesModel;
      
      private var modelsService:IModelService;
      
      public function ServerBattleMinesModel()
      {
         super();
      }
      
      public function init() : void
      {
         this.modelsService = IModelService(Main.osgi.getService(IModelService));
         this.model = BattleMinesModel(this.modelsService.getModelsByInterface(IBattleMinesModelBase)[0]);
      }
      
      public function initModel(data:String) : void
      {
         var json:Object = JSON.parse(data);
         this.model.initObject(__object,"activationSound_mine",json.activationTimeMsec,"blueMineTexture","deactivationSound_mine","enemyMineTexture","explosionSound_mine",json.farVisibilityRadius,"friendlyMineTexture_mine","idleExplosionTexture_mine",json.impactForce,"mainExplosionTextureId_mine",json.minDistanceFromBase,"modelId_mine",json.nearVisibilityRadius,json.radius,"redMineTexture_mine");
         this.model.objectLoaded(__object);
      }
      
      public function initMines(data:String) : void
      {
         var obj:Object = null;
         var mine:BattleMine = null;
         var json:Object = JSON.parse(data);
         var _mines:Array = new Array();
         for each(obj in json.mines)
         {
            mine = new BattleMine(true,obj.mineId,obj.ownerId,obj.x,obj.y,obj.z);
            _mines.push(mine);
         }
         this.model.initMines(null,_mines);
      }
      
      public function removeMines(ownerId:String) : void
      {
         this.model.removeMines(null,ownerId);
      }
      
      public function putMine(ownerObject:ClientObject, data:Object) : void
      {
         var json:Object = data;
         this.model.putMine(ownerObject,json.mineId,json.x,json.y,json.z,json.userId);
      }
      
      public function activateMine(ownerId:String) : void
      {
         this.model.activateMine(null,ownerId);
      }
      
      public function hitMine(ownerObject:ClientObject, mineId:String) : void
      {
         this.model.explodeMine(ownerObject,mineId,ownerObject.id);
      }
   }
}
