#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Определяет элементы справочника "ИдентификаторыСервисовСопровождения"
// по переданным идентификаторам.
//
// Параметры:
//  Идентификаторы - Массив - идентификаторы сервисов в системе Портал ИТС.
//
// Возвращаемое значение:
//  Соответствие - соответствие между идентификатором сервиса и ссылкой элемента
//                справочника "ИдентификаторыСервисовСопровождения".
//
Функция СервисыСопровожденияПоИдентификаторам(Идентификаторы) Экспорт
	
	СервисыСопровождения = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыСервисовСопровождения.Ссылка КАК Сервис,
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса КАК Идентификатор
		|ИЗ
		|	Справочник.ИдентификаторыСервисовСопровождения КАК ИдентификаторыСервисовСопровождения
		|ГДЕ
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса В(&Идентификаторы)
		|	И НЕ ИдентификаторыСервисовСопровождения.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Идентификаторы", Идентификаторы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СервисыСопровождения = Новый Соответствие;
	Для Каждого Идентификатор Из Идентификаторы Цикл
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Идентификатор", Идентификатор);
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(ПараметрыПоиска) Тогда
			СервисыСопровождения.Вставить(Идентификатор, ВыборкаДетальныеЗаписи.Сервис);
		Иначе
			СервисыСопровождения.Вставить(Идентификаторы, Неопределено);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СервисыСопровождения;
	
КонецФункции

