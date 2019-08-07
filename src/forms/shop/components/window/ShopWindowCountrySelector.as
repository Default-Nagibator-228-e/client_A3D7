package forms.shop.components.window
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.service.country.CountryService;
   import base.DiscreteSprite;
   import controls.dropdownlist.DropDownList;
   import flash.events.Event;
   import projects.tanks.client.panel.model.usercountry.CountryInfo;
   import projects.tanks.clients.flash.commons.services.payment.PaymentDisplayService;
   
   public class ShopWindowCountrySelector extends DiscreteSprite
   {
      
      [Inject]
      public static var countryService:CountryService;
      
      [Inject]
      public static var localeService:ILocaleService;
      
      [Inject]
      public static var paymentDisplayService:PaymentDisplayService;
       
      
      public var autoReloadPayments:Boolean;
      
      private var chooseCountryComboBox:DropDownList;
      
      public function ShopWindowCountrySelector(param1:Boolean = true)
      {
         this.chooseCountryComboBox = new DropDownList();
         super();
         this.chooseCountryComboBox.width = 160;
         this.initCountries();
         addChild(this.chooseCountryComboBox);
         this.autoReloadPayments = param1;
         this.chooseCountryComboBox.addEventListener(Event.CHANGE,this.onCountrySelected);
      }
      
      private function initCountries() : void
      {
         var _loc1_:Vector.<CountryInfo> = countryService.getRegisteredCountries();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.chooseCountryComboBox.addItem({
               "rang":0,
               "index":_loc2_,
               "id":_loc2_,
               "gameName":_loc1_[_loc2_].countryName,
               "code":_loc1_[_loc2_].countryCode
            });
            _loc2_++;
         }
         this.chooseCountryComboBox.sortOn("gameName");
         if(countryService.getDefaultCountryCode())
         {
            this.chooseCountryComboBox.selectItemByField("code",countryService.getDefaultCountryCode());
         }
         else
         {
            this.chooseCountryComboBox.selectItemByField("id",0);
         }
      }
      
      private function onCountrySelected(param1:Event) : void
      {
         countryService.changeCountry(this.chooseCountryComboBox.selectedItem["code"]);
         if(this.autoReloadPayments)
         {
            paymentDisplayService.reloadPayment();
         }
      }
      
      override public function get height() : Number
      {
         return this.chooseCountryComboBox.rowHeight;
      }
      
      override public function get width() : Number
      {
         return this.chooseCountryComboBox.width;
      }
   }
}
