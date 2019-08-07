package forms.garage.buttons 
{
	import flash.display.Sprite;

	public class Centerr extends Sprite
	{
		
		public var cn:Push = new Push();
		
		public var cn1:Corp = new Corp();
		
		public var cn2:Color = new Color();
		
		public var cn3:Prip = new Prip();
		
		public var cn4:Comp = new Comp();
		
		public function Centerr() 
		{
			super();
			addChild(cn);
			addChild(cn1);
			cn1.x = cn.width + 5;
			addChild(cn2);
			cn2.x = cn1.x + cn1.width + 5;
			addChild(cn3);
			cn3.x = cn2.x + cn2.width + 5;
			addChild(cn4);
			cn4.x = cn3.x + cn3.width + 5;
		}
		
	}

}