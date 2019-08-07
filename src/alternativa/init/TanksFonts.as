package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import flash.text.Font;
   
   public class TanksFonts implements IBundleActivator
   {
      [Embed(source = '1.ttf', fontName = 'MyriadPro', mimeType = 'application/x-font', embedAsCFF = 'false')]
      private static const MyriadProB:Class;
       
      
      public function TanksFonts()
      {
         super();
      }
      
      public static function init() : void
      {
         Font.registerFont(MyriadProB);
      }
      
      public function start(osgi:OSGi) : void
      {
         Font.registerFont(MyriadProB);
      }
      
      public function stop(osgi:OSGi) : void
      {
      }
   }
}
