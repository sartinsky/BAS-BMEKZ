// Процедура делает движения прихода по регистру ИНАГРО_ЗатратыОрганизаций
// на основании проводок по регистру Хозрасчетный.
//
//  Параметры:
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//
Процедура ИНАГРО_ДвиженияЗатратыОрганизации_Приход(СтруктураШапкиДокумента, Движения) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ДвиженияЗатратыОрганизации_Приход(СтруктураШапкиДокумента, Движения);
	КонецЕсли;
КонецПроцедуры

// Процедура делает движения расход по регистру ИНАГРО_ЗатратыОрганизаций
// на основании проводок по регистру Хозрасчетный.
//
//  Параметры:
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//
Процедура ИНАГРО_ДвиженияЗатратыОрганизации_Расход(СтруктураШапкиДокумента, Движения) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ДвиженияЗатратыОрганизации_Расход(СтруктураШапкиДокумента, Движения);
	КонецЕсли;
КонецПроцедуры

// Процедура делает движения прихода по регистру ИНАГРО_ВыпускПродукцииОрганизации
// и регистру ИНАГРО_ЗатратыОрганизаций
// на основании проводок по регистру Хозрасчетный.
//
//  Параметры:
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//
Процедура ИНАГРО_ДвиженияВыпускПродукции(СтруктураШапкиДокумента, Движения) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ДвиженияВыпускПродукции(СтруктураШапкиДокумента, Движения);
	КонецЕсли;
КонецПроцедуры

// Процедура делает движения прихода по регистру ИНАГРО_ВыпускПродукцииОрганизации.
//
//  Параметры:
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//		ТаблицаПоУслугам	    - ТаблицаЗначений - таблица по которой выполняются движения
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//
Процедура ИНАГРО_ДвиженияВыпускПродукции_Услуги(СтруктураШапкиДокумента, ТаблицаПоУслугам, Движения) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ДвиженияВыпускПродукции_Услуги(СтруктураШапкиДокумента, ТаблицаПоУслугам, Движения);
	КонецЕсли;
КонецПроцедуры

// Выполняет движения по приходу по регистру ВедомостьДвижений
//
//  Параметры:
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//		ТаблицаДокумента	    - ТаблицаЗначений - таблица по которой выполняются движения
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//
Процедура ИНАГРО_ВедомостьДвиженийПриход(Движения, ТаблицаДокумента, СтруктураШапкиДокумента) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ВедомостьДвиженийПриход(Движения, ТаблицаДокумента, СтруктураШапкиДокумента);
	КонецЕсли;
КонецПроцедуры

// Выполняет движения по расходу по регистру ВедомостьДвижений
//
//  Параметры:
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//		ТаблицаСписания	        - ТаблицаЗначений - таблица по которой выполняются движения
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//
Процедура ИНАГРО_ВедомостьДвиженийРасход(Движения, ТаблицаСписания, СтруктураШапкиДокумента) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ВедомостьДвиженийРасход(Движения, ТаблицаСписания, СтруктураШапкиДокумента);
	КонецЕсли;
КонецПроцедуры

// Процедура регистрирует факт закупки.
//
//  Параметры:
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//		СтрокаТаблицы	        - СтрокаТаблицыЗначений - строка таблицы по которой выполняются движения
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//      Расход                  - Булево - если Истина, то вид движения расход
//
Процедура ИНАГРО_РегистрацияЗакупки(Движения, СтрокаТаблицы, СтруктураШапкиДокумента, Расход = Ложь) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_РегистрацияЗакупки(Движения, СтрокаТаблицы, СтруктураШапкиДокумента, Расход);
	КонецЕсли;
КонецПроцедуры

// Процедура регистрирует факт реализации
//
//  Параметры:
//		СтрокаДокумента	- СтрокаТаблицыЗначений - строка таблицы по которой выполняются движения
//		Количество	    - Число
//      Стоимость       - Число
//      ДокОбъект       - ДокументОбъект
//      Голов           - Число - количество голов
//
Процедура ИНАГРО_РегистрацияРеализации(СтрокаДокумента, Количество, Стоимость, ДокОбъект = Неопределено, Голов = 0) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_РегистрацияРеализации(СтрокаДокумента, Количество, Стоимость, ДокОбъект, Голов);
	КонецЕсли;
КонецПроцедуры

