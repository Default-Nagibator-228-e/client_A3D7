package alternativa.register
{
   import alternativa.types.Long;
   
   public class ClassInfo
   {
       
      
      public var id:Long;
      
      public var parent:Long;
      
      public var name:String;
      
      public var modelsToAdd:Array;
      
      public var modelsToRemove:Array;
      
      public function ClassInfo(id:Long, parent:Long, name:String, modelsToAdd:Array, modelsToRemove:Array)
      {
         super();
         this.id = id;
         this.parent = parent;
         this.name = name;
         this.modelsToAdd = modelsToAdd;
         this.modelsToRemove = modelsToRemove;
      }
   }
}
