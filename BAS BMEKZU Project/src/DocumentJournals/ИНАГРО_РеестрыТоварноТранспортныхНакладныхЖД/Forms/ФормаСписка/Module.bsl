#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
		
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
	ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД");

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Тип", ДокументСсылка, ВидСравненияКомпоновкиДанных.Равно);
	
	УправлениеФормой(ЭтаФорма);
	
	ПолучитьИтогиНаСервере();

	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	ИначеЕсли ИмяСобытия = "СозданРеестрТТНВвозЖД"
		  ИЛИ ИмяСобытия = "СозданРеестрТТНВывозЖД" Тогда
		Элементы.Список.Обновить();		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	Если ДокументСсылка      = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД") Тогда
		Документ = "ИНАГРО_РеестрТТНВвозЖД";
	ИначеЕсли ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВывозЖД") Тогда
		Документ = "ИНАГРО_РеестрТТНВывозЖД";
	КонецЕсли;

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы();
	ОткрытьФорму("Документ." + Документ + ".Форма.ФормаДокумента", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура РеестрТТНВвозЖД(Команда)
	
	ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Тип", ДокументСсылка, ВидСравненияКомпоновкиДанных.Равно);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура РеестрТТНВывозЖД(Команда)
	
	ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВывозЖД");	
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Тип", ДокументСсылка, ВидСравненияКомпоновкиДанных.Равно);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьРеестрыТТН(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД") Тогда
		ПараметрыФормы.Вставить("Реестр", "РеестрТТНВвозЖД");	
	ИначеЕсли ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВывозЖД") Тогда
		ПараметрыФормы.Вставить("Реестр", "РеестрТТНВывозЖД");	
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ИНАГРО_ФормированиеРеестровТТН.Форма.Форма", ПараметрыФормы, ЭтаФорма, Новый УникальныйИдентификатор(), , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИтоги(Команда)
	
	ПолучитьИтогиНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПолучитьИтогиНаСервере()
	
	СхемаКомпоновкиДанных        = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    Настройки                    = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	ЭлементОтбора                = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Проведен");
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование  = Истина;

	КомпоновщикМакета            = Новый КомпоновщикМакетаКомпоновкиДанных;
    МакетКомпоновкиДанных        = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных    = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода              = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    Результат                    = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ФизическийВес                = Результат.Итог("СсылкаФизическийВес");
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаДокументы.Заголовок = УстановитьЗаголовок(Форма);
	
	Элементы.РеестрТТНВвозЖД.Доступность  = НЕ Форма.ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД");
	Элементы.РеестрТТНВывозЖД.Доступность = НЕ Форма.ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВывозЖД");
	
	Элементы.СкладскаяКвитанция.Видимость = Форма.ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД");
			
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УстановитьЗаголовок(Форма)
	
	Если Форма.ДокументСсылка      = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВвозЖД") Тогда
		ТекстЗаголовка = НСтр("ru='Реестры товарно-транспортных накладных (железнодорожных) (ввоз)';uk='Реєстри товарно-транспортних накладних (залізничних) (ввезення)'");	
	ИначеЕсли Форма.ДокументСсылка = Тип("ДокументСсылка.ИНАГРО_РеестрТТНВывозЖД") Тогда
		ТекстЗаголовка = НСтр("ru='Реестры товарно-транспортных накладных (железнодорожных) (вывоз)';uk='Реєстри товарно-транспортних накладних (залізничних) (вивезення)'");
	КонецЕсли;
	
	Возврат ТекстЗаголовка;

КонецФункции

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы()

	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
		
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Команда.Имя = "ПодменюПечатьОбычное_Реестр" Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

