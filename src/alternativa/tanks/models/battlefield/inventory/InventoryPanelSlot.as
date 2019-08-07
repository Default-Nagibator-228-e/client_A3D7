package alternativa.tanks.models.battlefield.inventory
{
   import alternativa.tanks.models.inventory.InventoryLock;
   import controls.InventoryIcon;
   import controls.Label;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class InventoryPanelSlot
   {
      
      private static const FONT_SIZE:int = 10;
      
      private static const FLASH_SHOW:int = 1;
      
      private static const FLASH_FADE:int = 2;
      
      private static const FLASH_DONE:int = 3;
       
      
      private var slotNumber:int;
      
      private var slotNumberLabel:Label;
      
      private var item:InventoryItem;
      
      private var canvas:DisplayObjectContainer;
      
      private var cooldownMask:CooldownIndicator;
      
      private var quantityLabel:Label;
      
      private var lockBits:int;
      
      private var emptyIcon:InventoryIcon;
      
      private var flashState:int = 3;
      
      private var colorTransform:ColorTransform;
      
      private var flashStartTime:int;
      
      private var prevItemReadiness:Number = 1;
      
      public function InventoryPanelSlot(slotNumber:int)
      {
         this.emptyIcon = new InventoryIcon(InventoryIcon.EMPTY);
         this.colorTransform = new ColorTransform();
         super();
         this.slotNumber = slotNumber;
         this.canvas = new Sprite();
         this.canvas.addChild(this.emptyIcon);
         this.slotNumberLabel = new Label();
         this.slotNumberLabel.size = FONT_SIZE;
         this.slotNumberLabel.text = slotNumber.toString();
         this.slotNumberLabel.x = this.canvas.width - 12;
         this.slotNumberLabel.y = this.canvas.height - 16;
		 //this.slotNumberLabel.filters = [new GlowFilter(0,0.8,4,4,3)];
         this.canvas.addChild(this.slotNumberLabel);
         this.setLockMask(InventoryLock.PLAYER_INACTIVE,true);
      }
      
      public function setLockMask(mask:int, setLock:Boolean) : void
      {
         if(setLock)
         {
            this.lockBits = this.lockBits | mask;
         }
         else
         {
            this.lockBits = this.lockBits & ~mask;
         }
      }
      
      public function isLocked() : Boolean
      {
         return this.lockBits != 0;
      }
      
      public function getCanvas() : DisplayObject
      {
         return this.canvas;
      }
      
      public function setItem(item:InventoryItem) : void
      {
         var icon:InventoryIcon = null;
         if(this.item == item)
         {
            return;
         }
         if(this.item != null)
         {
            this.canvas.removeChild(this.item.getIcon());
         }
         this.item = item;
         if(item != null)
         {
            if(this.canvas.contains(this.emptyIcon))
            {
               this.canvas.removeChild(this.emptyIcon);
            }
            icon = item.getIcon();
            this.canvas.addChildAt(icon,0);
            if(this.cooldownMask == null)
            {
               this.cooldownMask = new CooldownIndicator(icon.width - 4,8);
               this.cooldownMask.x = 2;
               this.cooldownMask.y = 2;
               this.canvas.addChild(this.cooldownMask);
            }
            this.cooldownMask.visible = false;
            if(this.quantityLabel == null)
            {
               this.quantityLabel = new Label();
			   //this.quantityLabel.filters = [new GlowFilter(0,0.8,4,4,3)];
               //this.quantityLabel.size = FONT_SIZE;
               this.canvas.addChild(this.quantityLabel);
            }
            this.updateCounter();
         }
         else
         {
            if(!this.canvas.contains(this.emptyIcon))
            {
               this.canvas.addChildAt(this.emptyIcon,0);
            }
            this.quantityLabel.visible = false;
         }
      }
      
      public function getItem() : InventoryItem
      {
         return this.item;
      }
      
      public function update(now:int) : void
      {
         var itemReadiness:Number = NaN;
         if(this.item == null)
         {
            return;
         }
         if(this.isLocked())
         {
            this.cooldownMask.visible = true;
			this.slotNumberLabel.visible = false;
            this.cooldownMask.draw(0);
            this.prevItemReadiness = 1;
         }
         else
         {
			this.slotNumberLabel.visible = true;
            itemReadiness = this.item == null?Number(0):Number(this.item.getCooldownStatus(now));
            if(itemReadiness == 1)
            {
               this.cooldownMask.visible = false;
               if(this.prevItemReadiness < 1)
               {
                  this.startFlash(now);
               }
               this.updateFlash(now);
            }
            else
            {
               this.stopFlash();
               this.cooldownMask.visible = true;
               this.cooldownMask.draw(itemReadiness);
            }
            this.prevItemReadiness = itemReadiness;
         }
      }
      
      public function updateCounter() : void
      {
         if(this.item == null)
         {
            return;
         }
         var count:int = this.item.count;
		 //this.slotNumberLabel.x = this.item.getIcon().width - this.slotNumberLabel.width - 3;
         //this.slotNumberLabel.y = this.item.getIcon().height - this.slotNumberLabel.height - 1;
         if(count > 0)
         {
            this.quantityLabel.text = count.toString();
			this.quantityLabel.x = this.item.getIcon().width/2 - this.quantityLabel.width/2;
            this.quantityLabel.y = -this.quantityLabel.height;
         }
         else
         {
            this.setItem(null);
         }
      }
      
      private function updateFlash(now:int) : void
      {
         var flashChannelOffset:uint = 255;
         var flashDuration:uint = 100;
         var flashFadeDuration:uint = 300;
         switch(this.flashState)
         {
            case FLASH_SHOW:
               if(now < this.flashStartTime + flashDuration)
               {
                  this.setColorOffset(flashChannelOffset * (now - this.flashStartTime) / flashDuration);
               }
               else
               {
                  this.setColorOffset(flashChannelOffset);
                  this.flashStartTime = this.flashStartTime + (flashDuration + flashFadeDuration);
                  this.flashState = FLASH_FADE;
               }
               break;
            case FLASH_FADE:
               if(now < this.flashStartTime)
               {
                  this.setColorOffset(flashChannelOffset * (this.flashStartTime - now) / flashFadeDuration);
               }
               else
               {
                  this.stopFlash();
               }
         }
      }
      
      private function setColorOffset(offset:uint) : void
      {
         this.colorTransform.redOffset = offset;
         this.colorTransform.greenOffset = offset;
         this.colorTransform.blueOffset = offset;
         this.colorTransform.alphaOffset = offset;
         this.canvas.transform.colorTransform = this.colorTransform;
      }
      
      private function startFlash(now:int) : void
      {
         this.flashState = FLASH_SHOW;
         this.flashStartTime = now;
      }
      
      private function stopFlash() : void
      {
         if(this.flashState != FLASH_DONE)
         {
            this.flashState = FLASH_DONE;
            this.setColorOffset(0);
         }
      }
   }
}
