package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.BlueButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Sprite;
   import flash.geom.Point;
   import forms.stat.StatList;
   import utils.client.panel.model.User;
   
   public class StatisticWindow extends Sprite
   {
       
      
      private var searchLabel:Label;
      
      private var input:TankInput;
      
      public var list:StatList;
      
      private var _viewListItemsNum:int;
      
      private const listItemHeight:int = 20;
      
      private var window:TankWindow;
      
      private var windowSize:Point;
      
      private var inner:TankWindowInner;
      
      public var sortByNameButton:BlueButton;
      
      public var sortByKillsButton:BlueButton;
      
      public var sortByDeathButton:BlueButton;
      
      public var sortByRankButton:BlueButton;
      
      public var sortByRatingButton:BlueButton;
      
      public var sortByRatioButton:BlueButton;
      
      public var sortByWealthButton:BlueButton;
      
      private const windowMargin:int = 11;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const spaceModule:int = 3;
      
      public function StatisticWindow()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.windowSize = new Point(600,737);
         this.window = new TankWindow(this.windowSize.x,this.windowSize.y);
         addChild(this.window);
         this.window.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.HALL_OF_FAME;
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.inner.showBlink = true;
         this.inner.x = this.windowMargin;
         addChild(this.inner);
         this.searchLabel = new Label();
         this.searchLabel.text = localeService.getText(TextConst.STATISTICS_SEARCH_LABEL_TEXT);
         addChild(this.searchLabel);
         this.searchLabel.x = this.windowMargin;
         this.input = new TankInput();
         addChild(this.input);
         this.input.x = int(this.windowMargin + this.searchLabel.textWidth + 10);
         this.input.y = this.windowMargin;
         this.input.timeout = 1500;
         this.searchLabel.y = this.input.y + Math.floor((this.input.height - this.searchLabel.textHeight) * 0.5);
         this.inner.y = this.windowMargin + this.input.height + 5;
         this.list = new StatList();
         addChild(this.list);
         this.list.x = this.windowMargin + this.spaceModule + 1;
         this.list.y = this.inner.y + this.spaceModule + 1;
      }
      
      public function resize(width:int, height:int) : void
      {
         this.windowSize = new Point(width,height);
         this.window.width = width;
         this.window.height = height;
         this.inner.width = width - this.windowMargin * 2;
         this.inner.height = height - this.inner.y - this.windowMargin;
         this.input.width = width - this.input.x - this.windowMargin;
         this.list.width = width - this.windowMargin * 2 - this.spaceModule * 2 + 7;
         this.list.height = height - this.list.y - this.windowMargin - this.spaceModule - 1;
         this._viewListItemsNum = Math.floor((height - this.list.y - this.windowMargin * 2) / this.listItemHeight) + 1;
      }
      
      public function viewListItemsNum() : int
      {
         return this._viewListItemsNum;
      }
      
      public function setListLength(length:int) : void
      {
         for(var i:int = 0; i < length; i++)
         {
            this.list.addItem(i + 1);
         }
      }
      
      public function scrollTo(pos:int) : void
      {
         this.list.select(pos);
      }
      
      public function setData(startPos:int, data:Array) : void
      {
         var info:User = null;
         for(var i:int = 0; i < data.length; i++)
         {
            info = data[i] as User;
            this.list.addItem(info.place + 1,info.rank,info.callsign,info.score,info.kills,info.deaths,info.ratio,info.wealth,info.rating);
         }
      }
      
      public function clearInput() : void
      {
         this.input.textField.text = "";
      }
      
      public function get searchName() : String
      {
         return this.input.textField.text;
      }
      
      public function updateInputDef(pos:int) : void
      {
         var foundName:String = this.list.getNameAtPos(pos);
         var inputName:String = this.input.textField.text.slice(0,this.input.textField.selectionBeginIndex);
         Main.writeVarsToConsoleChannel("TOP MODEL","updateInputDef:: foundName = %1",foundName);
         for(var i:int = 0; i < foundName.length; i++)
         {
            if(foundName.charAt(i).toLowerCase() != inputName.charAt(i).toLowerCase())
            {
               break;
            }
         }
         this.input.textField.text = foundName;
         this.input.textField.setSelection(i,this.input.textField.length);
      }
   }
}
