package controls
{
   import controls.slider.SliderThumb;
   import controls.slider.SliderTrack;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import forms.events.SliderEvent;
   
   public class Slider extends Sprite
   {
       
      
      protected var track:SliderTrack;
      
      protected var thumb:SliderThumb;
      
      protected var _thumb_width:int = 30;
      
      protected var curThumbX:int;
      
      protected var trgt:Sprite;
      
      public var _width:int;
      
      protected var _minValue:Number = 0;
      
      protected var _maxValue:Number = 100;
      
      protected var _value:Number = 0;
      
      protected var _tick:Number = 10;
      
      public function Slider()
      {
         this.track = new SliderTrack();
         this.thumb = new SliderThumb();
         super();
         addChild(this.track);
         addChild(this.thumb);
         this.thumb.width = this._thumb_width;
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addEventListener(Event.REMOVED_FROM_STAGE,this.UnConfigUI);
      }
      
      protected function UnConfigUI(e:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragThumb);
      }
      
      protected function ConfigUI(e:Event) : void
      {
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      protected function onMouseDown(e:MouseEvent) : void
      {
         this.trgt = Sprite(e.currentTarget);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragThumb);
         this.curThumbX = this.trgt.mouseX;
      }
      
      protected function onMouseUp(e:MouseEvent) : void
      {
         if(e != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragThumb);
         }
         this.trgt = null;
      }
      
      protected function dragThumb(e:MouseEvent) : void
      {
         var val:Number = NaN;
         this.thumb.x = this.thumb.x + (this.thumb.mouseX - this.curThumbX);
         if(this.thumb.x < 0)
         {
            this.thumb.x = 0;
         }
         if(this.thumb.x > this._width - this._thumb_width)
         {
            this.thumb.x = this._width - this._thumb_width;
         }
         val = this._minValue + this.thumb.x * (this._maxValue - this._minValue) / (width - this._thumb_width);
         this._value = val;
         dispatchEvent(new SliderEvent(val));
      }
      
      override public function set width(w:Number) : void
      {
         this._width = int(w);
         this.track.width = this._width;
      }
      
      public function get minValue() : Number
      {
         return this._minValue;
      }
      
      public function set minValue(minValue:Number) : void
      {
         this._minValue = minValue;
         this.track.minValue = this._minValue;
      }
      
      public function get maxValue() : Number
      {
         return this._maxValue;
      }
      
      public function set maxValue(maxValue:Number) : void
      {
         this._maxValue = maxValue;
         this.track.maxValue = this._maxValue;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(value:Number) : void
      {
         this._value = value;
         this.setThumb();
      }
      
      public function get tickInterval() : Number
      {
         return this._tick;
      }
      
      public function set tickInterval(tick:Number) : void
      {
         this._tick = tick;
         this.track.tickInterval = this._tick;
      }
      
      protected function setThumb() : void
      {
         this.thumb.x = int((this._value - this._minValue) * (this._width - this._thumb_width) / (this._maxValue - this._minValue));
      }
   }
}
