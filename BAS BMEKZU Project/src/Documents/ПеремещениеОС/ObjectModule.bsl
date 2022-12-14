#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Перем АмортизацияБА Экспорт; // ИНАГРО
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура проверяет правильность заполнения реквизитов документа
//
Процедура ПроверкаРеквизитовТЧ(ТаблицаОС,СтруктураШапкиДокумента,Отказ, Заголовок) Экспорт

	
	// Проверим соответствие организаций ОС и организации документа

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокОС"      , ТаблицаОС.ВыгрузитьКолонку("ОсновноеСредство"));
	Запрос.УстановитьПараметр("ВыбОрганизация", СтруктураШапкиДокумента.Организация);
	Запрос.УстановитьПараметр("Период"     , Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	МестонахождениеОСБухгалтерскийУчет.Организация КАК Организация,
	|	ОсновныеСредства.Код                           КАК Инв,
	|	ОсновныеСредства.Ссылка                        КАК ОсновноеСредство,
	|	Представление(ОсновныеСредства.Ссылка)         КАК ОсновноеСредствоПредставление
	|
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&Период, (ОсновноеСредство В(&СписокОС) И Организация = &ВыбОрганизация)) КАК МестонахождениеОСБухгалтерскийУчет
	|		ПО ОсновныеСредства.Ссылка = МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство
	|
	|ГДЕ
	|	ОсновныеСредства.Ссылка В(&СписокОС) И
	|	НЕ ОсновныеСредства.ЭтоГруппа И
	|	МестонахождениеОСБухгалтерскийУчет.Организация ЕСТЬ NULL";
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() > 0 Тогда

		Отказ = Истина;

		Пока Выборка.Следующий() Цикл
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Бух.учет: Несоответствие ОС ""%1"" инв.№ %2 и организации указанной в документе.';uk='Бух.облік: Невідповідність ОЗ ""%1"" інв.№ %2 і організації вказаної в документі.'"), СокрЛП(Выборка.ОсновноеСредствоПредставление), СокрЛП(Выборка.Инв));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры // ПроверкаРеквизитов()


// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС,Отказ, Заголовок)

	ДатаДока = Дата;

	МестонахождениеОСОрганизаций = Движения.МестонахождениеОСБухгалтерскийУчет;
	ОперацииОС                   = Движения.СобытияОСОрганизаций;

	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл

		Движение = МестонахождениеОСОрганизаций.Добавить();
	
		Движение.Период           = ДатаДока;
		Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
		Движение.Организация      = СтруктураШапкиДокумента.Организация;
		Движение.МОЛ              = СтруктураШапкиДокумента.МОЛОрганизации;
		Движение.Местонахождение  = СтруктураШапкиДокумента.ПодразделениеОрганизации;

		// Движения по регистру СобытияОСОрганизаций
		Движение = ОперацииОС.Добавить();
		Движение.Период				= ДатаДока;
		Движение.ОсновноеСредство	= СтрокаТЧ.ОсновноеСредство;
		Движение.Организация		= СтруктураШапкиДокумента.Организация;
		Движение.Событие 			= СтруктураШапкиДокумента.СобытиеОС;
		Движение.НазваниеДокумента	= Строка(СтруктураШапкиДокумента.Ссылка.Метаданные());
		Движение.НомерДокумента		= СтруктураШапкиДокумента.Номер;
		
	КонецЦикла;

КонецПроцедуры

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
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ОсновноеСредство", "ОсновноеСредство");

	РезультатЗапросаПоОС = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	
	Если Основание.Метаданные().Имя = "ИНАГРО_ПриплодИПривес" ИЛИ Основание.Метаданные().Имя = "ИНАГРО_ИнвентаризацияОС" Тогда
		
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_ИнвентаризацияОС") Тогда 
			МОЛОрганизации = Основание.МОЛ;
		КонецЕсли;		
		
		Для каждого ТекСтрокаОС Из Основание.ОС Цикл
			Если ТекСтрокаОС.НаличиеПоДаннымУчета И НЕ ТекСтрокаОС.НаличиеФактическое Тогда
				НоваяСтрока = ОС.Добавить();
				НоваяСтрока.ОсновноеСредство = ТекСтрокаОС.ОсновноеСредство;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьРеквизитыБА(Параметры) // ИНАГРО
			
	Дата 							 = Параметры.Дата;
	Организация  					 = Параметры.Организация;
	Комментарий  					 = Параметры.Комментарий;
	ИНАГРО_ДокументОперативногоУчета = Параметры.ИНАГРО_ДокументОперативногоУчета;
	ИНАГРО_БиологическийАктив  		 = Параметры.ИНАГРО_БиологическийАктив;
	ИНАГРО_БиологическийАктивНовый   = Параметры.ИНАГРО_БиологическийАктивНовый;
	ИНАГРО_Склад 					 = Параметры.ИНАГРО_Склад;
	ИНАГРО_СкладНовый 				 = Параметры.ИНАГРО_СкладНовый;	
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события "ОбработкаПроведения" документа.
//
Процедура ОбработкаПроведения(Отказ)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоОС; 
	
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
    ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок);
	
	ПроверкаРеквизитовТЧ(ТаблицаПоОС, СтруктураШапкиДокумента,Отказ, Заголовок);
 	
	//проверка, нет ли списанных ОС в табличной части
	УправлениеНеоборотнымиАктивами.ПроверитьНаСписанность(МоментВремени(), Организация, ТаблицаПоОС, Отказ, Заголовок);
	

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС,Отказ, Заголовок);
	КонецЕсли;
	
	// ИНАГРО++
	ДокументБА = Ложь;
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
		ДокументБА = (ЗначениеЗаполнено(ИНАГРО_ДокументОперативногоУчета) И
		ИНАГРО_ДокументОперативногоУчета.Метаданные().Имя = "ИНАГРО_ПеремещениеБиологическихАктивов");	
	КонецЕсли;
	
	Если НЕ Отказ И ДокументБА И АмортизацияБА Тогда  
		
		// Движение в РегистрСведений.ИНАГРО_СоответствиеБАиОС
		
		ТаблицаБА = ЭтотОбъект.ОС.Выгрузить();
		
		ТаблицаБА.Колонки.Добавить("БиологическийАктив");
		ТаблицаБА.ЗаполнитьЗначения(ЭтотОбъект.ИНАГРО_БиологическийАктив, "БиологическийАктив");
		
		ТаблицаБА.Колонки.Добавить("Склад");
		ТаблицаБА.ЗаполнитьЗначения(ЭтотОбъект.ИНАГРО_СкладНовый, "Склад");
		
		ТаблицаБА.Колонки.Добавить("ПодразделениеОрганизации");
		ТаблицаБА.ЗаполнитьЗначения(ЭтотОбъект.ПодразделениеОрганизации, "ПодразделениеОрганизации");
		
		ТаблицаБА.Колонки.Добавить("Организация");
		ТаблицаБА.ЗаполнитьЗначения(ЭтотОбъект.Организация, "Организация");
		
		ТаблицаБА.Колонки.Добавить("ДокументОперативногоУчета");
		ТаблицаБА.ЗаполнитьЗначения(ЭтотОбъект.ИНАГРО_ДокументОперативногоУчета.Ссылка, "ДокументОперативногоУчета");
		
		ТаблицаБА.Колонки.Добавить("СтоимостьБУ");
		ТаблицаБА.Колонки.Добавить("СтоимостьНУ");
		
		МодульИНАГРО_БиологическиеАктивы = ОбщегоНазначения.ОбщийМодуль("ИНАГРО_БиологическиеАктивы");
		МодульИНАГРО_БиологическиеАктивы.РассчитатьСтоимостьОсновныхСредств(Дата, ТаблицаБА, Организация, Истина);		
		МодульИНАГРО_БиологическиеАктивы.СоответствиеБАиОС(Движения, СтруктураШапкиДокумента, ТаблицаБА);		
				
	КонецЕсли;
	// ИНАГРО--

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// ИНАГРО++
	Если АмортизацияБА И ЗначениеЗаполнено(ИНАГРО_ДокументОперативногоУчета) И ИНАГРО_ДокументОперативногоУчета.Проведен Тогда
		
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Удаление запрещено! Документ-основание ""%1"" проведен.';uk='Видалення заборонено! Документ-підстава ""%1"" проведений'"), ИНАГРО_ДокументОперативногоУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		
		Отказ = Истина;			
	КонецЕсли;
	// ИНАГРО--
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ВнутреннееПеремещение);
	КонецЕсли;
	
	// ИНАГРО++
	Если  ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("ИНАГРО_ДокументОперативногоУчета") Тогда
		Если ДанныеЗаполнения.ИНАГРО_ДокументОперативногоУчета.Метаданные().Имя = "ИНАГРО_ПеремещениеБиологическихАктивов" Тогда
			ЗаполнитьРеквизитыБА(ДанныеЗаполнения);
		КонецЕсли;
	КонецЕсли;
	// ИНАГРО--

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

	// ИНАГРО++
	ИНАГРО_ДокументОперативногоУчета = Неопределено;
	ИНАГРО_БиологическийАктив	     = Справочники.БиологическиеАктивы.ПустаяСсылка();
	ИНАГРО_БиологическийАктивНовый   = Справочники.БиологическиеАктивы.ПустаяСсылка();
	ИНАГРО_Склад				     = Справочники.Склады.ПустаяСсылка();		
	ИНАГРО_СкладНовый			     = Справочники.Склады.ПустаяСсылка(); 		
	Комментарий 				     = ""; 	
	// ИНАГРО-- 
	
КонецПроцедуры

// ИНАГРО++
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
	Если Проведен И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения И АмортизацияБА		
		 И ЗначениеЗаполнено(ИНАГРО_ДокументОперативногоУчета) И ИНАГРО_ДокументОперативногоУчета.Проведен Тогда
		  
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Отмена проведения запрещена! Документ-основание ""%1"" проведен.';uk='Вiдміна проведення заборонено! Документ-підстава ""%1"" проведений'"),
			ИНАГРО_ДокументОперативногоУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);        		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

АмортизацияБА = Ложь;
Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
	АмортизацияБА = Константы.ИНАГРО_НачислятьАмортизациюБА.Получить();
КонецЕсли;
// ИНАГРО--

#КонецЕсли

