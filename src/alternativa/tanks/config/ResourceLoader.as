package alternativa.tanks.config
{
   import utils.Task;
   
   public class ResourceLoader extends Task
   {
       
      
      public var config:Config;
      
      public var name:String;
      
      public function ResourceLoader(name:String, config:Config)
      {
         super();
         this.config = config;
         this.name = name;
      }
   }
}
