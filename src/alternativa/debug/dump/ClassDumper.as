package alternativa.debug.dump
{
   import alternativa.init.Main;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.register.ClientClass;
   import alternativa.service.IClassService;
   
   public class ClassDumper implements IDumper
   {
       
      
      public function ClassDumper()
      {
         super();
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var result:String = "\n";
         var classes:Array = IClassService(Main.osgi.getService(IClassService)).classList;
         for(var i:int = 0; i < classes.length; i++)
         {
            result = result + ClientClass(classes[i]).toString();
         }
         result = result + "\n";
         return result;
      }
      
      public function get dumperName() : String
      {
         return "class";
      }
   }
}
