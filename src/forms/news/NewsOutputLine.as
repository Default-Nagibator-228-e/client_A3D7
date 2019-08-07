package forms.news
{
	import alternativa.debug.dump.SpaceDumper;
	import alternativa.init.Main;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	import alternativa.osgi.service.storage.IStorageService;
	import flash.events.IOErrorEvent;
	import flash.text.AntiAliasType;
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
   
   public class NewsOutputLine extends GridItemBase
   {
      
	  [Embed(source="1.png")]
	  private static var add:Class;
	  
	  [Embed(source="7.png")]
	  private static var add1:Class;
	  
      public var output:LabelBase;//16777215
	  
      public var output1:Label;//ColorConst.Green
	  
	  public var bit:Bitmap;
	  
	  public var id:String;
	  
	  public var dat:String;
	  
	  public var d:Label;
	  
	  public var d1:NewsOutput;
	  
	  private var gar:Sprite = new Sprite();
	  
	  private var gar2:Sprite = new Sprite();
	  
	  private var qw:Boolean = true;
	  
	  private var stor:SharedObject;
	  
	  private var loader:Loader = new Loader();
      
      public function NewsOutputLine(da:String,ou:String,out:String,b:String,j:NewsOutput)
      {
		  super();
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
		  output1.multiline = true;
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
	  
	private function creat() : void
      {
		 bit.y = 15;
		 bit.smoothing = true;
		addChild(bit);
		d.y = -15;
		bit.width = 70;
		bit.height = 70;
		gar.visible = qw;
		//d.x = this.width / 2 - d.width/2;
		output.y = 15;
		output.x = bit.width + 11;
		addChild(output);
		output1.y = output.y + output.textHeight + 6;
		output1.x = bit.width + 11;
		addChild(output1);
		addChild(d);
		addChild(gar);
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
		d1.setSize(NewsOutput.dr.x,NewsOutput.dr.y);
      }
	  
	public function dss(event:Event = null):void
	{
		Network(Main.osgi.getService(INetworker)).send("lobby;remnews;" + this.id);
	}
	  
	public function cr(event:Event = null):void
	{
		bit = new add();
		creat();
	}
	  
	public function hr(event:Event):void
	{
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, hr);
		bit = loader.content as Bitmap;
		creat();
	}
	  
	public function re(wid:int):void
	{
		d.x = wid / 2 - d.textWidth / 2;
		if (bit != null)
		{
			output1.width = wid + 32 + gar.x - bit.width * 2;
		}
		gar.x = -15;
		gar.y = 8;
		gar.graphics.clear();
		gar.graphics.lineStyle(2, 0x59ff31);
		gar.graphics.drawRoundRect(0, 0, wid + 32, this.height - 8, 6, 6);
		gar2.x = output1.width + output1.x + 11;
		gar2.y = 15;
	}
   }
}
