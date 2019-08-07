package forms.upgrade {
import alternativa.init.Main;
import utils.client.models.IModel;
import alternativa.osgi.service.locale.ILocaleService;
import alternativa.osgi.service.mainContainer.IMainContainerService;
import alternativa.osgi.service.storage.IStorageService;
import alternativa.service.IModelService;
import alternativa.tanks.help.MD5;
import alternativa.tanks.locale.constants.TextConst;
import alternativa.tanks.model.panel.IPanel;
import alternativa.tanks.model.payment.IPayment;

import assets.scroller.color.ScrollThumbSkinGreen;
import assets.scroller.color.ScrollTrackGreen;

import controls.DefaultButton;
import controls.Label;
import controls.PaymentButton;
import controls.TankCombo;
import controls.TankWindow;
import controls.TankWindowHeader;
import controls.TankWindowInner;

import fl.containers.ScrollPane;
import fl.controls.ScrollPolicy;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;

import flash.utils.getTimer;

import utils.client.panel.model.payment.Country;
import utils.client.panel.model.payment.Operator;
import utils.client.panel.model.payment.Paymode;
import utils.client.panel.model.payment.SMSNumber;

public class PaymentWindow extends Sprite {

    [Embed(source="../resources/crystals_pic.png")]
    private static const bitmapCrystalsPic:Class;
    private static const crystalsBd:BitmapData = new bitmapCrystalsPic().bitmapData;

    [Embed(source="../resources/icon_error.png")]
    private static const bitmapError:Class;
    private static const errorBd:BitmapData = new bitmapError().bitmapData;

    private var localeService:ILocaleService;
    private var storage:SharedObject;
    private var panelModel:IPanel;
    private var dialogsLayer:DisplayObjectContainer;

    private var window:TankWindow;
    private var windowSize:Point;
    private const windowMargin:int = 11;
    private const spaceModule:int = 7;

    private const buttonSize:Point = new Point(155, 50);

    private var numbers:Array;

    private var systemTypesNum:int;
    private var systemTypeButtonsSmall:Array;
    private var systemTypeButtons:Array;
    private var systemTypeButtonNames:Array;
    private var systemTypeButtonsInner:TankWindowInner;
    private var systemTypeButtonsSpace:int = 2;

    private var bigButtonsContainer:Sprite;
    private var smallButtonsContainer:Sprite;

    private var systemTypeTitle:Label;
    private var systemTypeDescriptions:Array;
    private var systemTypeDescription:Label;
    private var systemTypeDescriptionInner:TankWindowInner;
    private var systemTypeDescriptionInnerWidth:int = 200;

    private var errorInner:TankWindowInner;
    private var errorButton:DefaultButton;
    private var errorIcon:Bitmap;
    private var errorLabel:Label;

    private var colomn2x:int;
    private var colomn3x:int;

    private var tabContainers:Array;
    private var currentTabIndex:int = 0;

    private var exchangeGroup:ExchangeGroup;
    private var rates:Array;
    private var crystals:int;
    private var WMCombo:TankCombo;
    private var proceedButton:DefaultButton;

    private var crystalsPic:Bitmap;
    private var header:Label;
    private var headerInner:TankWindowInner;

    private var scrollPane:ScrollPane;
    private var scrollContainer:Sprite;

    private var smsBlock:SMSblock;
    public var terminalCountriesCombo:TankCombo;

    private var wallieButton:PaymentButton;
    private var paysafeButton:PaymentButton;
    private var rixtyButton:PaymentButton;
    private var cashuButton:PaymentButton;

    private var chronopayButton:PaymentButton;
    private var liqpayButton:PaymentButton;
    private var chronopaySelected:Boolean;
    private var prepayCardSelectedIndex:int;

    private var mobilePaymentSelectedIndex:int;
    private var megafonButton:PaymentButton;
    private var beelineButton:PaymentButton;


    private var INDEX_SMS:int;
    private var INDEX_QIWI:int;
    private var INDEX_YANDEX:int;
    private var INDEX_VISA:int;
    private var INDEX_WEBMONEY:int;
    private var INDEX_EASYPAY:int;
    //		private var INDEX_RBK:int;
    //		private var INDEX_MONEYMAIL:int;
    private var INDEX_WEBCREDS:int;
    private var INDEX_PAYPAL:int;
    private var INDEX_TERMINAL:int;
    private var INDEX_PREPAID:int;
    private var INDEX_WALLIE:int;
    private var INDEX_PAYSAFE:int;
    private var INDEX_RIXTY:int;
    private var INDEX_CASHU:int;
    private var INDEX_ALIPAY:int;
    private var INDEX_MOBILE_PAYMENT:int;
    private var INDEX_MEGAFON:int;
    private var INDEX_BEELINE:int;


    public static const SYSTEM_TYPE_SMS:String = "sms";
    public static const SYSTEM_TYPE_QIWI:String = "mk";
    public static const SYSTEM_TYPE_YANDEX:String = "yandex";
    public static const SYSTEM_TYPE_VISA:String = "bank_card";
    public static const SYSTEM_TYPE_WEBMONEY:String = "wm";
    public static const SYSTEM_TYPE_EASYPAY:String = "easypay";
    //		public static const SYSTEM_TYPE_RBK:String = "rbk";
    //		public static const SYSTEM_TYPE_MONEYMAIL:String = "moneymail";
    //		public static const SYSTEM_TYPE_WEBCREDS:String = "webcreds";
    public static const SYSTEM_TYPE_PAYPAL:String = "paypal";
    public static const SYSTEM_TYPE_TERMINAL:String = "terminal";

    public static var SYSTEM_TYPE_PREPAID:String = "prepaid";
    public static const SYSTEM_TYPE_WALLIE:String = "wallie";
    public static const SYSTEM_TYPE_PAYSAFE:String = "paysafecard";
    public static const SYSTEM_TYPE_RIXTY:String = "rixty";
    public static const SYSTEM_TYPE_CASHU:String = "cashu";

    public static const SYSTEM_TYPE_CHRONOPAY:String = "chronopay";
    public static const SYSTEM_TYPE_LIQPAY:String = "liqpay";
    public static const SYSTEM_TYPE_ALIPAY:String = "alipay";

    public static const SYSTEM_TYPE_MOBILE_PAYMENT:String = "mobilepayment";
    public static const SYSTEM_TYPE_MEGAFON:String = "megafon";
    public static const SYSTEM_TYPE_BEELINE:String = "beeline";


    private var buttonTypes:Array;

    private var bugReportWindow:PaymentBugReportWindow;


    public function PaymentWindow() {
        var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
        panelModel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
        dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;

        localeService = ILocaleService(Main.osgi.getService(ILocaleService));
        storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();

        this.crystals = crystals;

        windowSize = new Point();

        window = new TankWindow();
        addChild(window);
        window.headerLang = localeService.getText(TextConst.GUI_LANG);
        window.header = TankWindowHeader.ACCOUNT;
        SYSTEM_TYPE_PREPAID += localeService.getText(TextConst.GUI_LANG);

        headerInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
        addChild(headerInner);
        headerInner.x = windowMargin;
        headerInner.y = windowMargin;

        crystalsPic = new Bitmap(crystalsBd);
        addChild(crystalsPic);
        crystalsPic.x = windowMargin * 2;

        header = new Label();
        addChild(header);
        header.multiline = true;
        header.wordWrap = true;
        header.x = crystalsPic.x + crystalsPic.width + windowMargin;
        header.text = localeService.getText(TextConst.PAYMENT_MAININFO_LABEL_TEXT);

        systemTypeButtonsInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
        addChild(systemTypeButtonsInner);

        // TODO: подключить кнопку багрепорта для китайцев
        if (localeService.language != "cn") {
            // ERROR
            errorInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
            addChild(errorInner);

            errorIcon = new Bitmap(errorBd);
            addChild(errorIcon);

            errorLabel = new Label();
            addChild(errorLabel);
            errorLabel.multiline = true;
            errorLabel.wordWrap = true;
            errorLabel.text = localeService.getText(TextConst.PAYMENT_BUG_REPORT_INFO);

            errorButton = new DefaultButton();
            errorButton.label = localeService.getText(TextConst.PAYMENT_BUTTON_SEND_BUG_REPORT_TEXT);
            addChild(errorButton);
            errorButton.addEventListener(MouseEvent.CLICK, onErrorButtonClick);
        }

        systemTypeButtonNames = new Array();
        systemTypeDescriptions = new Array();

        if (localeService.language == "ru") {
            buttonTypes = [SYSTEM_TYPE_SMS,
                SYSTEM_TYPE_MOBILE_PAYMENT,
                SYSTEM_TYPE_TERMINAL,
                SYSTEM_TYPE_PREPAID,
                SYSTEM_TYPE_QIWI,
                SYSTEM_TYPE_VISA,
                SYSTEM_TYPE_YANDEX,
                //							   SYSTEM_TYPE_RBK,
                SYSTEM_TYPE_WEBMONEY,

                //                SYSTEM_TYPE_PAYPAL,
                SYSTEM_TYPE_EASYPAY
                ];
            //SYSTEM_TYPE_WEBCREDS,
            //							   SYSTEM_TYPE_MONEYMAIL];
        } else if (localeService.language == "en") {
            buttonTypes = [SYSTEM_TYPE_VISA,
                SYSTEM_TYPE_PREPAID,
                //                SYSTEM_TYPE_PAYPAL,
                SYSTEM_TYPE_SMS,
                SYSTEM_TYPE_WEBMONEY];
        } else {
            buttonTypes = [SYSTEM_TYPE_ALIPAY];
        }
        INDEX_SMS = buttonTypes.indexOf(SYSTEM_TYPE_SMS);
        INDEX_TERMINAL = buttonTypes.indexOf(SYSTEM_TYPE_TERMINAL);
        INDEX_QIWI = buttonTypes.indexOf(SYSTEM_TYPE_QIWI);
        INDEX_VISA = buttonTypes.indexOf(SYSTEM_TYPE_VISA);
        INDEX_YANDEX = buttonTypes.indexOf(SYSTEM_TYPE_YANDEX);
        //			INDEX_RBK = buttonTypes.indexOf(SYSTEM_TYPE_RBK);
        INDEX_WEBMONEY = buttonTypes.indexOf(SYSTEM_TYPE_WEBMONEY);
        INDEX_PAYPAL = buttonTypes.indexOf(SYSTEM_TYPE_PAYPAL);
        INDEX_EASYPAY = buttonTypes.indexOf(SYSTEM_TYPE_EASYPAY);
        //INDEX_WEBCREDS = buttonTypes.indexOf(SYSTEM_TYPE_WEBCREDS);
        //			INDEX_MONEYMAIL = buttonTypes.indexOf(SYSTEM_TYPE_MONEYMAIL);
        INDEX_PREPAID = buttonTypes.indexOf(SYSTEM_TYPE_PREPAID);
        INDEX_WALLIE = buttonTypes.indexOf(SYSTEM_TYPE_WALLIE);
        INDEX_PAYSAFE = buttonTypes.indexOf(SYSTEM_TYPE_PAYSAFE);
        INDEX_RIXTY = buttonTypes.indexOf(SYSTEM_TYPE_RIXTY);
        INDEX_CASHU = buttonTypes.indexOf(SYSTEM_TYPE_CASHU);
        INDEX_ALIPAY = buttonTypes.indexOf(SYSTEM_TYPE_ALIPAY);

        INDEX_MOBILE_PAYMENT = buttonTypes.indexOf(SYSTEM_TYPE_MOBILE_PAYMENT);
        INDEX_MEGAFON = buttonTypes.indexOf(SYSTEM_TYPE_MEGAFON);
        INDEX_BEELINE = buttonTypes.indexOf(SYSTEM_TYPE_BEELINE);


        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_SMS: %1", INDEX_SMS);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_TERMINAL: %1", INDEX_TERMINAL);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_PREPAID: %1", INDEX_PREPAID);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_WALLIE: %1", INDEX_WALLIE);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_PAYSAFE: %1", INDEX_PAYSAFE);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_RIXTY: %1", INDEX_RIXTY);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_CASHU: %1", INDEX_CASHU);

        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_QIWI: %1", INDEX_QIWI);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_VISA: %1", INDEX_VISA);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_YANDEX: %1", INDEX_YANDEX);
        //            Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_RBK: %1", INDEX_RBK);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_WEBMONEY: %1", INDEX_WEBMONEY);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_PAYPAL: %1", INDEX_PAYPAL);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_EASYPAY: %1", INDEX_EASYPAY);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_WEBCREDS: %1", INDEX_WEBCREDS);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_ALIPAY: %1", INDEX_ALIPAY);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_MOBILE_PAYMENT: %1", INDEX_MOBILE_PAYMENT);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_MEGAFON: %1", INDEX_MEGAFON);
        Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_BEELINE: %1", INDEX_BEELINE);
        //            Main.writeVarsToConsoleChannel("PAYMENT", "INDEX_MONEYMAIL: %1", INDEX_MONEYMAIL);


        if (INDEX_SMS != -1) {
            systemTypeButtonNames[INDEX_SMS] = localeService.getText(TextConst.PAYMENT_SMS_NAME_TEXT);
            systemTypeDescriptions[INDEX_SMS] = localeService.getText(TextConst.PAYMENT_SMS_DESCRIPTION_TEXT);
        }
        if (INDEX_QIWI != -1) {
            systemTypeButtonNames[INDEX_QIWI] = localeService.getText(TextConst.PAYMENT_QIWI_NAME_TEXT);
            systemTypeDescriptions[INDEX_QIWI] = localeService.getText(TextConst.PAYMENT_QIWI_DESCRIPTION_TEXT);
        }
        if (INDEX_YANDEX != -1) {
            systemTypeButtonNames[INDEX_YANDEX] = localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_NAME_TEXT);
            systemTypeDescriptions[INDEX_YANDEX] = localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_DESCRIPTION_TEXT);
        }
        if (INDEX_VISA != -1) {
            systemTypeButtonNames[INDEX_VISA] = localeService.getText(TextConst.PAYMENT_VISA_NAME_TEXT);
            systemTypeDescriptions[INDEX_VISA] = localeService.getText(TextConst.PAYMENT_VISA_DESCRIPTION_TEXT);
        }
        if (INDEX_WEBMONEY != -1) {
            systemTypeButtonNames[INDEX_WEBMONEY] = localeService.getText(TextConst.PAYMENT_WEBMONEY_NAME_TEXT);
            systemTypeDescriptions[INDEX_WEBMONEY] = localeService.getText(TextConst.PAYMENT_WEBMONEY_DESCRIPTION_TEXT);
        }
        if (INDEX_EASYPAY != -1) {
            systemTypeButtonNames[INDEX_EASYPAY] = localeService.getText(TextConst.PAYMENT_EASYPAY_NAME_TEXT);
            systemTypeDescriptions[INDEX_EASYPAY] = localeService.getText(TextConst.PAYMENT_EASYPAY_DESCRIPTION_TEXT);
        }
        //			if (INDEX_RBK != -1) {
        //				systemTypeButtonNames[INDEX_RBK] = localeService.getText(TextConst.PAYMENT_RBK_NAME_TEXT);
        //				systemTypeDescriptions[INDEX_RBK] = localeService.getText(TextConst.PAYMENT_RBK_DESCRIPTION_TEXT);
        //			}
        //			if (INDEX_MONEYMAIL != -1) {
        //				systemTypeButtonNames[INDEX_MONEYMAIL] = localeService.getText(TextConst.PAYMENT_MONEYMAIL_NAME_TEXT);
        //				systemTypeDescriptions[INDEX_MONEYMAIL] = localeService.getText(TextConst.PAYMENT_MONEYMAIL_DESCRIPTION_TEXT);
        //			}
        //			if (INDEX_WEBCREDS != -1) {
        //				systemTypeButtonNames[INDEX_WEBCREDS] = localeService.getText(TextConst.PAYMENT_WEBCREDS_NAME_TEXT);
        //				systemTypeDescriptions[INDEX_WEBCREDS] = localeService.getText(TextConst.PAYMENT_WEBCREDS_DESCRIPTION_TEXT);
        //			}
        if (INDEX_PAYPAL != -1) {
            systemTypeButtonNames[INDEX_PAYPAL] = localeService.getText(TextConst.PAYMENT_PAYPAL_NAME_TEXT);
            systemTypeDescriptions[INDEX_PAYPAL] = localeService.getText(TextConst.PAYMENT_PAYPAL_DESCRIPTION_TEXT);
        }
        if (INDEX_TERMINAL != -1) {
            systemTypeButtonNames[INDEX_TERMINAL] = localeService.getText(TextConst.PAYMENT_TERMINAL_NAME_TEXT);
            systemTypeDescriptions[INDEX_TERMINAL] = localeService.getText(TextConst.PAYMENT_TERMINAL_DESCRIPTION_TEXT);
        }
        // TODO: заменить тексты для предоплаченых карт
        if (INDEX_PREPAID != -1) {
            systemTypeButtonNames[INDEX_PREPAID] = localeService.getText(TextConst.PAYMENT_PREPAID_NAME_TEXT);
            systemTypeDescriptions[INDEX_PREPAID] = localeService.getText(TextConst.PAYMENT_PREPAID_DESCRIPTION_TEXT);
        }

        if (INDEX_MOBILE_PAYMENT != -1) {
            systemTypeButtonNames[INDEX_MOBILE_PAYMENT] = "Мобильный платёж";
            systemTypeDescriptions[INDEX_MOBILE_PAYMENT] = "Мобильный платёж - это способ покупки кристаллов с помощью вашего сотового телефона, который дешевле и удобнее SMS-платежей. Выберите оператора, укажите желаемое количество кристаллов и нажмите кнопку «Далее». На открывшейся странице введите номер своего сотового телефона и следуйте опубликованной там же инструкции.";
        }

        if (INDEX_MEGAFON != -1) {
            systemTypeButtonNames[INDEX_MEGAFON] = "Мегафон";
            systemTypeDescriptions[INDEX_MEGAFON] = "Мобильный платёж - это способ покупки кристаллов с помощью вашего сотового телефона, который дешевле и удобнее SMS-платежей. Выберите оператора, укажите желаемое количество кристаллов и нажмите кнопку «Далее». На открывшейся странице введите номер своего сотового телефона и следуйте опубликованной там же инструкции. ";
        }
        if (INDEX_BEELINE != -1) {
            systemTypeButtonNames[INDEX_BEELINE] = "Билайн";
            systemTypeDescriptions[INDEX_BEELINE] = "Мобильный платёж - это способ покупки кристаллов с помощью вашего сотового телефона, который дешевле и удобнее SMS-платежей. Выберите оператора, укажите желаемое количество кристаллов и нажмите кнопку «Далее». На открывшейся странице введите номер своего сотового телефона и следуйте опубликованной там же инструкции. ";
        }

        if (INDEX_WALLIE != -1) {
            systemTypeButtonNames[INDEX_WALLIE] = localeService.getText(TextConst.PAYMENT_RIXTY_NAME_TEXT);
            systemTypeDescriptions[INDEX_WALLIE] = localeService.getText(TextConst.PAYMENT_PREPAID_DESCRIPTION_TEXT);
        }

        if (INDEX_PAYSAFE != -1) {
            systemTypeButtonNames[INDEX_PAYSAFE] = localeService.getText(TextConst.PAYMENT_RIXTY_NAME_TEXT);
            systemTypeDescriptions[INDEX_PAYSAFE] = localeService.getText(TextConst.PAYMENT_PREPAID_DESCRIPTION_TEXT);
        }

        if (INDEX_RIXTY != -1) {
            systemTypeButtonNames[INDEX_RIXTY] = localeService.getText(TextConst.PAYMENT_RIXTY_NAME_TEXT);
            systemTypeDescriptions[INDEX_RIXTY] = localeService.getText(TextConst.PAYMENT_PREPAID_DESCRIPTION_TEXT);
        }

        if (INDEX_CASHU != -1) {
            systemTypeButtonNames[INDEX_CASHU] = localeService.getText(TextConst.PAYMENT_RIXTY_NAME_TEXT);
            systemTypeDescriptions[INDEX_CASHU] = localeService.getText(TextConst.PAYMENT_PREPAID_DESCRIPTION_TEXT);
        }

        if (INDEX_ALIPAY != -1) {
            systemTypeButtonNames[INDEX_ALIPAY] = localeService.getText(TextConst.PAYMENT_ALIPAY_NAME_TEXT);
            systemTypeDescriptions[INDEX_ALIPAY] = localeService.getText(TextConst.PAYMENT_ALIPAY_DESCRIPTION_TEXT);
        }

        systemTypesNum = systemTypeButtonNames.length;

        systemTypeButtons = new Array();
        tabContainers = new Array();

        systemTypeButtonsSmall = new Array();
        smallButtonsContainer = new Sprite();
        addChild(smallButtonsContainer);
        smallButtonsContainer.x = windowMargin + spaceModule + 1;
        bigButtonsContainer = new Sprite();
        addChild(bigButtonsContainer);
        bigButtonsContainer.x = windowMargin + spaceModule + 1;
        bigButtonsContainer.visible = false;

        var mainContainerIndex:int = -1;
        for (var i:int = 0; i < systemTypesNum; i++) {
            var b:PaymentButton = new PaymentButton();
            b.type = buttonTypes[i];
            systemTypeButtons[i] = b;
            bigButtonsContainer.addChild(b);
            b.addEventListener(MouseEvent.CLICK, onSystemSelect);

            var smallButton:DefaultButton = new DefaultButton();
            smallButton.label = systemTypeButtonNames[i];
            systemTypeButtonsSmall[i] = smallButton;
            smallButtonsContainer.addChild(smallButton);
            smallButton.addEventListener(MouseEvent.CLICK, onSystemSelect);
            smallButton.width = b.width;

            if (i != INDEX_SMS) {
                if (mainContainerIndex == -1) {
                    var c:Sprite = new Sprite();
                    addChild(c);

                    exchangeGroup = new ExchangeGroup(int.MAX_VALUE);
                    c.addChild(exchangeGroup);
                    exchangeGroup.addEventListener(Event.CHANGE, onExchangeChange);

                    proceedButton = new DefaultButton();
                    proceedButton.label = localeService.getText(TextConst.PAYMENT_BUTTON_PROCEED_TEXT);
                    c.addChild(proceedButton);
                    proceedButton.enable = false;
                    proceedButton.addEventListener(MouseEvent.CLICK, onProceedButtonClick);

                    WMCombo = new TankCombo();
                    WMCombo.addItem({gameName:"WMB", rang:0, mode:Paymode.WMB.value});
                    WMCombo.addItem({gameName:"WME", rang:0, mode:Paymode.WME.value});
                    WMCombo.addItem({gameName:"WMR", rang:0, mode:Paymode.WMR.value});
                    WMCombo.addItem({gameName:"WMU", rang:0, mode:Paymode.WMU.value});
                    WMCombo.addItem({gameName:"WMZ", rang:0, mode:Paymode.WMZ.value});
                    WMCombo.addEventListener(Event.CHANGE, onWMComboSelect);
                    c.addChild(WMCombo);
                    WMCombo.label = localeService.getText(TextConst.PAYMENT_WMCOMBO_LABEL_TEXT);
                    WMCombo.visible = false;

                    terminalCountriesCombo = new TankCombo();
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_RUSSIA_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_RUSSIA)});
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_UKRAINE_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_UKRAINE)});
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_KAZAKHSTAN_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_KAZAKHSTAN)});
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_ARMENIA_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_ARMENIA)});
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_BELARUS_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_BELARUS)});
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_MOLDOVA_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_MOLDOVA)});
                    terminalCountriesCombo.addItem({gameName:localeService.getText(TextConst.COUNTRIES_TAJIKISTAN_NAME), rang:0, сode:localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_TAJIKISTAN)});
                    terminalCountriesCombo.sortOn("gameName");
                    c.addChild(terminalCountriesCombo);
                    terminalCountriesCombo.label = localeService.getText(TextConst.PAYMENT_TERMINAL_COUNTRIES_LABEL_TEXT);
                    terminalCountriesCombo.visible = false;

                    /*** кнопки предоплаченых карт  *******************************************************************/
                    prepayCardSelectedIndex = (storage.data.prepayCardSelectedIndex != null) ? storage.data.prepayCardSelectedIndex : 0;

                    wallieButton = new PaymentButton();
                    wallieButton.type = SYSTEM_TYPE_WALLIE;
                    c.addChild(wallieButton);
                    wallieButton.addEventListener(MouseEvent.CLICK, onPrepaidButtonSelected);
                    wallieButton.enable = !(prepayCardSelectedIndex == 0);

                    paysafeButton = new PaymentButton();
                    paysafeButton.type = SYSTEM_TYPE_PAYSAFE;
                    paysafeButton.y = wallieButton.height + spaceModule;
                    c.addChild(paysafeButton);
                    paysafeButton.addEventListener(MouseEvent.CLICK, onPrepaidButtonSelected);
                    paysafeButton.enable = !(prepayCardSelectedIndex == 1);

                    rixtyButton = new PaymentButton();
                    rixtyButton.type = SYSTEM_TYPE_RIXTY;
                    rixtyButton.y = paysafeButton.y + paysafeButton.height + spaceModule;
                    c.addChild(rixtyButton);
                    rixtyButton.addEventListener(MouseEvent.CLICK, onPrepaidButtonSelected);
                    rixtyButton.enable = !(prepayCardSelectedIndex == 2);

                    cashuButton = new PaymentButton();
                    cashuButton.type = SYSTEM_TYPE_CASHU;
                    cashuButton.y = rixtyButton.y + rixtyButton.height + spaceModule;
                    c.addChild(cashuButton);
                    cashuButton.addEventListener(MouseEvent.CLICK, onPrepaidButtonSelected);
                    cashuButton.enable = !(prepayCardSelectedIndex == 3);

                    /*** кнопки мобильных платежей на деньги онлайн карт  *******************************************************************/
                    mobilePaymentSelectedIndex = (storage.data.mobilePaymentSelectedIndex != null) ? storage.data.mobilePaymentSelectedIndex : 0;

                    megafonButton = new PaymentButton();
                    megafonButton.type = SYSTEM_TYPE_MEGAFON;
                    c.addChild(megafonButton);
                    megafonButton.addEventListener(MouseEvent.CLICK, onMobilePaymentButtonSelected);
                    megafonButton.enable = !(mobilePaymentSelectedIndex == 0);

                    beelineButton = new PaymentButton();
                    beelineButton.type = SYSTEM_TYPE_BEELINE;
                    beelineButton.y = megafonButton.y + megafonButton.height + spaceModule;
                    c.addChild(beelineButton);
                    beelineButton.addEventListener(MouseEvent.CLICK, onMobilePaymentButtonSelected);
                    beelineButton.enable = !(mobilePaymentSelectedIndex == 1);



                    /**************************************************************************************************/


                    chronopaySelected = (storage.data.chronopaySelected != null) ? storage.data.chronopaySelected : false;

                    liqpayButton = new PaymentButton();
                    liqpayButton.type = SYSTEM_TYPE_LIQPAY;
                    c.addChild(liqpayButton);
                    liqpayButton.addEventListener(MouseEvent.CLICK, onLiqpaySelected);
                    liqpayButton.enable = chronopaySelected;

                    chronopayButton = new PaymentButton();
                    chronopayButton.type = SYSTEM_TYPE_CHRONOPAY;
                    c.addChild(chronopayButton);
                    chronopayButton.addEventListener(MouseEvent.CLICK, onChronopaySelected);
                    chronopayButton.y = liqpayButton.height + spaceModule;
                    chronopayButton.enable = !chronopaySelected;


                    mainContainerIndex = i;

                } else {
                    c = tabContainers[mainContainerIndex];
                }
            } else {
                c = new Sprite();
                addChild(c);
            }
            tabContainers.push(c);
            c.visible = false;
        }

        systemTypeButtonsInner.x = windowMargin;
        systemTypeButtonsInner.y = windowMargin;
        systemTypeButtonsInner.width = (systemTypeButtons[0] as PaymentButton).width + (spaceModule + 1) * 2;

        colomn2x = systemTypeButtonsInner.x + systemTypeButtonsInner.width + spaceModule - 2;

        systemTypeTitle = new Label();
        addChild(systemTypeTitle);
        systemTypeTitle.size = 18;
        systemTypeTitle.text = systemTypeButtonNames[currentTabIndex] as String;
        systemTypeTitle.x = colomn2x + windowMargin;
        systemTypeTitle.y = windowMargin * 2;

        systemTypeDescriptionInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
        systemTypeDescriptionInner.showBlink = true;
        addChild(systemTypeDescriptionInner);
        systemTypeDescriptionInner.x = colomn2x + windowMargin;
        systemTypeDescriptionInner.y = windowMargin * 2 + systemTypeTitle.textHeight + spaceModule;

        scrollContainer = new Sprite();

        scrollPane = new ScrollPane();
        confScroll();
        scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
        scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
        scrollPane.source = scrollContainer;
        scrollPane.update();
        scrollPane.focusEnabled = false;
        addChild(scrollPane);

        systemTypeDescription = new Label();
        scrollContainer.addChild(systemTypeDescription);
        systemTypeDescription.multiline = true;
        systemTypeDescription.wordWrap = true;
        systemTypeDescription.text = systemTypeDescriptions[0] as String;
        systemTypeDescription.x = spaceModule;
        scrollPane.update();

        //TODO: убрать заглушку от китайцев
        //********************
        if (localeService.language != "cn") {
            // ERROR
            errorInner.x = colomn2x + windowMargin;
            errorInner.height = 45;
            errorIcon.x = errorInner.x + windowMargin;
            errorLabel.x = errorIcon.x + errorIcon.width + windowMargin;


            // SMS
            var container:Sprite = tabContainers[INDEX_SMS];
            smsBlock = new SMSblock();
            addChild(smsBlock);

            smsBlock.operatorsCombo.addEventListener(Event.CHANGE, onOperatorSelect);
            smsBlock.countriesCombo.addEventListener(Event.CHANGE, onCountrySelect);
        }

        resize(null);
		Main.stage.addEventListener(Event.RESIZE,resize);
    }

    private function confScroll():void {
        scrollPane.setStyle("downArrowUpSkin", ScrollArrowDownGreen);
        scrollPane.setStyle("downArrowDownSkin", ScrollArrowDownGreen);
        scrollPane.setStyle("downArrowOverSkin", ScrollArrowDownGreen);
        scrollPane.setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);

        scrollPane.setStyle("upArrowUpSkin", ScrollArrowUpGreen);
        scrollPane.setStyle("upArrowDownSkin", ScrollArrowUpGreen);
        scrollPane.setStyle("upArrowOverSkin", ScrollArrowUpGreen);
        scrollPane.setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);

        scrollPane.setStyle("trackUpSkin", ScrollTrackGreen);
        scrollPane.setStyle("trackDownSkin", ScrollTrackGreen);
        scrollPane.setStyle("trackOverSkin", ScrollTrackGreen);
        scrollPane.setStyle("trackDisabledSkin", ScrollTrackGreen);

        scrollPane.setStyle("thumbUpSkin", ScrollThumbSkinGreen);
        scrollPane.setStyle("thumbDownSkin", ScrollThumbSkinGreen);
        scrollPane.setStyle("thumbOverSkin", ScrollThumbSkinGreen);
        scrollPane.setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
    }

    public function resize(e:Event = null):void {
        Main.writeVarsToConsoleChannel("PAYMENT WINDOW", "resize");
		var width:int = Math.round(int(Math.max(100,Main.stage.stageWidth)) * 2 / 3);
        var height:int = int(Math.max(Main.stage.stageHeight - 60, 530));
		var minWidth:int = int(Math.max(100,Main.stage.stageWidth));
		this.x = Math.round(minWidth/3);
		this.y = 60;
        scrollPane.update();

        windowSize.x = width;
        windowSize.y = height;

        window.width = width;
        window.height = height;

        //TODO: убрать заглушку от китайцев
        if (localeService.language != "cn") {
            // ERROR
            errorInner.y = height - windowMargin - errorInner.height;
            errorInner.width = width - windowMargin * 2 - errorInner.x;
            errorIcon.y = errorInner.y + int((errorInner.height - errorIcon.height) * 0.5);
            errorLabel.y = errorInner.y + int((errorInner.height - errorLabel.height) * 0.5);
            errorButton.y = errorInner.y + spaceModule;
            errorButton.x = width - 125;
            errorLabel.width = errorButton.x - errorLabel.x - windowMargin;
        }

        headerInner.width = width - windowMargin * 2;
        headerInner.height = crystalsPic.height;
        header.width = width - header.x - windowMargin * 2;

        crystalsPic.y = headerInner.y;
        header.y = crystalsPic.y + Math.round((crystalsPic.height - header.textHeight) * 0.5);

        var row2y:int = headerInner.y + headerInner.height + spaceModule - 2;

        systemTypeButtonsInner.y = row2y;
        systemTypeButtonsInner.height = height - row2y - windowMargin;

        bigButtonsContainer.y = row2y + spaceModule + 1;
        smallButtonsContainer.y = bigButtonsContainer.y;
        for (var i:int = 0; i < systemTypesNum; i++) {
            var b:PaymentButton = systemTypeButtons[i];
            b.y = i * (b.height + systemTypeButtonsSpace);

            var smallButton:DefaultButton = systemTypeButtonsSmall[i];
            smallButton.y = i * (smallButton.height + systemTypeButtonsSpace);
        }
        if (height - (bigButtonsContainer.y + systemTypesNum * (systemTypeButtons[0] as PaymentButton).height + (systemTypesNum - 1) * systemTypeButtonsSpace + spaceModule + 1 + windowMargin) >= 0) {
            bigButtonsContainer.visible = true;
            smallButtonsContainer.visible = false;
        } else {
            bigButtonsContainer.visible = false;
            smallButtonsContainer.visible = true;
        }

        systemTypeTitle.y = systemTypeButtonsInner.y - 5;

        systemTypeDescriptionInner.y = row2y + spaceModule * 3;
        systemTypeDescriptionInner.width = width - windowMargin * 2 - systemTypeDescriptionInner.x;//colomn3x - colomn2x - spaceModule + 2;
        //systemTypeDescriptionInner.height = (currentTabIndex != 0) ? 100 : int((height - systemTypeDescriptionInner.y - windowMargin*2)*0.4);//systemTypeButtonsInner.height - (systemTypeDescriptionInner.y - systemTypeButtonsInner.y);
        var descriptionHeight:int = int((height - systemTypeDescriptionInner.y - windowMargin * 2) * 0.4) - (localeService.language != "cn" ? errorInner.height : 0) - windowMargin;
        systemTypeDescriptionInner.height = descriptionHeight;


        systemTypeDescription.width = systemTypeDescriptionInner.width - spaceModule * 3;

        colomn3x = int(systemTypeDescriptionInner.width * 0.25);
        var colomn3width:int = int(systemTypeDescriptionInner.width * 0.5);

        scrollPane.x = systemTypeDescriptionInner.x;
        scrollPane.y = systemTypeDescriptionInner.y + spaceModule;
        //scrollPane.setSize(systemTypeDescriptionInner.width, (currentTabIndex != 0) ? 100 : int((height - systemTypeDescriptionInner.y - windowMargin*2)*0.4) - spaceModule*2);
        //scrollPane.setSize(systemTypeDescriptionInner.width, (currentTabIndex != 0) ? 100 : systemTypeDescriptionInner.height - spaceModule*2);
        scrollPane.setSize(systemTypeDescriptionInner.width, descriptionHeight - spaceModule * 2);
        scrollPane.update();

        tabContainers[currentTabIndex].x = colomn2x + windowMargin;

        tabContainers[currentTabIndex].y = systemTypeDescriptionInner.y + descriptionHeight + spaceModule;

        //TODO: убрать заглушку от китайцев
        if (currentTabIndex == INDEX_SMS && localeService.language != "cn") {
            smsBlock.resize(systemTypeDescriptionInner.width, height - tabContainers[currentTabIndex].y - windowMargin * 2 - errorInner.height);
        } else {
            //tabContainers[currentTabIndex].y = systemTypeDescriptionInner.y + 100 + spaceModule;
            if (currentTabIndex == INDEX_WEBMONEY && localeService.language != "cn") {
                WMCombo.x = colomn3x;
                WMCombo.width = colomn3width;
                exchangeGroup.y = spaceModule * 5;
            } else if (currentTabIndex == INDEX_TERMINAL && localeService.language != "cn") {
                terminalCountriesCombo.x = colomn3x + 4;
                terminalCountriesCombo.width = colomn3width - 8;
                exchangeGroup.y = spaceModule * 5;
            } else {
                exchangeGroup.y = 0;
            }
            exchangeGroup.x = (currentTabIndex == INDEX_VISA || currentTabIndex == INDEX_PREPAID || currentTabIndex == INDEX_MOBILE_PAYMENT) ? chronopayButton.width + spaceModule : colomn3x;
            exchangeGroup.resize(colomn3width);

            proceedButton.x = (currentTabIndex == INDEX_VISA || currentTabIndex == INDEX_PREPAID || currentTabIndex == INDEX_MOBILE_PAYMENT) ? chronopayButton.width + spaceModule + 4 : colomn3x + 4;
            proceedButton.y = (!exchangeGroup.visible) ? spaceModule * 5 + 3 : exchangeGroup.y + exchangeGroup.height + spaceModule;
            proceedButton.width = colomn3width - 8;
        }
    }

    public function setInitData(countries:Array, rates:Array, accountId:String, projectId:int, formId:String):void {
        if (storage.data.paymentSystemType != null && buttonTypes.indexOf(storage.data.paymentSystemType) != -1) {
            currentTabIndex = buttonTypes.indexOf(storage.data.paymentSystemType);
        } else {
            currentTabIndex = 0;
        }

        setSystemIndex(currentTabIndex);

        //TODO: убрать заглушку от китайцев
        if (localeService.language != "cn") smsBlock.countriesCombo.clear();

        this.rates = rates;

        var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
        var panelModel:IPanel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
        if (localeService.language != "cn") {
            for (var i:int = 0; i < countries.length; i++) {
                var country:Country = countries[i] as Country;
                smsBlock.countriesCombo.addItem({gameName:country.name, rang:0, id:country.id});
            }
            smsBlock.countriesCombo.sortOn("gameName");
            Main.writeVarsToConsoleChannel("PAYMENT", "setInitData countriesCombo.value after sortOn: %1", smsBlock.countriesCombo.value);
            Main.writeVarsToConsoleChannel("PAYMENT", "setInitData countriesCombo.value after sortOn: %1", smsBlock.countriesCombo.selectedItem["gameName"]);
            // Установка сохраненного выбора
            if (storage.data.userCountryName != null) {
                smsBlock.countriesCombo.value = storage.data.userCountryName;
            } else {
                smsBlock.countriesCombo.selectedItem = null;
            }
        }
        if (storage.data.paymentLastInputValue != null) {
            Main.writeVarsToConsoleChannel("PAYMENT", "paymentLastInputValue: %1", storage.data.paymentLastInputValue);
            exchangeGroup.inputValue = storage.data.paymentLastInputValue;
            if (exchangeGroup.inputValue != 0) {
                unlockProceedButtons();
            }
        } else {
            Main.writeVarsToConsoleChannel("PAYMENT", "paymentLastInputValue = null");
        }
        if (storage.data.paymentWMType != null) {
            WMCombo.value = storage.data.paymentWMType;
        }

        if (chronopaySelected) {
            onChronopaySelected(null);
        } else {
            onLiqpaySelected(null);
        }

        onPrepaidButtonSelected();
        onMobilePaymentButtonSelected();
        //if (currentTabIndex == 0) {
        //Main.writeVarsToConsoleChannel("PAYMENT", "setInitData dispatchEvent SELECT_COUNTRY (%1)", smsBlock.countriesCombo.value);
        //dispatchEvent(new PaymentWindowEvent(PaymentWindowEvent.SELECT_COUNTRY));
        //}

        //smsBlock.countriesCombo.addEventListener(Event.CHANGE, onCountrySelect);
    }

    public function setOperators(operators:Array):void {
        //Main.writeVarsToConsoleChannel("PAYMENT", "setOperators (%1)", operators.length);
        var selectedOperatorName:String = "";

        smsBlock.operatorsCombo.clear();
        smsBlock.smsString = "";

        for (var i:int = 0; i < operators.length; i++) {
            var operator:Operator = operators[i] as Operator;
            smsBlock.operatorsCombo.addItem({gameName:operator.name, rang:0, id:operator.id});
            if (storage.data.userOperatorName != null && operator.name == storage.data.userOperatorName) {
                selectedOperatorName = operator.name;
            }
        }
        smsBlock.operatorsCombo.sortOn("gameName");
        // Установка оператора

        if (selectedOperatorName != "") {
            smsBlock.operatorsCombo.value = selectedOperatorName;
        } else {
            smsBlock.operatorsCombo.selectedItem = null;
            storage.data.userOperatorName = null;
            smsBlock.numbersList.clear();
        }
        //Main.writeVarsToConsoleChannel("PAYMENT", "setOperators dispatchEvent SELECT_OPERATOR");
        //dispatchEvent(new PaymentWindowEvent(PaymentWindowEvent.SELECT_OPERATOR));
        //smsBlock.operatorsCombo.addEventListener(Event.CHANGE, onOperatorSelect);
    }

    public function setNumbers(numbers:Array):void {
        //Main.writeVarsToConsoleChannel("PAYMENT", "setNumbers (%1)", numbers.length);
        this.numbers = numbers;
        this.numbers.sort(sortNumbersByCost);
        smsBlock.numbersList.clear();

        var number:SMSNumber = numbers[0] as SMSNumber;
        var text:String = number.smsText;
        var difference:Boolean = false;
        for (var i:int = 1; i < numbers.length; i++) {
            number = numbers[i] as SMSNumber;
            if (number.smsText != text) {
                difference = true;
                break;
            }
        }
        smsBlock.oneTextForAllNumbers = !difference;
        for (i = 0; i < numbers.length; i++) {
            number = numbers[i] as SMSNumber;
            smsBlock.numbersList.addItem(int(number.number), Number(number.cost.toFixed(2)), number.currency, number.crystal, (difference) ? number.smsText : "");
        }
        if (!difference) {
            smsBlock.smsString = text;
        }
    }

    private function sortNumbersByCost(n1:SMSNumber, n2:SMSNumber):int {
        var result:int;
        if (n1.cost > n2.cost) {
            result = -1;
        } else if (n1.cost < n2.cost) {
            result = 1;
        } else {
            result = 0;
        }
        return result;
    }

    public function get selectedCountry():String {
        var id:String = smsBlock.countriesCombo.selectedItem["id"] as String;
        //Main.writeVarsToConsoleChannel("PAYMENT", "selectedCountry: %1", id);
        return id;
    }

    public function get selectedOperator():int {
        var id:int = smsBlock.operatorsCombo.selectedItem["id"] as int;
        //Main.writeVarsToConsoleChannel("PAYMENT", "selectedOperator: %1", id);
        return id;
    }

    private function lockProceedButtons():void {
        proceedButton.enable = false;
    }

    private function unlockProceedButtons():void {
        proceedButton.enable = true;
    }

    private function onSystemSelect(e:MouseEvent):void {
        Main.writeVarsToConsoleChannel("PAYMENT", "onSystemSelect");
        if (bigButtonsContainer.visible) {
            Main.writeVarsToConsoleChannel("PAYMENT", "   type: %1", (e.currentTarget as PaymentButton).type);
            var index:int = systemTypeButtons.indexOf(e.currentTarget);
        } else {
            index = systemTypeButtonsSmall.indexOf(e.currentTarget);
        }
        setSystemIndex(index);
    }

    private function setSystemIndex(index:int):void {
        Main.writeVarsToConsoleChannel("PAYMENT", "setSystemIndex: %1", index);
        (tabContainers[currentTabIndex] as Sprite).visible = false;

        var button:PaymentButton = systemTypeButtons[currentTabIndex];
        button.enable = true;
        var smallButton:DefaultButton = systemTypeButtonsSmall[currentTabIndex];
        smallButton.enable = true;

        button = systemTypeButtons[index];
        button.enable = false;
        smallButton = systemTypeButtonsSmall[index];
        smallButton.enable = false;

        currentTabIndex = index;
        (tabContainers[currentTabIndex] as Sprite).visible = true;

        systemTypeTitle.text = systemTypeButtonNames[index] as String;
        var helpURL:String = (localeService.language == "ru") ? "<font color='#00ff0b'><u><a href='http://forum.tankionline.com/posts/list/12852.page' target='_blank'>Инструкция по покупке кристаллов</a></u></font>" : ((localeService.language == "en") ? "<font color='#00ff0b'><u><a href='http://forum.tankionline.com/posts/list/1171.page#101800' target='_blank'>Crystal purchase instruction</a></u></font>" : "<font color='#00ff0b'><u><a href='http://forum.3dtank.com/posts/list/7.page' target='_blank'>水晶购买指南</a></u></font>");
        systemTypeDescription.htmlText = (systemTypeDescriptions[index] as String) + "\n\n" + helpURL;
        scrollPane.update();

        if (currentTabIndex != INDEX_SMS) {
            if (exchangeGroup.inputValue != 0) {
                onExchangeChange();
            }
            WMCombo.visible = (currentTabIndex == INDEX_WEBMONEY);
            terminalCountriesCombo.visible = (currentTabIndex == INDEX_TERMINAL);
            exchangeGroup.visible = !(currentTabIndex == INDEX_YANDEX || currentTabIndex == INDEX_WEBMONEY || currentTabIndex == INDEX_TERMINAL);
            if (currentTabIndex == INDEX_YANDEX || currentTabIndex == INDEX_WEBMONEY) {
                proceedButton.enable = true;
            } else {
                proceedButton.enable = ((currentTabIndex == INDEX_TERMINAL && terminalCountriesCombo.selectedItem != null) || (currentTabIndex != INDEX_TERMINAL && exchangeGroup.inputValue != 0));
            }
        }

        chronopayButton.visible = liqpayButton.visible = currentTabIndex == INDEX_VISA;
        wallieButton.visible = paysafeButton.visible = rixtyButton.visible = (currentTabIndex == INDEX_PREPAID);
        cashuButton.visible = (currentTabIndex == INDEX_PREPAID && SYSTEM_TYPE_PREPAID == "prepaiden");

        megafonButton.visible = beelineButton.visible = (currentTabIndex == INDEX_MOBILE_PAYMENT);

        //resize(windowSize.x, windowSize.y);

        storage.data.paymentSystemType = buttonTypes[currentTabIndex];
    }

    private function onCountrySelect(e:Event):void {
        //Main.writeVarsToConsoleChannel("PAYMENT", "onCountrySelect");
        if (smsBlock.countriesCombo.selectedItem != null && smsBlock.countriesCombo.selectedItem != "") {
            storage.data.userCountryName = smsBlock.countriesCombo.selectedItem["gameName"];

            //smsBlock.operatorsCombo.removeEventListener(Event.CHANGE, onOperatorSelect);
            dispatchEvent(new PaymentWindowEvent(PaymentWindowEvent.SELECT_COUNTRY));
        }
    }

    private function onOperatorSelect(e:Event):void {
        //Main.writeVarsToConsoleChannel("PAYMENT", "onOperatorSelect");
        if (smsBlock.operatorsCombo.selectedItem != null && smsBlock.operatorsCombo.selectedItem != "") {
            storage.data.userOperatorName = smsBlock.operatorsCombo.selectedItem["gameName"];

            //smsBlock.smsText.text = localeService.getText(TextConst.PAYMENT_SMSTEXT_HEADER_LABEL_TEXT) + "   " + smsBlock.operatorsCombo.selectedItem["smsText"];
            //smsText.text = localeService.getText(TextConst.PAYMENT_SMSTEXT_HEADER_LABEL_TEXT) + "   BTL+" + panelModel.userName;
            //Main.writeVarsToConsoleChannel("PAYMENT", "onOperatorSelect dispatchEvent SELECT_OPERATOR");
            dispatchEvent(new PaymentWindowEvent(PaymentWindowEvent.SELECT_OPERATOR));
        }
    }

    private function onProceedButtonClick(e:MouseEvent):void {
        var payMode:String;
        switch (currentTabIndex) {
            case INDEX_QIWI:
                payMode = "mk";
                break;
            case INDEX_YANDEX:
                payMode = "yandex";
                break;
            case INDEX_VISA:
                payMode = "bank_card";
                break;
            case INDEX_PREPAID:
                payMode = "prepaid";
                break;
            case INDEX_MOBILE_PAYMENT:
                payMode = "mobilepayment";
                break;
            case INDEX_WEBMONEY:
                var mode:int = WMCombo.selectedItem["mode"];
                switch (mode) {
                    case Paymode.WMB.value:
                        payMode = "wmb";
                        break;
                    case Paymode.WME.value:
                        payMode = "wme";
                        break;
                    case Paymode.WMR.value:
                        payMode = "wmr";
                        break;
                    case Paymode.WMU.value:
                        payMode = "wmu";
                        break;
                    /*case Paymode.WMY.value:
                     payMode = "wmy";
                     break;*/
                    case Paymode.WMZ.value:
                        payMode = "wmz";
                        break;
                }
                break;
            case INDEX_EASYPAY:
                payMode = "easypay";
                break;
            //				case INDEX_RBK:
            //					payMode = "rbk";
            //					break;
            //				case INDEX_MONEYMAIL:
            //					payMode = "moneymail";
            //					break;
            //				case INDEX_WEBCREDS:
            //					payMode = "webcreds";
            //					break;
            case INDEX_PAYPAL:
                payMode = "paypal";
                break;
            case INDEX_TERMINAL:
                payMode = "terminal";
                break;
            case INDEX_ALIPAY:
                payMode = "alipay";
                break;

        }
        var request:URLRequest;
        var variables:URLVariables = new URLVariables();
        var paymentModel:IPayment = ((Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPayment)[0] as IPayment);
        var panelModel:IPanel = ((Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPanel)[0] as IPanel);

        if (payMode == "paypal") {
            /*url = (localeService.language == "ru") ? "http://2pay.ru/oplata/paypal/?id=2148" : "http://2pay.us.com/oplata/paypal/?id=2148";
             request = new URLRequest(url);

             variables["v1"] = panelModel.userName;
             variables["amount"] = exchangeGroup.inputValue;*/
            url = "http://www.onlinedengi.ru/wmpaycheck.php";
            request = new URLRequest(url);
            variables["project"] = paymentModel.projectId;
            variables["nickname"] = panelModel.userName;
            variables["source"] = paymentModel.formId;
            variables["paymode"] = "34";


            variables["amount"] = exchangeGroup.outputValue;
        } else if (payMode == "yandex") {
            request = new URLRequest("https://2pay.ru/oplata/yandex/?id=2148");

            variables["v1"] = panelModel.userName;

        } else if (payMode == "prepaid") {
            var urlpart:Array = ["wallie.html","psc.html","rixty/","cashu/"];
            request = new URLRequest("http://2pay.us.com/oplata/" + urlpart[prepayCardSelectedIndex] + "?id=2148");
            variables["v1"] = panelModel.userName;
            variables["amount"] = exchangeGroup.inputValue;
        } else if (payMode == "mobilepayment") {
            url = "http://www.onlinedengi.ru/wmpaycheck.php";
            request = new URLRequest(url);
            variables["project"] = paymentModel.projectId;
            variables["nickname"] = panelModel.userName;
            variables["source"] = paymentModel.formId;

            if (mobilePaymentSelectedIndex == 0) {
                variables["mode_type"] = "39";
            } else {
                variables["mode_type"] = "45";
            }
            variables["amount"] = exchangeGroup.outputValue;
        } else if (payMode == "easypay") {
            url = "http://www.onlinedengi.ru/wmpaycheck.php";
            request = new URLRequest(url);
            variables["project"] = paymentModel.projectId;
            variables["nickname"] = panelModel.userName;
            variables["source"] = paymentModel.formId;
            variables["mode_type"] = 16;
            variables["amount"] = exchangeGroup.outputValue;
        } else if (payMode.indexOf("wm") != -1) {
            request = new URLRequest("https://2pay.ru/oplata/wm/?id=2148");

            variables["v1"] = panelModel.userName;
        } else if (payMode == "bank_card") {
            if (chronopaySelected) {
                url = (localeService.language == "ru") ? "http://www.onlinedengi.ru/wmpaycheck.php" : "http://en.onlinedengi.ru/wmpaycheck.php";
                variables["project"] = paymentModel.projectId;
                variables["nickname"] = panelModel.userName;
                variables["source"] = paymentModel.formId;
                //variables["paymode"] = payMode;
                variables["amount"] = exchangeGroup.outputValue;
                variables["mode_type"] = (localeService.language == "ru") ? 8 : 23;
            } else {
                var url:String = (localeService.language == "ru") ? "http://2pay.ru/oplata/liqpay/?id=2148" : "http://2pay.us.com/oplata/liqpay/?id=2148";
                variables["v1"] = panelModel.userName;
                variables["amount"] = exchangeGroup.inputValue;
                //variables["currency"] = (localeService.language == "ru") ? "RUR" : "USD";

            }
            request = new URLRequest(url);
        } else if (payMode == "terminal") {
            var countryCode:String = terminalCountriesCombo.selectedItem["сode"];
            //Main.writeVarsToConsoleChannel("PAYMENT", "2pay countryCode: %1", countryCode);
            switch (countryCode) {
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_RUSSIA):
                    url = "http://2pay.ru/oplata/number.html?id=2148";
                    break;
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_UKRAINE):
                    url = "http://2pay.ru/oplata/number_ukr.html?id=2148";
                    break;
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_KAZAKHSTAN):
                    url = "http://2pay.ru/oplata/osmp_kaz.html?id=2148 ";
                    break;
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_ARMENIA):
                    url = "http://2pay.ru/oplata/telcell.html?id=2148";
                    break;
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_BELARUS):
                    url = "http://2pay.ru/oplata/terminal_bel.html?id=2148 ";
                    break;
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_MOLDOVA):
                    url = "http://2pay.ru/oplata/osmp_mdl.html?id=2148";
                    break;
                case localeService.getText(TextConst.COUNTRIES_ALPHA2_CODE_TAJIKISTAN):
                    url = "http://2pay.ru/oplata/tj-terminal.html?id=2148";
                    break;
            }
            request = new URLRequest(url);
            variables["v1"] = panelModel.userName;
        } else if (payMode == "mk") {
            //request = new URLRequest("http://www.onlinedengi.ru/wmpaycheck.php");
            request = new URLRequest("https://2pay.ru/oplata/qiwi.html?id=2148");
            variables["v1"] = panelModel.userName;
            variables["project"] = paymentModel.projectId;
            variables["nickname"] = panelModel.userName;
            variables["source"] = paymentModel.formId;
            variables["paymode"] = payMode;
            variables["amount"] = exchangeGroup.outputValue;
        } else if (payMode == "alipay") {
            var key:String = "qon0ih01ucfwx8r9i2baxk85jhhav4s5";
            var params:Array = new Array();
            params.push({key:"service", value:"create_direct_pay_by_user"});
            params.push({key:"partner", value:"2088401488796054"});
            params.push({key:"notify_url", value:"http://3dtank.com:8181/billing/alipay"});
            params.push({key:"_input_charset", value:"utf-8"});
            params.push({key:"subject", value: panelModel.userName});
            params.push({key:"out_trade_no", value: getTimer().toString()+"-"+paymentModel.accountId});
            params.push({key:"total_fee", value: exchangeGroup.outputValue.toString()});
            params.push({key:"payment_type", value:"1"});
            params.push({key:"seller_email", value:"zhifu@3dtank.com"});

            params.sortOn("key");

            var toSign:String = "";
            url = "";

            for(var i:int = 0; i < params.length; i++) {
                toSign += "&" + params[i].key + "=" + params[i].value;
                url += "&" + params[i].key + "=" + escape(params[i].value);
            }

            toSign = toSign.substr(1);
            url = url.substr(1);

            var sign:String = MD5.encrypt(toSign+key);

            request = new URLRequest("https://www.alipay.com/cooperate/gateway.do?"+url+"&sign="+sign+"&sign_type=MD5");
            //Main.writeVarsToConsoleChannel("PAYMENT", "alipay request = %1", "https://www.alipay.com/cooperate/gateway.do?"+url+"&sign="+sign+"&sign_type=MD5");
        } else {
            request = new URLRequest("http://www.onlinedengi.ru/wmpaycheck.php");
            variables["project"] = paymentModel.projectId;
            variables["nickname"] = panelModel.userName;
            variables["source"] = paymentModel.formId;
            variables["paymode"] = payMode;
            variables["amount"] = exchangeGroup.outputValue;
        }
        request.method = URLRequestMethod.POST;
        request.data = variables;
        navigateToURL(request, "_blank");
    }

    private function onWMComboSelect(e:Event):void {
        //Main.writeVarsToConsoleChannel("PAYMENT", "WMCombo.selectedItem: %1", WMCombo.selectedItem["mode"]);
        storage.data.paymentWMType = WMCombo.selectedItem["gameName"];

        onExchangeChange();
    }

    private var visaRateValue:Number;
    private var visaCurrency:String;

    private function onChronopaySelected(e:MouseEvent):void {
        var paymentModel:IPayment = ((Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPayment)[0] as IPayment);
        chronopayButton.enable = false;
        liqpayButton.enable = true;
        chronopaySelected = true;
        visaCurrency = paymentModel.currentLocaleCurrency;
        visaRateValue = rates[Paymode.BANK_CARD.value];
        storage.data.chronopaySelected = chronopaySelected;
        onExchangeChange();
    }

    private function onLiqpaySelected(e:MouseEvent):void {
        var paymentModel:IPayment = ((Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPayment)[0] as IPayment);
        chronopayButton.enable = true;
        liqpayButton.enable = false;
        chronopaySelected = false;
        visaCurrency = 'USD';
        visaRateValue = rates[Paymode.LIQPAY.value];
        storage.data.chronopaySelected = chronopaySelected;
        onExchangeChange();
    }

    private var prepaidRate:Number = 0;

    private function onPrepaidButtonSelected(e:MouseEvent = null):void {
        var prepaidButtons:Array = [wallieButton, paysafeButton, rixtyButton, cashuButton];
        var preRates:Array = [rates[Paymode.WALLIE.value],rates[Paymode.PAYSAFE.value],rates[Paymode.RIXTY.value],rates[Paymode.CASHU.value]];
        if (e != null) {
            var trgt:PaymentButton = e.currentTarget as PaymentButton;
            for each (var button:PaymentButton in prepaidButtons) {
                button.enable = !(button == trgt);
            }
            prepayCardSelectedIndex = prepaidButtons.indexOf(trgt);
        }
        prepaidRate = preRates[prepayCardSelectedIndex];
        storage.data.prepayCardSelectedIndex = prepayCardSelectedIndex;
        onExchangeChange();
    }


    private var mobilePaymentRate:Number = 0;

    private function onMobilePaymentButtonSelected(e:MouseEvent = null):void {
        var mobilePaymentsButtons:Array = [megafonButton, beelineButton];
        var mobRates:Array = [rates[Paymode.MEGAFON.value],rates[Paymode.BEELINE.value]];
        if (e != null) {
            var trgt:PaymentButton = e.currentTarget as PaymentButton;
            for each (var button:PaymentButton in mobilePaymentsButtons) {
                button.enable = !(button == trgt);
            }
            mobilePaymentSelectedIndex = mobilePaymentsButtons.indexOf(trgt);
        }
        mobilePaymentRate = mobRates[mobilePaymentSelectedIndex];
        storage.data.mobilePaymentSelectedIndex = mobilePaymentSelectedIndex;
        onExchangeChange();
    }


    private function onExchangeChange(e:Event = null):void {
        //Main.writeVarsToConsoleChannel("PAYMENT", "onExchangeChange currentTabIndex: %1", currentTabIndex);
        var paymentModel:IPayment = ((Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPayment)[0] as IPayment);
        switch (currentTabIndex) {
            case INDEX_QIWI:
                exchangeGroup.outputValue = rates[Paymode.MK.value] * exchangeGroup.inputValue;
                exchangeGroup.currency = paymentModel.currentLocaleCurrency;
                break;
            case INDEX_YANDEX:
                exchangeGroup.outputValue = rates[Paymode.YANDEX.value] * exchangeGroup.inputValue;
                exchangeGroup.currency = paymentModel.currentLocaleCurrency;
                break;
            case INDEX_VISA:
                exchangeGroup.outputValue = visaRateValue * exchangeGroup.inputValue;
                exchangeGroup.currency = visaCurrency;
                break;
            case INDEX_PREPAID:
                exchangeGroup.outputValue = prepaidRate * exchangeGroup.inputValue;
                exchangeGroup.currency = "USD";
                break;
            case INDEX_MOBILE_PAYMENT:
                exchangeGroup.outputValue = mobilePaymentRate * exchangeGroup.inputValue;
                exchangeGroup.currency = "RUR";
                break;
            case INDEX_WEBMONEY:
                // WebMoney
                /*if (WMCombo.selectedItem != null) {
                 var mode:int = WMCombo.selectedItem["mode"];
                 exchangeGroup.outputValue = rates[mode]*exchangeGroup.inputValue;
                 switch (mode) {
                 case Paymode.WMB.value:
                 exchangeGroup.currency = "BYR";
                 break;
                 case Paymode.WME.value:
                 exchangeGroup.currency = "EUR";
                 break;
                 case Paymode.WMR.value:
                 exchangeGroup.currency = "RUR";
                 break;
                 case Paymode.WMU.value:
                 exchangeGroup.currency = "UAH";
                 break;
                 case Paymode.WMZ.value:
                 exchangeGroup.currency = "USD";
                 break;
                 }
                 }*/
                break;
            case INDEX_EASYPAY:
                //Main.writeVarsToConsoleChannel("PAYMENT", "EASYPAY rate: %1", rates[Paymode.EASYPAY.value]);
                exchangeGroup.outputValue = rates[Paymode.EASYPAY.value]*exchangeGroup.inputValue;
                exchangeGroup.currency = "BYR";
                break;
            //				case INDEX_RBK:
            //					exchangeGroup.outputValue = rates[Paymode.RBK.value]*exchangeGroup.inputValue;
            //                    exchangeGroup.currency = paymentModel.currentLocaleCurrency;
            //					break;
            //				case INDEX_MONEYMAIL:
            //					exchangeGroup.outputValue = rates[Paymode.MONEYMAIL.value]*exchangeGroup.inputValue;
            //                    exchangeGroup.currency = paymentModel.currentLocaleCurrency;
            //					break;
            //				case INDEX_WEBCREDS:
            //					exchangeGroup.outputValue = rates[Paymode.WEBCREDS.value]*exchangeGroup.inputValue;
            //                    exchangeGroup.currency = paymentModel.currentLocaleCurrency;
            //					break;
            case INDEX_PAYPAL:
                var result:Number = rates[Paymode.PAYPAL.value] * exchangeGroup.inputValue;
                exchangeGroup.outputValue = (result < 14) ? result + 0.4 : result;
                exchangeGroup.currency = "USD";
                break;

            case INDEX_ALIPAY:
                //var result:Number = rates[Paymode.PAYPAL.value] * exchangeGroup.inputValue;
                exchangeGroup.outputValue = rates[Paymode.ALIPAY.value] * exchangeGroup.inputValue;
                exchangeGroup.currency = "元";
                break;

        }

        storage.data.paymentLastInputValue = exchangeGroup.inputValue;

        if (exchangeGroup.inputValue != 0) {
            unlockProceedButtons();
        } else {
            lockProceedButtons();
        }
    }

    private function onErrorButtonClick(e:MouseEvent):void {
        panelModel.blur();

        bugReportWindow = new PaymentBugReportWindow();
        dialogsLayer.addChild(bugReportWindow);
        bugReportWindow.addEventListener(Event.COMPLETE, onBugReportComplete);
        bugReportWindow.addEventListener(Event.CANCEL, onBugReportCancel);

        //alignReportWindow();
        Main.stage.addEventListener(Event.RESIZE, alignReportWindow);

    }

    private function alignReportWindow(e:Event = null):void {
        bugReportWindow.x = Math.round((Main.stage.stageWidth - bugReportWindow.width) * 0.5);
        bugReportWindow.y = Math.round((Main.stage.stageHeight - bugReportWindow.height) * 0.5);
    }

    private function onBugReportCancel(e:Event = null):void {
        bugReportWindow.removeEventListener(Event.COMPLETE, onBugReportComplete);
        bugReportWindow.removeEventListener(Event.CANCEL, onBugReportCancel);
        Main.stage.removeEventListener(Event.RESIZE, alignReportWindow);

        dialogsLayer.removeChild(bugReportWindow);

        panelModel.unblur();
    }

    private function onBugReportComplete(e:Event = null):void {
        onBugReportCancel();

        panelModel.sendBugReport("PAYMENT bug report", bugReportWindow.reportString);
    }

    


}
}