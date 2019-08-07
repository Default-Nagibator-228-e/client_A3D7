package controls.statassets
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.events.StatListEvent;
   
   public class StatHeader extends Sprite
   {
       
      
      protected var tabs:Array;
      
      protected var headers:Array;
      
      protected var _currentSort:int = 8;
      
      protected var _oldSort:int = 8;
      
      protected var _width:int = 800;
      
      public function StatHeader()
      {
         var cell:StatHeaderButton = null;
         this.tabs = new Array();
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.headers = [localeService.getText(TextConst.STATISTICS_HEADER_NUMBER),localeService.getText(TextConst.STATISTICS_HEADER_RANK),localeService.getText(TextConst.STATISTICS_HEADER_CALLSIGN),localeService.getText(TextConst.STATISTICS_HEADER_SCORE),localeService.getText(TextConst.STATISTICS_HEADER_KILLS),localeService.getText(TextConst.STATISTICS_HEADER_DEATHS),localeService.getText(TextConst.STATISTICS_HEADER_RATIO),localeService.getText(TextConst.STATISTICS_HEADER_WEALTH),localeService.getText(TextConst.STATISTICS_HEADER_RATING)];
         for(var i:int = 0; i < 9; i++)
         {
            cell = new StatHeaderButton(i < 1 || i > 2);
            cell.label = this.headers[i];
            cell.height = 18;
            cell.numSort = i;
            addChild(cell);
            if(i > 0)
            {
               cell.addEventListener(MouseEvent.CLICK,this.changeSort);
            }
         }
         this.draw();
      }
      
      override public function set width(w:Number) : void
      {
         this._width = Math.floor(w);
         this.draw();
      }
      
      protected function draw() : void
      {
         var cell:StatHeaderButton = null;
         var i:int = 0;
         var infoX:int = int(this._width - 365);
         this.tabs = [0,55,180,infoX,infoX + 60,infoX + 130,infoX + 180,infoX + 220,infoX + 285,this._width - 1];
         for(i = 0; i < 9; i++)
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
   }
}
