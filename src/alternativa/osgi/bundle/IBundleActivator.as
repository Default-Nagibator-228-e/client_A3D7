package alternativa.osgi.bundle
{
   import alternativa.init.OSGi;
   
   public interface IBundleActivator
   {
       
      
      function start(param1:OSGi) : void;
      
      function stop(param1:OSGi) : void;
   }
}
