#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Ссылка") И ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.ИНАГРО_ЛабораторныйАнализ") Тогда
			ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения); 			
		КонецЕсли;
	КонецЕсли;
	
	ИНАГРО_ЭлеваторЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	ВидЖурнала   = Перечисления.ИНАГРО_ВидыЖурналов.ЖурналЛаборатории;
	
	Если  ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ТипЖурнала") Тогда
		ТипЖурнала = ДанныеЗаполнения.ТипЖурнала;
	КонецЕсли;
	
	НомерАнализа = Документы.ИНАГРО_ЛабораторныйАнализ.ЗаполнитьНомерАнализа(ЭтотОбъект);		
	
	Сушка        = Истина;
	Очистка      = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверкаДублированияСтрок(Отказ, Результаты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда		
		Возврат;		
	КонецЕсли;
		
	Влажность       = 0;
	СорнаяПримесь   = 0;
	ЗерноваяПримесь = 0;
	Масличность     = 0;
	
	Для Каждого СтрокаТабличнойЧасти Из Результаты Цикл
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Влажность Тогда 
			Влажность       = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.СорнаяПримесь Тогда 
			СорнаяПримесь   = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ЗерноваяПримесь Тогда 
			ЗерноваяПримесь = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Масличность Тогда 
			Масличность     = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;
	КонецЦикла;
	
	УдалитьНезаполненныеСтроки();	
	
	Если ЗначениеЗаполнено(ТипЖурнала) Тогда
		
		Отбор = Новый Структура("ВидЖурнала, ТипЖурнала");
		ЗаполнитьЗначенияСвойств(Отбор, ЭтотОбъект);
		
		ИНАГРО_Элеватор.ЗаписатьОчереднойНомер(Отбор, НомерАнализа);
		
	КонецЕсли;

КонецПроцедуры 

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь(); 	
	
	НомерАнализа = Документы.ИНАГРО_ЛабораторныйАнализ.ЗаполнитьНомерАнализа(ЭтотОбъект);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Основание);
	
	Если НЕ ЗначениеЗаполнено(ТипЖурнала) Тогда
		ЗаполнитьТипЖурналаЛаборатории(ТипЖурнала, Основание.ВладелецЛабАнализа); 
	КонецЕсли;
	
	ВладелецЛабАнализа = ТипЗнч(Основание.ВладелецЛабАнализа);
		
	Документы.ИНАГРО_ЛабораторныйАнализ.ЗаполнитьТабличнуюЧастьРезультаты(ЭтотОбъект, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьТипЖурналаЛаборатории(ТипЖурнала, ВладелецЛабАнализа)
	
	ВыборкаПараметров = ИНАГРО_ЭлеваторЗаполнениеДокументов.ПолучитьПараметрыВидовДокументов("ИмяПоМетаданным", ВладелецЛабАнализа.Метаданные().Имя);
	
	Если ВыборкаПараметров <> Справочники.ИНАГРО_ВидыДокументов.ПустаяСсылка() Тогда  
		
		ЛабораторныйЖурнал = ВыборкаПараметров.ТипЖурналаЛаборатории;
		
		Если ЗначениеЗаполнено(ЛабораторныйЖурнал) Тогда
			ТипЖурнала = ЛабораторныйЖурнал;
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ПроверкаДублированияСтрок(Отказ, ТаблицаОбхода)
	
	ТаблицаСообщений = Новый ТаблицаЗначений;
	ТаблицаСообщений.Колонки.Добавить("Характеристика");
	ТаблицаСообщений.Колонки.Добавить("НомераСтрок");
	ТаблицаСообщений.Колонки.Добавить("ЕстьДубль");
	
	Для Каждого СтрокаТаблицыОбхода Из ТаблицаОбхода Цикл
		
		НайденаяСтрока = ТаблицаСообщений.Найти(СтрокаТаблицыОбхода.Характеристика, "Характеристика");
		НоваяСтрокаСообщений = ?(НайденаяСтрока = Неопределено, ТаблицаСообщений.Добавить(), НайденаяСтрока);
		НоваяСтрокаСообщений.Характеристика = СтрокаТаблицыОбхода.Характеристика;
		НоваяСтрокаСообщений.НомераСтрок    = ?(НайденаяСтрока = Неопределено, Строка(СтрокаТаблицыОбхода.НомерСтроки), "" + НоваяСтрокаСообщений.НомераСтрок + ", " + Строка(СтрокаТаблицыОбхода.НомерСтроки));
		НоваяСтрокаСообщений.ЕстьДубль      = ?(НайденаяСтрока = Неопределено, Ложь, Истина);
				
	КонецЦикла;
	
	Для Каждого СтрокаСообщений Из ТаблицаСообщений Цикл 		
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строках %1'; uk='У рядках %1'"), СтрокаСообщений.НомераСтрок);

		Если СтрокаСообщений.ЕстьДубль И ЗначениеЗаполнено(СтрокаСообщений.Характеристика) Тогда
			ТекстСообщения = ТекстСообщения + НСтр("ru=' используются одинаковые характеристики!'; uk=' використовуються однакові характеристики!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаСообщений.Характеристика) Тогда
			ТекстСообщения = ТекстСообщения + НСтр("ru=' используются пустые характеристики!'; uk=' використовуються порожні характеристики!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);						
		КонецЕсли;
		
	КонецЦикла;	
		
КонецПроцедуры

Процедура УдалитьНезаполненныеСтроки()
	
	НомерСтроки = Результаты.Количество() - 1;
	
	Пока НомерСтроки >= 0 Цикл
		
		СтрокаТаблицы = Результаты.Получить(НомерСтроки);
		Если СтрокаТаблицы.Удалить Тогда
			Результаты.Удалить(СтрокаТаблицы);
		КонецЕсли;
		НомерСтроки = НомерСтроки - 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли