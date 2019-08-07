package forms.itemscategory 
{
	import alternativa.init.Main;
	import alternativa.osgi.service.locale.ILocaleService;
	import flash.geom.Matrix;
	import forms.garage.ItemPropertyIcon;
	import forms.garage.ModInfoRow;
	import forms.garage.ModTable;
	import forms.shop.components.item.GridItemBase;
	import alternativa.tanks.locale.constants.TextConst;
	import alternativa.tanks.model.IItemEffect;
	import alternativa.tanks.model.ItemParams;
	import utils.client.commons.types.ItemProperty;
	import utils.client.garage.item.ItemPropertyValue;
	import utils.client.garage.item.ModificationInfo;
	import flash.display.*;
	import flash.events.Event;

	public class Proporit extends GridItemBase
	{
		
		[Embed(source="I/1.png")]
      private static const bitmapForce:Class;
      
      private static const forceBd:BitmapData = new bitmapForce().bitmapData;
      [Embed(source="I/2.png")]
      private static const bitmapArmorWear:Class;
      
      private static const damageBd:BitmapData = new bitmapArmorWear().bitmapData;
      [Embed(source="I/3.png")]
      private static const bitmapArmor:Class;
      
      private static const armorBd:BitmapData = new bitmapArmor().bitmapData;
      [Embed(source="I/4.png")]
      private static const bitmaptgor:Class;
      
      private static const tgorBd:BitmapData = new bitmaptgor().bitmapData;
      [Embed(source="I/5.png")]
      private static const bitmapPerKr:Class;
      
      private static const PerKrBd:BitmapData = new bitmapPerKr().bitmapData;
      [Embed(source="I/6.png")]
      private static const bitmapRange:Class;
      
      private static const rangeBd:BitmapData = new bitmapRange().bitmapData;
      [Embed(source="I/7.png")]
      private static const bitmapRateOfFire:Class;
      
      private static const rateOfFireBd:BitmapData = new bitmapRateOfFire().bitmapData;
      [Embed(source="I/8.png")]
      private static const bitmapKrit:Class;
      
      private static const kritBd:BitmapData = new bitmapKrit().bitmapData;
      [Embed(source="I/9.png")]
      private static const bitmapPerProst:Class;
      
      private static const perprostBd:BitmapData = new bitmapPerProst().bitmapData;
      [Embed(source="I/10.png")]
      private static const bitmapSpread:Class;
      
      private static const spreadBd:BitmapData = new bitmapSpread().bitmapData;
      [Embed(source="I/11.png")]
      private static const bitmapTurretRotationRate:Class;
      
      private static const turretRotationRateBd:BitmapData = new bitmapTurretRotationRate().bitmapData;
      [Embed(source="I/12.png")]
      private static const bitmapSpeed:Class;
      
      private static const speedBd:BitmapData = new bitmapSpeed().bitmapData;
      [Embed(source="I/13.png")]
      private static const bitmapTurnSpeed:Class;
      
      private static const turnspeedBd:BitmapData = new bitmapTurnSpeed().bitmapData;
      [Embed(source="I/14.png")]
      private static const bitmapFireResistance:Class;
      
      private static const fireResistanceBd:BitmapData = new bitmapFireResistance().bitmapData;
      [Embed(source="I/15.png")]
      private static const bitmapPlasmaResistance:Class;
      
      private static const plasmaResistanceBd:BitmapData = new bitmapPlasmaResistance().bitmapData;
      [Embed(source="I/16.png")]
      private static const bitmapMechResistance:Class;
      
      private static const mechResistanceBd:BitmapData = new bitmapMechResistance().bitmapData;
      [Embed(source="I/17.png")]
      private static const bitmapRailResistance:Class;
      
      private static const railResistanceBd:BitmapData = new bitmapRailResistance().bitmapData;
      [Embed(source="I/18.png")]
      private static const bitmapVampireResistance:Class;
      
      private static const vampireResistanceBd:BitmapData = new bitmapVampireResistance().bitmapData;
      [Embed(source="I/19.png")]
      private static const bitmapThunderResistance:Class;
      
      private static const thunderResistanceBd:BitmapData = new bitmapThunderResistance().bitmapData;
      [Embed(source="I/20.png")]
      private static const bitmapFreezeResistance:Class;
      
      private static const freezeResistanceBd:BitmapData = new bitmapFreezeResistance().bitmapData;
      [Embed(source="I/21.png")]
      private static const bitmapRicochetResistance:Class;
      
      private static const ricochetResistanceBd:BitmapData = new bitmapRicochetResistance().bitmapData;
      [Embed(source="I/22.png")]
      private static const bitmapHealingRadius:Class;
      
      private static const healingRadiusBd:BitmapData = new bitmapHealingRadius().bitmapData;
      [Embed(source="I/23.png")]
      private static const bitmapHealRate:Class;
      
      private static const healRateBd:BitmapData = new bitmapHealRate().bitmapData;
      [Embed(source="I/24.png")]
      private static const bitmapVampireRate:Class;
      
      private static const vampireRateBd:BitmapData = new bitmapVampireRate().bitmapData;
	  
	  [Embed(source="I/25.png")]
      private static const bitmapMass:Class;
      
      private static const massBd:BitmapData = new bitmapMass().bitmapData;
	  
	  [Embed(source="I/26.png")]
      private static const bitmapPower:Class;
      
      private static const powerBd:BitmapData = new bitmapPower().bitmapData;
		
		public var forceIcon:ItemPropertyIcon;
      
		public var armorIcon:ItemPropertyIcon;
      
		  public var damageIcon:ItemPropertyIcon;
		  
		  public var damagePerSecondIcon:ItemPropertyIcon;
		  
		  public var tgorIcon:ItemPropertyIcon;
		  
		  public var perkrIcon:ItemPropertyIcon;
		  
		  public var powerIcon:ItemPropertyIcon;
		  
		  public var rangeIcon:ItemPropertyIcon;
		  
		  public var rateOfFireIcon:ItemPropertyIcon;
		  
		  public var perprostIcon:ItemPropertyIcon;
		  
		  public var kritIcon:ItemPropertyIcon;
		  
		  public var massIcon:ItemPropertyIcon;
		  
		  public var spreadIcon:ItemPropertyIcon;
		  
		  public var turretRotationRateIcon:ItemPropertyIcon;
		  
		  public var damageAngleIcon:ItemPropertyIcon;
		  
		  public var speedIcon:ItemPropertyIcon;
		  
		  public var turnSpeedIcon:ItemPropertyIcon;
		  
		  public var mechResistanceIcon:ItemPropertyIcon;
		  
		  public var plasmaResistanceIcon:ItemPropertyIcon;
		  
		  public var fireResistanceIcon:ItemPropertyIcon;
		  
		  public var railResistanceIcon:ItemPropertyIcon;
		  
		  public var vampireResistanceIcon:ItemPropertyIcon;
		  
		  public var thunderResistanceIcon:ItemPropertyIcon;
		  
		  public var freezeResistanceIcon:ItemPropertyIcon;
		  
		  public var ricochetResistanceIcon:ItemPropertyIcon;
		  
		  public var shaftResistanceIcon:ItemPropertyIcon;
		  
		  public var healingRadiusIcon:ItemPropertyIcon;
		  
		  public var healRateIcon:ItemPropertyIcon;
		  
		  public var vampireRateIcon:ItemPropertyIcon;
		  
		  public var visibleIcons:Array = new Array();
		  
		  public var modTable:ModTable;
		  
		  private var localeService:ILocaleService;
		  
		  private var horizMargin:int = 12;
      
		  private var vertMargin:int = 9;
      
		  private var spaceModule:int = 3;
		  
		  public const margin:int = 11;
		  
		  private const iconSpace:int = 10;
		  
		  private var hr:Boolean;
		  
		  private var selection:Shape = new Shape();
		  
		  private var selection1:Shape = new Shape();
		  
		  private var hei:int = 0;
		  
		  private var ico:Sprite = new Sprite();
		
		public function Proporit(properties:Array,itemParams:ItemParams,showProperties:Boolean) 
		{
			super();
			var i:int = 0;
			hr = showProperties;
			visibleIcons = new Array();
			this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
			 var p:ItemPropertyValue = null;
			 var mods:Array = null;
			 var text:Array = null;
			 var m:int = 0;
			 var modInfo:ModificationInfo = null;
			 var row:ModInfoRow = null;
			 var maxWidth:int = 0;
			 var modProperties:Array = null;
			 var rank:int = 0;
			 var cost:int = 0;
			 var acceptableNum:int = 0;
			 var itemEffectModel:IItemEffect = null;
			 this.addChild(this.selection);
			 this.addChild(this.selection1);
			 this.forceIcon = new ItemPropertyIcon(forceBd,"");
			 this.armorIcon = new ItemPropertyIcon(armorBd,"");
			 this.damageIcon = new ItemPropertyIcon(damageBd,"");
			 this.damagePerSecondIcon = new ItemPropertyIcon(damageBd,"");
			 this.tgorIcon = new ItemPropertyIcon(tgorBd,"");
			 this.perkrIcon = new ItemPropertyIcon(PerKrBd,"");
			 this.rangeIcon = new ItemPropertyIcon(rangeBd,"");
			 this.rateOfFireIcon = new ItemPropertyIcon(rateOfFireBd,"");
			 this.perprostIcon = new ItemPropertyIcon(perprostBd,"");
			 this.kritIcon = new ItemPropertyIcon(kritBd, "");
			 this.massIcon = new ItemPropertyIcon(massBd, "");
			 this.powerIcon = new ItemPropertyIcon(powerBd,"");
			 this.spreadIcon = new ItemPropertyIcon(spreadBd,"");
			 this.turretRotationRateIcon = new ItemPropertyIcon(turretRotationRateBd,"");
			 this.damageAngleIcon = new ItemPropertyIcon(spreadBd,"");
			 this.speedIcon = new ItemPropertyIcon(speedBd,"");
			 this.turnSpeedIcon = new ItemPropertyIcon(turnspeedBd,"");
			 this.mechResistanceIcon = new ItemPropertyIcon(mechResistanceBd,"");
			 this.fireResistanceIcon = new ItemPropertyIcon(fireResistanceBd,"");
			 this.plasmaResistanceIcon = new ItemPropertyIcon(plasmaResistanceBd,"");
			 this.railResistanceIcon = new ItemPropertyIcon(railResistanceBd,"");
			 this.vampireResistanceIcon = new ItemPropertyIcon(vampireResistanceBd,"");
			 this.thunderResistanceIcon = new ItemPropertyIcon(thunderResistanceBd,"");
			 this.freezeResistanceIcon = new ItemPropertyIcon(freezeResistanceBd,"");
			 this.ricochetResistanceIcon = new ItemPropertyIcon(ricochetResistanceBd,"");
			 this.healingRadiusIcon = new ItemPropertyIcon(healingRadiusBd,"");
			 this.healRateIcon = new ItemPropertyIcon(healRateBd,"");
			 this.vampireRateIcon = new ItemPropertyIcon(vampireRateBd, "");
         if(properties != null)
         {
            for(i = 0; i < properties.length; i++)
            {
               p = properties[i] as ItemPropertyValue;
			   switch(p.property)
               {
                  case ItemProperty.ARMOR:
                     visibleIcons[5] = this.armorIcon;
                     break;
                  case ItemProperty.DAMAGE:
                     visibleIcons[5] = this.damageIcon;
                     break;
                  case ItemProperty.DAMAGE_PER_SECOND:
                     visibleIcons[5] = this.damagePerSecondIcon;
                     break;
                  case ItemProperty.AIMING_ERROR:
                     visibleIcons[8] = this.spreadIcon;
                     break;
                  case ItemProperty.CONE_ANGLE:
                     visibleIcons[8] = this.damageAngleIcon;
                     break;
                  case ItemProperty.SHOT_FORCE:
                     visibleIcons[10] = this.forceIcon;
                     break;
				  case ItemProperty.T_GOR:
                     visibleIcons[23] = this.tgorIcon;
                     break;
				  case ItemProperty.KRIT:
                     visibleIcons[24] = this.kritIcon;
                     break;
				  case ItemProperty.PER_PROST:
                     visibleIcons[25] = this.perprostIcon;
                     break;
				  case ItemProperty.MASS:
                     visibleIcons[26] = this.massIcon;
                     break;
				  case ItemProperty.POWER:
                     visibleIcons[27] = this.powerIcon;
                     break;
                  case ItemProperty.SHOT_FREQUENCY:
                     visibleIcons[6] = this.rateOfFireIcon;
                     break;
                  case ItemProperty.SHOT_RANGE:
                     visibleIcons[9] = this.rangeIcon;
                     break;
                  case ItemProperty.TURRET_TURN_SPEED:
                     visibleIcons[7] = this.turretRotationRateIcon;
                     break;
                  case ItemProperty.SPEED:
                     visibleIcons[11] = this.speedIcon;
                     break;
                  case ItemProperty.TURN_SPEED:
                     visibleIcons[12] = this.turnSpeedIcon;
                     break;
				  case ItemProperty.PER_KR:
                     visibleIcons[22] = this.perkrIcon;
                     break;
                  case ItemProperty.MECH_RESISTANCE:
                     if(showProperties)
                     {
                        this.mechResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.mechResistanceIcon.labelText = "";
                     }
                     visibleIcons[13] = this.mechResistanceIcon;
                     break;
                  case ItemProperty.FIRE_RESISTANCE:
                     if(showProperties)
                     {
                        this.fireResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.fireResistanceIcon.labelText = "";
                     }
                     visibleIcons[14] = this.fireResistanceIcon;
                     break;
                  case ItemProperty.PLASMA_RESISTANCE:
                     if(showProperties)
                     {
                        this.plasmaResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.plasmaResistanceIcon.labelText = "";
                     }
                     visibleIcons[15] = this.plasmaResistanceIcon;
                     break;
                  case ItemProperty.RAIL_RESISTANCE:
                     if(showProperties)
                     {
                        this.railResistanceIcon.labelText = p.value;
                     }
                     visibleIcons[16] = this.railResistanceIcon;
                     break;
                  case ItemProperty.VAMPIRE_RESISTANCE:
                     if(showProperties)
                     {
                        this.vampireResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.vampireResistanceIcon.labelText = "";
                     }
                     visibleIcons[17] = this.vampireResistanceIcon;
                     break;
                  case ItemProperty.THUNDER_RESISTANCE:
                     if(showProperties)
                     {
                        this.thunderResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.thunderResistanceIcon.labelText = "";
                     }
                     visibleIcons[18] = this.thunderResistanceIcon;
                     break;
                  case ItemProperty.FREEZE_RESISTANCE:
                     if(showProperties)
                     {
                        this.freezeResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.freezeResistanceIcon.labelText = "";
                     }
                     visibleIcons[19] = this.freezeResistanceIcon;
                     break;
                  case ItemProperty.RICOCHET_RESISTANCE:
                     if(showProperties)
                     {
                        this.ricochetResistanceIcon.labelText = p.value;
                     }
                     else
                     {
                        this.ricochetResistanceIcon.labelText = "";
                     }
                     visibleIcons[20] = this.ricochetResistanceIcon;
                     break;
                  case ItemProperty.HEALING_RADUIS:
                     if(showProperties)
                     {
                        this.healingRadiusIcon.labelText = p.value;
                     }
                     else
                     {
                        this.healingRadiusIcon.labelText = "";
                     }
                     visibleIcons[21] = this.healingRadiusIcon;
                     break;
                  case ItemProperty.HEAL_RATE:
                     if(showProperties)
                     {
                        this.healRateIcon.labelText = p.value;
                     }
                     else
                     {
                        this.healRateIcon.labelText = "";
                     }
                     visibleIcons[5] = this.healRateIcon;
                     break;
                  case ItemProperty.VAMPIRE_RATE:
                     if(showProperties)
                     {
                        this.vampireRateIcon.labelText = p.value;
                     }
                     else
                     {
                        this.vampireRateIcon.labelText = "";
                     }
                     visibleIcons[6] = this.vampireRateIcon;
               }
            }
         }
         i = 0;
         while(i < visibleIcons.length)
         {
            if(visibleIcons[i] == null)
            {
               visibleIcons.splice(i,1);
            }
            else
            {
               i++;
            }
         }
         if(visibleIcons.length > 0)
         {
            this.showIcons();
         }
		 this.modTable = new ModTable();
		 if(!showProperties)
         {
            this.showModTable();
            this.modTable.select(itemParams.modificationIndex);
            mods = itemParams.modifications;
            for(m = 0; m < mods.length; m++)
            {
               modInfo = ModificationInfo(mods[m]);
               row = ModInfoRow(this.modTable.rows[m]);
               row.costLabel.text = modInfo.crystalPrice.toString();
               if(maxWidth < row.costLabel.width)
               {
                  maxWidth = row.costLabel.width;
               }
               this.modTable.maxCostWidth = maxWidth;
               row.rankIcon.rang = modInfo.rankId;
               text = new Array();
               modProperties = modInfo.itemProperties;
               for(i = 0; i < modProperties.length; i++)
               {
                  p = modProperties[i] as ItemPropertyValue;
                  switch(p.property)
                  {
                     case ItemProperty.ARMOR:
                        text[5] = p.value;
                        break;
                     case ItemProperty.DAMAGE:
                        text[5] = p.value;
                        break;
                     case ItemProperty.DAMAGE_PER_SECOND:
                        text[5] = p.value;
                        break;
                     case ItemProperty.AIMING_ERROR:
                        text[8] = p.value;
                        break;
                     case ItemProperty.CONE_ANGLE:
                        text[8] = p.value;
                        break;
                     case ItemProperty.SHOT_FORCE:
                        text[10] = p.value;
                        break;
					 case ItemProperty.PER_KR:
						text[22] = p.value;
						break;
					 case ItemProperty.T_GOR:
						text[23] = p.value;
						break;
					 case ItemProperty.KRIT:
						text[24] = p.value;
						break;
					 case ItemProperty.PER_PROST:
						text[25] = p.value;
						break;
					 case ItemProperty.MASS:
						text[26] = p.value;
						break;
					 case ItemProperty.POWER:
						text[27] = p.value;
						break;
                     case ItemProperty.SHOT_FREQUENCY:
                        text[6] = p.value;
                        break;
                     case ItemProperty.SHOT_RANGE:
                        text[9] = p.value;
                        break;
                     case ItemProperty.TURRET_TURN_SPEED:
                        text[7] = p.value;
                        break;
                     case ItemProperty.SPEED:
                        text[11] = p.value;
                        break;
                     case ItemProperty.TURN_SPEED:
                        text[12] = p.value;
                        break;
                     case ItemProperty.MECH_RESISTANCE:
                        text[13] = p.value;
                        break;
                     case ItemProperty.FIRE_RESISTANCE:
                        text[14] = p.value;
                        break;
                     case ItemProperty.PLASMA_RESISTANCE:
                        text[15] = p.value;
                        break;
                     case ItemProperty.RAIL_RESISTANCE:
                        text[16] = p.value;
                        break;
                     case ItemProperty.VAMPIRE_RESISTANCE:
                        text[17] = p.value;
                        break;
                     case ItemProperty.HEALING_RADUIS:
                        text[18] = p.value;
                        break;
                     case ItemProperty.HEAL_RATE:
                        text[5] = p.value;
                        break;
                     case ItemProperty.VAMPIRE_RATE:
                        text[6] = p.value;
                  }
               }
               i = 0;
               while(i < text.length)
               {
                  if(text[i] == null)
                  {
                     text.splice(i,1);
                  }
                  else
                  {
                     i++;
                  }
               }
               row.setLabelsNum(text.length);
               row.setLabelsText(text);
            }
            this.modTable.correctNonintegralValues();
         }
		Main.stage.addEventListener(Event.RESIZE, resize12);
		resize12(null);
	}
		
	public function hideModTable() : void
      {
         if(this.contains(this.modTable))
         {
            this.removeChild(this.modTable);
         }
      }
      
      public function showModTable() : void
      {
         if(!this.contains(this.modTable))
         {
            this.addChild(this.modTable);
         }
      }
		
	private function showIcons() : void
      {
         var icon:DisplayObject = null;
		 this.addChild(ico);
         for(var i:int = 0; i < visibleIcons.length; i++)
         {
            icon = visibleIcons[i] as DisplayObject;
            if(!ico.contains(icon))
            {
               ico.addChild(icon);
            }
            icon.visible = true;
         }
      }
		
	
	private function resize12(e:Event) : void
      {
		  var minContainerHeight:int = 0;
         var iconsNum:int = 0;
         var iconY:int = 0;
         var iconsWidth:int = 0;
         var summWidth:int = 0;
         var leftMargin:int = 0;
         var coords:Array = new Array();
         var i:int = 0;
         var icon:ItemPropertyIcon = null;
         var m:int = 0;
         var row:ModInfoRow = null;
		 var w1:int = 407;
         if(visibleIcons != null)
         {
            iconsNum = visibleIcons.length;
            if(iconsNum > 0)
            {
               minContainerHeight = this.y + this.height + this.vertMargin;
			   var widt:int = (w1 - this.margin * 2) - this.horizMargin*2;
               iconY = 6;
               iconsWidth = armorBd.width * iconsNum + this.iconSpace * (iconsNum - 1);
               summWidth = iconsWidth;
			   if(this.contains(this.modTable))
               {
                  summWidth = summWidth + this.modTable.constWidth;
               }
               leftMargin = Math.round((w1 - summWidth) * 0.5);
			   var dswe:int = (w1 - this.margin * 2 - 2) - this.horizMargin * 2;
			   dswe -= 3;
			   var swss:int = 0;
			   swss = leftMargin + iconsWidth + 10 - armorBd.width * iconsNum;
			   if (!hr)
			   {
				   swss = widt - 120 - armorBd.width * iconsNum;//leftMargin + iconsWidth + 10 - armorBd.width * iconsNum;
			   }else{
				   swss = widt - 12 - armorBd.width * iconsNum;
			   }
			   swss /= iconsNum;
			   for(i = 0; i < iconsNum; i++)
               {
                  icon = visibleIcons[i] as ItemPropertyIcon;
				  icon.x = i * (armorBd.width + swss);
                  icon.y = iconY;
               }
			   for(i = 0; i < iconsNum; i++)
               {
                  icon = visibleIcons[i] as ItemPropertyIcon;
				  if(hr)
				   {
					  ico.x = widt / 2 - ico.width / 2;
					  ico.x += 7;
				   }else{
					  ico.x = (widt - 120) / 2 - ico.width / 2;
					  ico.x += 7;
					  coords.push(ico.x + icon.x + armorBd.width * 0.5);//coords.push(ico.x + this.x + icon.x - this.modTable.x + armorBd.width * 0.5);
				   }
               }
               if(!hr)
               {
                  this.modTable.y = this.y + icon.height - 4;
                  this.modTable.resizeSelection(dswe);
                  for(m = 0; m < 4; m++)
                  {
                     row = ModInfoRow(this.modTable.rows[m]);
                     row.setLabelsPos(coords);
                     row.setConstPartCoord(widt - 113,widt - 17);
                  }
               }
			   var dsa:int = this.modTable.y + this.modTable.height + 10;
			   this.selection.graphics.clear();
				this.selection.graphics.beginFill(0x095300);
				this.selection.graphics.drawRoundRect(1, 1, widt, dsa, 6, 6);
				this.selection1.graphics.clear();
				this.selection1.graphics.lineStyle(1, 0x59ff32);
				this.selection1.graphics.drawRoundRect(1, 1, widt, dsa, 6, 6);
            }
         }
      }
		
	}

}