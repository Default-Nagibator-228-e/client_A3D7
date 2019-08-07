package alternativa.console
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   
   public class Console implements IConsole
   {
      
      private static const DEFAULT_BG_COLOR:uint = 0;
      
      private static const DEFAULT_FONT_COLOR:uint = 65280;
      
      private static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("Courier New",12,DEFAULT_FONT_COLOR);
      
      private static const tokenizer:RegExp = /(?:[^"\s]+)|(?:"[^"]*")/g;
       
      
      private var stage:Stage;
      
      private var container:Sprite;
      
      private var output:TextField;
      
      private var input:TextField;
      
      private var toggleKeys:Vector.<ToggleKey>;
      
      private var commandHandlers:Object;
      
      private var variables:Object;
      
      private var _height:Number;
      
      private var _width:Number;
      
      private var visible:Boolean;
      
      private var preventInput:Boolean;
      
      private var _alpha:Number;
      
      private var _bgColor:uint = 0;
      
      private var commandHistory:Array;
      
      private var commandHistoryIndex:int = 0;
      
      private var debugMode:Boolean;
      
      public function Console(stage:Stage, debugMode:Boolean, width:int = 500, height:int = 400, alpha:Number = 0.9)
      {
         this.toggleKeys = new Vector.<ToggleKey>();
         this.commandHandlers = {};
         this.variables = {};
         this.commandHistory = [];
         super();
         if(stage == null)
         {
            throw new ArgumentError("Parameter stage cannot be null");
         }
         this.stage = stage;
         this.debugMode = debugMode;
         this.container = new Sprite();
         this.container.mouseEnabled = false;
         this.container.tabEnabled = false;
         this.container.tabChildren = false;
         this.initInput();
         this.initOutput();
         this.initDefaultCommands();
         this.setWidth(width);
         this.setHeight(height);
         this.setAlpha(alpha);
         this.printGreeting();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.addEventListener(Event.RESIZE,this.resize);
      }
      
      public function addVariable(variable:ConsoleVar) : void
      {
         this.variables[variable.getName()] = variable;
      }
      
      public function removeVariable(variableName:String) : void
      {
         delete this.variables[variableName];
      }
      
      public function addToggleKey(keyCode:uint, altKey:Boolean = false, ctrlKey:Boolean = false, shiftKey:Boolean = false) : void
      {
         this.toggleKeys.push(new ToggleKey(keyCode,altKey,ctrlKey,shiftKey));
      }
      
      public function dispose() : void
      {
         this.hide();
         this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.stage.removeEventListener(Event.RESIZE,this.resize);
         this.stage = null;
      }
      
      public function getAlpha() : Number
      {
         return this.container.alpha;
      }
      
      public function setAlpha(value:Number) : void
      {
         this._alpha = value;
         this.resize();
      }
      
      public function getWidth() : int
      {
         return this._width;
      }
      
      public function setWidth(value:int) : void
      {
         this._width = value;
         this.resize();
      }
      
      public function getHeight() : int
      {
         return this._height;
      }
      
      public function setHeight(value:int) : void
      {
         this._height = value;
         this.resize();
      }
      
      public function show() : void
      {
         if(this.stage == null)
         {
            return;
         }
         this.visible = true;
         this.stage.addChild(this.container);
         this.stage.focus = this.input;
         this.preventInput = false;
         this.resize();
      }
      
      public function hide() : void
      {
         if(this.stage == null)
         {
            return;
         }
         if(this.visible)
         {
            this.stage.removeChild(this.container);
            this.stage.focus = this.stage;
            this.visible = false;
         }
      }
      
      public function hideDelayed(delay:uint) : void
      {
         setTimeout(this.hide,delay);
      }
      
      public function addLine(text:String) : void
      {
         this.output.appendText(text + "\n");
         this.output.scrollV = this.output.maxScrollV;
      }
      
      public function clear() : void
      {
         this.output.text = "";
      }
      
      public function addCommandHandler(command:String, handler:Function) : void
      {
         this.commandHandlers[command] = handler;
      }
      
      public function removeCommandHandler(command:String) : void
      {
         delete this.commandHandlers[command];
      }
      
      public function getCommandList() : Array
      {
         var key:* = null;
         var list:Array = [];
         for(key in this.commandHandlers)
         {
            list.push(key);
         }
         list.sort();
         return list;
      }
      
      public function isDebugMode() : Boolean
      {
         return this.debugMode;
      }
      
      public function getText() : String
      {
         return this.output.text;
      }
      
      public function setFontSize(size:int) : void
      {
         var textFormat:TextFormat = this.output.defaultTextFormat;
         textFormat.size = size;
         var text:String = this.output.text;
         this.output.text = "";
         this.output.defaultTextFormat = textFormat;
         this.output.text = text;
         this.input.defaultTextFormat = textFormat;
      }
      
      private function resize(e:Event = null) : void
      {
         if(!this.visible || this.stage == null)
         {
            return;
         }
         this.output.width = this.stage.stageWidth - 1;
         this.input.width = this.stage.stageWidth - 1;
         var h:int = this._height > this.stage.stageHeight?int(this.stage.stageHeight):int(this._height);
         this.output.height = h - this.input.height;
         this.input.y = this.output.height;
         var gfx:Graphics = this.container.graphics;
         gfx.clear();
         gfx.beginFill(this._bgColor,this._alpha);
         gfx.drawRect(0,0,this.container.width,this.container.height);
         gfx.endFill();
      }
      
      private function initInput() : void
      {
         this.input = new TextField();
         this.input.defaultTextFormat = DEFAULT_TEXT_FORMAT;
         this.input.height = 20;
         this.input.type = TextFieldType.INPUT;
         this.input.border = true;
         this.input.borderColor = DEFAULT_FONT_COLOR;
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
         this.input.addEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp);
         this.input.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         this.container.addChild(this.input);
      }
      
      private function initOutput() : void
      {
         this.output = new TextField();
         this.output.defaultTextFormat = DEFAULT_TEXT_FORMAT;
         this.output.type = TextFieldType.DYNAMIC;
         this.output.border = true;
         this.output.borderColor = DEFAULT_FONT_COLOR;
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.container.addChild(this.output);
      }
      
      private function onInputKeyDown(e:KeyboardEvent) : void
      {
         if(this.isToggleKey(e))
         {
            this.preventInput = true;
         }
         switch(e.keyCode)
         {
            case Keyboard.ENTER:
               this.processInput();
               break;
            case Keyboard.ESCAPE:
               if(this.input.text != "")
               {
                  this.clearInput();
               }
               else
               {
                  this.hideDelayed(50);
               }
               break;
            case Keyboard.TAB:
               this.contextExpand();
               break;
            case Keyboard.UP:
               this.historyUp();
               break;
            case Keyboard.DOWN:
               this.historyDown();
               break;
            case Keyboard.PAGE_UP:
               this.output.scrollV = this.output.scrollV - 10;
               break;
            case Keyboard.PAGE_DOWN:
               this.output.scrollV = this.output.scrollV + 10;
         }
         e.stopPropagation();
      }
      
      private function onInputKeyUp(e:KeyboardEvent) : void
      {
         if(!this.isToggleKey(e))
         {
            e.stopPropagation();
         }
      }
      
      private function onTextInput(e:TextEvent) : void
      {
         if(this.preventInput)
         {
            e.preventDefault();
            this.preventInput = false;
         }
      }
      
      private function processInput() : void
      {
         var handler:Function = null;
         var text:String = this.input.text;
         var len:int = this.commandHistory.length;
         if(len == 0 || this.commandHistory[len - 1] != text)
         {
            this.commandHistory.push(text);
         }
         this.commandHistoryIndex = this.commandHistory.length;
         this.clearInput();
         this.addLine("> " + text);
         if(text.match(/^\s*$/))
         {
            return;
         }
         var tokens:Array = text.match(tokenizer);
         var commandName:String = tokens.shift();
         var variable:ConsoleVar = this.variables[commandName];
         if(variable != null)
         {
            variable.processConsoleInput(this,tokens);
         }
         else
         {
            handler = this.commandHandlers[commandName];
            if(handler != null)
            {
               handler.call(null,this,tokens);
            }
         }
      }
      
      private function clearInput() : void
      {
         this.input.text = "";
      }
      
      private function contextExpand() : void
      {
      }
      
      private function historyUp() : void
      {
         if(this.commandHistoryIndex == 0)
         {
            return;
         }
         this.commandHistoryIndex--;
         this.input.text = this.commandHistory[this.commandHistoryIndex];
      }
      
      private function historyDown() : void
      {
         if(this.commandHistoryIndex > this.commandHistory.length - 2)
         {
            return;
         }
         this.commandHistoryIndex++;
         this.input.text = this.commandHistory[this.commandHistoryIndex];
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         if(this.isToggleKey(e))
         {
            if(this.visible)
            {
               this.hide();
            }
            else
            {
               this.show();
            }
         }
      }
      
      private function isToggleKey(e:KeyboardEvent) : Boolean
      {
         return e.keyCode == 75 && e.ctrlKey && e.shiftKey;
      }
      
      private function printGreeting() : void
      {
         this.addLine("Alternativa console");
         this.addLine("Type cmdlist to get list of commands");
      }
      
      private function initDefaultCommands() : void
      {
         var consoleCommands:ConsoleCommands = new ConsoleCommands();
         this.addCommandHandler("clear",consoleCommands.clearOutput);
         this.addCommandHandler("close",consoleCommands.close);
         this.addCommandHandler("copy",consoleCommands.copyOutput);
         this.addCommandHandler("fontsize",consoleCommands.fontSize);
         this.addCommandHandler("cmdlist",consoleCommands.cmdList);
         this.addCommandHandler("console",consoleCommands.consoleCommand);
         this.addCommandHandler("dump",consoleCommands.dump);
         this.addCommandHandler("varlist",this.printVars);
         this.addCommandHandler("varlistv",this.printVarsValues);
      }
      
      private function printVars(console:IConsole, args:Array) : void
      {
         this.printVariables(args[0],false);
      }
      
      private function printVarsValues(console:IConsole, args:Array) : void
      {
         this.printVariables(args[0],true);
      }
      
      private function printVariables(start:String, showValues:Boolean) : void
      {
         var name:* = null;
         var variable:ConsoleVar = null;
         var s:String = null;
         var vars:Array = [];
         for(name in this.variables)
         {
            if(start == null || start == "" || name.indexOf(start) == 0)
            {
               variable = this.variables[name];
               vars.push(!!showValues?name + " = " + variable.toString():name);
            }
         }
         if(vars.length > 0)
         {
            vars.sort();
            for each(s in vars)
            {
               this.addLine(s);
            }
         }
      }
   }
}

