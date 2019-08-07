package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import flash.events.Event;
   
   public class WinkingField extends IconField
   {
       
      
      protected var _value:int;
      
      protected var winkLimit:int;
      
      private var winkManager:WinkManager;
      
      public function WinkingField(winkLimit:int, iconType:int, winkManager:WinkManager)
      {
         super(iconType);
         this.winkLimit = winkLimit;
         this.winkManager = winkManager;
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function set value(value:int) : void
      {
         this._value = value;
         this.updateLabel();
         if(this._value <= this.winkLimit)
         {
            this.startWink();
         }
         else
         {
            this.stopWink();
         }
      }
      
      public function startWink() : void
      {
         if(this.winkManager != null)
         {
            this.winkManager.addField(this);
         }
      }
      
      public function stopWink() : void
      {
         if(this.winkManager != null)
         {
            this.winkManager.removeField(this);
         }
         label.visible = true;
      }
      
      public function get textVisible() : Boolean
      {
         return label.visible;
      }
      
      public function set textVisible(value:Boolean) : void
      {
         label.visible = value;
      }
      
      protected function updateLabel() : void
      {
         text = this._value.toString();
      }
      
      protected function onRemovedFromStage(e:Event) : void
      {
         this.stopWink();
      }
   }
}
