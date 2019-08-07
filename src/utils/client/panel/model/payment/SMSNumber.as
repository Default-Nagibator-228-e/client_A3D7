package utils.client.panel.model.payment {
	import alternativa.protocol.type.Float;

public class SMSNumber {

    private var _number:String;
    private var _currency:String;
    private var _cost:Number;
    private var _crystal:int;
    private var _smsText:String;

    public function SMSNumber(number:String, cost:Number, crystal:int, currency:String, smsText:String) {
	this._number = number;
	this._cost = cost;
	this._crystal = crystal;
	this._currency = currency;
	this._smsText = smsText;
    }

    public function get number():String {
	return _number;
    }

    public function set number(number:String):void {
	this._number = number;
    }

    public function get currency():String {
	return _currency;
    }

    public function set currency(currency:String):void {
	this._currency = currency;
    }

    public function get cost():Number {
	return _cost;
    }

    public function set cost(cost:Number):void {
	this._cost = cost;
    }

    public function get crystal():int {
	return _crystal;
    }

    public function set crystal(crystal:int):void {
	this._crystal = crystal;
    }

    public function get smsText():String {
	return _smsText;
    }

    public function set smsText(smsText:String):void {
	this._smsText = smsText;
	}
}
}