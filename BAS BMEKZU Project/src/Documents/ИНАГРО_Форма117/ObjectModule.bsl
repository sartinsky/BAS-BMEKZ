#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	
	ИНАГРО_ЭлеваторЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект); 	
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если  ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ВидОперации") Тогда
		ВидОперации = ДанныеЗаполнения.ВидОперации;
	КонецЕсли;	
				
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив; 	
	
	Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийФорма117.Сводная Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("Владелец");						
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 	
		
КонецПроцедуры 

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		   
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если ОтражатьВРасчетномВыходеПродукции Тогда
		
		ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
		
		// Движения по документу
		Если Не Отказ Тогда
			ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок);
		КонецЕсли;
		
	КонецЕсли;
	
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

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;	
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке(); 	
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");
		
КонецПроцедуры

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок)
	
	Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийФорма117.ПоВладельцу Тогда
		
		СтруктураПолей = Новый Структура;
		СтруктураПростыхПолей = Новый Структура;
		
		СтруктураПолей.Вставить("Ссылка",                   "Ссылка");
		СтруктураПолей.Вставить("Организация",              "Ссылка.Организация");
		СтруктураПолей.Вставить("Владелец",                 "Ссылка.Владелец");
		СтруктураПолей.Вставить("ПодразделениеОрганизации", "Ссылка.ПодразделениеОрганизации");
		СтруктураПолей.Вставить("Продукция",                "Номенклатура");
		СтруктураПолей.Вставить("Вес",                      "РасчетныйВесВыходаПродукции");
		
		РезультатЗапросаПоТоварам = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Продукция", СтруктураПолей, СтруктураПростыхПолей);
		ТаблицаПродукции = РезультатЗапросаПоТоварам.Выгрузить();
		
		Если НЕ Отказ Тогда
			Для Каждого СтрокаТаблицы Из ТаблицаПродукции Цикл
				ВидТМЦ = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(СтрокаТаблицы.Продукция, "ВидТМЦ");
				Если ВидТМЦ = Перечисления.ИНАГРО_ВидыТМЦ.Кат3 Тогда
					СобственныйКонтрагент = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитОрганизации(Организация,"Контрагент",Дата);
					СтрокаТаблицы.Владелец = СобственныйКонтрагент;
				КонецЕсли;
				ИНАГРО_Элеватор.ДвиженияПоРегиструРасчетныйВыпускПродукцииПриход(Движения, СтрокаТаблицы);				
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		
		ТаблицаПродукции = ПолучитьОстаткиПоРасчетномуВыходуПродукции();
		ТаблицаПродукции.Колонки.Добавить("Ссылка");
		
		Если НЕ Отказ Тогда
			Для Каждого СтрокаТаблицы Из ТаблицаПродукции Цикл
				СтрокаТаблицы.Ссылка = Ссылка;
				ИНАГРО_Элеватор.ДвиженияПоРегиструРасчетныйВыпускПродукцииРасход(Движения, СтрокаТаблицы);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_АктРасчет310") Тогда
		
		Организация        = Основание.Организация;
		Владелец           = Основание.Владелец;
		ДоговорКонтрагента = Основание.ДоговорКонтрагента;
		Склад              = Основание.Склад;
		ВидХранения        = Основание.ВидХранения;
		Урожай             = Основание.Урожай;
		ДатаНачала         = Основание.ДатаНачала;
		ДатаОкончания      = Основание.ДатаОкончания;
		
		НоваяСтрока = Сырье.Добавить();
		НоваяСтрока.Номенклатура       = Основание.Номенклатура;
		НоваяСтрока.ФизическийВес      = Основание.ФизическийВес8;
		НоваяСтрока.ЛабораторныйАнализ = Основание.ЛабораторныйАнализ;
		
	КонецЕсли;
			
КонецПроцедуры

Функция ПолучитьОстаткиПоРасчетномуВыходуПродукции()
	
	Запрос = Новый Запрос;		
	Фильтр = "";
	Фильтр = Фильтр + ?(ЗначениеЗаполнено(Организация),              " Организация = &Организация ", "");
	Фильтр = Фильтр + ?(ЗначениеЗаполнено(ПодразделениеОрганизации), " И ПодразделениеОрганизации = &ПодразделениеОрганизации ", "");
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.Организация,
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.ПодразделениеОрганизации,
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.Владелец КАК Владелец,
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.Продукция КАК Продукция,
		|	СУММА(ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.ВесКонечныйОстаток) КАК Вес
		|ИЗ
		|	РегистрНакопления.ИНАГРО_РасчетныйВыпускПродукции.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , ," + Фильтр + " ) КАК ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.Организация,
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.ПодразделениеОрганизации,
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.Владелец,
		|	ИНАГРО_РасчетныйВыпускПродукцииОстаткиИОбороты.Продукция";
	
	Запрос.УстановитьПараметр("ДатаНач",                  Новый Граница(НачалоДня(ДатаНачала), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ДатаКон",                  Новый Граница(КонецДня(ДатаОкончания), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",              Организация);
	Запрос.УстановитьПараметр("ПодразделениеОрганизации", ПодразделениеОрганизации);

	ТабОстатков = Запрос.Выполнить().Выгрузить();
	
	Возврат ТабОстатков;
	
КонецФункции

#КонецОбласти

#КонецЕсли