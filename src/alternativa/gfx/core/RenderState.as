package alternativa.gfx.core
{
   import flash.geom.Rectangle;
   
   public class RenderState
   {
       
      
      public var blendSourceFactor:String = "one";
      
      public var blendDestinationFactor:String = "zero";
      
      public var colorMaskRed:Boolean = true;
      
      public var colorMaskGreen:Boolean = true;
      
      public var colorMaskBlue:Boolean = true;
      
      public var colorMaskAlpha:Boolean = true;
      
      public var culling:String = "none";
      
      public var depthTestMask:Boolean = true;
      
      public var depthTestPassCompareMode:String = "less";
      
      public var program:ProgramResource = null;
      
      public var renderTarget:TextureResource = null;
      
      public var renderTargetEnableDepthAndStencil:Boolean = false;
      
      public var renderTargetAntiAlias:int = 0;
      
      public var renderTargetSurfaceSelector:int = 0;
      
      public var scissor:Boolean = false;
      
      public var scissorRectangle:Rectangle;
      
      public var stencilActionTriangleFace:String = "frontAndBack";
      
      public var stencilActionCompareMode:String = "always";
      
      public var stencilActionOnBothPass:String = "keep";
      
      public var stencilActionOnDepthFail:String = "keep";
      
      public var stencilActionOnDepthPassStencilFail:String = "keep";
      
      public var stencilReferenceValue:uint = 0;
      
      public var stencilReadMask:uint = 255;
      
      public var stencilWriteMask:uint = 255;
      
      public var textures:Vector.<TextureResource>;
      
      public var vertexBuffers:Vector.<VertexBufferResource>;
      
      public var vertexBuffersOffsets:Vector.<int>;
      
      public var vertexBuffersFormats:Vector.<String>;
      
      public var vertexConstants:Vector.<Number>;
      
      public var fragmentConstants:Vector.<Number>;
      
      public function RenderState()
      {
         this.scissorRectangle = new Rectangle();
         this.textures = new Vector.<TextureResource>(8,true);
         this.vertexBuffers = new Vector.<VertexBufferResource>(8,true);
         this.vertexBuffersOffsets = new Vector.<int>(8,true);
         this.vertexBuffersFormats = new Vector.<String>(8,true);
         this.vertexConstants = new Vector.<Number>(512,true);
         this.fragmentConstants = new Vector.<Number>(512,true);
         super();
      }
   }
}
