package alternativa.service
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ErrorLog
   {
       
      
      private var stage:Stage;
      
      private var btnShowLog:ErrorLogButton;
      
      private var btnCloseLog:ErrorLogButton;
      
      private var btnCopyLog:ErrorLogButton;
      
      private var log:TextField;
      
      private var logStrings:Array;
      
      public function ErrorLog(stage:Stage)
      {
         this.btnShowLog = new ErrorLogButton("[Click to view log messages]",16776960,16711680);
         this.btnCloseLog = new ErrorLogButton("[Close]",65280,0);
         this.btnCopyLog = new ErrorLogButton("[Copy to clipboard]",65280,0);
         this.logStrings = [];
         super();
         this.stage = stage;
         this.btnShowLog.addEventListener(MouseEvent.CLICK,this.onBtnShowLogClick);
         this.btnCloseLog.addEventListener(MouseEvent.CLICK,this.onBtnCloseClick);
         this.btnCopyLog.addEventListener(MouseEvent.CLICK,this.onBtnCopyClick);
         this.btnCopyLog.x = this.btnCloseLog.width;
         this.createLog();
      }
      
      public function addLogMessage(logLevel:String, message:String) : void
      {
         var s:String = "[" + logLevel + "]: " + message;
         if(this.log.parent == null)
         {
            this.logStrings.push(s);
            this.stage.addChild(this.btnShowLog);
         }
         else
         {
            this.addStringToLog(s);
         }
      }
      
      private function createLog() : void
      {
         this.log = new TextField();
         this.log.defaultTextFormat = new TextFormat("Tahoma",12,0);
         this.log.background = true;
         this.log.backgroundColor = 14540253;
         this.log.selectable = true;
         this.log.multiline = true;
         this.log.wordWrap = true;
         this.log.mouseWheelEnabled = true;
         this.log.y = this.btnCloseLog.height;
      }
      
      private function onBtnShowLogClick(e:Event) : void
      {
         this.stage.removeChild(this.btnShowLog);
         var len:int = this.logStrings.length;
         for(var i:int = 0; i < len; i++)
         {
            this.log.appendText(this.logStrings[i] + "\n");
         }
         this.logStrings.length = 0;
         this.stage.addChild(this.log);
         this.stage.addChild(this.btnCloseLog);
         this.stage.addChild(this.btnCopyLog);
         this.onStageResize(null);
         this.stage.addEventListener(Event.RESIZE,this.onStageResize);
      }
      
      private function addStringToLog(s:String) : void
      {
         this.log.appendText(s + "\n");
         this.log.scrollV = this.log.maxScrollV;
      }
      
      private function onStageResize(e:Event) : void
      {
         this.log.width = this.stage.stageWidth;
         this.log.height = this.stage.stageHeight - this.btnCloseLog.height;
      }
      
      private function onBtnCloseClick(e:Event) : void
      {
         this.stage.removeChild(this.log);
         this.stage.removeChild(this.btnCloseLog);
         this.stage.removeChild(this.btnCopyLog);
         this.log.text = "";
         this.stage.focus = this.stage;
      }
      
      private function onBtnCopyClick(e:Event) : void
      {
         System.setClipboard(this.log.text);
      }
   }
}

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class ErrorLogButton extends Sprite
{
    
   
   private var label:TextField;
   
   function ErrorLogButton(caption:String, fontColor:uint, bgColor:uint)
   {
      super();
      mouseChildren = false;
      buttonMode = true;
      this.label = new TextField();
      this.label.defaultTextFormat = new TextFormat("Tahoma",12,fontColor);
      this.label.autoSize = TextFieldAutoSize.LEFT;
      this.label.text = caption;
      this.label.background = true;
      this.label.backgroundColor = bgColor;
      addChild(this.label);
   }
}
