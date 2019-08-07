package forms.garage
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.Diamond;
   import controls.BigButton;
   import controls.Label;
   import controls.Money;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GarageRenewalButton extends BigButton
   {
      
      private static const CURRENCY_LABEL:String = (Main.osgi.getService(ILocaleService) as ILocaleService).getText(TextConst.GARAGE_INFO_PANEL_RENEWAL_BUTTON_CURRENCY_LABEL);
       
      
      protected var bmp:BitmapData;
      
      public function GarageRenewalButton()
      {
         super();
      }
      
      public function setInfo(crystal:int = 0, cash:Number = 0) : void
      {
         var cont:Sprite = new Sprite();
         var price:Label = new Label();
         var c_price:Label = new Label();
         var diamond:Diamond = new Diamond();
         if(crystal == 0 && cash == 0)
         {
            this.bmp = new BitmapData(40,40,true,2164195328);
            this.icon = this.bmp;
         }
         else
         {
            crystal = crystal < 0?int(-crystal):int(crystal);
            cash = cash < 0?Number(-cash):Number(cash);
            if(crystal > 0)
            {
               c_price.text = Money.numToString(crystal,false);
               c_price.x = 0;
               c_price.y = 0;
               cont.addChild(diamond);
               cont.addChild(c_price);
               diamond.x = c_price.textWidth + 3;
               diamond.y = 4;
            }
            if(cash > 0)
            {
               price.text = "(" + (cash < 1?"< 1":"≈ " + Math.floor(crystal / 6) + CURRENCY_LABEL + ")");
               price.x = cont.width + 4;
               cont.addChild(price);
            }
            this.bmp = new BitmapData(cont.width,cont.height,true,0);
            this.bmp.draw(cont);
            this.icon = this.bmp;
         }
      }
      
      override public function set width(w:Number) : void
      {
         _width = int(w);
         stateDOWN.width = stateOFF.width = stateOVER.width = stateUP.width = _width;
         _info.width = _label.width = _width - 4;
         if(_icon.bitmapData != null)
         {
            _icon.x = _width - _icon.width >> 1;
            _icon.y = 25;
         }
      }
      
      override public function set icon(icoBMP:BitmapData) : void
      {
         if(icoBMP != null)
         {
            _icon.visible = true;
            _label.y = 8;
         }
         else
         {
            _label.width = _width - 4;
            _icon.visible = false;
            _label.y = 15;
         }
         _icon.bitmapData = icoBMP;
         this.width = _width;
      }
      
      override protected function onMouseEvent(event:MouseEvent) : void
      {
         if(_enable)
         {
            switch(event.type)
            {
               case MouseEvent.MOUSE_OVER:
                  setState(2);
                  break;
               case MouseEvent.MOUSE_OUT:
                  setState(1);
                  break;
               case MouseEvent.MOUSE_DOWN:
                  setState(3);
                  break;
               case MouseEvent.MOUSE_UP:
                  setState(1);
            }
            if(_icon.bitmapData != null)
            {
               _icon.y = 25 + (event.type == MouseEvent.MOUSE_DOWN?1:0);
               _label.y = 8 + (event.type == MouseEvent.MOUSE_DOWN?1:0);
            }
            else
            {
               _label.y = 15 + (event.type == MouseEvent.MOUSE_DOWN?1:0);
            }
         }
      }
   }
}
