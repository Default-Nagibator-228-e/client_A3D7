package alternativa.tanks.utils.objectpool
{
   import flash.utils.Dictionary;
   
   public class ObjectPool
   {
       
      
      private var pools:Dictionary;
      
      public function ObjectPool()
      {
         this.pools = new Dictionary();
         super();
      }
      
      public function getObject(objectClass:Class) : Object
      {
         var pool:Pool = this.pools[objectClass];
         if(pool == null)
         {
            this.pools[objectClass] = pool = new Pool();
         }
         var object:Object = pool.getObject();
         return object == null?new objectClass(this):object;
      }
      
      public function putObject(objectClass:Class, object:Object) : void
      {
         var pool:Pool = this.pools[objectClass];
         if(pool == null)
         {
            this.pools[objectClass] = pool = new Pool();
         }
         pool.putObject(object);
      }
      
      public function clear() : void
      {
         var key:* = undefined;
         for(key in this.pools)
         {
            Pool(this.pools[key]).clear();
            delete this.pools[key];
         }
      }
   }
}

class Pool
{
    
   
   private var objects:Vector.<Object>;
   
   private var numObjects:int;
   
   function Pool()
   {
      this.objects = new Vector.<Object>();
      super();
   }
   
   public function getObject() : Object
   {
      if(this.numObjects == 0)
      {
         return null;
      }
      var object:Object = this.objects[--this.numObjects];
      this.objects[this.numObjects] = null;
      return object;
   }
   
   public function putObject(object:Object) : void
   {
      var _loc2_:* = this.numObjects++;
      this.objects[_loc2_] = object;
   }
   
   public function clear() : void
   {
      this.objects.length = 0;
      this.numObjects = 0;
   }
}
