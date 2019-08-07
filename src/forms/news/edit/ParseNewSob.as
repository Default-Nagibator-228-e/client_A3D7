package forms.news.edit 
{
	
	import alternativa.init.Main;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import controls.DefaultButton;
	import controls.TankWindowInner;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.TankWindowWithHeader;
	import forms.news.edit.Nnews;
	import forms.news.edit.Nopros;
	
	public class ParseNewSob extends Sprite
	{
		
		private var win:TankWindowWithHeader = TankWindowWithHeader.createWindow("СЛУЖБА НОВОСТЕЙ");
		
		private var clbut:DefaultButton = new DefaultButton();
		
		private var obut:DefaultButton = new DefaultButton();
		
		private var edbut:DefaultButton = new DefaultButton();
		
		public var ini:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
		
		public var news:Nnews = new Nnews(600 - 22);
		
		public var opros:Nopros;
		
		public function ParseNewSob() 
		{
			addChild(win);
			win.width = 600;
			win.height = 460;
			clbut.label = "Закрыть";
			clbut.x = win.width - 11 - clbut.width;
			clbut.y = win.height - 11 - clbut.height;
			win.addChild(clbut);
			this.opros = new Nopros(600 - 22,this);
			parB("Новость", obut, null);
			parB("Опрос", edbut, obut);
			ini.x = obut.x;
			ini.y = obut.y + obut.height + 11;
			ini.width = 600 - 22;
			ini.height = clbut.y - ini.y - 11;
			win.addChild(ini);
			ini.addChild(this.news);
			ini.addChild(this.opros);
			this.news.y = ini.height / 2 - this.news.height / 2;
			this.opros.y = ini.height / 2 - this.opros.height/2;
			n(null);
			clbut.addEventListener(MouseEvent.CLICK, ch);
			obut.addEventListener(MouseEvent.CLICK, n);
			edbut.addEventListener(MouseEvent.CLICK, c);
			ini.addEventListener(MouseEvent.CLICK, this.news.unchd);
			ini.addEventListener(MouseEvent.CLICK, this.news.unchd1);
			ini.addEventListener(MouseEvent.CLICK, this.news.unchd2);
			this.opros.addEventListener("pops",r);
		}
		
		private function r(e:Event) : void
		  {
			 this.opros.y = ini.height / 2 - this.opros.height/2;
		  }
		
		private function n(e:Event) : void
		  {
			 edbut.enable = true;
			 obut.en();
			 this.opros.visible = false;
			 this.news.visible = true;
		  }
		  
		  private function c(e:Event) : void
		  {
			 obut.enable = true;
			 edbut.en();
			 this.opros.visible = true;
			 this.news.visible = false;
		  }
		
		public function parB(st:String,d:DefaultButton,b:DefaultButton) : void
		{
			d.label = st;
			if (b != null)
			{
				d.x = b.x + b.width + 8;
			}else{
				d.x = 11;
			}
			d.y = 11;
			d.width = new MainPanelBattlesButton().width;
			win.addChild(d);
		}
		
		public function ch(e:Event) : void
		{
			PanelModel(Main.osgi.getService(IPanel)).hideSob();
		}
		
	}

}