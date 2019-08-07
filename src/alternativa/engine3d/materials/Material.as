package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.utils.getQualifiedClassName;
   
   use namespace alternativa3d;
   
   public class Material
   {
       
      
      public var name:String;
      
      public var alphaTestThreshold:Number = 0;
      
      public var zOffset:Boolean = false;
      
      public var uploadEveryFrame:Boolean = false;
      
      alternativa3d var drawId:uint = 0;
      
      alternativa3d var useVerticesNormals:Boolean = true;
      
      private var isTransparent:Boolean;
      
      public function Material()
      {
         super();
      }
      
      alternativa3d function get transparent() : Boolean
      {
         return this.isTransparent;
      }
      
      alternativa3d function set transparent(param1:Boolean) : void
      {
         this.isTransparent = param1;
      }
      
      public function clone() : Material
      {
         var _loc1_:Material = new Material();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      protected function clonePropertiesFrom(param1:Material) : void
      {
         this.name = param1.name;
         this.alphaTestThreshold = param1.alphaTestThreshold;
         this.useVerticesNormals = param1.useVerticesNormals;
      }
      
      public function toString() : String
      {
         var _loc1_:String = getQualifiedClassName(this);
         return "[" + _loc1_.substr(_loc1_.indexOf("::") + 2) + " " + this.name + "]";
      }
      
      alternativa3d function drawOpaque(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D) : void
      {
      }
      
      alternativa3d function drawTransparent(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D, param7:Boolean = false) : void
      {
      }
      
      public function dispose() : void
      {
      }
   }
}
