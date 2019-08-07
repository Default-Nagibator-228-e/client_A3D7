package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.Diamond;
   import assets.icons.IconGarageMod;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ConfirmAlert extends Sprite
   {
       
      
      private var localeService:ILocaleService;
      
      private var window:TankWindow;
      
      private var upgradeIndicator:IconGarageMod;
      
      private var preview:Bitmap;
      
      private var previewInner:TankWindowInner;
      
      private var questionLabel:Label;
      
      private var costLabel:Label;
      
      private var nameLabel:Label;
      
      private var crystalIcon:Diamond;
      
      public var confirmButton:DefaultButton;
      
      public var cancelButton:DefaultButton;
      
      private var windowWidth:int;
      
      private var windowHeight:int;
      
      private const windowMargin:int = 11;
      
      private const spaceModule:int = 7;
      
      private const previewSize:Point = new Point(164,106);
      
      private const buttonSize:Point = new Point(104,33);
      
      public function ConfirmAlert(name:String, cost:int, previewBd:BitmapData, buyAlert:Boolean, modIndex:int, text:String, inventoryNum:int = -1)
      {
         super();
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.windowWidth = Math.max(this.buttonSize.x * 2 + this.windowMargin * 2 + this.spaceModule,this.previewSize.x + this.windowMargin * 4);
         this.window = new TankWindow(this.windowWidth,0);
         addChild(this.window);
         this.previewInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.previewInner.x = this.windowMargin;
         this.previewInner.y = this.windowMargin;
         this.previewInner.width = this.windowWidth - this.windowMargin * 2;
         this.previewInner.height = this.previewSize.y + this.windowMargin * 2;
         addChild(this.previewInner);
         this.preview = new Bitmap(previewBd);
         addChild(this.preview);
         this.preview.x = this.previewInner.x + int((this.windowWidth - this.windowMargin * 2 - this.previewSize.x) * 0.5);
         this.preview.y = this.windowMargin * 2;
         if(modIndex != -1)
         {
            this.upgradeIndicator = new IconGarageMod();
            addChild(this.upgradeIndicator);
            this.upgradeIndicator.x = this.windowWidth - this.windowMargin - this.spaceModule - this.upgradeIndicator.width + 2;
            this.upgradeIndicator.y = this.windowMargin + this.spaceModule - 1;
            this.upgradeIndicator.mod = modIndex;
         }
         this.questionLabel = new Label();
         addChild(this.questionLabel);
         this.questionLabel.text = text;
         this.questionLabel.x = this.windowWidth - this.questionLabel.width >> 1;
         this.questionLabel.width = this.windowWidth - this.windowMargin * 2;
         this.questionLabel.y = this.previewInner.y + this.previewSize.y + this.windowMargin * 2 + this.spaceModule;
         this.nameLabel = new Label();
         addChild(this.nameLabel);
         if(modIndex > 0)
         {
            this.nameLabel.text = "\"" + name + "\" M" + modIndex + " " + this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_COST_PREFIX);
         }
         else
         {
            this.nameLabel.text = "\"" + name + "\" " + (inventoryNum > 1?"(" + inventoryNum + ") ":"") + this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_COST_PREFIX);
         }
         this.crystalIcon = new Diamond();
         addChild(this.crystalIcon);
         this.costLabel = new Label();
         addChild(this.costLabel);
         this.costLabel.text = cost.toString();
         var costBlockWidth:int = this.nameLabel.width + this.costLabel.width + this.crystalIcon.width + 2;
         var costBlockX:int = this.windowWidth - costBlockWidth >> 1;
         this.nameLabel.x = costBlockX;
         this.nameLabel.y = this.questionLabel.y + this.questionLabel.height + this.windowMargin;
         this.crystalIcon.x = this.nameLabel.x + this.nameLabel.width + 2;
         this.crystalIcon.y = this.nameLabel.y + 5;
         this.costLabel.x = this.crystalIcon.x + this.crystalIcon.width;
         this.costLabel.y = this.nameLabel.y;
         this.windowHeight = this.nameLabel.y + this.nameLabel.height + this.windowMargin * 2 + this.buttonSize.y;
         this.cancelButton = new DefaultButton();
         addChild(this.cancelButton);
         this.cancelButton.label = this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_CANCEL_BUTTON_TEXT);
         this.cancelButton.x = this.windowWidth - this.buttonSize.x - 3;
         this.cancelButton.y = this.windowHeight - this.windowMargin - this.buttonSize.y + 2;
         this.confirmButton = new DefaultButton();
         addChild(this.confirmButton);
         this.confirmButton.label = this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_CONFIRM_BUTTON_TEXT);
         this.confirmButton.x = this.windowMargin;
         this.confirmButton.y = this.windowHeight - this.windowMargin - this.buttonSize.y + 2;
         this.window.height = this.windowHeight;
      }
   }
}
