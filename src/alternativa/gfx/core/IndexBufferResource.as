package alternativa.gfx.core
{
   import alternativa.gfx.alternativagfx;
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   
   use namespace alternativagfx;
   
   public class IndexBufferResource extends Resource
   {
       
      
      alternativagfx var buffer:IndexBuffer3D;
      
      private var _indices:Vector.<uint>;
      
      private var _numIndices:int;
      
      public function IndexBufferResource(param1:Vector.<uint>)
      {
         super();
         this._indices = param1;
         this._numIndices = this._indices.length;
      }
      
      public function get indices() : Vector.<uint>
      {
         return this._indices;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.buffer != null)
         {
            this.buffer.dispose();
            this.buffer = null;
         }
         this._indices = null;
      }
      
      override public function reset() : void
      {
         super.reset();
         if(this.buffer != null)
         {
            this.buffer.dispose();
            this.buffer = null;
         }
      }
      
      override public function get available() : Boolean
      {
         return this._indices != null;
      }
      
      override public function create(param1:Context3D) : void
      {
         super.create(param1);
         this.buffer = param1.createIndexBuffer(this._numIndices);
      }
      
      override public function upload() : void
      {
         super.upload();
         this.buffer.uploadFromVector(this._indices,0,this._numIndices);
      }
   }
}
