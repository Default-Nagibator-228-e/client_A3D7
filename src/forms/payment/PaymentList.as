package forms.payment
{
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.statassets.StatLineBackgroundNormal;
   import controls.statassets.StatLineBackgroundSelected;
   import controls.statassets.StatLineNormal;
   import fl.controls.List;
   import fl.data.DataProvider;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Timer;
   
   public class PaymentList extends Sprite
   {
      
      private static var _withSMSText:Boolean = false;
       
      
      private var list:List;
      
      private var header:PaymentListHeader;
      
      private var dp:DataProvider;
      
      private var nr:DisplayObject;
      
      private var sl:DisplayObject;
      
      private var timer:Timer = null;
      
      private var _width:int = 100;
      
      private var _height:int = 100;
      
      public function PaymentList()
      {
         this.list = new List();
         this.header = new PaymentListHeader();
         this.dp = new DataProvider();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
      }
      
      public static function setBackground(_width:int) : BitmapData
      {
         var data:BitmapData = null;
         var cont:Sprite = new Sprite();
         var number:StatLineNormal = new StatLineNormal();
         var smsText:StatLineNormal = new StatLineNormal();
         var cost:StatLineNormal = new StatLineNormal();
         var crystals:StatLineNormal = new StatLineNormal();
         data = new BitmapData(_width > 0?int(_width):int(1),23,true,0);
         var subwidth:int = !!_withSMSText?int(60):int((_width - 70) / 2);
         number.height = smsText.height = cost.height = crystals.height = 21;
         cont.addChild(number);
         cont.addChild(cost);
         cont.addChild(crystals);
         number.width = 70;
         cost.x = 72;
         if(_withSMSText)
         {
            cont.addChild(smsText);
            smsText.x = 72;
            smsText.width = _width - 170;
            cost.x = 74 + smsText.width;
         }
         cost.width = subwidth;
         crystals.x = cost.x + cost.width + 2;
         crystals.width = int(_width - crystals.x - 3);
         data.draw(cont);
         return data;
      }
      
      public function set withSMSText(value:Boolean) : void
      {
         _withSMSText = value;
         this.header.withSMSText = value;
         this.dp.invalidate();
      }
      
      public function addItem(number:int, cost:Number, currency:String, crystals:int, smsText:String = "") : void
      {
         var item:Object = new Object();
         item.number = String(number);
         item.cost = String(cost) + " " + currency;
         item.crystals = String(crystals);
         item.smsText = smsText;
         this.dp.addItem(item);
         this.header.width = this.list.maxVerticalScrollPosition > 0?Number(this._width - 15):Number(this._width);
         StatLineBackgroundNormal.bg = new Bitmap(setBackground(this.list.maxVerticalScrollPosition > 0?int(this._width - 15):int(this._width)));
         StatLineBackgroundSelected.bg = new Bitmap(setBackground(this.list.maxVerticalScrollPosition > 0?int(this._width - 15):int(this._width)));
         this.dp.invalidate();
      }
      
      public function clear() : void
      {
         var item:Object = new Object();
         this.dp.removeAll();
      }
      
      private function ConfigUI(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         this.list.rowHeight = 22;
         this.list.setStyle("cellRenderer",PaymentListRenderer);
         this.list.dataProvider = this.dp;
         this.confSkin();
         addChild(this.header);
         addChild(this.list);
         this.list.y = 20;
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
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.list.width = this._width;
         this.header.width = this.list.maxVerticalScrollPosition > 0?Number(this._width - 15):Number(this._width);
         StatLineBackgroundNormal.bg = new Bitmap(setBackground(this.list.maxVerticalScrollPosition > 0?int(this._width - 15):int(this._width)));
         StatLineBackgroundSelected.bg = new Bitmap(setBackground(this.list.maxVerticalScrollPosition > 0?int(this._width - 15):int(this._width)));
         this.dp.invalidate();
      }
      
      override public function set height(value:Number) : void
      {
         this._height = int(value);
         this.list.height = this._height - 20;
      }
   }
}
