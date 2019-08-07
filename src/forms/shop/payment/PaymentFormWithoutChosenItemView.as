package forms.shop.payment
{
   import alternativa.tanks.gui.payment.events.SMSformEvent;
   import alternativa.tanks.gui.payment.forms.PayModeForm;
   import alternativa.tanks.gui.payment.forms.commons.DescriptionBlock;
   import forms.shop.components.paymentview.PaymentView;
   import forms.shop.forms.SMSForm;
   import alternativa.tanks.model.payment.category.PayModeView;
   import platform.client.fp10.core.type.IGameObject;
   
   public class PaymentFormWithoutChosenItemView extends PaymentView
   {
      
      private static const MAX_INNER_WINDOW_HEIGHT:int = 160;
      
      private static const MIN_INNER_WINDOW_HEIGHT:int = 70;
       
      
      private var chosenPayMode:IGameObject;
      
      private var descriptionBlock:DescriptionBlock;
      
      private var view:PayModeForm;
      
      private var previousHeight:int;
      
      public function PaymentFormWithoutChosenItemView(param1:IGameObject)
      {
         super();
         this.chosenPayMode = param1;
         this.descriptionBlock = new DescriptionBlock(param1,MAX_INNER_WINDOW_HEIGHT);
         addChild(this.descriptionBlock);
         this.view = PayModeView(param1.adapt(PayModeView)).getView();
         this.view.y = this.descriptionBlock.getHeight();
         this.view.addEventListener(SMSformEvent.SELECT_COUNTRY,this.onSMSformCountrySelected);
         addChild(this.view);
         this.previousHeight = this.view.getMinHeight();
      }
      
      override public function render(param1:int, param2:int) : void
      {
         super.render(param1,param2);
         var _loc3_:int = this.previousHeight - param2;
         var _loc4_:int = this.descriptionBlock.getInnerWindowHeight();
         if(param2 < this.view.getMinHeight() && _loc4_ > MIN_INNER_WINDOW_HEIGHT && _loc3_ > 0)
         {
            this.updateView(Math.max(_loc4_ - _loc3_,MIN_INNER_WINDOW_HEIGHT));
         }
         else if(_loc3_ < 0 && _loc4_ < MAX_INNER_WINDOW_HEIGHT)
         {
            this.updateView(Math.min(_loc4_ - _loc3_,MAX_INNER_WINDOW_HEIGHT));
         }
         this.previousHeight = param2;
         if(this.view is SMSForm)
         {
            SMSForm(this.view).resize(param1,param2 - this.descriptionBlock.getHeight());
         }
      }
      
      private function updateView(param1:int) : void
      {
         this.descriptionBlock.updateHeight(param1);
         this.view.y = this.descriptionBlock.getHeight();
      }
      
      private function onSMSformCountrySelected(param1:SMSformEvent) : void
      {
         this.descriptionBlock.updateDescription();
      }
   }
}
