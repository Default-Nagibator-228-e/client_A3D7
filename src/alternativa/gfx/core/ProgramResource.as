package alternativa.gfx.core
{
   import alternativa.gfx.alternativagfx;
   import flash.display3D.Context3D;
   import flash.display3D.Program3D;
   import flash.utils.ByteArray;
   
   use namespace alternativagfx;
   
   public class ProgramResource extends Resource
   {
       
      
      alternativagfx var program:Program3D;
      
      private var _vertexProgram:ByteArray;
      
      private var _fragmentProgram:ByteArray;
      
      public function ProgramResource(param1:ByteArray, param2:ByteArray)
      {
         super();
         this._vertexProgram = param1;
         this._fragmentProgram = param2;
      }
      
      public function get vertexProgram() : ByteArray
      {
         return this._vertexProgram;
      }
      
      public function get fragmentProgram() : ByteArray
      {
         return this._fragmentProgram;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.program != null)
         {
            this.program.dispose();
            this.program = null;
         }
         this._vertexProgram = null;
         this._fragmentProgram = null;
      }
      
      override public function reset() : void
      {
         super.reset();
         if(this.program != null)
         {
            this.program.dispose();
            this.program = null;
         }
      }
      
      override public function get available() : Boolean
      {
         return this._vertexProgram != null && this._fragmentProgram != null;
      }
      
      override public function create(param1:Context3D) : void
      {
         super.create(param1);
         this.program = param1.createProgram();
      }
      
      override public function upload() : void
      {
         super.upload();
         this.program.upload(this.vertexProgram,this.fragmentProgram);
      }
   }
}
