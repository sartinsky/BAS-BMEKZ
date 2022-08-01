#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокВидовОперацийСРасшифровкойПлатежа() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРКО.ОплатаПоставщику);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийРКО.РасчетыПоКредитамИЗаймамСКонтрагентами);
	
	Возврат(СписокОпераций);
	
КонецФункции

Функция ЕстьРасшифровкаПлатежа(ВидОперации) Экспорт
	
	СписокВидовСРасшифровкойПлатежа = ПолучитьСписокВидовОперацийСРасшифровкойПлатежа();
	
	Возврат СписокВидовСРасшифровкойПлатежа.НайтиПоЗначению(ВидОперации) <> Неопределено;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Расходный кассовый ордер (КО-2)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РКО";
	КомандаПечати.Представление = НСтр("ru='Расходный кассовый ордер';uk='Видатковий касовий ордер'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Расходный кассовый ордер""';uk='Реєстр документів ""Видатковий касовий ордер""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьРКО(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Ссылка,
	|	Номер,
	|	Дата                          КАК ДатаДокумента,
	|	Организация,
	|	ВидОперации,
	|	СчетКасса,
	|	ОбособленноеПодразделениеОрганизации,
	|	ОбособленноеПодразделениеОрганизации.НаименованиеПолное КАК ОбособленноеПодразделениеОрганизацииПредставление,
	|	СуммаДокумента                КАК Сумма,
	|	Контрагент,
	|	Контрагент.Представление      КАК ФИОПолучателя,
	|	ВалютаДокумента               КАК Валюта,
	|	ВалютаДокумента.Представление КАК ВалютаПредставление,
	|	Выдать,
	|	Приложение,
	|	ПоДокументу,
	|	Основание,
	|	НомерОрдера
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|
	|ГДЕ
	|	РасходныйКассовыйОрдер.Ссылка В(&МассивОбъектов)";

	Шапка = Запрос.Выполнить().Выбрать();
	ПервыйДокумент = Истина;
	
	ТабДокумент   = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасходныйКассовыйОрдер_КО2";
	
	Пока Шапка.Следующий() Цикл

		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Вариант2018 = Истина;
		Если Шапка.ДатаДокумента >= Дата('20180105') Тогда
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_КО2_2018");
		Иначе
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_КО2");
			Вариант2018 = Ложь;
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		КодЯзыкаПечать = "uk";
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
		
		// Выводим шапку накладной
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		Если Вариант2018 Тогда
			ПредставлениеДаты = Формат(Шапка.ДатаДокумента, "Л=uk_UA; ДЛФ=DD");
			ПредставлениеДаты = Сред(ПредставлениеДаты, 1, СтрДлина(ПредставлениеДаты) - 2) + "року";
			ОбластьМакета.Параметры.ДатаДокументаШапка = ПредставлениеДаты;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Шапка.ОбособленноеПодразделениеОрганизации) Тогда
			ОбластьМакета.Параметры.ПолноеНаименование 	= СведенияОбОрганизации.ПолноеНаименование;
		Иначе
			ОбластьМакета.Параметры.ПолноеНаименование = Шапка.ОбособленноеПодразделениеОрганизацииПредставление;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Сумма             	= ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.Сумма, Шапка.Валюта);
		
		Если Вариант2018 И (Шапка.ВидОперации = Перечисления.ВидыОперацийРКО.ВзносНаличнымиВБанк
			Или Шапка.ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыПоВедомостям
//++ БУ ЗИК
//~			Или Шапка.ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗарплатыРаздатчиком
//-- БУ ЗИК			
			Или Шапка.ВидОперации = Перечисления.ВидыОперацийРКО.ИнкассацияДенежныхСредств) Тогда 
			ОбластьМакета.Параметры.СуммаПрописью = ?(Шапка.Валюта = ВалютаРегламентированногоУчета, "грн      коп.", "");
			ОбластьМакета.Область("R15C2:R15C8").ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
		Иначе
			ОбластьМакета.Параметры.СуммаПрописью = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.Сумма, Шапка.Валюта, КодЯзыкаПечать);
		КонецЕсли;
		
		
		Если Шапка.Валюта = ВалютаРегламентированногоУчета Тогда
			ОбластьМакета.Параметры.СуммаПрописьюПолучил = ?(Вариант2018, "грн      коп.", "грн.      коп.");
		Иначе
			ОбластьМакета.Параметры.СуммаПрописьюПолучил = "";
		КонецЕсли;
		
		ОбластьМакета.Параметры.КодПоЕДРПОУ 		= БухгалтерскийУчетПереопределяемый.ПолучитьКодОрганизации(СведенияОбОрганизации);
		
		Если НЕ ЗначениеЗаполнено(Шапка.ОбособленноеПодразделениеОрганизации) Тогда
			Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(Шапка.Организация, Шапка.ДатаДокумента);
		Иначе
			Руководители = ОтветственныеЛицаБП.ОтветственныеЛицаОбособленногоПодразделения(Шапка.ОбособленноеПодразделениеОрганизации, Шапка.ДатаДокумента);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Руководители.РуководительФИО) Тогда
			ОбластьМакета.Параметры.ФИОРуководителя = ОбщегоНазначенияБПВызовСервера.ПолучитьФамилиюИмяОтчество(Руководители.РуководительФИО.Фамилия, Руководители.РуководительФИО.Имя, Руководители.РуководительФИО.Отчество, Истина); // Кратко
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Руководители.ГлавныйБухгалтерФИО) Тогда
			ОбластьМакета.Параметры.ФИОБухгалтера   = ОбщегоНазначенияБПВызовСервера.ПолучитьФамилиюИмяОтчество(Руководители.ГлавныйБухгалтерФИО.Фамилия, Руководители.ГлавныйБухгалтерФИО.Имя, Руководители.ГлавныйБухгалтерФИО.Отчество, Истина); // Кратко
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Руководители.КассирФИО) Тогда
			ОбластьМакета.Параметры.ФИОКассира      = ОбщегоНазначенияБПВызовСервера.ПолучитьФамилиюИмяОтчество(Руководители.КассирФИО.Фамилия, Руководители.КассирФИО.Имя, Руководители.КассирФИО.Отчество, Истина); // Кратко
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Шапка.Ссылка);
		
		Запрос.УстановитьПараметр("Счет", Шапка.СчетКасса);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Проводки.СчетДт КАК СчетДт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Проводки
		|
		|ГДЕ
		|	Проводки.Регистратор = &ТекущийДокумент И
		|	Проводки.СчетКт = &Счет"+
		?( Шапка.СчетКасса.Валютный, "
		|// проводки по курсовой разнице (без валютной суммы) пропускаем
		|	И Проводки.ВалютнаяСуммаКт <> 0","");
		
		ВыборкаСчетов = Запрос.Выполнить().Выбрать();
		
		СписокСчетов = ""; Разделитель = "";
		
		Пока ВыборкаСчетов.Следующий() Цикл
			Если Найти(СписокСчетов, Строка(ВыборкаСчетов.СчетДТ)) <> 0 Тогда
				Продолжить;
			КонецЕсли;	
			СписокСчетов = СписокСчетов + Разделитель + Строка(ВыборкаСчетов.СчетДТ);
			Разделитель = ", ";
		КонецЦикла;	
		ОбластьМакета.Параметры.Счет = СписокСчетов;
		
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
		НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;

	Возврат ТабДокумент;

КонецФункции // ПечатьРКО()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета РКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РКО") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РКО", НСтр("ru='Расходный кассовый ордер';uk='Видатковий касовий ордер'"), 
			ПечатьРКО(МассивОбъектов, ОбъектыПечати), , "ОбщийМакет.ПФ_MXL_UK_КО2");
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли