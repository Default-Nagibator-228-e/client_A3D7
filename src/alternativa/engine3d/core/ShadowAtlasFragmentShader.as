package alternativa.engine3d.core
{
   import alternativa.gfx.agal.FragmentShader;
   import alternativa.gfx.agal.SamplerDim;
   import alternativa.gfx.agal.SamplerFilter;
   import alternativa.gfx.agal.SamplerMipMap;
   import alternativa.gfx.agal.SamplerRepeat;
   
   public class ShadowAtlasFragmentShader extends FragmentShader
   {
       
      
      public function ShadowAtlasFragmentShader(param1:int, param2:Boolean)
      {
         var _loc3_:int = 0;
         super();
         mov(ft1,v0);
         tex(ft3,ft1,fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.NEAREST).mipmap(SamplerMipMap.NONE));
         if(param2)
         {
            sub(ft1.x,v0,fc[1]);
         }
         else
         {
            sub(ft1.y,v0,fc[1]);
         }
         _loc3_ = -param1;
         while(_loc3_ <= param1)
         {
            if(_loc3_ != 0)
            {
               tex(ft2,ft1,fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.NEAREST).mipmap(SamplerMipMap.NONE));
               add(ft3.w,ft3,ft2);
            }
            if(param2)
            {
               add(ft1.x,ft1,fc[0]);
            }
            else
            {
               add(ft1.y,ft1,fc[0]);
            }
            _loc3_++;
         }
         div(ft3.w,ft3,fc[0]);
         mov(oc,ft3);
      }
   }
}
