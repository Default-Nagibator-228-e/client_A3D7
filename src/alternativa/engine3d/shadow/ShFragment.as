package alternativa.engine3d.shadow 
{
	import alternativa.gfx.agal.FragmentShader;
   import alternativa.gfx.agal.SamplerDim;
   import alternativa.gfx.agal.SamplerFilter;
   import alternativa.gfx.agal.SamplerMipMap;
   import alternativa.gfx.agal.SamplerRepeat;
   
	public class ShFragment extends FragmentShader
	{
		
		public function ShFragment() 
		{
			super();
			tex(ft0, v1, fs0.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.LINEAR).mipmap(SamplerMipMap.LINEAR));
			mov(oc, ft0);
		}
		
	}

}