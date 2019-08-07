package alternativa.tanks.models.battlefield.gui 
{
	import alternativa.init.Main;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	import alternativa.tanks.model.panel.PanelModel;
	import assets.icons.InputCheckIcon;
	import controls.Label;
	import controls.TankInput;
	import controls.base.LabelBase;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Physics extends Sprite
	{
		[Embed(source="l.png")]
		private var l:Class;
		[Embed(source="r.png")]
		private var r:Class;
		
		private var bat:BattleController;
		
		private var sp:Vector.<Sprite> = new Vector.<Sprite>();
		
		private var inp:Vector.<TankInput> = new Vector.<TankInput>();
		
		private var turr:Boolean = true;
		
		private var mod:int = 0;
		
		private var p:int = 0;
		
		private var p1:int = 0;
		
		private var df3:LabelBase = new LabelBase();
		
		private var df4:LabelBase = new LabelBase();
		
		private var df7:Sprite = new Sprite();
		
		private var df8:Sprite = new Sprite();
		
		private var df9:Sprite = new Sprite();
		
		private var df10:Sprite = new Sprite();
		
		private var dsw:Sprite = new Sprite();
		
		private var scr:ScrollPane = new ScrollPane();
		
		public function Physics() 
		{
			super();
			bat = BattleController(Main.osgi.getService(IBattleController));
			Main.contentUILayer.addChild(this);
			this.visible = false;
			//trace(4);
			//now();
			er();
		}
		
		private function d(n:MouseEvent) : void
		{
			del();
			turr = !turr;
			now();
		}
		
		private function d1(n:MouseEvent) : void
		{
			del();
			mod += 1;
			now();
		}
		
		private function d2(n:MouseEvent) : void
		{
			del();
			mod -= 1;
			now();
		}
		
		private function d3(n:MouseEvent) : void
		{
			if (turr)
			{
				for (var gg:int = 0; gg < inp.length; gg++)
				{
					bat.mt[mod][bat.pmt[gg]] = inp[gg].textField.text;
					trace(bat.mt[mod][bat.pmt[gg]] + " g " + inp[gg].textField.text);
				}
			}
			if (!turr)
			{
				for (var gg:int = 0; gg < inp.length; gg++)
				{
					bat.mh[mod][bat.pmh[gg]] = inp[gg].textField.text;
				}
			}
			var parsert:Object = bat.mt as Object;
			var parserh:Object = bat.mh as Object;
			Network(Main.osgi.getService(INetworker)).send("battle;physics;" + JSON.stringify(parsert) + ";" + JSON.stringify(parserh) + ";");
		}
		
		private function skrol() : void
		{
			scr.horizontalScrollPolicy = ScrollPolicy.OFF;
			scr.focusEnabled = false;
			scr.source = dsw;
			this.addChild(scr);
			scr.width *= 3.5;
			scr.height *= 2.5;
		}
		
		private function gkn() : void
		{
			df10 = new Sprite();
			df10.graphics.beginFill(0, 0.6);
			df10.graphics.drawRoundRect(0, 0, 75, 40,6,6);
			df10.graphics.endFill();
			var dfe:TextField = new TextField();
			dfe.text = "Send!";
			dfe.selectable = false;
			dfe.textColor = 0xFFFFFF;
			df10.addChild(dfe);
			dfe.x = (75-dfe.textWidth)*0.5 - 1;
			dfe.y = (40-dfe.textHeight)*0.5 - 2;
			Main.contentUILayer.addChild(df10);
			df10.x = Math.round((Main.stage.stageWidth - df10.width) * 0.5);
			df10.y = Main.stage.stageHeight - df10.height - 20;
			df10.addEventListener(MouseEvent.CLICK, d3);
		}
		
		private function now() : void
		{
			//trace(2);
			df3.text = turr ? "Turret":"Hull";
			df4.text = "Модификация: " + mod;
			df3.scaleX = 4;
			df3.scaleY = 4;
			df4.scaleX = 2;
			df4.scaleY = 2;
			inp = new Vector.<TankInput>();
			this.x = Math.round((Main.stage.stageWidth - this.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - this.height) * 0.5);
			df3.x = Math.round((Main.stage.stageWidth - df3.width) * 0.5);
			df3.y = 50;
			df4.x = Math.round((Main.stage.stageWidth - df4.width) * 0.5);
			df4.y = 150;
			Main.contentUILayer.addChild(df3);
			Main.contentUILayer.addChild(df4);
			df7 = gk();
			if (mod + 1 < 4)
			{
				df8 = gm(true);
				df8.y = df4.y;
				df8.x = Main.contentUILayer.stage.stageWidth - df8.width - 20;
				Main.contentUILayer.addChild(df8);
				df8.addEventListener(MouseEvent.CLICK, d1);
			}
			if (mod - 1 > -1)
			{
				df9 = gm(false);
				df9.y = df4.y;
				df9.x = 20;
				Main.contentUILayer.addChild(df9);
				df9.addEventListener(MouseEvent.CLICK, d2);
			}
			df7.y = df3.y;
			df7.x = Main.contentUILayer.stage.stageWidth - df7.width - 20;
			Main.contentUILayer.addChild(df7);
			skrol();
			if (turr)
			{
				while (p < bat.pmt.length)
				{
					ne();
				}
			}
			if (!turr)
			{
				while (p < bat.pmh.length)
				{
					ne();
				}
			}
			ne1();
			gkn();
			Main.stage.addEventListener(Event.RESIZE, res);
			df7.addEventListener(MouseEvent.CLICK, d);
			res();
		}
		
		private function del() : void
		{
			//throw new Error();
			Main.stage.removeEventListener(Event.RESIZE, res);
			df7.removeEventListener(MouseEvent.CLICK, d);
			df8.removeEventListener(MouseEvent.CLICK, d1);
			df9.removeEventListener(MouseEvent.CLICK, d2);
			df10.removeEventListener(MouseEvent.CLICK, d3);
			this.removeChild(scr);
			scr = new ScrollPane();
			dsw = new Sprite();
			Main.contentUILayer.removeChild(df3);
			Main.contentUILayer.removeChild(df4);
			Main.contentUILayer.removeChild(df7);
			if (Main.contentUILayer.contains(df8))
			{
				Main.contentUILayer.removeChild(df8);
			}
			//throw new Error();
			if (Main.contentUILayer.contains(df9))
			{
				Main.contentUILayer.removeChild(df9);
			}
			Main.contentUILayer.removeChild(df10);
			df7 = new Sprite();
			df8 = new Sprite();
			df9 = new Sprite();
			df10 = new Sprite();
			p = 0;
		}
		
		private function res(n:Event = null) : void
		{
			this.x = Math.round((Main.stage.stageWidth - scr.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - scr.height) * 0.5) + 10;
			df3.x = Math.round((Main.stage.stageWidth - df3.width) * 0.5);
			df4.x = Math.round((Main.stage.stageWidth - df4.width) * 0.5);
			df7.x = Main.contentUILayer.stage.stageWidth - df7.width - 20;
			if (Main.contentUILayer.stage.contains(df8))
			{
				df8.x = Main.contentUILayer.stage.stageWidth - df8.width - 20;
			}
			df10.x = Math.round((Main.stage.stageWidth - df10.width) * 0.5);
			df10.y = Main.stage.stageHeight - df10.height - 20;
		}
		
		private function gk() : Sprite
		{
			var df:Sprite = new Sprite();
			var df5:LabelBase = new LabelBase();
			var df6:Bitmap = new r();
			df6.scaleX = 0.0625;
			df6.scaleY = 0.0625;
			df5.text = turr ? "Hull":"Turret";
			df5.scaleX = 2;
			df5.scaleY = 2;
			df.addChild(df5);
			df6.x = df5.textWidth;
			df.addChild(df6);
			df5.y = Math.round((df.height - df5.height) * 0.5);
			return df;
		}
		
		private function gm(v:Boolean) : Sprite
		{
			var df:Sprite = new Sprite();
			var df5:LabelBase = new LabelBase();
			if (v)
			{
				var df6:Bitmap = new r();
				df6.scaleX = 0.03125;
				df6.scaleY = 0.03125;
				df5.text = "Модификация: " + (mod + 1);
				df.addChild(df5);
				df6.x = df5.textWidth;
				df.addChild(df6);
				df5.y = Math.round((df.height - df5.height) * 0.5);
			}else{
				var df6:Bitmap = new l();
				df6.scaleX = 0.03125;
				df6.scaleY = 0.03125;
				df5.text = "Модификация: " + (mod - 1);
				df.addChild(df5);
				df.addChild(df6);
				df5.x = df6.width;
				df5.y = Math.round((df.height - df5.height) * 0.5);
			}
			return df;
		}
		
		private function ne1() : void
		{
			var df:Sprite = new Sprite();
			var df1:LabelBase = new LabelBase();
			if (turr)
			{
				df1.text = bat.pmt[p] + ": ";
			}else{
				df1.text = bat.pmh[p] + ": ";
			}
			df.addChild(df1);
			df1.visible = false;
			df.y = dsw.height + 10;
			this.x = Math.round((Main.stage.stageWidth - scr.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - scr.height) * 0.5);
			dsw.addChild(df);
			scr.update();
			p++;
		}
		
		private function ne() : void
		{
			var df:Sprite = new Sprite();
			var df1:LabelBase = new LabelBase();
			var df2:TankInput = new TankInput();
			inp.push(df2);
			sp.push(df);
			if (turr)
			{
				df1.text = bat.pmt[p] + ": ";
			}else{
				df1.text = bat.pmh[p] + ": ";
			}
			df.addChild(df1);
			df2.textField.text = turr ? bat.mt[mod][bat.pmt[p]]: bat.mh[mod][bat.pmh[p]];
			//df2.textField.text += parseFloat();
			if (p == 0)
			{
				p1 = df1.textWidth + 80;
			}
			df2.x = p1;
			df.addChild(df2);
			df1.y = Math.round((df.height - df1.height) * 0.5);
			//this.addChild(df);
			df.y = dsw.height + 10;
			this.x = Math.round((Main.stage.stageWidth - scr.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - scr.height) * 0.5);
			dsw.addChild(df);
			scr.update();
			p++;
		}
		
		public function er() : void
		{
			//turr = true;
			//mod = 0;
			!this.visible ? now() : del();
			this.visible = !this.visible;
		}
	}

}