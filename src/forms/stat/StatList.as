package forms.stat
{
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.statassets.StatHeader;
   import controls.statassets.StatLineBackgroundNormal;
   import controls.statassets.StatLineBackgroundSelected;
   import controls.statassets.StatLineBase;
   import controls.statassets.StatLineNormal;
   import controls.statassets.StatLineNormalActive;
   import controls.statassets.StatLineSelected;
   import controls.statassets.StatLineSelectedActive;
   import fl.controls.List;
   import fl.data.DataProvider;
   import fl.events.ScrollEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.events.StatListEvent;
   
   public class StatList extends Sprite
   {
       
      
      protected var list:List;
      
      protected var header:StatHeader;
      
      protected var dp:DataProvider;
      
      protected var currentSort:int = 8;
      
      protected var nr:DisplayObject;
      
      protected var sl:DisplayObject;
      
      protected var timer:Timer = null;
      
      protected var _width:int = 100;
      
      private var _height:int = 100;
      
      public function StatList()
      {
         this.list = new List();
         this.header = new StatHeader();
         this.dp = new DataProvider();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
      }
      
      public static function setBackground(_width:int, currentSort:int, _selected:Boolean) : BitmapData
      {
         var cell:StatLineBase = null;
         var i:int = 0;
         var cont:Sprite = new Sprite();
         var infoX:int = int(_width - 365);
         var cells:Array = [0,55,180,infoX,infoX + 60,infoX + 130,infoX + 180,infoX + 220,infoX + 285,_width - 1];
         i = 0;
         var data:BitmapData = new BitmapData(_width,20,true,0);
         for(i = 0; i < 9; i++)
         {
            if(currentSort == i)
            {
               if(_selected)
               {
                  cell = new StatLineSelectedActive();
               }
               else
               {
                  cell = new StatLineNormalActive();
               }
            }
            else if(_selected)
            {
               cell = new StatLineSelected();
            }
            else
            {
               cell = new StatLineNormal();
            }
            cell.width = cells[i + 1] - cells[i] - 2;
            cell.height = 18;
            cell.x = cells[i];
            cont.addChild(cell);
         }
         data.draw(cont);
         return data;
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.list.width = this._width;
         this.header.width = this._width - 15;
         StatLineBackgroundNormal.bg = new Bitmap(setBackground(this._width - 15,this.currentSort,false));
         StatLineBackgroundSelected.bg = new Bitmap(setBackground(this._width - 15,this.currentSort,true));
         this.dp.invalidate();
         this.updateScreen(null);
      }
      
      override public function set height(value:Number) : void
      {
         this._height = int(value);
         this.list.height = this._height - 20;
         this.updateScreen(null);
      }
      
      protected function ConfigUI(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         this.list.rowHeight = 20;
         this.list.setStyle("cellRenderer",StatListRenderer);
         this.list.dataProvider = this.dp;
         this.confSkin();
         addChild(this.header);
         addChild(this.list);
         this.list.y = 20;
         this.list.addEventListener(ScrollEvent.SCROLL,this.onScroll);
         this.header.addEventListener(StatListEvent.UPDATE_SORT,this.changeSort);
      }
      
      public function select(index:int) : void
      {
         var scrPos:int = 0;
         var begin:int = 1;
         var num:int = int(this._height / 20);
         if(this.list.verticalScrollPosition > 0)
         {
            begin = int(this.list.verticalScrollPosition / 20 - 0.5);
            begin = begin == 0?int(1):int(begin);
         }
         var end:int = Math.min(begin + num,this.dp.length - 1);
         this.list.selectedIndex = index;
         scrPos = index < num / 2?int(0):int(int((index - num / 2) * 20));
         this.list.verticalScrollPosition = scrPos;
         dispatchEvent(new StatListEvent(StatListEvent.UPDATE_STAT,begin,end));
      }
      
      protected function changeSort(e:StatListEvent) : void
      {
         this.currentSort = e.sortField;
         this.clear();
         this.width = this._width;
      }
      
      protected function onScroll(e:ScrollEvent) : void
      {
         var i:int = 0;
         var end:int = 0;
         var begin:int = 1;
         var num:int = int(this._height / 20);
         if(this.list.verticalScrollPosition > 0)
         {
            begin = int(this.list.verticalScrollPosition / 20 - 0.5);
            begin = begin == 0?int(1):int(begin);
         }
         end = Math.min(begin + num,this.dp.length - 1);
         for(i = begin; i <= end; )
         {
            if(this.list.getItemAt(i).callsign != "")
            {
               begin = i;
               i++;
               continue;
            }
            break;
         }
         num = begin;
         for(i = begin + 1; i <= end; i++)
         {
            if(this.list.getItemAt(i).callsign == "" && e != null)
            {
               num = i + 2;
            }
         }
         if(num > begin)
         {
            dispatchEvent(new StatListEvent(StatListEvent.UPDATE_STAT,begin,num));
         }
         if(this.timer == null)
         {
            this.timer = new Timer(500,1);
            this.timer.addEventListener(TimerEvent.TIMER,this.updateScreen);
            this.timer.start();
         }
         else
         {
            this.timer.stop();
            this.timer.start();
         }
      }
      
      private function updateScreen(e:TimerEvent) : void
      {
         var begin:int = 1;
         var num:int = int(this._height / 20);
         if(this.list.verticalScrollPosition > 0)
         {
            begin = int(this.list.verticalScrollPosition / 20 - 0.5);
            begin = begin == 0?int(1):int(begin);
         }
         var end:int = Math.min(begin + num,this.dp.length - 1);
         dispatchEvent(new StatListEvent(StatListEvent.UPDATE_STAT,begin,end));
      }
      
      public function clear() : void
      {
         var item:Object = new Object();
         for(var i:int = 0; i < this.dp.length; i++)
         {
            item.pos = -1;
            item.rank = -1;
            item.callsign = " ";
            item.score = -1;
            item.kills = -1;
            item.deaths = -1;
            item.ratio = -11;
            item.wealth = -1;
            item.rating = -1;
            item.sort = this.currentSort;
            this.dp.replaceItemAt(item,i);
            this.dp.invalidateItemAt(i);
         }
      }
      
      public function addItem(pos:int, rank:int = 0, callsign:String = "", score:int = 0, kills:int = 0, deaths:int = 0, ratio:Number = 0, wealth:int = 0, rating:Number = 0, sort:int = 4) : void
      {
         var item:Object = new Object();
         item.pos = pos;
         item.rank = rank;
         item.callsign = callsign;
         item.score = score;
         item.kills = String(kills);
         item.deaths = String(deaths);
         item.ratio = ratio;
         item.wealth = wealth;
         item.rating = rating;
         item.sort = sort;
         if(this.dp.length < pos)
         {
            this.dp.addItem(item);
         }
         else
         {
            this.dp.replaceItemAt(item,pos - 1);
            this.dp.invalidateItemAt(pos - 1);
         }
      }
      
      public function getNameAtPos(pos:int) : String
      {
         return (this.dp.getItemAt(pos) as Object).callsign;
      }
      
      protected function confSkin() : void
      {
         this.list.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.list.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.list.setStyle("trackUpSkin",ScrollTrackGreen);
         this.list.setStyle("trackDownSkin",ScrollTrackGreen);
         this.list.setStyle("trackOverSkin",ScrollTrackGreen);
         this.list.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.list.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
   }
}
