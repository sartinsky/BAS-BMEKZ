#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ВыполнитьИнициализацию();	
		ЗаполнитьОписания();
		ФормироватьНаименованиеПолноеАвтоматически = Истина;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИсключаемыеВиды = Новый Массив;
	ИсключаемыеВиды.Добавить(Справочники.ВидыКонтактнойИнформации.АдресМестонахожденияОсновныеСредства);
	
	ПараметрыРазмещенияКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ПараметрыРазмещенияКонтактнойИнформации.ИмяЭлементаДляРазмещения = "ГруппаКонтактнаяИнформация";
	ПараметрыРазмещенияКонтактнойИнформации.ИсключаемыеВиды = ИсключаемыеВиды;
	
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ПараметрыРазмещенияКонтактнойИнформации);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация	

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ВыполнитьИнициализацию();

	ЗаполнитьОписания();

	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);

	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененаИнформацияОС" И Параметр = Параметры.Ключ Тогда
		
		ОбновитьСведения();
		
	КонецЕсли;

	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("Ссылка", Объект.Ссылка);
	
	Оповестить("ИзмененОбъектОС", ПараметрОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаСведенийПриИзменении(Элемент)

	ОбновитьСведения();

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставлениеНажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставление1Нажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставление2Нажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУПредставление3Нажатие(Элемент, СтандартнаяОбработка)

	ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУПредставлениеНажатие(Элемент, СтандартнаяОбработка)

	ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУПредставление1Нажатие(Элемент, СтандартнаяОбработка)

	ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУПредставление2Нажатие(Элемент, СтандартнаяОбработка)

	ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)

	СформироватьНаименованиеПолноеАвтоматически();

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)

	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
		
	// ИНАГРО++
	Объект = Форма.Объект;
	
	Элементы.Группа2.Видимость = Объект.Автотранспорт;
	// ИНАГРО-- 
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьИнициализацию()

	Если ИнициализацияВыполнена Тогда
		Возврат;
	КонецЕсли;

	ИнициализацияВыполнена = Истина;

	ДатаСведений = КонецДня(ТекущаяДатаСеанса());
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ВалютаРегламентированногоУчетаНУ = ВалютаРегламентированногоУчета;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСведения()

	ЗаполнитьОписания();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписания()

	ВидСубконтоОС = Новый Массив();
	ВидСубконтоОС.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);

	// Выборка из регистра сведений "Состояния ОС организаций"
	Запрос = Новый Запрос();
	ДатаВремяНаКонецДня = Новый Граница(КонецДня(ДатаСведений), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("ДатаСведений", 	  ДатаВремяНаКонецДня);
	Запрос.УстановитьПараметр("ОсновноеСредство", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|";
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Организация = РезультатЗапроса.Выгрузить()[0].Организация;
		ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
			ЭтаФорма,
			Организация,
			ДатаСведений);
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;

	// Данные для заполнения закладки "Бухгалтерский учет"
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", Объект.Ссылка);
	Запрос.УстановитьПараметр("ДатаСведений",     Новый Граница(КонецДня(ДатаСведений), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",      Организация);
	Запрос.УстановитьПараметр("ВидСубконтоОС",    ВидСубконтоОС);

	Запрос.Текст =
	"////////////////////////////////////////////////////////////////////////////////
	|// 0 - ПервоначальныеСведенияОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.СпособНачисленияАмортизации КАК СпособНачисленияАмортизацииБУ,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимостьБУ,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПараметрВыработки КАК ПараметрВыработкиБУ,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПараметрВыработки.ЕдиницаИзмерения КАК ЕдиницаПараметраВыработкиБУ
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&ДатаСведений, ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 1 - МестонахождениеОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ КАК МОЛБУ,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение КАК ПодразделениеБУ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 2 - ПараметрыАмортизацииОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.СрокПолезногоИспользования КАК СрокИспользованияБУ,
	|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ОбъемПродукцииРабот КАК ОбъемРаботБУ,
	|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимостьБУ
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 3 - ГрафикиАмортизацииОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГрафикиАмортизацииОСБухгалтерскийУчетСрезПоследних.ГрафикАмортизации КАК ГодовойГрафикБУ
	|ИЗ
	|	РегистрСведений.ГрафикиАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ГрафикиАмортизацииОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 4 - СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетСрезПоследних.СпособыОтраженияРасходовПоАмортизации КАК СпособОтраженияРасходовПоАмортизацииБУ
	|ИЗ
	|	РегистрСведений.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|//	5 - СчетаБухгалтерскогоУчетаОС
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчетаБУ,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации КАК СчетНачисленияАмортизацииБУ,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчетаДооценокОС КАК СчетУчетаДооценокОС
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОССрезПоследних";

    МассивРезультатов 	= Запрос.ВыполнитьПакет();
    СчетУчетаБУ 				= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
    СчетНачисленияАмортизацииБУ = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	
    Если МассивРезультатов[0].Пустой() Тогда
		НоваяТекущаяСтраница = Элементы.ГруппаОсновноеСредствоВБухгалтерскомУчетеНеОтражалось;
		Элементы.ГруппаАмортизацияБУ.Видимость = Ложь;
	Иначе
		НоваяТекущаяСтраница = Элементы.ГруппаОтражениеОСВБУ;
		Элементы.ГруппаАмортизацияБУ.Видимость = Истина;
		
		Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Стоимостные показатели
	Если ЗначениеЗаполнено(СчетУчетаБУ) Тогда
		
		Запрос.УстановитьПараметр("СчетУчетаБУ", СчетУчетаБУ);
		Запрос.УстановитьПараметр("СчетНачисленияАмортизацииБУ", СчетНачисленияАмортизацииБУ);
		
		ТекстЗапросаСтоимость = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХозрасчетныйОстаткиСтоимость.СуммаОстатокДт КАК ТекущаяСтоимостьБУ,
		|	ХозрасчетныйОстаткиСтоимость.СуммаНУОстатокДт КАК ТекущаяСтоимостьНУ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаСведений,
		|			Счет = &СчетУчетаБУ,
		|			&ВидСубконтоОС,
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстаткиСтоимость";
		
		ТекстЗапросаАмортизация = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ХозрасчетныйОстаткиАмортизация.СуммаОстатокКт КАК ТекАмортизацияБУ,
		|	ХозрасчетныйОстаткиАмортизация.СуммаОстатокДт КАК ТекИзносБУ,
		|	ХозрасчетныйОстаткиАмортизация.СуммаНУОстатокКт КАК ТекАмортизацияНУ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаСведений,
		|			Счет = &СчетНачисленияАмортизацииБУ,
		|			&ВидСубконтоОС,
		|			Организация = &Организация
		|				И Субконто1 = &ОсновноеСредство) КАК ХозрасчетныйОстаткиАмортизация";
		
		Запрос.Текст = ТекстЗапросаСтоимость;
		Если ЗначениеЗаполнено(СчетНачисленияАмортизацииБУ) Тогда
			Запрос.Текст = Запрос.Текст 
				+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета()
				+ ТекстЗапросаАмортизация;
		КонецЕсли;
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;
	Элементы.ГруппаСтраницыОтражениеВБУ.ТекущаяСтраница = НоваяТекущаяСтраница;

	РасшифровкаСрокаПолезногоИспользованияБУ = УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СрокИспользованияБУ);

	// Установка видимости страниц панели ПанельПараметрыАмортизации
	Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Прямолинейный
		  ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УменьшенияОстатка
		  ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Кумулятивный
		  ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.УскоренногоУменьшенияОстатка Тогда
		Элементы.ГруппаПараметрыАмортизации.ТекущаяСтраница = Элементы.ГруппаПрочие;
	ИначеЕсли СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Производственный Тогда
		Элементы.ГруппаПараметрыАмортизации.ТекущаяСтраница = Элементы.ГруппаПроизводственный;
	Иначе	
		Элементы.ГруппаПараметрыАмортизации.ТекущаяСтраница = Элементы.ГруппаСпособНачисленияАмортизацииБУНеУказан;
	КонецЕсли;

	УчетОС.ПолучитьДокументБухСостоянияОС(Объект.Ссылка, Организация, Перечисления.СостоянияОС.ВведеноВЭксплуатацию,
		ДокументВводаВЭксплуатациюБУ, ВведеноВЭксплуатациюБУ);
	УчетОС.ПолучитьДокументБухСостоянияОС(Объект.Ссылка, Организация, Перечисления.СостоянияОС.СнятоСУчета,
		ДокументСнятияСУчетаБУ, СнятоСУчетаБУ);

	// Данные для заполнения закладки "Налоговый учет".
	// Стоимостные показатели текущей стоимости и амортизации по НУ заполнены вместе с БУ.
	Запрос.Текст =
	"////////////////////////////////////////////////////////////////////////////////
	|// 0 - ПервоначальныеСведенияОСНалоговыйУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ПервоначальныеСведенияОСНалоговыйУчетСрезПоследних.ПервоначальнаяСтоимостьНУ, 0) КАК ПервоначальнаяСтоимостьНУ,
	|	ПервоначальныеСведенияОСНалоговыйУчетСрезПоследних.НалоговаяГруппаОС КАК НалоговаяГруппаОС
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОСНалоговыйУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 1 - ПараметрыАмортизацииОСНалоговыйУчет
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПараметрыАмортизацииОСНалоговыйУчетСрезПоследних.СрокПолезногоИспользования КАК СрокИспользованияНУ
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСНалоговыйУчет.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыАмортизацииОСНалоговыйУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 2 - НалоговыеНазначенияОС
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НалоговыеНазначенияОССрезПоследних.НалоговоеНазначение КАК НалоговоеНазначение
	|ИЗ
	|	РегистрСведений.НалоговыеНазначенияОС.СрезПоследних(
	|			&ДатаСведений,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК НалоговыеНазначенияОССрезПоследних";

	МассивРезультатов = Запрос.ВыполнитьПакет();

	Если МассивРезультатов[0].Пустой() Тогда
		НоваяТекущаяСтраница = Элементы.ГруппаОсновноеСредствоВНалоговомУчетеНеОтражалось;
		Элементы.ГруппаНачислениеАмортизацииНУДекорация.Видимость = Ложь;
	Иначе
		НоваяТекущаяСтраница = Элементы.ГруппаОтражениеОСВНУ;
		Элементы.ГруппаНачислениеАмортизацииНУДекорация.Видимость = Истина;
		
		Для Каждого РезультатЗапроса Из МассивРезультатов Цикл
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ГруппаСтраницыОтражениеВНУ.ТекущаяСтраница = НоваяТекущаяСтраница;

	РасшифровкаСрокаПолезногоИспользованияНУ = УправлениеВнеоборотнымиАктивамиКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СрокИспользованияНУ);

	ВведеноВЭксплуатациюНУ = ВведеноВЭксплуатациюБУ;
	СнятоСУчетаНУ = СнятоСУчетаБУ;

	ЗаполнитьТекстПроДокументы();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекстПроДокументы()

	Если ДокументВводаВЭксплуатациюБУ = Неопределено Тогда
		ДокументВводаВЭксплуатациюБУПредставление = НСтр("ru='Ввести документ ввода в эксплуатацию';uk='Ввести документ введення в експлуатацію'");
		ВведеноВЭксплуатациюБУ = '00010101';
		ВведеноВЭксплуатациюНУ = '00010101';
	Иначе
		ДокументВводаВЭксплуатациюБУПредставление = Строка(ДокументВводаВЭксплуатациюБУ);
		ИмяТипаДокументаВводаВЭксплуатацию = ДокументВводаВЭксплуатациюБУ.Метаданные().Имя;
	КонецЕсли;

	ДокументВводаВЭксплуатациюНУПредставление = ДокументВводаВЭксплуатациюБУПредставление;
	
	Если ДокументСнятияСУчетаБУ = Неопределено Тогда
		ДокументСнятияСУчетаБУПредставление = НСтр("ru='Ввести документ списания';uk='Ввести документ списання'");
		СнятоСУчетаБУ = '00010101';
		СнятоСУчетаНУ = '00010101';
	Иначе
		ДокументСнятияСУчетаБУПредставление = Строка(ДокументСнятияСУчетаБУ);
		ИмяТипаДокументаСнятияСУчета = ДокументСнятияСУчетаБУ.Метаданные().Имя;
	КонецЕсли;
	
	ДокументСнятияСУчетаНУПредставление = ДокументСнятияСУчетаБУПредставление;

КонецПроцедуры

// Процедура проверяет, совпадало ли ранее полное наименование с наименованием,
// и присваивает соответствующее значение переменной мФормироватьНаименованиеПолноеАвтоматически.
//
// Параметры:
//  Нет.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(Форма)

	Если ПустаяСтрока(Форма.Объект.НаименованиеПолное)
	 ИЛИ Форма.Объект.НаименованиеПолное = Форма.Объект.Наименование Тогда
		Форма.ФормироватьНаименованиеПолноеАвтоматически = Истина;
	Иначе
		Форма.ФормироватьНаименованиеПолноеАвтоматически = Ложь;
	КонецЕсли;

КонецПроцедуры

// Процедура проверяет, необходимо ли формировать полное наименование автоматически или нет,
// и, если необходимо, формирует его.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СформироватьНаименованиеПолноеАвтоматически()

	Если ФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДокументВводаВЭксплуатациюБУНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru='Данные еще не записаны.
|Ввод документа ввода в эксплуатацию возможен только после записи.
|Данные будут записаны.';uk='Дані ще не записані.
|Введення документа введення в експлуатацію можливе лише після запису.
|Дані будуть записані.'");
		Оповещение = Новый ОписаниеОповещения("ВопросВводВводаВЭксплуатациюПослеЗаписиЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ОткрытьФормуВводаВЭксплуатациюОС();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросВводВводаВЭксплуатациюПослеЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Если Записать() Тогда // Записать новый объект, чтобы его можно было поместить в документ
			ОткрытьФормуВводаВЭксплуатациюОС();
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВводаВЭксплуатациюОС()
	
	ПараметрыОткрытия = Новый Структура;
	Если ДокументВводаВЭксплуатациюБУ = Неопределено Тогда
		ПараметрыОткрытия.Вставить("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.ВводВЭксплуатациюОС.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	Иначе
		ПараметрыОткрытия.Вставить("Ключ", ДокументВводаВЭксплуатациюБУ);
		ОткрытьФорму("Документ." + ИмяТипаДокументаВводаВЭксплуатацию + ".ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	КонецЕсли;

	ОбновитьСведения();

КонецПроцедуры

&НаКлиенте
Процедура ДокументСнятияСУчетаБУНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = НСтр("ru='Данные еще не записаны.
|Ввод документа снятия с учета возможен только после записи.
|Данные будут записаны.';uk='Дані ще не записані.
|Введення документа зняття з обліку можливе тільки після запису.
|Дані будуть записані.'");
			
		Оповещение = Новый ОписаниеОповещения("ВопросВводСнятиеСУчетаОСПослеЗаписиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ОткрытьФормуСписаниеОС();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросВводСнятиеСУчетаОСПослеЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Если Записать() Тогда
			ОткрытьФормуСписаниеОС();
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСписаниеОС()
	
	ПараметрыФормы = Новый Структура;
	Если ДокументСнятияСУчетаБУ = Неопределено Тогда
		ПараметрыФормы.Вставить("Основание", Объект.Ссылка);
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ПодразделениеОрганизации", ПодразделениеБУ);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураПараметров);
		ОткрытьФорму("Документ.СписаниеОС.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПараметрыФормы.Вставить("Ключ", ДокументСнятияСУчетаБУ);
		ОткрытьФорму("Документ." + ИмяТипаДокументаСнятияСУчета +".ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

	ОбновитьСведения();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Ссылка, Реквизит) // ИНАГРО
	
	Возврат	ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, Реквизит);
	
КонецФункции

&НаКлиенте
Процедура АвтотранспортПриИзменении(Элемент) // ИНАГРО
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
 
&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)

	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)

	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);

КонецПроцедуры

// ИНАГРО++
&НаКлиенте
Процедура ЗаполнитьСведенияОбАвтотранспорте(Команда) 
	
	Если Параметры.Ключ.Пустая() Тогда
		ТекстВопроса = Нстр("ru='Перед заполнением необходимо записать элемент. Сохранить изменения?';uk='Перед заповненням необхідно записати елемент. Зберегти зміни?'");
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьСведенияОбАвтотранспортеЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да); 
	Иначе
		ЗаполнитьСведенияОбАвтотранспортеПрименить();  
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведенияОбАвтотранспортеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
   	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Если Записать() Тогда
			ЗаполнитьСведенияОбАвтотранспортеПрименить();
		КонецЕсли;
	КонецЕсли; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведенияОбАвтотранспортеПрименить()	
		
	Если ПолучитьЗначениеРеквизита(Объект.Модель, "ВидТехники") = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыТехники.Автотранспорт") Тогда
				
		ПараметрыОтбора	= Новый Структура("ОсновноеСредство", Объект.Ссылка);
		ПараметрыФормы	= Новый Структура("Отбор",            ПараметрыОтбора); 				
		
		ОткрытьФорму("РегистрСведений.ИНАГРО_ТранспортныеСредства.ФормаСписка", ПараметрыФормы, ЭтаФорма);
		
	ИначеЕсли ПолучитьЗначениеРеквизита(Объект.Модель, "ВидТехники") = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыТехники.Сельхозтехника") Тогда
		
		ПараметрыОтбора	= Новый Структура("ОсновноеСредство", Объект.Ссылка);
		ПараметрыФормы	= Новый Структура("Отбор",            ПараметрыОтбора); 				
		
		ОткрытьФорму("РегистрСведений.ИНАГРО_Сельхозтехника.ФормаСписка", ПараметрыФормы, ЭтаФорма); 
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура АдресМестонахожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, Модифицированность, СтандартнаяОбработка);
	
КонецПроцедуры
