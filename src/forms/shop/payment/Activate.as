package forms.shop.payment 
{
	import alternativa.init.Main;
	import forms.shop.components.item.GridItemBase;
	import controls.DefaultButton;
	import controls.TankInput;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import alternativa.network.INetworker;
	import alternativa.network.Network;
	/**
	 * ...
	 * @author 
	 */
	public class Activate extends GridItemBase
	{
		
		private var code:TankInput = new TankInput();
		private var sendButton:DefaultButton = new DefaultButton();
		
		public function Activate() 
		{
			super();
			addChild(code);
			addChild(sendButton);
			code.align = TextFormatAlign.CENTER;
			//Main.stage.addEventListener(Event.RESIZE,ft);
			sendButton.label = "Отправить";
			sendButton.addEventListener(MouseEvent.CLICK, ft);
			sendButton.enable = false;
			code.width = Math.max(code.textField.textWidth, int(915 * 0.66));
			sendButton.x = code.width + 8;
			code.restrict = ".0-9A-Z_\\-";
			code.textField.addEventListener(Event.CHANGE, ft1);
		}
		
		public function ft(e:Event = null) : void 
		{
			//throw new Error();
			Network(Main.osgi.getService(INetworker)).send("lobby;zacet;" + code.textField.text + ";");
			code.value = "";
			sendButton.enable = false;
		}
		
		public function ft1(e:Event = null) : void 
		{
			while(code.textField.text.search(" ") != -1)
			 {
				code.textField.text = code.textField.text.replace(" ","");
			 }
			sendButton.enable = true;
			if (code.textField.text == "")
			{
				sendButton.enable = false;
			}
		}
	}

}