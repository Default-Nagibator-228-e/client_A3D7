package alternativa.resource.loaders
{
   public class TextureInfo
   {
       
      
      public var diffuseMapFileName:String;
      
      public var opacityMapFileName:String;
      
      public function TextureInfo(diffuseMapFileName:String = null, opacityMapFileName:String = null)
      {
         super();
         this.diffuseMapFileName = diffuseMapFileName;
         this.opacityMapFileName = opacityMapFileName;
      }
      
      public function toString() : String
      {
         return "[TextureInfo diffuseMapFileName=" + this.diffuseMapFileName + ", opacityMapFileName=" + this.opacityMapFileName + "]";
      }
   }
}
