

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ВыполнитьПроверкуКлючевыхРеквизитов(Отказ)

	Если ЭтоНовый() тогда
		//В случае нового договора не производить проверку
		Возврат;
	КонецЕсли;

	// Получим значения реквизитов договора из информационной базы
	РеквизитыДоговораИзИБ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, 
		"ПометкаУдаления, Владелец, ВалютаВзаиморасчетов, ВидДоговора, 
		|ВедениеВзаиморасчетов, ВедениеВзаиморасчетовНУ, СхемаНалоговогоУчета, СложныйНалоговыйУчет,
		|Организация");

	Если ПометкаУдаления <> РеквизитыДоговораИзИБ.ПометкаУдаления тогда
		//В случае установки или снятия пометки удаления не производить проверку
		Возврат;
	КонецЕсли;


	// Проверим, можно ли изменять реквизиты договора.

	УстановитьПривилегированныйРежим(Истина);

	Если ЭтоГруппа Тогда

		// Для группы владельца менять нельзя
		Если Владелец <> РеквизитыДоговораИзИБ.Владелец Тогда
			ТекстСообщения = НСтр("ru='Нельзя изменять контрагента для группы договоров.';uk='Не можна змінювати контрагента для групи договорів.'"); 
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", 
								НСтр("ru='Контрагент';uk='Контрагент'"), , , ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Владелец", "Объект", Отказ);
		КонецЕсли;

	Иначе

		// Для элемента нужно получить документы, в которых использован договор:
		ЕстьПроведенныеДокументыПоДоговору = Ложь;
		ЕстьОформленныеДокументыПоДоговору = Ложь;
		
		НеобходимаПроверка = ОпределитьНеобходимостьПроверки(РеквизитыДоговораИзИБ, 
			ЕстьПроведенныеДокументыПоДоговору, ЕстьОформленныеДокументыПоДоговору);
		
		Если НеобходимаПроверка Тогда

			// Проверим возможность смены владельца для договора
			Если ЕстьОформленныеДокументыПоДоговору = Истина Тогда
				ТекстСообщения = НСтр("ru='Существуют документы, оформленные по договору %1.';uk='Існують документи, оформлені за договором %1.'"); 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Наименование);
				СообщитьОНекорректномРеквизите("Владелец", НСтр("ru='Контрагент';uk='Контрагент'"), ТекстСообщения, Отказ);
			КонецЕсли;

			Если ЕстьПроведенныеДокументыПоДоговору Тогда
				СписокРеквизитов = Новый Структура("ВалютаВзаиморасчетов, ВидДоговора, Организация, ВедениеВзаиморасчетов, ВедениеВзаиморасчетовНУ, СхемаНалоговогоУчета, СложныйНалоговыйУчет", 
							НСтр("ru='Валюта расчетов';uk='Валюта розрахунків'"), 
							НСтр("ru='Вид договора';uk='Вид договору'"), 
							НСтр("ru='Организация';uk='Організація'"), 
							НСтр("ru='Ведение взаиморасчетов';uk='Ведення взаєморозрахунків'"), 
							НСтр("ru='Ведение взаиморасчетов по налоговому учету';uk='Ведення взаєморозрахунків по податковому обліку'"),
							НСтр("ru='Схема налогового учета';uk='Схема податкового обліку'"), 
							НСтр("ru='Сложный  учет НДС';uk='Складний облік ПДВ'")); 
				ТекстСообщения = НСтр("ru='Существуют документы, проведенные по договору %1.
|Реквизит %2 не может быть изменен.';uk='Існують документи, проведені за договором %1.
|Реквізит %2 не може бути змінений.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Наименование);
				Для Каждого КлючИЗначение Из СписокРеквизитов Цикл
					СообщитьОНекорректномРеквизите(КлючИЗначение.Ключ, КлючИЗначение.Значение, ТекстСообщения, Отказ);
				КонецЦикла;
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

