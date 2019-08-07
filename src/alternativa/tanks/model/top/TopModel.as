package alternativa.tanks.model.top
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.StatisticWindow;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.events.LoginFormEvent;
   import forms.events.StatListEvent;
   import utils.client.panel.model.ITopModelBase;
   import utils.client.panel.model.TopModelBase;
   import utils.client.panel.model.User;
   import utils.client.users.PropertyType;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   
   public class TopModel extends TopModelBase implements ITopModelBase, IObjectLoadListener
   {
       
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var statWindow:StatisticWindow;
      
      private var userPos:int;
      
      private var startPos:int;
      
      private var usersCount:int;
      
      private var topOrder:PropertyType;
      
      private var firstLoad:Boolean = true;
      
      private var lock:Boolean;
      
      private var updateAfterSearch:Boolean;
      
      private var searchTimer:Timer;
      
      private var inputPause:Timer;
      
      private var currentUserPos:int;
      
      public function TopModel()
      {
         this.searchTimer = new Timer(500);
         this.inputPause = new Timer(1000);
         super();
         _interfaces.push(IModel);
         _interfaces.push(ITopModelBase);
         _interfaces.push(IObjectLoadListener);
         this.layer = Main.contentUILayer;
         this.searchTimer.addEventListener(TimerEvent.TIMER,this.updateByTime);
         this.inputPause.addEventListener(TimerEvent.TIMER,this.beginSearch);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("TOP MODEL","objectLoaded");
         this.clientObject = object;
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("TOP MODEL","objectUnloaded");
         this.clientObject = null;
      }
      
      public function openTop(clientObject:ClientObject, usersCount:int) : void
      {
         var panelModel:IPanel = null;
         Main.writeVarsToConsoleChannel("TOP MODEL","openTop usersCount: " + usersCount);
         this.usersCount = usersCount;
         this.statWindow = new StatisticWindow();
         this.alignStatisticWindow();
         this.statWindow.setListLength(usersCount);
         this.statWindow.list.addEventListener(StatListEvent.UPDATE_STAT,this.updateList);
         this.statWindow.list.addEventListener(StatListEvent.UPDATE_SORT,this.updateSort);
         this.statWindow.addEventListener(LoginFormEvent.TEXT_CHANGED,this.searchByName);
         Main.stage.addEventListener(Event.RESIZE,this.alignStatisticWindow);
         this.topOrder = PropertyType.RATING;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         panelModel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
         var timer:Timer = new Timer(2500,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            (Main.osgi.getService(ILoader) as CheckLoader).setFullAndClose(null);
            layer.addChild(statWindow);
            panelModel.partSelected(2);
            PanelModel(Main.osgi.getService(IPanel)).unlock();
         });
         timer.start();
      }
      
      public function closeTop(clientObject:ClientObject) : void
      {
         if(this.layer.contains(this.statWindow))
         {
            this.statWindow.list.removeEventListener(StatListEvent.UPDATE_STAT,this.updateList);
            this.statWindow.list.removeEventListener(StatListEvent.UPDATE_SORT,this.updateSort);
            Main.stage.removeEventListener(Event.RESIZE,this.alignStatisticWindow);
            this.statWindow.removeEventListener(Event.CHANGE,this.searchByName);
            this.layer.removeChild(this.statWindow);
         }
      }
      
      private function updateList(e:StatListEvent) : void
      {
         if(this.firstLoad)
         {
            this.firstLoad = false;
         }
         else if(!this.lock)
         {
            this.lock = true;
            Main.writeVarsToConsoleChannel("TOP MODEL","updateList");
            Main.writeVarsToConsoleChannel("TOP MODEL","      e.beginPosition: %1",e.beginPosition);
            Main.writeVarsToConsoleChannel("TOP MODEL","      e.numRow: %1",e.numRow);
            this.startPos = e.beginPosition - 1;
            Main.writeVarsToConsoleChannel("TOP MODEL","      getTopData startPos: %1, count: %2",this.startPos,e.numRow - e.beginPosition + 1);
         }
      }
      
      private function updateSort(e:StatListEvent) : void
      {
         var newOrderType:PropertyType = null;
         Main.writeVarsToConsoleChannel("TOP MODEL","updateSort");
         switch(e.sortField)
         {
            case 1:
               newOrderType = PropertyType.RANK;
               break;
            case 2:
               newOrderType = PropertyType.CALLSIGN;
               break;
            case 3:
               newOrderType = PropertyType.SCORE;
               break;
            case 4:
               newOrderType = PropertyType.KILLS;
               break;
            case 5:
               newOrderType = PropertyType.DEATHS;
               break;
            case 6:
               newOrderType = PropertyType.RATIO;
               break;
            case 7:
               newOrderType = PropertyType.WEALTH;
               break;
            case 8:
               newOrderType = PropertyType.RATING;
         }
         if(this.topOrder != newOrderType)
         {
            this.topOrder = newOrderType;
            Main.writeVarsToConsoleChannel("TOP MODEL","      setTopOrder");
            this.setTopOrder(this.clientObject,this.topOrder);
         }
      }
      
      private function setTopOrder(clientObject:ClientObject, prder:PropertyType) : void
      {
      }
      
      public function setTopUserPos(clientObject:ClientObject, userPos:int) : void
      {
         Main.writeVarsToConsoleChannel("TOP MODEL","setTopUserPos: %1",userPos);
         this.userPos = userPos;
         this.currentUserPos = userPos;
         this.statWindow.scrollTo(userPos);
      }
      
      public function setTopData(clientObject:ClientObject, peoples:Array) : void
      {
         Main.writeVarsToConsoleChannel("TOP MODEL","setTopData");
         for(var i:int = 0; i < peoples.length; i++)
         {
            Main.writeVarsToConsoleChannel("TOP MODEL","           %1   %2",(peoples[i] as User).place,(peoples[i] as User).callsign);
            Main.writeVarsToConsoleChannel("TOP MODEL","           kills: %1   deaths: %2   ratio: %3\n",(peoples[i] as User).kills,(peoples[i] as User).deaths,(peoples[i] as User).ratio);
         }
         this.statWindow.setData(this.startPos,peoples);
         this.statWindow.updateInputDef(this.currentUserPos);
         this.lock = false;
         this.updateAfterSearch = false;
      }
      
      private function searchByName(e:Event) : void
      {
         this.inputPause.stop();
         this.inputPause.start();
      }
      
      private function alignStatisticWindow(e:Event = null) : void
      {
         var minWidth:int = int(Math.max(1000,Main.stage.stageWidth));
         this.statWindow.resize(Math.round(minWidth * 2 / 3),Math.max(Main.stage.stageHeight - 60,530));
         this.statWindow.x = Math.round(minWidth / 3);
         this.statWindow.y = 60;
      }
      
      private function updateByTime(e:TimerEvent) : void
      {
      }
      
      private function beginSearch(e:TimerEvent) : void
      {
         this.updateAfterSearch = true;
         this.searchTimer.stop();
         this.searchTimer.start();
         this.inputPause.stop();
      }
   }
}
