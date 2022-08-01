#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВалютаРегламентированногоУчета;

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"       , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                        , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

Процедура ДвиженияПоРегистрам(РежимПроведения,СтруктураШапкиДокумента, Отказ, Заголовок)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.НомерСтроки                                                             КАК НомерСтроки,
	|	&ПустойДоговор                                                              КАК ДоговорКонтрагента,
	|	Док.Ссылка.Организация                                                      КАК Организация,
	|	Док.Ссылка.Склад                                                            КАК Склад,
	|	Док.Номенклатура                                                            КАК Номенклатура,
	|	Док.Ссылка.ОбъектСтроительства                                              КАК ОбъектСтроительства,
	|	Док.Ссылка.СтатьяЗатрат                                                     КАК СтатьяЗатрат,
	|	Док.Количество * Коэффициент												КАК Количество,
	|	Док.СчетУчетаБУ                                                             КАК СчетУчетаБУ,
	|	Док.Ссылка.СчетУчетаБУОбъектаСтроительства                                  КАК КорСчетСписанияБУ,
	|	Док.Ссылка.ОбъектСтроительства                                              КАК КорСубконтоСписанияБУ1,
	|	Док.Ссылка.СтатьяЗатрат                                                     КАК КорСубконтоСписанияБУ2,
	|	&НомерЖурнала                                                               КАК НомерЖурналаБУ,
	|	Док.Ссылка.ОбъектСтроительства.НалоговоеНазначение.ВидНалоговойДеятельности КАК КорСубконтоСписанияНУ1,
	|	Док.Ссылка.ОбъектСтроительства                                              КАК КорСубконтоСписанияНУ2,
	|	НЕОПРЕДЕЛЕНО                                                                КАК ДокументОприходования,
	|	Док.НалоговоеНазначение                          							КАК НалоговоеНазначение,
	|	Док.Ссылка.ОбъектСтроительства.НалоговоеНазначение                          КАК НалоговоеНазначениеНовое
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж.Оборудование КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка"                         , СтруктураШапкиДокумента.Ссылка );
	Запрос.УстановитьПараметр("НомерЖурнала"                   , НСтр("ru='ОС';uk='ОЗ'",Локализация.КодЯзыкаИнформационнойБазы()));
	Запрос.УстановитьПараметр("ПустойДоговор"                  , Справочники.ДоговорыКонтрагентов.ПустаяСсылка());

	Результат = Запрос.Выполнить();
	ТаблицаДвижений = Результат.Выгрузить();
	ТаблицаДвижений.Колонки.Добавить("Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(ЭтотОбъект, "Регистратор");
	ТаблицаДвижений.Колонки.Добавить("СчетДоходовБУ");
	
	УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(ТаблицаДвижений, Отказ, , НСтр("ru='Передача оборудования в монтаж';uk='Передача устаткування в монтаж'",Локализация.КодЯзыкаИнформационнойБазы()));
	
	// ИНАГРО++
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
		ТаблицаДвижений.Колонки.Добавить("НаправлениеДвижения");
		ТаблицаДвижений.ЗаполнитьЗначения(Справочники.ИНАГРО_ВидыДвиженийВедомости.Списание, "НаправлениеДвижения");
		ИНАГРО_Общий.ИНАГРО_ВедомостьДвиженийРасход(Движения, ТаблицаДвижений, СтруктураШапкиДокумента);	
	КонецЕсли;	
	// ИНАГРО--

КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура") 
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	// Специфические для конкретного документа действия
	СчетаУчета = УправлениеНеоборотнымиАктивами.ПолучитьСчетаУчетаОбъектовСтроительства(Организация, ОбъектСтроительства);

	Если НЕ ЗначениеЗаполнено(СчетУчетаБУОбъектаСтроительства) Тогда
		СчетУчетаБУОбъектаСтроительства = СчетаУчета.СчетУчетаБУ;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ,РежимПроведения)

	Перем Заголовок, СтруктураШапкиДокумента;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
    ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	
	// Получим данные учетной политики
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);

	Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
		Для Каждого Строка Из Оборудование Цикл
			УправлениеНеоборотнымиАктивами.ПроверитьСоответствиеНалоговогоНазначенияОбъектов(Строка.Номенклатура, ОбъектСтроительства, Строка.НалоговоеНазначение, ОбъектСтроительства.НалоговоеНазначение);
		КонецЦикла;
	КонецЕсли;		

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения,СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	 
	Если НЕ ПлательщикНДС Тогда
		
		// организация - не плательщик НДС. Установим во всех ТЧ признак соответствующего учета НДС
		НеОблНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		
		Для каждого СтрокаТЧ  Из Оборудование Цикл
		    СтрокаТЧ.НалоговоеНазначение = НеОблНДСДеятельность;
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
#КонецЕсли
