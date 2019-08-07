package utils.client.models.core.users.model.entrance
{
   public class RestorePasswordStatusEnum
   {
      
      public static var OK:RestorePasswordStatusEnum = new RestorePasswordStatusEnum();
      
      public static var MAIL_NOT_FOUND:RestorePasswordStatusEnum = new RestorePasswordStatusEnum();
      
      public static var MAIL_NOT_SEND:RestorePasswordStatusEnum = new RestorePasswordStatusEnum();
       
      
      public function RestorePasswordStatusEnum()
      {
         super();
      }
   }
}
