package forms.shop.windows
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.shop.components.itemcategoriesview.ItemCategoriesView;
   import forms.shop.components.itemscategory.ItemsCategoryView;
   import forms.shop.components.paymentview.PaymentView;
   import forms.shop.components.window.ShopWindowHeader;
   import forms.shop.payment.Activate;
   import forms.shop.shopitems.item.bp.BPButton;
   import forms.shop.shopitems.item.crystalitem.CrystalPackageButton;
   import forms.shop.windows.bugreport.PaymentBugReportBlock;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import forms.TankWindowWithHeader;
   
   public class ShopWindow extends Sprite
   {
      
      public static var localeService:ILocaleService;
      
      public static const WINDOW_PADDING:int = 11;
      
      public static const WINDOW_WIDTH:int = 915;
      
      private static const WINDOW_MAX_HEIGHT:int = 691;
      
      private static const WINDOW_MIN_HEIGHT:int = 580;
       
      
      public var window:TankWindowWithHeader;
	  
	  public var cat:ItemCategoriesView;
      
      private var header:ShopWindowHeader;
      
      private var headerLayerIndex:int;
      
      private var paymentView:PaymentView;
      
      private var bugReportBlock:PaymentBugReportBlock;
      
      private var closeButton:DefaultButtonBase;
      
      private var eulaLink:LabelBase;
      
      private var privacyAndCookiesLink:LabelBase;
      
      private var purchaseInstructionLink:LabelBase;
      
      private var params:ShopWindowParams;
	  
	  private var fge:Long = new Long(0, 4);
	  
	  private var fge1:Long = new Long(0, 4);
	  
	  private var fg:Long = new Long(0, 1);
	  
	  private var fg1:Long = new Long(0, 1);
      
      public function ShopWindow(param1:ShopWindowParams)
      {
         this.eulaLink = new LabelBase();
         this.privacyAndCookiesLink = new LabelBase();
         this.purchaseInstructionLink = new LabelBase();
         super();
         this.params = param1;
         this.createWindow();
         this.createWindowHeader();
         this.createBugReportBlock();
         this.createCloseButton();
		 this.createCat();
      }
      
      private function createWindow() : void
      {
         this.window = TankWindowWithHeader.createWindow("МАГАЗИН");
         this.window.width = WINDOW_WIDTH;
         addChild(this.window);
      }
	  
	  private function createCat() : void
      {
         this.cat = new ItemCategoriesView();
		 this.cat.addCategory(new ItemsCategoryView("Кристаллы", "Здесь вы можете купить кристаллы, чтобы использовать их для приобретения нужных вам вещей в гараже", fge));
		 this.cat.addCategory(new ItemsCategoryView("Боевой пропуск","",fge1));
		 this.cat.addCategory(new ItemsCategoryView("Платёжная инструкция","Выберите желаемый пакет кристаллов, нажмите на него и дождитесь момента, пока система перенаправит Вас на сайт для завершения оплаты. После внесения определённой суммы денег и подтверждения платежа, Вам будет выслан специальный текстовый документ с секретным ключом, который нужно будет ввести в соответствующее поле ввода для подтверждения.\nЭто сделано для того, чтобы обезопасить наших игроков от потенциально опасных фишинговых сайтов, на которых якобы можно получить кристаллы.",fg1));
		 this.cat.addCategory(new ItemsCategoryView("Активация","В представленном поле для ввода необходимо указать код для оформления платежа",fg));
		 this.cat.addItem(fge, new CrystalPackageButton(500, 99,"http://194.67.207.47/"));
		 this.cat.addItem(fge, new CrystalPackageButton(1000, 199,"http://194.67.207.47/"));
		 this.cat.addItem(fge, new CrystalPackageButton(3000, 599, "http://194.67.207.47/"));
		 this.cat.addItem(fge1, new BPButton(1, 150,"http://194.67.207.47/"));
		 this.cat.addItem(fg, new Activate());
		 this.render();
		 addChild(this.cat);
      }
      
      private function createWindowHeader() : void
      {
         this.header = new ShopWindowHeader("Здесь вы можете купить различные предметы, которые помогут вам разнообразить игру и могут быть полезными в битвах. Вы соглашаетесь с тем, что купленные предметы будут зачислены на ваш аккаунт после завершения оплаты. Купленные предметы, которые были зачисленны на ваш аккаунт, не подлежат возврату.");
         this.header.x = WINDOW_PADDING;
         this.header.y = WINDOW_PADDING;
         this.header.resize(WINDOW_WIDTH - WINDOW_PADDING * 2);
         addChild(this.header);
         this.headerLayerIndex = numChildren;
      }
      
      private function createBugReportBlock() : void
      {
         this.bugReportBlock = new PaymentBugReportBlock();
         this.bugReportBlock.x = WINDOW_PADDING;
		 this.bugReportBlock.width = WINDOW_WIDTH - WINDOW_PADDING * 2;
         addChild(this.bugReportBlock);
		 this.bugReportBlock.render();
      }
      
      private function createCloseButton() : void
      {
         this.closeButton = new DefaultButtonBase();
         this.closeButton.tabEnabled = false;
         this.closeButton.label = "Закрыть";
         this.closeButton.x = WINDOW_WIDTH - this.closeButton.width - 2 * WINDOW_PADDING;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         addChild(this.closeButton);
      }
      
      public function show() : void
      {
         Main.stage.addEventListener(Event.RESIZE, this.render);
         this.render();
      }
      
      public function get currentPaymentView() : PaymentView
      {
         return this.paymentView;
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this.visible = false;
		 PanelModel(Main.osgi.getService(IPanel)).isP = false;
		 Main.unblur();
		 PanelModel(Main.osgi.getService(IPanel)).partSelected(4);
      }
      
      public function destroy() : void
      {
         if(this.paymentView)
         {
            this.paymentView.destroy();
         }
         Main.stage.removeEventListener(Event.RESIZE,this.render);
         this.closeButton.removeEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.stage.focus = null;
      }
      
      public function render(param1:Event = null) : void
      {
         this.window.height = Math.round(Math.max(60,Math.min(Main.stage.stageHeight - 60,WINDOW_MAX_HEIGHT)));
         this.closeButton.y = this.window.height - this.closeButton.height - WINDOW_PADDING;
         this.eulaLink.y = this.privacyAndCookiesLink.y = this.purchaseInstructionLink.y = this.window.height - this.eulaLink.height - WINDOW_PADDING;
         this.bugReportBlock.y = this.closeButton.y - this.bugReportBlock.height - 3;
         this.bugReportBlock.width = WINDOW_WIDTH - WINDOW_PADDING * 2;
		 this.bugReportBlock.render();
         if(this.paymentView)
         {
            this.paymentView.x = WINDOW_PADDING;
            this.paymentView.y = this.header.y + this.header.height;
            this.paymentView.render(WINDOW_WIDTH - WINDOW_PADDING * 2,this.bugReportBlock.y - this.paymentView.y - 3);
         }
		 this.cat.x = WINDOW_PADDING;
		 this.cat.y = WINDOW_PADDING + this.header.headerInner.height;
		 this.cat.render(WINDOW_WIDTH - WINDOW_PADDING * 2,this.bugReportBlock.y - this.cat.y);
      }
   }
}
