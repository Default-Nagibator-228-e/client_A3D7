package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.Label;
   import controls.statassets.BlackRoundRect;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   
   public class ServerStopAlert extends Sprite
   {
       
      
      protected const PADDING:int = 15;
      
      protected var bg:BlackRoundRect;
      
      protected var timeLimitLabel:Label;
      
      protected var countDown:int = 0;
      
      protected var countDownTimer:Timer;
      
      public var str:String;
      
      public function ServerStopAlert(time:int)
      {
         this.bg = new BlackRoundRect();
         this.timeLimitLabel = new Label();
         super();
         this.countDown = time;
         this.init();
      }
      
      protected function init() : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.timeLimitLabel.align = TextFormatAlign.CENTER;
         this.str = localeService.getText(TextConst.SERVER_STOP_ALERT_TEXT);
         this.timeLimitLabel.text = this.getText(this.str,"88");
         addChild(this.bg);
         addChild(this.timeLimitLabel);
         this.timeLimitLabel.x = this.PADDING;
         this.timeLimitLabel.y = this.PADDING;
         this.bg.width = this.timeLimitLabel.width + this.PADDING * 2;
         this.bg.height = this.timeLimitLabel.height + this.PADDING * 2;
         this.showCountDown();
      }
      
      protected function showCountDown() : void
      {
         this.countDownTimer = new Timer(1000);
         this.countDownTimer.addEventListener(TimerEvent.TIMER,this.showCountDownTick);
         this.countDownTimer.start();
         this.showCountDownTick();
      }
      
      protected function showCountDownTick(e:TimerEvent = null) : void
      {
         var str1:String = null;
         var min:int = int(this.countDown / 60);
         var sec:int = this.countDown - min * 60;
         str1 = sec > 9?String(sec):"0" + String(sec);
         this.timeLimitLabel.text = this.timeLimitLabel.text = this.getText(this.str,str1);
         this.countDown--;
         if(this.countDown < 0)
         {
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
            this.countDownTimer.stop();
         }
      }
      
      protected function getText(id:String, ... vars) : String
      {
         var text:String = id;
         for(var i:int = 0; i < vars.length; i++)
         {
            text = text.replace("%" + (i + 1),vars[i]);
         }
         return text;
      }
   }
}
