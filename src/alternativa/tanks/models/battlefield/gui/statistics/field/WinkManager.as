package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class WinkManager
   {
      
      private static var _instance:WinkManager;
       
      
      private var timer:Timer;
      
      private var fields:Dictionary;
      
      private var numFields:int;
      
      private var visible:Boolean;
      
      public function WinkManager(interval:int)
      {
         super();
         this.fields = new Dictionary();
         this.timer = new Timer(interval);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public static function init(interval:int) : void
      {
         if(_instance == null)
         {
            _instance = new WinkManager(interval);
         }
      }
      
      public static function get instance() : WinkManager
      {
         return _instance;
      }
      
      public function addField(field:WinkingField) : void
      {
         if(this.fields[field] != null)
         {
            return;
         }
         this.fields[field] = field;
         this.numFields++;
         if(this.numFields == 1)
         {
            this.timer.start();
         }
      }
      
      public function removeField(field:WinkingField) : void
      {
         if(this.fields[field] == null)
         {
            return;
         }
         delete this.fields[field];
         this.numFields--;
         if(this.numFields == 0)
         {
            this.timer.stop();
            this.visible = true;
         }
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         var field:WinkingField = null;
         if(this.numFields == 0)
         {
            return;
         }
         this.visible = !this.visible;
         for each(field in this.fields)
         {
            field.textVisible = this.visible;
         }
      }
   }
}
