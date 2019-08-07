package forms.itemscategory.skin 
{
	import alternativa.engine3d.core.View;
	import alternativa.init.Main;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	import alternativa.osgi.service.loader.ILoaderService;
	import alternativa.osgi.service.locale.ILocaleService;
	import forms.garage.ItemInfoPanel;
	import forms.garage.ItemPropertyIcon;
	import alternativa.tanks.locale.constants.TextConst;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import assets.icons.GarageItemBackground;
	import controls.Label;
	import controls.TankInput;
	import controls.TankWindowInner;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import forms.ColorConstants;
	import forms.TankWindowWithHeader;
	import forms.garage.GarageButton;

	
	public class Skin extends Sprite
	{
		
		private var windowSize:Point = new Point(496, 492);
		
		private const windowMargin:int = 12;
		
		public var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("Скины");
		
		private var windowInput:TankWindowInner = new TankWindowInner(1, 1, TankWindowInner.GREEN);
		
		private var gar:Sprite = new Sprite();
		
		private var buttonUpgrade:GarageButton = new GarageButton();
		
		private var gar1:Sprite = new Sprite();
		
		private var buttonUpgrade1:GarageButton = new GarageButton();
		
		private var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		
		private var closeButton:SkButton = new SkButton();
		
		private var lab:Label = new Label();
		
		private var lab1:Label = new Label();
		
		private var lab2:Label = new Label();
		
		private var lab3:Label = new Label();
		
		private var i:Sprite = new Sprite();
		
		private var id:String;
		
		private var i1:Sprite = new Sprite();
		
		private var sh:Boolean = false;
		
		public function Skin() 
		{
			super();
			gar.graphics.clear();
			gar.graphics.lineStyle(2, 0x59ff31);
			gar.graphics.drawRoundRect(0, 0, 200, 100, 6, 6);
			gar1.graphics.clear();
			gar1.graphics.lineStyle(2, 0x59ff31);
			gar1.graphics.drawRoundRect(0,0,200,200,6,6);
			//Network(Main.osgi.getService(INetworker)).send("garage;try_mount_item;" + id);
		}
		
		public function init(n:String,d:String,i3:String) : void 
		{
			id = i3;
			this.addChild(this.window);
			this.addChild(i1);
			i1.addChild(windowInput);
			i1.addChild(i);
			lab.text = "Стандартные настройки";
			lab.size = 18;
			lab.color = 381208;
			lab1.text = "Стандартные заводские настройки без специальных эффектов";
			lab1.color = 381208;
			lab1.multiline = true;
			lab1.wordWrap = true;
			lab1.width = lab.textWidth;
			//lab1.size = 18;
			lab2.text = n;
			lab2.size = 18;
			lab2.color = 381208;
			lab2.multiline = true;
			lab2.wordWrap = true;
			lab2.width = lab.textWidth;
			lab3.text = d;
			//lab3.size = 18;
			lab3.color = 381208;
			lab3.multiline = true;
			lab3.wordWrap = true;
			lab3.width = lab.textWidth;
			buttonUpgrade.label = "Купить";
			closeButton.label = "Закрыть";
			i1.addChild(closeButton);
			this.window.visible = false;
			i1.visible = false;
			i1.removeChild(windowInput);
			windowInput = new TankWindowInner(1, 1, TankWindowInner.GREEN);
			i1.addChild(windowInput);
			i1.removeChild(i);
			i = new Sprite();
			i1.addChild(i);
			i.addChild(gar);
			gar.addChild(buttonUpgrade);
			gar.addChild(lab);
			gar.addChild(lab1);
			i.addChild(gar1);
			gar1.addChild(buttonUpgrade1);
			gar1.addChild(lab2);
			gar1.addChild(lab3);
		}
		
		public function davay(cost:int,ch:Boolean = true) : void 
		{
			if (ch)
			{
				buttonUpgrade.label = "Установлено";
				buttonUpgrade.enable = false;
			}else{
				buttonUpgrade.label = "Установить";
				buttonUpgrade.enable = true;
				buttonUpgrade.addEventListener(MouseEvent.CLICK,dfet1);
			}
			if (cost > 0)
			{
				buttonUpgrade1.label = "Купить";
				if (PanelModel(Main.osgi.getService(IPanel))._crystal<cost)
				{
					buttonUpgrade1.setInfo(-cost, 0);
					buttonUpgrade1.enable = false;
					buttonUpgrade1.addEventListener(MouseEvent.CLICK,dfet);
				}else{
					buttonUpgrade1.setInfo(cost, 0);
					buttonUpgrade1.enable = true;
					buttonUpgrade1.addEventListener(MouseEvent.CLICK,dfet);
				}
			}else{
				if (ch)
				{
					buttonUpgrade1.label = "Установить";
					buttonUpgrade1.enable = true;
					buttonUpgrade1.setInfo(0, 0);
					buttonUpgrade1.addEventListener(MouseEvent.CLICK,dfet1);
				}else{
					buttonUpgrade1.label = "Установлено";
					buttonUpgrade1.enable = false;
					buttonUpgrade1.setInfo(0, 0);
				}
			}
			resize();
		}
		
		public function show() : void 
		{
			if (!sh)
			{
				this.window.visible = true;
				i1.visible = true;
				Main.blur();
				sh = true;
				Main.stage.addEventListener(Event.RESIZE, resize);
				closeButton.addEventListener(MouseEvent.CLICK, hide);
				buttonUpgrade.addEventListener(MouseEvent.CLICK,hop);
			}
		}
		
		public function dfet1(e:MouseEvent = null) : void 
		{
			Network(Main.osgi.getService(INetworker)).send("garage;sskin;" + id);
		}
		
		public function dfet(e:MouseEvent = null) : void 
		{
			Network(Main.osgi.getService(INetworker)).send("garage;bskin;" + id);
		}
		
		public function hide(e:MouseEvent = null) : void 
		{
			Main.unblur();
			this.window.visible = false;
			i1.visible = false;
			sh = false;
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
			gar.graphics.clear();
			gar.graphics.lineStyle(2, 0x59ff31);
			gar.graphics.drawRoundRect(0, 0, windowInput.width - windowMargin * 4, 100, 6, 6);
			gar1.y = windowInput.y + windowMargin + 100;
			gar1.graphics.clear();
			gar1.graphics.lineStyle(2, 0x59ff31);
			gar1.graphics.drawRoundRect(0,0,windowInput.width - windowMargin * 4,200,6,6);
			//gar.width = windowInput.width - windowMargin * 2;
			windowInput.height = windowMargin * 2;
			i.x = windowInput.x + windowMargin;
			i.y = windowInput.y + windowMargin;
			windowInput.height = windowMargin * 2 + i.height;
			closeButton.x = this.window.width - closeButton.width - windowMargin;
			closeButton.y = windowInput.y + windowInput.height + windowMargin;
			closeButton.width = 100;
			buttonUpgrade.x = (windowInput.width - windowMargin * 4) - buttonUpgrade.width - windowMargin * 2;
			buttonUpgrade.y = 50 - buttonUpgrade.height / 2;
			lab.x = 30;
			lab.y = 15;
			lab1.x = 30;
			lab1.y = lab.y + lab.height + 15;
			buttonUpgrade1.x = (windowInput.width - windowMargin * 4) - buttonUpgrade1.width - windowMargin * 2;
			buttonUpgrade1.y = 50 - buttonUpgrade1.height / 2;
			lab2.x = 30;
			lab2.y = 15;
			lab3.x = 30;
			lab3.y = lab2.y + lab2.height + 15;
			this.window.height = closeButton.y + closeButton.height + windowMargin;
			closeButton.y = windowInput.y + windowInput.height + windowMargin;
			this.x = Math.round((Main.stage.stageWidth - this.window.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - this.window.height) * 0.5);
		}
		
	}

}