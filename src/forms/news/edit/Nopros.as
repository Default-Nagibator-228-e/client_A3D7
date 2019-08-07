package forms.news.edit 
{
	import alternativa.init.Main;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	import controls.Label;
	import controls.TankInput;
	import controls.base.LabelBase;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import forms.ColorConstants;
	import utils.FontParamsUtil;
	
	public class Nopros extends Sprite
	{
		
		[Embed(source="1.png")]
		private static var add:Class;
		
		[Embed(source="3.png")]
		private static var add1:Class;
		
		[Embed(source="4.png")]
		private static var add2:Class;
		
		public var d:Label = new Label();
		
		public var cd:TankInput = new TankInput();
		
		public var cd1:TankInput = new TankInput();
		
		public var cd2:TankInput = new TankInput();
		
		public var cd3:TankInput = new TankInput();
		
		private var sp:Sprite = new Sprite();
		
		private var sp1:Sprite = new Sprite();
		
		private var sp2:Sprite = new Sprite();
		
		private var sp3:Sprite = new Sprite();
		
		private var sp4:Sprite = new Sprite();
		
		private var sp5:Sprite = new Sprite();
		
		private var bit:Bitmap = new add();
		
		private var bit1:Bitmap = new add1();
		
		private var bit2:Bitmap = new add2();
		
		private var file:FileReference;
		
		private var loade:Loader;
		
		public var output:LabelBase;
	  
		public var output1:Label;
		
		private var lin:Array = new Array();
		
		public var od:AddLine = new AddLine();
		
		private var o1:ParseNewSob;
		
		private var fil:String;
		
		public function Nopros(w:int,o:ParseNewSob) 
		{
			super();
			o1 = o;
			addChild(sp);
			addChild(sp1);
			addChild(sp5);
			addChild(sp2);
			addChild(sp3);
			addChild(sp4);
			sp.y = 15;
			var da:Date = new Date();
			bit1.width = bit.width + 44;
			bit1.height = bit.height + 44;
			bit1.visible = false;
			bit.x = 22;
			bit.y = 22;
			d.textColor = 8454016;
			d.text = par(da.getDay()) + "." + par(da.getMonth()) + "." + par(da.getFullYear());
			d.mouseEnabled = false;
			sp.addChild(bit);
			sp.addChild(bit1);
			sp.buttonMode = true;
			sp.tabEnabled = false;
			sp1.buttonMode = true;
			sp1.tabEnabled = false;
			sp1.addChild(cd);
			cd.visible = false;
			sp1.x = w / 2 - d.textWidth / 2;
			sp1.addChild(d);
			innnicolons();
			innnitext();
			sp4.buttonMode = true;
			sp4.tabEnabled = false;
			bit2.width /= 20;
			bit2.height /= 20;
			sp4.x = sp2.x + 389;
			sp4.y = (sp.y + bit1.height/2) - bit2.height/2;
			sp4.addChild(bit2);
			sp.addEventListener(MouseEvent.CLICK, sdfee);
			sp1.addEventListener(MouseEvent.CLICK, chd);
			sp4.addEventListener(MouseEvent.CLICK, sdfee1);
			o.ini.addEventListener(MouseEvent.CLICK, unchd);
			o.ini.addEventListener(MouseEvent.CLICK, unchd1);
			o.ini.addEventListener(MouseEvent.CLICK, unchd2);
			//this.parent.addEventListener(MouseEvent.CLICK, unchd);
		}
		
		public function innnitext() : void
		{
			output = new LabelBase();
			output1 = new Label();
			output.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			output.thickness = 100;
			output1.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			output1.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
			output.size = 10;
			output1.size = 10;
			output.text = "Заголовок";
			output1.multiline = true;
			//output1.wordWrap = true;
			output1.text = "Текст";
			output.textColor = ColorConstants.GREEN_LABEL;
			output1.textColor = ColorConstants.GREEN_LABEL;
			output.mouseEnabled = false;
			output1.mouseEnabled = false;
			sp2.buttonMode = true;
			sp2.tabEnabled = false;
			sp3.buttonMode = true;
			sp3.tabEnabled = false;
			sp2.addChild(output);
			sp3.addChild(output1);
			sp2.addChild(cd1);
			sp3.addChild(cd2);
			cd1.visible = false;
			cd2.visible = false;
			sp2.y = sp5.height + sp5.y + 11;
			sp2.x = sp3.x = bit1.width + 11;
			sp3.y = sp2.y + output.textHeight + 6;
			sp2.addEventListener(MouseEvent.CLICK, chd1);
			sp3.addEventListener(MouseEvent.CLICK, chd2);
			cd1.textField.addEventListener(Event.CHANGE, csd1);
			cd2.textField.addEventListener(Event.CHANGE, csd1);
		}
		
		public function rescol() : void
		{
			sp2.y = sp5.height + sp5.y + 11;
			sp3.y = sp2.y + output.textHeight + 6;
		}
		
		public function innnicolons() : void
		{
			sp5.y = 15 + 22;
			sp5.x = bit1.width + 11;
			var dsw:LineOp = new LineOp("столбец1", false);
			sp5.addChild(dsw);
			o1.ini.addEventListener(MouseEvent.CLICK, dsw.unchd);
			var dsw1:LineOp = new LineOp("столбец2", false);
			o1.ini.addEventListener(MouseEvent.CLICK, dsw1.unchd);
			lin.push(dsw,dsw1);
			dsw1.y = dsw.height + 11;
			sp5.addChild(dsw1);
			od.y = dsw1.y + dsw1.height + 11;
			sp5.addChild(od);
			od.addEventListener(MouseEvent.CLICK, cp);
		}
		
		public function cp(e:Event) : void
		{
			var dsw:LineOp = new LineOp("столбец");
			sp5.addChild(dsw);
			o1.ini.addEventListener(MouseEvent.CLICK, dsw.unchd);
			dsw.y = od.y;
			od.y = dsw.y + dsw.height + 11;
			dsw.addEventListener("gfijk",function(e:Event) : void
			{
				lin.removeAt(lin.indexOf(dsw));
				sp5.removeChild(dsw);
				o1.ini.removeEventListener(MouseEvent.CLICK, dsw.unchd);
				od.y = lin[lin.length-1].y + lin[lin.length-1].height + 11;
				rescol();
				dsw = null;
				dispatchEvent(new Event("pops"));
			});
			rescol();
			lin.push(dsw);
			dispatchEvent(new Event("pops"));
		}
		
		public function csd1(e:Event) : void
		{
			//cd1.textField.height = cd1.textField.textHeight+10;
			cd2.textField.height = cd2.textField.textHeight+10;
		}
		
		public function chd1(e:Event) : void
		{
			cd1.width = 378;
			if (output.text != "             ")
			{
				cd1.textField.text = output.text;
			}
			cd1.textField.multiline = true;
			//cd1.scaleY = 3;
			//cd1.textField.height = 200;
			output.visible = false;
			cd1.visible = true;
			sp3.visible = false;
		}
		
		public function unchd1(e:Event) : void
		{
			if (e.target == sp1 || e.target == cd1.textField || e.target == sp || e.target == sp2 || e.target == sp3 || !cd1.visible)
			{
				//throw new Error("sdsdff");
				return;
			}
			if (cd1.textField.text == "")
			{
				output.text = "             ";
			}else{
				output.text = cd1.textField.text;
			}
			output.visible = true;
			cd1.visible = false;
			sp3.visible = true;
		}
		
		public function chd2(e:Event) : void
		{
			cd2.width = 378;
			if (output1.text != "             ")
			{
				cd2.textField.text = output1.text;
			}
			cd2.textField.multiline = true;
			//cd2.textField.height = 200;
			output1.visible = false;
			cd2.visible = true;
			sp2.visible = false;
		}
		
		public function unchd2(e:Event) : void
		{
			if (e.target == sp1 || e.target == cd2.textField || e.target == sp || e.target == sp2 || e.target == sp3 || !cd2.visible)
			{
				//throw new Error("sdsdff");
				return;
			}
			if (cd2.textField.text == "")
			{
				output1.text = "             ";
			}else{
				output1.text = cd2.textField.text;
			}
			output1.visible = true;
			cd2.visible = false;
			sp2.visible = true;
		}
		
		public function chd(e:Event) : void
		{
			cd.width = d.textWidth + 15;
			if (d.text != "             ")
			{
				cd.textField.text = d.text;
			}
			d.visible = false;
			cd.visible = true;
		}
		
		public function unchd(e:Event) : void
		{
			if (e.target == sp1 || e.target == cd.textField || e.target == sp || e.target == sp2 || e.target == sp3 || !cd.visible)
			{
				//throw new Error("sdsdff");
				return;
			}
			if (cd.textField.text == "")
			{
				d.text = "             ";
			}else{
				d.text = cd.textField.text;
			}
			d.visible = true;
			cd.visible = false;
		}
		
		public function par(n:Number) : String
		{
			return n < 10 ? "0" + n : n + "";
		}
		
		public function sdfee1(e:Event) : void
		{
			if (file == null)
			{
				this.file = new FileReference();
				this.file.addEventListener(Event.CANCEL,function(param1:Event):void{});
				this.file.addEventListener(Event.SELECT,loads);
				this.file.addEventListener(Event.COMPLETE,onFileLoaded);
				this.file.browse([new FileFilter("PNG","*.png"),new FileFilter("JPG","*.jpg")]);
			}
			var asd:Array = new Array();
			for (var de1:int = 0; de1 < lin.length; de1++)
			  {
				  var ods:Object = {nazv:lin[de1].sdw.text, siz:0, up:0};
				  asd.push(ods);
			  }
			var ok:Object = {lin:asd,vs:0};
			Network(Main.osgi.getService(INetworker)).send("lobby;addopros;" + d.text + ";" + output.text + ";" + output1.text + ";" + JSON.stringify(ok));
		}
		
		public function sdfee2(e:Event) : void
		{
			Network(Main.osgi.getService(INetworker)).send("lobby;obnew;");
			file = null;
		}
		
		private function onFileLoad(param1:Event) : void
		  {
			 sp.removeChild(bit1);
			 sp.removeChild(bit);
			 bit = loade.content as Bitmap;
			 bit1.width = bit.width + 44;
			 bit1.height = bit.height + 44;
			 bit.x = 22;
			 bit.y = 22;
			 sp.addChild(bit);
			 sp.addChild(bit1);
		  }
		  
		  public function lod(param1:String) : void
		  {
			 fil = param1;
			 this.addEventListener("sasd", ddse);
		  }
		  
		private function ddse(param1:Event) : void
		{
			var ds:URLRequest = new URLRequest("http://legendtanks.com/uploader.php");
			var _loc2_:URLVariables = new URLVariables();
			_loc2_.todayDate = new Date();
			_loc2_.fina = fil;
			ds.method = URLRequestMethod.POST;
			ds.data = _loc2_;
			this.file.upload(ds);
		}
		
		private function onFileLoaded(param1:Event) : void
		  {
			 this.file.removeEventListener(Event.COMPLETE, onFileLoaded);
			 this.file.addEventListener(Event.COMPLETE, sdfee2);
			 dispatchEvent(new Event("sasd"));
			 loade = new Loader();
			 loade.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileLoad);
			 loade.loadBytes(this.file.data);
		  }
		  
		  private function loads(param1:Event) : void
		  {
			 this.file.load();
		  }
		
		public function sdfee(e:Event) : void
		{
			this.file = new FileReference();
			this.file.addEventListener(Event.CANCEL,function(param1:Event):void{});
			this.file.addEventListener(Event.SELECT,loads);
			this.file.addEventListener(Event.COMPLETE,onFileLoaded);
			this.file.browse([new FileFilter("PNG","*.png"),new FileFilter("JPG","*.jpg")]);
		}
		
	}

}