package forms.news.edit 
{
	import controls.Label;
	import controls.TankInput;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.ColorConstants;
	import utils.FontParamsUtil;
	
	public class LineOp extends Sprite
	{
		
		[Embed(source="7.png")]
		private static var add1:Class;
		
		public var sdw:Label = new Label();
		
		private var gar:Sprite = new Sprite();
		
		private var gar2:Sprite = new Sprite();
		
		private var cd:TankInput = new TankInput();
		
		public function LineOp(s:String,f:Boolean = true) 
		{
			super();
			addChild(gar);
			sdw.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			sdw.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
			sdw.size = 10;
			sdw.text = s;
			sdw.textColor = ColorConstants.GREEN_LABEL;
			sdw.mouseEnabled = false;
			gar.addChild(sdw);
			gar.buttonMode = true;
			gar.tabEnabled = false;
			cd.width = 100;
			addChild(cd);
			cd.visible = false;
			gar.addEventListener(MouseEvent.CLICK,chd);
			if (f)
			{
				addChild(gar2);
				gar2.buttonMode = true;
				gar2.tabEnabled = false;
				var df:Bitmap = new add1();
				df.smoothing = true;
				df.width = 15;
				df.height = 15;
				gar2.addChild(df);
				gar2.x = 111;
				gar2.y = sdw.height / 2 - gar2.height / 2;
				gar2.addEventListener(MouseEvent.CLICK, gop);
			}
		}
		
		public function chd(e:Event) : void
		{
			if (sdw.text != "             ")
			{
				cd.textField.text = sdw.text;
			}
			sdw.visible = false;
			cd.visible = true;
			sdw.visible = false;
		}
		
		public function unchd(e:Event) : void
		{
			if ((e.target == cd || e.target == cd.textField || e.target == gar) || !cd.visible)
			{
				//throw new Error("sdsdff");
				return;
			}
			if (cd.textField.text == "")
			{
				sdw.text = "             ";
			}else{
				sdw.text = cd.textField.text;
			}
			sdw.visible = true;
			cd.visible = false;
		}
		
		public function gop(e:Event) : void
		{
			dispatchEvent(new Event("gfijk"));
		}
		
	}

}