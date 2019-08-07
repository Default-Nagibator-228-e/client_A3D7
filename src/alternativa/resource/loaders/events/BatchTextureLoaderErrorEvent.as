package alternativa.resource.loaders.events
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   
   public class BatchTextureLoaderErrorEvent extends ErrorEvent
   {
      
      public static const LOADER_ERROR:String = "loaderError";
       
      
      private var _textureName:String;
      
      public function BatchTextureLoaderErrorEvent(type:String, textureName:String, text:String)
      {
         super(type);
         this.text = text;
         this._textureName = textureName;
      }
      
      public function get textureName() : String
      {
         return this._textureName;
      }
      
      override public function clone() : Event
      {
         return new BatchTextureLoaderErrorEvent(type,this._textureName,text);
      }
      
      override public function toString() : String
      {
         return "[BatchTextureLoaderErrorEvent textureName=" + this._textureName + ", text=" + text + "]";
      }
   }
}
