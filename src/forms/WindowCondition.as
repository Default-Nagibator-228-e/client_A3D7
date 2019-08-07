package forms 
{
	import controls.ColorButton;
	import controls.Label;
	import controls.TankWindow;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author LockOn
	 */
	public class WindowCondition extends Sprite
	{
		private var _stage:Stage;
		private var b:TankWindow = new TankWindow(400, 500);
		private var d:Array = [
			"Краткие правила\n\nВ игре запрещено:\n- боты, использовать стороннее ПО и баги;\n- выдавать себя за Администрацию;\n- прокачка, учинение помех другим игрокам;\n- реклама, политическая агитация;\n- нарушение законодательства, в т.ч. о \nправе интеллектуальной собственности;\n- размещение вредоносной информации;\n- продажа и передача аккаунтов;\n- публичное обсуждение модерации, а также действий \nадминистрации проекта\n- фрод;\n\nВ чате и на форуме запрещено:\n- оскорбления, угрозы;\n- мат, в том числе завуалированный;\n- флуд, флейм, спам, печать заглавными буквами (CAPS \nLOCK);\n- выманивание паролей;\n- троллинг;\n- подстрекательство других к нарушению правил;\n- публичное обсуждение модерации, а также действий \nадминистрации проекта.",
			"Лицензионное соглашение с пользователем. \n\nЛюбое пользование Игрой и ее отдельными \nобъектами, означает, что вы ознакомлены и согласны \nс нижеизложенным соглашением, и безоговорочно \nпринимаете все его условия. \n\nЕсли вы не согласны с данным соглашением, у вас нет \nправа на дальнейшее пользование Игрой и ее \nсервисами, и вы обязаны немедленно покинуть сайт. \n\nОсновные термины и понятия: \n\nАдминистрация – лица, действующие от имени и в \nинтересах Правообладателя и обеспечивающие \nфункционирование Игры; \n\nИгра – интерактивная многопользовательская онлайн \nигра «Танки Онлайн», в том числе ее компоненты, как \nотдельно, так и в совокупности, вся совокупность \nМатериалов, изображений, звуков, программ для \nЭВМ, веб-ресурсов, расположенных на Сайте; \n\nМатериалы – различного рода объекты в форме \nтекстов, рисунков, изображений, звуков, программ, "
		];
		private var e:Label = new Label();
		private var f:ColorButton = new ColorButton();
		
		public function WindowCondition(a:Stage, c:int):void
		{
			_stage = a;
			_stage.addEventListener(Event.RESIZE, draw);
			
			e.y = 30;
			e.x = 35;
			e.defaultTextFormat = new TextFormat("MyriadPro", 13);
			e.htmlText = d[c];
			
			f.x = 148;
			f.y = 435;
			f.setStyle("def");
			f.label = "OK";
			f.addEventListener(MouseEvent.ROLL_OVER, function(e:Event):void {
				Mouse.cursor = MouseCursor.BUTTON;
			});
			f.addEventListener(MouseEvent.ROLL_OUT, function(e:Event):void {
				Mouse.cursor = MouseCursor.ARROW;
			});
			f.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				removeChild(b);
			});
			
			addChild(b);
			b.addChild(e);
			b.addChild(f);
			
			draw();
		}
		
		private function draw(e:Event = null):void {
			b.x = int((_stage.stageWidth - b.width) / 2);
			b.y = int((_stage.stageHeight - b.height) / 2);
		}
		
	}

}