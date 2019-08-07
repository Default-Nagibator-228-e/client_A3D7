package alternativa.osgi.service.dump
{
   import alternativa.osgi.service.dump.dumper.IDumper;
   import flash.utils.Dictionary;
   
   public interface IDumpService
   {
       
      
      function registerDumper(param1:IDumper) : void;
      
      function unregisterDumper(param1:String) : void;
      
      function dump(param1:Vector.<String>) : String;
      
      function get dumpers() : Dictionary;
      
      function get dumpersList() : Vector.<IDumper>;
   }
}
