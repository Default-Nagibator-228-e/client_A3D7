package forms.news.edit 
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
	
	public class AddLine extends Sprite
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
			d.text = "добавить столбец";
			d.textColor = 8454016;
			sp.addChild(d);
			bit.height /= 4;
			bit.width /= 4;
			d.x = bit.width + 11;
			d.y = -4;
			sp.buttonMode = true;
			sp.tabEnabled = false;
			d.mouseEnabled = false;
		}
		
	}

}