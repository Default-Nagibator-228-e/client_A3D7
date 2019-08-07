package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFormatAlign;
   
   public class EntranceAlertWindow extends Sprite
   {
      [Embed(source="en/1.png")]
      private static const DISCOUNT_PICTURE_EN:Class;
      [Embed(source="en/2.png")]
      private static const DISCOUNT_PICTURE_RU:Class;
      
      private static const entranceBitmapDataEn:BitmapData = new DISCOUNT_PICTURE_EN().bitmapData;
      
      private static const entranceBitmapDataRu:BitmapData = new DISCOUNT_PICTURE_RU().bitmapData;
      
      public static const CRYSTALS:int = 0;
      
      public static const NOSUPPLIES:int = 1;
       
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var messageTopLabel:Label;
      
      private var messageBottomLabel:Label;
      
      private var entranceImage:Bitmap;
      
      public var closeButton:DefaultButton;
      
      private var windowWidth:int = 430;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const space:int = 8;
      
      public function EntranceAlertWindow()
      {
         var messageTop:String = null;
         var messageBottom:String = null;
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.entranceImage = ILocaleService(Main.osgi.getService(ILocaleService)).language == "RU"?new Bitmap(entranceBitmapDataRu):new Bitmap(entranceBitmapDataEn);
         messageTop = ILocaleService(Main.osgi.getService(ILocaleService)).language == "RU"?"Поздравляем с Днём Танкиста!":"Dear tankmen!";
         messageBottom = ILocaleService(Main.osgi.getService(ILocaleService)).language == "RU"?"12 сентября в России и странах СНГ отмечается профессиональный праздник танкистов и танкостроителей. Администрация «Танков Онлайн» желает вам удачи в виртуальных боях и дарит скидку 25% на все товары в «Гараже». Внимание, скидка действует только до 05:00 понедельника, 13 сентября (время московское).":"On the 12th of September a professional holiday of tankmen and tank constructors is celebrated in Russia. Administration of Tanki Online wishes you good luck in virtual fights and presents 25% discount on all goods in the Garage. Attention, discount lasts only till 05:00 of Monday, September 13th (UTC +4).";
         this.window = new TankWindow(this.windowWidth,this.entranceImage.height);
         addChild(this.window);
         this.window.header = TankWindowHeader.ACCOUNT;
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.inner);
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         this.entranceImage.x = (this.windowWidth - this.entranceImage.width) / 2;
         this.entranceImage.y = this.windowMargin * 2;
         addChild(this.entranceImage);
         this.messageTopLabel = new Label();
         this.messageTopLabel.align = TextFormatAlign.CENTER;
         this.messageTopLabel.wordWrap = true;
         this.messageTopLabel.multiline = true;
         this.messageTopLabel.size = 18;
         this.messageTopLabel.bold = true;
         this.messageTopLabel.text = messageTop;
         this.messageTopLabel.color = 5898034;
         this.messageTopLabel.x = this.windowMargin * 2;
         this.messageTopLabel.y = this.entranceImage.y + this.entranceImage.height - 10;
         this.messageTopLabel.width = this.windowWidth - this.windowMargin * 4;
         addChild(this.messageTopLabel);
         this.messageBottomLabel = new Label();
         this.messageBottomLabel.align = TextFormatAlign.LEFT;
         this.messageBottomLabel.wordWrap = true;
         this.messageBottomLabel.multiline = true;
         this.messageBottomLabel.size = 12;
         this.messageBottomLabel.color = 5898034;
         this.messageBottomLabel.htmlText = messageBottom;
         this.messageBottomLabel.x = this.windowMargin * 2;
         this.messageBottomLabel.y = this.messageTopLabel.y + this.messageTopLabel.height;
         this.messageBottomLabel.width = this.windowWidth - this.windowMargin * 4;
         addChild(this.messageBottomLabel);
         this.closeButton = new DefaultButton();
         addChild(this.closeButton);
         this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         this.window.height = this.messageBottomLabel.y + this.messageBottomLabel.height + this.closeButton.height + this.margin * 3 + 10;
         this.closeButton.y = this.window.height - this.margin - 35;
         this.closeButton.x = this.window.width - this.closeButton.width >> 1;
         this.inner.width = this.window.width - this.windowMargin * 2;
         this.inner.height = this.window.height - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
      }
   }
}
