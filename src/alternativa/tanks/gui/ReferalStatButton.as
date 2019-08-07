package alternativa.tanks.gui
{
   import assets.Diamond;
   import controls.DefaultButton;
   import flash.events.MouseEvent;
   
   public class ReferalStatButton extends DefaultButton
   {
      
      private static var crystalIcon:Diamond = new Diamond();
       
      
      private var _numCrystals:int;
      
      private var _enable:Boolean = true;
      
      public function ReferalStatButton()
      {
         super();
         addChild(crystalIcon);
         crystalIcon.y = 10;
      }
      
      public function set numCrystals(value:int) : void
      {
         this._numCrystals = value;
      }
      
      override public function set width(w:Number) : void
      {
         super.width = int(w);
         stateDOWN.width = stateOFF.width = stateOVER.width = stateUP.width = this.width;
         _label.width = this.width - 4 - crystalIcon.width;
      }
      
      override public function get width() : Number
      {
         return super.width;
      }
      
      override public function set label(text:String) : void
      {
         super.label = text;
         crystalIcon.x = _label.textWidth + (_label.width - _label.textWidth) / 2 + 7;
      }
      
      override protected function onMouseEvent(event:MouseEvent) : void
      {
         if(this._enable)
         {
            switch(event.type)
            {
               case MouseEvent.MOUSE_OVER:
                  setState(2);
                  _label.y = 6;
                  crystalIcon.y = 10;
                  break;
               case MouseEvent.MOUSE_OUT:
                  setState(1);
                  _label.y = 6;
                  crystalIcon.y = 10;
                  break;
               case MouseEvent.MOUSE_DOWN:
                  setState(3);
                  _label.y = 7;
                  crystalIcon.y = 11;
                  break;
               case MouseEvent.MOUSE_UP:
                  setState(1);
                  _label.y = 6;
                  crystalIcon.y = 10;
            }
         }
      }
      
      override public function set enable(flag:Boolean) : void
      {
         this._enable = flag;
         if(this._enable)
         {
            addListeners();
         }
         else
         {
            removeListeners();
         }
      }
      
      override public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
