package alternativa.tanks.models.sfx.colortransform
{
   import utils.client.models.ClientObject;
   
   public interface IColorTransformModel
   {
       
      
      function getModelData(param1:ClientObject) : Vector.<ColorTransformEntry>;
   }
}
