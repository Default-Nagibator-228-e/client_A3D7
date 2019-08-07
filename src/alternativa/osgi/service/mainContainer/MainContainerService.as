package alternativa.osgi.service.mainContainer
{
   import alternativa.init.OSGi;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.focus.IFocusListener;
   import alternativa.osgi.service.focus.IFocusService;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class MainContainerService implements IMainContainerService, IFocusListener
   {
       
      
      private var _stage:Stage;
      
      private var mainContainerParentSprite:DisplayObjectContainer;
      
      private var _mainContainer:DisplayObjectContainer;
      
      private var _backgroundLayer:DisplayObjectContainer;
      
      private var _contentLayer:DisplayObjectContainer;
      
      private var _contentUILayer:DisplayObjectContainer;
      
      private var _systemLayer:DisplayObjectContainer;
      
      private var _systemUILayer:DisplayObjectContainer;
      
      private var _dialogsLayer:DisplayObjectContainer;
      
      private var _noticesLayer:DisplayObjectContainer;
      
      private var _cursorLayer:DisplayObjectContainer;
      
      private var haltDelay:int = 1000;
      
      private var haltDelayTimer:Timer;
      
      private var haltAnimTimer:Timer;
      
      private var screenShotContainer:Sprite;
      
      private var screenShot:Bitmap;
      
      public function MainContainerService(s:Stage, container:DisplayObjectContainer)
      {
         super();
         this._stage = s;
         this._mainContainer = container;
         this.mainContainerParentSprite = this._mainContainer.parent;
         this._backgroundLayer = this.addLayerSprite();
         this._contentLayer = this.addLayerSprite();
         this._contentUILayer = this.addLayerSprite();
         this._systemLayer = this.addLayerSprite();
         this._systemUILayer = this.addLayerSprite();
         this._dialogsLayer = this.addLayerSprite();
         this._noticesLayer = this.addLayerSprite();
         this._cursorLayer = this.addLayerSprite();
         (OSGi.osgi.getService(IFocusService) as IFocusService).addFocusListener(this);
         this.haltDelayTimer = new Timer(this.haltDelay,1);
         this.haltDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.startHaltAnim);
         this.haltAnimTimer = new Timer(100,10);
         this.haltAnimTimer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.haltAnimTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      }
      
      private function addLayerSprite() : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.mouseEnabled = true;
         sprite.tabEnabled = true;
         sprite.focusRect = false;
         this.mainContainer.addChild(sprite);
         return sprite;
      }
      
      public function focusIn(focusedObject:Object) : void
      {
      }
      
      public function focusOut(exfocusedObject:Object) : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function activate() : void
      {
      }
      
      private function startHaltAnim(e:TimerEvent) : void
      {
         this.haltDelayTimer.stop();
         var bd:BitmapData = new BitmapData(this._stage.stageWidth,this._stage.stageHeight,false,2829082);
         bd.draw(this._stage);
         this.screenShotContainer = new Sprite();
         this.screenShotContainer.mouseEnabled = true;
         this.screenShotContainer.tabEnabled = true;
         this.mainContainerParentSprite.addChild(this.screenShotContainer);
         this.screenShot = new Bitmap(bd);
         this.screenShotContainer.addChild(this.screenShot);
         this.haltAnimTimer.reset();
         this.haltAnimTimer.start();
      }
      
      private function onTimerTick(e:TimerEvent) : void
      {
         var consoleService:IConsoleService = OSGi.osgi.getService(IConsoleService) as IConsoleService;
         consoleService.writeToConsoleChannel("OSGI","MainContainerService onTimerTick");
         var k:Number = 1 - 0.6 * (this.haltAnimTimer.currentCount / this.haltAnimTimer.repeatCount);
         this.screenShotContainer.transform.colorTransform = new ColorTransform(k,k,k,1);
      }
      
      private function onTimerComplete(e:TimerEvent) : void
      {
         this.haltAnimTimer.stop();
         this._stage.frameRate = 0.1;
         var consoleService:IConsoleService = OSGi.osgi.getService(IConsoleService) as IConsoleService;
         consoleService.writeToConsoleChannel("OSGI","MainContainerService onTimerComplete");
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function get mainContainer() : DisplayObjectContainer
      {
         return this._mainContainer;
      }
      
      public function get backgroundLayer() : DisplayObjectContainer
      {
         return this._backgroundLayer;
      }
      
      public function get contentLayer() : DisplayObjectContainer
      {
         return this._contentLayer;
      }
      
      public function get contentUILayer() : DisplayObjectContainer
      {
         return this._contentUILayer;
      }
      
      public function get systemLayer() : DisplayObjectContainer
      {
         return this._systemLayer;
      }
      
      public function get systemUILayer() : DisplayObjectContainer
      {
         return this._systemUILayer;
      }
      
      public function get dialogsLayer() : DisplayObjectContainer
      {
         return this._dialogsLayer;
      }
      
      public function get noticesLayer() : DisplayObjectContainer
      {
         return this._noticesLayer;
      }
      
      public function get cursorLayer() : DisplayObjectContainer
      {
         return this._cursorLayer;
      }
   }
}
