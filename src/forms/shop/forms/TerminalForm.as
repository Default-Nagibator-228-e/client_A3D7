package forms.shop.forms
{
   import alternativa.tanks.calculators.ExchangeCalculator;
   import alternativa.tanks.gui.payment.controls.PaymentButton;
   import alternativa.tanks.gui.payment.controls.exchange.ExchangeGroup;
   import alternativa.tanks.gui.payment.forms.PayModeForm;
   import forms.shop.windows.ShopWindow;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.panel.model.payment.modes.terminal.TerminalInstance;
   import projects.tanks.client.panel.model.payment.modes.terminal.TerminalPaymentCC;
   
   public class TerminalForm extends PayModeForm
   {
      
      private static const CALCULATOR_LABEL_HEIGHT:int = 50;
      
      private static const CALCULATOR_LABEL_OFFSET:int = 12;
       
      
      private var exchangeGroup:ExchangeGroup;
      
      private var calculatorLabel:LabelBase;
      
      private var exchangeCalculator:ExchangeCalculator;
      
      private var terminalButtonsContainer:Sprite;
      
      private var withCalculator:Boolean;
      
      public function TerminalForm(param1:IGameObject, param2:TerminalPaymentCC)
      {
         this.calculatorLabel = new LabelBase();
         this.exchangeCalculator = new ExchangeCalculator(1,"RUB",0,50);
         super(param1);
         this.withCalculator = param2.withCalculator;
         if(this.withCalculator)
         {
            this.addCalculator(param2.text);
         }
         this.addTerminalLinkButtons(param2.terminals);
      }
      
      private function addCalculator(param1:String) : void
      {
         this.calculatorLabel.autoSize = TextFieldAutoSize.NONE;
         this.calculatorLabel.multiline = true;
         this.calculatorLabel.wordWrap = true;
         this.calculatorLabel.htmlText = param1;
         this.calculatorLabel.size = 14;
         addChild(this.calculatorLabel);
         this.exchangeGroup = new ExchangeGroup();
         this.exchangeGroup.hideButtons();
         this.exchangeGroup.setCalculator(this.exchangeCalculator);
         this.exchangeGroup.currency = "руб";
         addChild(this.exchangeGroup);
         this.exchangeGroup.width = int(ShopWindow.WINDOW_WIDTH / 2);
         this.exchangeGroup.x = int(ShopWindow.WINDOW_WIDTH / 2 - this.exchangeGroup.calculatorWidth() / 2) + 200;
         this.calculatorLabel.width = this.exchangeGroup.calculatorWidth();
         this.calculatorLabel.x = this.exchangeGroup.x + (this.exchangeGroup.width - this.calculatorLabel.width) / 2;
         this.calculatorLabel.y = this.exchangeGroup.y + this.exchangeGroup.calculatorHeight() + CALCULATOR_LABEL_OFFSET;
         this.calculatorLabel.height = CALCULATOR_LABEL_HEIGHT;
      }
      
      private function addTerminalLinkButtons(param1:Vector.<TerminalInstance>) : void
      {
         var _loc6_:TerminalInstance = null;
         var _loc7_:PaymentButton = null;
         var _loc8_:Boolean = false;
         this.terminalButtonsContainer = new Sprite();
         var _loc2_:int = !!this.withCalculator?int(3):int(5);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in param1)
         {
            _loc7_ = new PaymentButton(_loc6_.image);
            _loc7_.url = _loc6_.url;
            _loc8_ = _loc3_ % _loc2_ == 0;
            _loc7_.y = !!_loc8_?Number(_loc3_ / _loc2_ * (_loc7_.height + 2)):Number(_loc4_);
            _loc7_.x = !!_loc8_?Number(0):Number(_loc5_ + _loc7_.width + 2);
            _loc7_.addEventListener(MouseEvent.CLICK,this.onTerminalSelect);
            this.terminalButtonsContainer.addChild(_loc7_);
            _loc4_ = _loc7_.y;
            _loc5_ = _loc7_.x;
            _loc3_++;
         }
         addChild(this.terminalButtonsContainer);
      }
      
      private function onTerminalSelect(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(PaymentButton(param1.target).url),"_blank");
      }
      
      override public function activate() : void
      {
         if(this.withCalculator)
         {
            this.exchangeCalculator.init(1,0,50);
            this.exchangeGroup.outputMaxValue = 19999;
            this.exchangeGroup.outputMinValue = 1;
            this.exchangeGroup.resetValue();
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:PaymentButton = null;
         super.destroy();
         for each(_loc1_ in this.terminalButtonsContainer)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onTerminalSelect);
         }
      }
      
      override public function isWithoutChosenItem() : Boolean
      {
         return true;
      }
   }
}
