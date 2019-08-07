package forms.shop.forms
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.payment.events.PaymentFormEvent;
   import alternativa.tanks.gui.payment.events.SMSformEvent;
   import alternativa.tanks.gui.payment.forms.PayModeForm;
   import forms.shop.windows.ShopWindow;
   import alternativa.tanks.model.payment.modes.sms.SMSPayMode;
   import alternativa.tanks.service.country.CountryService;
   import alternativa.tanks.service.payment.IPaymentService;
   import controls.TankWindowInner;
   import controls.base.LabelBase;
   import controls.dropdownlist.DropDownList;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.geom.Point;
   import forms.payment.PaymentList;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.panel.model.payment.modes.sms.types.Country;
   import projects.tanks.client.panel.model.payment.modes.sms.types.SMSNumber;
   import projects.tanks.client.panel.model.payment.modes.sms.types.SMSOperator;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   import projects.tanks.clients.fp10.libraries.tanksservices.service.storage.IStorageService;
   import utils.TextUtils;
   
   public class SMSForm extends PayModeForm
   {
      
      [Inject]
      public static var localeService:ILocaleService;
      
      [Inject]
      public static var paymentService:IPaymentService;
      
      [Inject]
      public static var storageService:IStorageService;
      
      [Inject]
      public static var countryService:CountryService;
       
      
      private const windowMargin:int = 11;
      
      private const spaceModule:int = 7;
      
      private var countriesCombo:DropDownList;
      
      private var operatorsCombo:DropDownList;
      
      private var comboLabelWidth:int = 50;
      
      private var smsTextLabel:LabelBase;
      
      private var smsText:LabelBase;
      
      private var smsTextBmp:Bitmap;
      
      private var numbers:Vector.<SMSNumber>;
      
      private var numbersList:PaymentList;
      
      private var numbersListInner:TankWindowInner;
      
      private var smsTextInner:TankWindowInner;
      
      private var oneText:Boolean;
      
      private var size:Point;
      
      public function SMSForm(param1:IGameObject)
      {
         super(param1);
         this.size = new Point();
         this.numbersListInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.numbersListInner.showBlink = true;
         addChild(this.numbersListInner);
         this.smsTextInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.smsTextInner.showBlink = true;
         addChild(this.smsTextInner);
         this.numbersList = new PaymentList();
         addChild(this.numbersList);
         this.smsTextLabel = new LabelBase();
         this.smsTextLabel.text = localeService.getText(TanksLocale.TEXT_PAYMENT_SMSTEXT_HEADER_LABEL_TEXT);
         addChild(this.smsTextLabel);
         this.smsText = new LabelBase();
         this.smsTextBmp = new Bitmap();
         addChild(this.smsTextBmp);
         this.operatorsCombo = new DropDownList();
         addChild(this.operatorsCombo);
         this.operatorsCombo.label = localeService.getText(TanksLocale.TEXT_PAYMENT_OPERATORS_LABEL_TEXT);
         this.countriesCombo = new DropDownList();
         addChild(this.countriesCombo);
         this.countriesCombo.label = localeService.getText(TanksLocale.TEXT_PAYMENT_COUNTRIES_LABEL_TEXT);
         this.operatorsCombo.addEventListener(Event.CHANGE,this.onOperatorSelect);
         this.countriesCombo.addEventListener(Event.CHANGE,this.onCountrySelect);
         this.numbersList.withSMSText = false;
         this.smsTextInner.visible = false;
         this.smsTextLabel.visible = false;
         this.smsTextBmp.visible = false;
         this.resize(ShopWindow.WINDOW_WIDTH - ShopWindow.WINDOW_PADDING * 2,250);
      }
      
      override public function set width(param1:Number) : void
      {
         this.size.x = param1;
         this.resize(this.size.x,this.size.y);
      }
      
      override public function set height(param1:Number) : void
      {
         this.size.y = param1;
         this.resize(this.size.x,this.size.y);
      }
      
      public function resize(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         this.size.x = param1;
         this.size.y = param2;
         this.countriesCombo.width = int(param1 * 0.5) - this.comboLabelWidth - this.windowMargin;
         this.operatorsCombo.width = int(param1 * 0.5) - this.comboLabelWidth - this.windowMargin;
         this.countriesCombo.x = this.comboLabelWidth;
         this.operatorsCombo.x = int(param1 * 0.5) + this.comboLabelWidth + this.windowMargin;
         this.graphics.drawRect(this.comboLabelWidth,0,int(param1 * 0.5) - this.comboLabelWidth - this.windowMargin,this.countriesCombo.height);
         this.graphics.drawRect(int(param1 * 0.5) + this.comboLabelWidth + this.windowMargin,0,int(param1 * 0.5) - this.comboLabelWidth - this.windowMargin,this.operatorsCombo.height);
         if(this.oneText)
         {
            this.smsTextInner.width = param1 - this.comboLabelWidth;
            this.smsTextInner.height = 50;
            this.smsTextInner.x = this.comboLabelWidth;
            this.smsTextInner.y = this.spaceModule * 5;
            if(this.smsText.text != null && this.smsText.text != "")
            {
               _loc3_ = Math.max(12,Math.min(12 + int((this.size.x - 447) * 0.03) + int((28 - this.smsText.text.length) * 0.3),20));
               this.smsText.size = _loc3_;
               this.smsTextBmp.bitmapData = TextUtils.getTextInCells(this.smsText,11 * (_loc3_ / 12),16 * (_loc3_ / 12));
               this.smsTextBmp.x = this.smsTextInner.x + this.spaceModule * 2;
               this.smsTextBmp.y = this.smsTextInner.y + (this.smsTextInner.height - this.smsTextBmp.height >> 1);
            }
            this.smsTextLabel.x = this.smsTextInner.x - this.spaceModule - this.smsTextLabel.width;
            this.smsTextLabel.y = this.smsTextInner.y + (this.smsTextInner.height - this.smsTextLabel.height >> 1);
            this.numbersListInner.y = this.smsTextInner.y + this.smsTextInner.height + this.spaceModule;
         }
         else
         {
            this.numbersListInner.y = this.spaceModule * 5;
         }
         this.numbersListInner.width = param1;
         this.numbersListInner.height = param2 - this.numbersListInner.y;
         this.numbersList.x = 5;
         this.numbersList.y = this.numbersListInner.y + 5;
         this.numbersList.width = param1 - 10;
         this.numbersList.height = param2 - this.numbersListInner.y - 10;
      }
      
      override public function activate() : void
      {
         var _loc1_:Vector.<Country> = SMSPayMode(payMode.adapt(SMSPayMode)).getCountries();
         this.setCountries(_loc1_);
         var _loc2_:String = countryService.getDefaultCountryCode();
         if(_loc2_ == null)
         {
            _loc2_ = storageService.getStorage().data.userCountryId;
         }
         if(_loc2_ != null && this.countriesCombo.findItemIndexByField("id",_loc2_) == -1)
         {
            _loc2_ = null;
         }
         if(_loc2_ == null)
         {
            switch(localeService.language)
            {
               case "ru":
                  _loc2_ = "RU";
                  break;
               case "cn":
                  _loc2_ = "CN";
                  break;
               case "de":
                  _loc2_ = "DE";
                  break;
               case "en":
                  _loc2_ = "UK";
            }
         }
         this.countriesCombo.selectItemByField("id",_loc2_);
      }
      
      public function setCountries(param1:Vector.<Country>) : void
      {
         var _loc3_:Country = null;
         this.countriesCombo.clear();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as Country;
            this.countriesCombo.addItem({
               "gameName":_loc3_.name,
               "rang":0,
               "id":_loc3_.id
            });
            _loc2_++;
         }
         this.countriesCombo.sortOn("gameName");
      }
      
      public function setOperators(param1:Vector.<SMSOperator>) : void
      {
         var _loc5_:SMSOperator = null;
         var _loc2_:String = "";
         var _loc3_:String = storageService.getStorage().data.userOperatorId;
         this.operatorsCombo.clear();
         this.smsString = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_] as SMSOperator;
            this.operatorsCombo.addItem({
               "gameName":_loc5_.name,
               "rang":0,
               "id":_loc5_.id
            });
            if(_loc3_ != null && _loc5_.id == int(_loc3_))
            {
               _loc2_ = _loc5_.name;
            }
            _loc4_++;
         }
         this.operatorsCombo.sortOn("gameName");
         if(_loc2_ != "")
         {
            this.operatorsCombo.value = _loc2_;
         }
         else
         {
            this.clearOperators();
            this.clearNumbers();
         }
      }
      
      public function clearOperators() : void
      {
         this.operatorsCombo.selectedItem = null;
      }
      
      public function setNumbers(param1:Vector.<SMSNumber>) : void
      {
         this.numbers = param1;
         this.numbers.sort(this.sortNumbersByCost);
         this.numbersList.clear();
         var _loc2_:SMSNumber = param1[0] as SMSNumber;
         var _loc3_:String = _loc2_.smsText;
         var _loc4_:Boolean = false;
         var _loc5_:int = 1;
         while(_loc5_ < param1.length)
         {
            _loc2_ = param1[_loc5_] as SMSNumber;
            if(_loc2_.smsText != _loc3_)
            {
               _loc4_ = true;
               break;
            }
            _loc5_++;
         }
         this.oneTextForAllNumbers = !_loc4_;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = param1[_loc5_] as SMSNumber;
            if(_loc2_.currency == "£")
            {
               this.numbersList.addItem(_loc2_.number,_loc2_.currency,_loc2_.cost.toFixed(2),_loc2_.crystals,!!_loc4_?_loc2_.smsText:"");
            }
            else
            {
               this.numbersList.addItem(_loc2_.number,_loc2_.cost.toFixed(2),_loc2_.currency,_loc2_.crystals,!!_loc4_?_loc2_.smsText:"");
            }
            _loc5_++;
         }
         if(!_loc4_)
         {
            this.smsString = _loc3_;
         }
      }
      
      public function clearNumbers() : void
      {
         this.numbersList.clear();
      }
      
      public function set smsString(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this.smsTextBmp.visible = true;
            this.smsText.text = param1;
            this.resize(this.size.x,this.size.y);
         }
         else
         {
            this.smsText.text = "";
            this.smsTextBmp.visible = false;
         }
      }
      
      public function set oneTextForAllNumbers(param1:Boolean) : void
      {
         this.oneText = param1;
         this.numbersList.withSMSText = !param1;
         this.smsTextInner.visible = param1;
         this.smsTextLabel.visible = param1;
         this.smsTextBmp.visible = param1;
         this.resize(this.size.x,this.size.y);
      }
      
      public function get selectedCountry() : String
      {
         return this.countriesCombo.selectedItem != null?this.countriesCombo.selectedItem["id"]:"";
      }
      
      public function get selectedOperator() : int
      {
         return this.operatorsCombo.selectedItem != null?int(int(this.operatorsCombo.selectedItem["id"])):int(-1);
      }
      
      public function get selectedOperatorName() : String
      {
         return this.operatorsCombo.selectedItem != null?String(this.operatorsCombo.selectedItem["gameName"]):"";
      }
      
      private function onCountrySelect(param1:Event) : void
      {
         dispatchEvent(new SMSformEvent(SMSformEvent.SELECT_COUNTRY,this));
         dispatchEvent(new PaymentFormEvent(PaymentFormEvent.SUBSYSTEM_SELECTED));
      }
      
      private function onOperatorSelect(param1:Event) : void
      {
         dispatchEvent(new SMSformEvent(SMSformEvent.SELECT_OPERATOR,this));
         dispatchEvent(new PaymentFormEvent(PaymentFormEvent.SUBSYSTEM_SELECTED));
      }
      
      private function sortNumbersByCost(param1:SMSNumber, param2:SMSNumber) : int
      {
         var _loc3_:int = 0;
         if(param1.cost > param2.cost)
         {
            _loc3_ = -1;
         }
         else if(param1.cost < param2.cost)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function getDescription() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "МТС";
         if(localeService.language == "ru")
         {
            if(this.selectedCountry == "UA")
            {
               return localeService.getText(TanksLocale.TEXT_PAYMENT_UKRAINE_SMS_INFO) + "\n";
            }
            if(this.selectedCountry == "RU" && this.selectedOperatorName == _loc2_)
            {
               return _loc1_ + "\n" + localeService.getText(TanksLocale.TEXT_PAYMENT_MTS_ADDITIONAL_INFO) + "\n";
            }
         }
         if(this.selectedCountry == "PT")
         {
            return localeService.getText(TanksLocale.TEXT_PAYMENT_SMS_DESCRIPTION_TEXT_INCLUDING_VAT) + "\n";
         }
         if(this.selectedCountry == "UK" && localeService.language == "en")
         {
            return _loc1_ + "\n" + localeService.getText(TanksLocale.TEXT_PAYMENT_SMS_UK_DESCRIPTION_ENDING_TEXT) + "\n";
         }
         if(this.selectedCountry == "CO" && localeService.language == "es")
         {
            return localeService.getText(TanksLocale.TEXT_PAYMENT_SMS_DESCRIPTION_CO_TEXT) + "\n";
         }
         return _loc1_;
      }
      
      override public function isWithoutChosenItem() : Boolean
      {
         return true;
      }
      
      override public function getMinHeight() : int
      {
         return 450;
      }
   }
}