Функция ОпределитьНеобходимостьПроверки(РеквизитыДоговораИзИБ, ЕстьПроведенныеДокументыПоДоговору, ЕстьОформленныеДокументыПоДоговору)

	ЕстьПроведенныеДокументыПоДоговору = Ложь;
	ЕстьОформленныеДокументыПоДоговору = Ложь;

	Если Владелец <> РеквизитыДоговораИзИБ.Владелец
		ИЛИ ВалютаВзаиморасчетов <> РеквизитыДоговораИзИБ.ВалютаВзаиморасчетов 
		ИЛИ ВидДоговора <> РеквизитыДоговораИзИБ.ВидДоговора
		ИЛИ Организация <> РеквизитыДоговораИзИБ.Организация 
		ИЛИ ВедениеВзаиморасчетов <> РеквизитыДоговораИзИБ.ВедениеВзаиморасчетов 
		ИЛИ ВедениеВзаиморасчетовНУ <> РеквизитыДоговораИзИБ.ВедениеВзаиморасчетовНУ 
		ИЛИ СхемаНалоговогоУчета <> РеквизитыДоговораИзИБ.СхемаНалоговогоУчета
		ИЛИ СложныйНалоговыйУчет <> РеквизитыДоговораИзИБ.СложныйНалоговыйУчет Тогда

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Договор", Ссылка);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументыПоДоговоруКонтрагента.Ссылка КАК ДокументПоДоговору
		|ИЗ
		|	КритерийОтбора.ДокументыПоДоговоруКонтрагента(&Договор) КАК ДокументыПоДоговоруКонтрагента";
		
		МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументПоДоговору");
		
		Если МассивДокументов.Количество() > 0 Тогда
		
			МассивНеПроведенныхДокументов = ОбщегоНазначения.ПроверитьПроведенностьДокументов(МассивДокументов);
			
			ЕстьОформленныеДокументыПоДоговору = Истина;
			ЕстьПроведенныеДокументыПоДоговору = (МассивНеПроведенныхДокументов.Количество() < МассивДокументов.Количество());
			
		КонецЕсли;
			
		Возврат Истина;

	Иначе

		// Проверку запускать не надо, ключевые реквизиты не менялись
		Возврат Ложь;

	КонецЕсли;

КонецФункции

Процедура СообщитьОНекорректномРеквизите(ИмяРеквизита, СинонимРеквизита, ШаблонСообщения, Отказ)

	Если ЭтотОбъект[ИмяРеквизита] <> Ссылка[ИмяРеквизита] Тогда
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%2", СинонимРеквизита);
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", 
			СинонимРеквизита, , , ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ИмяРеквизита, "Объект", Отказ);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью элемента справочника.
//
Процедура ПередЗаписью(Отказ)

	Если НЕ ЭтоГруппа Тогда
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		ОплатаВВалюте = (ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);
	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ВыполнитьПроверкуКлючевыхРеквизитов(Отказ);
	
	// ИНАГРО++
	Если ЭтотОбъект.ПометкаУдаления И ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() И ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаЗемли Тогда
		
		Набор = РегистрыСведений.ИНАГРО_НормативнаяОценкаЗемли.СоздатьНаборЗаписей();
		
		Для Каждого Строка Из ИНАГРО_СписокУчастков Цикл
		
			Набор.Отбор.Организация.Установить(Организация);
			Набор.Отбор.Договор.Установить(Ссылка);
			Набор.Отбор.Участок.Установить(Строка.Участок);
			Набор.Прочитать();
			НомерСтроки = Набор.Количество() - 1;
			Пока НомерСтроки >= 0 Цикл
				Запись = Набор[НомерСтроки];
				Запись.Актуальность = Ложь;
				НомерСтроки = НомерСтроки - 1;
			КонецЦикла;
			Набор.Записать();
		КонецЦикла;
		
	КонецЕсли;
	// ИНАГРО--

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	СохраняемыеЗначенияРеквизитов = ХранилищеОбщихНастроек.Загрузить("ДоговорыКонтрагентов_СохраняемыеЗначенияРеквизитов");
	Если ЗначениеЗаполнено(СохраняемыеЗначенияРеквизитов) И Не ЭтоГруппа Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраняемыеЗначенияРеквизитов);	
	КонецЕсли; 
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнениеДокументов.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
		// ИНАГРО++
		Если ДанныеЗаполнения.Свойство("ВидДоговора") И ДанныеЗаполнения.Свойство("АдресТаблицыУчастков") Тогда
			Если ДанныеЗаполнения.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаЗемли Тогда				
				Дата = ДанныеЗаполнения.Дата; 				
				ЗаполнитьСписокУчастков(ДанныеЗаполнения.АдресТаблицыУчастков, ДанныеЗаполнения.ДоговорКонтрагента);				
			КонецЕсли;
		КонецЕсли;
		// ИНАГРО--
	КонецЕсли;

	Если НЕ ЭтоГруппа Тогда
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		
		Если НЕ ЗначениеЗаполнено(Организация) Тогда
			ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
			
			Справочники.Организации.ПроверитьНаличиеОрганизацииПриОднофирменномУчете(ОсновнаяОрганизация);
			
			Организация = ОсновнаяОрганизация;
			КонецЕсли;
		Если ЗначениеЗаполнено(Организация) Тогда
			Организация = Организация;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
			ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ВедениеВзаиморасчетов) Тогда
			ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом;
			ВедениеВзаиморасчетовНУ = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СхемаНалоговогоУчета) Тогда
			Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
				СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомиссионером_НК;
				СложныйНалоговыйУчет = Истина;
			ИначеЕсли ВидДоговора =  Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
				СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомитентом_НК;
				СложныйНалоговыйУчет = Истина;
			ИначеЕсли ВидДоговора =  Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
				СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.Бартер;
			Иначе
				Если Не ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
					СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ВЭД;		
				Иначе	
					СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ПоПервомуСобытию;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ФормаРасчетов) Тогда
			Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
				ФормаРасчетов = "Бартер";  	
			Иначе		
				ФормаРасчетов = "Оплата з поточного рахунка";
			КонецЕсли;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ВидДоговораПоГК) Тогда
			Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
				ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Бартер;
			ИначеЕсли ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером
				ИЛИ ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
				ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Комиссия;
			Иначе
				ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Поставка;
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли; 	

