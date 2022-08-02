#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Требование
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Требование";
	КомандаПечати.Представление = НСтр("ru='Требование';uk='Вимога'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаДокументаОбщая";

	// Накладная112
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная112";
	КомандаПечати.Представление = НСтр("ru='Накладная(форма 112)';uk='Накладна(форма 112)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая";
	КомандаПечати.Порядок       = 100;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Акт фасовки""';uk='Реєстр документів ""Акт фасування""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
	// Требование (2021)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Требование_2021";
	КомандаПечати.Представление = НСтр("ru='Требование (2021)';uk='Вимога (2021)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаДокументаОбщая";
	
	// Накладная112
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная112_2021";
	КомандаПечати.Представление = НСтр("ru='Накладная(форма 112) (2021)';uk='Накладна(форма 112) (2021)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая";
	КомандаПечати.Порядок       = 110;


КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Требование") Тогда
		 // Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Требование", НСтр("ru='Требование';uk='Вимога'"), 
			ПечатьТребование(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_АктФасовки.ПФ_MXL_Требование", , Истина);
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная112") Тогда
		 // Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная112", НСтр("ru='Накладная(форма 112)';uk='Накладна(форма 112)'"), 
			ПечатьНакладная112(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_АктФасовки.ПФ_MXL_Накладная112", , Истина);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Требование_2021") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Требование_2021", НСтр("ru='Требование(2021)';uk='Вимога(2021)'"), 
		ПечатьТребование2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_АктФасовки.ПФ_MXL_Требование_2021", , Истина);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная112_2021") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная112_2021", НСтр("ru='Накладная(форма 112) (2021)';uk='Накладна(форма 112) (2021)'"), 
		ПечатьНакладная112_2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_АктФасовки.ПФ_MXL_Накладная112_2021", , Истина);
	КонецЕсли;
		
КонецПроцедуры // Печать

Функция ПечатьТребование2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)

	УстановитьПривилегированныйРежим(Истина);
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_АктФасовки.ПФ_MXL_Требование_2021");
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	ПервыйДокумент = Истина;
	Для каждого Ссылка Из МассивОбъектов Цикл
		Если НЕ ПервыйДокумент Тогда
		     ТабДокумент.ВывестиВертикальныйРазделительСтраниц();
		 КонецЕсли; 
		 ПервыйДокумент = Ложь;

		//Шапка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		|	ИНАГРО_АктФасовки.Организация.НаименованиеПолное КАК Организация,
		|	ИНАГРО_АктФасовки.Номер КАК НомерДок,
		|	ИНАГРО_АктФасовки.Дата КАК ДатаДок,
		|	ИНАГРО_АктФасовки.Владелец.НаименованиеПолное КАК Владелец,
		|	ИНАГРО_АктФасовки.Организация.КодПоЕДРПОУ КАК ЕДРПОУ,
		|	ИНАГРО_АктФасовки.Склад.Наименование КАК Склад
		|ИЗ
		|	Документ.ИНАГРО_АктФасовки КАК ИНАГРО_АктФасовки
		|ГДЕ
		|	ИНАГРО_АктФасовки.Ссылка = &Ссылка";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Заполнить(Шапка);
		ОблШапка.Параметры.ДатаДокДень = Формат(Шапка.ДатаДок, "ДФ='dd'");
		ОблШапка.Параметры.ДатаДокМесяц = Формат(Шапка.ДатаДок, "ДФ='MMMM';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ОблШапка.Параметры.ДатаДокГод = Формат(Шапка.ДатаДок, "ДФ='yyyy'");
		//ОблШапка.Параметры.ДатаРецептаДень = Формат(Шапка.Рецепт.Дата,"ДФ='dd'");
		//ОблШапка.Параметры.ДатаРецептаМесяц = Формат(Шапка.Рецепт.Дата, "ДФ='MMMM';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		//ОблШапка.Параметры.ДатаРецептаГод = Формат(Шапка.Рецепт.Дата, "ДФ='yyyy'");
		//ОблШапка.Параметры.НомерРецепта = Шапка.Рецепт.Номер;
		ТабДокумент.Вывести(ОблШапка);
		
		//Строка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		|	ИНАГРО_АктФасовкиСырье.НомерСтроки КАК НомерСтроки,
		|	ИНАГРО_АктФасовкиСырье.Номенклатура КАК Номенклатура,
		|	ИНАГРО_АктФасовкиСырье.ФизическийВес КАК Вес,
		|	ИНАГРО_АктФасовкиСырье.Влажность КАК Влажность,
		|	ИНАГРО_АктФасовкиСырье.СорнаяПримесь КАК СорнаяПримесь,
		|	ИНАГРО_АктФасовкиСырье.Сумма КАК Сумма,
		|	ИНАГРО_АктФасовкиСырье.НомерАнализа КАК НомерАнализа
		|ИЗ
		|	Документ.ИНАГРО_АктФасовки.Сырье КАК ИНАГРО_АктФасовкиСырье
		|ГДЕ
		|	ИНАГРО_АктФасовкиСырье.Ссылка = &Ссылка";
		Стр = Запрос.Выполнить().Выбрать();
		Пока Стр.Следующий()Цикл
			ОблСтрока = Макет.ПолучитьОбласть("Строка");
			ОблСтрока.Параметры.Заполнить(Стр);
			ТабДокумент.Вывести(ОблСтрока);
		КонецЦикла;
		
		//Дно
		ОблДно = Макет.ПолучитьОбласть("Дно");
		//ОблДно.Параметры.ИтогВес = Запрос.Выполнить().Выгрузить().Итог("Вес");
		ТабДокумент.Вывести(ОблДно);
		КонецЦикла;
		Возврат ТабДокумент;
		
	КонецФункции


Функция ПечатьТребование(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_АктФасовки.ПФ_MXL_Требование");
	// печать производится на языке, указанном в настройках пользователя
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиВертикальныйРазделительСтраниц();
		КонецЕсли; 
		
		ПервыйДокумент = Ложь;
		
		//Шапка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ИНАГРО_АктФасовки.Организация.НаименованиеПолное КАК Организация,
			|	ИНАГРО_АктФасовки.Номер КАК НомерДок,
			|	ИНАГРО_АктФасовки.Дата КАК ДатаДок,
			|	ИНАГРО_АктФасовки.Владелец.НаименованиеПолное КАК Владелец
			|ИЗ
			|	Документ.ИНАГРО_АктФасовки КАК ИНАГРО_АктФасовки
			|ГДЕ
			|	ИНАГРО_АктФасовки.Ссылка = &Ссылка";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Заполнить(Шапка);
		ОблШапка.Параметры.ДатаДок = Формат(Шапка.ДатаДок, "ДФ='дд ММММ гггг';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ТабДокумент.Вывести(ОблШапка);
		
		//Строка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ИНАГРО_АктФасовкиСырье.НомерСтроки КАК НомерСтроки,
			|	ИНАГРО_АктФасовкиСырье.Номенклатура КАК Номенклатура,
			|	ИНАГРО_АктФасовкиСырье.ФизическийВес КАК Вес,
			|	ИНАГРО_АктФасовкиСырье.Влажность КАК Влажность,
			|	ИНАГРО_АктФасовкиСырье.СорнаяПримесь КАК СорнаяПримесь,
			|	ИНАГРО_АктФасовкиСырье.Себестоимость КАК Цена,
			|	ИНАГРО_АктФасовкиСырье.Сумма КАК Сумма
			|ИЗ
			|	Документ.ИНАГРО_АктФасовки.Сырье КАК ИНАГРО_АктФасовкиСырье
			|ГДЕ
			|	ИНАГРО_АктФасовкиСырье.Ссылка = &Ссылка";
		
		Стр = Запрос.Выполнить().Выбрать();
		
		Пока Стр.Следующий()Цикл
			ОблСтрока = Макет.ПолучитьОбласть("Строка");
			ОблСтрока.Параметры.Заполнить(Стр);
			ТабДокумент.Вывести(ОблСтрока);
		КонецЦикла;
		
		//Дно
		ОблДно = Макет.ПолучитьОбласть("Дно");
		ОблДно.Параметры.ИтогВес = Запрос.Выполнить().Выгрузить().Итог("Вес");
		ТабДокумент.Вывести(ОблДно);
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьНакладная112(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_АктФасовки.ПФ_MXL_Накладная112");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиВертикальныйРазделительСтраниц();
		КонецЕсли; 
		ПервыйДокумент = Ложь;
		
		//Макет = ПолучитьМакет("Накладная112");
		
		//Шапка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ИНАГРО_АктФасовки.Организация.НаименованиеПолное КАК Организация,
			|	ИНАГРО_АктФасовки.Номер КАК НомерДок,
			|	ИНАГРО_АктФасовки.Дата КАК ДатаДок
			|ИЗ
			|	Документ.ИНАГРО_АктФасовки КАК ИНАГРО_АктФасовки
			|ГДЕ
			|	ИНАГРО_АктФасовки.Ссылка = &Ссылка";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Заполнить(Шапка);
		ОблШапка.Параметры.Организация = Шапка.Организация;
		//ОблШапка.Параметры.ДатаДок = Формат(Дата, "ДФ='дд ММММ гггг';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ОблШапка.Параметры.ДатаДок = Формат(Шапка.ДатаДок, "ДФ='дд ММММ гггг';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ОблШапка.Параметры.НомерДок = Шапка.НомерДок;
		ТабДокумент.Вывести(ОблШапка);
		
		//Строка
		ОблСтрока = Макет.ПолучитьОбласть("Строка");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ИНАГРО_АктФасовкиПродукция.Номенклатура КАК Продукция,
			|	ИНАГРО_АктФасовкиПродукция.Количество КАК КвоПродукции,
			|	ИНАГРО_АктФасовкиПродукция.ФизическийВес КАК ВесПродукции,
			|	ИНАГРО_АктФасовкиПродукция.Фасовка.Вес КАК Фасовка,
			|	ИНАГРО_АктФасовкиПродукция.Влажность КАК Влажность,
			|	ИНАГРО_АктФасовкиПродукция.СорнаяПримесь КАК СорнаяПримесь
			|ИЗ
			|	Документ.ИНАГРО_АктФасовки.Продукция КАК ИНАГРО_АктФасовкиПродукция
			|ГДЕ
			|	ИНАГРО_АктФасовкиПродукция.Ссылка = &Ссылка";
		
		Стр = Запрос.Выполнить().Выбрать();
		Пока Стр.Следующий()Цикл
			ОблСтрока.Параметры.Заполнить(Стр);
			ТабДокумент.Вывести(ОблСтрока);
		КонецЦикла;
		
		//Дно
		ОблДно = Макет.ПолучитьОбласть("Дно");
		
		ОблДно.Параметры.ИтогКвоПродукции = Запрос.Выполнить().Выгрузить().Итог("КвоПродукции");
		ОблДно.Параметры.ИтогВесПродукции = Запрос.Выполнить().Выгрузить().Итог("ВесПродукции");
		ТабДокумент.Вывести(ОблДно);
	КонецЦикла;
	
	Возврат ТабДокумент;
 
КонецФункции

Функция ПечатьНакладная112_2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_АктФасовки.ПФ_MXL_Накладная112_2021");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиВертикальныйРазделительСтраниц();
		КонецЕсли; 
		ПервыйДокумент = Ложь;
		
		//Макет = ПолучитьМакет("Накладная112");
		
		//Шапка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_АктФасовки.Организация.НаименованиеПолное КАК Организация,
		|	ИНАГРО_АктФасовки.Номер КАК НомерДок,
		|	ИНАГРО_АктФасовки.Дата КАК ДатаДок,
		|	ИНАГРО_АктФасовки.Организация.КодПоЕДРПОУ КАК КодПоЕДРПОУ
		|ИЗ
		|	Документ.ИНАГРО_АктФасовки КАК ИНАГРО_АктФасовки
		|ГДЕ
		|	ИНАГРО_АктФасовки.Ссылка = &Ссылка";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Заполнить(Шапка);
		ОблШапка.Параметры.Организация = Шапка.Организация;
		ОблШапка.Параметры.НомерДок = ПодчеркнутьТекстВМакете(Шапка.НомерДок);
		ОблШапка.Параметры.ДатаДокДень = СокрЛП(ПодчеркнутьТекстВМакете(Формат(Шапка.ДатаДок, "ДФ='dd'")));
		ОблШапка.Параметры.ДатаДокМесяц = СокрЛП(ПодчеркнутьТекстВМакете(Формат(Шапка.ДатаДок, "ДФ='MMMM';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать))));
		ОблШапка.Параметры.ДатаДокГод = СокрЛП(ПодчеркнутьТекстВМакете(Формат(Шапка.ДатаДок, "ДФ='yy'")));
		ТабДокумент.Вывести(ОблШапка);
		
		//Строка
		ОблСтрока = Макет.ПолучитьОбласть("Строка");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ИНАГРО_АктФасовкиПродукция.Номенклатура КАК Продукция,
			|	ИНАГРО_АктФасовкиПродукция.Количество КАК КвоПродукции,
			|	ИНАГРО_АктФасовкиПродукция.ФизическийВес КАК ВесПродукции,
			|	ИНАГРО_АктФасовкиПродукция.Фасовка.Вес КАК Фасовка,
			|	ИНАГРО_АктФасовкиПродукция.Влажность КАК Влажность,
			|	ИНАГРО_АктФасовкиПродукция.СорнаяПримесь КАК СорнаяПримесь
			|ИЗ
			|	Документ.ИНАГРО_АктФасовки.Продукция КАК ИНАГРО_АктФасовкиПродукция
			|ГДЕ
			|	ИНАГРО_АктФасовкиПродукция.Ссылка = &Ссылка";
		
		Стр = Запрос.Выполнить().Выбрать();
		Пока Стр.Следующий()Цикл
			ОблСтрока.Параметры.Заполнить(Стр);
			ТабДокумент.Вывести(ОблСтрока);
		КонецЦикла;
		
		//Дно
		ОблДно = Макет.ПолучитьОбласть("Дно");
		ТабДокумент.Вывести(ОблДно);
	КонецЦикла;
	
	Возврат ТабДокумент;
 
КонецФункции


Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

Функция ПодчеркнутьТекстВМакете(Строка)  
	Результат = "";
	Для Индекс = 1 По СтрДлина(Строка) Цикл
		Если Сред(Строка, Индекс, 1) <> " " И Сред(Строка, Индекс, 1) <> "_" И Сред(Строка, Индекс, 1) <> "-" Тогда 
			Результат = Результат + Символ(863);
		КонецЕсли;
		Результат = Результат + Сред(Строка, Индекс, 1);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

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
	ФормыИНАГРО_АктФасовки = ПолучитьСоответствиеВидовОперацийФормам();
	ВыбраннаяФорма = ФормыИНАГРО_АктФасовки[ВидОперации];
	Если ВыбраннаяФорма = Неопределено Тогда
		ВыбраннаяФорма = "ФормаДокумента";
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти 

#Область ПрограммныйИнтерфейс

// Заполняет счета учета номенклатуры в табличной части документа
//
// Параметры:
//
//  Объект - СправочникСсылка - объект контактной информации.
// 	ИмяТабличнойЧасти - Строка - имя для табличной части документа.
//  СобственноеПодразделение - имя собственного подразделения.
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

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСоответствиеВидовОперацийФормам() Экспорт

	ФормыИНАГРО_АктФасовки = Новый Соответствие;
	
	ФормыИНАГРО_АктФасовки.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.ДавальческоеСырье, "ФормаДокументаОбщая");
	ФормыИНАГРО_АктФасовки.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.СобственноеСырье,  "ФормаДокументаОбщая");
	ФормыИНАГРО_АктФасовки.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.СкладскойУчет,     "ФормаДокументаОбщая");
		
	Возврат ФормыИНАГРО_АктФасовки;

КонецФункции 

Функция ОпределитьВидОперацииПоДокументуОснованию(Основание) Экспорт

	Результат = Перечисления.ИНАГРО_ВидыОперацийПереработка.ДавальческоеСырье;

	Возврат Результат;

КонецФункции

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

#КонецОбласти 

#КонецЕсли