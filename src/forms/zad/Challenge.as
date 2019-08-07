package forms.zad 
{
	
	import alternativa.init.ChatModelActivator;
	import alternativa.tanks.help.HelpService;
	import controls.Label;
	import controls.TankWindowInner;
	import controls.base.LabelBase;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import forms.progr.ChProgress;

	public class Challenge extends Sprite
	{
		
		[Embed(source="ch/Table.png")]
		private static const t:Class;
		
		[Embed(source="ch/cr.png")]
		private static const cr:Class;
		
		[Embed(source="ch/ci.png")]
		private static const ci:Class;
		
		[Embed(source="ch/mt.png")]
		private static const mt:Class;
		
		[Embed(source="ch/bt.png")]
		private static const bt:Class;
		
		[Embed(source="ch/zv.png")]
		private static const zv:Class;
		
		[Embed(source="ch/ch.png")]
		private static const ch:Class;
		
		private var ta:Bitmap = new t();
		public var mta:Bitmap = new bt();
		private var bta:Bitmap = new mt();
		private var cra:Bitmap = new cr();
		private var cia:Bitmap = new ci();
		private var zva:Bitmap = new zv();
		private var chaa:Bitmap = new ch();
		
		private var pr:ChProgress = new ChProgress();
		
		private var vip:Boolean = false;
		private var dontStartCountDown:Boolean = false;
		
		private var prl:LabelBase = new LabelBase();
		private var tprl:LabelBase = new LabelBase();
		private var chl:LabelBase = new LabelBase();
		private var typrl:Label = new Label();
		
		private var countDownTimer:Timer;
		
		private var part:int = 0;//текущий уровень
		private var mpart:int = 0;//максимальный уровень
		private var pro:int = 0;//баллы
		private var mpro:int = 0;//баллы до следующего уровня
		private var mpr:int = 0;//процент выполнения следующего уровня
		private var timeLimit:int = 0;
		private var currentTime:int = 0;
		public var countDown:int = 0;
		private var _timeLimit:int = 0;
		private var setupTime:int;
		
		public var list:PartsList = new PartsList();
		
		private var cha:TankWindowInner = new TankWindowInner(100, 100, TankWindowInner.TRANSPARENT);
		private var inn:TankWindowInner = new TankWindowInner(100, 100, TankWindowInner.GREEN);
		
		public function Challenge() 
		{
			super();
			addChild(ta);
			mta.y = ta.height + 3;
			addChild(mta);
			bta.y = mta.y + mta.height + 3;
			addChild(bta);
			cra.x = 5.5;
			cra.y = bta.y + (bta.height / 2 - cra.height/2);
			addChild(cra);
			cia.x = 5.5;
			cia.y = mta.y + (mta.height / 2 - cia.height/2);
			addChild(cia);
			pr.x = ta.width + 8;
			pr.redr(100);
			addChild(pr);
			zva.x = 5.5;
			zva.y = pr.height / 2 - zva.height / 2;
			pr.addChild(zva);
			prl.color = 0x12ff00;
			prl.text = "Звёзды 0/0";
			prl.x = zva.x + zva.width + 8;
			prl.y = pr.height / 2 - prl.height / 2;
			pr.addChild(prl);
			tprl.color = 0x12ff00;
			tprl.text = "0";
			tprl.x = ta.width / 2 - tprl.textWidth * 2;
			tprl.y = 2.5;
			tprl.size = 42;
			addChild(tprl);
			typrl.color = 0x12ff00;
			typrl.text = "Уровень";
			typrl.x = ta.width / 2 - typrl.textWidth / 1.25;
			typrl.y = tprl.y + (tprl.textHeight*0.75) + 2;
			typrl.size = 18;
			addChild(typrl);
			cha.x = pr.x + pr.width + 8;
			cha.width = 870 - cha.x - 24;
			cha.height = pr.height;
			addChild(cha);
			chaa.x = cha.x + 8;
			chaa.y = cha.height/2 - chaa.height/2;
			addChild(chaa);
			chl.x = chaa.x + chaa.width + 4;
			chl.text = "9ч 54м";
			chl.y = cha.height / 2 - chl.textHeight/2;
			addChild(chl);
			list.x = pr.x + 2.5;
			list.y = pr.height + 10.5;
			list.height = bta.y + bta.height - list.y + 5;
			list.width = cha.x + cha.width - ta.width - 13;
			inn.x = pr.x;
			inn.y = pr.height + 8;
			inn.height = bta.y + bta.height - inn.y;
			inn.width = cha.x + cha.width - ta.width - 8;
			list.fds = mta.y - list.y;
			list.fds1 = mta.height
			addChild(inn);
			addChild(list);
		}
		
		public function inf(zvc:int,mzvc:int,p:int) : void
		  {
			prl.text = "Звёзды " + zvc + "/" + mzvc;
			tprl.text = p + "";
			pr.redr(ChProgress.MAX_WIDTH * (zvc/mzvc));
		  }
		
		public function chas(cu:int,ti:int) : void
		  {
			 currentTime = cu;
			 timeLimit = ti;
			 if(timeLimit > 0)
			 {
				this.setupTime = getTimer();
				this.countDown = currentTime > 0?int(currentTime):int(timeLimit);
				this.dontStartCountDown = currentTime == 0;
				this._timeLimit = this.countDown;
				this.showCountDown();
			 }
		  }
		
		private function showCountDown() : void
		  {
			 this.countDownTimer = new Timer(500);
			 this.countDownTimer.addEventListener(TimerEvent.TIMER,this.showCountDownTick);
			 this.countDownTimer.start();
			 this.showCountDownTick();
		  }
		  
		private function showCountDownTick(e:TimerEvent = null) : void
		  {
			 var str:String = "";
			 var currentTimer:int = getTimer();
			 var day:int = int(this.countDown / 86400);//86400 //1440
			 var cho:int = int((this.countDown - (day * 86400)) / 3600);
			 var min:int = int((this.countDown - (cho * 3600)) / 3600);
			 var sec:int = int((this.countDown - (min * 3600)) / 3600);
			 var dfe:int = 0;
			 if (day != 0)
			 {
				 str += day + "д";
				 ++dfe;
			 }
			 if (cho != 0)
			 {
				 if (dfe > 0)
				 {
					 str += " ";
				 }
				 str += cho + "ч";
				 ++dfe;
			 }
			 if (min != 0 && dfe < 2)
			 {
				 if (dfe > 0)
				 {
					 str += " ";
				 }
				 str += min + "м";
				 ++dfe;
			 }
			 if (sec != 0 && dfe < 2)
			 {
				 if (dfe > 0)
				 {
					 str += " ";
				 }
				 str += sec > 9?sec + "с":"0" + sec + "с";
				 ++dfe;
			 }
			 chl.text = str;
			 if((this.countDown < 0 || this.dontStartCountDown) && this.countDownTimer != null)
			 {
				this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showCountDownTick);
				this.countDownTimer.stop();
				this.dontStartCountDown = false;
			 }
			 this.countDown = this._timeLimit - (currentTimer - this.setupTime) / 1000;
			 dispatchEvent(new Event(Event.CHANGE));
		  }
		
	}

}