КонецПроцедуры

Процедура ЗаполнитьСписокУчастков(АдресТаблицыУчастков, ДоговорКонтрагента) // ИНАГРО 	
	
	ТаблицаУчастков = ПолучитьИзВременногоХранилища(АдресТаблицыУчастков);
	
	// Заполним ТЧ СписокУчастков в новом договоре
	// РС НормативнаяОценкаЗемли пока не заполняем т.к. НовыйДоговор может быть не записан, а записи в РС останутся записанными 
	Если ТаблицаУчастков.Количество() > 0 Тогда 
		
		ИНАГРО_СписокУчастков.Очистить();
		
		Для каждого СтрокаУч из ТаблицаУчастков Цикл
			НоваяСтрока = ИНАГРО_СписокУчастков.Добавить();
			НоваяСтрока.Участок = СтрокаУч.Участок;			
		КонецЦикла;
		
		Записать();
		
		//Заполним РС ИНАГРО_НормативнаяОценкаЗемли для новых пайщиков	
		Набор = РегистрыСведений.ИНАГРО_НормативнаяОценкаЗемли.СоздатьНаборЗаписей();
		Для каждого СтрокаУч из ТаблицаУчастков Цикл
			
			Набор.Отбор.Период.Установить(НачалоМесяца(Дата));
			Набор.Отбор.Организация.Установить(Организация);
			Набор.Отбор.Договор.Установить(Ссылка);
			Набор.Отбор.Участок.Установить(СтрокаУч.Участок);
			Набор.Прочитать();
			
			Если Набор.Количество()	= 0 Тогда // т.е. в отрывавшемся новом договоре не заполняли регистр вручную		
				Запись = Набор.Добавить();
				Запись.Период	 				= НачалоМесяца(Дата);
				Запись.Организация 				= Организация;
				Запись.Договор 					= Ссылка;
				Запись.Участок 					= СтрокаУч.Участок;
				Запись.Актуальность 			= Истина;
				Запись.НормативнаяОценкаЗемли 	= СтрокаУч.НормативнаяОценкаЗемли;
				Запись.НормативнаяОценкаЗемлиЕдПлощади 	= СтрокаУч.НормативнаяОценкаЗемлиЕдПлощади;
				Набор.Записать();
			КонецЕсли;
			
		КонецЦикла;
		
		//Заполним РС ИНАГРО_НормативнаяОценкаЗемли для предыдущих пайщиков	без актуальности
		Набор = РегистрыСведений.ИНАГРО_НормативнаяОценкаЗемли.СоздатьНаборЗаписей();
		Для каждого СтрокаУч из ТаблицаУчастков Цикл
			
			Набор.Отбор.Период.Установить(НачалоМесяца(Дата));
			Набор.Отбор.Организация.Установить(Организация);
			Набор.Отбор.Договор.Установить(ДоговорКонтрагента);
			Набор.Отбор.Участок.Установить(СтрокаУч.Участок);
			Набор.Прочитать();
			
			Если Набор.Количество()	= 0 Тогда		
				Запись = Набор.Добавить();
				Запись.Период	 				= НачалоМесяца(Дата);
				Запись.Организация 				= Организация;
				Запись.Договор 					= ДоговорКонтрагента;
				Запись.Участок 					= СтрокаУч.Участок;
				Запись.Актуальность 			= Ложь;
				Запись.НормативнаяОценкаЗемли 	= СтрокаУч.НормативнаяОценкаЗемли;
				Запись.НормативнаяОценкаЗемлиЕдПлощади 	= СтрокаУч.НормативнаяОценкаЗемлиЕдПлощади;
				Набор.Записать();
			КонецЕсли;
			
		КонецЦикла;		
				
	КонецЕсли; 
	
КонецПроцедуры
#КонецЕсли
