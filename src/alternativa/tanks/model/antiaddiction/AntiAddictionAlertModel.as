package alternativa.tanks.model.antiaddiction
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.AntiAddictionWindow;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import forms.Alert;
   import forms.AlertAnswer;
   import utils.client.panel.model.antiaddictionalert.AntiAddictionAlertModelBase;
   import utils.client.panel.model.antiaddictionalert.IAntiAddictionAlertModelBase;
   
   public class AntiAddictionAlertModel extends AntiAddictionAlertModelBase implements IAntiAddictionAlert, IAntiAddictionAlertModelBase, IObjectLoadListener
   {
       
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var antiAddictionWindow:AntiAddictionWindow;
      
      private var clientObject:ClientObject;
      
      public function AntiAddictionAlertModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IAntiAddictionAlertModelBase);
         _interfaces.push(IAntiAddictionAlert);
         _interfaces.push(IObjectLoadListener);
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
      }
      
      public function showAntiAddictionAlert(clientObject:ClientObject, minutesPlayedToday:int) : void
      {
         
      }
      
      public function setIdNumberCheckResult(clientObject:ClientObject, result:Boolean) : void
      {
         
      }
      
      public function setIdNumberAndRealName(realName:String, idNumber:String) : void
      {
      }
      
      private function showAntiAddictionWindow(minutesPlayedToday:int) : void
      {

      }
      
      private function onIDCardEntered(e:Event) : void
      {
         
      }
      
      private function onIDCardCanceled(e:Event) : void
      {
         
      }
      
      private function alignAntiAddictionWindow(e:Event = null) : void
      {
       
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
        
      }
   }
}
