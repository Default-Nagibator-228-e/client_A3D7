package forms.news 
{
	import controls.TankWindowInner;
	import fl.events.ScrollEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import forms.Communic;
	
	public class News extends Sprite
	{
		
		private var mod:Communic;
		
		public var output:NewsOutput = new NewsOutput();
		
		private var delayTimer:Timer;
		
		public function News(m:Communic) 
		{
			super();
			mod = m;
			addEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		private function ini(e:Event):void
		{
			this.output.x = 11;
			this.output.y = this.mod.cha.y + this.mod.cha.height + 4;
			this.addChild(this.output);
		}
		
		public function res(widt:int,hei:int):void
		{
			this.output.setSize(widt - 22, hei - 55);
		}
		
	}

}