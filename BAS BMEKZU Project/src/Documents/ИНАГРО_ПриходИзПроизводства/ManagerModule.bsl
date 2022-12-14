#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_XML_Накладная112";
	КомандаПечати.Представление = НСтр("ru='Приходная накладная';uk='Прибуткова накладна'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка,ФормаВыбора,";
	
	// Приходная накладная 2021
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_XML_Накладная112_2021";
	КомандаПечати.Представление = НСтр("ru='Приходная накладная (2021)';uk='Прибуткова накладна (2021)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокументаОбщая,ФормаСписка,ФормаВыбора,";

	// Рапорт документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_XML_Рапорт";
	КомандаПечати.Представление = НСтр("ru='Рапорт';uk='Рапорт'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Рапорт';uk='Рапорт'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокументаОбщая";
	КомандаПечати.Порядок       = 100;
	
	// Рапорт документов 2021
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_XML_Рапорт_2021";
	КомандаПечати.Представление = НСтр("ru='Рапорт (2021)';uk='Рапорт (2021)'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Рапорт (2021)';uk='Рапорт (2021)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокументаОбщая";
	КомандаПечати.Порядок       = 100;

	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Приход из производства""';uk='Реєстр документів ""Надходження з виробництва""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_XML_Накладная112") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_XML_Накладная112", НСтр("ru='Приходная накладная';uk='Прибуткова накладна'"), 
		ПечатьНакладная112(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_ПриходИзПроизводства.ПФ_XML_Накладная112", , Истина);
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_XML_Накладная112_2021") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_XML_Накладная112_2021", НСтр("ru='Приходная накладная (2021)';uk='Прибуткова накладна (2021)'"), 
		ПечатьНакладная112_2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_ПриходИзПроизводства.ПФ_XML_Накладная112_2021", , Истина);
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_XML_Рапорт") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ПФ_XML_Рапорт", НСтр("ru='Рапорт о выроботке комбикормов и использовании';uk='Рапорт виробки комбiкормiв та використовування'"),
		ПечатьРапорт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_ПриходИзПроизводства.ПФ_XML_Рапорт", , Истина);
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_XML_Рапорт_2021") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ПФ_XML_Рапорт_2021", НСтр("ru='Рапорт о выроботке комбикормов и использовании (2021)';uk='Рапорт виробки комбiкормiв та використовування (2021)'"),
		ПечатьРапорт2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ИНАГРО_ПриходИзПроизводства.ПФ_XML_Рапорт_2021", , Истина);
	КонецЕсли;
	
КонецПроцедуры 

Функция ПечатьРапорт(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНАГРО_ПриходИзПроизводства_ПФ_XML_Рапорт";
	
	Макет = ПолучитьМакет("ПФ_XML_Рапорт");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;	
	ПервыйДокумент = Истина;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИНАГРО_ПриходИзПроизводства.Ссылка,
	|	СпрОрганизации.НаименованиеПолное
	|ИЗ
	|	Документ.ИНАГРО_ПриходИзПроизводства КАК ИНАГРО_ПриходИзПроизводства
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК СпрОрганизации
	|		ПО ИНАГРО_ПриходИзПроизводства.Организация = СпрОрганизации.Ссылка
	|ГДЕ
	|	ИНАГРО_ПриходИзПроизводства.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//Шапка
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Организация = ВыборкаДетальныеЗаписи.НаименованиеПолное;
		ТабДокумент.Вывести(ОблШапка);
		
		//Строка
		ОблСтрока = Макет.ПолучитьОбласть("Строка");
		ТабДокумент.Вывести(ОблСтрока);
		//Дно
		ОблДно = макет.ПолучитьОбласть("Дно");
		ТабДокумент.Вывести(ОблДно);
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	Возврат ТабДокумент;
	
КонецФункции // макет "требование"

Функция ПечатьРапорт2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНАГРО_ПриходИзПроизводства_ПФ_XML_Рапорт_2021";
	
	Макет = ПолучитьМакет("ПФ_XML_Рапорт_2021");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;	
	ПервыйДокумент = Истина;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИНАГРО_ПриходИзПроизводства.Ссылка КАК Ссылка,
	|	СпрОрганизации.НаименованиеПолное КАК НаименованиеПолное,
	|	СпрОрганизации.КодПоЕДРПОУ КАК КодПоЕДРПОУ
	|ИЗ
	|	Документ.ИНАГРО_ПриходИзПроизводства КАК ИНАГРО_ПриходИзПроизводства
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК СпрОрганизации
	|		ПО ИНАГРО_ПриходИзПроизводства.Организация = СпрОрганизации.Ссылка
	|ГДЕ
	|	ИНАГРО_ПриходИзПроизводства.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//Шапка
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Организация = ВыборкаДетальныеЗаписи.НаименованиеПолное;
		ОблШапка.Параметры.КодПоЕДРПОУ = ВыборкаДетальныеЗаписи.КодПоЕДРПОУ;
		
		Дата = Формат(ВыборкаДетальныеЗаписи.Ссылка.Дата, "ДФ='дд ММММ гггг';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать)); 
		ОблШапка.Параметры.Число = Лев(Дата, 2);
		ОблШапка.Параметры.Дата = Сред(Дата, 3, СтрДлина(Дата)); 
		
		ТабДокумент.Вывести(ОблШапка);
		
		//Строка
		ОблСтрока = Макет.ПолучитьОбласть("Строка");
		ТабДокумент.Вывести(ОблСтрока);
		//Дно
		ОблДно = макет.ПолучитьОбласть("Дно");
		ТабДокумент.Вывести(ОблДно);
		
	КонецЦикла;
		
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьНакладная112(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	ВалютаПечати = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ТабДок = Новый ТабличныйДокумент();
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_ПриходИзПроизводства.ПФ_XML_Накладная112");
	ПервыйДокумент = Истина;
	//ТабДокумент = Новый ТабличныйДокумент;
	//Макет = ПолучитьМакет("Накладная112_");
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;        
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИНАГРО_ПриходИзПроизводства.Номенклатура КАК Продукция,
	|	ИНАГРО_ПриходИзПроизводства.Количество КАК КвоПродукции,
	|	ИНАГРО_ПриходИзПроизводства.ФизическийВес КАК ВесПродукции,
	|	ИНАГРО_ПриходИзПроизводства.Влажность,
	|	ИНАГРО_ПриходИзПроизводства.СорнаяПримесь,
	|	ИНАГРО_ПриходИзПроизводства.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИНАГРО_ПриходИзПроизводства.Продукция КАК ИНАГРО_ПриходИзПроизводства
	|ГДЕ
	|	ИНАГРО_ПриходИзПроизводства.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//Пока ВыборкаСсылка.Следующий() Цикл
	// Вставить обработку выборки ВыборкаСсылка
	
	//Выборка = ВыборкаСсылка.Выбрать();
	
	//Пока Выборка.Следующий() Цикл
		
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		//Шапка
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка.Организация, "НаименованиеПолное");
		Облшапка.Параметры.ДатаДок = Формат(Ссылка.Дата, "ДЛФ='ДД';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
		ОблШапка.Параметры.НомерДок = Ссылка.Номер;
		ТабДок.Вывести(ОблШапка);
		
		//Строка
		ОблСтрока = Макет.ПолучитьОбласть("Строка");
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		|	ИНАГРО_ПриходИзПроизводства.Номенклатура КАК Продукция,
		|	ИНАГРО_ПриходИзПроизводства.Количество КАК КвоПродукции,
		|	ИНАГРО_ПриходИзПроизводства.ФизическийВес КАК ВесПродукции,
		|	ИНАГРО_ПриходИзПроизводства.Влажность,
		|	ИНАГРО_ПриходИзПроизводства.СорнаяПримесь
		|ИЗ
		|	Документ.ИНАГРО_ПриходИзПроизводства.Продукция КАК ИНАГРО_ПриходИзПроизводства
		|ГДЕ
		|	ИНАГРО_ПриходИзПроизводства.Ссылка = &Ссылка";
		
		Стр = Запрос.Выполнить().Выбрать();
		Пока Стр.Следующий()Цикл
			ОблСтрока.Параметры.Заполнить(Стр);
			ТабДок.Вывести(ОблСтрока);
		КонецЦикла;
		
		//Дно
		ОблДно = Макет.ПолучитьОбласть("Дно");
		ОблДно.Параметры.ИтогКвоПродукции = Запрос.Выполнить().Выгрузить().Итог("КвоПродукции");
		ОблДно.Параметры.ИтогВесПродукции = Запрос.Выполнить().Выгрузить().Итог("ВесПродукции");
		ТабДок.Вывести(ОблДно);
		
	КонецЦикла;
	
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьНакладная112_2021(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	ВалютаПечати = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ТабДок = Новый ТабличныйДокумент();
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_ПриходИзПроизводства.ПФ_XML_Накладная112_2021");
	ПервыйДокумент = Истина;
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;        
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИНАГРО_ПриходИзПроизводства.Номенклатура КАК Продукция,
	|	ИНАГРО_ПриходИзПроизводства.Количество КАК КвоПродукции,
	|	ИНАГРО_ПриходИзПроизводства.ФизическийВес КАК ВесПродукции,
	|	ИНАГРО_ПриходИзПроизводства.Влажность,
	|	ИНАГРО_ПриходИзПроизводства.СорнаяПримесь,
	|	ИНАГРО_ПриходИзПроизводства.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИНАГРО_ПриходИзПроизводства.Продукция КАК ИНАГРО_ПриходИзПроизводства
	|ГДЕ
	|	ИНАГРО_ПриходИзПроизводства.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСсылка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		//Шапка
		ОблШапка = Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка.Организация, "НаименованиеПолное");
		ОблШапка.Параметры.КодПоЕДРПОУ = Ссылка.Организация.КодПоЕДРПОУ;
		Дата = Формат(Ссылка.Дата, "ДФ='дд ММММ гггг';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать)); 
		ОблШапка.Параметры.Число = Лев(Дата, 2);
		ОблШапка.Параметры.Месяц = Сред(Дата, 3, СтрДлина(Дата)-7); 
		ОблШапка.Параметры.Год = Прав(Дата, 4); 
		ОблШапка.Параметры.НомерДок = Ссылка.Номер;
		ТабДок.Вывести(ОблШапка);
		
		//Строка
		ОблСтрока = Макет.ПолучитьОбласть("Строка");
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		|	ИНАГРО_ПриходИзПроизводства.Номенклатура КАК Продукция,
		|	ИНАГРО_ПриходИзПроизводства.Количество КАК КвоПродукции,
		|	ИНАГРО_ПриходИзПроизводства.ФизическийВес КАК ВесПродукции,
		|	ИНАГРО_ПриходИзПроизводства.Влажность,
		|	ИНАГРО_ПриходИзПроизводства.СорнаяПримесь
		|ИЗ
		|	Документ.ИНАГРО_ПриходИзПроизводства.Продукция КАК ИНАГРО_ПриходИзПроизводства
		|ГДЕ
		|	ИНАГРО_ПриходИзПроизводства.Ссылка = &Ссылка";
		
		Стр = Запрос.Выполнить().Выбрать();
		Пока Стр.Следующий()Цикл
			ОблСтрока.Параметры.Заполнить(Стр);
			ТабДок.Вывести(ОблСтрока);
		КонецЦикла;
		
		//Дно
		ОблДно = Макет.ПолучитьОбласть("Дно");
		ТабДок.Вывести(ОблДно);
		
	КонецЦикла;
	ТабДок.АвтоМасштаб = Истина;  
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	Возврат ТабДок;
	
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
//  СведенияОНоменклатуре - Структура - структура сведений о номенклатуре, либо структура счетов учета.
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
	ФормыПоступлениеТоваровУслуг = ПолучитьСоответствиеВидовОперацийФормам();
	ВыбраннаяФорма = ФормыПоступлениеТоваровУслуг[ВидОперации];
	Если ВыбраннаяФорма = Неопределено Тогда
		ВыбраннаяФорма = "ФормаДокумента";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСоответствиеВидовОперацийФормам() Экспорт
	
	ФормыИНАГРО_ПриходИзПроизводства = Новый Соответствие;
	
	ФормыИНАГРО_ПриходИзПроизводства.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.ДавальческоеСырье, "ФормаДокументаОбщая");
	ФормыИНАГРО_ПриходИзПроизводства.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.СобственноеСырье,  "ФормаДокументаОбщая");
	ФормыИНАГРО_ПриходИзПроизводства.Вставить(Перечисления.ИНАГРО_ВидыОперацийПереработка.СкладскойУчет,     "ФормаДокументаОбщая");
	
	Возврат ФормыИНАГРО_ПриходИзПроизводства;
	
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

Функция ОпределитьВидОперацииПоДокументуОснованию(Основание) Экспорт

	Результат = Перечисления.ИНАГРО_ВидыОперацийПереработка.ДавальческоеСырье;

	Возврат Результат;

КонецФункции
	
#КонецОбласти

#КонецЕсли 