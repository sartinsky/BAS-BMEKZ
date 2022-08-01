////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаСервере
Процедура ПриИзмененииПодразделенияСервер()

	Если НЕ ОсновноеПодразделение.Пустая() Тогда
		ОрганизацияПодразделения = БухгалтерскийУчетПереопределяемый.ОрганизацияПодразделения(ОсновноеПодразделение);
		Если ЗначениеЗаполнено(ОрганизацияПодразделения) 
			И ОрганизацияПодразделения <> ОсновнаяОрганизация Тогда
			ОсновнаяОрганизация = ОрганизацияПодразделения;
			ОсновноеОбособленноеПодразделениеОрганизации = Неопределено;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОсновноеПодразделениеПриИзменении(Элемент)

	ПриИзмененииПодразделенияСервер();

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОбособленноеПодразделенияСервер()

	Если НЕ ОсновноеОбособленноеПодразделениеОрганизации.Пустая() Тогда
		ОрганизацияОбособленногоПодразделения = БухгалтерскийУчетПереопределяемый.ОрганизацияПодразделения(ОсновноеОбособленноеПодразделениеОрганизации);
		Если ЗначениеЗаполнено(ОрганизацияОбособленногоПодразделения) 
			И ОрганизацияОбособленногоПодразделения <> ОсновнаяОрганизация Тогда
			ОсновнаяОрганизация = ОрганизацияОбособленногоПодразделения;
			ОсновноеПодразделениеОрганизации = Неопределено;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОсновноеОбособленноеПодразделениеОрганизацииПриИзменении(Элемент)
	
	ПриИзмененииОбособленноеПодразделенияСервер();
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ЗаписатьДанные();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные()
	
	СохранитьНастройкиСервер();
	
	Если ТекущаяОрганизация <> ОсновнаяОрганизация Тогда
		Оповестить("ИзменениеОсновнойОрганизации", ОсновнаяОрганизация);
	КонецЕсли;
	
	Если ТекущееПодразделение <> ОсновноеПодразделение Тогда
		Оповестить("ИзменениеОсновногоПодразделенияОрганизации", ОсновноеПодразделение);
	КонецЕсли;
	
	Если ТекущееОбособленноеПодразделениеОрганизации <> ОсновноеОбособленноеПодразделениеОрганизации Тогда
		Оповестить("ИзменениеОсновноеОбособленноеПодразделениеОрганизации", ОсновноеОбособленноеПодразделениеОрганизации);
	КонецЕсли;
	
	Если ТекущийКтоВыписалНалоговуюНакладную <> КтоВыписалНалоговуюНакладную Тогда
		Оповестить("ИзменениеКтоВыписалНалоговуюНакладную", КтоВыписалНалоговуюНакладную);
	КонецЕсли;
	
	Если ТекущаяНоменклатураДляЗаполненияНалоговыхНакладных <> НоменклатураДляЗаполненияНалоговыхНакладных Тогда
		Оповестить("ИзменениеНоменклатураДляЗаполненияНалоговыхНакладных", НоменклатураДляЗаполненияНалоговыхНакладных);
	КонецЕсли;
	
	Если ТекущийСклад <> ОсновнойСклад Тогда
		Оповестить("ИзменениеОсновногоСклада", ОсновнойСклад);
	КонецЕсли;
	
	Если ТекущееМестоСоставленияДокумента <> ОсновноеМестоСоставленияДокумента Тогда
		Оповестить("ИзменениеОсновногоМестаСоставленияДокумента", ОсновноеМестоСоставленияДокумента);
	КонецЕсли;
	
	Если ТекущийПредставительОрганизации <> ОсновнойПредставительОрганизации Тогда
		Оповестить("ИзменениеОсновногоПредставительОрганизации", ОсновнойПредставительОрганизации);
	КонецЕсли;

	МассивСтруктур = Новый Массив;
	
	// БазоваяФункциональность
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "ОбщиеНастройкиПользователя",
	    "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
	    ЗапрашиватьПодтверждениеПриЗавершенииПрограммы));
	// Конец БазоваяФункциональность
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Форма.Элементы.ЗначениеРабочейДаты.Доступность = Форма.ИспользоватьТекущуюДатуКомпьютера = 1;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ
//

&НаСервере
Процедура СохранитьНастройкиСервер()

	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновнаяОрганизация",              ОсновнаяОрганизация);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации", ОсновноеПодразделение);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновноеОбособленноеПодразделениеОрганизации", ОсновноеОбособленноеПодразделениеОрганизации);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("КтоВыписалНалоговуюНакладную", КтоВыписалНалоговуюНакладную);
	
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("НоменклатураДляЗаполненияНалоговыхНакладных", НоменклатураДляЗаполненияНалоговыхНакладных);
	
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновнойСклад",                    ОсновнойСклад);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновноеМестоСоставленияДокумента", ОсновноеМестоСоставленияДокумента);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновнойПредставительОрганизации",  ОсновнойПредставительОрганизации);
	
	Если ИспользоватьТекущуюДатуКомпьютера = 0 Тогда
		ЗначениеРабочейДатыДляСохранения  = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения  = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);	

	//ВариантМасштабаФорм
	НастройкиКлиентскогоПриложения = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Общее/НастройкиКлиентскогоПриложения", "");
	Если ПустаяСтрока(ВариантМасштабаФорм) Тогда 
		ВариантМасштабаФорм = "Авто";
	КонецЕсли;
	
	Если НастройкиКлиентскогоПриложения <> Неопределено Тогда 
		НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения   = ВариантМасштабаФормКлиентскогоПриложения[ВариантМасштабаФорм];
	Иначе 
		НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
		НастройкиКлиентскогоПриложения.ВариантИнтерфейсаКлиентскогоПриложения 	= ВариантИнтерфейсаКлиентскогоПриложения.Такси;
		НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения[ВариантМасштабаФорм];
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(
		"Общее/НастройкиКлиентскогоПриложения",
		"",
		НастройкиКлиентскогоПриложения);
	//ВариантМасштабаФорм
	
	
	Модифицированность = Ложь;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОсновнаяОрганизация		= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	ОсновноеПодразделение	= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");
	ОсновноеОбособленноеПодразделениеОрганизации	= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеОбособленноеПодразделениеОрганизации");
	КтоВыписалНалоговуюНакладную	= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("КтоВыписалНалоговуюНакладную");
	НоменклатураДляЗаполненияНалоговыхНакладных = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("НоменклатураДляЗаполненияНалоговыхНакладных");
	
	ОсновнойСклад			= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад");
	ОсновноеМестоСоставленияДокумента = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеМестоСоставленияДокумента");
	ОсновнойПредставительОрганизации  = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойПредставительОрганизации");
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	ЗначениеРабочейДаты		= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата");
	
	ТекущаяОрганизация		= ОсновнаяОрганизация;
	ТекущееПодразделение	= ОсновноеПодразделение;
	ТекущийСклад			= ОсновнойСклад;
	ТекущийМестоСоставленияДокумента = ОсновноеМестоСоставленияДокумента;
	ТекущийПредставительОрганизации  = ОсновнойПредставительОрганизации;

    ТекущееОбособленноеПодразделениеОрганизации = ОсновноеОбособленноеПодразделениеОрганизации;
	ТекущийКтоВыписалНалоговуюНакладную = КтоВыписалНалоговуюНакладную;
	ТекущаяНоменклатураДляЗаполненияНалоговыхНакладных = НоменклатураДляЗаполненияНалоговыхНакладных;

	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 1;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 0;
		ЗначениеРабочейДаты = '0001-01-01';
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

	ПоказыватьПредупреждениеОбИзменениях = Истина;
	Если НЕ Параметры.Свойство("ПоказыватьПредупреждениеОбИзменениях", ПоказыватьПредупреждениеОбИзменениях) Тогда
		ПоказыватьПредупреждениеОбИзменениях = Истина;
	КонецЕсли;
	
	НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДата", 
		ПоказыватьПредупреждениеОбИзменениях);

	//ВариантМасштабаФорм
	Элементы.ВариантМасштабаФорм.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	НастройкиКлиентскогоПриложения = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить("Общее/НастройкиКлиентскогоПриложения", "");

	Если НастройкиКлиентскогоПриложения = Неопределено Тогда 
		ВариантМасштабаФорм   = "Авто";
	ИначеЕсли НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения.Авто Тогда
		ВариантМасштабаФорм   = "Авто";
	ИначеЕсли НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения.Компактный Тогда
		ВариантМасштабаФорм   = "Компактный";
	ИначеЕсли НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения.Обычный Тогда
		ВариантМасштабаФорм   = "Обычный";
	КонецЕсли;
	//ВариантМасштабаФорм
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	// Конец СтандартныеПодсистемы.Пользователи	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// Чтобы при режиме работы "В закладках" форма предупреждения открывалась поверх формы
	// персональных настроек, открываем ее с небольшой задержкой.
	ПодключитьОбработчикОжидания("ПоказатьПредупреждениеПриОткрытииОбработчикОжидания", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеПриОткрытииОбработчикОжидания()

	ОбщегоНазначенияБПКлиент.ПоказатьПредупреждениеОбИзменениях("РабочаяДата", , НастройкиПредупреждений);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьДанные();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ
//

&НаКлиенте
Процедура АвторизованныйПользовательНажатие(Элемент, СтандартнаяОбработка)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры


&НаКлиенте
Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если ИспользоватьТекущуюДатуКомпьютера = 0 Тогда
		ЗначениеРабочейДаты = '0001-01-01';
	ИначеЕсли ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДаты = ТекущаяДата();
	КонецЕсли;
	Модифицированность = Истина;

КонецПроцедуры