import flash.events.KeyboardEvent;

class ToggleKey
{
    
   
   public var keyCode:uint;
   
   public var altKey:Boolean;
   
   public var ctrlKey:Boolean;
   
   public var shiftKey:Boolean;
   
   function ToggleKey(keyCode:uint, altKey:Boolean, ctrlKey:Boolean, shiftKey:Boolean)
   {
      super();
      this.keyCode = keyCode;
      this.altKey = altKey;
      this.ctrlKey = ctrlKey;
      this.shiftKey = shiftKey;
   }
   
   public function match(e:KeyboardEvent) : Boolean
   {
      return e.keyCode == this.keyCode && e.altKey == this.altKey && e.ctrlKey == this.ctrlKey && e.shiftKey == this.shiftKey;
   }
}

import alternativa.console.IConsole;
import alternativa.init.Main;
import alternativa.osgi.service.dump.IDumpService;
import alternativa.osgi.service.dump.dumper.IDumper;
import flash.system.System;

class ConsoleCommands
{
    
   
   private var consoleCommandHandlers:Object;
   
   function ConsoleCommands()
   {
      this.consoleCommandHandlers = {};
      super();
      this.consoleCommandHandlers["alpha"] = this.setAlpha;
      this.consoleCommandHandlers["height"] = this.setHeight;
   }
   
   public function clearOutput(console:IConsole, args:Array) : void
   {
      console.clear();
   }
   
   public function close(console:IConsole, args:Array) : void
   {
      console.hideDelayed(100);
   }
   
   public function copyOutput(console:IConsole, args:Array) : void
   {
      System.setClipboard(console.getText());
   }
   
   public function dump(console:IConsole, args:Array) : Boolean
   {
      var dumperName:String = null;
      var dumpers:Vector.<IDumper> = null;
      var names:Array = null;
      var i:int = 0;
      var dumper:IDumper = null;
      var dump:String = null;
      var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
      if(args.length == 0)
      {
         dumpers = dumpService.dumpersList;
         names = [];
         for(i = 0; i < dumpers.length; i++)
         {
            names[i] = IDumper(dumpers[i]).dumperName;
         }
         names.sort();
         console.addLine("List of registered dumpers:");
         for each(dumperName in names)
         {
            console.addLine(" " + dumperName);
         }
      }
      else
      {
         dumperName = args.shift();
         dumper = dumpService.dumpers[dumperName];
         if(dumper == null)
         {
            console.addLine("Uknown dumper name");
         }
         else
         {
            dump = dumper.dump(Vector.<String>(args));
            console.addLine(dump);
         }
      }
      return true;
   }
   
   public function cmdList(console:IConsole, args:Array) : void
   {
      var command:String = null;
      for each(command in console.getCommandList())
      {
         console.addLine(command);
      }
   }
   
   public function consoleCommand(console:IConsole, args:Array) : void
   {
      if(args.length == 0)
      {
         return;
      }
      var param:String = args.shift();
      var handler:Function = this.consoleCommandHandlers[param];
      if(handler != null)
      {
         handler.call(null,console,args);
      }
   }
   
   public function fontSize(console:IConsole, args:Array) : void
   {
      var size:int = 0;
      if(args.length > 0)
      {
         size = int(args[0]);
         if(size > 0)
         {
            console.setFontSize(size);
         }
      }
   }
   
   private function setAlpha(console:IConsole, args:Array) : void
   {
      var alpha:Number = NaN;
      if(args.length == 0)
      {
         console.addLine("alpha = " + console.getAlpha().toString());
      }
      else
      {
         alpha = Number(args[0]);
         if(isNaN(alpha) || alpha < 0)
         {
            console.addLine("Wrong alpha value");
         }
         else
         {
            console.setAlpha(alpha);
         }
      }
   }
   
   private function setHeight(console:IConsole, args:Array) : void
   {
      var h:int = 0;
      if(args.length == 0)
      {
         console.addLine("height = " + console.getHeight());
      }
      else
      {
         h = int(args[0]);
         if(h <= 0)
         {
            console.addLine("Height must be positive integer");
         }
         else
         {
            console.setHeight(h);
         }
      }
   }
}
