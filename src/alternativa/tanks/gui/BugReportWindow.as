package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TextArea;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import forms.events.LoginFormEvent;
   
   public class BugReportWindow extends Sprite
   {
       
      
      private var sendButton:DefaultButton;
      
      private var sendScreenShot:TankCheckBox;
      
      private var cancelButton:DefaultButton;
      
      private var window:TankWindow;
      
      private var summaryLabel:Label;
      
      private var summaryInput:TankInput;
      
      private var descriptionLabel:Label;
      
      private var descriptionInput:TextArea;
      
      private var image:Bitmap;
      
      private var imageSize:Point;
      
      private var windowSize:Point;
      
      private const windowWidth:int = 340;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      private var progressBar:ProgressBar;
      
      private var cropRectContainer:Sprite;
      
      private var cropLeftButton:Sprite;
      
      private var cropTopButton:Sprite;
      
      private var cropRightButton:Sprite;
      
      private var cropBottomButton:Sprite;
      
      private var cropTopLeftButton:Sprite;
      
      private var cropTopRightButton:Sprite;
      
      private var cropBottomLeftButton:Sprite;
      
      private var cropBottomRightButton:Sprite;
      
      private var holdPoint:Point;
      
      private var moveButton:Sprite;
      
      private var dragButton:Sprite;
      
      private var cropRect:Rectangle;
      
      private var k:Number;
      
      private var maxCropWidth:int;
      
      private var maxCropHeight:int;
      
      public function BugReportWindow(screenShot:BitmapData)
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.imageSize = new Point(this.windowWidth - this.windowMargin * 2,(this.windowWidth - this.windowMargin * 2) * (screenShot.height / screenShot.width));
         var tf:TextFormat = new TextFormat("Tahoma",14,16777215,true);
         this.windowSize = new Point(this.windowWidth,this.imageSize.y * 2 + this.windowMargin * 5 + this.buttonSize.y);
         this.window = new TankWindow(this.windowSize.x,this.windowSize.y);
         addChild(this.window);
         this.window.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.BUG_REPORT;
         var screenPreview:BitmapData = new BitmapData(this.imageSize.x,this.imageSize.y,true,0);
         var matrix:Matrix = new Matrix();
         this.k = this.imageSize.x / screenShot.width;
         matrix.scale(this.k,this.k);
         screenPreview.draw(screenShot,matrix);
         this.maxCropWidth = screenShot.width * this.k;
         this.maxCropHeight = screenShot.height * this.k;
         this.image = new Bitmap(screenPreview);
         addChild(this.image);
         this.image.x = this.windowMargin;
         this.image.y = this.windowMargin;
         this.cropRect = new Rectangle();
         this.holdPoint = new Point();
         this.cropRectContainer = new Sprite();
         addChild(this.cropRectContainer);
         this.cropRectContainer.x = this.image.x;
         this.cropRectContainer.y = this.image.y;
         this.moveButton = new Sprite();
         this.cropRectContainer.addChild(this.moveButton);
         this.moveButton.addEventListener(MouseEvent.MOUSE_DOWN,this.holdMoveButton);
         this.moveButton.addEventListener(MouseEvent.DOUBLE_CLICK,this.maximizeCropRect);
         this.cropLeftButton = this.createCropButton();
         this.cropTopButton = this.createCropButton();
         this.cropRightButton = this.createCropButton();
         this.cropBottomButton = this.createCropButton();
         this.cropTopLeftButton = this.createCropButton();
         this.cropTopRightButton = this.createCropButton();
         this.cropBottomLeftButton = this.createCropButton();
         this.cropBottomRightButton = this.createCropButton();
         this.setCropRect(this.image.width - this.maxCropWidth >> 1,this.image.height - this.maxCropHeight >> 1,this.maxCropWidth,this.maxCropHeight);
         this.sendScreenShot = new TankCheckBox();
         this.sendScreenShot.label = localeService.getText(TextConst.BUG_REPORT_SEND_SCREEN_SHOT_CHECKBOX_LABEL_TEXT);
         this.sendScreenShot.checked = true;
         addChild(this.sendScreenShot);
         this.sendScreenShot.x = this.windowMargin;
         this.sendScreenShot.y = this.image.y + this.image.height + this.windowMargin;
         this.summaryLabel = new Label();
         addChild(this.summaryLabel);
         this.summaryLabel.text = localeService.getText(TextConst.BUG_REPORT_SUMMARY_LABEL_TEXT);
         this.summaryLabel.x = this.windowMargin - 2;
         this.summaryLabel.y = this.sendScreenShot.y + this.sendScreenShot.height + this.windowMargin;
         this.summaryInput = new TankInput();
         addChild(this.summaryInput);
         this.summaryInput.width = this.imageSize.x;
         this.summaryInput.x = this.windowMargin;
         this.summaryInput.y = this.summaryLabel.y + this.summaryLabel.textHeight + Math.round(this.windowMargin * 0.5);
         this.summaryInput.addEventListener(LoginFormEvent.TEXT_CHANGED,this.onSummaryChange);
         this.descriptionLabel = new Label();
         addChild(this.descriptionLabel);
         this.descriptionLabel.text = localeService.getText(TextConst.BUG_REPORT_DESCRIPTION_LABEL_TEXT);
         this.descriptionLabel.x = this.windowMargin - 2;
         this.descriptionLabel.y = this.summaryInput.y + this.summaryInput.height + this.windowMargin;
         this.descriptionInput = new TextArea();
         addChild(this.descriptionInput);
         this.descriptionInput.tf.addEventListener(Event.CHANGE,this.onDescriptionChange);
         this.descriptionInput.width = this.imageSize.x;
         this.descriptionInput.x = this.windowMargin;
         this.descriptionInput.y = this.descriptionLabel.y + this.descriptionLabel.textHeight + Math.round(this.windowMargin * 0.5);
         this.descriptionInput.height = this.windowSize.y - this.windowMargin * 2 - this.buttonSize.y - this.descriptionInput.y + 2;
         this.descriptionInput.maxChars = 500;
         this.cancelButton = new DefaultButton();
         addChild(this.cancelButton);
         this.cancelButton.label = localeService.getText(TextConst.BUG_REPORT_BUTTON_CANCEL_TEXT);
         this.cancelButton.x = this.windowSize.x - this.buttonSize.x - this.margin + 5;
         this.cancelButton.y = this.windowSize.y - this.buttonSize.y - this.margin;
         this.sendButton = new DefaultButton();
         addChild(this.sendButton);
         this.sendButton.label = localeService.getText(TextConst.BUG_REPORT_BUTTON_SEND_TEXT);
         this.sendButton.x = this.windowSize.x - this.buttonSize.x * 2 - 1 - this.margin;
         this.sendButton.y = this.windowSize.y - this.buttonSize.y - this.margin;
         this.sendButton.enable = false;
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.sendButton.addEventListener(MouseEvent.CLICK,this.onSendClick);
         this.progressBar = new ProgressBar();
         addChild(this.progressBar);
         this.progressBar.resize(this.windowSize.x - this.windowMargin * 2);
         this.progressBar.x = this.windowMargin;
         this.progressBar.y = this.sendButton.y + Math.round((this.buttonSize.y - this.progressBar.height) * 0.5);
         this.progressBar.visible = false;
      }
      
      public function showProgress() : void
      {
         this.cancelButton.visible = false;
         this.sendButton.visible = false;
         this.progressBar.visible = true;
      }
      
      public function setProgress(n:Number) : void
      {
         this.progressBar.setProgress(n);
      }
      
      public function get summary() : String
      {
         return this.summaryInput.value;
      }
      
      public function get description() : String
      {
         return this.descriptionInput.text;
      }
      
      public function get sendScreenshot() : Boolean
      {
         return this.sendScreenShot.checked;
      }
      
      private function onSummaryChange(e:Event) : void
      {
         if(this.descriptionInput.text.length >= 3 && this.summaryInput.value.length >= 3)
         {
            this.sendButton.enable = true;
         }
         else
         {
            this.sendButton.enable = false;
         }
      }
      
      private function onDescriptionChange(e:Event) : void
      {
         if(this.descriptionInput.text.length >= 3 && this.summaryInput.value.length >= 3)
         {
            this.sendButton.enable = true;
         }
         else
         {
            this.sendButton.enable = false;
         }
      }
      
      private function onCancelClick(e:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CANCEL,true,false));
      }
      
      private function onSendClick(e:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE,true,false));
      }
      
      private function createCropButton() : Sprite
      {
         var button:Sprite = new Sprite();
         button.graphics.beginFill(13369344,1);
         button.graphics.drawRect(-5,-5,10,10);
         this.cropRectContainer.addChild(button);
         button.addEventListener(MouseEvent.MOUSE_DOWN,this.holdCropButton);
         return button;
      }
      
      private function setCropRect(x:int, y:int, width:int, height:int, resize:Boolean = true) : void
      {
         this.cropRect.x = x;
         this.cropRect.y = y;
         this.cropRect.width = width;
         this.cropRect.height = height;
         this.cropRectContainer.graphics.clear();
         this.cropRectContainer.graphics.beginFill(0,0.5);
         this.cropRectContainer.graphics.drawRect(0,0,this.image.width,this.image.height);
         this.cropRectContainer.graphics.lineStyle(1,13369344);
         this.cropRectContainer.graphics.drawRect(x,y,width,height);
         this.cropLeftButton.x = x;
         this.cropLeftButton.y = y + int(this.cropRect.height * 0.5);
         this.cropTopButton.x = x + int(this.cropRect.width * 0.5);
         this.cropTopButton.y = y;
         this.cropRightButton.x = x + width;
         this.cropRightButton.y = y + int(this.cropRect.height * 0.5);
         this.cropBottomButton.x = x + int(this.cropRect.width * 0.5);
         this.cropBottomButton.y = y + height;
         this.cropTopLeftButton.x = x;
         this.cropBottomLeftButton.x = x;
         this.cropTopRightButton.x = x + width;
         this.cropBottomRightButton.x = x + width;
         this.cropTopLeftButton.y = y;
         this.cropTopRightButton.y = y;
         this.cropBottomLeftButton.y = y + height;
         this.cropBottomRightButton.y = y + height;
         if(resize)
         {
            this.moveButton.x = x;
            this.moveButton.y = y;
            this.moveButton.graphics.clear();
            this.moveButton.graphics.beginFill(204,0);
            this.moveButton.graphics.drawRect(0,0,width,height);
         }
      }
      
      private function holdCropButton(e:MouseEvent) : void
      {
         this.dragButton = e.target as Sprite;
         this.holdPoint.x = this.dragButton.mouseX;
         this.holdPoint.y = this.dragButton.mouseY;
         Main.stage.addEventListener(MouseEvent.MOUSE_UP,this.dropCropButton);
         Main.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragCropButton);
      }
      
      private function dragCropButton(e:MouseEvent) : void
      {
         if(this.dragButton == this.cropLeftButton || this.dragButton == this.cropRightButton)
         {
            this.dragButton.x = this.dragButton.x + (this.dragButton.mouseX - this.holdPoint.x);
         }
         else if(this.dragButton == this.cropTopButton || this.dragButton == this.cropBottomButton)
         {
            this.dragButton.y = this.dragButton.y + (this.dragButton.mouseY - this.holdPoint.y);
         }
         else
         {
            this.dragButton.x = this.dragButton.x + (this.dragButton.mouseX - this.holdPoint.x);
            this.dragButton.y = this.dragButton.y + (this.dragButton.mouseY - this.holdPoint.y);
         }
         switch(this.dragButton)
         {
            case this.cropLeftButton:
               if(this.cropLeftButton.x < 0)
               {
                  this.cropLeftButton.x = 0;
               }
               if(this.cropLeftButton.x > this.cropRightButton.x)
               {
                  this.cropLeftButton.x = this.cropRightButton.x;
               }
               if(this.cropRightButton.x - this.cropLeftButton.x > this.maxCropWidth)
               {
                  this.cropLeftButton.x = this.cropRightButton.x - this.maxCropWidth;
               }
               break;
            case this.cropTopButton:
               if(this.cropTopButton.y < 0)
               {
                  this.cropTopButton.y = 0;
               }
               if(this.cropTopButton.y > this.cropBottomButton.y)
               {
                  this.cropTopButton.y = this.cropBottomButton.y;
               }
               if(this.cropBottomButton.y - this.cropTopButton.y > this.maxCropHeight)
               {
                  this.cropTopButton.y = this.cropBottomButton.y - this.maxCropHeight;
               }
               break;
            case this.cropRightButton:
               if(this.cropRightButton.x > this.image.width)
               {
                  this.cropRightButton.x = this.image.width;
               }
               if(this.cropRightButton.x < this.cropLeftButton.x)
               {
                  this.cropRightButton.x = this.cropLeftButton.x;
               }
               if(this.cropRightButton.x - this.cropLeftButton.x > this.maxCropWidth)
               {
                  this.cropRightButton.x = this.cropLeftButton.x + this.maxCropWidth;
               }
               break;
            case this.cropBottomButton:
               if(this.cropBottomButton.y > this.image.height)
               {
                  this.cropBottomButton.y = this.image.height;
               }
               if(this.cropBottomButton.y < this.cropTopButton.y)
               {
                  this.cropBottomButton.y = this.cropTopButton.y;
               }
               if(this.cropBottomButton.y - this.cropTopButton.y > this.maxCropHeight)
               {
                  this.cropBottomButton.y = this.cropTopButton.y + this.maxCropHeight;
               }
               break;
            case this.cropTopLeftButton:
               if(this.cropTopLeftButton.x < 0)
               {
                  this.cropTopLeftButton.x = 0;
               }
               if(this.cropTopLeftButton.x > this.cropRightButton.x)
               {
                  this.cropTopLeftButton.x = this.cropRightButton.x;
               }
               if(this.cropRightButton.x - this.cropTopLeftButton.x > this.maxCropWidth)
               {
                  this.cropTopLeftButton.x = this.cropRightButton.x - this.maxCropWidth;
               }
               if(this.cropTopLeftButton.y < 0)
               {
                  this.cropTopLeftButton.y = 0;
               }
               if(this.cropTopLeftButton.y > this.cropBottomButton.y)
               {
                  this.cropTopLeftButton.y = this.cropBottomButton.y;
               }
               if(this.cropBottomButton.y - this.cropTopLeftButton.y > this.maxCropHeight)
               {
                  this.cropTopLeftButton.y = this.cropBottomButton.y - this.maxCropHeight;
               }
               this.cropTopButton.y = this.cropTopLeftButton.y;
               this.cropLeftButton.x = this.cropTopLeftButton.x;
               break;
            case this.cropTopRightButton:
               if(this.cropTopRightButton.x > this.image.width)
               {
                  this.cropTopRightButton.x = this.image.width;
               }
               if(this.cropTopRightButton.x < this.cropLeftButton.x)
               {
                  this.cropTopRightButton.x = this.cropLeftButton.x;
               }
               if(this.cropTopRightButton.x - this.cropLeftButton.x > this.maxCropWidth)
               {
                  this.cropTopRightButton.x = this.cropLeftButton.x + this.maxCropWidth;
               }
               if(this.cropTopRightButton.y < 0)
               {
                  this.cropTopRightButton.y = 0;
               }
               if(this.cropTopRightButton.y > this.cropBottomButton.y)
               {
                  this.cropTopRightButton.y = this.cropBottomButton.y;
               }
               if(this.cropBottomButton.y - this.cropTopRightButton.y > this.maxCropHeight)
               {
                  this.cropTopRightButton.y = this.cropBottomButton.y - this.maxCropHeight;
               }
               this.cropTopButton.y = this.cropTopRightButton.y;
               this.cropRightButton.x = this.cropTopRightButton.x;
               break;
            case this.cropBottomLeftButton:
               if(this.cropBottomLeftButton.x < 0)
               {
                  this.cropBottomLeftButton.x = 0;
               }
               if(this.cropBottomLeftButton.x > this.cropRightButton.x)
               {
                  this.cropBottomLeftButton.x = this.cropRightButton.x;
               }
               if(this.cropRightButton.x - this.cropBottomLeftButton.x > this.maxCropWidth)
               {
                  this.cropBottomLeftButton.x = this.cropRightButton.x - this.maxCropWidth;
               }
               if(this.cropBottomLeftButton.y > this.image.height)
               {
                  this.cropBottomLeftButton.y = this.image.height;
               }
               if(this.cropBottomLeftButton.y < this.cropTopButton.y)
               {
                  this.cropBottomLeftButton.y = this.cropTopButton.y;
               }
               if(this.cropBottomLeftButton.y - this.cropTopButton.y > this.maxCropHeight)
               {
                  this.cropBottomLeftButton.y = this.cropTopButton.y + this.maxCropHeight;
               }
               this.cropBottomButton.y = this.cropBottomLeftButton.y;
               this.cropLeftButton.x = this.cropBottomLeftButton.x;
               break;
            case this.cropBottomRightButton:
               if(this.cropBottomRightButton.x > this.image.width)
               {
                  this.cropBottomRightButton.x = this.image.width;
               }
               if(this.cropBottomRightButton.x < this.cropLeftButton.x)
               {
                  this.cropBottomRightButton.x = this.cropLeftButton.x;
               }
               if(this.cropBottomRightButton.x - this.cropLeftButton.x > this.maxCropWidth)
               {
                  this.cropBottomRightButton.x = this.cropLeftButton.x + this.maxCropWidth;
               }
               if(this.cropBottomRightButton.y > this.image.height)
               {
                  this.cropBottomRightButton.y = this.image.height;
               }
               if(this.cropBottomRightButton.y < this.cropTopButton.y)
               {
                  this.cropBottomRightButton.y = this.cropTopButton.y;
               }
               if(this.cropBottomRightButton.y - this.cropTopButton.y > this.maxCropHeight)
               {
                  this.cropBottomRightButton.y = this.cropTopButton.y + this.maxCropHeight;
               }
               this.cropBottomButton.y = this.cropBottomRightButton.y;
               this.cropRightButton.x = this.cropBottomRightButton.x;
         }
         this.setCropRect(this.cropLeftButton.x,this.cropTopButton.y,this.cropRightButton.x - this.cropLeftButton.x,this.cropBottomButton.y - this.cropTopButton.y);
      }
      
      private function dropCropButton(e:MouseEvent) : void
      {
         Main.stage.removeEventListener(MouseEvent.MOUSE_UP,this.dropCropButton);
         Main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragCropButton);
      }
      
      private function maximizeCropRect(e:MouseEvent) : void
      {
         Main.writeToConsole("maximizeCropRect");
         this.setCropRect(0,0,this.image.width,this.image.height);
      }
      
      private function holdMoveButton(e:MouseEvent) : void
      {
         this.dragButton = e.target as Sprite;
         this.holdPoint.x = this.moveButton.mouseX;
         this.holdPoint.y = this.moveButton.mouseY;
         Main.stage.addEventListener(MouseEvent.MOUSE_UP,this.dropMoveButton);
         Main.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragMoveButton);
      }
      
      private function dragMoveButton(e:MouseEvent) : void
      {
         this.moveButton.x = this.moveButton.x + (this.moveButton.mouseX - this.holdPoint.x);
         this.moveButton.y = this.moveButton.y + (this.moveButton.mouseY - this.holdPoint.y);
         if(this.moveButton.x < 0)
         {
            this.moveButton.x = 0;
         }
         if(this.moveButton.y < 0)
         {
            this.moveButton.y = 0;
         }
         if(this.moveButton.x + this.moveButton.width > this.image.width)
         {
            this.moveButton.x = this.image.width - this.moveButton.width;
         }
         if(this.moveButton.y + this.moveButton.height > this.image.height)
         {
            this.moveButton.y = this.image.height - this.moveButton.height;
         }
         this.setCropRect(this.moveButton.x,this.moveButton.y,this.moveButton.width,this.moveButton.height,false);
      }
      
      private function dropMoveButton(e:MouseEvent) : void
      {
         Main.stage.removeEventListener(MouseEvent.MOUSE_UP,this.dropMoveButton);
         Main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragMoveButton);
      }
      
      public function get cropRectangle() : Rectangle
      {
         var fullSizeRect:Rectangle = this.cropRect.clone();
         fullSizeRect.x = fullSizeRect.x / this.k;
         fullSizeRect.y = fullSizeRect.y / this.k;
         fullSizeRect.width = fullSizeRect.width / this.k;
         fullSizeRect.height = fullSizeRect.height / this.k;
         return fullSizeRect;
      }
   }
}
