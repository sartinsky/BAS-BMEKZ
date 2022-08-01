#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНАГРО_РасчетыСВладельцем";
	КомандаПечати.Представление = НСтр("ru='Расчеты с владельцами';uk='Розрахунки з власниками'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Перемещение""';uk='Реєстр документів ""Переміщення""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНАГРО_РасчетыСВладельцем") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ИНАГРО_РасчетыСВладельцем", НСтр("ru='Расчеты с владельцем';uk='Розрахунки з власником'"), 
		ПечатьДокументаРасчетыСВладельцем(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИНАГРО_РасчетыСВладельцем.ПФ_MXL_ИНАГРО_РасчетыСВладельцем19042016", ,Истина);	
	КонецЕсли; 	
	
КонецПроцедуры

Функция ПечатьДокументаРасчетыСВладельцем(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасчетыСВладельцами";
	
	Макет = ПолучитьМакет("ПФ_MXL_РасчетыСВладельцами");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_РасчетыСВладельцем.Дата,
		|	ИНАГРО_РасчетыСВладельцем.Номер,
		|	ИНАГРО_РасчетыСВладельцем.Организация,
		|	ИНАГРО_РасчетыСВладельцем.СкладПолучатель,
		|	ИНАГРО_РасчетыСВладельцем.Контрагент,
		|	ИНАГРО_РасчетыСВладельцем.ОбщийДолг,
		|	ИНАГРО_РасчетыСВладельцем.Ответственный,
		|	ИНАГРО_РасчетыСВладельцем.ТараДолг,
		|	ИНАГРО_РасчетыСВладельцем.РасчетСуммой,
		|	ИНАГРО_РасчетыСВладельцем.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ИНАГРО_РасчетыСВладельцем КАК ИНАГРО_РасчетыСВладельцем
		|ГДЕ
		|	ИНАГРО_РасчетыСВладельцем.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
				
		// Заголовок
		Область = Макет.ПолучитьОбласть("Заголовок");
		ТабДокумент.Вывести(Область);
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаСсылка);
		ТабДокумент.Вывести(Шапка);
				
		// Остатки
		Область = Макет.ПолучитьОбласть("ОстаткиШапка");
		ТабДокумент.Вывести(Область);
		ОбластьОстатки = Макет.ПолучитьОбласть("Остатки");
		
		ВыборкаОстатки = ПолучитьОстаткиДокумента(ВыборкаСсылка.Ссылка);
		
		Пока ВыборкаОстатки.Следующий() Цикл
			ОбластьОстатки.Параметры.Заполнить(ВыборкаОстатки);
			ТабДокумент.Вывести(ОбластьОстатки);  
		КонецЦикла;
		
		// Расчеты
		Область = Макет.ПолучитьОбласть("РасчетыШапка");
		ТабДокумент.Вывести(Область);
		ОбластьРасчеты = Макет.ПолучитьОбласть("Расчеты");

		ВыборкаРасчеты = ПолучитьРасчетыДокумента(ВыборкаСсылка.Ссылка);
		
		Пока ВыборкаРасчеты.Следующий() Цикл
			ОбластьРасчеты.Параметры.Заполнить(ВыборкаРасчеты);
			ТабДокумент.Вывести(ОбластьРасчеты);  
		КонецЦикла;
				
		// Вывоз
		Область = Макет.ПолучитьОбласть("ВывозШапка");
		ТабДокумент.Вывести(Область);
		ОбластьВывоз = Макет.ПолучитьОбласть("Вывоз");
		
		ВыборкаВывоз = ПолучитьВывозДокумента(ВыборкаСсылка.Ссылка);
		Пока ВыборкаВывоз.Следующий() Цикл
			ОбластьВывоз.Параметры.Заполнить(ВыборкаВывоз);
			ТабДокумент.Вывести(ОбластьВывоз);  
		КонецЦикла;		
		
		// Подвал
		Подвал = Макет.ПолучитьОбласть("Подвал");
		Подвал.Параметры.Заполнить(ВыборкаСсылка);
		ТабДокумент.Вывести(Подвал);
		
		ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		//ТабДокумент.Вывести(Область);
		
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции // ()

Функция ПолучитьОстаткиДокумента(Ссылка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_РасчетыСВладельцемОстатки.НомерСтроки,
		|	ИНАГРО_РасчетыСВладельцемОстатки.Номенклатура,
		|	ИНАГРО_РасчетыСВладельцемОстатки.Количество,
		|	ИНАГРО_РасчетыСВладельцемОстатки.Фасовка,
		|	ИНАГРО_РасчетыСВладельцемОстатки.Склад,
		|	ИНАГРО_РасчетыСВладельцемОстатки.Урожай
		|ИЗ
		|	Документ.ИНАГРО_РасчетыСВладельцем.Остатки КАК ИНАГРО_РасчетыСВладельцемОстатки
		|ГДЕ
		|	ИНАГРО_РасчетыСВладельцемОстатки.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
	

КонецФункции 

Функция ПолучитьРасчетыДокумента(Ссылка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_РасчетыСВладельцемРасчеты.НомерСтроки,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Номенклатура,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Количество,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Цена,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Сумма,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Склад,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Урожай,
		|	ИНАГРО_РасчетыСВладельцемРасчеты.ВидХранения
		|ИЗ
		|	Документ.ИНАГРО_РасчетыСВладельцем.Расчеты КАК ИНАГРО_РасчетыСВладельцемРасчеты
		|ГДЕ
		|	ИНАГРО_РасчетыСВладельцемРасчеты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();


КонецФункции

Функция ПолучитьВывозДокумента(Ссылка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_РасчетыСВладельцемВывоз.НомерСтроки,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Номенклатура,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Количество,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Фасовка,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Цена,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Сумма,
		|	ИНАГРО_РасчетыСВладельцемВывоз.ВидФасовки,
		|	ИНАГРО_РасчетыСВладельцемВывоз.КоличествоФасовки,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Тара,
		|	ИНАГРО_РасчетыСВладельцемВывоз.ТараОстаток,
		|	ИНАГРО_РасчетыСВладельцемВывоз.КоличествоТара,
		|	ИНАГРО_РасчетыСВладельцемВывоз.НоменклатураФасовки,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Урожай,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Склад,
		|	ИНАГРО_РасчетыСВладельцемВывоз.НовыйСклад,
		|	ИНАГРО_РасчетыСВладельцемВывоз.Услуга
		|ИЗ
		|	Документ.ИНАГРО_РасчетыСВладельцем.Вывоз КАК ИНАГРО_РасчетыСВладельцемВывоз
		|ГДЕ
		|	ИНАГРО_РасчетыСВладельцемВывоз.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

