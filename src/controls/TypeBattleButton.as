package controls
{
   import flash.events.MouseEvent;
   
   public class TypeBattleButton extends BigButton
   {
       
      
      public function TypeBattleButton()
      {
         super();
         _label.multiline = true;
         _label.wordWrap = true;
         _label.height = 45;
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         setState(3);
         _label.y = int(25 - _label.textHeight / 2) + 1;
         _info.y = 25;
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         _label.y = int(25 - _label.textHeight / 2);
         _info.y = 24;
      }
      
      override protected function onMouseEvent(event:MouseEvent) : void
      {
         if(_enable)
         {
            switch(event.type)
            {
               case MouseEvent.MOUSE_OVER:
                  setState(2);
                  _label.y = int(25 - _label.textHeight / 2);
                  _info.y = 24;
                  break;
               case MouseEvent.MOUSE_OUT:
                  setState(1);
                  _label.y = int(25 - _label.textHeight / 2);
                  _info.y = 24;
                  break;
               case MouseEvent.MOUSE_DOWN:
                  setState(3);
                  _label.y = int(25 - _label.textHeight / 2) + 1;
                  _info.y = 25;
                  break;
               case MouseEvent.MOUSE_UP:
                  setState(1);
                  _label.y = int(25 - _label.textHeight / 2);
                  _info.y = 24;
            }
            if(_icon != null)
            {
               _icon.y = int(25 - _icon.height / 2) + (event.type == MouseEvent.MOUSE_DOWN?1:0);
            }
         }
      }
   }
}
