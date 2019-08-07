package alternativa.physics.collision
{
   import alternativa.physics.collision.types.BoundBox;
   
   public class CollisionKdTree
   {
      
      private static const nodeBoundBoxThreshold:BoundBox = new BoundBox();
      
      private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
      
      private static const _nodeBB:Vector.<Number> = new Vector.<Number>(6);
      
      private static const _bb:Vector.<Number> = new Vector.<Number>(6);
       
      
      public var threshold:Number = 0.1;
      
      public var minPrimitivesPerNode:int = 1;
      
      public var rootNode:CollisionKdNode;
      
      public var staticChildren:Vector.<CollisionPrimitive>;
      
      public var numStaticChildren:int;
      
      public var staticBoundBoxes:Vector.<BoundBox>;
      
      private var splitAxis:int;
      
      private var splitCoord:Number;
      
      private var splitCost:Number;
      
      public function CollisionKdTree()
      {
         this.staticBoundBoxes = new Vector.<BoundBox>();
         super();
      }
      
      public function createTree(collisionPrimitives:Vector.<CollisionPrimitive>, boundBox:BoundBox = null) : void
      {
         var child:CollisionPrimitive = null;
         var childBoundBox:BoundBox = null;
         this.staticChildren = collisionPrimitives.concat();
         this.numStaticChildren = this.staticChildren.length;
         this.rootNode = new CollisionKdNode();
         this.rootNode.indices = new Vector.<int>();
         var rootNodeBoundBox:BoundBox = this.rootNode.boundBox = boundBox != null?boundBox:new BoundBox();
         for(var i:int = 0; i < this.numStaticChildren; i++)
         {
            child = this.staticChildren[i];
            childBoundBox = this.staticBoundBoxes[i] = child.calculateAABB();
            rootNodeBoundBox.addBoundBox(childBoundBox);
            this.rootNode.indices[i] = i;
         }
         this.staticBoundBoxes.length = this.numStaticChildren;
         this.splitNode(this.rootNode);
         splitCoordsX.length = splitCoordsY.length = splitCoordsZ.length = 0;
      }
      
      private function splitNode(node:CollisionKdNode) : void
      {
         var nodeBoundBox:BoundBox = null;
         var i:int = 0;
         var j:int = 0;
         var boundBox:BoundBox = null;
         var min:Number = NaN;
         var max:Number = NaN;
         var indices:Vector.<int> = node.indices;
         var numPrimitives:int = indices.length;
         if(numPrimitives <= this.minPrimitivesPerNode)
         {
            return;
         }
         nodeBoundBox = node.boundBox;
         nodeBoundBoxThreshold.minX = nodeBoundBox.minX + this.threshold;
         nodeBoundBoxThreshold.minY = nodeBoundBox.minY + this.threshold;
         nodeBoundBoxThreshold.minZ = nodeBoundBox.minZ + this.threshold;
         nodeBoundBoxThreshold.maxX = nodeBoundBox.maxX - this.threshold;
         nodeBoundBoxThreshold.maxY = nodeBoundBox.maxY - this.threshold;
         nodeBoundBoxThreshold.maxZ = nodeBoundBox.maxZ - this.threshold;
         var doubleThreshold:Number = this.threshold * 2;
         var numSplitCoordsX:int = 0;
         var numSplitCoordsY:int = 0;
         var numSplitCoordsZ:int = 0;
         for(i = 0; i < numPrimitives; i++)
         {
            boundBox = this.staticBoundBoxes[indices[i]];
            if(boundBox.maxX - boundBox.minX <= doubleThreshold)
            {
               if(boundBox.minX <= nodeBoundBoxThreshold.minX)
               {
                  splitCoordsX[numSplitCoordsX++] = nodeBoundBox.minX;
               }
               else if(boundBox.maxX >= nodeBoundBoxThreshold.maxX)
               {
                  splitCoordsX[numSplitCoordsX++] = nodeBoundBox.maxX;
               }
               else
               {
                  splitCoordsX[numSplitCoordsX++] = (boundBox.minX + boundBox.maxX) * 0.5;
               }
            }
            else
            {
               if(boundBox.minX > nodeBoundBoxThreshold.minX)
               {
                  splitCoordsX[numSplitCoordsX++] = boundBox.minX;
               }
               if(boundBox.maxX < nodeBoundBoxThreshold.maxX)
               {
                  splitCoordsX[numSplitCoordsX++] = boundBox.maxX;
               }
            }
            if(boundBox.maxY - boundBox.minY <= doubleThreshold)
            {
               if(boundBox.minY <= nodeBoundBoxThreshold.minY)
               {
                  splitCoordsY[numSplitCoordsY++] = nodeBoundBox.minY;
               }
               else if(boundBox.maxY >= nodeBoundBoxThreshold.maxY)
               {
                  splitCoordsY[numSplitCoordsY++] = nodeBoundBox.maxY;
               }
               else
               {
                  splitCoordsY[numSplitCoordsY++] = (boundBox.minY + boundBox.maxY) * 0.5;
               }
            }
            else
            {
               if(boundBox.minY > nodeBoundBoxThreshold.minY)
               {
                  splitCoordsY[numSplitCoordsY++] = boundBox.minY;
               }
               if(boundBox.maxY < nodeBoundBoxThreshold.maxY)
               {
                  splitCoordsY[numSplitCoordsY++] = boundBox.maxY;
               }
            }
            if(boundBox.maxZ - boundBox.minZ <= doubleThreshold)
            {
               if(boundBox.minZ <= nodeBoundBoxThreshold.minZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = nodeBoundBox.minZ;
               }
               else if(boundBox.maxZ >= nodeBoundBoxThreshold.maxZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = nodeBoundBox.maxZ;
               }
               else
               {
                  splitCoordsZ[numSplitCoordsZ++] = (boundBox.minZ + boundBox.maxZ) * 0.5;
               }
            }
            else
            {
               if(boundBox.minZ > nodeBoundBoxThreshold.minZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = boundBox.minZ;
               }
               if(boundBox.maxZ < nodeBoundBoxThreshold.maxZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = boundBox.maxZ;
               }
            }
         }
         this.splitAxis = -1;
         this.splitCost = 1.0e308;
         _nodeBB[0] = nodeBoundBox.minX;
         _nodeBB[1] = nodeBoundBox.minY;
         _nodeBB[2] = nodeBoundBox.minZ;
         _nodeBB[3] = nodeBoundBox.maxX;
         _nodeBB[4] = nodeBoundBox.maxY;
         _nodeBB[5] = nodeBoundBox.maxZ;
         this.checkNodeAxis(node,0,numSplitCoordsX,splitCoordsX,_nodeBB);
         this.checkNodeAxis(node,1,numSplitCoordsY,splitCoordsY,_nodeBB);
         this.checkNodeAxis(node,2,numSplitCoordsZ,splitCoordsZ,_nodeBB);
         if(this.splitAxis < 0)
         {
            return;
         }
         var axisX:Boolean = this.splitAxis == 0;
         var axisY:Boolean = this.splitAxis == 1;
         node.axis = this.splitAxis;
         node.coord = this.splitCoord;
         node.negativeNode = new CollisionKdNode();
         node.negativeNode.parent = node;
         node.negativeNode.boundBox = nodeBoundBox.clone();
         node.positiveNode = new CollisionKdNode();
         node.positiveNode.parent = node;
         node.positiveNode.boundBox = nodeBoundBox.clone();
         if(axisX)
         {
            node.negativeNode.boundBox.maxX = node.positiveNode.boundBox.minX = this.splitCoord;
         }
         else if(axisY)
         {
            node.negativeNode.boundBox.maxY = node.positiveNode.boundBox.minY = this.splitCoord;
         }
         else
         {
            node.negativeNode.boundBox.maxZ = node.positiveNode.boundBox.minZ = this.splitCoord;
         }
         var coordMin:Number = this.splitCoord - this.threshold;
         var coordMax:Number = this.splitCoord + this.threshold;
         for(i = 0; i < numPrimitives; i++)
         {
            boundBox = this.staticBoundBoxes[indices[i]];
            min = !!axisX?Number(boundBox.minX):!!axisY?Number(boundBox.minY):Number(boundBox.minZ);
            max = !!axisX?Number(boundBox.maxX):!!axisY?Number(boundBox.maxY):Number(boundBox.maxZ);
            if(max <= coordMax)
            {
               if(min < coordMin)
               {
                  if(node.negativeNode.indices == null)
                  {
                     node.negativeNode.indices = new Vector.<int>();
                  }
                  node.negativeNode.indices.push(indices[i]);
                  indices[i] = -1;
               }
               else
               {
                  if(node.splitIndices == null)
                  {
                     node.splitIndices = new Vector.<int>();
                  }
                  node.splitIndices.push(indices[i]);
                  indices[i] = -1;
               }
            }
            else if(min >= coordMin)
            {
               if(node.positiveNode.indices == null)
               {
                  node.positiveNode.indices = new Vector.<int>();
               }
               node.positiveNode.indices.push(indices[i]);
               indices[i] = -1;
            }
         }
         for(i = 0,j = 0; i < numPrimitives; i++)
         {
            if(indices[i] >= 0)
            {
               indices[j++] = indices[i];
            }
         }
         if(j > 0)
         {
            indices.length = j;
         }
         else
         {
            node.indices = null;
         }
         if(node.splitIndices != null)
         {
            node.splitTree = new CollisionKdTree2D(this,node);
            node.splitTree.createTree();
         }
         if(node.negativeNode.indices != null)
         {
            this.splitNode(node.negativeNode);
         }
         if(node.positiveNode.indices != null)
         {
            this.splitNode(node.positiveNode);
         }
      }
      
      private function checkNodeAxis(node:CollisionKdNode, axis:int, numSplitCoords:int, splitCoords:Vector.<Number>, bb:Vector.<Number>) : void
      {
         var currSplitCoord:Number = NaN;
         var minCoord:Number = NaN;
         var maxCoord:Number = NaN;
         var areaNegative:Number = NaN;
         var areaPositive:Number = NaN;
         var numNegative:int = 0;
         var numPositive:int = 0;
         var conflict:Boolean = false;
         var numObjects:int = 0;
         var j:int = 0;
         var cost:Number = NaN;
         var boundBox:BoundBox = null;
         var axis1:int = (axis + 1) % 3;
         var axis2:int = (axis + 2) % 3;
         var area:Number = (bb[axis1 + 3] - bb[axis1]) * (bb[axis2 + 3] - bb[axis2]);
         for(var i:int = 0; i < numSplitCoords; i++)
         {
            currSplitCoord = splitCoords[i];
            if(!isNaN(currSplitCoord))
            {
               minCoord = currSplitCoord - this.threshold;
               maxCoord = currSplitCoord + this.threshold;
               areaNegative = area * (currSplitCoord - bb[axis]);
               areaPositive = area * (bb[int(axis + 3)] - currSplitCoord);
               numNegative = 0;
               numPositive = 0;
               conflict = false;
               numObjects = node.indices.length;
               for(j = 0; j < numObjects; j++)
               {
                  boundBox = this.staticBoundBoxes[node.indices[j]];
                  _bb[0] = boundBox.minX;
                  _bb[1] = boundBox.minY;
                  _bb[2] = boundBox.minZ;
                  _bb[3] = boundBox.maxX;
                  _bb[4] = boundBox.maxY;
                  _bb[5] = boundBox.maxZ;
                  if(_bb[axis + 3] <= maxCoord)
                  {
                     if(_bb[axis] < minCoord)
                     {
                        numNegative++;
                     }
                  }
                  else if(_bb[axis] >= minCoord)
                  {
                     numPositive++;
                  }
                  else
                  {
                     conflict = true;
                     break;
                  }
               }
               cost = areaNegative * numNegative + areaPositive * numPositive;
               if(!conflict && cost < this.splitCost)
               {
                  this.splitAxis = axis;
                  this.splitCost = cost;
                  this.splitCoord = currSplitCoord;
               }
               for(j = i + 1; j < numSplitCoords; j++)
               {
                  if(splitCoords[j] >= currSplitCoord - this.threshold && splitCoords[j] <= currSplitCoord + this.threshold)
                  {
                     splitCoords[j] = NaN;
                  }
               }
            }
         }
      }
      
      public function traceTree() : void
      {
         this.traceNode("",this.rootNode);
      }
      
      private function traceNode(str:String, node:CollisionKdNode) : void
      {
         if(node == null)
         {
            return;
         }
         trace(str,node.axis == -1?"end":node.axis == 0?"X":node.axis == 1?"Y":"Z","splitCoord=" + this.splitCoord,"bound",node.boundBox,"objs:",node.indices);
         this.traceNode(str + "-",node.negativeNode);
         this.traceNode(str + "+",node.positiveNode);
      }
   }
}