// Определяет данные сервиса сопровождения по переданному идентификатору.
//
// Параметры:
//  Идентификатор      - Строка, Справочник.ИдентификаторыСервисовСопровождения - идентификатор сервиса в системе Портал ИТС;
//  ВызыватьИсключение - Булево - признак, который регулирует необходимость вызова
//                       исключения, если сервис сопровождения по идентфикатору не найден.
//
// Возвращаемое значение:
//  Структура - содержит данные реквизитов справочника "ИдентификаторыСервисовСопровождения".
//
Функция ОписательСервисСопровожденияПоИдентификатору(Идентификатор, ВызыватьИсключение = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса КАК Идентификатор,
		|	ИдентификаторыСервисовСопровождения.Ссылка КАК СервисСопровождения,
		|	ИдентификаторыСервисовСопровождения.Наименование КАК Наименование,
		|	ИдентификаторыСервисовСопровождения.Описание КАК Описание,
		|	ИдентификаторыСервисовСопровождения.URLОписание КАК URLОписание,
		|	ИдентификаторыСервисовСопровождения.URLУсловияПолучения КАК URLУсловияПолучения,
		|	ИдентификаторыСервисовСопровождения.ИдентификаторКартинки КАК ИдентификаторКартинки
		|ИЗ
		|	Справочник.ИдентификаторыСервисовСопровождения КАК ИдентификаторыСервисовСопровождения
		|ГДЕ
		|	ИдентификаторыСервисовСопровождения.%1 = &Идентификатор
		|	И НЕ ИдентификаторыСервисовСопровождения.ПометкаУдаления";
	
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Запрос.Текст,
		?(ТипЗнч(Идентификатор) = Тип("Строка"), "ИдентификаторСервиса", "Ссылка"));
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ИменаСвойств = "СервисСопровождения,
		|Наименование,
		|Описание,
		|URLОписание,
		|URLУсловияПолучения,
		|Идентификатор";
		
	ОписательСервиса = Новый Структура(ИменаСвойств);
	ОписательСервиса.Вставить("Картинка", Неопределено);
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ОписательСервиса, ВыборкаДетальныеЗаписи, ИменаСвойств);
		ОписательСервиса.Картинка = БиблиотекаКартинок[ВыборкаДетальныеЗаписи.ИдентификаторКартинки];
		ОписательСервиса.Описание = СтрЗаменить(ОписательСервиса.Описание, Символы.ПС, "");
	Иначе
		Если ВызыватьИсключение Тогда
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сервис с идентификатором %1 не найден.';uk='Сервіс з ідентифікатором %1 не знайдений.'"),
				Идентификатор);
			
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОписательСервиса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет элементы справочника "ИдентификаторыСервисовСопровождения".
//
// Параметры:
//  СервисыСопровождения - Массив - содержит структуры с описанием сервиса:
//    Значение - Структура - см ПодключениеСервисовСопровождения.НовыйОписательСервиса().
//
Процедура ОбновитьДанныеСервисовСопровождения(СервисыСопровождения) Экспорт
	
	Идентификаторы = Новый Массив;
	Для Каждого ОписательСервиса Из СервисыСопровождения Цикл
		Идентификаторы.Добавить(ОписательСервиса.Идентификатор);
		ОписательСервиса.Вставить("ИдентификаторКартинки", "");
		Если ОписательСервиса.Картинка <> Неопределено Тогда
			ОписательСервиса.ИдентификаторКартинки = ОписательСервиса.Картинка.Имя;
		КонецЕсли;
	КонецЦикла;
	
	// Добавление новых идентификаторов.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыСервисовСопровождения.Ссылка КАК Ссылка,
		|	ИдентификаторыСервисовСопровождения.Наименование КАК Наименование,
		|	ИдентификаторыСервисовСопровождения.Описание КАК ОписаниеСервиса,
		|	ИдентификаторыСервисовСопровождения.ИдентификаторКартинки КАК ИдентификаторКартинки,
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса КАК Идентификатор
		|ИЗ
		|	Справочник.ИдентификаторыСервисовСопровождения КАК ИдентификаторыСервисовСопровождения
		|ГДЕ
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса В(&Идентификаторы)";
	
	Запрос.УстановитьПараметр("Идентификаторы", Идентификаторы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	// Обновление настроек не требует проверки прав доступа.
	УстановитьПривилегированныйРежим(Истина);
	
	ОбновленныеИдентификаторы = Новый Массив;
	Для Каждого ОписательСервиса Из СервисыСопровождения Цикл
		ИдентификаторОбъект = Неопределено;
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Идентификатор", ОписательСервиса.Идентификатор);
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(ПараметрыПоиска) Тогда
			Если ВыборкаДетальныеЗаписи.Наименование <> ОписательСервиса.Наименование
				Или ВыборкаДетальныеЗаписи.ОписаниеСервиса <> ОписательСервиса.Описание
				Или ВыборкаДетальныеЗаписи.ИдентификаторКартинки <> ОписательСервиса.ИдентификаторКартинки Тогда
				ИдентификаторОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			Иначе
				ОбновленныеИдентификаторы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			КонецЕсли;
			ВыборкаДетальныеЗаписи.Сбросить();
		Иначе
			ИдентификаторОбъект = Справочники.ИдентификаторыСервисовСопровождения.СоздатьЭлемент();
		КонецЕсли;
		
		Если ИдентификаторОбъект = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(
			ИдентификаторОбъект,
			ОписательСервиса,
			"Наименование, Описание, ИдентификаторКартинки");
		
		ИдентификаторОбъект.ПометкаУдаления      = Ложь;
		ИдентификаторОбъект.ИдентификаторСервиса = ОписательСервиса.Идентификатор;
		ИдентификаторОбъект.Записать();
		ОбновленныеИдентификаторы.Добавить(ИдентификаторОбъект.Ссылка);
	КонецЦикла;
	
	// Пометка на удаление не используемых.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыСервисовСопровождения.Ссылка КАК Ссылка,
		|	ИдентификаторыСервисовСопровождения.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ИдентификаторыСервисовСопровождения КАК ИдентификаторыСервисовСопровождения
		|ГДЕ
		|	НЕ ИдентификаторыСервисовСопровождения.Ссылка В (&ОбновленныеИдентификаторы)";
	
	Запрос.УстановитьПараметр("ОбновленныеИдентификаторы", ОбновленныеИдентификаторы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ИдентификаторОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ИдентификаторОбъект.Наименование     = ВставитьЗнакВопроса(ВыборкаДетальныеЗаписи.Наименование);
		ИдентификаторОбъект.ПометкаУдаления = Истина;
		ИдентификаторОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Обновляет данные ссылок справочника "ИдентификаторыСервисовСопровождения".
//
// Параметры:
//  ДанныеСервисовСопровождения - ТаблицаЗначений - см. функцию
//                              ПодключениеСервисовСопровождения.НовыйОписательСервисаСопровождения().
//
Процедура ОбновитьДанныеСсылокСервисовСопровождения(Знач ДанныеСервисовСопровождения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыСервисовСопровождения.Ссылка КАК Ссылка,
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса КАК Идентификатор,
		|	ИдентификаторыСервисовСопровождения.URLОписание КАК URLОписание,
		|	ИдентификаторыСервисовСопровождения.URLУсловияПолучения КАК URLУсловияПолучения
		|ИЗ
		|	Справочник.ИдентификаторыСервисовСопровождения КАК ИдентификаторыСервисовСопровождения
		|ГДЕ
		|	ИдентификаторыСервисовСопровождения.ИдентификаторСервиса В(&Идентификаторы)
		|	И НЕ ИдентификаторыСервисовСопровождения.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Идентификаторы", ДанныеСервисовСопровождения.ВыгрузитьКолонку("Идентификатор"));
	РезультатЗапроса       = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	// Обновление настроек не требует проверки прав доступа.
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ОписательСервиса Из ДанныеСервисовСопровождения Цикл
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Идентификатор", ОписательСервиса.Идентификатор);
		URLУсловияПолучения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1#%2",
			ОписательСервиса.URLОписание,
			ОписательСервиса.URLУсловияПолучения);
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(ПараметрыПоиска) Тогда
			Если ВыборкаДетальныеЗаписи.URLОписание <> ОписательСервиса.URLОписание
				Или ВыборкаДетальныеЗаписи.URLУсловияПолучения <> URLУсловияПолучения Тогда
				ИдентификаторОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
				ИдентификаторОбъект.URLОписание         = ОписательСервиса.URLОписание;
				ИдентификаторОбъект.URLУсловияПолучения = URLУсловияПолучения;
				ИдентификаторОбъект.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ФормаСпискаПриСозданииНаСервере(Форма) Экспорт
	
	Если Форма.Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Форма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ФормаЭлементаПриСозданииНаСервере(Форма) Экспорт
	
	Если Форма.Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Форма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

// Добавляет знак "?" к начальной строке.
//
// Параметры:
//  НачальноеЗначение - Строка - начальная строка.
//
// Возвращаемое значение:
//  Строка - начальная строка с дополненная символом "?".
//
Функция ВставитьЗнакВопроса(Знач НачальноеЗначение)
	
	Если Не СтрНачинаетсяС(НачальноеЗначение, "?") Тогда
		Если Не СтрНачинаетсяС(НачальноеЗначение, " ") Тогда
			НачальноеЗначение = "? " + НачальноеЗначение;
		Иначе
			НачальноеЗначение = "?" + НачальноеЗначение;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НачальноеЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли
