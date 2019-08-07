package forms.upgrade
{
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.Label;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class UpgradeProgressForm extends Sprite
   {
      [Embed(source="2.png")]
      private static const leftProgressResource:Class;
	  [Embed(source="3.png")]
      private static const centerProgressResource:Class;
      
      public static var localeService:ILocaleService;
      
      private var progressBarBackground:TankWindowInner;
      
      private var progressBar:Bitmap;
      
      private var leftProgressPart:Bitmap;
      
      private var centerProgressPart:Bitmap;
      
      private var _width:Number;
	  
	  private var upgradeProgressValue:Label;
	  
	  public var lev:Number = 0;
      
      public function UpgradeProgressForm()
      {
         this.progressBar = new Bitmap();
         super();
         this._width = 400;
         this.progressBarBackground = new TankWindowInner(this._width,50,TankWindowInner.GREEN);
         addChild(this.progressBarBackground);
         this.progressBar.x = 1;
         this.progressBar.y = 1;
         this.progressBar.blendMode = BlendMode.OVERLAY;
         addChild(this.progressBar);
		 this.upgradeProgressValue = new Label();
		 this.upgradeProgressValue.x = 8;
         addChild(this.upgradeProgressValue);
         this.leftProgressPart = new Bitmap(new leftProgressResource().bitmapData);
         this.centerProgressPart = new Bitmap(new centerProgressResource().bitmapData);
      }
      
      public function update() : void
      {
         var _loc4_:Shape = null;
         var _loc5_:Graphics = null;
         var _loc6_:Matrix = null;
         var _loc1_:Number = this._width - 2;
         var _loc2_:int = Math.round(_loc1_ * this.lev / 10);
         if(_loc2_ == 0)
         {
            this.progressBar.visible = false;
         }
         else
         {
            this.progressBar.visible = true;
            this.progressBar.bitmapData = new BitmapData(_loc2_,this.leftProgressPart.height,true,0);
            if(_loc2_ > 0)
            {
               this.progressBar.bitmapData.draw(this.leftProgressPart);
            }
            if(_loc2_ > this.leftProgressPart.width)
            {
               this.centerProgressPart.width = Math.min(_loc2_ - this.leftProgressPart.width,_loc1_ - this.leftProgressPart.width * 2);
               _loc4_ = new Shape();
               _loc5_ = _loc4_.graphics;
               _loc5_.beginBitmapFill(this.centerProgressPart.bitmapData);
               _loc5_.drawRect(this.leftProgressPart.width,0,this.centerProgressPart.width,this.centerProgressPart.height);
               _loc5_.endFill();
               this.progressBar.bitmapData.draw(_loc4_);
            }
            if(_loc2_ == _loc1_)
            {
               _loc6_ = new Matrix(-1,0,0,1,_loc1_,0);
               this.progressBar.bitmapData.draw(this.leftProgressPart,_loc6_);
            }
         }
         var _loc3_:String = "Прогресс";
         this.upgradeProgressValue.text = _loc3_ + ":  " + this.lev + " / " + 10;
         this.upgradeProgressValue.y = 23 - (this.upgradeProgressValue.height >> 1);
         //this.align();
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = int(param1);
         this.progressBarBackground.width = param1;
         this.update();
      }
   }
}
