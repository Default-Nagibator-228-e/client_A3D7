package forms.garage
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.Diamond;
   import controls.BigButton;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class GarageButton extends BigButton
   {
      
      private static const RANK_LABEL:String = (ILocaleService(Main.osgi.getService(ILocaleService)) as ILocaleService).getText(TextConst.GARAGE_BUY_BUTTON_RANK_LABEL);
       
      
      protected var bmp:BitmapData;
      
      public function GarageButton()
      {
         super();
      }
      
      public function setInfo(crystal:int = 0, rank:int = 0) : void
      {
         var cont:Sprite = new Sprite();
         var c_price:Label = new Label();
         var rangLabel:Label = new Label();
         var rangIcon:RangIconSmall = new RangIconSmall();
         var diamond:Diamond = new Diamond();
         if(crystal == 0 && rank >= 0)
         {
            //this.bmp = new BitmapData(40,20,true,2164195328);
            //this.icon = this.bmp;
			this.bmp = null;
			this.icon = null;
         }
         else
         {
            if(crystal < 0)
            {
               c_price.color = 16731648;
               c_price.sharpness = -100;
               c_price.thickness = 100;
            }
            if(rank < 0)
            {
               rangLabel.color = 16731648;
               rangLabel.sharpness = -100;
               rangLabel.thickness = 100;
            }
            else
            {
               rank = 0;
            }
            rangLabel.filters = c_price.filters = [new DropShadowFilter(1,45,0,0.7,1,1,1)];
            crystal = crystal < 0?int(-crystal):int(crystal);
            rank = rank < 0?int(-rank):int(rank);
            if(crystal > 0)
            {
               c_price.text = String(crystal);
               c_price.x = 0;
               c_price.y = 0;
               cont.addChild(diamond);
               cont.addChild(c_price);
               diamond.x = c_price.textWidth + 5;
               diamond.y = 4;
            }
            if(rank > 0)
            {
               rangIcon.rang = rank;
               cont.addChild(rangLabel);
               rangLabel.y = 0;
               rangLabel.x = cont.width + 4;
               rangLabel.text = RANK_LABEL;
               rangIcon.y = rangLabel.y + 3;
               rangIcon.x = cont.width - 1;
               cont.addChild(rangIcon);
            }
            cont.x = cont.x - (96 - cont.width);
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
