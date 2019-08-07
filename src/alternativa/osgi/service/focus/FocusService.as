package alternativa.osgi.service.focus
{
   import alternativa.init.OSGi;
   import alternativa.osgi.service.console.IConsoleService;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   
   public class FocusService implements IFocusService
   {
       
      
      private var stage:Stage;
      
      private var mouseFocusChanged:Boolean = true;
      
      private var keyFocusChanged:Boolean = false;
      
      private var focusListeners:Array;
      
      private var _focused:Object;
      
      public function FocusService(_stage:Stage)
      {
         super();
         this.stage = _stage;
         if(_stage == null)
         {
            this.stage = Game.getInstance.stage;
         }
         this.focusListeners = new Array();
         this.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onMouseFocusChange);
         this.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onKeyFocusChange);
         this.stage.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this.stage.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         this.stage.addEventListener(Event.ACTIVATE,this.activate);
         this.stage.addEventListener(Event.DEACTIVATE,this.deactivate);
      }
      
      private function activate(e:Event) : void
      {
         var listener:IFocusListener = null;
         var consoleService:IConsoleService = OSGi.osgi.getService(IConsoleService) as IConsoleService;
         consoleService.writeToConsoleChannel("FOCUS","activate");
         for(var i:int = 0; i < this.focusListeners.length; i++)
         {
            listener = IFocusListener(this.focusListeners[i]);
            listener.activate();
         }
      }
      
      private function deactivate(e:Event) : void
      {
         var listener:IFocusListener = null;
         var consoleService:IConsoleService = OSGi.osgi.getService(IConsoleService) as IConsoleService;
         consoleService.writeToConsoleChannel("FOCUS","deactivate");
         for(var i:int = 0; i < this.focusListeners.length; i++)
         {
            listener = IFocusListener(this.focusListeners[i]);
            listener.deactivate();
         }
      }
      
      public function addFocusListener(listener:IFocusListener) : void
      {
         this.focusListeners.push(listener);
      }
      
      public function removeFocusListener(listener:IFocusListener) : void
      {
         this.focusListeners.splice(this.focusListeners.indexOf(listener),1);
      }
      
      public function getFocus() : Object
      {
         return this._focused;
      }
      
      public function clearFocus(object:DisplayObject) : void
      {
         if(this._focused == object)
         {
            this._focused = this.stage;
            this.stage.focus = this.stage;
         }
      }
      
      private function onFocusIn(e:FocusEvent) : void
      {
         var listener:IFocusListener = null;
         this._focused = e.target;
         for(var i:int = 0; i < this.focusListeners.length; i++)
         {
            listener = IFocusListener(this.focusListeners[i]);
            listener.focusIn(this._focused);
         }
      }
      
      private function onFocusOut(e:FocusEvent) : void
      {
         var listener:IFocusListener = null;
         this._focused = null;
         for(var i:int = 0; i < this.focusListeners.length; i++)
         {
            listener = IFocusListener(this.focusListeners[i]);
            listener.focusOut(e.currentTarget);
         }
      }
      
      private function onKeyFocusChange(e:FocusEvent) : void
      {
         this.keyFocusChanged = true;
      }
      
      private function onMouseFocusChange(e:FocusEvent) : void
      {
         this.mouseFocusChanged = true;
      }
   }
}
