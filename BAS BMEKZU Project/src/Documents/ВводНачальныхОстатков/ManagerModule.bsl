#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

#Область ПроцедурыФункцииОбщегоНазначения

Функция ПолучитьТекстВстроеннойСправки(ИмяОбласти = "Начало", Организация = Неопределено, ДатаДокумента = Неопределено) Экспорт
	
	МакетПомощника = ПолучитьМакет("Справка");
	
	ОбластьТекстЗаголовок			= ИмяОбласти + "|Заголовок";
	ОбластьТекстаСправки = МакетПомощника.ПолучитьОбласть(ОбластьТекстЗаголовок);
	ТекстЗаголовок = ОбластьТекстаСправки.ТекущаяОбласть.Текст;
	
	ОбластьТекстОбщий			= ИмяОбласти + "|Общий";
	ОбластьТекстаСправки = МакетПомощника.ПолучитьОбласть(ОбластьТекстОбщий);
	ТекстОбщий = ОбластьТекстаСправки.ТекущаяОбласть.Текст + "
															  |";
	
	ОбластьТекстОсновной = ИмяОбласти + "|ОСН";
		
	ОбластьТекстаСправки = МакетПомощника.ПолучитьОбласть(ОбластьТекстОсновной);
	ТекстОбщий = ТекстОбщий + ОбластьТекстаСправки.ТекущаяОбласть.Текст + "
																		   |";
	мЕстьНалогНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, НачалоМесяца(ДатаДокумента));
	мЕстьНДС            = УчетнаяПолитика.ПлательщикНДС(Организация, НачалоМесяца(ДатаДокумента));	
	
	Если мЕстьНалогНаПрибыль И мЕстьНДС Тогда

		ОбластьТекстНалогНаПрибыль = ИмяОбласти + "|НалогНаПрибыльИНДС";
		ОбластьТекстаСправки = МакетПомощника.ПолучитьОбласть(ОбластьТекстНалогНаПрибыль);
		ТекстОбщий = ТекстОбщий + ОбластьТекстаСправки.ТекущаяОбласть.Текст + "
																			  |";
	ИначеЕсли мЕстьНДС Тогда

		ОбластьТекстНДС = ИмяОбласти + "|НДС";
		ОбластьТекстаСправки = МакетПомощника.ПолучитьОбласть(ОбластьТекстНДС);
		ТекстОбщий = ТекстОбщий + ОбластьТекстаСправки.ТекущаяОбласть.Текст + "
																			   |"; 	
	КонецЕсли; 																		   
	

	ТекстОбщий = "<DIV>" + СтрЗаменить(ТекстОбщий, Символы.ПС, "</DIV>" + Символы.ПС + "<DIV>") + "</DIV>";

 	ТекстВстроеннойСправки = ПолучитьМакет("ШаблонВстроеннойСправки").ПолучитьТекст();

	ТекстВстроеннойСправки = СтрЗаменить(ТекстВстроеннойСправки, "%header%", ТекстЗаголовок);
	ТекстВстроеннойСправки = СтрЗаменить(ТекстВстроеннойСправки, "%text%", ТекстОбщий);

	Возврат ТекстВстроеннойСправки;
	
КонецФункции

Процедура УстановитьПараметрыФункциональныхОпцийФормыДокумента(Форма) Экспорт

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
		Форма,
		Форма.Объект.Организация,
		КонецМесяца(Форма.Объект.Дата) + 1);

КонецПроцедуры

Функция ПолучитьДатуВводаОстатков(Организация) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДатыВводаНачальныхОстатков.ДатаВводаНачальныхОстатков
	|ИЗ
	|	РегистрСведений.ДатыВводаНачальныхОстатков КАК ДатыВводаНачальныхОстатков
	|ГДЕ
	|	ДатыВводаНачальныхОстатков.Организация = &Организация";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Дата(1,1,1);
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ДатаВводаНачальныхОстатков;
	КонецЕсли;

КонецФункции

#КонецОбласти 

#Область ПроцедурыИФункцииЗаголовкаФормы

Процедура УстановитьЗаголовокФормы(Форма) Экспорт
	
	Объект = Форма.Объект;

	ТекстЗаголовка	= НСтр("ru='Ввод остатков';uk='Введення залишків'");
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2';uk=' %1 від %2'"), Объект.Номер, Формат(Объект.Дата, "ДЛФ=D"));
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru=' (создание)';uk=' (створення)'");
	КонецЕсли;
	
	Форма.Заголовок = ТекстЗаголовка + " (" + Строка(Объект.РазделУчета) + ")";

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытий

Функция ПолучитьСоответствиеРазделовФормам() Экспорт

	СоответствиеРазделыУчета = Новый Соответствие;
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ВзаиморасчетыСКонтрагентами, "ФормаРасчетыСКонтрагентами");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ВзаиморасчетыСПодотчетнымиЛицами, "ФормаБухСправка");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ГруппыОСНалоговыйУчет, "ФормаБухСправка");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ДанныеНалоговогоУчета, "ФормаБухСправка");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ДенежныеСредства, "ФормаБухСправка");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ЗапасыПереданные, "ФормаЗапасыВсе");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ЗапасыСебестоимость, "ФормаЗапасыВсе");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ЗарплатаИОтчисления, "ФормаРасчетыПоЗаработнойПлате");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.КапитальныеИнвестиции, "ФормаЗапасыВсе");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.МалоценныеАктивыВЭксплуатации, "ФормаМалоценныеАктивы");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.НезавершенноеПроизводство, "ФормаЗатраты");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.НематериальныеАктивы, "ФормаНематериальныеАктивы");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ОсновныеСредства, "ФормаОсновныеСредства");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ОтсроченныеНалоговыеАктивыИОбязательства, "ФормаБухСправка");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ПрочиеСчетаБухгалтерскогоУчета, "ФормаБухСправка");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.РасходыБудущихПериодов, "ФормаРасходыБудущихПериодов");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ТоварыНаКомиссии, "ФормаЗапасыВсе");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ТоварыПоПродажнойЦене, "ФормаТоварыПоПродажнойЦене");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ТранспортноЗаготовительныеРасходыНаОтдельныхСубсчетах, "ФормаЗатраты");
	СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.ВременнаяРазницаОСЗа2020, "ФормаВременнаяРазницаОСЗа2020");
	
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
		СоответствиеРазделыУчета.Вставить(Перечисления.РазделыУчетаДляВводаОстатков.БиологическиеАктивы, "ФормаБиологическиеАктивы");
	КонецЕсли;
		
	Возврат СоответствиеРазделыУчета;

КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	ВыбранныйРаздел = Неопределено;

	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВыбранныйРаздел = Параметры.Ключ.РазделУчета;
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") Тогда
		Параметры.ЗначенияЗаполнения.Свойство("РазделУчета", ВыбранныйРаздел);
	КонецЕсли;

	Если ЗначениеЗаполнено(ВыбранныйРаздел) Тогда
		СтандартнаяОбработка = Ложь;
		СоответствиеРазделовФормам = ПолучитьСоответствиеРазделовФормам();
		ВыбраннаяФорма = СоответствиеРазделовФормам[ВыбранныйРаздел];
	КонецЕсли;

КонецПроцедуры

#КонецОбласти 

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Ввод остатков""';uk='Реєстр документів ""Введення залишків""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыТЧ_ОС

