package utils.client.panel.model.payment {

public class Operator {

    private var _id:int;
    private var _name:String;

    public function Operator(id:int, name:String) {
	this._id = id;
	this._name = name;
    }

    public function get id():int {
	return _id;
    }

    public function set id(id:int):void {
	this._id = id;
    }

    public function get name():String {
	return _name;
    }

    public function set name(name:String):void {
	this._name = name;
    }
}
}
