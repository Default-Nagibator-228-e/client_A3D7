package alternativa.engine3d.core
{
   import alternativa.gfx.agal.FragmentShader;
   import alternativa.gfx.agal.SamplerDim;
   import alternativa.gfx.agal.SamplerFilter;
   import alternativa.gfx.agal.SamplerMipMap;
   import alternativa.gfx.agal.SamplerRepeat;
   
   public class ShadowReceiverFragmentShader extends FragmentShader
   {
       
      
      public function ShadowReceiverFragmentShader(param1:Boolean, param2:Boolean)
      {
         super();
         var _loc3_:SamplerFilter = param1?SamplerFilter.LINEAR:SamplerFilter.NEAREST;
         var _loc4_:SamplerMipMap = param1?SamplerMipMap.LINEAR:SamplerMipMap.NEAREST;
         if(param2)
         {
            max(ft0,v0,fc[16]);
            min(ft0.x,ft0,fc[16].z);
            min(ft0.y,ft0,fc[16].w);
            tex(ft0,ft0,fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(_loc3_).mipmap(SamplerMipMap.NONE));
         }
         else
         {
            tex(ft0,v0,fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(_loc3_).mipmap(SamplerMipMap.NONE));
         }
         sub(ft1,v0.z,fc[14]);
         div(ft2,ft1,fc[13]);
         max(ft3,ft1,fc[13].x);
         mul(ft3,ft3,fc[13].y);
         min(ft3,ft3,fc[14]);
         sub(ft4,fc[14],ft3);
         mul(ft2,ft2,ft3);
         mul(ft1,ft1,ft4);
         add(ft2,ft1,ft2);
         sub(ft2,fc[14],ft2);
         mul(ft0,ft0,ft2);
         sub(ft1,v0,fc[14]);
         div(ft1,ft1,fc[14].y);
         sat(ft1,ft1);
         mul(ft0,ft0,ft1.z);
         mov(ft0.xyz,fc[15]);
         mul(ft0.w,ft0,fc[15]);
         mov(oc,ft0);
      }
   }
}
