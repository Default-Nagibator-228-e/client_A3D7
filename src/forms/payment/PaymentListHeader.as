package forms.payment
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.Diamond;
   import controls.statassets.StatHeaderButton;
   import flash.display.Sprite;
   
   public class PaymentListHeader extends Sprite
   {
      
      private static var _withSMSText:Boolean = false;
       
      
      private const headers:Array = ["Number","Cost","Crystals"];
      
      private var number:StatHeaderButton;
      
      private var smsText:StatHeaderButton;
      
      private var cost:StatHeaderButton;
      
      private var crystals:StatHeaderButton;
      
      private var cr:Diamond;
      
      protected var _width:int = 800;
      
      public function PaymentListHeader()
      {
         this.number = new StatHeaderButton();
         this.smsText = new StatHeaderButton(false);
         this.cost = new StatHeaderButton();
         this.crystals = new StatHeaderButton();
         this.cr = new Diamond();
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.number.height = this.cost.height = this.smsText.height = this.crystals.height = 18;
         this.number.label = localeService.getText(TextConst.PAYMENT_SMSNUMBERS_NUMBER_HEADER_LABEL_TEXT);
         this.smsText.label = localeService.getText(TextConst.PAYMENT_SMSNUMBERS_SMSTEXT_HEADER_LABEL_TEXT);
         this.cost.label = localeService.getText(TextConst.PAYMENT_SMSNUMBERS_COST_HEADER_LABEL_TEXT);
         addChild(this.number);
         addChild(this.smsText);
         this.smsText.visible = _withSMSText;
         addChild(this.cost);
         addChild(this.crystals);
         addChild(this.cr);
         this.number.width = 70;
         this.cost.x = 72;
         this.cr.y = 5;
         this.draw();
      }
      
      public function set withSMSText(value:Boolean) : void
      {
         _withSMSText = value;
         this.draw();
      }
      
      override public function set width(w:Number) : void
      {
         this._width = Math.floor(w);
         this.draw();
      }
      
      private function draw() : void
      {
         var subwidth:int = !!_withSMSText?int(60):int((this._width - 70) / 2);
         this.smsText.visible = _withSMSText;
         this.cost.x = 72;
         if(_withSMSText)
         {
            this.smsText.x = 72;
            this.smsText.width = this._width - 170;
            this.cost.x = 72 + this.smsText.width + 2;
         }
         this.cost.width = subwidth;
         this.crystals.x = this.cost.x + this.cost.width + 2;
         this.crystals.width = int(this._width - this.crystals.x - 3);
         this.cr.x = this.crystals.x + this.crystals.width - this.cr.width - 3;
      }
   }
}
