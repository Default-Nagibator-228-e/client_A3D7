package alternativa.physics.collision
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.Contact;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.colliders.BoxBoxCollider;
   import alternativa.physics.collision.colliders.BoxRectCollider;
   import alternativa.physics.collision.colliders.BoxSphereCollider;
   import alternativa.physics.collision.colliders.BoxTriangleCollider;
   import alternativa.physics.collision.colliders.SphereSphereCollider;
   import alternativa.physics.collision.types.BoundBox;
   import alternativa.physics.collision.types.RayIntersection;
   
   use namespace altphysics;
   
   public class KdTreeCollisionDetector implements ICollisionDetector
   {
      
      private static var _rayAABB:BoundBox = new BoundBox();
       
      
      altphysics var tree:CollisionKdTree;
      
      altphysics var dynamicPrimitives:Vector.<CollisionPrimitive>;
      
      altphysics var dynamicPrimitivesNum:int;
      
      altphysics var threshold:Number = 1.0E-4;
      
      private var colliders:Object;
      
      private var _time:MinMax;
      
      private var _n:Vector3;
      
      private var _o:Vector3;
      
      private var _dynamicIntersection:RayIntersection;
      
      public function KdTreeCollisionDetector()
      {
         this.colliders = {};
         this._time = new MinMax();
         this._n = new Vector3();
         this._o = new Vector3();
         this._dynamicIntersection = new RayIntersection();
         super();
         this.tree = new CollisionKdTree();
         this.dynamicPrimitives = new Vector.<CollisionPrimitive>();
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.BOX,new BoxBoxCollider());
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.SPHERE,new BoxSphereCollider());
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.RECT,new BoxRectCollider());
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.TRIANGLE,new BoxTriangleCollider());
         this.addCollider(CollisionPrimitive.SPHERE,CollisionPrimitive.SPHERE,new SphereSphereCollider());
      }
      
      public function addPrimitive(primitive:CollisionPrimitive, isStatic:Boolean = true) : Boolean
      {
         return true;
      }
      
      public function removePrimitive(primitive:CollisionPrimitive, isStatic:Boolean = true) : Boolean
      {
         return true;
      }
      
      public function init(collisionPrimitives:Vector.<CollisionPrimitive>) : void
      {
         this.tree.createTree(collisionPrimitives);
      }
      
      public function getAllContacts(contacts:Contact) : Contact
      {
         return null;
      }
      
      public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact) : Boolean
      {
         if((prim1.collisionGroup & prim2.collisionGroup) == 0)
         {
            return false;
         }
         if(prim1.body != null && prim1.body == prim2.body)
         {
            return false;
         }
         if(!prim1.aabb.intersects(prim2.aabb,0.01))
         {
            return false;
         }
         var collider:ICollider = this.colliders[prim1.type <= prim2.type?prim1.type << 16 | prim2.type:prim2.type << 16 | prim1.type] as ICollider;
         if(collider != null && collider.getContact(prim1,prim2,contact))
         {
            if(prim1.postCollisionPredicate != null && !prim1.postCollisionPredicate.considerCollision(prim2))
            {
               return false;
            }
            if(prim2.postCollisionPredicate != null && !prim2.postCollisionPredicate.considerCollision(prim1))
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive) : Boolean
      {
         if((prim1.collisionGroup & prim2.collisionGroup) == 0)
         {
            return false;
         }
         if(prim1.body != null && prim1.body == prim2.body)
         {
            return false;
         }
         if(!prim1.aabb.intersects(prim2.aabb,0.01))
         {
            return false;
         }
         var collider:ICollider = this.colliders[prim1.type <= prim2.type?prim1.type << 16 | prim2.type:prim2.type << 16 | prim1.type] as ICollider;
         if(collider != null && collider.haveCollision(prim1,prim2))
         {
            if(prim1.postCollisionPredicate != null && !prim1.postCollisionPredicate.considerCollision(prim2))
            {
               return false;
            }
            if(prim2.postCollisionPredicate != null && !prim2.postCollisionPredicate.considerCollision(prim1))
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function intersectRay(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection) : Boolean
      {
         var hasStaticIntersection:Boolean = this.intersectRayWithStatic(origin,dir,collisionGroup,maxTime,predicate,result);
         var hasDynamicIntersection:Boolean = this.intersectRayWithDynamic(origin,dir,collisionGroup,maxTime,predicate,this._dynamicIntersection);
         if(!(hasDynamicIntersection || hasStaticIntersection))
         {
            return false;
         }
         if(hasDynamicIntersection && hasStaticIntersection)
         {
            if(result.t > this._dynamicIntersection.t)
            {
               result.copy(this._dynamicIntersection);
            }
            return true;
         }
         if(hasStaticIntersection)
         {
            return true;
         }
         result.copy(this._dynamicIntersection);
         return true;
      }
      
      public function intersectRayWithStatic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection) : Boolean
      {
         if(!this.getRayBoundBoxIntersection(origin,dir,this.tree.rootNode.boundBox,this._time))
         {
            return false;
         }
         if(this._time.max < 0 || this._time.min > maxTime)
         {
            return false;
         }
         if(this._time.min <= 0)
         {
            this._time.min = 0;
            this._o.x = origin.x;
            this._o.y = origin.y;
            this._o.z = origin.z;
         }
         else
         {
            this._o.x = origin.x + this._time.min * dir.x;
            this._o.y = origin.y + this._time.min * dir.y;
            this._o.z = origin.z + this._time.min * dir.z;
         }
         if(this._time.max > maxTime)
         {
            this._time.max = maxTime;
         }
         var hasIntersection:Boolean = this.testRayAgainstNode(this.tree.rootNode,origin,this._o,dir,collisionGroup,this._time.min,this._time.max,predicate,result);
         return !!hasIntersection?Boolean(result.t <= maxTime):Boolean(false);
      }
      
      public function testBodyPrimitiveCollision(body:Body, primitive:CollisionPrimitive) : Boolean
      {
         return false;
      }
      
      private function addCollider(type1:int, type2:int, collider:ICollider) : void
      {
         this.colliders[type1 <= type2?type1 << 16 | type2:type2 << 16 | type1] = collider;
      }
      
      private function getPrimitiveNodeCollisions(node:CollisionKdNode, primitive:CollisionPrimitive, contacts:Contact) : Contact
      {
         return null;
      }
      
      private function intersectRayWithDynamic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection) : Boolean
      {
         var primitive:CollisionPrimitive = null;
         var paabb:BoundBox = null;
         var t:Number = NaN;
         var xx:Number = origin.x + dir.x * maxTime;
         var yy:Number = origin.y + dir.y * maxTime;
         var zz:Number = origin.z + dir.z * maxTime;
         if(xx < origin.x)
         {
            _rayAABB.minX = xx;
            _rayAABB.maxX = origin.x;
         }
         else
         {
            _rayAABB.minX = origin.x;
            _rayAABB.maxX = xx;
         }
         if(yy < origin.y)
         {
            _rayAABB.minY = yy;
            _rayAABB.maxY = origin.y;
         }
         else
         {
            _rayAABB.minY = origin.y;
            _rayAABB.maxY = yy;
         }
         if(zz < origin.z)
         {
            _rayAABB.minZ = zz;
            _rayAABB.maxZ = origin.z;
         }
         else
         {
            _rayAABB.minZ = origin.z;
            _rayAABB.maxZ = zz;
         }
         var minTime:Number = maxTime + 1;
         for(var i:int = 0; i < this.dynamicPrimitivesNum; i++)
         {
            primitive = this.dynamicPrimitives[i];
            if((primitive.collisionGroup & collisionGroup) != 0)
            {
               paabb = primitive.aabb;
               if(!(_rayAABB.maxX < paabb.minX || _rayAABB.minX > paabb.maxX || _rayAABB.maxY < paabb.minY || _rayAABB.minY > paabb.maxY || _rayAABB.maxZ < paabb.minZ || _rayAABB.minZ > paabb.maxZ))
               {
                  if(!(predicate != null && primitive.body != null && !predicate.considerBody(primitive.body)))
                  {
                     t = primitive.getRayIntersection(origin,dir,this.threshold,this._n);
                     if(t > 0 && t < minTime)
                     {
                        minTime = t;
                        result.primitive = primitive;
                        result.normal.x = this._n.x;
                        result.normal.y = this._n.y;
                        result.normal.z = this._n.z;
                     }
                  }
               }
            }
         }
         if(minTime > maxTime)
         {
            return false;
         }
         result.pos.x = origin.x + dir.x * minTime;
         result.pos.y = origin.y + dir.y * minTime;
         result.pos.z = origin.z + dir.z * minTime;
         result.t = minTime;
         return true;
      }
      
      private function getRayBoundBoxIntersection(origin:Vector3, dir:Vector3, bb:BoundBox, time:MinMax) : Boolean
      {
         var t1:Number = NaN;
         var t2:Number = NaN;
         time.min = -1;
         time.max = 1.0e308;
         for(var i:int = 0; i < 3; i++)
         {
            switch(i)
            {
               case 0:
                  if(dir.x < this.threshold && dir.x > -this.threshold)
                  {
                     if(origin.x < bb.minX || origin.x > bb.maxX)
                     {
                        return false;
                     }
                     continue;
                  }
                  t1 = (bb.minX - origin.x) / dir.x;
                  t2 = (bb.maxX - origin.x) / dir.x;
                  break;
               case 1:
                  if(dir.y < this.threshold && dir.y > -this.threshold)
                  {
                     if(origin.y < bb.minY || origin.y > bb.maxY)
                     {
                        return false;
                     }
                     continue;
                  }
                  t1 = (bb.minY - origin.y) / dir.y;
                  t2 = (bb.maxY - origin.y) / dir.y;
                  break;
               case 2:
                  if(dir.z < this.threshold && dir.z > -this.threshold)
                  {
                     if(origin.z < bb.minZ || origin.z > bb.maxZ)
                     {
                        return false;
                     }
                     continue;
                  }
                  t1 = (bb.minZ - origin.z) / dir.z;
                  t2 = (bb.maxZ - origin.z) / dir.z;
                  break;
            }
            if(t1 < t2)
            {
               if(t1 > time.min)
               {
                  time.min = t1;
               }
               if(t2 < time.max)
               {
                  time.max = t2;
               }
            }
            else
            {
               if(t2 > time.min)
               {
                  time.min = t2;
               }
               if(t1 < time.max)
               {
                  time.max = t1;
               }
            }
            if(time.max < time.min)
            {
               return false;
            }
         }
         return true;
      }
      
      private function testRayAgainstNode(node:CollisionKdNode, origin:Vector3, localOrigin:Vector3, dir:Vector3, collisionGroup:int, t1:Number, t2:Number, predicate:IRayCollisionPredicate, result:RayIntersection) : Boolean
      {
         var splitTime:Number = NaN;
         var currChildNode:CollisionKdNode = null;
         var intersects:Boolean = false;
         if(node.indices != null && this.getRayNodeIntersection(origin,dir,collisionGroup,this.tree.staticChildren,node.indices,predicate,result))
         {
            return true;
         }
         if(node.axis == -1)
         {
            return false;
         }
         switch(node.axis)
         {
            case 0:
               if(dir.x > -this.threshold && dir.x < this.threshold)
               {
                  splitTime = t2 + 1;
               }
               else
               {
                  splitTime = (node.coord - origin.x) / dir.x;
               }
               currChildNode = localOrigin.x < node.coord?node.negativeNode:node.positiveNode;
               break;
            case 1:
               if(dir.y > -this.threshold && dir.y < this.threshold)
               {
                  splitTime = t2 + 1;
               }
               else
               {
                  splitTime = (node.coord - origin.y) / dir.y;
               }
               currChildNode = localOrigin.y < node.coord?node.negativeNode:node.positiveNode;
               break;
            case 2:
               if(dir.z > -this.threshold && dir.z < this.threshold)
               {
                  splitTime = t2 + 1;
               }
               else
               {
                  splitTime = (node.coord - origin.z) / dir.z;
               }
               currChildNode = localOrigin.z < node.coord?node.negativeNode:node.positiveNode;
         }
         if(splitTime < t1 || splitTime > t2)
         {
            return this.testRayAgainstNode(currChildNode,origin,localOrigin,dir,collisionGroup,t1,t2,predicate,result);
         }
         intersects = this.testRayAgainstNode(currChildNode,origin,localOrigin,dir,collisionGroup,t1,splitTime,predicate,result);
         if(intersects)
         {
            return true;
         }
         this._o.x = origin.x + splitTime * dir.x;
         this._o.y = origin.y + splitTime * dir.y;
         this._o.z = origin.z + splitTime * dir.z;
         return this.testRayAgainstNode(currChildNode == node.negativeNode?node.positiveNode:node.negativeNode,origin,this._o,dir,collisionGroup,splitTime,t2,predicate,result);
      }
      
      private function getRayNodeIntersection(origin:Vector3, dir:Vector3, collisionGroup:int, primitives:Vector.<CollisionPrimitive>, indices:Vector.<int>, predicate:IRayCollisionPredicate, intersection:RayIntersection) : Boolean
      {
         var minTime:Number = NaN;
         var primitive:CollisionPrimitive = null;
         var t:Number = NaN;
         var pnum:int = indices.length;
         minTime = 1.0e308;
         for(var i:int = 0; i < pnum; i++)
         {
            primitive = primitives[indices[i]];
            if((primitive.collisionGroup & collisionGroup) != 0)
            {
               if(!(predicate != null && primitive.body != null && !predicate.considerBody(primitive.body)))
               {
                  t = primitive.getRayIntersection(origin,dir,this.threshold,this._n);
                  if(t > 0 && t < minTime)
                  {
                     minTime = t;
                     intersection.primitive = primitive;
                     intersection.normal.x = this._n.x;
                     intersection.normal.y = this._n.y;
                     intersection.normal.z = this._n.z;
                  }
               }
            }
         }
         if(minTime == 1.0e308)
         {
            return false;
         }
         intersection.pos.x = origin.x + dir.x * minTime;
         intersection.pos.y = origin.y + dir.y * minTime;
         intersection.pos.z = origin.z + dir.z * minTime;
         intersection.t = minTime;
         return true;
      }
   }
}

class MinMax
{
    
   
   public var min:Number = 0;
   
   public var max:Number = 0;
   
   function MinMax()
   {
      super();
   }
}
