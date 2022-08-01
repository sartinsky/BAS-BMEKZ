#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыль"             , УчетнаяПолитика.ПлательщикНалогаНаПрибыль(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                        , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Проверка реквизитов в ТЧ по регл. учету
// 
Процедура ПроверкаРеквизитовТЧРегл(Отказ, Заголовок)

	
	// Проверим соответствие организаций ОС и организации документа
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокОС"      , ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	Запрос.УстановитьПараметр("ВыбОрганизация", Организация);
	Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	МестонахождениеОС.Организация          КАК Организация,
	|	ОсновныеСредства.Код                   КАК Инв,
	|	ОсновныеСредства.Ссылка                КАК ОсновноеСредство,
	|	Представление(ОсновныеСредства.Ссылка) КАК ОсновноеСредствоПредставление
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|ЛЕВОЕ СОЕДИНЕНИЕ 
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|	                &Период,
	|	                (ОсновноеСредство В(&СписокОС) 
	|	                 И Организация = &ВыбОрганизация)) КАК МестонахождениеОС
	|	ПО ОсновныеСредства.Ссылка = МестонахождениеОС.ОсновноеСредство
	|
	|ГДЕ
	|	ОсновныеСредства.Ссылка В(&СписокОС)
	|	И
	|	НЕ ОсновныеСредства.ЭтоГруппа
	|	И
	|	МестонахождениеОС.Организация ЕСТЬ NULL";
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() > 0 Тогда

		Пока Выборка.Следующий() Цикл
			
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Бух.учет: Несоответствие организаций ОС ""%1"" код %2 и организации указанной в документе.';uk='Бух.облік: Невідповідність організацій ОЗ ""%1"" код %2 і організації вказаної в документі.'"), СокрЛП(Выборка.ОсновноеСредствоПредставление), СокрЛП(Выборка.Инв));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
							  
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок)

	ПроверкаРеквизитовТЧРегл(Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок)

	ДатаДока      = Дата;
	
	УправлениеНеоборотнымиАктивами.ДополнитьТабличнуюЧастьСведениямиОбОСБухНалогРегл(МоментВремени(), ТаблицаПоОС,
	                                                  СтруктураШапкиДокумента, 
													  Отказ, Заголовок, , Истина);
	
	ОперацииОСБух = Движения.СобытияОСОрганизаций;
	
	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
		
		Движение = ОперацииОСБух.Добавить();
		
		Движение.Период            = ДатаДока;
		Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
		Движение.Организация       = СтруктураШапкиДокумента.Организация;
		Движение.Событие           = СтруктураШапкиДокумента.СобытиеОС;
		Движение.НазваниеДокумента = Строка(СтруктураШапкиДокумента.Ссылка.Метаданные());
		Движение.НомерДокумента    = СтруктураШапкиДокумента.Номер;
		
	КонецЦикла;
	
	Если СтруктураШапкиДокумента.ВлияетНаНачислениеАмортизации Тогда
		
		НачислениеАмортизацииБух = Движения.НачислениеАмортизацииОСБухгалтерскийУчет;
		
		Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
			
			Движение = НачислениеАмортизацииБух.Добавить();
			
			Движение.Период               = ДатаДока;
			Движение.ОсновноеСредство     = СтрокаТЧ.ОсновноеСредство;
			Движение.Организация          = СтруктураШапкиДокумента.Организация;
			Движение.НачислятьАмортизацию = СтруктураШапкиДокумента.НачислятьАмортизацию;
			
		КонецЦикла;
		
		
		НачислениеАмортизацииНУ = Движения.НачислениеАмортизацииОСНалоговыйУчет;
		
		Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
			
			Непроизводственное = СтрокаТЧ.ВидНалоговойДеятельности_ОС = Справочники.ВидыНалоговойДеятельности.НеОблагаемая;
			НачислятьАмортизациюНУ = СтруктураШапкиДокумента.НачислятьАмортизацию И НЕ Непроизводственное;
			
			Движение = НачислениеАмортизацииНУ.Добавить();
			
			Движение.Период               = ДатаДока;
			Движение.ОсновноеСредство     = СтрокаТЧ.ОсновноеСредство;
			Движение.Организация          = СтруктураШапкиДокумента.Организация;
			Движение.НачислятьАмортизацию = СтруктураШапкиДокумента.НачислятьАмортизацию;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("ВидСобытияОС",СтруктураШапкиДокумента.СобытиеОС.ВидСобытияОС);
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок) Экспорт
	
	// Сформируем структуру табличной части
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ОсновноеСредство" , "ОсновноеСредство");
	
	РезультатЗапросаПоОС = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		Если Основание.ЭтоГруппа Тогда
			ТекстСообщения = НСтр("ru='Ввод изменения состояния ОС на основании группы ОС невозможен!
|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз';uk='Введення зміни стану ОЗ на підставі групи ОЗ неможливий!
|Виберіть ОЗ. Для розкриття групи використовуйте клавіші Ctrl і стрілку вниз'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;

		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание.Ссылка;

	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.НачислениеАмортизации);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	Иначе
		ОтражатьВБухгалтерскомУчете = Истина;
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоОС;

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
	
	ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок);

	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок);
	
	//проверка, нет ли списанных ОС в табличной части
	УправлениеНеоборотнымиАктивами.ПроверитьНаСписанность(МоментВремени(), Организация, ТаблицаПоОС, Отказ, Заголовок);
	

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок);
	КонецЕсли;

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецЕсли