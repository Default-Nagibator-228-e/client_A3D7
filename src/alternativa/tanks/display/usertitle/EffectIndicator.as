package alternativa.tanks.display.usertitle
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.models.inventory.InventoryItemType;
   import alternativa.tanks.sfx.Blinker;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class EffectIndicator
   {
      
      private static const STATE_HIDDEN:int = 1;
      
      private static const STATE_PREPARED:int = 2;
      
      private static const STATE_VISIBLE:int = 4;
      
      private static const STATE_HIDING:int = 8;
      
      [Embed (source="assets/icon_health.png")] private static var iconHealthCls:Class;
		private static var iconHealth:BitmapData = new iconHealthCls().bitmapData;
		[Embed (source="assets/icon_armor.png")] private static var iconArmorCls:Class;
		private static var iconArmor:BitmapData = new iconArmorCls().bitmapData;
		[Embed (source="assets/icon_power.png")] private static var iconPowerCls:Class;
		private static var iconPower:BitmapData = new iconPowerCls().bitmapData;
		[Embed (source="assets/icon_nitro.png")] private static var iconNitroCls:Class;
		private static var iconNitro:BitmapData = new iconNitroCls().bitmapData;
      
      private static const MIN_ALPHA:Number = 0.2;
      
      private static var icons:Dictionary;
      
      private static var iconRect:Rectangle;
      
      private static var matrix:Matrix = new Matrix();
       
      
      private var _effectId:int;
      
      public var icon:BitmapData;
      
      private var blinkingTime:int;
      
      private var colorTransform:ColorTransform;
      
      private var blinkingStartTime:int;
      
      private var blinker:Blinker;
      
      private var alpha:Number = 1;
      
      private var needRedraw:Boolean;
      
      private var x:int;
      
      private var y:int;
      
      private var userTitle:UserTitle;
      
      private var state:int;
      
      private var blinking:Boolean;
      
      public function EffectIndicator(effectId:int, blinkingTime:int, userTitle:UserTitle, initialBlinkInterval:int, blinkIntervalDecrement:int)
      {
         this.colorTransform = new ColorTransform();
         super();
         if(icons == null)
         {
            initIcons();
         }
         this._effectId = effectId;
         this.icon = icons[effectId];
         this.blinkingTime = blinkingTime;
         this.userTitle = userTitle;
         this.blinker = new Blinker(initialBlinkInterval,20,blinkIntervalDecrement,MIN_ALPHA,1,10);
         this.state = STATE_HIDDEN;
      }
      
      private static function initIcons() : void
      {
         icons = new Dictionary();
         icons[InventoryItemType.FISRT_AID] = iconHealth;
         icons[InventoryItemType.ARMOR] = iconArmor;
         icons[InventoryItemType.POWER] = iconPower;
         icons[InventoryItemType.SPEED] = iconNitro;
         iconRect = BitmapData(icons[InventoryItemType.POWER]).rect;
      }
      
      public function get effectId() : int
      {
         return this._effectId;
      }
      
      public function isVisible() : Boolean
      {
         return (this.state & STATE_VISIBLE) != 0;
      }
      
      public function isHidden() : Boolean
      {
         return this.state == STATE_HIDDEN;
      }
      
      public function show(duration:int) : void
      {
         this.state = this.state & ~STATE_HIDING;
         if(this.state != STATE_VISIBLE || this.alpha != 1)
         {
            this.needRedraw = true;
         }
         this.blinkingStartTime = getTimer() + duration - this.blinkingTime;
         this.blinking = false;
         this.alpha = 1;
         if(this.state == STATE_HIDDEN)
         {
            this.state = STATE_PREPARED;
         }
      }
      
      public function hide() : void
      {
         if(this.state == STATE_PREPARED)
         {
            this.userTitle.doHideIndicator(this);
            this.state = STATE_HIDDEN;
            return;
         }
         if((this.state & (STATE_HIDDEN | STATE_HIDING)) != 0)
         {
            return;
         }
         this.state = this.state | STATE_HIDING;
         this.blinker.setMinValue(0);
         if(!this.blinking)
         {
            this.blinkingStartTime = 0;
            this.blinker.init(getTimer());
            this.blinking = true;
         }
      }
      
      public function clear(texture:BitmapData) : void
      {
         if(this.state == STATE_HIDDEN || this.state == STATE_PREPARED)
         {
            return;
         }
         iconRect.x = this.x;
         iconRect.y = this.y;
         texture.fillRect(iconRect,0);
      }
      
      public function setPosition(x:int, y:int) : void
      {
         this.x = x;
         this.y = y;
         this.needRedraw = true;
      }
      
      public function forceRedraw() : void
      {
         this.needRedraw = true;
      }
      
      public function update(now:int, delta:int, texture:BitmapData, sprite:TextureMaterial) : void
      {
         if(this.state == STATE_HIDDEN)
         {
            return;
         }
         if(this.needRedraw)
         {
            this.draw(texture,sprite);
            this.needRedraw = false;
         }
         if(now > this.blinkingStartTime)
         {
            this.updateBlinking(now,delta,texture,sprite);
         }
         if(this.state == STATE_PREPARED)
         {
            this.state = STATE_VISIBLE;
         }
      }
      
      private function updateBlinking(now:int, delta:int, texture:BitmapData, sprite:TextureMaterial) : void
      {
         var newAlpha:Number = NaN;
         if(this.blinking)
         {
            newAlpha = this.blinker.updateValue(now,delta);
            if(newAlpha != this.alpha)
            {
               this.alpha = newAlpha;
               this.draw(texture,sprite);
            }
            if((this.state & STATE_HIDING) != 0 && this.alpha == 0)
            {
               this.userTitle.doHideIndicator(this);
               this.state = STATE_HIDDEN;
            }
         }
         else
         {
            this.blinker.setMinValue(MIN_ALPHA);
            this.blinker.init(now);
            this.blinking = true;
         }
      }
      
      private function draw(texture:BitmapData, sprite:TextureMaterial) : void
      {
         this.clear(texture);
         matrix.tx = this.x;
         matrix.ty = this.y;
         this.colorTransform.alphaMultiplier = this.alpha;
         texture.draw(this.icon,matrix,this.colorTransform,null,null,true);
         sprite.texture = texture;
      }
   }
}
