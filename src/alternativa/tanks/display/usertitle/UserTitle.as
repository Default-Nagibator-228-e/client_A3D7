package alternativa.tanks.display.usertitle
{
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.inventory.InventoryItemType;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import flash.display.BitmapData;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class UserTitle
   {
      
      private static const matrix:Matrix = new Matrix();
      
      private static const EFFECT_WARNING_TIME:int = 3000;
      
      private static const MAX_HEALTH:int = 10000;
      
      private static var RANK_ICON_SIZE:int = 13;
      
      private static const LABEL_HEIGHT:int = 13;
      
      private static const RANK_ICON_OFFSET_Y:int = 2;
      
      private static const EFFECTS_ICON_SIZE:int = 16;
      
      private static const LABEL_SPACING:int = 0;
      
      private static const HEALTH_BAR_SPACING_Y:int = 2;
      
      private static const WEAPON_BAR_SPACING_Y:int = -1;
      
      private static const EFFECTS_SPACING_Y:int = 2;
      
      private static const EFFECTS_SPACING_X:int = 4;
      
      private static const BAR_WIDTH:int = 100;
      
      private static const BAR_HEIGHT:int = 8;
      
      private static const TEXTURE_MARGIN:int = 3;
      
      private static const TEXTURE_MARGIN_2:int = 2 * TEXTURE_MARGIN;
      
      private static const rankIcon:RangIconSmall = new RangIconSmall();
      
      private static const inventoryItemTypes:Vector.<int> = Vector.<int>([InventoryItemType.FISRT_AID,InventoryItemType.ARMOR,InventoryItemType.POWER,InventoryItemType.SPEED]);
      
      private static const filter:GlowFilter = new GlowFilter(0,0.8,4,4,3);
      
      public static const BIT_LABEL:int = 1;
      
      public static const BIT_HEALTH:int = 2;
      
      public static const BIT_WEAPON:int = 4;
      
      public static const BIT_EFFECTS:int = 8;
      
      private static const ALPHA_SPEED:Number = 0.002;
       
      
      private var configFlags:int;
      
      private var dirtyFlags:int;
      
      public var sprite:Sprite3D;
      
      private var textureRect:Rectangle;
      
      private var label:Label;
      
      private var healthBar:ProgressBar;
      
      private var weaponBar:ProgressBar;
      
      private var effectIndicators:Vector.<EffectIndicator>;
      
      private var numVisibleIndicators:int;
      
      private var effectIndicatorsY:int;
      
      private var rankId:int;
      
      private var labelText:String;
      
      private var health:int;
      
      private var weaponStatus:int;
      
      private var indicatorsNumberChanged:Boolean;
      
      private var teamType:BattleTeamType;
      
      private var skin:ProgressBarSkin;
      
      private var hidden:Boolean = true;
      
      private var time:int;
      
      private var material:TextureMaterial;
      
      private var texture:BitmapData;
      
      private var local:Boolean;
      
      public function UserTitle(isLocal:Boolean)
      {
         this.teamType = BattleTeamType.NONE;
         this.skin = ProgressBarSkin.HEALTHBAR_DM;
         super();
         this.material = new TextureMaterial();
         this.local = isLocal;
         this.sprite = new Sprite3D(100,100,this.material);
         this.sprite.perspectiveScale = false;
         this.sprite.alpha = 0;
         this.sprite.visible = false;
         this.sprite.shadowMapAlphaThreshold = 100;
         this.sprite.softAttenuation = 0;
         this.sprite.useLight = false;
         this.sprite.useShadowMap = false;
         this.sprite.sorting = 0;
         this.sprite.clipping = Clipping.FACE_CLIPPING;
         this.material.uploadEveryFrame = true;
         if(!isLocal)
         {
            this.sprite.originY = 1;
         }
         else
         {
            this.sprite.depthTest = false;
         }
         this.hidden = true;
      }
      
      public function hide() : void
      {
         if(this.hidden)
         {
            return;
         }
         this.hidden = true;
      }
      
      public function show() : void
      {
         if(!this.hidden)
         {
            return;
         }
         this.hidden = false;
      }
      
      public function isHidden() : Boolean
      {
         return this.hidden;
      }
      
      public function setConfiguration(configFlags:int) : void
      {
         if(this.configFlags == configFlags)
         {
            return;
         }
         this.configFlags = configFlags;
         this.updateConfiguration();
      }
      
      public function setTeamType(teamType:BattleTeamType) : void
      {
         var bit:int = 0;
         if(this.teamType == teamType)
         {
            return;
         }
         this.teamType = teamType;
         this.skin = ProgressBarSkin.HEALTHBAR_DM;
         switch(teamType)
         {
            case BattleTeamType.RED:
               this.skin = ProgressBarSkin.HEALTHBAR_RED;
               break;
            case BattleTeamType.BLUE:
               this.skin = ProgressBarSkin.HEALTHBAR_BLUE;
         }
         for each(bit in [BIT_LABEL,BIT_HEALTH,BIT_WEAPON])
         {
            if(this.hasOption(bit))
            {
               this.markDirty(bit);
            }
         }
      }
      
      public function setRank(rankId:int) : void
      {
         if(this.rankId == rankId)
         {
            return;
         }
         this.rankId = rankId;
         if(this.hasOption(BIT_LABEL))
         {
            this.markDirty(BIT_LABEL | BIT_HEALTH | BIT_WEAPON | BIT_EFFECTS);
         }
      }
      
      public function setLabelText(labelText:String) : void
      {
         if(this.labelText == labelText)
         {
            return;
         }
         this.labelText = labelText;
         if(this.hasOption(BIT_LABEL))
         {
            this.updateConfiguration();
            this.markDirty(BIT_LABEL | BIT_HEALTH | BIT_WEAPON | BIT_EFFECTS);
         }
      }
      
      public function setHealth(health:int) : void
      {
         if(this.health == health)
         {
            return;
         }
         this.health = health;
         if(this.hasOption(BIT_HEALTH))
         {
            this.markDirty(BIT_HEALTH);
         }
      }
      
      public function setWeaponStatus(weaponStatus:int) : void
      {
         if(this.weaponStatus == weaponStatus)
         {
            return;
         }
         this.weaponStatus = weaponStatus;
         if(this.hasOption(BIT_WEAPON))
         {
            this.markDirty(BIT_WEAPON);
         }
      }
      
      public function showIndicator(effectId:int, duration:int) : void
      {
		 //throw new Error(duration);
         if(!this.hasOption(BIT_EFFECTS))
         {
            return;
         }
         var indicator:EffectIndicator = this.getEffectIndicatorById(effectId);
         if(indicator != null)
         {
            if(indicator.isHidden())
            {
               this.changeVisibleIndicatorsNumber(1);
            }
            indicator.show(duration);
         }
      }
      
      public function hideIndicator(effectId:int) : void
      {
         if(!this.hasOption(BIT_EFFECTS))
         {
            return;
         }
         var indicator:EffectIndicator = this.getEffectIndicatorById(effectId);
         if(indicator != null)
         {
            indicator.hide();
         }
      }
      
      public function hideIndicators() : void
      {
         var effectId:int = 0;
         if(!this.hasOption(BIT_EFFECTS) || this.effectIndicators == null)
         {
            return;
         }
         for each(effectId in inventoryItemTypes)
         {
            this.hideIndicator(effectId);
         }
      }
      
      public function doHideIndicator(indicator:EffectIndicator) : void
      {
         indicator.clear(this.texture);
         this.changeVisibleIndicatorsNumber(-1);
      }
      
      public function update(pos:Vector3) : void
      {
         var effectIndicator:EffectIndicator = null;
         this.setPosition(pos);
         var now:int = getTimer();
         var delta:int = now - this.time;
         this.time = now;
         this.updateVisibility(delta);
         if(this.dirtyFlags != 0)
         {
            if(this.isDirtyAndHasOption(BIT_LABEL))
            {
               this.updateLabel();
            }
            if(this.isDirtyAndHasOption(BIT_HEALTH))
            {
               this.healthBar.setSkin(this.skin);
               this.healthBar.progress = this.health;
               this.healthBar.draw(this.texture,this.material);
            }
            if(this.isDirtyAndHasOption(BIT_WEAPON))
            {
               this.weaponBar.progress = this.weaponStatus;
               this.weaponBar.draw(this.texture,this.material);
            }
            if(this.isDirtyAndHasOption(BIT_EFFECTS))
            {
               for each(effectIndicator in this.effectIndicators)
               {
                  effectIndicator.forceRedraw();
               }
            }
            this.dirtyFlags = 0;
         }
         if(this.hasOption(BIT_EFFECTS))
         {
            this.updateEffectIndicators(now,delta);
         }
      }
      
      private function isDirtyAndHasOption(bit:int) : Boolean
      {
         return (this.dirtyFlags & bit) != 0 && (this.configFlags & bit) != 0;
      }
      
      private function updateEffectIndicators(now:int, delta:int) : void
      {
         var indicator:EffectIndicator = null;
         var i:int = 0;
         var x:int = 0;
         var num:int = this.effectIndicators.length;
         if(this.indicatorsNumberChanged)
         {
            this.indicatorsNumberChanged = false;
            x = this.textureRect.width + TEXTURE_MARGIN_2 - this.numVisibleIndicators * EFFECTS_ICON_SIZE - (this.numVisibleIndicators - 1) * EFFECTS_SPACING_X >> 1;
            for(i = 0; i < num; i++)
            {
               indicator = this.effectIndicators[i];
               if(indicator.isVisible())
               {
                  indicator.clear(this.texture);
               }
               if(!indicator.isHidden())
               {
                  indicator.setPosition(x,this.effectIndicatorsY);
                  //x += this.effectIndicators[i].icon.width/1.25 + EFFECTS_SPACING_X;
				  x += this.effectIndicators[i].icon.width + 1;
               }
            }
         }
         for(i = 0; i < num; i++)
         {
            indicator = this.effectIndicators[i];
            indicator.update(now,delta,this.texture,this.material);
         }
      }
      
      private function changeVisibleIndicatorsNumber(increment:int) : void
      {
         this.numVisibleIndicators = this.numVisibleIndicators + increment;
         this.indicatorsNumberChanged = true;
      }
      
      private function updateConfiguration() : void
      {
         if(this.configFlags == 0)
         {
            return;
         }
         this.setupTexture();
         this.setupComponents();
      }
      
      private function setupTexture() : void
      {
         var width:int = 0;
         var height:int = 0;
         var numEffects:int = 0;
         var w:int = 0;
         if(this.hasOption(BIT_LABEL))
         {
            if(this.label == null)
            {
               this.createLabelComponents();
            }
            this.label.text = this.labelText == null?"":this.labelText;
            width = RANK_ICON_SIZE + LABEL_SPACING + this.label.width;
            height = LABEL_HEIGHT;
         }
         if(this.hasOption(BIT_HEALTH))
         {
            if(width < BAR_WIDTH)
            {
               width = BAR_WIDTH;
            }
            if(height > 0)
            {
               height = height + HEALTH_BAR_SPACING_Y;
            }
            height = height + BAR_HEIGHT;
            if(this.hasOption(BIT_WEAPON))
            {
               height = height + (WEAPON_BAR_SPACING_Y + BAR_HEIGHT);
            }
         }
         if(this.hasOption(BIT_EFFECTS))
         {
            numEffects = 4;
            w = numEffects * EFFECTS_ICON_SIZE + (numEffects - 1) * EFFECTS_SPACING_X;
            if(width < w)
            {
               width = w;
            }
            if(height > 0)
            {
               height = height + EFFECTS_SPACING_Y;
            }
            height = height + EFFECTS_ICON_SIZE;
         }
         width = width + 2 * TEXTURE_MARGIN;
         height = height + 2 * TEXTURE_MARGIN;
         if(this.texture == null || this.texture.width != width || this.texture.height != height)
         {
            if(this.texture != null)
            {
               this.texture.dispose();
            }
            this.texture = new BitmapData(width,height,true,0);
            this.material.texture = this.texture;
            this.sprite.width = width;
            this.sprite.height = height;
            this.textureRect = this.texture.rect;
            this.markDirty(BIT_LABEL | BIT_HEALTH | BIT_WEAPON | BIT_EFFECTS);
         }
      }
      
      private function setupComponents() : void
      {
         var left:int = 0;
         var top:int = TEXTURE_MARGIN;
         if(this.hasOption(BIT_LABEL))
         {
            top = top + LABEL_HEIGHT;
         }
         if(this.hasOption(BIT_HEALTH))
         {
            if(this.hasOption(BIT_LABEL))
            {
               top = top + HEALTH_BAR_SPACING_Y;
            }
            left = this.textureRect.width - BAR_WIDTH >> 1;
            this.healthBar = new ProgressBar(left,top,MAX_HEALTH,BAR_WIDTH,this.skin);
            top = top + BAR_HEIGHT;
            if(this.hasOption(BIT_WEAPON))
            {
               top = top + WEAPON_BAR_SPACING_Y;
               this.weaponBar = new ProgressBar(left,top,100,BAR_WIDTH,ProgressBarSkin.WEAPONBAR);
               top = top + BAR_HEIGHT;
            }
         }
         if(this.hasOption(BIT_EFFECTS))
         {
            top += EFFECTS_SPACING_Y;
            this.effectIndicatorsY = top;
            this.createEffectsIndicators();
         }
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         if(this.sprite.parent != null)
         {
            return;
         }
         container.addChild(this.sprite);
         this.time = getTimer();
      }
      
      public function removeFromContainer() : void
      {
         if(this.sprite.parent != null)
         {
            this.sprite.parent.removeChild(this.sprite);
         }
      }
      
      public function setPosition(pos:Vector3D) : void
      {
         this.sprite.x = pos.x;
         this.sprite.y = pos.y;
         this.sprite.z = pos.z;
      }
      
      private function markDirty(dirtyBit:int) : void
      {
         this.dirtyFlags = this.dirtyFlags | dirtyBit;
      }
      
      public function hasOption(optionBit:int) : Boolean
      {
         return (optionBit & this.configFlags) != 0;
      }
      
      private function createLabelComponents() : void
      {
         if(this.label == null)
         {
            this.label = new Label();
            this.label.autoSize = TextFieldAutoSize.LEFT;
            this.label.thickness = 50;
         }
      }
      
      private function updateLabel() : void
      {
         var tmpBitmapData:BitmapData = this.texture.clone();
         tmpBitmapData.fillRect(this.textureRect,0);
         var labelWidth:int = RANK_ICON_SIZE + LABEL_SPACING + this.label.width;
         var left:int = tmpBitmapData.width - labelWidth >> 1;
         matrix.tx = left;
         matrix.ty = TEXTURE_MARGIN + RANK_ICON_OFFSET_Y;
         rankIcon.rang = this.rankId;
		 RANK_ICON_SIZE = rankIcon.width;
         tmpBitmapData.draw(rankIcon,matrix,null,null,null,true);
         matrix.tx = left + RANK_ICON_SIZE + LABEL_SPACING;
         matrix.ty = TEXTURE_MARGIN;
         this.label.textColor = this.skin.color;
         tmpBitmapData.draw(this.label,matrix,null,null,null,true);
         this.texture.applyFilter(tmpBitmapData,this.textureRect,new Point(),filter);
         tmpBitmapData.dispose();
      }
      
      private function createEffectsIndicators() : void
      {
         var typeId:int = 0;
         if(this.effectIndicators != null)
         {
            return;
         }
         this.effectIndicators = new Vector.<EffectIndicator>();
         for each(typeId in inventoryItemTypes)
         {
            if(typeId == InventoryItemType.FISRT_AID)
            {
               this.effectIndicators.push(new EffectIndicator(typeId,100000,this,300,0));
            }
            else
            {
               this.effectIndicators.push(new EffectIndicator(typeId,EFFECT_WARNING_TIME,this,300,30));
            }
         }
      }
      
      private function getEffectIndicatorById(effectId:int) : EffectIndicator
      {
         var indicator:EffectIndicator = null;
         if(this.effectIndicators == null)
         {
            return null;
         }
         var len:int = this.effectIndicators.length;
         for(var i:int = 0; i < len; i++)
         {
            indicator = this.effectIndicators[i];
            if(indicator.effectId == effectId)
            {
               return indicator;
            }
         }
         return null;
      }
      
      private function updateVisibility(delta:int) : void
      {
         if(this.hidden)
         {
            if(this.sprite.alpha > 0)
            {
               this.sprite.alpha = this.sprite.alpha - ALPHA_SPEED * delta;
               if(this.sprite.alpha <= 0)
               {
                  this.sprite.alpha = 0;
                  this.sprite.visible = false;
               }
            }
         }
         else
         {
            this.sprite.visible = true;
            if(this.sprite.alpha < 1)
            {
               this.sprite.alpha = this.sprite.alpha + ALPHA_SPEED * delta;
               if(this.sprite.alpha > 1)
               {
                  this.sprite.alpha = 1;
               }
            }
         }
      }
   }
}
