package alternativa.physics.collision
{
   import alternativa.physics.collision.types.BoundBox;
   
   public class CollisionKdNode
   {
       
      
      public var indices:Vector.<int>;
      
      public var splitIndices:Vector.<int>;
      
      public var boundBox:BoundBox;
      
      public var parent:CollisionKdNode;
      
      public var splitTree:CollisionKdTree2D;
      
      public var axis:int = -1;
      
      public var coord:Number;
      
      public var positiveNode:CollisionKdNode;
      
      public var negativeNode:CollisionKdNode;
      
      public function CollisionKdNode()
      {
         super();
      }
   }
}
