package alternativa.tanks.sfx
{
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   
   public interface IGraphicEffect extends ISpecialEffect
   {
       
      
      function addToContainer(param1:Scene3DContainer) : void;
   }
}
