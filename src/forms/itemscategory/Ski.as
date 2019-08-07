package forms.itemscategory 
{
	import alternativa.init.Main;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	import forms.itemscategory.skin.Skin;
	import forms.shop.components.item.GridItemBase;
	import fl.events.ListEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Ski extends GridItemBase
	{
		
		[Embed(source="1.png")]
		private static const gg:Class;
		public var ded:Bitmap = new gg();
		private var n:String;
		private var d:String;
		private var id:String;
		public var sde:Skin = new Skin();
		
		public function Ski(f:String,sa:String,dst:String) 
		{
			n = f;
			d = sa;
			id = dst;
			super();
			addChild(this.ded);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, this.sd);
		}
		
		public function sd(e:Event) : void
		{
			Main.stage.addChild(sde);
			sde.init(n, d, id);
			Network(Main.osgi.getService(INetworker)).send("garage;skin;" + id);
			//sde.davay(500000);
			//sde.show();
		}
		
	}

}