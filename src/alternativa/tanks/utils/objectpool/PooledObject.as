package alternativa.tanks.utils.objectpool
{
   public class PooledObject
   {
       
      
      protected var objectPool:ObjectPool;
      
      public function PooledObject(objectPool:ObjectPool)
      {
         super();
         this.objectPool = objectPool;
      }
      
      public final function storeInPool() : void
      {
         this.objectPool.putObject(this.getClass(),this);
      }
      
      protected function getClass() : Class
      {
         throw new Error("Not implemented");
      }
   }
}
