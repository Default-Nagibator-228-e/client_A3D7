package alternativa.tanks.models.battlefield.logic
{
   import flash.utils.Dictionary;
   
   public class BattleLogicUnits
   {
       
      
      private var units:Dictionary;
      
      public function BattleLogicUnits()
      {
         this.units = new Dictionary();
         super();
      }
      
      public function addLogicUnit(unit:LogicUnit) : void
      {
         this.units[unit] = true;
      }
      
      public function removeLogicUnit(unit:LogicUnit) : void
      {
         this.units[unit] = false;
         delete this.units[unit];
      }
      
      public function update(deltaMsec:int, deltaSec:int) : void
      {
         var unit:* = undefined;
         var logicUnit:LogicUnit = null;
         for(unit in this.units)
         {
            logicUnit = unit as LogicUnit;
            logicUnit.runLogic(deltaMsec,deltaSec);
         }
      }
   }
}
