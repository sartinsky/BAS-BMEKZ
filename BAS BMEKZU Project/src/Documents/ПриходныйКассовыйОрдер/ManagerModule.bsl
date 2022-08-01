#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокВидовОперацийСРасшифровкойПлатежа() Экспорт
	
	СписокОпераций = Новый СписокЗначений();
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПКО.ОплатаПокупателя);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймамСКонтрагентами);
	СписокОпераций.Добавить(Перечисления.ВидыОперацийПКО.ПриходДенежныхСредствРозничнаяВыручка);
	
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

	// Приходный кассовый ордер (КО-1)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПКО";
	КомандаПечати.Представление = НСтр("ru='Приходный кассовый ордер (КО-1)';uk='Прибутковий касовий ордер (КО-1)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Приходный кассовый ордер""';uk='Реєстр документів ""Прибутковий касовий ордер""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой ПКО
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПКО (МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриходныйКассовыйОрдер_КО1";
	
	КодЯзыкаПечать = "uk";
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Ссылка,
	|	Номер,
	|	Дата  КАК ДатаДокумента,
	|	ВидОперации,
	|	СчетКасса,
	|	Организация КАК Орган,
	|	Организация,
	|	Организация КАК Руководители,
	|	ОбособленноеПодразделениеОрганизации,
	|	ОбособленноеПодразделениеОрганизации.НаименованиеПолное КАК ОбособленноеПодразделениеОрганизацииПредставление,
	|	Контрагент,
	|	Контрагент.Представление КАК Контрагент,
	|	ПринятоОт      КАК ПринятоОт,
	|	Основание      КАК Основание,
	|	Приложение     КАК Приложение,
	|	СуммаДокумента КАК Сумма,
	|	ВалютаДокумента,
	|	ВалютаДокумента.Представление КАК ВалютаПредставление,
	|	СтавкаНДС,
	|	НомерОрдера,
	|	ДокументОснование,
	|	СуммаПродаж,
	|	СуммаВозврата,
	|	СуммаБезналичнойОплаты,
	|	ВыводитьНаПечатьСуммуНДС,
	|	ПриемРозничнойВыручки.(
	|		Ссылка,
	|		НомерСтроки,
	|		Возврат,
	|		Сумма,
	|		СтавкаНДС,
	|		СуммаНДС,
	|		СчетУчетаНДС,
	|		СхемаРеализации,
	|		НоменклатурнаяГруппа,
	|		НалоговоеНазначение,
	|		НалоговоеНазначениеДоходовИЗатрат
	|	),
	|	РасшифровкаПлатежа.(
	|		Ссылка,
	|		НомерСтроки,
	|		ДоговорКонтрагента,
	|		Сделка,
	|		СуммаПлатежа,
	|		КурсВзаиморасчетов,
	|		СуммаВзаиморасчетов,
	|		СтавкаНДС,
	|		СуммаНДС,
	|		СтатьяДвиженияДенежныхСредств,
	|		СчетУчетаРасчетовСКонтрагентом,
	|		СчетУчетаРасчетовПоАвансам,
	|		КратностьВзаиморасчетов,
	|		ЗаТару,
	|		СтатьяДекларацииПоЕдиномуНалогу,
	|		ДокументПередачиОС,
	|		ОстаточнаяСтоимостьОС,
	|		СчетУчетаНДС,
	|		СчетУчетаНДСПодтвержденный,
	|		НалоговоеНазначение,
	|		СуммаНДСПропорциональноКредит,
	|		Амортизируется,
	|		ВозвратАвансаДо01042011НУ,
	|		СтатьяПоВозвратуАвансаДо2011НУ,
	|		СуммаВДВРПоАвансуДо01042011
	|	)
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|
	|ГДЕ
	|	ПриходныйКассовыйОрдер.Ссылка В(&МассивОбъектов)";

	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Вариант2018 = Истина;
		Если Шапка.ДатаДокумента >= Дата('20180105') Тогда
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_КО1_2018");
		Иначе
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_КО1");
			Вариант2018 = Ложь;
		КонецЕсли;
		
		// Выводим шапку ПКО
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Орган, Шапка.ДатаДокумента);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		Если Вариант2018 Тогда
			ПредставлениеДаты = Формат(Шапка.ДатаДокумента, "Л=uk_UA; ДЛФ=DD");
			ПредставлениеДаты = Сред(ПредставлениеДаты, 1, СтрДлина(ПредставлениеДаты) - 2) + "року";
			ОбластьМакета.Параметры.ДатаДокумента = ПредставлениеДаты;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Шапка.ОбособленноеПодразделениеОрганизации) Тогда
			ОбластьМакета.Параметры.ПолноеНаименование 	= СведенияОбОрганизации.ПолноеНаименование;
		Иначе
			ОбластьМакета.Параметры.ПолноеНаименование = Шапка.ОбособленноеПодразделениеОрганизацииПредставление;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Сумма             	= ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.Сумма, Шапка.ВалютаДокумента);
		
		ОбластьМакета.Параметры.СуммаПрописью = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.Сумма, Шапка.ВалютаДокумента, КодЯзыкаПечать);
		
		ОбластьМакета.Параметры.КодПоЕДРПОУ 		= БухгалтерскийУчетПереопределяемый.ПолучитьКодОрганизации(СведенияОбОрганизации);
		
		Если Шапка.ВидОперации = Перечисления.ВидыОперацийПКО.ПриходДенежныхСредствРозничнаяВыручка Тогда
			
			ТаблицаВыручки = Шапка.ПриемРозничнойВыручки.Выгрузить();
			Для каждого Строка Из ТаблицаВыручки Цикл
				Если Строка.Возврат = Истина Тогда
					Строка.СуммаНДС = - Строка.СуммаНДС;
					Строка.Сумма = - Строка.Сумма;
				КонецЕсли; 
			КонецЦикла; 
			
			СуммаНДС = ?(ТаблицаВыручки.Итог("Сумма") = 0, 0, ТаблицаВыручки.Итог("СуммаНДС") / ТаблицаВыручки.Итог("Сумма") * (ТаблицаВыручки.Итог("Сумма") - Шапка.СуммаБезналичнойОплаты));	
			СуммаНДС = Макс(СуммаНДС, 0)
			
		Иначе
			
			СуммаНДС = Шапка.РасшифровкаПлатежа.Выгрузить().Итог("СуммаНДС");	
			
		КонецЕсли; 
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Шапка.Ссылка);
		
		Запрос.УстановитьПараметр("Счет", Шапка.СчетКасса);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Проводки.СчетКт КАК СчетКт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Проводки
		|
		|ГДЕ
		|	Проводки.Регистратор = &ТекущийДокумент И
		|	Проводки.СчетДт = &Счет"+
		?(Шапка.СчетКасса.Валютный, "
		|// проводки по курсовой разнице (без валютной суммы) пропускаем
		|	И Проводки.ВалютнаяСуммаДт <> 0","");
		
		ВыборкаСчетов = Запрос.Выполнить().Выбрать();
		
		СписокСчетов = ""; Разделитель = "";
		
		Пока ВыборкаСчетов.Следующий() Цикл
			Если Найти(СписокСчетов, Строка(ВыборкаСчетов.СчетКТ)) <> 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Если ВыборкаСчетов.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСРозничнымиПокупателями Тогда
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ДокументОснование", Шапка.Ссылка);
				Запрос.УстановитьПараметр("Счет", ВыборкаСчетов.СчетКт);
				
				Запрос.Текст =
				"ВЫБРАТЬ
				|	Проводки.СчетКт КАК СчетКт
				|ИЗ
				|	РегистрБухгалтерии.Хозрасчетный КАК Проводки
				|
				|ГДЕ
				|	Проводки.Регистратор = &ДокументОснование И
				|	Проводки.СчетДт = &Счет";
				
				Выборка = Запрос.Выполнить().Выбрать();
				
				Пока Выборка.Следующий() Цикл
					Если Найти(СписокСчетов, Строка(Выборка.СчетКТ)) <> 0 Тогда
						Продолжить;
					КонецЕсли;	
					СписокСчетов = СписокСчетов + Разделитель + Строка(Выборка.СчетКТ);
					Разделитель = ", ";
				КонецЦикла;
			Иначе
				СписокСчетов = СписокСчетов + Разделитель + Строка(ВыборкаСчетов.СчетКТ);
				Разделитель = ", ";
			КонецЕсли;
		КонецЦикла;
		
		Если ТипЗнч(Шапка.ДокументОснование) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДокументОснование", Шапка.ДокументОснование);
			Запрос.УстановитьПараметр("Счет", Шапка.СчетКасса);
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	Проводки.СчетКт КАК СчетКт
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный КАК Проводки
			|
			|ГДЕ
			|	Проводки.Регистратор = &ДокументОснование И
			|	Проводки.СчетДт = &Счет";
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Если Выборка.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСРозничнымиПокупателями Тогда
					Запрос = Новый Запрос;
					Запрос.УстановитьПараметр("ДокументОснование", Шапка.ДокументОснование);
					Запрос.УстановитьПараметр("Счет", Выборка.СчетКт);
					
					Запрос.Текст =
					"ВЫБРАТЬ
					|	Проводки.СчетКт КАК СчетКт
					|ИЗ
					|	РегистрБухгалтерии.Хозрасчетный КАК Проводки
					|
					|ГДЕ
					|	Проводки.Регистратор = &ДокументОснование И
					|	Проводки.СчетДт = &Счет";
					
					ВыборкаСчетов = Запрос.Выполнить().Выбрать();
					
					Пока ВыборкаСчетов.Следующий() Цикл
						Если Найти(СписокСчетов, Строка(ВыборкаСчетов.СчетКТ)) <> 0 Тогда
							Продолжить;
						КонецЕсли;	
						СписокСчетов = СписокСчетов + Разделитель + Строка(ВыборкаСчетов.СчетКТ);
						Разделитель = ", ";
					КонецЦикла;
				Иначе 
					Если Найти(СписокСчетов, Строка(Выборка.СчетКТ)) <> 0 Тогда
						Продолжить;
					КонецЕсли;	
					СписокСчетов = СписокСчетов + Разделитель + Строка(Выборка.СчетКТ);
					Разделитель = ", ";
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Счет = СписокСчетов;
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		Если Шапка.ВыводитьНаПечатьСуммуНДС Тогда
			
			ОбластьМакета = Макет.ПолучитьОбласть("СекцияВТомЧисле");
			
			Если СуммаНДС = 0 Тогда
				ОбластьМакета.Параметры.ВТомЧисле = "0,00"+ " " + СокрП(Шапка.ВалютаДокумента);
			Иначе
				ОбластьМакета.Параметры.ВТомЧисле = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаНДС, Шапка.ВалютаДокумента);
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		
		Если НЕ ЗначениеЗаполнено(Шапка.ОбособленноеПодразделениеОрганизации) Тогда
			Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(Шапка.Организация, Шапка.ДатаДокумента);
		Иначе
			Руководители = ОтветственныеЛицаБП.ОтветственныеЛицаОбособленногоПодразделения(Шапка.ОбособленноеПодразделениеОрганизации, Шапка.ДатаДокумента);
		КонецЕсли;
		Если ЗначениеЗаполнено(Руководители.РуководительФИО) Тогда
			Руководитель =ОбщегоНазначенияБПВызовСервера.ПолучитьФамилиюИмяОтчество(Руководители.РуководительФИО.Фамилия, Руководители.РуководительФИО.Имя, Руководители.РуководительФИО.Отчество, Истина); // Кратко
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Руководители.ГлавныйБухгалтерФИО) Тогда
			Бухгалтер    = ОбщегоНазначенияБПВызовСервера.ПолучитьФамилиюИмяОтчество(Руководители.ГлавныйБухгалтерФИО.Фамилия, Руководители.ГлавныйБухгалтерФИО.Имя, Руководители.ГлавныйБухгалтерФИО.Отчество, Истина); // Кратко
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Руководители.КассирФИО) Тогда
			Кассир       = ОбщегоНазначенияБПВызовСервера.ПолучитьФамилиюИмяОтчество(Руководители.КассирФИО.Фамилия, Руководители.КассирФИО.Имя, Руководители.КассирФИО.Отчество, Истина); // Кратко
		КонецЕсли;
		
		ОбластьМакета.Параметры.ФИОГлавногоБухгалтера = Бухгалтер;
		ОбластьМакета.Параметры.ФИОКассира 			  = Кассир;
		
		
		ОбластьМакета.Параметры.Приложение	  = Шапка.Приложение;
		ТабДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции // ПечатьПКО()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета ПКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПКО") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПКО", НСтр("ru='Приходный кассовый ордер';uk='Прибутковий касовий ордер'"), ПечатьПКО(МассивОбъектов, ОбъектыПечати),,
			"ОбщийМакет.ПФ_MXL_UK_КО1");
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

