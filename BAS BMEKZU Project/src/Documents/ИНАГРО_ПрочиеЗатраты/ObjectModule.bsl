#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мВалютаРегламентированногоУчета; 

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если  ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ВидОперации") Тогда
		ВидОперации = ДанныеЗаполнения.ВидОперации;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ УчетнаяПолитика.ПлательщикНДС(Организация, Дата) Тогда
		// Организация - не плательщик НДС. Установим во всех ТЧ признак соответствующего учета НДС.
		НеОБлНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		
		Для каждого СтрокаТЧ  Из Затраты Цикл
		    СтрокаТЧ.НалоговоеНазначение = НеОБлНДСДеятельность;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаЗатрат; 
		
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);  	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	мВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
		
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента,Отказ,Заголовок);
	
	// Дополним полями, нужными для регл. и упр. учета
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке();
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	
	// Формирование движений регистров, бухгалтерских и налоговых проводок.
	ФормированиеДвиженийРегл(СтруктураШапкиДокумента);

	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
		
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015", УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС",                  УчетнаяПолитика.ПлательщикНДС(Организация, Дата));
	
	БухгалтерскийУчет.ПроверитьЗаполнениеАналитикиЗатрат(ЭтотОбъект, Отказ, Заголовок);
	
КонецПроцедуры 

