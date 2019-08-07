package alternativa.osgi.service.dump.dumper
{
   import alternativa.init.OSGi;
   
   public class ServiceDumper implements IDumper
   {
       
      
      private var osgi:OSGi;
      
      public function ServiceDumper(osgi:OSGi)
      {
         super();
         this.osgi = osgi;
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var result:String = "\n";
         var services:Vector.<Object> = this.osgi.serviceList;
         for(var i:int = 0; i < services.length; i++)
         {
            result = result + ("   service " + (i + 1).toString() + ": " + services[i] + "\n");
         }
         result = result + "\n";
         return result;
      }
      
      public function get dumperName() : String
      {
         return "service";
      }
   }
}
