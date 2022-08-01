#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСчетаУчетаРасчетов(Объект) Экспорт
	
	СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
		Объект.Организация,  Объект.Контрагент, Объект.ДоговорКонтрагента);
		
	Объект.СчетУчетаРасчетовСКонтрагентом 	= СчетаУчета.СчетРасчетов;
	Объект.СчетУчетаРасчетовПоАвансам     	= СчетаУчета.СчетАвансов;
	Объект.СчетУчетаРасчетовПоТаре        	= СчетаУчета.СчетУчетаТары;
	Объект.СчетУчетаНДС 					= СчетаУчета.СчетУчетаНДСПриобретений;
	Объект.СчетУчетаНДСПодтвержденный 		= СчетаУчета.СчетУчетаНДСПриобретенийПодтвержденный;
	
КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СчетаУчета);
	КонецЦикла;

КонецПроцедуры

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо стуктура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре) Экспорт

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
	
	Если ИмяТабличнойЧасти = "Продукция" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.Счет = СчетаУчета.СчетУчетаБУ;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "Услуги" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "ИспользованныеМатериалы" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетПередачиБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ =
				БухгалтерскийУчетВызовСервераПовтИсп.СчетУчетаМатериалыПереданныеВПереработку(СчетаУчета.СчетПередачиБУ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "ВозвращенныеМатериалы" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетПередачиБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ =
				БухгалтерскийУчетВызовСервераПовтИсп.СчетУчетаМатериалыПереданныеВПереработку(СчетаУчета.СчетПередачиБУ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.СчетПередачиБУ = СчетаУчета.СчетУчетаБУ;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
	ИначеЕсли ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		
		Если ЗначениеЗаполнено(СчетаУчета.СчетУчетаБУ) Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = СчетаУчета.СчетУчетаБУ;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
			СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура РассчитатьПропорциональныйНДС(Объект, ПлательщикНДС, КоэффициентПропорциональногоНДС) Экспорт

	МассивИменТабличныхЧастей = Новый Массив();
	МассивИменТабличныхЧастей.Добавить("Услуги");
	
	УчетНДСКлиентСервер.РассчитатьПропорциональныйНДС(
		Объект,
		МассивИменТабличныхЧастей, 
		ПлательщикНДС,
		КоэффициентПропорциональногоНДС
	);
		
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Приходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru='Приходная накладная';uk='Прибуткова накладна'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	// М-4 (приходный ордер)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "М4";
	КомандаПечати.Представление = НСтр("ru='Приходный ордер (М-4)';uk='Прибутковий ордер (М-4)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Поступление из переработки""';uk='Реєстр документів ""Надходження з переробки""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Процедура осуществляет печать документа. Можно направить печать на
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", НСтр("ru='Приходная накладная';uk='Прибуткова накладна'"), 
			ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"Документ.ПоступлениеИзПереработки.ПФ_MXL_Накладная", , Истина);
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М4") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М4", НСтр("ru='Приходный ордер (М-4)';uk='Прибутковий ордер (М-4)'"), 
			ПечатьМ4(МассивОбъектов, ОбъектыПечати, ПараметрыВывода),,"ОбщийМакет.ПФ_MXL_UK_М4");
	КонецЕсли;
КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	УстановитьПривилегированныйРежим(Истина);

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПоступлениеИзПереработки_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПоступлениеИзПереработки.ПФ_MXL_Накладная");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номер,
		|	Дата,
		|	Ответственный.ФизическоеЛицо.Наименование КАК Получил,
		|	Организация,
		|	Организация КАК Поставщик,
		|	Склад,
		|	ПодразделениеОрганизации КАК Подразделение
		|ИЗ
		|	Документ.ПоступлениеИзПереработки КАК ПоступлениеИзПереработки
		|
		|ГДЕ
		|	ПоступлениеИзПереработки.Ссылка = &ТекущийДокумент";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номенклатура,
		|	Номенклатура.НаименованиеПолное КАК Товар,
		|	Номенклатура.Код КАК Код,
		|	Количество,
		|	ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
		|   НомерСтроки,
		|   1 КАК ID
		|ИЗ 
		|	(ВЫБРАТЬ
		|		Номенклатура         КАК Номенклатура,
		|		ЕдиницаИзмерения     КАК ЕдиницаИзмерения,
		|		СУММА(Количество)    КАК Количество,
		|		МИНИМУМ(НомерСтроки) КАК НомерСтроки
		|	ИЗ
		|		Документ.ПоступлениеИзПереработки.Продукция КАК ПоступлениеИзПереработки
		|
		|	ГДЕ
		|		ПоступлениеИзПереработки.Ссылка = &ТекущийДокумент
		|	СГРУППИРОВАТЬ ПО
		|		Номенклатура,
		|		ЕдиницаИзмерения
		|	) КАК ВложенныйЗапросПоТоварам
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Номенклатура,
		|	Номенклатура.НаименованиеПолное КАК Товар,
		|	Номенклатура.Код КАК Код,
		|	Количество,
		|	ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,	
		|   НомерСтроки,
		|   2 КАК ID
		|ИЗ
		|	Документ.ПоступлениеИзПереработки.ВозвращенныеМатериалы КАК ПоступлениеИзПереработки
		|
		|ГДЕ
		|	ПоступлениеИзПереработки.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	ID,
		|	НомерСтроки";
		ЗапросТовары = Запрос.Выполнить().Выгрузить();

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, НСтр("ru='Приходная накладная (из переработки)';uk='Прибуткова накладна (з переробки)'",КодЯзыкаПечать),КодЯзыкаПечать);

		ТабДокумент.Вывести(ОбластьМакета);

		СведенияОПоставщике = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,",,КодЯзыкаПечать);	
		ОбластьМакета.Параметры.РеквизитыПоставщика =     ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес,Телефоны,/,КодПоЕДРПОУ,КодПоДРФО,",,КодЯзыкаПечать);
	    ТабДокумент.Вывести(ОбластьМакета);
		
		// Выводим дополнительно информацию о договоре и сделке
		СписокДополнительныхПараметров = "Склад,Подразделение,";
		МассивСтруктурСтрок = ОбщегоНазначенияБПВызовСервера.ДополнительнаяИнформация(Шапка,СписокДополнительныхПараметров,КодЯзыкаПечать);
		ОбластьМакета = Макет.ПолучитьОбласть("ДопИнформация");
	    Для каждого СтруктураСтроки Из МассивСтруктурСтрок Цикл
			ОбластьМакета.Параметры.Заполнить(СтруктураСтроки);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.Товар 		= СокрЛП(ВыборкаСтрокТовары.Товар);
			ОбластьМакета.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			ТабДокумент.Вывести(ОбластьМакета);

		КонецЦикла;

		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
		
	Возврат ТабДокумент;

