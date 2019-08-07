package alternativa.tanks.models.battlefield.gui.statistics.field
{
   public class CTFScoreIndicatorBlinker
   {
       
      
      public var values:Vector.<Number>;
      
      private var maxValue:Number;
      
      private var minValue:Number;
      
      private var intervals:Vector.<int>;
      
      private var speedCoeffs:Vector.<Number>;
      
      private var numValues:int;
      
      private var speeds:Vector.<Number>;
      
      private var switchTimes:Vector.<int>;
      
      private var valueDelta:Number;
      
      private var runCount:int = 0;
      
      public function CTFScoreIndicatorBlinker(minValue:Number, maxValue:Number, intervals:Vector.<int>, speedCoeffs:Vector.<Number>)
      {
         super();
         this.minValue = minValue;
         this.maxValue = maxValue;
         this.intervals = intervals;
         this.speedCoeffs = speedCoeffs;
         this.valueDelta = maxValue - minValue;
         this.numValues = intervals.length;
         this.speeds = new Vector.<Number>(this.numValues);
         this.switchTimes = new Vector.<int>(this.numValues);
         this.values = new Vector.<Number>(this.numValues);
      }
      
      public function start(now:int) : void
      {
         if(this.runCount == 0)
         {
            this.init(now);
         }
         this.runCount++;
      }
      
      public function stop() : void
      {
         this.runCount--;
      }
      
      public function update(now:int, delta:int) : void
      {
         if(this.runCount <= 0)
         {
            return;
         }
         for(var i:int = 0; i < this.numValues; i++)
         {
            this.values[i] = this.values[i] + this.speeds[i] * delta;
            if(this.values[i] > this.maxValue)
            {
               this.values[i] = this.maxValue;
            }
            if(this.values[i] < this.minValue)
            {
               this.values[i] = this.minValue;
            }
            if(now >= this.switchTimes[i])
            {
               this.switchTimes[i] = this.switchTimes[i] + this.intervals[i];
               if(this.speeds[i] < 0)
               {
                  this.speeds[i] = this.getSpeed(1,this.speedCoeffs[i],this.intervals[i]);
               }
               else
               {
                  this.speeds[i] = this.getSpeed(-1,this.speedCoeffs[i],this.intervals[i]);
               }
            }
         }
      }
      
      private function init(now:int) : void
      {
         for(var i:int = 0; i < this.numValues; i++)
         {
            this.speeds[i] = this.getSpeed(-1,this.speedCoeffs[i],this.intervals[i]);
            this.values[i] = this.maxValue;
            this.switchTimes[i] = now + this.intervals[i];
         }
      }
      
      private function getSpeed(direction:Number, speedCoeff:Number, interval:int) : Number
      {
         return direction * speedCoeff * this.valueDelta / interval;
      }
   }
}
