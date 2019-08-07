package alternativa.tanks.model
{
   import alternativa.init.Main;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.loaderParams.ILoaderParamsService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IAddressService;
   import alternativa.tanks.gui.ChangeEmailAndPasswordWindow;
   import alternativa.tanks.gui.ChangePasswordAndEmailEvent;
   import alternativa.tanks.gui.InviteWindow;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.locale.constants.TextConst;
   import utils.client.models.core.users.model.entrance.ConfirmEmailStatus;
   import utils.client.models.core.users.model.entrance.EntranceModelBase;
   import utils.client.models.core.users.model.entrance.IEntranceModelBase;
   import utils.client.models.core.users.model.entrance.RegisterStatusEnum;
   import utils.client.models.core.users.model.entrance.RestorePasswordStatusEnum;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import forms.Alert;
   import forms.AlertAnswer;
   import forms.LoginForm;
   import forms.RegisterForm;
   import forms.ViewText;
   import forms.events.AlertEvent;
   import forms.events.LoginFormEvent;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworkListener;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.network.commands.Command;
   import alternativa.network.commands.Type;
   
   public class UserModel extends EntranceModelBase implements IEntranceModelBase, IObjectLoadListener, INetworkListener
   {
      
      private var addressService:IAddressService;
      
      private var loaderParamsService:ILoaderParamsService;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var loginForm:LoginForm;
      
      private var errorWindow:Alert;
      
      private var confirmAlert:Alert;
      
      private var changeEmailAndPasswordWindow:ChangeEmailAndPasswordWindow;
      
      private var inputShortInt:int = -1;
      
      private var inputLongInt:int = -1;
      
      private const inputShortDelay:int = 250;
      
      private const inputLongDelay:int = 3000;
      
      private const STATE_LOGIN:int = 1;
      
      private const STATE_REGISTER:int = 2;
      
      private const STATE_RESTORE_PASSWORD:int = 3;
      
      private var state:int = 0;
      
      private var not1stSimbols:String = "-_.";
      
      private var hash:String;
      
      private var emailConfirmHash:String;
      
      private var email:String;
	  
	  private var pass:String;
      
      private var emailChangeHash:String;
      
      private var inviteWindow:InviteWindow;
      
      private var inviteEnabled:Boolean;
      
      private var antiAddictionEnabled:Boolean;
      
      private var params:Dictionary;
	  
	  private var storage1:SharedObject = SharedObject.getLocal("tttty");
      
      private var checkCallsignTimer:Timer;
	  
	  private var checkInvTimer:Timer;
      
      private const checkCallsignDelay:int = 500;
      
      private var localeService:ILocaleService;
      
      private var network:Network;
      
      private var isUnique:Boolean;
      
      public function UserModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IEntranceModelBase);
         _interfaces.push(IObjectLoadListener);
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.layer = Main.contentUILayer;
         this.inviteWindow = new InviteWindow();
         this.addressService = Main.osgi.getService(IAddressService) as IAddressService;
         this.loaderParamsService = Main.osgi.getService(ILoaderParamsService) as ILoaderParamsService;
		 CheckLoader(Main.osgi.getService(ILoader)).setFullAndClose(null);
      }
      
      public function initObject(clientObject:ClientObject, antiAddictionEnabled:Boolean, inviteEnabled:Boolean) : void
      {
         this.inviteEnabled = inviteEnabled;
         this.antiAddictionEnabled = antiAddictionEnabled;
         this.loginForm = new LoginForm(antiAddictionEnabled);
		 //Main.stage.addEventListener(Event.RESIZE,df);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var s:String = null;
         var v:Array = null;
         var i:int = 0;
         var p:Array = null;
         var loaderService:ILoaderWindowService = null;
         var loaderServiceE:ILoaderWindowService = null;
         Main.writeVarsToConsoleChannel("USER MODEL","objectLoaded");
         this.clientObject = object;
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         this.network = Main.osgi.getService(INetworker) as Network;
         this.network.addListener(this);
         this.network.send("system;init_location;" + Game.currLocale);
         if(this.addressService != null)
         {
            s = this.addressService.getValue();
            v = s.split("&");
            this.params = new Dictionary();
            for(i = 0; i < v.length; i++)
            {
               p = (v[i] as String).split("=");
               this.params[p[0]] = p[1];
            }
            this.hash = this.params["hash"];
            this.emailConfirmHash = this.params["emailConfirmHash"];
            this.email = this.params["userEmail"];
            this.emailChangeHash = this.params["emailChangeHash"];
         }
         Main.writeVarsToConsoleChannel("USER MODEL","hassssssh: %1",this.hash);
         if(this.hash != null && this.hash != "")
         {
            storage.data.userHash = this.hash;
         }
         else
         {
            this.hash = storage.data.userHash;
         }
         if(this.email != null && this.email != "")
         {
            storage.data.userEmail = this.email;
         }
         else
         {
            this.email = storage.data.userEmail;
         }
         Main.writeVarsToConsole("USER MODEL","   hash: %1",this.hash);
         Main.writeVarsToConsole("USER MODEL","   email: %1",this.email);
         Main.writeVarsToConsole("USER MODEL","   emailConfirmHash: %1",this.emailConfirmHash);
         if(this.emailConfirmHash != null)
         {
            loaderService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
            loaderService.hideLoaderWindow();
            loaderService.lockLoaderWindow();
            this.confirmAlert = new Alert(Alert.ALERT_CONFIRM_EMAIL);
            this.layer.addChild(this.confirmAlert);
            this.confirmAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAlertButtonPressed);
         }
         else if(this.emailChangeHash != null)
         {
            loaderServiceE = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
            loaderServiceE.hideLoaderWindow();
            loaderServiceE.lockLoaderWindow();
         }
         else
         {
            this.enter();
         }
      }
      
      public function onData(data:Command) : void
      {
         if(data.type == Type.REGISTRATON)
         {
            switch(data.args[0])
            {
               case "check_name_result":
                  this.nameUnique(null,data.args[1] == "not_exist"?Boolean(true):Boolean(false));
                  break;
			   case "check_inv_result":
                  this.inv(data.args[1] == "not_exist"?Boolean(true):Boolean(false));
                  break;
               case "info_done":
                  //this.state = this.STATE_LOGIN;
                  //IStorageService(Main.osgi.getService(IStorageService)).getStorage().data.alreadyPlayedTanks = true;
                  //this.enter();
            }
         }
         else if(data.type == Type.AUTH)
         {
            switch(data.args[0])
            {
               case "accept":
                  this.objectUnloaded(this.clientObject);
                  CheckLoader(Main.osgi.getService(ILoader)).addProgress(230);
				  switch(data.args[1])
					{
					   case "admin":
						  var lobbyServices:Lobby_a = new Lobby_a();
						  Game.group = "admin";
						  var panel:PanelModel = new PanelModel();
						  Main.osgi.registerService(IPanel,panel);
						  Main.osgi.registerService(ILobby, lobbyServices);
						  lobbyServices.beforeAuth();
						  this.network.send("auth;go;");
						  break;
					   case "default":
						  var lobbyServices1:Lobby = new Lobby();
						  Game.group = "default";
						  var panel1:PanelModel = new PanelModel();
						  Main.osgi.registerService(IPanel,panel1);
						  Main.osgi.registerService(ILobby, lobbyServices1);
						  lobbyServices1.beforeAuth();
						  this.network.send("auth;go;");
						  break;
					   case "moderator":
						  var lobbyServices2:Lobby = new Lobby();
						  Game.group = "moderator";
						  var panel2:PanelModel = new PanelModel();
						  Main.osgi.registerService(IPanel,panel2);
						  Main.osgi.registerService(ILobby, lobbyServices2);
						  lobbyServices2.beforeAuth();
						  this.network.send("auth;go;");
						  break;
					   case "tester":
						  var lobbyServices3:Lobby = new Lobby();
						  Game.group = "tester";
						  var panel3:PanelModel = new PanelModel();
						  Main.osgi.registerService(IPanel,panel3);
						  Main.osgi.registerService(ILobby, lobbyServices3);
						  lobbyServices3.beforeAuth();
						  this.network.send("auth;go;");
					}
                  break;
               case "denied":
                  this.passwdLoginFailed(null);
                  break;
               case "not_exist":
                  this.passwdLoginFailed(null);
                  break;
               case "ban":
                  this.showBanWindow(data.args[1]);
            }
         }
      }
      
      public function changeEmailHashIsOk(clientObject:ClientObject, oldEmail:String) : void
      {
         this.changeEmailAndPasswordWindow = new ChangeEmailAndPasswordWindow();
         this.changeEmailAndPasswordWindow.email = oldEmail;
         this.changeEmailAndPasswordWindow.addEventListener(ChangePasswordAndEmailEvent.CHANGE_PRESSED,this.onChangePassAndEmailPressed);
         this.changeEmailAndPasswordWindow.addEventListener(ChangePasswordAndEmailEvent.CANCEL_PRESSED,this.onCancelPassAndEmailPressed);
         this.layer.addChild(this.changeEmailAndPasswordWindow);
         this.allignChangeEmailAndPasswordWindow(null);
         Main.stage.addEventListener(Event.RESIZE,this.allignChangeEmailAndPasswordWindow);
      }
      
      public function changeEmailHashIsWrong(clientObject:ClientObject) : void
      {
         var alert:Alert = new Alert();
         alert.showAlert(this.localeService.getText(TextConst.SETTINGS_CHANGE_PASSWORD_WRONG_LINK_TEXT),[AlertAnswer.OK]);
         this.layer.addChild(alert);
         alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onWrongChangePasswordAlertButtonPressed);
      }
      
      private function onWrongChangePasswordAlertButtonPressed(event:AlertEvent) : void
      {
         this.enter();
      }
      
      private function enter() : void
      {
         var loaderService:ILoaderWindowService = null;
         if(this.hash != null)
         {
            Main.writeVarsToConsoleChannel("USER MODEL","loginByHash: " + this.hash);
         }
         else
         {
            loaderService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
            loaderService.hideLoaderWindow();
            loaderService.lockLoaderWindow();
            if(this.inviteEnabled)
            {
               this.showInviteWindow();
            }
            else
            {
               this.afterInviteEnter();
            }
         }
      }
      
      private function afterInviteEnter() : void
      {
         var userName:String = null;
         var s:String = null;
		 loginForm.visible = true;
         this.checkCallsignTimer = new Timer(this.checkCallsignDelay,1);
         this.checkCallsignTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onCallsignCheckTimerComplete);
		 this.checkInvTimer = new Timer(this.checkCallsignDelay,1);
         this.checkInvTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onInvCheckTimerComplete);
		 var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         if (storage.data.ky == null)
		 {
			this.showWindow();
			//throw new Error("0");
		 }else{
			 //throw new Error("1");
			 loginForm.visible = false;
			 this.showWindow();
			 //this.loginForm.callSign = user;
			 //this.loginForm.checkPassword.password.value = storage1.data.ky;
			 //this.state = 0;
			 this.loginByName(storage.data.userName, storage.data.ky, storage.data.rememberUserFlag);
			 //throw new Error(storage.data.userName+"	"+storage1.data.ky+"	"+storage.data.rememberUserFlag);
		 }
         var VasyaWasHere:Boolean = storage.data.alreadyPlayedTanks;
         Main.writeVarsToConsoleChannel("USER MODEL","VasyaWasHere: %1",VasyaWasHere);
         if(VasyaWasHere)
         {
            this.state = this.STATE_LOGIN;
            this.loginForm.loginState = true;
            userName = storage.data.userName;
            Main.writeVarsToConsoleChannel("USER MODEL","userName: %1",userName);
            Main.writeVarsToConsoleChannel("USER MODEL","rememberUserFlag: %1",storage.data.rememberUserFlag);
            if(userName != null)
            {
               this.loginForm.callSign = userName;
            }
            if(storage.data.rememberUserFlag)
            {
               this.loginForm.remember = storage.data.rememberUserFlag;
            }
            s = this.loaderParamsService.params["user"];
            if(s != null)
            {
               this.loginForm.callSign = s;
            }
            s = this.loaderParamsService.params["password"];
            if(s != null)
            {
               this.loginForm.checkPassword.password.value = s;
            }
         }
         else
         {
            this.state = this.STATE_REGISTER;
            this.loginForm.loginState = false;
            if(this.addressService != null)
            {
               if(this.loaderParamsService.params["partner"] != null)
               {
                  this.addressService.setValue("registration/partner=" + this.loaderParamsService.params["partner"]);
               }
               else
               {
                  this.addressService.setValue("registration");
               }
            }
         }
      }
      
      private function onAlertButtonPressed(e:AlertEvent) : void
      {
      }
      
      public function confirmEmailStatus(clientObject:ClientObject, status:ConfirmEmailStatus) : void
      {
         switch(status)
         {
            case ConfirmEmailStatus.ERROR:
               this.enter();
               break;
            case ConfirmEmailStatus.OK:
               this.enter();
               break;
            case ConfirmEmailStatus.OK_EXISTS:
               this.goToPortal();
         }
      }
      
      private function goToPortal(e:AlertEvent = null) : void
      {
		  
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         var loaderService:ILoaderWindowService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         loaderService.unlockLoaderWindow();
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.alreadyPlayedTanks = true;
		 if (this.loginForm != null)
		 {
			 if(this.loginForm.callSign != null && this.loginForm.callSign != "")
			 {
				storage.data.userName = this.loginForm.callSign;
				storage.data.rememberUserFlag = this.loginForm.remember;
				if (this.loginForm.remember && storage.data.ky == null)
				{
					storage.data.ky = this.loginForm.checkPassword.password.value;
					storage.flush();
				}
				if(this.addressService != null)
				{
				   if(this.state == this.STATE_REGISTER)
				   {
					  if(this.loaderParamsService.params["partner"] != null)
					  {
						 this.addressService.setValue("registered/" + this.loginForm.callSign + "/partner=" + this.loaderParamsService.params["partner"]);
					  }
					  else
					  {
						 this.addressService.setValue("registered/" + this.loginForm.callSign);
					  }
				   }
				}
				this.loginForm.hide();
				this.hideWindow();
			 }
		 }
         if(this.checkCallsignTimer != null)
         {
            this.checkCallsignTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onCallsignCheckTimerComplete);
            this.checkCallsignTimer = null;
         }
		 if(this.checkInvTimer != null)
         {
            this.checkInvTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onInvCheckTimerComplete);
            this.checkInvTimer = null;
         }
         this.network.removeListener(this);
         this.loginForm = null;
         this.clientObject = null;
      }
      
      public function hashLoginFailed(clientObject:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","hashLoginFailed!");
         var loaderService:ILoaderWindowService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         loaderService.hideLoaderWindow();
         loaderService.lockLoaderWindow();
         if(this.inviteEnabled)
         {
            this.showInviteWindow();
         }
         else
         {
            this.afterInviteEnter();
         }
      }
      
      public function passwdLoginFailed(clientObject:ClientObject) : void
      {
		 var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
		 if (storage.data.ky == null)
		 {
			 Main.writeVarsToConsoleChannel("USER MODEL","passwdLoginFailed!");
			 this.showErrorWindow(Alert.ERROR_PASSWORD_INCORRECT);
			 this.loginForm.clearPassword();
			 this.loginForm.registerForm.playButton.enable = true;
			 this.loginForm.checkPassword.playButton.enable = true;
		 }else{
			 //throw new Error(""+"	"+storage.data.ky+"	"+"");
			storage.data.ky = null;
			storage.flush();
			afterInviteEnter();
		 }
      }
      
      public function registerStatus(clientObject:ClientObject, status:RegisterStatusEnum) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","registerStatus: " + status);
         switch(status)
         {
            case RegisterStatusEnum.EMAIL_LDAP_UNIQUE:
               this.showErrorWindow(Alert.ERROR_EMAIL_UNIQUE);
               break;
            case RegisterStatusEnum.EMAIL_NOT_VALID:
               this.showErrorWindow(Alert.ERROR_EMAIL_INVALID);
               break;
            case RegisterStatusEnum.UID_LDAP_UNIQUE:
               this.showErrorWindow(Alert.ERROR_CALLSIGN_UNIQUE);
         }
         this.loginForm.registerForm.playButton.enable = true;
         this.loginForm.checkPassword.playButton.enable = true;
      }
      
      public function setHash(clientObject:ClientObject, hash:String) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","setHash: " + hash);
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.userHash = hash;
         storage.data.alreadyPlayedTanks = true;
         var result:String = storage.flush();
         Main.writeVarsToConsoleChannel("USER MODEL","setHash result: " + result);
      }
      
      public function restorePasswordStatus(clientObject:ClientObject, status:RestorePasswordStatusEnum) : void
      {
         var linkSended:Alert = null;
         switch(status)
         {
            case RestorePasswordStatusEnum.OK:
               Main.writeVarsToConsoleChannel("USER MODEL","restorePasswordStatus: OK");
               this.loginForm.hideRestoreForm();
               this.state = this.STATE_LOGIN;
               linkSended = new Alert(Alert.ALERT_RECOVERY_LINK_SENDED);
               this.layer.addChild(linkSended);
               break;
            case RestorePasswordStatusEnum.MAIL_NOT_FOUND:
               Main.writeVarsToConsoleChannel("USER MODEL","restorePasswordStatus: MAIL_NOT_FOUND");
               this.loginForm.invalidRestoreForm();
               this.showErrorWindow(Alert.ERROR_EMAIL_NOTFOUND);
               break;
            case RestorePasswordStatusEnum.MAIL_NOT_SEND:
               Main.writeVarsToConsoleChannel("USER MODEL","restorePasswordStatus: MAIL_NOT_SEND");
               this.loginForm.hideRestoreForm();
               this.showErrorWindow(Alert.ERROR_EMAIL_NOTSENDED);
         }
      }
      
      public function setLicenseText(clientObject:ClientObject, string:String) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","setLicenseText: " + string);
         var tv:ViewText = new ViewText();
         this.layer.addChild(tv);
         tv.text = string;
      }
      
      public function setRulesText(clientObject:ClientObject, rules:String) : void
      {
         var tv:ViewText = new ViewText();
         this.layer.addChild(tv);
         tv.text = rules;
      }
      
      public function inviteFree(clientObject:ClientObject) : void
      {
         this.hideInviteWindow();
         this.afterInviteEnter();
      }
      
      public function inviteAlreadyActivated(clientObject:ClientObject, user:String) : void
      {
         this.hideInviteWindow();
		 var pas:String = new String("");
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
		 //if (storage1.data.ky == null)
		 //{
			//this.showWindow();
			//throw new Error("");
		 //}else{
			 //throw new Error("");
			 this.loginForm.callSign = user;
			 this.loginForm.checkPassword.password.value = storage.data.ky;
		 //}
         this.state = this.STATE_LOGIN;
         this.loginForm.loginState = true;
         this.loginForm.callSign = user;
         //this.loginForm.checkPassword.registerButton.enable = false;
         if(storage.data.rememberUserFlag)
         {
            this.loginForm.remember = storage.data.rememberUserFlag;
         }
      }
      
      public function inviteNotFound(clientObject:ClientObject) : void
      {
         this.inviteWindow.showInviteError();
      }
      
      public function nameUnique(clientObject:ClientObject, result:Boolean) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","nameUnique result: %1",result);
         this.loginForm.registerForm.callSignState = result?int(RegisterForm.CALLSIGN_STATE_VALID):int(RegisterForm.CALLSIGN_STATE_INVALID);
         this.isUnique = result;
      }
	  
	  public function inv(result:Boolean) : void
      {
         this.loginForm.registerForm.inState = result?int(RegisterForm.CALLSIGN_STATE_VALID):int(RegisterForm.CALLSIGN_STATE_INVALID);
		 this.loginForm.registerForm.invite.validValue = result;
		 this.loginForm.registerForm.switchPlayButton(null);
      }
      
      private function showWindow() : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","showWindow");
         if(!this.layer.contains(this.loginForm))
         {
            this.layer.addChild(this.loginForm);
         }
         this.loginForm.addEventListener(LoginFormEvent.SHOW_TERMS,this.onShowTermsPressed);
         this.loginForm.addEventListener(LoginFormEvent.SHOW_RULES,this.onShowRulesPressed);
         this.loginForm.addEventListener(LoginFormEvent.CHANGE_STATE,this.onStateChanged);
         this.loginForm.addEventListener(LoginFormEvent.RESTORE_PRESSED,this.onLoginRestore);
         this.loginForm.checkPassword.restoreLink.addEventListener(MouseEvent.CLICK,this.onRestoreClick);
         this.loginForm.addEventListener(LoginFormEvent.PLAY_PRESSED,this.onPlayPressed);
         Main.writeVarsToConsoleChannel("USER MODEL","   callSign.addEventListener(LoginFormEvent.TEXT_CHANGED)");
         this.loginForm.registerForm.callSign.addEventListener(LoginFormEvent.TEXT_CHANGED, this.onCallsignChanged);
		 this.loginForm.registerForm.invite.addEventListener(LoginFormEvent.TEXT_CHANGED,this.onInvChanged);
      }
      
      private function hideWindow() : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","hideWindow");
         if(this.layer.contains(this.loginForm))
         {
            this.layer.removeChild(this.loginForm);
         }
         this.loginForm.removeEventListener(LoginFormEvent.SHOW_TERMS,this.onShowTermsPressed);
         this.loginForm.removeEventListener(LoginFormEvent.SHOW_RULES,this.onShowRulesPressed);
         this.loginForm.removeEventListener(LoginFormEvent.CHANGE_STATE,this.onStateChanged);
         this.loginForm.removeEventListener(LoginFormEvent.RESTORE_PRESSED,this.onLoginRestore);
         this.loginForm.checkPassword.restoreLink.removeEventListener(MouseEvent.CLICK,this.onRestoreClick);
         this.loginForm.removeEventListener(LoginFormEvent.PLAY_PRESSED,this.onPlayPressed);
         Main.writeVarsToConsoleChannel("USER MODEL","   callSign.removeEventListener(LoginFormEvent.TEXT_CHANGED)");
         this.loginForm.registerForm.callSign.removeEventListener(LoginFormEvent.TEXT_CHANGED, this.onCallsignChanged);
		 this.loginForm.registerForm.invite.removeEventListener(LoginFormEvent.TEXT_CHANGED,this.onInvChanged);
      }
	  
	  private function onInvChanged(e:LoginFormEvent) : void
      {
         this.checkInvTimer.reset();
         this.checkInvTimer.start();
      }
      
      private function onInvCheckTimerComplete(e:TimerEvent) : void
      {
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])?$/i;
         var result:Array = this.loginForm.registerForm.invite.value.match(pattern);
         if(result != null)
         {
            this.loginForm.registerForm.inState = RegisterForm.CALLSIGN_STATE_PROGRESS;
            this.network.send("registration;invite_check;" + this.loginForm.registerForm.invite.value);
         }
         else
         {
            this.loginForm.registerForm.inState = RegisterForm.CALLSIGN_STATE_INVALID;
         }
      }
      
      private function onCallsignChanged(e:LoginFormEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onCallsignChanged");
         this.checkCallsignTimer.reset();
         this.checkCallsignTimer.start();
      }
      
      private function onCallsignCheckTimerComplete(e:TimerEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onCallsignCheckTimerComplete");
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])?$/i;
         var result:Array = this.loginForm.registerForm.callSign.value.match(pattern);
         if(result != null)
         {
            this.loginForm.registerForm.callSignState = RegisterForm.CALLSIGN_STATE_PROGRESS;
            this.network.send("registration;check_name;" + this.loginForm.registerForm.callSign.value);
         }
         else
         {
            this.loginForm.registerForm.callSignState = RegisterForm.CALLSIGN_STATE_INVALID;
         }
      }
      
      private function showErrorWindow(alertType:int) : void
      {
         this.errorWindow = new Alert(alertType);
         if(!this.layer.contains(this.errorWindow))
         {
            Main.dialogsLayer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
      
      private function showBanWindow(reason:String) : void
      {
         this.errorWindow = new Alert(Alert.ERROR_BAN);
         this.errorWindow._msg = reason;
         if(!this.layer.contains(this.errorWindow))
         {
            this.layer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
      
      private function showInviteWindow() : void
      {
         if(!this.layer.contains(this.inviteWindow))
         {
            this.layer.addChild(this.inviteWindow);
            this.alignInviteWindow();
            Main.stage.addEventListener(Event.RESIZE,this.alignInviteWindow);
            this.inviteWindow.addEventListener(Event.COMPLETE,this.onInviteWindowComplete);
         }
      }
      
      private function hideInviteWindow() : void
      {
         if(this.layer.contains(this.inviteWindow))
         {
            this.layer.removeChild(this.inviteWindow);
            Main.stage.removeEventListener(Event.RESIZE,this.alignInviteWindow);
            this.inviteWindow.removeEventListener(Event.COMPLETE,this.onInviteWindowComplete);
         }
      }
      
      private function alignInviteWindow(e:Event = null) : void
      {
         this.inviteWindow.x = Math.round((Main.stage.stageWidth - this.inviteWindow.width) * 0.5);
         this.inviteWindow.y = Math.round((Main.stage.stageHeight - this.inviteWindow.height) * 0.5);
      }
      
      private function onInviteWindowComplete(e:Event) : void
      {
      }
      
      private function onPlayPressed(e:LoginFormEvent) : void
      {
         var domen:String = null;
         var referalHash:String = null;
         switch(this.state)
         {
            case this.STATE_LOGIN:
               Main.writeVarsToConsoleChannel("USER MODEL","onPlayPressed STATE_LOGIN");
               Main.writeVarsToConsoleChannel("USER MODEL","   callSign: " + this.loginForm.callSign);
               Main.writeVarsToConsoleChannel("USER MODEL","   mainPassword: " + this.loginForm.mainPassword);
               this.loginByName(this.loginForm.callSign,this.loginForm.mainPassword,this.loginForm.remember);
               break;
            case this.STATE_REGISTER:
               Main.writeVarsToConsoleChannel("USER MODEL","onPlayPressed STATE_REGISTER");
               if(this.loginForm.callSign.length >= 2)
               {
                  if(this.not1stSimbols.indexOf(this.loginForm.callSign.charAt(0)) != -1)
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_FIRST_SYMBOL);
                  }
                  else if(this.loginForm.callSign.indexOf("__") != -1 || this.loginForm.callSign.indexOf("--") != -1 || this.loginForm.callSign.indexOf("..") != -1)
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_DEVIDE);
                  }
                  else if(this.not1stSimbols.indexOf(this.loginForm.callSign.charAt(this.loginForm.callSign.length - 1)) != -1)
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_LAST_SYMBOL);
                  }
                  else if(this.loginForm.pass1.length < 2)
                  {
                     this.showErrorWindow(Alert.ERROR_PASSWORD_LENGTH);
                  }
                  else if(this.isUnique)
                  {
                     domen = this.addressService != null?this.addressService.getBaseURL():"";
                     referalHash = this.params != null?this.params["friend"]:"";
                     this.registerUser(this.loginForm.callSign,this.loginForm.pass1,this.loginForm.registerForm.invite.textField.text,this.loginForm.remember,false,referalHash);
                  }
                  else
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_UNIQUE);
                  }
               }
               else
               {
                  this.showErrorWindow(Alert.ERROR_CALLSIGN_LENGTH);
               }
         }
      }
      
      private function loginByName(login:String, password:String, remember:Boolean) : void
      {
		 Game.log = login;
         var userInfo:String = login + ";" + password + ";" + remember.toString();
         this.network.send("auth;log;" + userInfo);
      }
      
      private function registerUser(name:String, password:String, email:String, remember:Boolean, sentNews:Boolean, referalHash:String) : void
      {
         var userInfo:String = name + ";" + password + ";" + email + ";" + remember.toString() + ";";
         this.network.send("registration;reg;" + userInfo);
      }
      
      private function onStateChanged(e:LoginFormEvent) : void
      {
         if(this.loginForm.loginState)
         {
            this.state = this.STATE_LOGIN;
            if(this.addressService != null)
            {
            }
         }
         else
         {
            this.state = this.STATE_REGISTER;
            if(this.addressService != null)
            {
               if(this.loaderParamsService.params["partner"] != null)
               {
                  this.addressService.setValue("registration/partner=" + this.loaderParamsService.params["partner"]);
               }
               else
               {
                  this.addressService.setValue("registration");
               }
            }
         }
         Main.writeVarsToConsoleChannel("USER MODEL","onStateChanged: " + this.state);
      }
      
      private function onShowTermsPressed(e:LoginFormEvent) : void
      {
      }
      
      private function onShowRulesPressed(e:LoginFormEvent) : void
      {
      }
      
      private function onRestoreClick(e:MouseEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onRestoreClick");
         this.state = this.STATE_RESTORE_PASSWORD;
         this.loginForm.showRestoreForm();
      }
      
      private function onLoginRestore(e:LoginFormEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onLoginRestore");
         Main.writeVarsToConsoleChannel("USER MODEL","restoreEmail: " + this.loginForm.restoreEmail);
      }
      
      private function onCancelPassAndEmailPressed(event:ChangePasswordAndEmailEvent) : void
      {
         this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CANCEL_PRESSED,this.onCancelPassAndEmailPressed);
         this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CHANGE_PRESSED,this.onChangePassAndEmailPressed);
         this.layer.removeChild(this.changeEmailAndPasswordWindow);
         this.enter();
      }
      
      private function onChangePassAndEmailPressed(event:ChangePasswordAndEmailEvent) : void
      {
         if(this.emailChangeHash != null)
         {
         }
      }
      
      private function allignChangeEmailAndPasswordWindow(event:Event) : void
      {
         this.changeEmailAndPasswordWindow.x = Math.round((Main.stage.stageWidth - this.changeEmailAndPasswordWindow.width) * 0.5);
         this.changeEmailAndPasswordWindow.y = Math.round((Main.stage.stageHeight - this.changeEmailAndPasswordWindow.height) * 0.5);
      }
      
      public function setPasswordChangeResult(clientObject:ClientObject, result:Boolean, text:String) : void
      {
         var passChangeAlert:Alert = null;
         var passChangeFailureAlert:Alert = null;
         if(result == true)
         {
            if(this.layer.contains(this.changeEmailAndPasswordWindow))
            {
               this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CANCEL_PRESSED,this.onCancelPassAndEmailPressed);
               this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CHANGE_PRESSED,this.onChangePassAndEmailPressed);
               this.layer.removeChild(this.changeEmailAndPasswordWindow);
               passChangeAlert = new Alert();
               passChangeAlert.showAlert(text,[AlertAnswer.OK]);
               this.layer.addChild(passChangeAlert);
               passChangeAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onChangePasswordAndEmailAlertPressed);
            }
         }
         else
         {
            passChangeFailureAlert = new Alert();
            passChangeFailureAlert.showAlert(text,[AlertAnswer.OK]);
            this.layer.addChild(passChangeFailureAlert);
         }
      }
      
      private function onChangePasswordAndEmailAlertPressed(e:Event) : void
      {
         this.enter();
      }
      
      public function serverIsRestarting(clientObject:ClientObject) : void
      {
         this.errorWindow = new Alert();
         this.errorWindow.showAlert(this.localeService.getText(TextConst.SERVER_IS_RESTARTING_LOGIN_TEXT),[AlertAnswer.OK]);
         if(!Main.noticesLayer.contains(this.errorWindow))
         {
            Main.noticesLayer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
      
      public function youWereKicked(clientObject:ClientObject) : void
      {
         this.errorWindow = new Alert();
         this.errorWindow.showAlert("Вас кикнули",[AlertAnswer.OK]);
         if(!Main.noticesLayer.contains(this.errorWindow))
         {
            Main.noticesLayer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
   }
}
