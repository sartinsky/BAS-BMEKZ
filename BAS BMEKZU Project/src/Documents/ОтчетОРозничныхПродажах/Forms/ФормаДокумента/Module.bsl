////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЗначениеКопирования = Параметры.ЗначениеКопирования;
	ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	Основание           = Параметры.Основание;
	
	Параметры.ЗначениеКопирования = Неопределено;
	Параметры.ЗначенияЗаполнения  = Неопределено;
	Параметры.Основание           = Неопределено;
	
	ФормыДокумента = Новый ФиксированноеСоответствие(
		Документы.ОтчетОРозничныхПродажах.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОпераций = ПолучитьСписокВидовОпераций();
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(Объект.ВидОперации);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций()

	СписокВидовОпераций = Новый СписокЗначений;
	
	ЗначенияПеречисления = Метаданные.Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ЗначенияПеречисления;
	Для Каждого ЗначениеПеречисления Из ЗначенияПеречисления Цикл
		ТекущийВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах[ЗначениеПеречисления.Имя];
		СписокВидовОпераций.Добавить(ТекущийВидОперации, Строка(ТекущийВидОперации));
	КонецЦикла;
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	ЗначенияЗаполнения.Вставить("ВидОперации", ВыбранныйВидОперации);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Параметры.Ключ);
	СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	СтруктураПараметров.Вставить("Основание",           Основание);
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> Объект.ВидОперации Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации", ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОткрытьФорму("Документ.ОтчетОРозничныхПродажах.Форма." + ФормыДокумента[ВыбранныйВидОперации], СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры
