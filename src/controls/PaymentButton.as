package controls
{
   import assets.icon.PaymentsIcon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class PaymentButton extends BigButton
   {
      
      public static const SMS:String = "sms";
      
      public static const QIWI:String = "mk";
      
      public static const YANDEX:String = "yandex";
      
      public static const VISA:String = "bank_card";
      
      public static const WEBMONEY:String = "wm";
      
      public static const EASYPAY:String = "easypay";
      
      public static const RBK:String = "rbk";
      
      public static const MONEYMAIL:String = "moneymail";
      
      public static const WEBCREDITS:String = "webcreds";
      
      public static const PAYPAL:String = "paypal";
      
      public static const TERMINAL:String = "terminal";
      
      public static const CHRONOPAY:String = "chronopay";
      
      public static const LIQPAY:String = "liqpay";
      
      public static const RIXTY:String = "rixty";
      
      public static const PREPAID_EN:String = "prepaiden";
      
      public static const PREPAID_RU:String = "prepaidru";
      
      public static const WALLIE:String = "wallie";
      
      public static const PAYSAFE:String = "paysafecard";
      
      public static const CASHU:String = "cashu";
      
      public static const types:Array = [SMS,QIWI,YANDEX,VISA,WEBMONEY,EASYPAY,RBK,MONEYMAIL,WEBCREDITS,PAYPAL,TERMINAL,CHRONOPAY,LIQPAY,RIXTY,PREPAID_EN,PREPAID_RU,WALLIE,PAYSAFE,CASHU];
       
      
      protected var bmp:BitmapData;
      
      private var _type:String;
      
      public function PaymentButton()
      {
         super();
         this.type = SMS;
         this.width = 155;
      }
      
      public function set type(value:String) : void
      {
         var numValue:int = types.indexOf(value);
         var payicon:PaymentsIcon = new PaymentsIcon();
         this._type = value;
         payicon.gotoAndStop(numValue + 1);
         this.bmp = new BitmapData(payicon.width,payicon.height,true,0);
         this.bmp.draw(payicon);
         icon = this.bmp;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      override public function set width(w:Number) : void
      {
         _width = int(w);
         stateDOWN.width = stateOFF.width = stateOVER.width = stateUP.width = _width;
         _info.width = _label.width = _width - 4;
         if(_icon != null)
         {
            _icon.x = int(_width / 2 - _icon.width / 2);
            _icon.y = int(25 - _icon.height / 2);
         }
      }
   }
}
