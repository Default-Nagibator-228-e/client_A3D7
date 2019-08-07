package alternativa.debug.dump
{
   import alternativa.init.Main;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.register.SpaceInfo;
   import alternativa.service.ISpaceService;
   import flash.utils.Dictionary;
   
   public class ObjectDumper implements IDumper
   {
       
      
      public function ObjectDumper()
      {
         super();
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var objects:Dictionary = null;
         var obj:ClientObject = null;
         var models:Vector.<String> = null;
         var m:int = 0;
         var result:String = "\n";
         var spaces:Array = ISpaceService(Main.osgi.getService(ISpaceService)).spaceList;
         for(var i:int = 0; i < spaces.length; i++)
         {
            result = result + ("   space id: " + SpaceInfo(spaces[i]).id + "\n");
            objects = SpaceInfo(spaces[i]).objectRegister.getObjects();
            for each(obj in objects)
            {
               result = result + ("      object id: " + obj.id + "\n");
               models = obj.getModels();
               if(models.length > 0)
               {
                  result = result + "         models id:";
                  for(m = 0; m < models.length; m++)
                  {
                     result = result + (" " + models[m]);
                  }
                  result = result + "\n";
               }
            }
            result = result + "\n";
         }
         return result;
      }
      
      public function get dumperName() : String
      {
         return "object";
      }
   }
}
