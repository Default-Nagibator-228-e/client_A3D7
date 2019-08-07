package utils.client.models.core.users.model.entrance
{
   public class ConfirmEmailStatus
   {
      
      public static var ERROR:ConfirmEmailStatus = new ConfirmEmailStatus();
      
      public static var OK:ConfirmEmailStatus = new ConfirmEmailStatus();
      
      public static var OK_EXISTS:ConfirmEmailStatus = new ConfirmEmailStatus();
       
      
      public function ConfirmEmailStatus()
      {
         super();
      }
   }
}
