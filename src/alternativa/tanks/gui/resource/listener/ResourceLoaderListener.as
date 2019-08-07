package alternativa.tanks.gui.resource.listener
{
   public class ResourceLoaderListener
   {
      
      public static var listeners:Vector.<Function> = new Vector.<Function>();
       
      
      public function ResourceLoaderListener()
      {
         super();
      }
      
      public static function addEventListener(fun:Function) : void
      {
         listeners.push(fun);
      }
      
      public static function loadedComplete() : void
      {
         var resource:Function = null;
         for each(resource in listeners)
         {
            resource.call();
         }
      }
   }
}
