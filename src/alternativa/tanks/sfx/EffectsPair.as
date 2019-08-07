package alternativa.tanks.sfx
{
   public class EffectsPair
   {
       
      
      public var graphicEffect:IGraphicEffect;
      
      public var soundEffect:ISound3DEffect;
      
      public function EffectsPair(graphicEffect:IGraphicEffect, soundEffect:ISound3DEffect)
      {
         super();
         this.graphicEffect = graphicEffect;
         this.soundEffect = soundEffect;
      }
   }
}
