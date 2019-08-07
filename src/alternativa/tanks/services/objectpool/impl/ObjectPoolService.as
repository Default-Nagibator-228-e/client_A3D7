package alternativa.tanks.services.objectpool.impl
{
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   
   public class ObjectPoolService implements IObjectPoolService
   {
       
      
      private var _objectPool:ObjectPool;
      
      public function ObjectPoolService()
      {
         this._objectPool = new ObjectPool();
         super();
      }
      
      public function get objectPool() : ObjectPool
      {
         return this._objectPool;
      }
      
      public function clear() : void
      {
         this._objectPool.clear();
      }
   }
}
