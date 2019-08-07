package alternativa.debug.dump
{
   import alternativa.init.Main;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.register.SpaceInfo;
   import alternativa.service.ISpaceService;
   
   public class SpaceDumper implements IDumper
   {
       
      
      public function SpaceDumper()
      {
         super();
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var result:String = "\n";
         var spaces:Array = ISpaceService(Main.osgi.getService(ISpaceService)).spaceList;
         for(var i:int = 0; i < spaces.length; i++)
         {
            result = result + ("   space id: " + (SpaceInfo(spaces[i]).id == null?"X":SpaceInfo(spaces[i]).id.toString()) + "\n");
         }
         result = result + "\n";
         return result;
      }
      
      public function get dumperName() : String
      {
         return "space";
      }
   }
}
