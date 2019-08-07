package forms.upgrade 
{
	import alternativa.engine3d.core.View;
	import alternativa.init.Main;
	import alternativa.osgi.service.loader.ILoaderService;
	import alternativa.osgi.service.locale.ILocaleService;
	import forms.garage.ItemInfoPanel;
	import forms.garage.ItemPropertyIcon;
	import alternativa.tanks.locale.constants.TextConst;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import controls.Label;
	import controls.TankInput;
	import controls.TankWindowInner;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import forms.TankWindowWithHeader;
	import forms.garage.GarageButton;

	
	public class UpgradeWindow extends Sprite
	{
      
      [Embed(source="1.png")]
      private static const gg:Class;
      
      private static const ggh:BitmapData = new gg().bitmapData;
		
		private var windowSize:Point = new Point(496, 492);
		
		private const windowMargin:int = 12;
		
		public var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("УЛУЧШЕНИЯ");
		
		private var windowInput:TankWindowInner = new TankWindowInner(1,1,TankWindowInner.GREEN);
		
		private var progress:UpgradeProgressForm = new UpgradeProgressForm();
		
		private var prog:Label = new Label();
		
		private var buttonUpgrade:GarageButton = new GarageButton();
		
		private var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		
		private var closeButton:UpgrButton = new UpgrButton();
		
		private var imgs:Array;
		
		private var i:Sprite = new Sprite();
		
		private var i1:Sprite = new Sprite();
		
		private var od:PropertyIcon;
		
		private var v:Boolean = false;
		
		private var vi:Array = new Array();
		
		private var fk:Array = new Array();
		
		private var fe:Bitmap = new Bitmap(ggh);
		
		public function UpgradeWindow() 
		{
			super();
			//od = new PropertyIcon(areaBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
			//Network(Main.osgi.getService(INetworker)).send("garage;try_mount_item;" + id);
			//imgs = new Array(new ItemPropertyIcon(areaBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT)), new ItemPropertyIcon(armorBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEALTH_UNIT_TEXT)), new ItemPropertyIcon(damageBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEALTH_UNIT_TEXT)), new ItemPropertyIcon(damageBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT)), new ItemPropertyIcon(energyConsumptionBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_POWER_UNIT_TEXT)), new ItemPropertyIcon(powerBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_POWER_UNIT_TEXT)), new ItemPropertyIcon(rangeBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT)), new ItemPropertyIcon(rateOfFireBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RATE_OF_FIRE_UNIT_TEXT)), new ItemPropertyIcon(resourceBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_UNIT_TEXT)), new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_UNIT_TEXT)), new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_SHOT_WEAR_UNIT_TEXT)), new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_TIME_WEAR_UNIT_TEXT)), new ItemPropertyIcon(resourceWearBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_SHOT_TIME_WEAR_UNIT_TEXT)), new ItemPropertyIcon(spreadBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_ANGLE_UNIT_TEXT)), new ItemPropertyIcon(turretRotationRateBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_TURN_SPEED_UNIT_TEXT)), new ItemPropertyIcon(spreadBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_ANGLE_UNIT_TEXT)), new ItemPropertyIcon(speedBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_SPEED_UNIT_TEXT)), new ItemPropertyIcon(turnspeedBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_TURN_SPEED_UNIT_TEXT)), new ItemPropertyIcon(mechResistanceBd, "%"), new ItemPropertyIcon(fireResistanceBd, "%"), new ItemPropertyIcon(plasmaResistanceBd, "%"), new ItemPropertyIcon(railResistanceBd, "%"), new ItemPropertyIcon(vampireResistanceBd, "%"), new ItemPropertyIcon(thunderResistanceBd, "%"), new ItemPropertyIcon(freezeResistanceBd, "%"), new ItemPropertyIcon(ricochetResistanceBd, "%"), new ItemPropertyIcon(healingRadiusBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT)), new ItemPropertyIcon(healRateBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT)), new ItemPropertyIcon(vampireRateBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT)));
		}
		
		public function init() : void 
		{
			this.addChild(this.window);
			this.addChild(i1);
			i1.addChild(windowInput);
			i1.addChild(i);
			i1.addChild(progress);
			prog.text = "Прогресс: 0/10"
			//i1.addChild(prog);
			buttonUpgrade.label = "Улучшить";
			i1.addChild(buttonUpgrade);
			closeButton.label = "Закрыть";
			i1.addChild(closeButton);
			this.window.visible = false;
			i1.visible = false;
		}
		
		public function davay(p:int,p1:Array,p2:Array,p3:Array,cost:int) : void 
		{
			buttonUpgrade.setInfo(cost, 0);
			if (PanelModel(Main.osgi.getService(IPanel))._crystal<cost)
			{
				buttonUpgrade.setInfo(-cost, 0);
				buttonUpgrade.enable = false;
			}else{
				buttonUpgrade.enable = true;
			}
			vi = new Array();
			i1.removeChild(windowInput);
			windowInput = new TankWindowInner(1, 1, TankWindowInner.GREEN);
			i1.addChild(windowInput);
			i1.removeChild(i);
			i = new Sprite();
			i1.addChild(i);
			resize();
			progress.lev = p;
			progress.update();
			//prog.text = "Прогресс: " + p + "/10";
			for (var fj:int = 0; fj < ItemInfoPanel.por.visibleIcons.length; fj++)
			{
				vi[fj] = ItemInfoPanel.por.visibleIcons[fj].clone();
			}
			var fk:Array = new Array();
			var d:Array = new Array();
			var d1:Array = new Array();
			var d2:Array = new Array();
			var d3:Array = new Array();
			//throw new Error(p2 + "ee");
			for (var ggj:int = 0; ggj < vi.length; ggj++)
			{
				var fl:PropertyIcon = vi[ggj];
				//throw new Error(p1);
				for (var ip:int = 0; ip < p1.length; ip++)
				{
					var h:Label = new Label();
					h.color = 65291;
					//throw new Error(p2[ip1]);
					if (p2[ip] == 0 || p2[ip] == null)
					{
						h.color = 16580352;
					}
					//throw new Error(p1[ip]);
					h.text = p1[ip] + "";
					d.push(h);
				}
				for (var ip1:int = 0; ip1 < p2.length; ip1++)
				{
					//throw new Error(p2);
					//if (p2[ip1] == 0 || p2[ip1] == null)
					//{
						//throw new Error(p2 + "	 " + ip1 + "	 " + p2.length);
						//break;
					//}else{
						var h1:Label = new Label();
						h1.text = "+" + p2[ip1];
						//throw new Error(p2[ip1] + "	 " + p2.length);
						if (p2[ip1] < 0)
						{
							h1.text = "" + p2[ip1];
						}
						d1.push(h1);
						d3.push(new Bitmap(ggh));
						//d1.push(h1);
						//d3.push(new Bitmap(ggh));
					//}
				}
				for (var ip2:int = 0; ip2 < p3.length; ip2++)
				{
					var h2:Label = new Label();
					h2.color = 65291;
					if (p2[ip2] == 0 || p2[ip2] == null)
					{
						h2.color = 16580352;
						d1[ip2] = null;
						d3[ip2] = null;
					}
					h2.text = p3[ip2] + "";
					d2.push(h2);
				}
				i.addChild(fl);
				i.addChild(d[ggj]);
				buttonUpgrade.visible = false;
				if (d1[ggj] != null)
				{
					i.addChild(d3[ggj]);
					i.addChild(d1[ggj]);
					buttonUpgrade.visible = true;
				}
				if (d2[ggj] != null)
				{
					i.addChild(d2[ggj]);
					buttonUpgrade.visible = true;
				}
				d[ggj].x = 496 / 2;
				if (d1[ggj] != null)
				{
					d1[ggj].x = (496 / 1.5) - 20;
					d3[ggj].x = (496 / 1.5) - 20;
				}
				if (d2[ggj] != null)
				{
					d2[ggj].x = (496 / 1.25) - 20;
				}
				if (ggj == 0)
				{
					fl.y = 0;
					d[ggj].y = fl.height / 4;
					if (d1[ggj] != null)
					{
						d3[ggj].y = fl.height / 4;
						d1[ggj].y = fl.height / 4;
					}
					if (d2[ggj] != null)
					{
						d2[ggj].y = fl.height / 4;
					}
				}else{
					if (fk[ggj - 1] != null)
					{
						fl.y = fk[ggj - 1].y + windowMargin + fk[ggj - 1].height;
						d[ggj].y = d[ggj - 1].y + fl.height + windowMargin;
						if (d1[ggj] != null)
						{
							d3[ggj].y = d3[ggj - 1].y + fl.height + windowMargin;
							d1[ggj].y = d1[ggj - 1].y + fl.height + windowMargin;
						}
						if (d2[ggj] != null)
						{
							d2[ggj].y = d2[ggj - 1].y + fl.height + windowMargin;
						}
					}
				}
				fk.push(fl);
			}
			resize();
		}
		
		public function show() : void 
		{
			this.window.visible = true;
			i1.visible = true;
			Main.stage.addEventListener(Event.RESIZE, resize);
			closeButton.addEventListener(MouseEvent.CLICK, hide);
			buttonUpgrade.addEventListener(MouseEvent.CLICK,hop);
		}
		
		public function hide(e:MouseEvent = null) : void 
		{
			Main.unblur();
			this.window.visible = false;
			i1.visible = false;
			Main.stage.removeEventListener(Event.RESIZE, resize);
			closeButton.removeEventListener(MouseEvent.CLICK,hide);
			buttonUpgrade.removeEventListener(MouseEvent.CLICK,hop);
		}
		
		public function hop(e:Event = null) : void 
		{
			dispatchEvent(new Event("Da"))
		}
		
		public function destroy() : void 
		{
			this.removeChild(this.window);
			this.removeChild(i1);
			Main.stage.removeEventListener(Event.RESIZE, resize);
			closeButton.removeEventListener(MouseEvent.CLICK, hide);
			buttonUpgrade.removeEventListener(MouseEvent.CLICK,hop);
		}
		
		public function resize(e:Event = null) : void 
		{
			this.window.width = windowSize.x;
			windowInput.x = windowMargin;
			windowInput.y = windowMargin;
			windowInput.width = this.window.width - windowMargin * 2;
			windowInput.height = windowMargin * 2 + vi.length * 30;
			i.x = windowInput.x + windowMargin;
			i.y = windowInput.y + windowMargin;
			windowInput.height = windowMargin * 2 + i.height;
			progress.width = windowInput.width;
			progress.x = windowMargin;
			progress.y = windowInput.y + windowInput.height + windowMargin;
			//prog.x = Math.round((window.width - prog.width) * 0.5);
			//prog.y = progress.y + 7.5;
			closeButton.x = this.window.width - closeButton.width - windowMargin;
			closeButton.y = this.window.height - closeButton.height - windowMargin;
			closeButton.width = 100;
			buttonUpgrade.x = this.window.width/2 - buttonUpgrade.width/2;
			buttonUpgrade.y = progress.y + progress.height + windowMargin;
			//progress.DEFAULT_HEIGHT = buttonUpgrade.height;
			//progress.r(progress._bgdRightIcon,true,1);
			//progress.r(progress._bgdLeftIcon, true);
			//progress.r(progress._progressLine,true, 3);
			//progress.r(progress.bgdCenterBitmapData, false, 0);
			//prog.y = progress.y + progress.height / 6;
			//progress.resize();
			this.window.height = buttonUpgrade.y + buttonUpgrade.height + windowMargin;
			closeButton.y = this.window.height - closeButton.height - windowMargin;
		}
		
	}

}