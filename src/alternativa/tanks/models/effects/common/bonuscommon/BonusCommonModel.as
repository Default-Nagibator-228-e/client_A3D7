package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.resource.StubBitmapData;
   import alternativa.service.IResourceService;
   import alternativa.tanks.bonuses.IBonus;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.effects.common.IBonusCommonModel;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import utils.client.warfare.models.common.bonuscommon.BonusCommonModelBase;
   import utils.client.warfare.models.common.bonuscommon.IBonusCommonModelBase;
   import flash.display.BitmapData;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class BonusCommonModel extends BonusCommonModelBase implements IBonusCommonModelBase, IBonusCommonModel, IObjectLoadListener
   {
      
      private static const MIPMAP_RESOLUTION:Number = 4;
      
      private static var materialRegistry:IMaterialRegistry;
       
      
      public function BonusCommonModel()
      {
         super();
         _interfaces.push(IModel,IBonusCommonModelBase,IBonusCommonModel,IObjectLoadListener);
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
      }
      
      public function initObject(clientObject:ClientObject, boxResourceId:String, cordResourceId:String, disappearingTime:int, parachuteInnerResourceId:String, parachuteResourceId:String) : void
      {
         var resourceService:IResourceService = Main.osgi.getService(IResourceService) as IResourceService;
         var bonusData:BonusCommonData = new BonusCommonData();
         bonusData.boxMesh = this.getMeshFromResource(resourceService,boxResourceId);
         bonusData.parachuteMesh = this.getMeshFromResource(resourceService,parachuteResourceId);
         bonusData.parachuteInnerMesh = this.getMeshFromResource(resourceService,parachuteInnerResourceId);
         bonusData.cordMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,ResourceUtil.getResource(ResourceType.IMAGE,cordResourceId).bitmapData as BitmapData,MIPMAP_RESOLUTION);
         bonusData.duration = disappearingTime * 1000;
         clientObject.putParams(BonusCommonModel,bonusData);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         var data:BonusCommonData = BonusCommonData(object.getParams(BonusCommonModel));
         ParaBonus.deletePool(data);
      }
      
      public function getBonus(clientObject:ClientObject, bonusId:String, livingTime:int, isFalling:Boolean) : IBonus
      {
         var data:BonusCommonData = BonusCommonData(clientObject.getParams(BonusCommonModel));
         var bonus:ParaBonus = ParaBonus.create(data);
         bonus.init(bonusId,data.duration - livingTime,isFalling);
         return bonus;
      }
      
      private function getMeshFromResource(resourceService:IResourceService, resourceId:String) : Mesh
      {
         var refMesh:Mesh = ResourceUtil.getResource(ResourceType.MODEL,resourceId).mesh as Mesh;
         var texture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,resourceId).bitmapData as BitmapData;
         if(texture == null)
         {
            texture = new StubBitmapData(65280);
         }
         var material:TextureMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,texture,MIPMAP_RESOLUTION);
         var mesh:Mesh = Mesh(refMesh.clone());
         mesh.setMaterialToAllFaces(material);
         return mesh;
      }
   }
}
