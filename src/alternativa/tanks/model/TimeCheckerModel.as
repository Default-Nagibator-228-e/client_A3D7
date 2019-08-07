package alternativa.tanks.model
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import utils.client.models.core.users.model.timechecker.ITimeCheckerModelBase;
   import utils.client.models.core.users.model.timechecker.TimeCheckerModelBase;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.Alert;
   import forms.AlertAnswer;
   
   public class TimeCheckerModel extends TimeCheckerModelBase implements ITimeCheckerModelBase
   {
       
      
      private var clientObject:ClientObject;
      
      private var timer:Timer;
      
      public function TimeCheckerModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(ITimeCheckerModelBase);
         this.timer = new Timer(15000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.sendPong);
      }
      
      public function ping(clientObject:ClientObject) : void
      {
         this.clientObject = clientObject;
         this.timer.reset();
         this.timer.start();
      }
      
      public function showKickMessage(clientObject:ClientObject, message:String) : void
      {
         var alert:Alert = new Alert();
         alert.showAlert(message,[AlertAnswer.OK]);
         Main.contentUILayer.addChild(alert);
      }
      
      private function sendPong(e:TimerEvent) : void
      {
      }
   }
}
