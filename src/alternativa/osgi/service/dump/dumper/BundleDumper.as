package alternativa.osgi.service.dump.dumper
{
   import alternativa.init.OSGi;
   import alternativa.osgi.bundle.Bundle;
   
   public class BundleDumper implements IDumper
   {
       
      
      private var osgi:OSGi;
      
      public function BundleDumper(osgi:OSGi)
      {
         super();
         this.osgi = osgi;
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var result:String = "\n";
         var bundles:Vector.<Bundle> = this.osgi.bundleList;
         for(var i:int = 0; i < bundles.length; i++)
         {
            result = result + ("   bundle " + (i + 1).toString() + ": " + bundles[i].name + "\n");
         }
         result = result + "\n";
         return result;
      }
      
      public function get dumperName() : String
      {
         return "bundle";
      }
   }
}
