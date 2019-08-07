package alternativa.network.command
{
   public class ControlCommand
   {
      
      public static const HASH_REQUEST:int = 1;
      
      public static const HASH_RESPONCE:int = 2;
      
      public static const HASH_ACCEPT:int = 4;
      
      public static const OPEN_SPACE:int = 3;
      
      public static const LOAD_RESOURCES:int = 5;
      
      public static const RESOURCES_LOADED:int = 7;
      
      public static const UNLOAD_CLASSES_AND_RESOURCES:int = 6;
      
      public static const LOAD_CLASSES:int = 12;
      
      public static const CLASSES_LOADED:int = 13;
      
      public static const LOG:int = 8;
      
      public static const SERVER_MESSAGE:int = 11;
      
      public static const COMMAND_REQUEST:int = 9;
      
      public static const COMMAND_RESPONCE:int = 10;
       
      
      public var id:int;
      
      public var name:String;
      
      public var params:Array;
      
      public function ControlCommand(id:int, name:String, params:Array)
      {
         super();
         this.id = id;
         this.name = name;
         this.params = params;
      }
      
      public function toString() : String
      {
         return "[ControlCommand id: " + this.id + " name: " + this.name + "]";
      }
   }
}
