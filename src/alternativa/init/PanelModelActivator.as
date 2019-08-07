package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.antiaddiction.AntiAddictionAlertModel;
   import alternativa.tanks.model.banner.BannerModel;
   import alternativa.tanks.model.bonus.BonusModel;
   import alternativa.tanks.model.entrancealert.EntranceAlertModel;
   import alternativa.tanks.model.panel.CapabilitiesDumper;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.model.payment.PaymentModel;
   import alternativa.tanks.model.referals.ReferalsModel;
   import alternativa.tanks.model.top.TopModel;
   import alternativa.tanks.model.user.UserDataModel;
   import utils.client.panel.model.ITopModelBase;
   
   public class PanelModelActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      private var panelModel:PanelModel;
      
      private var topModel:TopModel;
      
      private var userDataModel:UserDataModel;
      
      private var paymentModel:PaymentModel;
      
      private var bonusModel:BonusModel;
      
      private var bannerModel:BannerModel;
      
      private var referalsModel:ReferalsModel;
      
      private var antiAddictionModel:AntiAddictionAlertModel;
      
      private var entranceAlertModel:EntranceAlertModel;
      
      private var capabilitiesDumper:CapabilitiesDumper;
      
      public function PanelModelActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         PanelModelActivator.osgi = osgi;
         var modelRegister:IModelService = IModelService(osgi.getService(IModelService));
         this.panelModel = new PanelModel();
         modelRegister.add(this.panelModel);
         osgi.registerService(IBattleSettings,this.panelModel);
         this.topModel = new TopModel();
         Main.osgi.registerService(ITopModelBase,this.topModel);
         modelRegister.add(this.topModel);
         this.userDataModel = new UserDataModel();
         modelRegister.add(this.userDataModel);
         this.bonusModel = new BonusModel();
         modelRegister.add(this.bonusModel);
         this.bannerModel = new BannerModel();
         modelRegister.add(this.bannerModel);
         this.referalsModel = new ReferalsModel();
         modelRegister.add(this.referalsModel);
         this.antiAddictionModel = new AntiAddictionAlertModel();
         modelRegister.add(this.antiAddictionModel);
         this.entranceAlertModel = new EntranceAlertModel();
         modelRegister.add(this.entranceAlertModel);
         this.capabilitiesDumper = new CapabilitiesDumper();
         IDumpService(osgi.getService(IDumpService)).registerDumper(this.capabilitiesDumper);
      }
      
      public function stop(osgi:OSGi) : void
      {
         var modelRegister:IModelService = IModelService(osgi.getService(IModelService));
         osgi.unregisterService(IBattleSettings);
         modelRegister.remove(this.panelModel.id);
         this.panelModel = null;
         modelRegister.remove(this.topModel.id);
         this.topModel = null;
         modelRegister.remove(this.userDataModel.id);
         this.userDataModel = null;
         modelRegister.remove(this.paymentModel.id);
         this.paymentModel = null;
         modelRegister.remove(this.bonusModel.id);
         this.bonusModel = null;
         modelRegister.remove(this.bannerModel.id);
         this.bannerModel = null;
         modelRegister.remove(this.referalsModel.id);
         this.referalsModel = null;
         modelRegister.remove(this.antiAddictionModel.id);
         this.antiAddictionModel = null;
         modelRegister.remove(this.entranceAlertModel.id);
         this.entranceAlertModel = null;
         IDumpService(osgi.getService(IDumpService)).unregisterDumper(this.capabilitiesDumper.dumperName);
         this.capabilitiesDumper = null;
         PanelModelActivator.osgi = null;
      }
   }
}
