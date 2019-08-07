package alternativa.tanks.hulls
{
   import flash.utils.Dictionary;
   
   public class Hulls
   {
      
      public static var hulls:Dictionary = new Dictionary();
       
      
      public function Hulls()
      {
         super();
      }
      
      public static function add(id:String, hull:Hull) : void
      {
         if(hulls[id] == null && hull.mesh != null && hull.mountPoint != null)
         {
            hulls[id] = hull;
            return;
         }
         throw new Error("Hull with id :\'" + id + "\' has been arleady registered!");
      }
      
      public static function getHull(id:String) : Hull
      {
         return hulls[id];
      }
   }
}