// Процедура формирует движения документа ИНАГРО_РаспределениеЗатрат.
//
//  Параметры:
//		Движения       		    - КоллекцияДвижений - коллекция движений документа
//		БазаРаспределения	    - ПеречислениеСсылка.ИНАГРО_СпособыРаспределенияЗатрат
//		СтруктураШапкиДокумента	- Структура - структура реквизитов шапки документа
//		ТаблицаПоРаспределению	- ТаблицаЗначений
//		ТаблицаПоЗатратам	    - ТаблицаЗначений
//      Отказ                   - Булево - отказ от проведения документа
//      Заголовок               - Строка - заголовок
//
Процедура ИНАГРО_ДвиженияРаспределенияЗатрат(Движения, БазаРаспределения, СтруктураШапкиДокумента, ТаблицаПоРаспределению, ТаблицаПоЗатратам, Отказ, Заголовок = "") Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ДвиженияРаспределенияЗатрат(Движения, БазаРаспределения, СтруктураШапкиДокумента, ТаблицаПоРаспределению, ТаблицаПоЗатратам, Отказ, Заголовок);
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

// Заполняет таблицу затрат
//
//  Параметры:
//		ПараметрыОтбора   - Структура - параметры отбора
//		ТЧЗатраты         - ТаблицаЗначений
//		НеобходимыеДанные - Структура - структура допоплнительных параметров
//
Процедура ИНАГРО_ЗаполнитьТЧЗатраты(ПараметрыОтбора, ТЧЗатраты, НеобходимыеДанные) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ЗаполнитьТЧЗатраты(ПараметрыОтбора, ТЧЗатраты, НеобходимыеДанные);
	КонецЕсли;
КонецПроцедуры

// Заполняет таблицу базы
//
//  Параметры:
//		БазаРаспределения - ПеречислениеСсылка.ИНАГРО_СпособыРаспределенияЗатрат
//		ТЗБазаПоЗатрате   - ТаблицаЗначений
//		НеобходимыеДанные - Структура - структура допоплнительных параметров
//
Процедура ИНАГРО_ЗаполнитьТЧБаза(БазаРаспределения, ТЗБазаПоЗатрате, НеобходимыеДанные) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ЗаполнитьТЧБаза(БазаРаспределения, ТЗБазаПоЗатрате, НеобходимыеДанные);
	КонецЕсли;
КонецПроцедуры

// Процедура заполняет таблицу распределения затрат
//
//  Параметры:
//		БазаРаспределения - ПеречислениеСсылка.ИНАГРО_СпособыРаспределенияЗатрат
//		НеобходимыеДанные - Структура - структура допоплнительных параметров
//
Процедура ИНАГРО_ЗаполнитьТЧРаспределение(БазаРаспределения, НеобходимыеДанные) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ИНАГРО_ЗаполнитьТЧРаспределение(БазаРаспределения, НеобходимыеДанные);
	КонецЕсли;
КонецПроцедуры

// Процедура рассчитывает НДФЛ для таблицы
//
//  Параметры:
//		ТаблицаКонтрагентов - ТаблицаЗначений
//		Дата                - Дата
//      СтавкаПодоходный    - Число - основная ставка НДФЛ
//
Процедура РассчитатьНДФЛДляТаблицы(ТаблицаКонтрагентов, Дата, СтавкаПодоходный) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.РассчитатьНДФЛДляТаблицы(ТаблицаКонтрагентов, Дата, СтавкаПодоходный);
	КонецЕсли;
КонецПроцедуры

// Процедура рассчитывает НДФЛ для таблицы обратым методом
//
//  Параметры:
//		ТаблицаКонтрагентов - ТаблицаЗначений
//		Дата                - Дата
//      СтавкаНДФЛ          - Число - ставка НДФЛ основная 
//  	СтавкаВС            - Число - ставка НДФЛ военного сбора
//
Процедура РассчитатьНДФЛДляТаблицыОбратный(ТаблицаКонтрагентов, Дата, СтавкаНДФЛ, СтавкаВС) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.РассчитатьНДФЛДляТаблицыОбратный(ТаблицаКонтрагентов, Дата, СтавкаНДФЛ, СтавкаВС);
	КонецЕсли;
КонецПроцедуры

