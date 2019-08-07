package forms.zad 
{
	import alternativa.init.Main;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import controls.DefaultButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.TankWindowWithHeader;

	public class Zadan extends Sprite
	{
		
		private var win:TankWindowWithHeader = TankWindowWithHeader.createWindow("ЗАДАНИЯ");
		
		private var obut:DefaultButton = new DefaultButton();
		
		private var edbut:DefaultButton = new DefaultButton();
		
		private var enbut:DefaultButton = new DefaultButton();
		
		private var chbut:DefaultButton = new DefaultButton();
		
		private var clbut:DefaultButton = new DefaultButton();
		
		private var i1:MainPanelBattlesButton = new MainPanelBattlesButton();
		
		public var ch:Challenge = new Challenge();
		
		public function Zadan() 
		{
			super();
			win.width = 870;
			win.height = 460;
			parB("Основные",obut,null,false);
			parB("Ежедневные",edbut,obut,false);
			parB("Еженедельные", enbut, edbut,false);
			parB("Челленджи", chbut, enbut, true);
			chbut.en();
			clbut.label = "Закрыть";
			clbut.x = win.width - 11 - clbut.width;
			clbut.y = win.height - 11 - clbut.height;
			win.addChild(clbut);
			this.ch.x = 11;
			this.ch.y = obut.y + obut.height + 8;
			win.addChild(this.ch);
		}
		
		public function ch0(e:Event) : void
		{
			PanelModel(Main.osgi.getService(IPanel)).hideZadan();
		}
		
		public function parB(st:String,d:DefaultButton,b:DefaultButton,r:Boolean) : void
		{
			d.label = st;
			if (b != null)
			{
				d.x = b.x + b.width + 8;
			}else{
				d.x = 11;
			}
			d.y = 11;
			d.enable = r;
			d.width = this.ch.mta.width;
			win.addChild(d);
		}
		
		public function show() : void
		{
			hide();
			if (win != null)
			{
				addChild(win);
			}
			Main.stage.addEventListener(Event.RESIZE, rs);
			clbut.addEventListener(MouseEvent.CLICK,ch0);
			rs();
		}
		
		public function hide() : void
		{
			if (contains(win) && win != null)
			{
				removeChild(win);
			}
			Main.stage.removeEventListener(Event.RESIZE, rs);
			clbut.removeEventListener(MouseEvent.CLICK,ch0);
		}
		
		private function rs(e:Event = null) : void
		{
			win.x = Math.round((Main.stage.stageWidth - 870) * 0.5);
			win.y = Math.round((Main.stage.stageHeight - 460) * 0.5);
		}
		
	}

}