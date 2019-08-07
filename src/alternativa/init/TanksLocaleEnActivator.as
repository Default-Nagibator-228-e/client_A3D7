package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.en.Image;
   import alternativa.tanks.locale.en.Text;
   
   public class TanksLocaleEnActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      public function TanksLocaleEnActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         TanksLocaleEnActivator.osgi = osgi;
         Text.init(osgi.getService(ILocaleService) as ILocaleService);
         Image.init(osgi.getService(ILocaleService) as ILocaleService);
      }
      
      public function stop(osgi:OSGi) : void
      {
         TanksLocaleEnActivator.osgi = null;
      }
   }
}
