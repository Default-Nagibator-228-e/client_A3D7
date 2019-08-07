package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.materials.Material;
   import alternativa.math.Vector3;
   import alternativa.tanks.materials.TrackMaterial;
   import flash.display.Graphics;
   
   public class Track
   {
       
      
      public var tank:Tank;
      
      public var rays:Vector.<SuspensionRay>;
      
      public var raysNum:int;
      
      public var lastContactsNum:int;
      
      public function Track(tank:Tank, raysNum:int, relPos:Vector3, trackLength:Number)
      {
         super();
         this.tank = tank;
         this.setTrackParams(raysNum,relPos,trackLength);
      }
      
      public function set collisionGroup(value:int) : void
      {
         for(var i:int = 0; i < this.raysNum; SuspensionRay(this.rays[i]).collisionGroup = value,i++)
         {
         }
      }
      
      public function setTrackParams(raysNum:int, relPos:Vector3, trackLength:Number) : void
      {
         this.raysNum = raysNum;
         this.rays = new Vector.<SuspensionRay>(raysNum);
         var step:Number = trackLength / (raysNum - 1);
         for(var i:int = 0; i < raysNum; this.rays[i] = new SuspensionRay(this.tank,new Vector3(relPos.x,relPos.y + 0.5 * trackLength - i * step,relPos.z),new Vector3(0,0,-1)),i++)
         {
         }
      }
	  
	  public function updateControls():void {
		  for (var i:int = 0; i < raysNum; this.rays[i].updateCachedValues(i, raysNum), i++)
			 {
			 }
		}
      
      public function addForces(dt:Number, throttle:Number, maxSpeed:Number, slipTerm:int, weight:Number, data:SuspensionData, brake:Boolean) : void
      {
         var i:int = 0;
         this.lastContactsNum = 0;
         for(i = 0; i < this.raysNum; i++)
         {
            if(SuspensionRay(this.rays[i]).calculateIntersection(tank.tpd.rayRestLengthCoeff))
            {
               this.lastContactsNum++;
            }
         }
         if(this.lastContactsNum == 0)
         {
            return;
         }
         var springCoeff:Number = 0.5 * weight / (this.lastContactsNum * data.rayOptimalLength);
         throttle = throttle * (this.raysNum / this.lastContactsNum);
         var mid:int = this.raysNum >> 1;
         if(this.raysNum & 1 == 0)
         {
            for(i = 0; i < this.raysNum; i++)
            {
               SuspensionRay(this.rays[i]).addForce(dt,data,springCoeff,throttle);//(dt,data,springCoeff,throttle)
            }
         }
         else
         {
            for(i = 0; i < this.raysNum; i++)
            {
               SuspensionRay(this.rays[i]).addForce(dt,data,springCoeff,throttle);
            }
         }
      }
      
      public function debugDraw(g:Graphics, camera:Camera3D, data:SuspensionData) : void
      {
         var ray:SuspensionRay = null;
         for each(ray in this.rays)
         {
            ray.debugDraw(g,camera,data);
         }
      }
   }
}