// Загружает таблицы документа в таблицы соответствующие структуре регистров.
//
//	Параметры:
//		Движение                 - движение документа (т.е. регистр)
//		СтруктураТаблицДокумента - структура содержащая таблицы документа. ключ - имя таблицы, значение - таблица значений с данными документа.
//
//	Возвращаемое значение:
//		Структура, в которой ключ - это имя таблицы документа, соответствующий параметру СтруктураТаблицДокумента,
//		  значение - таблица значений, со структурой соответствующей структуре параметра (т.е. регистра) Движение
//		  В таблицы значений данные загружаются по соответствию с имен полей.
//
Функция ЗагрузитьТаблицыДокументаВСтруктуру(Движение, СтруктураТаблицДокумента) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Возврат Обр.ЗагрузитьТаблицыДокументаВСтруктуру(Движение, СтруктураТаблицДокумента);
	КонецЕсли;
КонецФункции

// Заполняет структуру таблиц документа, значением которое будет одинаковым для всех таблиц (например значением шапки документа).
//
//	Параметры:
//		СтруктураТаблицДокумента - Структура, структура таблиц документа, сформированная функцией ЗагрузитьТаблицыДокументаВСтруктуру()
//		ИмяПоля                  - имя колонки в таблицах документа, в которую будет установлено новое значение
//		УстанавливаемоеЗначение  - значение, которое надо установить в таблицы документа
//		СтрТабЧасти              - Строка, имена таб. частей документа в которые необходимо установить новое значение
//
Процедура УстановитьЗначениеВТаблицыДокумента(СтруктураТаблицДокумента, ИмяПоля, УстанавливаемоеЗначение, СтрТабЧасти = "") Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.УстановитьЗначениеВТаблицыДокумента(СтруктураТаблицДокумента, ИмяПоля, УстанавливаемоеЗначение, СтрТабЧасти);
	КонецЕсли;
КонецПроцедуры

// Формирует движение в регистр на основании данных в таблицах документов.
//
//	Параметры:
//		Движение                 - движение документа, в которое необходимо произвести добавление записей (т.е. регистр)
//		ВидДвижения              - ВидДвиженияНакопления - (приход/расход)
//		СтруктураТаблицДокумента - Структура - структура таблиц документа, сформированная функцией ЗагрузитьТаблицыДокументаВСтруктуру()
//		ДатаДвижения             - Дата на которую будут формироваться записи.
//
Процедура ЗаписатьТаблицыДокументаВРегистр(Движение, ВидДвижения, СтруктураТаблицДокумента, ДатаДвижения) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ЗаписатьТаблицыДокументаВРегистр(Движение, ВидДвижения, СтруктураТаблицДокумента, ДатаДвижения);
	КонецЕсли;
КонецПроцедуры

// Устанавливает префикс источника подписки в соответствии с префиксом информационной базы и префиксом организации.
// Источник подписки должен содержать обязательный реквизит шапки "Организация", тип: "СправочникСсылка.Организации".
//
//  Параметры:
// 		Источник             - Источник события подписки.
//  	СтандартнаяОбработка - Булево - флаг стандартной обработки подписки
//  	Префикс              - Строка - префикс объекта, который нужно изменить
//
Процедура УстановитьПрефиксИнформационнойБазыИОрганизации(Источник, СтандартнаяОбработка, Префикс) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.УстановитьПрефиксИнформационнойБазыИОрганизации(Источник, СтандартнаяОбработка, Префикс);
	КонецЕсли;
КонецПроцедуры

// Заполняет субконто ТЧ распределения
//
// Параметры:
//	Получатель
//	Источник
//
Процедура ЗаполнитьСубконтоТЧРаспределение(Получатель, Источник) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Обр.ЗаполнитьСубконтоТЧРаспределение(Получатель, Источник);
	КонецЕсли;
КонецПроцедуры

// Функция возвращает состав затратных счетов
// 
// 
Функция ИНАГРО_СписокСчетовЗатрат() Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Возврат Обр.ИНАГРО_СписокСчетовЗатрат();
	КонецЕсли;
КонецФункции

// Проверяет находится ли счет в иерархии списка счетов
//
//	Параметры:
//	 Счет 		  - счет
//   СписокСчетов - список счетов для проверки.
//
//  ВозвращаемоеЗначение: Ложь или Истина
Функция ИНАГРО_СчетВСпискеПоИерархии(Счет, СписокСчетов) Экспорт
	Обр = ИНАГРО_ДирективыПрепроцессору.ИНАГРО_ВызовЗащищеннойОбработки("ИНАГРО_ОбщийСервер");
	Если Обр <> Неопределено Тогда
		Возврат Обр.ИНАГРО_СчетВСпискеПоИерархии(Счет, СписокСчетов);
	КонецЕсли;
КонецФункции

