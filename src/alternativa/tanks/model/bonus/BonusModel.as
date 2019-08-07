package alternativa.tanks.model.bonus
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import forms.cong.CongratulationsWindowPresent;
   import forms.cong.CongratulationsWindowWithBanner;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.types.Long;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import utils.client.panel.model.bonus.BonusModelBase;
   import utils.client.panel.model.bonus.IBonusModelBase;
   
   public class BonusModel extends BonusModelBase implements IBonusModelBase, IObjectLoadListener, IBonus
   {
       
      
      private var clientObject:ClientObject;
      
      private var panelModel:IPanel;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var bonusWindow:CongratulationsWindowWithBanner;
      
      private var bonusWindowPresent:CongratulationsWindowPresent;
      
      public function BonusModel()
      {
         super();
         _interfaces.push(IModel,IBonus,IBonusModelBase,IObjectLoadListener);
         this.dialogsLayer = Main.dialogsLayer;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         this.panelModel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
      }
      
      public function showBonuses(clientObject:ClientObject, items:Array, bannerObjectId:String) : void
      {
         if(items.length > 0)
         {
            Main.blur();
            this.bonusWindow = new CongratulationsWindowWithBanner(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_TEXT),items,null);
            this.dialogsLayer.addChild(this.bonusWindow);
            this.bonusWindow.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindow);
            this.alignWindow();
            Main.stage.addEventListener(Event.RESIZE,this.alignWindow);
         }
      }
      
      public function showCrystals(clientObject:ClientObject, count:int, banner:Long) : void
      {
         Main.blur();
         this.bonusWindowPresent = new CongratulationsWindowPresent(CongratulationsWindowPresent.CRYSTALS,null,count);
         this.dialogsLayer.addChild(this.bonusWindowPresent);
         this.bonusWindowPresent.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresent);
         this.alignWindowPresent();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowPresent);
      }
      
      public function showNoSupplies(clientObject:ClientObject, banner:Long) : void
      {
         Main.blur();
         this.bonusWindowPresent = new CongratulationsWindowPresent(CongratulationsWindowPresent.NOSUPPLIES,null);
         this.dialogsLayer.addChild(this.bonusWindowPresent);
         this.bonusWindowPresent.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresent);
         this.alignWindowPresent();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowPresent);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.clientObject = this.clientObject;
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         if(this.bonusWindow != null && this.dialogsLayer.contains(this.bonusWindow))
         {
            this.closeWindow();
            this.bonusWindow.closeButton.removeEventListener(MouseEvent.CLICK,this.closeWindow);
            Main.stage.removeEventListener(Event.RESIZE,this.alignWindow);
            this.bonusWindow = null;
         }
         this.clientObject = null;
      }
      
      public function get congratulationsWindow() : CongratulationsWindowWithBanner
      {
         return this.bonusWindow;
      }
      
      private function alignWindow(e:Event = null) : void
      {
         this.bonusWindow.x = Math.round((Main.stage.stageWidth - this.bonusWindow.width) * 0.5);
         this.bonusWindow.y = Math.round((Main.stage.stageHeight - this.bonusWindow.height) * 0.5);
      }
      
      private function alignWindowPresent(e:Event = null) : void
      {
         this.bonusWindowPresent.x = Math.round((Main.stage.stageWidth - this.bonusWindowPresent.width) * 0.5);
         this.bonusWindowPresent.y = Math.round((Main.stage.stageHeight - this.bonusWindowPresent.height) * 0.5);
      }
      
      private function closeWindow(e:MouseEvent = null) : void
      {
         Main.unblur();
         this.dialogsLayer.removeChild(this.bonusWindow);
      }
      
      private function closeWindowPresent(e:MouseEvent = null) : void
      {
         Main.unblur();
         this.dialogsLayer.removeChild(this.bonusWindowPresent);
      }
   }
}
