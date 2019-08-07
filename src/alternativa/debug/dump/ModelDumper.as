package alternativa.debug.dump
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.service.IModelService;
   
   public class ModelDumper implements IDumper
   {
       
      
      public function ModelDumper()
      {
         super();
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var result:String = "\n";
         var modelRegister:IModelService = IModelService(Main.osgi.getService(IModelService));
         var models:Vector.<IModel> = modelRegister.modelsList;
         for(var i:int = 0; i < models.length; i++)
         {
            result = result + ("  " + models[i] + "\n");
            result = result + ("      id: " + models[i].id + "\n");
            result = result + ("      interfaces: " + modelRegister.getInterfacesForModel(models[i].id) + "\n\n");
         }
         result = result + "\n";
         return result;
      }
      
      public function get dumperName() : String
      {
         return "model";
      }
   }
}
