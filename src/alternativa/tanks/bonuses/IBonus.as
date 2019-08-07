package alternativa.tanks.bonuses
{
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsScene;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   
   public interface IBonus
   {
       
      
      function get bonusId() : String;
      
      function attach(param1:Vector3, param2:PhysicsScene, param3:Scene3DContainer, param4:IBonusListener) : void;
	  
	  function attach1(param1:Vector3, param2:PhysicsScene, param3:Scene3DContainer, param4:IBonusListener) : void;
      
      function update(param1:int, param2:int, param3:Number) : Boolean;
      
      function isFalling() : Boolean;
      
      function setRestingState(param1:Number, param2:Number, param3:Number) : void;
      
      function setTakenState() : void;
      
      function setRemovedState() : void;
      
      function destroy() : void;
      
      function readBonusPosition(param1:Vector3) : void;
   }
}
