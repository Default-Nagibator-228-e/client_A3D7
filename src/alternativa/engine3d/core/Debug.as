package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class Debug
   {
      
      public static const BOUNDS:int = 1;//256
      
      public static const EDGES:int = 1;//512
      
      public static const NODES:int = 1;//1024
      
      public static const LIGHTS:int = 1;//2048
      
      public static const BONES:int = 1;//2048
	  
	  private static var canvas:Canvas = new Canvas();
      
      private static const boundVertexList:Vertex = Vertex.createList(8);
      
      private static const nodeVertexList:Vertex = Vertex.createList(4);
       
      
      public function Debug()
      {
         super();
      }
      
      alternativa3d static function drawEdges(camera:Camera3D, list:Face, color:int) : void
      {
         var t:Number = NaN;
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var viewSizeX:Number = camera.viewSizeX;
         var viewSizeY:Number = camera.viewSizeY;
         canvas.gfx.lineStyle(0,color);
         for(var face:Face = list; face != null; face = face.processNext)
         {
            wrapper = face.wrapper;
            vertex = wrapper.vertex;
            t = 1 / vertex.cameraZ;
            x = vertex.cameraX * viewSizeX * t;
            y = vertex.cameraY * viewSizeY * t;
            canvas.gfx.moveTo(x,y);
            for(wrapper = wrapper.next; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               t = 1 / vertex.cameraZ;
               canvas.gfx.lineTo(vertex.cameraX * viewSizeX * t,vertex.cameraY * viewSizeY * t);
            }
            canvas.gfx.lineTo(x,y);
         }
      }
      
      alternativa3d static function drawBounds(camera:Camera3D, transformation:Object3D, boundMinX:Number, boundMinY:Number, boundMinZ:Number, boundMaxX:Number, boundMaxY:Number, boundMaxZ:Number, color:int = -1, alpha:Number = 1) : void
      {
         var vertex:Vertex = null;
         var t:Number = NaN;
         var a:Vertex = boundVertexList;
         a.x = boundMinX;
         a.y = boundMinY;
         a.z = boundMinZ;
         var b:Vertex = a.next;
         b.x = boundMaxX;
         b.y = boundMinY;
         b.z = boundMinZ;
         var c:Vertex = b.next;
         c.x = boundMinX;
         c.y = boundMaxY;
         c.z = boundMinZ;
         var d:Vertex = c.next;
         d.x = boundMaxX;
         d.y = boundMaxY;
         d.z = boundMinZ;
         var e:Vertex = d.next;
         e.x = boundMinX;
         e.y = boundMinY;
         e.z = boundMaxZ;
         var f:Vertex = e.next;
         f.x = boundMaxX;
         f.y = boundMinY;
         f.z = boundMaxZ;
         var g:Vertex = f.next;
         g.x = boundMinX;
         g.y = boundMaxY;
         g.z = boundMaxZ;
         var h:Vertex = g.next;
         h.x = boundMaxX;
         h.y = boundMaxY;
         h.z = boundMaxZ;
         for(vertex = a; vertex != null; )
         {
            vertex.cameraX = transformation.ma * vertex.x + transformation.mb * vertex.y + transformation.mc * vertex.z + transformation.md;
            vertex.cameraY = transformation.me * vertex.x + transformation.mf * vertex.y + transformation.mg * vertex.z + transformation.mh;
            vertex.cameraZ = transformation.mi * vertex.x + transformation.mj * vertex.y + transformation.mk * vertex.z + transformation.ml;
            if(vertex.cameraZ <= 0)
            {
               return;
            }
            vertex = vertex.next;
         }
         var viewSizeX:Number = camera.viewSizeX;
         var viewSizeY:Number = camera.viewSizeY;
         for(vertex = a; vertex != null; vertex = vertex.next)
         {
            t = 1 / vertex.cameraZ;
            vertex.cameraX = vertex.cameraX * viewSizeX * t;
            vertex.cameraY = vertex.cameraY * viewSizeY * t;
         }
         canvas.gfx.lineStyle(0, color < 0?transformation.culling > 0?uint(16776960):uint(65280):uint(color),alpha);
         canvas.gfx.moveTo(a.cameraX,a.cameraY);
         canvas.gfx.lineTo(b.cameraX,b.cameraY);
         canvas.gfx.lineTo(d.cameraX,d.cameraY);
         canvas.gfx.lineTo(c.cameraX,c.cameraY);
         canvas.gfx.lineTo(a.cameraX,a.cameraY);
         canvas.gfx.moveTo(e.cameraX,e.cameraY);
         canvas.gfx.lineTo(f.cameraX,f.cameraY);
         canvas.gfx.lineTo(h.cameraX,h.cameraY);
         canvas.gfx.lineTo(g.cameraX,g.cameraY);
         canvas.gfx.lineTo(e.cameraX,e.cameraY);
         canvas.gfx.moveTo(a.cameraX,a.cameraY);
         canvas.gfx.lineTo(e.cameraX,e.cameraY);
         canvas.gfx.moveTo(b.cameraX,b.cameraY);
         canvas.gfx.lineTo(f.cameraX,f.cameraY);
         canvas.gfx.moveTo(d.cameraX,d.cameraY);
         canvas.gfx.lineTo(h.cameraX,h.cameraY);
         canvas.gfx.moveTo(c.cameraX,c.cameraY);
         canvas.gfx.lineTo(g.cameraX,g.cameraY);
      }
      
      alternativa3d static function drawKDNode(camera:Camera3D, transformation:Object3D, axis:int, coord:Number, boundMinX:Number, boundMinY:Number, boundMinZ:Number, boundMaxX:Number, boundMaxY:Number, boundMaxZ:Number, alpha:Number) : void
      {
         var vertex:Vertex = null;
         var t:Number = NaN;
         var a:Vertex = nodeVertexList;
         var b:Vertex = a.next;
         var c:Vertex = b.next;
         var d:Vertex = c.next;
         if(axis == 0)
         {
            a.x = coord;
            a.y = boundMinY;
            a.z = boundMaxZ;
            b.x = coord;
            b.y = boundMaxY;
            b.z = boundMaxZ;
            c.x = coord;
            c.y = boundMaxY;
            c.z = boundMinZ;
            d.x = coord;
            d.y = boundMinY;
            d.z = boundMinZ;
         }
         else if(axis == 1)
         {
            a.x = boundMaxX;
            a.y = coord;
            a.z = boundMaxZ;
            b.x = boundMinX;
            b.y = coord;
            b.z = boundMaxZ;
            c.x = boundMinX;
            c.y = coord;
            c.z = boundMinZ;
            d.x = boundMaxX;
            d.y = coord;
            d.z = boundMinZ;
         }
         else
         {
            a.x = boundMinX;
            a.y = boundMinY;
            a.z = coord;
            b.x = boundMaxX;
            b.y = boundMinY;
            b.z = coord;
            c.x = boundMaxX;
            c.y = boundMaxY;
            c.z = coord;
            d.x = boundMinX;
            d.y = boundMaxY;
            d.z = coord;
         }
         for(vertex = a; vertex != null; )
         {
            vertex.cameraX = transformation.ma * vertex.x + transformation.mb * vertex.y + transformation.mc * vertex.z + transformation.md;
            vertex.cameraY = transformation.me * vertex.x + transformation.mf * vertex.y + transformation.mg * vertex.z + transformation.mh;
            vertex.cameraZ = transformation.mi * vertex.x + transformation.mj * vertex.y + transformation.mk * vertex.z + transformation.ml;
            if(vertex.cameraZ <= 0)
            {
               return;
            }
            vertex = vertex.next;
         }
         var viewSizeX:Number = camera.viewSizeX;
         var viewSizeY:Number = camera.viewSizeY;
         for(vertex = a; vertex != null; vertex = vertex.next)
         {
            t = 1 / vertex.cameraZ;
            vertex.cameraX = vertex.cameraX * viewSizeX * t;
            vertex.cameraY = vertex.cameraY * viewSizeY * t;
         }
         canvas.gfx.lineStyle(0,axis == 0?uint(16711680):axis == 1?uint(65280):uint(255),alpha);
         canvas.gfx.moveTo(a.cameraX,a.cameraY);
         canvas.gfx.lineTo(b.cameraX,b.cameraY);
         canvas.gfx.lineTo(c.cameraX,c.cameraY);
         canvas.gfx.lineTo(d.cameraX,d.cameraY);
         canvas.gfx.lineTo(a.cameraX,a.cameraY);
      }
      
      alternativa3d static function drawBone(x1:Number, y1:Number, x2:Number, y2:Number, size:Number, color:int) : void
      {
         var lx:Number = NaN;
         var ly:Number = NaN;
         var rx:Number = NaN;
         var ry:Number = NaN;
         var nx:Number = x2 - x1;
         var ny:Number = y2 - y1;
         var nl:Number = Math.sqrt(nx * nx + ny * ny);
         if(nl > 0.001)
         {
            nx = nx / nl;
            ny = ny / nl;
            lx = ny * size;
            ly = -nx * size;
            rx = -ny * size;
            ry = nx * size;
            if(nl > size * 2)
            {
               nl = size;
            }
            else
            {
               nl = nl / 2;
            }
            canvas.gfx.lineStyle(1,color);
            canvas.gfx.beginFill(color,0.6);
            canvas.gfx.moveTo(x1,y1);
            canvas.gfx.lineTo(x1 + nx * nl + lx,y1 + ny * nl + ly);
            canvas.gfx.lineTo(x2,y2);
            canvas.gfx.lineTo(x1 + nx * nl + rx,y1 + ny * nl + ry);
            canvas.gfx.lineTo(x1,y1);
         }
      }
   }
}
