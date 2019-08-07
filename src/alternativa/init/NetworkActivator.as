package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   
   public class NetworkActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      public function NetworkActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         NetworkActivator.osgi = osgi;
      }
      
      public function stop(osgi:OSGi) : void
      {
         NetworkActivator.osgi = null;
      }
   }
}
