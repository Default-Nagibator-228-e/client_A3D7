package controls.statassets
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.events.StatListEvent;
   
   public class ReferralStatHeader extends Sprite
   {
       
      
      protected var tabs:Array;
      
      protected var headers:Array;
      
      protected var _currentSort:int = 1;
      
      protected var _oldSort:int = 1;
      
      protected var _width:int = 800;
      
      public function ReferralStatHeader()
      {
         var cell:StatHeaderButton = null;
         this.tabs = new Array();
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.headers = [localeService.getText(TextConst.REFERAL_STATISTICS_HEADER_CALLSIGN),localeService.getText(TextConst.REFERAL_STATISTICS_HEADER_INCOME)];
         for(var i:int = 0; i < 2; i++)
         {
            cell = new StatHeaderButton(i == 1);
            cell.label = this.headers[i];
            cell.height = 18;
            cell.numSort = i;
            addChild(cell);
            cell.addEventListener(MouseEvent.CLICK,this.changeSort);
         }
         this.draw();
      }
      
      protected function draw() : void
      {
         var cell:StatHeaderButton = null;
         var infoX:int = int(this._width - 345);
         this.tabs = [0,this._width - 120,this._width - 1];
         for(var i:int = 0; i < 2; i++)
         {
            cell = getChildAt(i) as StatHeaderButton;
            cell.width = this.tabs[i + 1] - this.tabs[i] - 2;
            cell.x = this.tabs[i];
            cell.selected = i == this._currentSort;
         }
      }
      
      protected function changeSort(e:MouseEvent) : void
      {
         var trgt:StatHeaderButton = e.currentTarget as StatHeaderButton;
         this._currentSort = trgt.numSort;
         if(this._currentSort != this._oldSort)
         {
            this.draw();
            dispatchEvent(new StatListEvent(StatListEvent.UPDATE_SORT,0,0,this._currentSort));
            this._oldSort = this._currentSort;
         }
      }
      
      override public function set width(w:Number) : void
      {
         this._width = Math.floor(w);
         this.draw();
      }
   }
}
