package forms.news 
{
	
	import alternativa.init.Main;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import controls.Label;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.shop.components.item.GridItemBase;
	
	public class AddLine extends GridItemBase
	{
		
		[Embed(source="2.png")]
		private static var add:Class;
		
		private var bit:Bitmap = new add();
		
		private var d:Label = new Label();
		
		private var sp:MovieClip = new MovieClip();
		
		private var wis:int = 0;
		
		public function AddLine() 
		{
			addChild(sp);
			sp.addChild(bit);
			d.text = "добавить событие";
			d.textColor = 8454016;
			sp.addChild(d);
			bit.height /= 4;
			bit.width /= 4;
			d.x = bit.width + 11;
			d.y = -4;
			//wis = d.x + d.textWidth;
			sp.buttonMode = true;
			sp.tabEnabled = false;
			d.mouseEnabled = false;
			this.addEventListener(MouseEvent.CLICK,start);
		}
		
		private function start(e:Event):void
		{
			PanelModel(Main.osgi.getService(IPanel)).showSob();
		}
		
		public function re(wid:int):void
		{
			sp.x = wid / 2 - this.width / 2;
		}
		
	}

}