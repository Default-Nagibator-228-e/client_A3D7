package forms.cong
{
   import alternativa.init.Main;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.ImageConst;
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
   import forms.TankWindowWithHeader;
   
   public class CongratulationsWindowPresent extends Sprite
   {
      
      private static var abonBd:BitmapData;
      [Embed(source="bonus_crystals.png")]
      private static const bitmapCrys:Class;
      
      private static const crysBd:BitmapData = new bitmapCrys().bitmapData;
      
      public static const CRYSTALS:int = 0;
      
      public static const NOSUPPLIES:int = 1;
       
      
      private var window:TankWindowWithHeader;
      
      private var inner:TankWindowInner;
      
      private var messageTopLabel:Label;
      
      private var messageBottomLabel:Label;
      
      private var presentBitmap:Bitmap;
      
      public var closeButton:DefaultButton;
      
      private var bannerObject:ClientObject;
      
      private var bannerContainer:Sprite;
      
      private var bannerBmp:Bitmap;
      
      private var bannerURL:String;
      
      private var windowWidth:int = 450;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const space:int = 8;
      
      public function CongratulationsWindowPresent(type:int, bannerObject:ClientObject, numCrystals:int = 0)
      {
         var messageTop:String = null;
         var messageBottom:String = null;
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.bannerContainer = new Sprite();
         this.bannerBmp = new Bitmap();
         this.bannerContainer.addChild(this.bannerBmp);
         if(type == CRYSTALS)
         {
            this.presentBitmap = new Bitmap(crysBd);
            messageTop = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_TEXT);
            messageBottom = TextConst.setVarsInString(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_CRYSTALS_TEXT),numCrystals);
         }
         else
         {
            this.presentBitmap = new Bitmap(ILocaleService(Main.osgi.getService(ILocaleService)).getImage(ImageConst.CONGRATULATION_WINDOW_TICKET_IMAGE));
            messageTop = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_TEXT);
            messageBottom = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_NOSUPPLIES_TEXT);
         }
         this.windowWidth = this.presentBitmap.width + this.windowMargin * 2 + this.margin * 2;
         this.window = TankWindowWithHeader.createWindow("ПОЗДРАВЛЯЕМ!");
		 this.window.width = this.windowWidth;
		 this.window.height = this.presentBitmap.height;
         addChild(this.window);
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.inner);
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         this.messageTopLabel = new Label();
         this.messageTopLabel.align = TextFormatAlign.CENTER;
         this.messageTopLabel.wordWrap = true;
         this.messageTopLabel.multiline = true;
         this.messageTopLabel.size = 12;
         this.messageTopLabel.text = messageTop;
         this.messageTopLabel.color = 5898034;
         this.messageTopLabel.x = this.windowMargin * 2;
         this.messageTopLabel.y = this.windowMargin * 2;
         this.messageTopLabel.width = this.windowWidth - this.windowMargin * 4;
         addChild(this.messageTopLabel);
         this.presentBitmap.x = this.margin + this.windowMargin;
         this.presentBitmap.y = this.messageTopLabel.y + this.messageTopLabel.height - 20;
         addChild(this.presentBitmap);
         this.messageBottomLabel = new Label();
         this.messageBottomLabel.align = TextFormatAlign.CENTER;
         this.messageBottomLabel.wordWrap = true;
         this.messageBottomLabel.multiline = true;
         this.messageBottomLabel.size = 12;
         this.messageBottomLabel.color = 5898034;
         this.messageBottomLabel.htmlText = messageBottom;
         this.messageBottomLabel.x = this.windowMargin * 2;
         this.messageBottomLabel.y = this.presentBitmap.y + this.presentBitmap.height - 20;
         this.messageBottomLabel.width = this.windowWidth - this.windowMargin * 4;
         addChild(this.messageBottomLabel);
         this.closeButton = new DefaultButton();
         addChild(this.closeButton);
         this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         this.window.height = this.messageBottomLabel.y + this.messageBottomLabel.height + this.closeButton.height + this.margin * 3;
         this.closeButton.y = this.window.height - this.margin - 35;
         this.closeButton.x = this.window.width - this.closeButton.width >> 1;
         this.inner.width = this.window.width - this.windowMargin * 2;
         this.inner.height = this.window.height - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
      }
   }
}
