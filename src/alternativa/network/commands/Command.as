package alternativa.network.commands
{
   public class Command
   {
       
      
      public var type:Type;
      
      public var args:Array;
      
      public var src:String;
      
      public function Command(type:Type, args:Array, src:String = null)
      {
         super();
         this.type = type;
         this.args = args;
         this.src = src;
      }
   }
}
