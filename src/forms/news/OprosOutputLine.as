package forms.news 
{
	
	import alternativa.debug.dump.SpaceDumper;
	import alternativa.init.Main;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	import alternativa.osgi.service.storage.IStorageService;
	import flash.events.IOErrorEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextLineMetrics;
	import forms.shop.components.item.GridItemBase;
	import controls.Label;
	import controls.base.LabelBase;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import forms.ColorConstants;
	import utils.FontParamsUtil;
	
	public class OprosOutputLine extends GridItemBase
	{
		
		[Embed(source="1.png")]
		  private static var add:Class;
		  
		[Embed(source="7.png")]
		  private static var add1:Class;
		  
		  public var output:LabelBase;//16777215
		  
		  public var output1:Label;//ColorConst.Green
		  
		  public var bit:Bitmap;
		  
		  public var dat:String;
		  
		  public var d:Label;
		  
		  public var d1:NewsOutput;
		  
		  private var gar:Sprite = new Sprite();
		  
		  private var gar1:Sprite = new Sprite();
		  
		  private var gar2:Sprite = new Sprite();
		  
		  private var qw:Boolean = true;
		  
		  private var stor:SharedObject;
		  
		  private var loader:Loader = new Loader();
		  
		  public var lin:Array = new Array();
		  
		  public var id:String;
		  
		  private var dsww:String;
		
		public function OprosOutputLine(da:String,ou:String,out:String,b:String,j:NewsOutput,drt:String)
      {
		  super();
		  dsww = drt;
		  stor = SharedObject.getLocal(da);
		  if (stor.data.ram == null)
		  {
			stor.data.ram = true;
		  }
		  stor.flush();
		  id = b;
		  qw = stor.data.ram;
		  d1 = j;
		  d = new Label();
		  gar.graphics.clear();
		  gar.graphics.lineStyle(2, 0x59ff31);
		  gar.graphics.drawRoundRect(0, 0, 200, 100, 6, 6);
		  dat = da;
		  d.text = da;
		  output = new LabelBase();
		  output1 = new Label();
		  output.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
          output.thickness = 100;
		  output1.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
          output1.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
		  output.size = 10;
		  output1.size = 10;
		  output.text = ou;
		  //output1.multiline = true;
		  output1.wordWrap = true;
		  output1.htmlText = str(out);
		  d.textColor = 8454016;
		  output.textColor = ColorConstants.GREEN_LABEL;
		  output1.textColor = ColorConstants.GREEN_LABEL;
		  if (b != "")
		  {
			  loader.contentLoaderInfo.addEventListener(Event.COMPLETE, hr);
			  loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, cr);
			  loader.load(new URLRequest("https://legendtanks.com/imagecom/" + b));
		  }else{
			  cr();
		  }
		  addEventListener(MouseEvent.CLICK, n);
		  this.visible = false;
		  creat();
      }
	  
	public function str(o:String):String
	{
		var dod:String = o;
		var d1:Boolean = true;
		while(dod.search("/n") != -1)
         {
            dod = d1 ? dod.replace("/n", "\n\n"):dod.replace("/n", "\n\n");
			d1 = !d1;
         }
		return dod;
	}
	
	private function n(e:Event) : void
      {
		 stor.data.ram = gar.visible = qw = false;
		 stor.flush();
      }
	  
	private function creatop(a:Array) : void
      {
		 var dse:int = 0;
		 for (var de:int = 0; de < a.length; de++)
		 {
			var obj:Object = a[de];
			trace(obj.nazv,obj.siz,obj.up);
			var sp:LineOpr = new LineOpr(obj.nazv,obj.siz,obj.up,de);
			sp.addEventListener(MouseEvent.CLICK, sokol);
			gar1.addChild(sp);
			lin.push(sp);
			sp.y = de == 0 ? 0 : gar1.height + 7;
		 }
      }
	  
	public function sokol(e:Event) : void
      {
		 Network(Main.osgi.getService(INetworker)).send("lobby;addgolos;" + this.id + ";" + (e.currentTarget as LineOpr).de + ";");
      }
	  
	private function creat() : void
      {
		d.y = -15;
		gar.visible = qw;
		//d.x = this.width / 2 - d.width/2;
		output.y = 15;
		addChild(output);
		addChild(output1);
		addChild(d);
		addChild(gar);
		addChild(gar1);
		gar.x = -15;
		gar.y = 8;
		gar1.y = 15;
		var parser:Object = JSON.parse(dsww);
		creatop(parser.lin as Array);
		output.y = gar1.y + gar1.height + 6;
		output1.y = output.y + output.height + 6;
		addChild(gar2);
		if (Game.group == "admin")
		{
			gar2.buttonMode = true;
			gar2.tabEnabled = false;
			var df:Bitmap = new add1();
			df.smoothing = true;
			df.width = 15;
			df.height = 15;
			gar2.addChild(df);
			gar2.addEventListener(MouseEvent.CLICK,dss);
		}
      }
	  
	public function dss(event:Event = null):void
	{
		Network(Main.osgi.getService(INetworker)).send("lobby;remopsros;" + this.id);
	}
	  
	public function cr(event:Event = null):void
	{
		bit = new add();
		bit.width = 70;
		bit.height = 70;
		bit.y = 15;
		bit.smoothing = true;
		addChild(bit);
		d1.setSize(NewsOutput.dr.x, NewsOutput.dr.y);
		this.visible = true;
	}
	  
	public function hr(event:Event):void
	{
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, hr);
		bit = loader.content as Bitmap;
		bit.width = 70;
		bit.height = 70;
		bit.y = 15;
		addChild(bit);
		d1.setSize(NewsOutput.dr.x, NewsOutput.dr.y);
		this.visible = true;
	}
	  
	public function re(wid:int):void
	{
		d.x = wid / 2 - d.textWidth / 2;
		if (bit != null)
		{
			output.x = output1.x = bit.width + 11;
			output1.width = wid + 32 + gar.x - bit.width * 2;
			gar1.x = output1.x + 3;
		}
		gar.graphics.clear();
		gar.graphics.lineStyle(2, 0x59ff31);
		gar.graphics.drawRoundRect(0, 0, wid + 32, this.height - 8, 6, 6);
		var dr:int = lin[0].res(output1.width);
		for (var de:int = 1; de < lin.length; de++)
		 {
			if (lin[de].res(output1.width) < dr)
			{
				dr = lin[de].res(output1.width);
			}
		 }
		 for (var de:int = 0; de < lin.length; de++)
		 {
			lin[de].res(output1.width,dr);
		 }
		 gar2.x = output1.width + output1.x + 11;
		 gar2.y = 15;
		//gar1.width = output1.width;
		//gar1.graphics.lineStyle(3,0x59ff31,1,true);
		//gar1.graphics.beginFill(0x59ff31);
		//gar1.graphics.drawRoundRect(0, 0, output1.width, 12, 3, 2);
		//gar1.graphics.endFill();
	}
   }

}