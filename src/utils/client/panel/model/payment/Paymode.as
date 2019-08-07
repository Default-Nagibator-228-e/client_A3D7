package utils.client.panel.model.payment {
	import alternativa.protocol.type.Float;

public class Paymode {
	public static var WMB:Paym = new Paym("BYR", 1, false);
	public static var WME:Paym = new Paym("EUR", 1, false);
	public static var WMR:Paym = new Paym("RUR", 1, false);
	public static var WMU:Paym = new Paym("UAH", 1, false);
	public static var WMZ:Paym = new Paym("USD", 1, false); // WebMoney
	public static var YANDEX:Paym = new Paym(null,5, true); // Яндекс.Деньги
	public static var BANK_CARD:Paym = new Paym(null,5, true); // банковские карты
	public static var RBK:Paym = new Paym(null,2, true); // RBK Money
	public static var MK:Paym = new Paym(null,5, true); // Личный кабинет QIWI
	public static var MONEYMAIL:Paym = new Paym(null,2, true); // MoneyMail
	public static var WEBCREDS:Paym = new Paym(null,2, true); // WebCreds
	public static var EASYPAY:Paym = new Paym("BYR", 10, false); // EasyPay
	public static var PAYPAL:Paym = new Paym("USD", 0, false);
    public static var LIQPAY:Paym = new Paym("USD", 0, false);
    public static var WALLIE:Paym = new Paym("USD", 22, false);
    public static var CASHU:Paym = new Paym("USD", 7, false);
    public static var RIXTY:Paym = new Paym("USD", 25, false);
    public static var PAYSAFE:Paym = new Paym("USD", 20, false);
    public static var ALIPAY:Paym = new Paym("CNY", 0, false);
    public static var MEGAFON:Paym = new Paym("RUR", 14, false);
    public static var BEELINE:Paym = new Paym("RUR", 20, false);

	private var currency:String;
	private var feePercent:Number;
	private var currencyDependsOnLocale:Boolean;

	public function Paymode(feePercent:Number, currencyDependsOnLocale:Boolean) {
		this.currency = "RUR";
		this.feePercent = feePercent / 101;
		this.currencyDependsOnLocale = currencyDependsOnLocale;
	}

	public function getCurrency(): String{
		return currency;
	}

	public function getFeePercent(): Number{
		return feePercent;
	}
	
	public function isCurrencyDependsOnLocale(): Boolean{
		return currencyDependsOnLocale;
	}
	
	public function toString(): String{
		return "Paymode [currency: " + currency + ", feePercent: " + feePercent + "]";
	}
}
}