Функция ПолучитьРеквизитыОСДляПроверки(Дата, СтрокаОС,БезусловныеРеквизиты, НалУчет, НалУчетОбщ) Экспорт 

	РеквизитыДляПроверки = Новый Структура(БезусловныеРеквизиты);
	Для каждого ТекРеквизит из РеквизитыДляПроверки Цикл
		РеквизитыДляПроверки.Вставить(ТекРеквизит.Ключ, СтатусСообщения.Важное);
	КонецЦикла;
	
	ДатаНКУ2015_ДляВводаНачальныхОстатков = '2015 01 01' - 86400;
	ЭтоДокументДо2015 = (Дата < ДатаНКУ2015_ДляВводаНачальныхОстатков);
	
	//Проверка реквизитов общей группы
	
	
	//По видам учета
	Если СтрокаОС.НакопленнаяАмортизацияБУ <> 0 Тогда
		РеквизитыДляПроверки.Вставить("СчетАмортизацииБУ",  СтатусСообщения.Важное);
	КонецЕсли;
	РеквизитыДляПроверки.Вставить("ТекущаяСтоимостьБУ" ,СтатусСообщения.Важное);
	
	Если СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка 
		ИЛИ СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка
		ИЛИ СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный
		Тогда
		РеквизитыДляПроверки.Вставить("ДатаВводаВЭксплуатациюРеглБУ", СтатусСообщения.Важное);
	КонецЕсли;	
	
	
	
	Если НалУчетОбщ тогда
		РеквизитыДляПроверки.Вставить("НалоговоеНазначение", СтатусСообщения.Важное);
		Если СтрокаОС.НачислятьАмортизациюБУ И НЕ ЭтоДокументДо2015 Тогда
			РеквизитыДляПроверки.Вставить("СпособНачисленияАмортизацииНУ", СтатусСообщения.Важное);
		КонецЕсли;	
	КонецЕсли;
	
	Если НалУчет Тогда
		РеквизитыДляПроверки.Вставить( "НалоговаяГруппаОС", СтатусСообщения.Важное);
		//	 		РеквизитыДляПроверки.Вставить("БалансоваяСтоимостьНУ", СтатусСообщения.Важное);				
		
		Если ЭтоДокументДо2015 Тогда
			Если СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный 
				ИЛИ СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный 
				ИЛИ СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка
				ИЛИ СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка Тогда
				
				Если СтрокаОС.БалансоваяСтоимостьНУ > 0 Тогда
					РеквизитыДляПроверки.Вставить("СрокИспользованияДляВычисленияАмортизацииНУ" ,СтатусСообщения.Важное);
				КонецЕсли;	
			КонецЕсли;
		Иначе	
			Если СтрокаОС.СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный 
				ИЛИ СтрокаОС.СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный 
				ИЛИ СтрокаОС.СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка
				ИЛИ СтрокаОС.СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка Тогда
				
				Если СтрокаОС.НачислятьАмортизациюБУ Тогда 
					РеквизитыДляПроверки.Вставить("СрокИспользованияДляВычисленияАмортизацииНУ" ,СтатусСообщения.Важное);
 				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;	
		
	КонецЕсли; 
	
	
	//Проверка реквизитов дополнительной группы
	Модернизация = Новый структура("ДатаПоследнейМодернизацииРегл,
	|СобытиеМодернизацииРегл,
	|НомерДокументаМодернизацииРегл,
	|НазваниеДокументаМодернизацииРегл");
	Модернизация.Вставить("СуммаПоследнейМодернизацииБУ");
	
	Для Каждого ТекРеквизит Из Модернизация Цикл
		Если ЗначениеЗаполнено(СтрокаОС[ТекРеквизит.Ключ]) тогда
			РеквизитыДляПроверки.Вставить("ДатаПоследнейМодернизацииРегл"		,СтатусСообщения.Важное);
			РеквизитыДляПроверки.Вставить("СобытиеМодернизацииРегл"				,СтатусСообщения.Внимание);
			РеквизитыДляПроверки.Вставить("НомерДокументаМодернизацииРегл"		,СтатусСообщения.Внимание);
			РеквизитыДляПроверки.Вставить("НазваниеДокументаМодернизацииРегл"	,СтатусСообщения.Внимание);
			РеквизитыДляПроверки.Вставить("СуммаПоследнейМодернизацииБУ"		,СтатусСообщения.Внимание);
			
			Если СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный 
				или СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный 
				или СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка 
				или СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка Тогда
				РеквизитыДляПроверки.Вставить("СрокИспользованияДляВычисленияАмортизацииБУ"	,СтатусСообщения.Внимание);					
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	//Проверка реквизитов групп амортизации
	Если СтрокаОС.НачислятьАмортизациюБУ Тогда
		
		РеквизитыДляПроверки.Вставить("СпособНачисленияАмортизацииБУ"			,СтатусСообщения.Важное);
		Если СтрокаОС.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Производственный Тогда			
			РеквизитыДляПроверки.Вставить( "ПараметрВыработкиБУ",   СтатусСообщения.Важное);
			РеквизитыДляПроверки.Вставить( "ОбъемПродукцииРаботДляВычисленияАмортизацииБУ", СтатусСообщения.Важное);                            			
		Конецесли;
		
		Если СтрокаОС.НачислятьАмортизациюБУ Тогда
			РеквизитыДляПроверки.Вставить("СпособОтраженияРасходовПоАмортизацииБУ"	,СтатусСообщения.Внимание);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РеквизитыДляПроверки;
	
КонецФункции // ПолучитьРеквизитыДляПроверки()
	
#КонецОбласти 

#КонецЕсли
