#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//Требование
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Требование";
	КомандаПечати.Представление = НСтр("ru = 'Требование'; uk = 'Вимога'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Требование'; uk = 'Вимога'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка";
	
	//Накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Накладная";
	КомандаПечати.Представление = НСтр("ru='Накладная 110';uk='Накладна 110'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокументаОбщая";
	
	//Распоряжение
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Распоряжение";
	КомандаПечати.Представление = НСтр("ru = 'Распоряжение'; uk = 'Розпорядження'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Распоряжение'; uk = 'Розпорядження'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка";
	
	//ЗаборонаяКарта
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_ЗаборнаяКарта";
	КомандаПечати.Представление = НСтр("ru = 'Забороная Карта'; uk = 'Забірна картка'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Забороная Карта'; uk = 'Забірна картка'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка";
	
	// Рапорт
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Рапорт";
	КомандаПечати.Представление = НСтр("ru = 'Рапорт'; uk = 'Рапорт'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Рапорт'; uk = 'Рапорт'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка";
	
	// Накладная112
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Накладная112";
	КомандаПечати.Представление = НСтр("ru = 'Накладная 112'; uk = 'Накладна 112'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Накладная 112'; uk = 'Накладна 112'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка";
	
	// Накладная115
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_Накладная115";
	КомандаПечати.Представление = НСтр("ru = 'Накладная 115'; uk = 'Накладна 115'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Накладная 115'; uk = 'Накладна 115'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Переработка""';uk='Реєстр документів ""Переробка""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
			
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета Требование формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Требование") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ПФ_MXL_Требование", НСтр("ru='Требование';uk='Вимога'"), 
		ПечатьТребование(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_Требование", , Истина);
		
	КонецЕсли; 	

	  // Проверяем, нужно ли для макета Накладная формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная", НСтр("ru='Накладная(форма 110)';uk='Накладна(форма 110)'"), 
		ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_Накладная", , Истина);
		
	КонецЕсли;
	
	// Проверяем, нужно ли для макета Распоряжение формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Распоряжение") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_Распоряжение", НСтр("ru='Распоряжение';uk='Розпорядження'"), 
		ПечатьРаспоряжение(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_Распоряжение", , Истина);
		
	КонецЕсли;
	
	// Проверяем, нужно ли для макета ЗаборонаяКарта формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаборнаяКарта") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаборнаяКарта", НСтр("ru='Забороная Карта';uk='Забірна картка'"), 
		ПечатьЗаборонаяКарта(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_ЗаборнаяКарта", , Истина);
		
	КонецЕсли;
	
	// Проверяем, нужно ли для макета Рапорт формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Рапорт") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_Рапорт", НСтр("ru='Рапорт';uk='Рапорт'"), 
		ПечатьРапорт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_Рапорт", , Истина);
		
	КонецЕсли;
	
	// Проверяем, нужно ли для макета Накладная112 формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная112") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная112", НСтр("ru='Накладная(форма 112)';uk='Накладна(форма 112)'"), 
		ПечатьНакладная112(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_Накладная112", , Истина);
		
	КонецЕсли;
	
	// Проверяем, нужно ли для макета Накладная112 формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная115") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_Накладная115", НСтр("ru='Накладная(форма 115)';uk='Накладна(форма 115)'"), 
		ПечатьНакладная115(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_Переработка.ПФ_MXL_Накладная115", , Истина);
		
	КонецЕсли;
	
КонецПроцедуры // Печать

Функция ПечатьТребование(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_Требование");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_ПереработкаСырье.Коэффициент,
		|	ИНАГРО_ПереработкаСырье.Себестоимость КАК Цена,
		|	ИНАГРО_ПереработкаСырье.Номенклатура,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_ПереработкаСырье.Ссылка КАК Ссылка,
		|	ИНАГРО_ПереработкаСырье.Влажность,
		|	ИНАГРО_Переработка.Организация,
		|	ИНАГРО_Переработка.Владелец,
		|	ИНАГРО_ПереработкаСырье.НомерСтроки КАК НомерСтроки,
		|	ИНАГРО_ПереработкаСырье.ФизическийВес КАК Вес,
		|	ИНАГРО_ПереработкаСырье.СорнаяПримесь КАК СорнаяПримесь,
		|	ИНАГРО_ПереработкаСырье.Сумма,
		|	ИНАГРО_ПереработкаСырье.Количество
		|ИЗ
		|	Документ.ИНАГРО_Переработка.Сырье КАК ИНАГРО_ПереработкаСырье
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ПО ИНАГРО_ПереработкаСырье.Ссылка = ИНАГРО_Переработка.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаСырье.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
	Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли;
		
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			Область.Параметры.Цена = ВыборкаВнутр.Цена;
			ТабДокумент.Вывести(Область);		
		КонецЦикла;		
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		Дно.Параметры.ИтогВес = Запрос.Выполнить().Выгрузить().Итог("Вес");
		ТабДокумент.Вывести(Дно);
		
		ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		
		КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_Накладная");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_Переработка.Организация,
		|	ИНАГРО_Переработка.Склад,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_ПереработкаСырье.Номенклатура,
		|	ИНАГРО_ПереработкаСырье.Количество,
		|	ИНАГРО_ПереработкаСырье.Влажность,
		|	ИНАГРО_ПереработкаСырье.СорнаяПримесь
		|ИЗ
		|	Документ.ИНАГРО_Переработка.Сырье КАК ИНАГРО_ПереработкаСырье
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ПО ИНАГРО_ПереработкаСырье.Ссылка = ИНАГРО_Переработка.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаСырье.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	ИНАГРО_ПереработкаСырье.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
		Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли;
	
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			ТабДокумент.Вывести(Область);		
		КонецЦикла;		
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		Дно.Параметры.Заполнить(ВыборкаСсылка);
		ТабДокумент.Вывести(Дно);
		
		 ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		//ТабДокумент.Вывести(Область);
		
		
		КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьРаспоряжение(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_Распоряжение");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_Переработка.Организация,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_Переработка.Склад,
		|	ИНАГРО_ПереработкаСырье.Номенклатура,
		|	ВЫБОР
		|		КОГДА ИНАГРО_ПереработкаСырье.ЕдиницаИзмерения = ИНАГРО_ПереработкаСырье.Номенклатура.БазоваяЕдиницаИзмерения
		|			ТОГДА ИНАГРО_ПереработкаСырье.ФизическийВес
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Вес,
		|	ИНАГРО_ПереработкаСырье.ЛабораторныйАнализ.Влажность КАК Влажность,
		|	ИНАГРО_ПереработкаСырье.ЛабораторныйАнализ.СорнаяПримесь КАК СорнаяПримесь,
		|	ИНАГРО_ПереработкаСырье.ЛабораторныйАнализ.ЗерноваяПримесь КАК ЗерноваяПримесь 
		|ИЗ
		|	Документ.ИНАГРО_Переработка.Сырье КАК ИНАГРО_ПереработкаСырье
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ПО ИНАГРО_ПереработкаСырье.Ссылка = ИНАГРО_Переработка.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаСырье.Ссылка В(&МассивОбъектов)
		|ИТОГИ
		|	СУММА(Вес)
		|ПО
		|	ИНАГРО_ПереработкаСырье.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
		Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли;
		
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			ТабДокумент.Вывести(Область);		
		КонецЦикла;		
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		//Дно.Параметры.ИтогВес = ВыборкаСсылка.Вес;
		ТабДокумент.Вывести(Дно);
		
		ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		
	КонецЦикла;
	
	
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьЗаборонаяКарта(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_ЗаборнаяКарта");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_Переработка.Организация.НаименованиеПолное КАК Организация,
		|	ИНАГРО_Переработка.Склад,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_ПереработкаСырье.ФизическийВес КАК Количество,
		|	ИНАГРО_ПереработкаСырье.Влажность,
		|	ИНАГРО_ПереработкаСырье.СорнаяПримесь,
		|	ИНАГРО_ПереработкаСырье.Количество КАК Количество1
		|ИЗ
		|	Документ.ИНАГРО_Переработка.Сырье КАК ИНАГРО_ПереработкаСырье
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ПО ИНАГРО_ПереработкаСырье.Ссылка = ИНАГРО_Переработка.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаСырье.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	ИНАГРО_ПереработкаСырье.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
		Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли;
	
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			ТабДокумент.Вывести(Область);		
		КонецЦикла;		
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		Дно.Параметры.Заполнить(ВыборкаВнутр);
		Итого = Запрос.Выполнить().Выгрузить().Итог("Количество");
		Дно.Параметры.ИтогКоличество = Итого;
		Дно.Параметры.ИтогКоличествопрописью = ЧислоПрописью(Итого,"Л="+Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ТабДокумент.Вывести(Дно);
		
		 ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		//ТабДокумент.Вывести(Область);
		
		
		КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьРапорт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_Рапорт");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_Переработка.Организация,
		|	ИНАГРО_Переработка.Склад,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_ПереработкаСырье.Номенклатура,
		|	ИНАГРО_ПереработкаСырье.Количество,
		|	ИНАГРО_ПереработкаСырье.Влажность,
		|	ИНАГРО_ПереработкаСырье.СорнаяПримесь
		|ИЗ
		|	Документ.ИНАГРО_Переработка.Сырье КАК ИНАГРО_ПереработкаСырье
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ПО ИНАГРО_ПереработкаСырье.Ссылка = ИНАГРО_Переработка.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаСырье.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	ИНАГРО_ПереработкаСырье.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
		Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли;
	
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			ТабДокумент.Вывести(Область);		
		КонецЦикла;		
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		Дно.Параметры.Заполнить(ВыборкаСсылка);
		ТабДокумент.Вывести(Дно);
		
		 ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		//ТабДокумент.Вывести(Область);
		
		
		КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьНакладная112(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_Накладная112");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_Переработка.Склад,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_ПереработкаПродукция.Номенклатура КАК Продукция,
		|	ИНАГРО_ПереработкаПродукция.Количество КАК КвоПродукции,
		|	ИНАГРО_ПереработкаПродукция.ФизическийВес КАК ВесПродукции,
		|	ИНАГРО_ПереработкаПродукция.Влажность,
		|	ИНАГРО_ПереработкаПродукция.СорнаяПримесь,
		|	ИНАГРО_Переработка.Организация.НаименованиеПолное КАК Организация
		|ИЗ
		|	Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка.Продукция КАК ИНАГРО_ПереработкаПродукция
		|		ПО ИНАГРО_Переработка.Ссылка = ИНАГРО_ПереработкаПродукция.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаПродукция.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	ИНАГРО_ПереработкаПродукция.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
		Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли;
	
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		Шапка.Параметры.Организация = ВыборкаВнутр.Организация;
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			ТабДокумент.Вывести(Область);		
		КонецЦикла;		
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		Дно.Параметры.Заполнить(ВыборкаСсылка);
		Дно.Параметры.ИтогКвоПродукции = Запрос.Выполнить().Выгрузить().Итог("КвоПродукции");
		Дно.Параметры.ИтогВесПродукции = Запрос.Выполнить().Выгрузить().Итог("ВесПродукции");
		ТабДокумент.Вывести(Дно);
		
		 ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		
		КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьНакладная115(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Переработка";
	
	Макет = ПолучитьМакет("ПФ_MXL_Накладная115");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_ПереработкаСырье.Коэффициент,
		|	ИНАГРО_ПереработкаСырье.ЛабораторныйАнализ,
		|	ИНАГРО_ПереработкаСырье.Себестоимость,
		|	ИНАГРО_ПереработкаСырье.Номенклатура КАК Номенклатура,
		|	ИНАГРО_Переработка.Номер КАК НомерДок,
		|	ИНАГРО_Переработка.Дата КАК ДатаДок,
		|	ИНАГРО_ПереработкаСырье.Ссылка КАК Ссылка,
		//|	ИНАГРО_ПереработкаСырье.СтатьяПриростаУбылиЗапасов,
		|	ИНАГРО_ПереработкаСырье.НомерАнализа,
		|	ИНАГРО_ПереработкаСырье.Влажность,
		|	ИНАГРО_Переработка.Организация,
		|	ИНАГРО_Переработка.Склад,
		|	ИНАГРО_ПереработкаСырье.Количество КАК Кол,
		|	ИНАГРО_ПереработкаСырье.ЗачетныйВес КАК Вес
		|ИЗ
		|	Документ.ИНАГРО_Переработка.Сырье КАК ИНАГРО_ПереработкаСырье
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_Переработка КАК ИНАГРО_Переработка
		|		ПО ИНАГРО_ПереработкаСырье.Ссылка = ИНАГРО_Переработка.Ссылка
		|ГДЕ
		|	ИНАГРО_ПереработкаСырье.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		ВыборкаВнутр = ВыборкаСсылка.Выбрать();
		
		Если НЕ ВыборкаВнутр.Следующий() Тогда
			Продолжить;	
		КонецЕсли; 
		
		// Шапка
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаВнутр);
		ТабДокумент.Вывести(Шапка);
		
		// Строка
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаВнутр.Сбросить();
		Пока ВыборкаВнутр.Следующий() Цикл
			Область.Параметры.Заполнить(ВыборкаВнутр);
			Область.Параметры.КвоШт = ВыборкаВнутр.Кол;
			Область.Параметры.Кво = ВыборкаВнутр.Вес;
			ТабДокумент.Вывести(Область);		
		КонецЦикла;	
		
		// Дно
		Дно	= Макет.ПолучитьОбласть("Дно");
		Дно.Параметры.Заполнить(ВыборкаСсылка);
		Итого = Запрос.Выполнить().Выгрузить().Итог("Вес");
		Дно.Параметры.ИтогКвоПрописью = ЧислоПрописью(Итого,"Л="+Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ТабДокумент.Вывести(Дно);
		
		// Дно2
		Дно2 = Макет.ПолучитьОбласть("Дно2");
		ТабДокумент.Вывести(Дно2);
		
		 ТабДокумент.ОтображатьСетку = Ложь;
		ТабДокумент.Защита = Ложь;
		ТабДокумент.ТолькоПросмотр = Ложь;
		ТабДокумент.ОтображатьЗаголовки = Ложь;
		//ТабДокумент.Вывести(Область);
		
		
		КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Заполняет счета учета номенклатуры в табличной части документа
//
// Параметры:
// Объект - СправочникСсылка - объект контактной информации
// ИмяТабличнойЧасти - имя табличной части
// СобственноеПодразделение - собственное подразделение.
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти, СобственноеПодразделение) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, ВидОперации, Склад, ОтражатьВБухгалтерскомУчете");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.Вставить("СобственноеПодразделение", СобственноеПодразделение);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, СведенияОНоменклатуре);
	КонецЦикла;

КонецПроцедуры

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - Строка - строка табличной части документа
//  СведенияОНоменклатуре - Структура - структура сведений о номенклатуре, либо структура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, СведенияОНоменклатуре) Экспорт
	
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчетаБУ") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;

	Если ДанныеОбъекта.ОтражатьВБухгалтерскомУчете Тогда
		
		Если  ДанныеОбъекта.СобственноеПодразделение
			И ДанныеОбъекта. ВидОперации = Перечисления.ИНАГРО_ВидыОперацийПереработка.СобственноеСырье Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;				
		Иначе
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетУчетаДоп;				
		КонецЕсли; 	
		
		СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		
	Иначе
		
		СтрокаТабличнойЧасти.СчетУчетаБУ         = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаДокумента"
		И ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;

	ВидОперации = Неопределено; 

	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ВидОперации");
	КонецЕсли;

	// Если документ копируется, то вид формы получаем из копируемого документа.
	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("ЗначениеКопирования")
			И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Параметры.ЗначениеКопирования, "ВидОперации");
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") 
			И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") Тогда
			Если Параметры.ЗначенияЗаполнения.Свойство("ВидОперации") Тогда
				ВидОперации = Параметры.ЗначенияЗаполнения.ВидОперации;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		Если Параметры.Свойство("Основание")
			И ЗначениеЗаполнено(Параметры.Основание) Тогда
			ВидОперации = ОпределитьВидОперацииПоДокументуОснованию(Параметры.Основание);
		КонецЕсли;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ФормыИНАГРО_Переработка = ПолучитьСоответствиеВидовОперацийФормам();
	ВыбраннаяФорма = ФормыИНАГРО_Переработка[ВидОперации];
	Если ВыбраннаяФорма = Неопределено Тогда
		ВыбраннаяФорма = "ФормаДокумента";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьФиксированныйМассивВидовОпераций() Экспорт

	МассивВидовОпераций = Новый Массив;
	СписокВидовОпераций = Новый СписокЗначений;
	
	ЗначенияПеречисления = Метаданные.Перечисления.ИНАГРО_ВидыОперацийПереработка.ЗначенияПеречисления;
	Для Каждого ЗначениеПеречисления Из ЗначенияПеречисления Цикл
		ТекущийВидОперации = Перечисления.ИНАГРО_ВидыОперацийПереработка[ЗначениеПеречисления.Имя];
		МассивВидовОпераций.Добавить(ТекущийВидОперации);
	КонецЦикла;
		
	Возврат Новый ФиксированныйМассив(МассивВидовОпераций);


КонецФункции

Функция ОпределитьВидОперацииПоДокументуОснованию(Основание) Экспорт

	Результат = Перечисления.ИНАГРО_ВидыОперацийПереработка.ДавальческоеСырье;

	Возврат Результат;

КонецФункции

Функция ПолучитьСоответствиеВидовОперацийФормам() Экспорт
	
	ФормыИНАГРО_Переработка = Новый Соответствие;
	
	ФормыИНАГРО_Переработка.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.ДавальческоеСырье, "ФормаДокументаОбщая");
	ФормыИНАГРО_Переработка.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.СобственноеСырье,  "ФормаДокументаОбщая");
	ФормыИНАГРО_Переработка.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.СкладскойУчет,     "ФормаДокументаОбщая");
	
	Возврат ФормыИНАГРО_Переработка;
	
КонецФункции

Функция ПолучитьЗначениеДолиСтоимости(Рецепт, Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
			
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_РецептСписокПродукции.Процент КАК Процент
		|ИЗ
		|	Документ.ИНАГРО_Рецепт.СписокПродукции КАК ИНАГРО_РецептСписокПродукции
		|ГДЕ
		|	ИНАГРО_РецептСписокПродукции.Ссылка = &Ссылка
		|	И ИНАГРО_РецептСписокПродукции.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Ссылка",       Рецепт);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Результат = 100;
	Иначе
		Выборка   = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Результат = Выборка.Процент;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

#КонецОбласти 

#КонецЕсли