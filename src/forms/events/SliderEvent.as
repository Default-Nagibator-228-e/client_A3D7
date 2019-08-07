package forms.events
{
   import flash.events.Event;
   
   public class SliderEvent extends Event
   {
      
      public static const CHANGE_VALUE:String = "SliderChangeValue";
       
      
      public var currentValue:Number;
      
      public function SliderEvent(value:Number)
      {
         this.currentValue = value;
         super(CHANGE_VALUE,true,false);
      }
   }
}