КонецФункции

// Функция формирует табличный документ унифицированной формы М-4
//
//
// Возвращаемое значение:
//  Табличный документ по форме Приходный ордер (М-4).
//
Функция ПечатьМ4(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если Не ЗначениеЗаполнено(ДопКолонка) Тогда
		ДопКолонка = "Код";
	КонецЕсли;
	
	ЗапросШапка = Новый Запрос;
	ЗапросШапка.Текст =	"ВЫБРАТЬ
	|	Номер,
	|	Дата,     	
	|	Ответственный.ФизическоеЛицо.Наименование КАК Получил,
	|	Организация,
	|	Контрагент  КАК Поставщик,
	|	Склад,
	|	Склад.ТипСклада КАК ТипСклада,
	|	ПодразделениеОрганизации КАК Подразделение
	|ИЗ
	|	Документ.ПоступлениеИзПереработки КАК ПоступлениеИзПереработки
	|
	|ГДЕ
	|	ПоступлениеИзПереработки.Ссылка = &ТекущийДокумент";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Номенклатура,
	|	Номенклатура.НаименованиеПолное КАК Товар,
	|	ВЫБОР КОГДА &КолонкаКодов = ""Артикул"" ТОГДА
	|		Номенклатура.Артикул
	|	ИНАЧЕ
	|		Номенклатура.Код
	|	КОНЕЦ ТоварКод,
	|	Количество КАК КоличествоПринято,
	|	ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|	ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	Цена,
	|	Сумма,
	|   НомерСтроки,
	|   1 КАК ID
	|ИЗ 
	|	(ВЫБРАТЬ
	|		Номенклатура         	КАК Номенклатура,
	|		ЕдиницаИзмерения     	КАК ЕдиницаИзмерения,
	|		ПлановаяСтоимость 		КАК Цена,
	|		СУММА(Количество)    	КАК Количество,
	|		СУММА(СуммаПлановая) 	КАК Сумма,
	|		МИНИМУМ(НомерСтроки) 	КАК НомерСтроки
	|	ИЗ
	|		Документ.ПоступлениеИзПереработки.Продукция КАК ПоступлениеИзПереработки
	|
	|	ГДЕ
	|		ПоступлениеИзПереработки.Ссылка = &ТекущийДокумент
	|	СГРУППИРОВАТЬ ПО
	|		Номенклатура,
	|		ПлановаяСтоимость,
	|		ЕдиницаИзмерения
	|	) КАК ВложенныйЗапросПоТоварам
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Номенклатура,
	|	Номенклатура.НаименованиеПолное КАК Товар,
	|	ВЫБОР КОГДА &КолонкаКодов = ""Артикул"" ТОГДА
	|		Номенклатура.Артикул
	|	ИНАЧЕ
	|		Номенклатура.Код
	|	КОНЕЦ ТоварКод,
	|	Количество КАК КоличествоПринято,
	|	ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|	ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,	
	|	NULL КАК Цена,
	|	NULL КАК Сумма,
	|   НомерСтроки,
	|   2 КАК ID
	|ИЗ
	|	Документ.ПоступлениеИзПереработки.ВозвращенныеМатериалы КАК ПоступлениеИзПереработки
	|
	|ГДЕ
	|	ПоступлениеИзПереработки.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	ID,
	|	НомерСтроки";
	
	// Зададим параметры макета
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДокумент.АвтоМасштаб = Истина;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_М4";
	
	КодЯзыкаПечать = "uk";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_М4");
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// шапка
		ЗапросШапка.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Шапка = ЗапросШапка.Выполнить().Выбрать();
		Шапка.Следующий();
		// ТЧ печатной формы
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения", Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка());
		Запрос.УстановитьПараметр("КолонкаКодов", ДопКолонка);
		
		ЗапросТовары = Запрос.Выполнить().Выгрузить();
		Если ЗапросТовары.Количество()= 0 Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='В документе %1 отсутствуют товары. Печать приходного ордера не требуется';uk='У документі %1 відсутні товари. Друк прибуткового ордера не потрібний'"),
			Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			Ссылка);
			Продолжить;
			
		КонецЕсли;	
				
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата,,,КодЯзыкаПечать);
		СведенияОПоставщике     = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата,,,КодЯзыкаПечать);
		ПредставлениеПоставщика = СведенияОПоставщике.ПолноеНаименование;
		НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Шапка.Номер, Ложь, Истина);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ПредставлениеОрганизации", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,",,КодЯзыкаПечать));
		СтруктураПараметров.Вставить("КодПоЕДРПОУ", СведенияОбОрганизации.КодПоЕДРПОУ);
		СтруктураПараметров.Вставить("НомерДокумента", НомерДокумента);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокДокумента");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("НомерДокумента", НомерДокумента);
		СтруктураПараметров.Вставить("ДатаСоставления", Шапка.Дата);
		СтруктураПараметров.Вставить("СкладНаименование", Шапка.Склад);
		СтруктураПараметров.Вставить("ПоставщикНаименование", ПредставлениеПоставщика);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
		
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		ЭтоНТТ = (Шапка.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);
		
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.ТоварНаименование 		= СокрЛП(ВыборкаСтрокТовары.Товар);
     		ОбластьМакета.Параметры.СуммаСНДС      			= ВыборкаСтрокТовары.Сумма;
			
			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Если НЕ ЭтоНТТ Тогда
					Сообщить(НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.';uk='В одному з рядків не заповнене значення номенклатури - рядок під час друку буде пропущений.'"), СтатусСообщения.Важное);
					Продолжить;
				Иначе	
					// для НТТ при отсутствии номенклатуры печатаем некий текст
					ОбластьМакета.Параметры.ТоварНаименование = НСтр("ru='Товары в ассортименте';uk='Товари в асортименті'",КодЯзыкаПечать);
				КонецЕсли;
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.КладовщикПринявшийТоварДолжностьФИО       = Шапка.Получил;
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли