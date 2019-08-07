package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.IChatListener;
   import alternativa.tanks.models.battlefield.gui.chat.cmdhandlers.BlockCommandHandler;
   import alternativa.tanks.models.battlefield.gui.chat.cmdhandlers.IChatCommandHandler;
   import alternativa.tanks.models.battlefield.gui.chat.cmdhandlers.UnblockCommandHandler;
   import controls.TankInput;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import forms.Chat;
   import forms.Communic;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   [Event(name="sendMessage",type="alternativa.tanks.model.battlefield.gui.chat.BattleChatEvent")]
   public class BattleChat extends Sprite
   {
       
      
      private const CMD_BLOCK:String = "/block";
      
      private const CMD_UNBLOCK:String = "/unblock";
      
      private var commandHandlers:Object;
      
      private var _alwaysShow:Boolean;
      
      private var inputControl:TankInput;
      
      private var input:TextField;
      
      private var output:BattleChatOutput;
      
      private var _chatOpened:Boolean;
      
      private var _locked:Boolean;
      
      public function BattleChat()
      {
         super();
         this.init();
      }
      
      public function set alwaysShow(value:Boolean) : void
      {
         if(this._alwaysShow == value)
         {
            return;
         }
         this._alwaysShow = value;
         if(!this._chatOpened)
         {
            this.output.visible = this._alwaysShow;
         }
      }
      
      public function set locked(value:Boolean) : void
      {
         this._locked = value;
      }
      
      public function get chatOpened() : Boolean
      {
         return this._chatOpened;
      }
      
      public function addUserMessage(messageLabel:String, userName:String, userRank:int, teamType:BattleTeamType, text:String) : void
      {
         if(Chat.blocked(userName))
         {
            return;
         }
         this.output.addLine(messageLabel,userRank,userName,teamType,text);
         this.onResize();
      }
      
      public function addSpectatorMessage(messageLabel:String) : void
      {
         this.output.addSpectatorLine(messageLabel);
         this.onResize();
      }
      
      public function addSystemMessage(text:String) : void
      {
         this.output.addSystemMessage(text);
         this.onResize();
      }
      
      public function clear() : void
      {
         this.output.clear();
      }
      
      public function openChat() : void
      {
         var i:int = 0;
         if(this._chatOpened || this._locked)
         {
            return;
         }
         this.output.visible = true;
         this.input.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onChatInputKey);
         this.input.addEventListener(KeyboardEvent.KEY_UP,this.onChatInputKey);
         this.input.text = "";
         this.inputControl.visible = true;
         Main.stage.focus = this.input;
         this._chatOpened = true;
         this.onResize();
         var modelRegister:IModelService = IModelService(Main.osgi.getService(IModelService));
         var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IChatListener);
         if(listeners != null)
         {
            for(i = listeners.length - 1; i >= 0; i--)
            {
               IChatListener(listeners[i]).chatOpened();
            }
         }
      }
      
      public function closeChat() : void
      {
         var i:int = 0;
         if(!this._chatOpened || this._locked)
         {
            return;
         }
         this.output.visible = this._alwaysShow;
         if(this.inputControl.visible)
         {
            this.input.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this.inputControl.visible = false;
            Main.stage.focus = null;
            this.output.minimize();
            this._chatOpened = false;
            this.onResize();
         }
         var modelRegister:IModelService = IModelService(Main.osgi.getService(IModelService));
         var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IChatListener);
         if(listeners != null)
         {
            for(i = listeners.length - 1; i >= 0; i--)
            {
               IChatListener(listeners[i]).chatClosed();
            }
         }
      }
      
      private function init() : void
      {
         this.inputControl = new TankInput();
         this.inputControl.tabEnabled = false;
         this.inputControl.tabChildren = false;
         this.inputControl.x = 10;
         addChild(this.inputControl);
         this.input = this.inputControl.textField;
         this.input.maxChars = 299;
         this.input.addEventListener(KeyboardEvent.KEY_UP,this.sendMessageKey);
         this.output = new BattleChatOutput();
         this.output.tabEnabled = false;
         this.output.tabChildren = false;
         this.output.x = 10;
         addChild(this.output);
         this.initCommandHandlers();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function initCommandHandlers() : void
      {
         this.commandHandlers = {
            "/block":new BlockCommandHandler(this.output),
            "/unblock":new UnblockCommandHandler(this.output)
         };
      }
      
      private function onAddedToStage(e:Event) : void
      {
         this.inputControl.visible = false;
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onResize(e:Event = null) : void
      {
         var outputY:Number = NaN;
         if(this._chatOpened)
         {
            this.output.maximize();
         }
         this.inputControl.width = int(0.25 * Main.stage.stageWidth);
         this.inputControl.y = Main.stage.stageHeight - this.inputControl.height - 70;
         outputY = this.inputControl.y - this.output.height - 10;
         if(outputY < 50)
         {
            while(outputY < 50)
            {
               outputY = outputY + this.output.height;
               this.output.shiftMessages();
               outputY = outputY - this.output.height;
            }
         }
         this.output.y = outputY;
      }
      
      private function sendMessageKey(e:KeyboardEvent) : void
      {
         if(this.inputControl.visible)
         {
            switch(e.keyCode)
            {
               case Keyboard.ENTER:
                  if(this.input.text != "")
                  {
                     if(!this.handleCommand(this.input.text) && hasEventListener(BattleChatEvent.SEND_MESSAGE))
                     {
                        dispatchEvent(new BattleChatEvent(BattleChatEvent.SEND_MESSAGE,this.input.text));
                     }
                     this.input.text = "";
                  }
               case Keyboard.ESCAPE:
                  e.keyCode = 0;
                  this.closeChat();
            }
         }
      }
      
      private function handleCommand(text:String) : Boolean
      {
         if(text.charAt(0) != "/")
         {
            return false;
         }
         var tokens:Array = text.split(/\s+/);
         if(tokens.length == 0)
         {
            return false;
         }
         var commandName:String = tokens.shift();
         var handler:IChatCommandHandler = this.commandHandlers[commandName];
         if(handler == null)
         {
            return false;
         }
         handler.handleCommand(tokens);
         return true;
      }
      
      private function onFocusOut(e:FocusEvent) : void
      {
         this.closeChat();
      }
      
      private function onChatInputKey(e:KeyboardEvent) : void
      {
         e.stopPropagation();
      }
   }
}
