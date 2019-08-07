package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import controls.chat.ChatOutput;
   import controls.chat.ChatOutputLine;
   import fl.events.ScrollEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import forms.contextmenu.ContextMenu;
   import forms.events.ChatFormEvent;
   import forms.events.LoginFormEvent;
   import forms.news.News;
   import forms.buttons.Newsb;
   import forms.userlabel.UserLabel;
   
   public class Communic extends Sprite
   {
      
      private var mainBackground:TankWindowWithHeader;
	  
	  public var nov:Newsb = new Newsb("Новости");
	  
	  public var cha:DefaultButton = new DefaultButton();
	  
	  public var chat:Chat;
	  
	  public var news:News;
      
      public function Communic()
      {
         this.mainBackground = TankWindowWithHeader.createWindow("КОММУНИКАТОР");
		 cha.label = "Чат";
		 cha.width = nov.width;
		 cha.height = nov.height;
		 chat = new Chat(this);
		 news = new News(this);
		 nov.en();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE, this.removeResizeListener);
		 cha.addEventListener(MouseEvent.CLICK, c);
		 nov.addEventListener(MouseEvent.CLICK, n);
      }
	  
	  private function n(e:Event) : void
      {
		 cha.enable = true;
		 nov.en();
         chat.visible = false;
		 news.visible = true;
      }
	  
	  private function c(e:Event) : void
      {
		 nov.enable = true;
		 cha.en();
         chat.visible = true;
		 news.visible = false;
      }
      
      private function addResizeListener(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE, this.onResize);
		 addChild(this.mainBackground);
		 this.nov.x = this.cha.y = this.nov.y = 11;
		 cha.x = this.nov.x + this.nov.width + 5;
		 addChild(cha);
		 addChild(nov);
		 addChild(chat);
		 addChild(news);
         this.onResize(null);
		 n(null);
      }
      
      private function removeResizeListener(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onResize(e:Event) : void
      {
         var minWidth:int = int(Math.max(100,stage.stageWidth));
         this.mainBackground.width = minWidth / 3;
         this.mainBackground.height = Math.max(stage.stageHeight - 60, 530);
		 x = 0;
         y = 60;
		 this.chat.onResize(this.mainBackground.width, this.mainBackground.height);
		 this.news.res(this.mainBackground.width, this.mainBackground.height);
      }
   }
}
