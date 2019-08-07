
package alternativa.debug {
	import alternativa.init.Main;
	import alternativa.osgi.service.alert.IAlertService;
	import alternativa.osgi.service.dump.IDumpService;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;

	public class Debug implements IDebugCommandProvider, IDebugCommandHandler, IAlertService {

		private var _handlers : Dictionary;
		private var _commandList : Array;

		private static var errorWindow : ErrorWindow;
		private static var serverMessageWindow : ServerMessageWindow;

		private var layer : DisplayObjectContainer; 

		
		public function Debug() {
			layer = Main.noticesLayer;
			
			errorWindow = new ErrorWindow();
			serverMessageWindow = new ServerMessageWindow();
			
			_handlers = new Dictionary();
			_commandList = new Array();
			
			registerCommand("dump", this);
			registerCommand("hide", this);
			registerCommand("show", this);
			registerCommand("help", this);
			registerCommand("clear", this);
			registerCommand("spam", this);
			
//			var console : EventDispatcher = IConsoleService(Main.osgi.getService(IConsoleService)).console as EventDispatcher;
//			if (console != null) {
//				console.addEventListener(Event.COMPLETE, consoleCommand);
//			}
			//Main.stage.addEventListener(Event.RESIZE, onStageResize);
			
			/*if (Main.osgi.getService(IDebugService) != null) {
				FPS.offsetY = 30;
				FPS.init(Main.systemUILayer);
				registerCommand("fps", this);
			}*/
		}

		private function consoleCommand(e : Event) : void {
//			var command : String = IConsoleService(Main.osgi.getService(IConsoleService)).console.getCommand();
//			var result : String = executeCommand(command);
//			if (result != null && result != "") {
//				IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("COMMAND", result);
//			}
		}

		public function execute(command : String) : String {
//			var result : String;
//			var stringsArray : Array = command.split(" ");
//			var name : String = stringsArray.shift();
//			switch (name) {
//				case "help":
//					result = "\n";
//					for (var i : int = 0;i < _commandList.length;i++) {
//						result += "	  " + _commandList[i] + "\n";
//					}
//					result += "\n";
//					break;
//				case "dump":
//					var strings : Vector.<String> = Vector.<String>(stringsArray);
//					var dumpService : IDumpService = IDumpService(Main.osgi.getService(IDumpService));
//					if (dumpService != null) {
//						result = dumpService._dump(strings);
//					}
//					break;
//				case "hide":
//					IConsoleService(Main.osgi.getService(IConsoleService)).hideConsole();
//					break;
//				case "show":
//					IConsoleService(Main.osgi.getService(IConsoleService)).showConsole();
//					break;
//				case "clear":
//					IConsoleService(Main.osgi.getService(IConsoleService)).clearConsole();
//					break;
//				/*case "fps":
//				if (stringsArray.length > 0) {
//				switch (stringsArray[0]) {
//				case "show":
//				FPS.show();
//				break;
//				case "hide":
//				FPS.hide();
//				break;
//				}
//				}
//				break;*/
//				case "spam":
//					setInterval(spam, 25);
//					break;
//				default:
//					result = "Unknown command";
//					break;
//			}
//			return result;
			return "";
		}

		private function spam() : void {
			for (var i : int = 0;i < 3000;i++) {
				var s : Shape = new Shape();
			}
		}

		public function executeCommand(command : String) : String {
			var result : String;
			var name : String = command.split(" ")[0];
			if (_handlers[name] != null) {
				result = IDebugCommandHandler(_handlers[name]).execute(command);
			} else {
				result = "Unknown command";
			}
			return result;
		}

		public function registerCommand(command : String, handler : IDebugCommandHandler) : void {
			_handlers[command] = handler;
			_commandList.push(command);
		}

		public function unregisterCommand(command : String) : void {
			_commandList.splice(_commandList.indexOf(command), 1);
			delete _handlers[command];
		}

		private function onStageResize(e : Event = null) : void {
		}

		private function openWindow() : void {
			if (!layer.contains(errorWindow)) {
				layer.addChild(errorWindow);
				onStageResize();
			}
		}

		private function closeWindow() : void {
			if (layer.contains(errorWindow)) {
				layer.removeChild(errorWindow);
			}
		}

		public function showAlert(message : String) : void {
			showServerMessageWindow(message);
		}
		
		public function hideAlert() : void {
			hideServerMessageWindow();
		}

		public function showErrorWindow(message : String) : void {
			errorWindow.text = message;
			openWindow();
		}

		public function hideErrorWindow() : void {
			closeWindow();
		}

		public function showServerMessageWindow(message : String) : void {
			serverMessageWindow.text = message;
			if (!layer.contains(serverMessageWindow)) {
				layer.addChild(serverMessageWindow);
				serverMessageWindow.redraw();
			}
		}

		public function hideServerMessageWindow() : void {
			if (layer.contains(serverMessageWindow)) {
				layer.removeChild(serverMessageWindow);
			}
		}
	}
}