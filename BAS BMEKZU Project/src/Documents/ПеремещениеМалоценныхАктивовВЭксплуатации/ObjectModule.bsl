#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мВалютаРегламентированногоУчета;

// Хранит вид МБП
Перем мМБП;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"		  , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                        , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Процедура проверяет правильность заполнения реквизитов документа
//
Функция ПроверкаРеквизитов(Отказ, Заголовок) Экспорт

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("КодОперации", "Перемещение");
	
	// Получим данные учетной политики
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);

	Возврат СтруктураШапкиДокумента;

КонецФункции // ПроверкаРеквизитов()

// Подготовливает таблицу для проведения.
//
Функция ПодготовитьТаблицуПоМалоценнымАктивам(СтруктураШапкиДокумента, Отказ, Заголовок)

    Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.НомерСтроки                                          КАК НомерСтроки,
	|	Док.ФизЛицо                                              КАК ФизЛицо,
	|	Док.Номенклатура                                         КАК Номенклатура,
	|	Док.Номенклатура.БланкСтрогогоУчета			 			 КАК БланкСтрогогоУчета,
	|	ПРЕДСТАВЛЕНИЕ(Док.Номенклатура.БазоваяЕдиницаИзмерения)  КАК БазоваяЕдиницаИзмерения,
	|	Док.ПартияМалоценныхАктивовВЭксплуатации                 КАК ПартияМалоценныхАктивовВЭксплуатации,
	|	Док.НазначениеИспользования.СчетПередачиБУ               КАК СчетПередачиБУ,
	|	Док.НазначениеИспользования.СчетАмортизацииБУ            КАК СчетАмортизацииБУ,
	|	Док.НазначениеИспользования                              КАК НазначениеИспользования,
	|	Док.НазначениеИспользования.Владелец                     КАК ВладелецНазначения,
	|	Док.НазначениеИспользования.СпособОтраженияРасходов      КАК СпособОтраженияРасходов,
	|	Док.НазначениеИспользования.ВидМалоценногоАктива         КАК ВидМалоценногоАктива,
	|	Док.НалоговоеНазначение                             	КАК НалоговоеНазначение,
	|	Док.Количество  * Коэффициент							 КАК Количество,
	|	Док.НазначениеИспользованияНовое                         КАК НазначениеИспользованияНовое,
	|	Док.НазначениеИспользованияНовое.ВидМалоценногоАктива    КАК ВидМалоценногоАктиваНовый,
	|	Док.НазначениеИспользованияНовое.Владелец                КАК ВладелецНазначенияНового,
	|	Док.НазначениеИспользованияНовое.СчетПередачиБУ          КАК СчетПередачиБУНовый,
	|	Док.НазначениеИспользованияНовое.СчетАмортизацииБУ       КАК СчетАмортизацииБУНовый,
	|	Док.НазначениеИспользованияНовое.СпособОтраженияРасходов КАК СпособОтраженияРасходовНовый
	|ИЗ
	|	Документ.ПеремещениеМалоценныхАктивовВЭксплуатации.МалоценныеАктивы КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураШапкиДокумента.Ссылка );
	
	ТаблицаПоМалоценнымАктивам = Запрос.Выполнить().Выгрузить();
	
	
	Возврат ТаблицаПоМалоценнымАктивам;

КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМалоценнымАктивам, Отказ, Заголовок)

	ПроцедурыМалоценныеАктивы.ДвижениеПартийМалоценныхАктивов(СтруктураШапкиДокумента, ТаблицаПоМалоценнымАктивам, Движения.Хозрасчетный, Отказ, Заголовок);
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события ОбработкаПроведения
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураШапкиДокумента = ПроверкаРеквизитов(Отказ, Заголовок);

	ТаблицаПоМалоценнымАктивам = ПодготовитьТаблицуПоМалоценнымАктивам(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Движения по документу.
	Если НЕ Отказ Тогда
		
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМалоценнымАктивам, Отказ, Заголовок);
		
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры	// ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения)

	ТипОснования = ТипЗнч(ДанныеЗаполнения);

	Если ТипОснования = Тип("ДокументСсылка.ПередачаМалоценныхАктивовВЭксплуатацию") Тогда

		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);

		// Заполнение шапки
		Комментарий              = ДанныеЗаполнения.Комментарий;
		УказыватьПартию          = Истина;
		
		// Заполнение табличной части "МалоценныеАктивы"
		Для Каждого СтрокаТЧ Из ДанныеЗаполнения.МалоценныеАктивы Цикл
			
			НоваяСтрока = МалоценныеАктивы.Добавить();
			
			НоваяСтрока.Номенклатура                  = СтрокаТЧ.Номенклатура;
			НоваяСтрока.НазначениеИспользования       = СтрокаТЧ.НазначениеИспользования;
			НоваяСтрока.ФизЛицо 				      = СтрокаТЧ.ФизЛицо;
			НоваяСтрока.ПартияМалоценныхАктивовВЭксплуатации  = ДанныеЗаполнения;
			НоваяСтрока.Количество                    = СтрокаТЧ.Количество;
			НоваяСтрока.ЕдиницаИзмерения              = СтрокаТЧ.ЕдиницаИзмерения;
			НоваяСтрока.Коэффициент              	  = СтрокаТЧ.Коэффициент;
			НоваяСтрока.НазначениеИспользованияНовое  = СтрокаТЧ.НазначениеИспользования;
			
			НоваяСтрока.НалоговоеНазначение       	  = СтрокаТЧ.НалоговоеНазначение;
			
		КонецЦикла;

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ УказыватьПартию И МалоценныеАктивы.Количество() > 0 Тогда
		
		// Очистка реквизита ПартияМалоценныхАктивовВЭксплуатации
		МассивОчистки = Новый Массив(МалоценныеАктивы.Количество());
		МалоценныеАктивы.ЗагрузитьКолонку(МассивОчистки, "ПартияМалоценныхАктивовВЭксплуатации");
		
	КонецЕсли;
	
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	
	Если НЕ ПлательщикНДС Тогда
		
		// организация - не плательщик НДС. Установим во всех ТЧ признак соответствующего учета НДС
		НеОблНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		
		Для каждого СтрокаТЧ  Из МалоценныеАктивы Цикл
		    СтрокаТЧ.НалоговоеНазначение = НеОблНДСДеятельность;
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	
	Если НЕ УказыватьПартию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МалоценныеАктивы.ПартияМалоценныхАктивовВЭксплуатации");
	КонецЕсли;
	
	Для Каждого Строка Из МалоценныеАктивы Цикл
		Если НЕ Строка.НазначениеИспользования.Пустая() Тогда
			
			Если Строка.Номенклатура <> Строка.НазначениеИспользования.Владелец Тогда
				ТекстСообщения = НСтр("ru='Назначение использования, выбранное в строке %1 табличной части, не соответствует номенклатуре %2.';uk='Призначення використання, вибране в рядку %1 табличної частини, не відповідає номенклатурі %2.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки, Строка.Номенклатура);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользования", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.Номенклатура <> Строка.НазначениеИспользованияНовое.Владелец Тогда
				ТекстСообщения = НСтр("ru='Новое назначение использования, выбранное в строке %1 табличной части, не соответствует номенклатуре %2.';uk='Нове призначення використання, обране в рядку %1 табличної частини, що не відповідає номенклатурі %2.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки, Строка.Номенклатура);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НовоеНазначениеИспользования", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользования.СпособОтраженияРасходов.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В назначении использования, выбранном в строке %1 табличной части, не указан способ отражения расходов.';uk='У призначенні використання, вказаному в рядку %1 табличної частини, не зазначений спосіб відображення витрат.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользования", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользованияНовое.СпособОтраженияРасходов.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В новом назначении использования, выбранном в строке %1 табличной части, не указан способ отражения расходов.';uk='У новому призначенні використання, вказаному в рядку %1 табличної частини, не вказаний спосіб відображення витрат.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользованияНовое", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользования.ВидМалоценногоАктива.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В назначении использования, выбранном в строке %1 табличной части, не указан вид малоценного актива.';uk='У призначенні використання, вказаному в рядку %1 табличної частини, не зазначено вид малоцінного активу.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользования", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользованияНовое.ВидМалоценногоАктива.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В новом назначении использования, выбранном в строке %1 табличной части, не указан вид малоценного актива.';uk='У новому призначенні використання, вказаному в рядку %1 табличної частини, не зазначений вид малоцінного активу.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользованияНовое", "Объект", Отказ);
			КонецЕсли;
			
			Если НЕ Строка.НазначениеИспользования.ВидМалоценногоАктива.Пустая() И НЕ Строка.НазначениеИспользованияНовое.ВидМалоценногоАктива.Пустая() И Строка.НазначениеИспользования.ВидМалоценногоАктива <> Строка.НазначениеИспользованияНовое.ВидМалоценногоАктива Тогда
				ТекстСообщения = НСтр("ru='Вид малоценного актива %1 в новом назначении использования, выбранном в строке %2 табличной части, не соответствует виду малоценного актива %3 в старом назначении использования.';uk='Вид малоцінного активу %1 у новому призначенні використання, вказаний в рядку %2 табличної частини, не відповідає виду малоцінного активу %3 в старому призначенні використання.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НазначениеИспользования.ВидМалоценногоАктива, Строка.НомерСтроки, Строка.НазначениеИспользованияНовое.ВидМалоценногоАктива);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользованияНовое", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользования.СчетПередачиБУ.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В назначении использования, выбранном в строке %1 табличной части, не указан счет передачи.';uk='У призначенні використання, вказаному в рядку %1 табличної частини, не вказаний рахунок передачі.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользования", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользованияНовое.СчетПередачиБУ.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В новом назначении использования, выбранном в строке %1 табличной части, не указан счет передачи.';uk='У новому призначенні використання, вказаному в рядку %1 табличної частини, не вказаний рахунок передачі.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользованияНовое", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользования.ВидМалоценногоАктива <> мМБП И Строка.НазначениеИспользования.СчетПередачиБУ.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В назначении использования, выбранном в строке %1 табличной части, не указан счет амортизации.';uk='У призначенні використання, вказаному в рядку %1 табличної частини, не вказаний рахунок амортизації.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользования", "Объект", Отказ);
			КонецЕсли;
			
			Если Строка.НазначениеИспользованияНовое.ВидМалоценногоАктива <> мМБП И Строка.НазначениеИспользованияНовое.СчетПередачиБУ.Пустая() Тогда
				ТекстСообщения = НСтр("ru='В новом назначении использования, выбранном в строке %1 табличной части, не указан счет амортизации.';uk='У новому призначенні використання, вказаному в рядку %1 табличної частини, не вказаний рахунок амортизації.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "МалоценныеАктивы[" + (Формат(Строка.НомерСтроки, "ЧН=; ЧГ=") - 1) + "].НазначениеИспользованияНовое", "Объект", Отказ);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ПлательщикНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МалоценныеАктивы.НалоговоеНазначение");	
	КонецЕсли;		

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////// 
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 
// 

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
мМБП                            = Перечисления.ВидыМалоценныхАктивов.МалоценныйБыстроизнашивающийсяПредмет;

#КонецЕсли