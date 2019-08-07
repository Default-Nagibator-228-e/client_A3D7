package utils
{
   public class Task
   {
       
      
      private var _taskSequence:TaskSequence;
      
      public function Task()
      {
         super();
      }
      
      public function run() : void
      {
         throw new Error("Not implemented");
      }
      
      public function set taskSequence(value:TaskSequence) : void
      {
         this._taskSequence = value;
      }
      
      protected final function completeTask() : void
      {
         this._taskSequence.taskComplete(this);
      }
   }
}
