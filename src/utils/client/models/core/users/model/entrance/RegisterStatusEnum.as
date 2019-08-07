package utils.client.models.core.users.model.entrance
{
   public class RegisterStatusEnum
   {
      
      public static var EMAIL_LDAP_UNIQUE:RegisterStatusEnum = new RegisterStatusEnum();
      
      public static var EMAIL_NOT_VALID:RegisterStatusEnum = new RegisterStatusEnum();
      
      public static var UID_LDAP_UNIQUE:RegisterStatusEnum = new RegisterStatusEnum();
       
      
      public function RegisterStatusEnum()
      {
         super();
      }
   }
}
