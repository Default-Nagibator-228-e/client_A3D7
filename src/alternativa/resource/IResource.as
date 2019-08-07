package alternativa.resource
{
   import alternativa.types.Long;
   
   public interface IResource
   {
       
      
      function get name() : String;
      
      function get id() : Long;
      
      function set id(param1:Long) : void;
      
      function get version() : int;
      
      function set version(param1:int) : void;
      
      function load(param1:String) : void;
      
      function close() : void;
      
      function unload() : void;
   }
}
