package alternativa.tanks.model.panel
{
	import controls.PlayerInfo;
   public interface IPanel
   {
       
      
      function lock() : void;
      
      function unlock() : void;
      
      function get userName() : String;
      
      function get userEmail() : String;
      
      function get rank() : int;
      
      function get crystal() : int;
      
      function partSelected(param1:int) : void;
	  
	  function closeFriend() : void;
      
      function goToGarage() : void;
      
      function goToPayment() : void;
      
      function setInviteSendResult(param1:Boolean, param2:String) : void;
      
      function sendBugReport(param1:String, param2:String) : void;
      
      function _showMessage(param1:String) : void;
      
      function setIdNumberCheckResult(param1:Boolean) : void;
   }
}