// Процедура формирования движений регл. регистров
//
Процедура ФормированиеДвиженийРегл(СтруктураШапкиДокумента)
	
	Проводки = Движения.Хозрасчетный;
	
	СтруктДопПараметры = Новый Структура;
	СтруктДопПараметры.Вставить("ВидОперации",        СтруктураШапкиДокумента.ВидОперации);
	СтруктДопПараметры.Вставить("КурсДокумента",      1);
	СтруктДопПараметры.Вставить("КратностьДокумента", 1);
	СтруктДопПараметры.Вставить("ЕстьНДС",            Ложь);
	
	Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийПрочиеЗатраты.Списание Тогда
		СтруктДопПараметры.Вставить("ВидДвижения",   "Расход");
	КонецЕсли;
	
	Для Каждого СтрокаТабличнойЧасти Из Затраты Цикл
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Активность 	= Истина;
		НоваяПроводка.Период     	= Дата;
		
		НоваяПроводка.Организация 	= Организация;
		НоваяПроводка.Содержание	= Нстр("ru='Прочие затраты';uk='Інші витрати'");
		НоваяПроводка.Сумма  		= СтрокаТабличнойЧасти.Сумма;
		
		Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийПрочиеЗатраты.Отражение Тогда
			
			НоваяПроводка.СчетДт = СтрокаТабличнойЧасти.СчетЗатрат;
			БухгалтерскийУчет.УстановитьСубконто(СтрокаТабличнойЧасти.СчетЗатрат, НоваяПроводка.СубконтоДт, 1, СтрокаТабличнойЧасти.Субконто1);
			БухгалтерскийУчет.УстановитьСубконто(СтрокаТабличнойЧасти.СчетЗатрат, НоваяПроводка.СубконтоДт, 2, СтрокаТабличнойЧасти.Субконто2);
			БухгалтерскийУчет.УстановитьСубконто(СтрокаТабличнойЧасти.СчетЗатрат, НоваяПроводка.СубконтоДт, 3, СтрокаТабличнойЧасти.Субконто3);
			
			НоваяПроводка.СчетКт = Счет;
			БухгалтерскийУчет.УстановитьСубконто(Счет, НоваяПроводка.СубконтоКт, 1, Субконто1);
			БухгалтерскийУчет.УстановитьСубконто(Счет, НоваяПроводка.СубконтоКт, 2, Субконто2);
			БухгалтерскийУчет.УстановитьСубконто(Счет, НоваяПроводка.СубконтоКт, 3, Субконто3);
						
			Если НоваяПроводка.СчетДт.НалоговыйУчет Тогда
				НоваяПроводка.НалоговоеНазначениеДт = СтрокаТабличнойЧасти.НалоговоеНазначение;
				Если НоваяПроводка.НалоговоеНазначениеДт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность
					И НоваяПроводка.НалоговоеНазначениеДт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
					НоваяПроводка.СуммаНУДт = СтрокаТабличнойЧасти.СуммаНУ;
				КонецЕсли;
			КонецЕсли;
			Если НоваяПроводка.СчетКт.НалоговыйУчет Тогда
				НоваяПроводка.НалоговоеНазначениеКт = НалоговоеНазначениеДоходовИЗатрат;
				Если НоваяПроводка.НалоговоеНазначениеКт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность
					И НоваяПроводка.НалоговоеНазначениеКт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
					НоваяПроводка.СуммаНУКт = СтрокаТабличнойЧасти.СуммаНУ;
				КонецЕсли;
			КонецЕсли; 			
			
			Если НоваяПроводка.СчетДт.УчетПоНалоговымНазначениямНДС Тогда
				НоваяПроводка.НалоговоеНазначениеДт = СтрокаТабличнойЧасти.НалоговоеНазначение;
			КонецЕсли; 
			Если НоваяПроводка.СчетКт.УчетПоНалоговымНазначениямНДС Тогда
				НоваяПроводка.НалоговоеНазначениеКт = НалоговоеНазначениеДоходовИЗатрат;
			КонецЕсли;
						
		Иначе
			
			НоваяПроводка.СчетДт = Счет;
			БухгалтерскийУчет.УстановитьСубконто(Счет, НоваяПроводка.СубконтоДт, 1, Субконто1);
			БухгалтерскийУчет.УстановитьСубконто(Счет, НоваяПроводка.СубконтоДт, 2, Субконто2);
			БухгалтерскийУчет.УстановитьСубконто(Счет, НоваяПроводка.СубконтоДт, 3, Субконто3);
			
			НоваяПроводка.СчетКт = СтрокаТабличнойЧасти.СчетЗатрат;
			БухгалтерскийУчет.УстановитьСубконто(СтрокаТабличнойЧасти.СчетЗатрат, НоваяПроводка.СубконтоКт, 1, СтрокаТабличнойЧасти.Субконто1);
			БухгалтерскийУчет.УстановитьСубконто(СтрокаТабличнойЧасти.СчетЗатрат, НоваяПроводка.СубконтоКт, 2, СтрокаТабличнойЧасти.Субконто2);
			БухгалтерскийУчет.УстановитьСубконто(СтрокаТабличнойЧасти.СчетЗатрат, НоваяПроводка.СубконтоКт, 3, СтрокаТабличнойЧасти.Субконто3);
						
			Если НоваяПроводка.СчетДт.НалоговыйУчет Тогда
				НоваяПроводка.НалоговоеНазначениеДт = НалоговоеНазначениеДоходовИЗатрат;
				Если НоваяПроводка.НалоговоеНазначениеДт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность
					И НоваяПроводка.НалоговоеНазначениеДт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
					НоваяПроводка.СуммаНУДт = СтрокаТабличнойЧасти.СуммаНУ;
				КонецЕсли;
			КонецЕсли;
			Если НоваяПроводка.СчетКт.НалоговыйУчет Тогда
				НоваяПроводка.НалоговоеНазначениеКт = СтрокаТабличнойЧасти.НалоговоеНазначение;
				Если НоваяПроводка.НалоговоеНазначениеКт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность
					И НоваяПроводка.НалоговоеНазначениеКт <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
					НоваяПроводка.СуммаНУКт = СтрокаТабличнойЧасти.СуммаНУ;
				КонецЕсли;
			КонецЕсли;
						
			Если НоваяПроводка.СчетДт.УчетПоНалоговымНазначениямНДС Тогда
				НоваяПроводка.НалоговоеНазначениеДт = НалоговоеНазначениеДоходовИЗатрат;
			КонецЕсли; 
			Если НоваяПроводка.СчетКт.УчетПоНалоговымНазначениямНДС Тогда
				НоваяПроводка.НалоговоеНазначениеКт = СтрокаТабличнойЧасти.НалоговоеНазначение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИНАГРО_Общий.ИНАГРО_ДвиженияЗатратыОрганизации_Приход(СтруктураШапкиДокумента, Движения);
	
	СписокСчетов = ИНАГРО_Общий.ИНАГРО_СписокСчетовЗатрат();
	
	Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийПрочиеЗатраты.Списание Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
		|	ВЫБОР
		|		КОГДА &Счет В ИЕРАРХИИ (&Список)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Счет
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный";
		
		Запрос.УстановитьПараметр("Список", СписокСчетов);
		Запрос.УстановитьПараметр("Счет",   Счет);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если  Выборка.Счет = Ложь Тогда
				Инагро_ДвиженияЗатратыОрганизацииРасход(СтруктураШапкиДокумента, Движения, СписокСчетов);
			КонецЕсли;   
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ИНАГРО_ВидыОперацийПрочиеЗатраты.Отражение Тогда 
		// Если счет затрат (сч. Дт) не входит в список счетов затрат для распределения,
		// Тогда для движения Расход необходимо вызвать отдельную процедуру.
		Запрос = Новый Запрос;
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВЫБОР
			|		КОГДА ИНАГРО_ПрочиеЗатратыЗатраты.СчетЗатрат В ИЕРАРХИИ (&Список)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Счет
			|ИЗ
			|	Документ.ИНАГРО_ПрочиеЗатраты.Затраты КАК ИНАГРО_ПрочиеЗатратыЗатраты
			|ГДЕ
			|	ИНАГРО_ПрочиеЗатратыЗатраты.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Список", СписокСчетов);
		Запрос.УстановитьПараметр("Счет",   Счет);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);

		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если  Выборка.Счет = Ложь Тогда
				Инагро_ДвиженияЗатратыОрганизацииРасход(СтруктураШапкиДокумента, Движения, СписокСчетов);
			КонецЕсли;   
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура делает расход по регистру Затраты Организации. Тот случай когда нужно списать с затратного счета.
Процедура Инагро_ДвиженияЗатратыОрганизацииРасход(СтруктураШапкиДокумента, Движения, СписокСчетов)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
		|	ХозрасчетныйДвиженияССубконто.Период,
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.НомерСтроки,
		|	ХозрасчетныйДвиженияССубконто.Активность,
		|	ХозрасчетныйДвиженияССубконто.СчетДт,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт2 ССЫЛКА Справочник.СтатьиЗатрат
		|					ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт2
		|				ИНАЧЕ ВЫБОР
		|						КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт3 ССЫЛКА Справочник.СтатьиЗатрат
		|							ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт3
		|						ИНАЧЕ NULL
		|					КОНЕЦ
		|			КОНЕЦ
		|	КОНЕЦ КАК СтатьяЗатрат,
		|	ХозрасчетныйДвиженияССубконто.ВидСубконтоДт1,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт2 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|					ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт2
		|				ИНАЧЕ ВЫБОР
		|						КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт3 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|							ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт3
		|						ИНАЧЕ NULL
		|					КОНЕЦ
		|			КОНЕЦ
		|	КОНЕЦ КАК Подразделение,
		|	ХозрасчетныйДвиженияССубконто.ВидСубконтоДт2,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1 ССЫЛКА Справочник.НоменклатурныеГруппы
		|			ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт2 ССЫЛКА Справочник.НоменклатурныеГруппы
		|					ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт2
		|				ИНАЧЕ ВЫБОР
		|						КОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт3 ССЫЛКА Справочник.НоменклатурныеГруппы
		|							ТОГДА ХозрасчетныйДвиженияССубконто.СубконтоКт3
		|						ИНАЧЕ NULL
		|					КОНЕЦ
		|			КОНЕЦ
		|	КОНЕЦ КАК НоменклатурнаяГруппа,
		|	ХозрасчетныйДвиженияССубконто.ВидСубконтоДт3,
		|	ХозрасчетныйДвиженияССубконто.СчетКт,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1,
		|	ХозрасчетныйДвиженияССубконто.ВидСубконтоКт1,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт2,
		|	ХозрасчетныйДвиженияССубконто.ВидСубконтоКт2,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт3,
		|	ХозрасчетныйДвиженияССубконто.ВидСубконтоКт3,
		|	ХозрасчетныйДвиженияССубконто.Организация,
		|	ХозрасчетныйДвиженияССубконто.ВалютаДт,
		|	ХозрасчетныйДвиженияССубконто.ВалютаКт,
		|	ХозрасчетныйДвиженияССубконто.Сумма,
		|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаДт,
		|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаКт,
		|	ХозрасчетныйДвиженияССубконто.КоличествоДт,
		|	ХозрасчетныйДвиженияССубконто.КоличествоКт,
		|	ХозрасчетныйДвиженияССубконто.Содержание,
		|	ХозрасчетныйДвиженияССубконто.НомерЖурнала,
		|	ХозрасчетныйДвиженияССубконто.СчетДополнительный,
		|	ХозрасчетныйДвиженияССубконто.НеКорректироватьСтоимостьАвтоматически,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйДвиженияССубконто.СчетКт В ИЕРАРХИИ (&СписокСчетовЗатрат)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК РасходЗатрат,
		|	ХозрасчетныйДвиженияССубконто.СуммаНУДт,
		|	ХозрасчетныйДвиженияССубконто.СуммаНУКт,
		|	ХозрасчетныйДвиженияССубконто.НалоговоеНазначениеДт,
		|	ХозрасчетныйДвиженияССубконто.НалоговоеНазначениеКт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор = &Ссылка, , ) КАК ХозрасчетныйДвиженияССубконто
		|ГДЕ
		|	ХозрасчетныйДвиженияССубконто.СчетКт В ИЕРАРХИИ(&СписокСчетовЗатрат)"; 
	
	Запрос.УстановитьПараметр("Ссылка",             СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("СписокСчетовЗатрат", СписокСчетов);
	
	ВыборкаЗатрат = Запрос.Выполнить().Выбрать();
	
	ПустаяНомГруп = Справочники.НоменклатурныеГруппы.ПустаяСсылка();
	ПустоеПодразд = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	ПустаяСтатья  = Справочники.СтатьиЗатрат.ПустаяСсылка();
	
	Пока ВыборкаЗатрат.Следующий() Цикл
		
		Движение = Движения.ИНАГРО_ЗатратыОрганизаций.Добавить();		
		Движение.ВидДвижения 	                   = ВидДвиженияНакопления.Расход;
		Движение.Период 		                   = ВыборкаЗатрат.Период;
		Движение.Организация 	                   = ВыборкаЗатрат.Организация;		
		Движение.СчетЗатрат 		               = ВыборкаЗатрат.СчетКт;
		Движение.Подразделение 		               = ВыборкаЗатрат.Подразделение;
		Движение.НоменклатурнаяГруппа              = ВыборкаЗатрат.НоменклатурнаяГруппа;
		Движение.СтатьяЗатрат 		               = ВыборкаЗатрат.СтатьяЗатрат; 		
		Движение.Количество 		               = ВыборкаЗатрат.КоличествоКт;
		Движение.Сумма 				               = ВыборкаЗатрат.Сумма;		
		Движение.СуммаНУ                           = ВыборкаЗатрат.СуммаНУДт;
		Движение.НалоговоеНазначениеДоходовИЗатрат = ВыборкаЗатрат.НалоговоеНазначениеКт; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли 