package alternativa.service
{
   import alternativa.osgi.service.log.ILogService;
   
   public class DummyLogService implements ILogService
   {
       
      
      public function DummyLogService()
      {
         super();
      }
      
      public function log(level:int, message:String, exception:String = null) : void
      {
      }
   }
}
