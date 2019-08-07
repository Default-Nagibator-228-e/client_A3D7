package alternativa.tanks.physics
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.BodyList;
   import alternativa.physics.BodyListItem;
   import alternativa.physics.CollisionPrimitiveListItem;
   import alternativa.physics.Contact;
   import alternativa.physics.ContactPoint;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionKdNode;
   import alternativa.physics.collision.CollisionKdTree;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.ICollider;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.IRayCollisionPredicate;
   import alternativa.physics.collision.colliders.BoxBoxCollider;
   import alternativa.physics.collision.colliders.BoxRectCollider;
   import alternativa.physics.collision.colliders.BoxSphereCollider;
   import alternativa.physics.collision.colliders.BoxTriangleCollider;
   import alternativa.physics.collision.types.BoundBox;
   import alternativa.physics.collision.types.RayIntersection;
   
   use namespace altphysics;
   
   public class TanksCollisionDetector implements ICollisionDetector
   {
       
      
      public var tree:CollisionKdTree;
      
      public var bodies:BodyList;
      
      public var threshold:Number = 1.0E-4;
      
      private var colliders:Object;
      
      private var _time:MinMax;
      
      private var _n:Vector3;
      
      private var _o:Vector3;
      
      private var _dynamicIntersection:RayIntersection;
      
      private var _rayAABB:BoundBox;
      
      public function TanksCollisionDetector()
      {
         this.colliders = {};
         this._time = new MinMax();
         this._n = new Vector3();
         this._o = new Vector3();
         this._dynamicIntersection = new RayIntersection();
         this._rayAABB = new BoundBox();
         super();
         this.tree = new CollisionKdTree();
         this.bodies = new BodyList();
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.BOX,new BoxBoxCollider());
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.RECT,new BoxRectCollider());
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.TRIANGLE,new BoxTriangleCollider());
         this.addCollider(CollisionPrimitive.BOX,CollisionPrimitive.SPHERE,new BoxSphereCollider());
      }
      
      public function buildKdTree(collisionPrimitives:Vector.<CollisionPrimitive>, boundBox:BoundBox = null) : void
      {
         this.tree.createTree(collisionPrimitives,boundBox);
      }
      
      public function addBody(body:Body) : void
      {
         this.bodies.append(body);
      }
      
      public function removeBody(body:Body) : void
      {
         this.bodies.remove(body);
      }
      
      public function getAllContacts(contact:Contact) : Contact
      {
         var cpListItem1:CollisionPrimitiveListItem = null;
         var body:Body = null;
         var cpListItem2:CollisionPrimitiveListItem = null;
         var bodyListItem2:BodyListItem = null;
         var otherBody:Body = null;
         var abort:Boolean = false;
         var primitive1:CollisionPrimitive = null;
         var bodyListItem1:BodyListItem = this.bodies.head;
         while(bodyListItem1 != null)
         {
            body = bodyListItem1.body;
            if(!body.frozen)
            {
               cpListItem1 = body.collisionPrimitives.head;
               while(cpListItem1 != null)
               {
                  contact = this.getPrimitiveNodeCollisions(this.tree.rootNode,cpListItem1.primitive,contact);
                  cpListItem1 = cpListItem1.next;
               }
            }
            bodyListItem2 = bodyListItem1.next;
            while(bodyListItem2 != null)
            {
               otherBody = bodyListItem2.body;
               if(body.frozen && otherBody.frozen || !body.aabb.intersects(otherBody.aabb,0.1))
               {
                  bodyListItem2 = bodyListItem2.next;
               }
               else
               {
                  cpListItem1 = body.collisionPrimitives.head;
                  abort = false;
                  while(cpListItem1 != null && !abort)
                  {
                     primitive1 = cpListItem1.primitive;
                     cpListItem2 = otherBody.collisionPrimitives.head;
                     while(cpListItem2 != null)
                     {
                        if(this.getContact(primitive1,cpListItem2.primitive,contact))
                        {
                           if(body.postCollisionPredicate != null && !body.postCollisionPredicate.considerBodies(body,otherBody) || otherBody.postCollisionPredicate != null && !otherBody.postCollisionPredicate.considerBodies(otherBody,body))
                           {
                              abort = true;
                              break;
                           }
                           contact = contact.next;
                        }
                        cpListItem2 = cpListItem2.next;
                     }
                     cpListItem1 = cpListItem1.next;
                  }
                  bodyListItem2 = bodyListItem2.next;
               }
            }
            bodyListItem1 = bodyListItem1.next;
         }
         return contact;
      }
      
      public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact) : Boolean
      {
         var pen:Number = NaN;
         var i:int = 0;
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
         var colliderId:int = prim1.type <= prim2.type?int(prim1.type << 16 | prim2.type):int(prim2.type << 16 | prim1.type);
         var collider:ICollider = this.colliders[colliderId];
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
            if(prim1.body != null)
            {
               prim1.body.contacts[prim1.body.contactsNum++] = contact;
            }
            if(prim2.body != null)
            {
               prim2.body.contacts[prim2.body.contactsNum++] = contact;
            }
            contact.maxPenetration = (contact.points[0] as ContactPoint).penetration;
            for(i = contact.pcount - 1; i >= 1; i--)
            {
               if((pen = (contact.points[i] as ContactPoint).penetration) > contact.maxPenetration)
               {
                  contact.maxPenetration = pen;
               }
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
         var colliderId:int = prim1.type <= prim2.type?int(prim1.type << 16 | prim2.type):int(prim2.type << 16 | prim1.type);
         var collider:ICollider = this.colliders[colliderId];
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
      
      public function testPrimitiveTreeCollision(primitive:CollisionPrimitive) : Boolean
      {
         return this.testPrimitiveNodeCollision(primitive,this.tree.rootNode);
      }
      
      private function addCollider(type1:int, type2:int, collider:ICollider) : void
      {
         this.colliders[type1 <= type2?type1 << 16 | type2:type2 << 16 | type1] = collider;
      }
      
      private function getPrimitiveNodeCollisions(node:CollisionKdNode, primitive:CollisionPrimitive, contact:Contact) : Contact
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var primitives:Vector.<CollisionPrimitive> = null;
         var indices:Vector.<int> = null;
         var i:int = 0;
         if(node.indices != null)
         {
            primitives = this.tree.staticChildren;
            indices = node.indices;
            for(i = indices.length - 1; i >= 0; i--)
            {
               if(this.getContact(primitive,primitives[indices[i]],contact))
               {
                  contact = contact.next;
               }
            }
         }
         if(node.axis == -1)
         {
            return contact;
         }
         switch(node.axis)
         {
            case 0:
               min = primitive.aabb.minX;
               max = primitive.aabb.maxX;
               break;
            case 1:
               min = primitive.aabb.minY;
               max = primitive.aabb.maxY;
               break;
            case 2:
               min = primitive.aabb.minZ;
               max = primitive.aabb.maxZ;
         }
         if(min < node.coord)
         {
            contact = this.getPrimitiveNodeCollisions(node.negativeNode,primitive,contact);
         }
         if(max > node.coord)
         {
            contact = this.getPrimitiveNodeCollisions(node.positiveNode,primitive,contact);
         }
         if(node.splitTree != null && min < node.coord && max > node.coord)
         {
            contact = this.getPrimitiveNodeCollisions(node.splitTree.rootNode,primitive,contact);
         }
         return contact;
      }
      
      private function testPrimitiveNodeCollision(primitive:CollisionPrimitive, node:CollisionKdNode) : Boolean
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var primitives:Vector.<CollisionPrimitive> = null;
         var indices:Vector.<int> = null;
         var i:int = 0;
         if(node.indices != null)
         {
            primitives = this.tree.staticChildren;
            indices = node.indices;
            for(i = indices.length - 1; i >= 0; i--)
            {
               if(this.testCollision(primitive,primitives[indices[i]]))
               {
                  return true;
               }
            }
         }
         if(node.axis == -1)
         {
            return false;
         }
         switch(node.axis)
         {
            case 0:
               min = primitive.aabb.minX;
               max = primitive.aabb.maxX;
               break;
            case 1:
               min = primitive.aabb.minY;
               max = primitive.aabb.maxY;
               break;
            case 2:
               min = primitive.aabb.minZ;
               max = primitive.aabb.maxZ;
         }
         if(node.splitTree != null && min < node.coord && max > node.coord)
         {
            if(this.testPrimitiveNodeCollision(primitive,node.splitTree.rootNode))
            {
               return true;
            }
         }
         if(min < node.coord)
         {
            if(this.testPrimitiveNodeCollision(primitive,node.negativeNode))
            {
               return true;
            }
         }
         if(max > node.coord)
         {
            if(this.testPrimitiveNodeCollision(primitive,node.positiveNode))
            {
               return true;
            }
         }
         return false;
      }
      
      private function intersectRayWithDynamic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection) : Boolean
      {
         var body:Body = null;
         var aabb:BoundBox = null;
         var listItem:CollisionPrimitiveListItem = null;
         var primitive:CollisionPrimitive = null;
         var t:Number = NaN;
         var xx:Number = origin.x + dir.x * maxTime;
         var yy:Number = origin.y + dir.y * maxTime;
         var zz:Number = origin.z + dir.z * maxTime;
         if(xx < origin.x)
         {
            this._rayAABB.minX = xx;
            this._rayAABB.maxX = origin.x;
         }
         else
         {
            this._rayAABB.minX = origin.x;
            this._rayAABB.maxX = xx;
         }
         if(yy < origin.y)
         {
            this._rayAABB.minY = yy;
            this._rayAABB.maxY = origin.y;
         }
         else
         {
            this._rayAABB.minY = origin.y;
            this._rayAABB.maxY = yy;
         }
         if(zz < origin.z)
         {
            this._rayAABB.minZ = zz;
            this._rayAABB.maxZ = origin.z;
         }
         else
         {
            this._rayAABB.minZ = origin.z;
            this._rayAABB.maxZ = zz;
         }
         var minTime:Number = maxTime + 1;
         var bodyItem:BodyListItem = this.bodies.head;
         while(bodyItem != null)
         {
            body = bodyItem.body;
            aabb = body.aabb;
            if(this._rayAABB.maxX < aabb.minX || this._rayAABB.minX > aabb.maxX || this._rayAABB.maxY < aabb.minY || this._rayAABB.minY > aabb.maxY || this._rayAABB.maxZ < aabb.minZ || this._rayAABB.minZ > aabb.maxZ)
            {
               bodyItem = bodyItem.next;
            }
            else
            {
               listItem = body.collisionPrimitives.head;
               while(listItem != null)
               {
                  primitive = listItem.primitive;
                  if((primitive.collisionGroup & collisionGroup) == 0)
                  {
                     listItem = listItem.next;
                  }
                  else
                  {
                     aabb = primitive.aabb;
                     if(this._rayAABB.maxX < aabb.minX || this._rayAABB.minX > aabb.maxX || this._rayAABB.maxY < aabb.minY || this._rayAABB.minY > aabb.maxY || this._rayAABB.maxZ < aabb.minZ || this._rayAABB.minZ > aabb.maxZ)
                     {
                        listItem = listItem.next;
                     }
                     else if(predicate != null && !predicate.considerBody(body))
                     {
                        listItem = listItem.next;
                     }
                     else
                     {
                        t = primitive.getRayIntersection(origin,dir,this.threshold,this._n);
                        if(t >= 0 && t < minTime)
                        {
                           minTime = t;
                           result.primitive = primitive;
                           result.normal.x = this._n.x;
                           result.normal.y = this._n.y;
                           result.normal.z = this._n.z;
                        }
                        listItem = listItem.next;
                     }
                  }
               }
               bodyItem = bodyItem.next;
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
         var splitNode:CollisionKdNode = null;
         var i:int = 0;
         var primitive:CollisionPrimitive = null;
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
         if(node.splitTree != null)
         {
            splitNode = node.splitTree.rootNode;
            while(splitNode != null && splitNode.axis != -1)
            {
               switch(splitNode.axis)
               {
                  case 0:
                     splitNode = this._o.x < splitNode.coord?splitNode.negativeNode:splitNode.positiveNode;
                     continue;
                  case 1:
                     splitNode = this._o.y < splitNode.coord?splitNode.negativeNode:splitNode.positiveNode;
                     continue;
                  case 2:
                     splitNode = this._o.z < splitNode.coord?splitNode.negativeNode:splitNode.positiveNode;
                     continue;
                  default:
                     continue;
               }
            }
            if(splitNode != null && splitNode.indices != null)
            {
               for(i = splitNode.indices.length - 1; i >= 0; i--)
               {
                  primitive = this.tree.staticChildren[splitNode.indices[i]];
                  if((primitive.collisionGroup & collisionGroup) != 0)
                  {
                     if(!(predicate != null && primitive.body != null && !predicate.considerBody(primitive.body)))
                     {
                        result.t = primitive.getRayIntersection(origin,dir,this.threshold,result.normal);
                        if(result.t >= 0)
                        {
                           result.pos.vCopy(this._o);
                           result.primitive = primitive;
                           return true;
                        }
                     }
                  }
               }
            }
         }
         return this.testRayAgainstNode(currChildNode == node.negativeNode?node.positiveNode:node.negativeNode,origin,this._o,dir,collisionGroup,splitTime,t2,predicate,result);
      }
      
      private function getRayNodeIntersection(origin:Vector3, dir:Vector3, collisionGroup:int, primitives:Vector.<CollisionPrimitive>, indices:Vector.<int>, predicate:IRayCollisionPredicate, intersection:RayIntersection) : Boolean
      {
         var primitive:CollisionPrimitive = null;
         var t:Number = NaN;
         var pnum:int = indices.length;
         var minTime:Number = 1.0e308;
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
