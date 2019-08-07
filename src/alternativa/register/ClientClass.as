package alternativa.register
{
   import flash.utils.Dictionary;
   
   public class ClientClass
   {
       
      
      private var _name:String;
      
      private var _id:String;
      
      private var _parent:ClientClass;
      
      private var _children:Vector.<ClientClass>;
      
      private var _models:Vector.<String>;
      
      private var _modelsParams:Dictionary;
      
      public function ClientClass(id:String, parent:ClientClass, name:String, models:Vector.<String> = null)
      {
         super();
         this._id = id;
         this._parent = parent;
         this._name = name;
         this._children = new Vector.<ClientClass>();
         this._modelsParams = new Dictionary();
         if(models != null)
         {
            this._models = models;
         }
         else
         {
            this._models = new Vector.<String>();
         }
      }
      
      public function addChild(child:ClientClass) : void
      {
         this._children.push(child);
      }
      
      public function removeChild(child:ClientClass) : void
      {
         this._children.splice(this._children.indexOf(child),1);
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get parent() : ClientClass
      {
         return this._parent;
      }
      
      public function get children() : Vector.<ClientClass>
      {
         return this._children;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get models() : Vector.<String>
      {
         return this._models;
      }
      
      public function get modelsParams() : Dictionary
      {
         return this._modelsParams;
      }
      
      public function setModelParams(modelId:String, params:Object) : void
      {
         this._modelsParams[modelId] = params;
      }
      
      public function toString() : String
      {
         var i:int = 0;
         var key:* = undefined;
         var s:String = "\nClientClass";
         s = s + ("\n   id: " + this._id);
         s = s + ("\n   name: " + this._name);
         if(this._parent != null)
         {
            s = s + ("\n   parent id: " + this._parent.id);
         }
         if(this._children.length > 0)
         {
            s = s + "\n   children id:";
            for(i = 0; i < this._children.length; i++)
            {
               s = s + (" " + ClientClass(this._children[i]).id);
            }
         }
         if(this._models.length > 0)
         {
            s = s + ("\n   models: " + this._models);
            s = s + "\n   modelParams: \n";
            for(key in this._modelsParams)
            {
               s = s + ("\n   " + key.toString() + ": " + this._modelsParams[key]);
            }
         }
         s = s + "\n";
         return s;
      }
   }
}
