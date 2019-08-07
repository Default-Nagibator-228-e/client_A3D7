package alternativa.tanks.models.tank
{
   import flash.utils.Dictionary;
   
   public class TankEventDispatcher implements ITankEventDispatcher
   {
       
      
      private var processingEvent:Boolean;
      
      private var eventListeners:Dictionary;
      
      private var addedListeners:Dictionary;
      
      private var removedListeners:Dictionary;
      
      public function TankEventDispatcher()
      {
         this.eventListeners = new Dictionary();
         this.addedListeners = new Dictionary();
         this.removedListeners = new Dictionary();
         super();
      }
      
      public function addTankEventListener(eventType:int, listener:ITankEventListener) : void
      {
         if(this.processingEvent)
         {
            this.removeListener(this.removedListeners,eventType,listener);
            this.addListener(this.addedListeners,eventType,listener);
         }
         else
         {
            this.addListener(this.eventListeners,eventType,listener);
         }
      }
      
      public function removeTankEventListener(eventType:int, listener:ITankEventListener) : void
      {
         if(this.processingEvent)
         {
            this.removeListener(this.addedListeners,eventType,listener);
            this.addListener(this.removedListeners,eventType,listener);
         }
         else
         {
            this.removeListener(this.eventListeners,eventType,listener);
         }
      }
      
      public function dispatchEvent(eventType:int, tankData:TankData) : void
      {
         var len:int = 0;
         var i:int = 0;
         this.processingEvent = true;
         var listeners:Vector.<ITankEventListener> = this.eventListeners[eventType];
         if(listeners != null)
         {
            len = listeners.length;
            for(i = 0; i < len; i++)
            {
               ITankEventListener(listeners[i]).handleTankEvent(eventType,tankData);
            }
         }
         this.processingEvent = false;
         this.processDeferredActions();
      }
      
      private function addListener(storage:Dictionary, eventType:int, listener:ITankEventListener) : void
      {
         var idx:int = 0;
         var listeners:Vector.<ITankEventListener> = storage[eventType];
         if(listeners == null)
         {
            listeners = new Vector.<ITankEventListener>();
            storage[eventType] = listeners;
         }
         else
         {
            idx = listeners.indexOf(listener);
            if(idx > -1)
            {
               return;
            }
         }
         listeners.push(listener);
      }
      
      private function removeListener(storage:Dictionary, eventType:int, listener:ITankEventListener) : void
      {
         var listeners:Vector.<ITankEventListener> = storage[eventType];
         if(listeners == null)
         {
            return;
         }
         var idx:int = listeners.indexOf(listener);
         if(idx < 0)
         {
            return;
         }
         if(listeners.length == 1)
         {
            delete storage[eventType];
         }
         else
         {
            listeners.splice(idx,1);
         }
      }
      
      private function processDeferredActions() : void
      {
         var key:* = undefined;
         var i:int = 0;
         var len:int = 0;
         var eventType:* = 0;
         var listeners:Vector.<ITankEventListener> = null;
         for(eventType in this.removedListeners)
         {
            listeners = this.removedListeners[key];
            delete this.removedListeners[key];
            len = listeners.length;
            for(i = 0; i < len; i++)
            {
               this.removeListener(this.eventListeners,eventType,listeners[i]);
            }
         }
         for(eventType in this.addedListeners)
         {
            listeners = this.addedListeners[key];
            delete this.addedListeners[key];
            len = listeners.length;
            for(i = 0; i < len; i++)
            {
               this.addListener(this.eventListeners,eventType,listeners[i]);
            }
         }
      }
   }
}
