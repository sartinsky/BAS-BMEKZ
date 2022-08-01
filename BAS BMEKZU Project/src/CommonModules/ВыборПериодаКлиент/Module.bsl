////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения выбора периода.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ВидПериодаПриИзменении(Элемент, Знач ВидПериода, НачалоПериода, КонецПериода, Период) Экспорт
	
	Если ВидПериода <> ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.ПроизвольныйПериод") Тогда
		Если ЗначениеЗаполнено(НачалоПериода) Тогда
			НачалоПериода = ВыборПериодаКлиентСервер.НачалоПериодаОтчета(ВидПериода, НачалоПериода);
			КонецПериода  = ВыборПериодаКлиентСервер.КонецПериодаОтчета(ВидПериода, НачалоПериода);
		Иначе
			НачалоПериода = Неопределено;
			КонецПериода  = Неопределено;
		КонецЕсли;
		
		Список = ВыборПериодаКлиентСервер.ПолучитьСписокПериодов(НачалоПериода, ВидПериода);
		ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
		Если ЭлементСписка <> Неопределено тогда
			Период = ЭлементСписка.Представление;
		Иначе
			Период = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПериодПриИзменении(Элемент, Знач Период, НачалоПериода, КонецПериода) Экспорт
	
	Если ПустаяСтрока(Период) Тогда
		НачалоПериода = Неопределено;
		КонецПериода  = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПериодНачалоВыбора(Форма, Элемент, СтандартнаяОбработка, ВидПериода, НачалоПериода, ВыполняемоеОповещение) Экспорт
	
	Если НачалоПериода = '00010101' Тогда
		НачалоПериода = ВыборПериодаКлиентСервер.НачалоПериодаОтчета(ВидПериода, ТекущаяДата());
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьПериодОтчета(Форма, Элемент, ВидПериода, НачалоПериода, ВыполняемоеОповещение);
	
КонецПроцедуры

Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Дата") Тогда
		НачалоПериода = ВыборПериодаКлиентСервер.НачалоПериодаОтчета(ВидПериода, ВыбранноеЗначение);
		КонецПериода  = ВыборПериодаКлиентСервер.КонецПериодаОтчета(ВидПериода, ВыбранноеЗначение);
		
		ВыбранноеЗначение = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
			ВидПериода, НачалоПериода, КонецПериода);
			
		Период = ВыбранноеЗначение;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	ДанныеВыбора = ВыборПериодаКлиентСервер.ПодобратьПериодОтчета(ВидПериода, Текст, 
		НачалоПериода, КонецПериода);
		
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = ВыборПериодаКлиентСервер.ПодобратьПериодОтчета(ВидПериода, Текст, 
		НачалоПериода, КонецПериода);
		
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ВыбратьПериодОтчета(Форма, Элемент, ВидПериода, НачалоПериода, ВыполняемоеОповещение)
	
	Список = ВыборПериодаКлиентСервер.ПолучитьСписокПериодов(НачалоПериода, ВидПериода);
	Если Список.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Список", Список);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	ДополнительныеПараметры.Вставить("ВидПериода", ВидПериода);
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);

	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
	
	Форма.ПоказатьВыборИзСписка(ОписаниеОповещения, Список, Элемент, ЭлементСписка);
	
КонецПроцедуры

Процедура ВыбратьПериодОтчетаЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Список = ДополнительныеПараметры.Список;
	Элемент = ДополнительныеПараметры.Элемент;
	ВидПериода = ДополнительныеПараметры.ВидПериода;
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	
	Если ВыбранныйПериод = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Индекс = Список.Индекс(ВыбранныйПериод);
	Если Индекс = 0 ИЛИ Индекс = Список.Количество() - 1 тогда
		ВыбратьПериодОтчета(Форма, Элемент, ВидПериода, ВыбранныйПериод.Значение, ВыполняемоеОповещение);
	Иначе
		ВернутьВыбранныйПериодВФорму(ВидПериода, ВыбранныйПериод, ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВернутьВыбранныйПериодВФорму(ВидПериода, ВыбранныйПериод, ВыполняемоеОповещение)
	
	СтруктураПериода = Новый Структура;
	СтруктураПериода.Вставить("ВидПериода", ВидПериода);
	СтруктураПериода.Вставить("Период", ВыбранныйПериод.Представление);
	СтруктураПериода.Вставить("НачалоПериода", ВыбранныйПериод.Значение);
	СтруктураПериода.Вставить("КонецПериода", ВыборПериодаКлиентСервер.КонецПериодаОтчета(ВидПериода, ВыбранныйПериод.Значение));
	
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, СтруктураПериода);
	
КонецПроцедуры