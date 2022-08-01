#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда	

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		// Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда
			
			ДвиженияРегистров()
			
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

#КонецОбласти

#Область Проведение

// Формирует запрос по шапке документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса
Функция СформироватьЗапросПоШапке()
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("парамГоловнаяОрганизация",	Организация);
	Запрос.УстановитьПараметр("парамСсылка",	Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	ВЫБОР
	|		КОГДА Договор.Сотрудник.ГоловнаяОрганизация = &парамГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	ЛОЖЬ КАК ОшибкаСотрудникНеДоговорник
	|ИЗ
	|	Документ.ИНАГРО_ДоговорНаВыполнениеРаботСФизЛицом КАК Договор
	|ГДЕ
	|	Договор.Ссылка = &парамСсылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПоШапке()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен некорректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)
	
	Если ВыборкаПоШапкеДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ТекстСообщения = НСтр("ru='Указан сотрудник другой организации!';uk='Вказаний співробітник іншої організації!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,,,Отказ);
	КонецЕсли;
	
	Если ВыборкаПоШапкеДокумента.ОшибкаСотрудникНеДоговорник Тогда
		ТекстСообщения = НСтр("ru='Указан сотрудник, не являющийся договорником!';uk='Вказаний співробітник не є договірником!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,,,Отказ);
	КонецЕсли;
	
	// ДатаНачала
	Если ДатаНачала > ДатаОкончания Тогда
		ТекстСообщения = НСтр("ru='Неверно указаны даты договора!';uk='Невірно вказані дати договору!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,,,Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

Процедура ДвиженияРегистров()
	
	Движения.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций.Записывать = Истина;
	Движение = Движения.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций.Добавить();
	
	Если ХарактерОплаты = Перечисления.ИНАГРО_ХарактерВыплатыПоДоговору.Ежемесячно Тогда
		Движение.Период			= ДатаНачала;
	Иначе
		Движение.Период			= Макс(НачалоМесяца(ДатаОкончания), ДатаНачала);   
	КонецЕсли;
	
	// Измерения
	Движение.Сотрудник		= Сотрудник;
	Движение.Организация	= Организация;
	Движение.ВидНачисления 	= Перечисления.ИНАГРО_ВидыНачисленийРаботникаОрганизации.ПустаяСсылка();
	Движение.ДокументОснование = Ссылка;
	
	// Ресурсы
	Движение.ВидРасчета		= ВидРасчета;
	Движение.Действует		= Истина;
	Движение.Действие		= Перечисления.ВидыДействияСНачислением.Начать;
	Движение.Показатель1	= СуммаЗаРаботу;
	Движение.СпособОтраженияВБухучете	= СпособОтраженияВБухучете;
	// Реквизиты
	
	Если ЗначениеЗаполнено(ДатаОкончания) Тогда
		Движение = Движения.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций.Добавить();
		Движение.Период 	= КонецДня(ДатаОкончания);
		
		// Измерения
		Движение.Сотрудник			= Сотрудник;
		Движение.Организация		= Организация;
		Движение.ВидНачисления 		= Перечисления.ИНАГРО_ВидыНачисленийРаботникаОрганизации.ПустаяСсылка();
		Движение.ДокументОснование 	= Ссылка;
		
		Движение.ВидРасчета	= ВидРасчета;
		Движение.Действие	= Перечисления.ВидыДействияСНачислением.Прекратить;
		Движение.Действует	= Ложь;
	КонецЕсли;	
	
	// Взносы в фонды
	Если НазначитьВзносы Тогда
		ЗапросВзносы = Новый Запрос;
		ЗапросВзносы.УстановитьПараметр("Сотрудники", ?(ЗначениеЗаполнено(Сотрудник.ОсновноеНазначение),Сотрудник.ОсновноеНазначение,Сотрудник));
		ЗапросВзносы.УстановитьПараметр("Организация",	Организация);
		ЗапросВзносы.УстановитьПараметр("Дата",			ДатаНачала);
		
		СписокВзносов = Новый СписокЗначений;
		СписокВзносов.Добавить (Справочники.Налоги.ЕСВГПХ);
		ЗапросВзносы.УстановитьПараметр("Взносы", СписокВзносов);
		
		Если ЗначениеЗаполнено(Сотрудник.ИНАГРО_ГруппаВзносов) Тогда
			ЗапросВзносы.УстановитьПараметр("Группа", Сотрудник.ИНАГРО_ГруппаВзносов);
		Иначе
			ЗапросВзносы.УстановитьПараметр("Группа", Справочники.ИНАГРО_ГруппыВзносовВФонды.Договорники);
		КонецЕсли;	
		
		ЗапросВзносы.Текст = 
		"ВЫБРАТЬ
		|	Взносы.Сотрудник,
		|	Взносы.Налог,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(Взносы.Было) = ЛОЖЬ
		|				И МАКСИМУМ(Взносы.Стало) = ИСТИНА
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДействияСНачислением.Начать)
		|		КОГДА МАКСИМУМ(Взносы.Было) = ИСТИНА
		|				И МАКСИМУМ(Взносы.Стало) = ЛОЖЬ
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДействияСНачислением.НеИзменять)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыДействияСНачислением.НеИзменять)
		|	КОНЕЦ КАК Действие,
		|	&Дата КАК ДатаДействия
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВзносыВФондыРаботниковОрганизацийСрезПоследних.Сотрудник КАК Сотрудник,
		|		ВзносыВФондыРаботниковОрганизацийСрезПоследних.Налог КАК Налог,
		|		ИСТИНА КАК Было,
		|		ЛОЖЬ КАК Стало
		|	ИЗ
		|		РегистрСведений.ИНАГРО_ВзносыВФондыРаботниковОрганизаций.СрезПоследних(
		|				&Дата,
		|				Сотрудник В (&Сотрудники)
		|					И Налог В (&Взносы)) КАК ВзносыВФондыРаботниковОрганизацийСрезПоследних
		|	ГДЕ
		|		ВзносыВФондыРаботниковОрганизацийСрезПоследних.Действует
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	 ВЫБРАТЬ
		|		Сотрудники.Ссылка,
		|		ВзносыВФондыПоГруппам.Налог,
		|		ЛОЖЬ,
		|		ИСТИНА
		|	 ИЗ
		|	    Справочник.Сотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_ВзносыВФондыПоГруппам.СрезПоследних(&Дата) КАК ВзносыВФондыПоГруппам
		|		ПО ИСТИНА
		|	 ГДЕ ВзносыВФондыПоГруппам.ГруппаВзносов = &Группа
		|		И ВзносыВФондыПоГруппам.Налог В (&Взносы)
		|		И ВзносыВФондыПоГруппам.Действует
		|		И Сотрудники.Ссылка В (&Сотрудники)
		|	 ) КАК Взносы
		|   ГДЕ НЕ Взносы.Было
		|
		|СГРУППИРОВАТЬ ПО
		|	Взносы.Сотрудник,
		|	Взносы.Налог";
		
		ВыборкаПоВзносам = ЗапросВзносы.Выполнить().Выбрать();
		Движения.ИНАГРО_ВзносыВФондыРаботниковОрганизаций.Записывать = Истина;
		Пока ВыборкаПоВзносам.Следующий() Цикл
			Если ВыборкаПоВзносам.Действие = Перечисления.ВидыДействияСНачислением.Начать Тогда
				
				Движение = Движения.ИНАГРО_ВзносыВФондыРаботниковОрганизаций.Добавить();
				
				Движение.Период       = НачалоМесяца(ВыборкаПоВзносам.ДатаДействия);
				// Измерения
				Движение.Организация  = Организация;
				Движение.Сотрудник    = ВыборкаПоВзносам.Сотрудник;
				Движение.Налог		  = ВыборкаПоВзносам.Налог;
				Движение.Действует	= Истина;
			ИначеЕсли ВыборкаПоВзносам.Действие = Перечисления.ВидыДействияСНачислением.Прекратить Тогда
				
				Движение = Движения.ИНАГРО_ВзносыВФондыРаботниковОрганизаций.Добавить();
				
				Движение.Период       = ВыборкаПоВзносам.ДатаДействия-1;
				// Измерения
				Движение.Организация  = Организация;
				Движение.Сотрудник    = ВыборкаПоВзносам.Сотрудник;
				Движение.Налог		  = ВыборкаПоВзносам.Налог;
				Движение.Действует = Ложь;	
			ИначеЕсли ВыборкаПоВзносам.Действие = Перечисления.ВидыДействияСНачислением.НеИзменять Тогда
				ТекстСообщения = НСтр("ru='На дату начала договора сотруднику уже назначено удержание взноса ';uk='На дату початку договору працівнику вже призначене утримання внеску '") + ВыборкаПоВзносам.Налог.Наименование;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,,,);
			КонецЕсли;	
		КонецЦикла;	
		
		
		СписокВзносов = Новый СписокЗначений;
		Если ВидВзносаФОТ.Пустая() Тогда      
			СписокВзносов.Добавить (Справочники.Налоги.ЕСВФОТГПХ);
		Иначе
			СписокВзносов.Добавить (ВидВзносаФОТ);
		КонецЕсли;
		ЗапросВзносы.УстановитьПараметр("Взносы", СписокВзносов);
		ВыборкаПоВзносам = ЗапросВзносы.Выполнить().Выбрать();
		Пока ВыборкаПоВзносам.Следующий() Цикл
			Если ВыборкаПоВзносам.Действие = Перечисления.ВидыДействияСНачислением.Начать Тогда
				
				Движение = Движения.ИНАГРО_ВзносыВФондыРаботниковОрганизаций.Добавить();
				
				Движение.Период       = НачалоМесяца(ВыборкаПоВзносам.ДатаДействия);
				// Измерения
				Движение.Организация  = Организация;
				Движение.Сотрудник    = ВыборкаПоВзносам.Сотрудник;
				Движение.Налог		  = ВыборкаПоВзносам.Налог;
				Движение.Действует	= Истина;
				
			ИначеЕсли ВыборкаПоВзносам.Действие = Перечисления.ВидыДействияСНачислением.Прекратить Тогда
				
				Движение = Движения.ИНАГРО_ВзносыВФондыРаботниковОрганизаций.Добавить();
				
				Движение.Период       = ВыборкаПоВзносам.ДатаДействия-1;
				// Измерения
				Движение.Организация  = Организация;
				Движение.Сотрудник    = ВыборкаПоВзносам.Сотрудник;
				Движение.Налог		  = ВыборкаПоВзносам.Налог;
				Движение.Действует = Ложь;	
				
			ИначеЕсли ВыборкаПоВзносам.Действие = Перечисления.ВидыДействияСНачислением.НеИзменять Тогда
				ТекстСообщения = НСтр("ru='На дату начала договора сотруднику уже назначено удержание взноса ';uk='На дату початку договору працівнику вже призначене утримання внеску '") + ВыборкаПоВзносам.Налог.Наименование;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,,,);
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
