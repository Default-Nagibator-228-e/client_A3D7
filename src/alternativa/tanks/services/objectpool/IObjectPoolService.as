package alternativa.tanks.services.objectpool
{
   import alternativa.tanks.utils.objectpool.ObjectPool;
   
   public interface IObjectPoolService
   {
       
      
      function get objectPool() : ObjectPool;
      
      function clear() : void;
   }
}
