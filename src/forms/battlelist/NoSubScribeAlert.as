package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.Label;
   import controls.statassets.BlackRoundRect;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class NoSubScribeAlert extends Sprite
   {
      [Embed(source="1.png")]
      private static const bitmapBezpripasov:Class;
      
      private static const bezpripasov:BitmapData = new bitmapBezpripasov().bitmapData;
       
      
      private var bg:BlackRoundRect;
      
      private var label:Label;
      
      private var prizBitmap:Bitmap;
      
      public function NoSubScribeAlert()
      {
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.bg = new BlackRoundRect();
         this.bg.height = 69;
         addChild(this.bg);
         this.prizBitmap = new Bitmap(bezpripasov);
         addChild(this.prizBitmap);
         this.prizBitmap.x = 12;
         this.prizBitmap.y = 3;
         this.label = new Label();
         this.label.text = localeService.getText(TextConst.BATTLE_CREATE_PANEL_LABEL_NO_SUBSCRIBE_BATTLE);
         this.label.x = 100;
         this.label.multiline = true;
         this.label.wordWrap = true;
         addChild(this.label);
      }
	  
	  public function ret(value:String) : void
      {
			this.label.text = value;
      }
      
      override public function set width(value:Number) : void
      {
         this.bg.width = value;
         this.label.width = value - 112;
         this.label.y = 70 - this.label.height >> 1;
      }
      
      override public function set height(value:Number) : void
      {
      }
   }
}
