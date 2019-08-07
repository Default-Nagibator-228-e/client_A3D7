package forms.shop.windows.bugreport
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.TankWindowInner;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   
   public class PaymentBugReportBlock extends Sprite
   {
      
      public static var localeService:ILocaleService;
      
      private static const WINDOW_MARGIN:int = 11;
      
      private static const SPACE_MODULE:int = 7;
      
      private static const HEIGHT:int = 45;
       
      
      private var errorInner:TankWindowInner;
      
      private var errorButton:DefaultButtonBase;
      
      private var errorLabel:LabelBase;
      
      private var _width:Number;
      
      public function PaymentBugReportBlock()
      {
         super();
         this.errorInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         this.errorInner.height = HEIGHT;
         addChild(this.errorInner);
		 Main.stage.removeEventListener(Event.RESIZE, this.render);
         this.errorLabel = new LabelBase();
         this.errorLabel.multiline = true;
         this.errorLabel.wordWrap = true;
         this.errorLabel.text = "Если Ваш платёж не дошёл или возникла проблема - сообщите нам об этом.";
         this.errorLabel.x = WINDOW_MARGIN;
         addChild(this.errorLabel);
         this.errorButton = new DefaultButtonBase();
         this.errorButton.label = "Сообщить";
         this.errorButton.addEventListener(MouseEvent.CLICK,this.onErrorButtonClick);
         this.errorButton.y = SPACE_MODULE;
         addChild(this.errorButton);
		 render();
      }
	  
	  public function render(param1:Event = null) : void
      {
         //this._width = param1;
         this.errorInner.width = this.width;
         this.errorButton.x = this.width - this.errorButton.width - WINDOW_MARGIN;
         this.errorLabel.width = this.errorButton.x - this.errorLabel.x - WINDOW_MARGIN;
         this.errorLabel.y = int((HEIGHT - this.errorLabel.height) * 0.5);
      }
      
      private function onErrorButtonClick(param1:MouseEvent) : void
      {
		 /*
         var _loc2_:String = localeService.getText(TanksLocale.TEXT_SHOP_PAYMENT_BUG_REPORT_LINK);
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         var _loc4_:ProcessedPaymentInfo = processedPaymentService.getLastProcessedPaymentInfo();
         _loc3_.data = Boolean(_loc4_)?this.fillURLParamsForSendError(_loc4_):new URLVariables();
         _loc3_.data.user = UidUtil.userNameWithoutClanTag(userPropertiesService.userName);
         navigateToURL(_loc3_,"_blank");
		 
      }
      
      private function fillURLParamsForSendError(param1:ProcessedPaymentInfo) : URLVariables
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.currencyName = param1.currencyName;
         _loc2_.itemFinalPrice = param1.itemFinalPrice;
         _loc2_.itemId = param1.itemId;
         _loc2_.payModeId = param1.payModeId;
         _loc2_.payModeName = param1.payModeName;
         _loc2_.date = param1.date;
         _loc2_.time = param1.time;
         return _loc2_;
      }
      */
	  }
      /*
      public function set width(param1:Number) : void
      {
         this._width = param1;
         this.errorInner.width = this._width;
         this.errorButton.x = this._width - this.errorButton.width - WINDOW_MARGIN;
         this.errorLabel.width = this.errorButton.x - this.errorLabel.x - WINDOW_MARGIN;
         this.errorLabel.y = int((HEIGHT - this.errorLabel.height) * 0.5);
      }
	  */
   }
}
