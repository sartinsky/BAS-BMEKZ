#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ВыполнитьИнициализацию();
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ВыполнитьИнициализацию();
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНематериальныхАктивов.Форма.Форма" Тогда
		ОбработкаВыбораНаСервере(ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	УстановитьФункциональныеОпцииФормы();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОбъектСтроительстваПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ОбъектСтроительства) Тогда 
		Объект.СчетУчетаБУВнеоборотногоАктива = ПолучитьСчетУчетаОбъектаСтроительства(
			Объект.Организация, Объект.ОбъектСтроительства);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)

	СтруктураПараметров = Новый Структура;
	Если Объект.НМА.Количество() > 0 Тогда
		СтруктураПараметров.Вставить("АдресВХранилище", ПоместитьНМАВХранилище());
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборНематериальныхАктивов.Форма.Форма", СтруктураПараметров, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммы(Команда)

	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60);
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();

	Отказ = Ложь;

	Если НЕ ЗначениеЗаполнено(Объект.ОбъектСтроительства) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Объект строительства';uk=""Об'єкт будівництва"""));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОбъектСтроительства", , Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация", , Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.СчетУчетаБУВнеоборотногоАктива) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Счет учета внеоборотного актива';uk='Рахунок обліку внеоборотного активу'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.СчетУчетаБУВнеоборотногоАктива", , Отказ);
	КонецЕсли;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	СтруктураСтоимости = УправлениеНеоборотнымиАктивами.РасчитатьСтоимостьОбъектаСтроительства(Объект.СчетУчетаБУВнеоборотногоАктива, 
	                                                            Объект.ОбъектСтроительства,
																Объект.Организация, 
																КонецМесяца(Объект.Дата));

	ЗаполнитьЗначенияСвойств(Объект, СтруктураСтоимости);
	
	ДатаНКУ2015 = '2015 01 01';
	
	Если Объект.Дата >= ДатаНКУ2015 Тогда
		// для документов 2015 года СтоимостьНУ = СтоимостьБУ  
		Объект.СтоимостьНУ = СтруктураСтоимости.СтоимостьБУ;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаНМА(Команда)

	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60);
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат;
	КонецЕсли;

	ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!
|Продолжить?';uk='При заповненні існуючі дані будуть перераховані!
|Продовжити?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьДляСпискаНМАЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаНМАЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьДляСпискаНМАСервер();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьИнициализацию()

	Если ИнициализацияВыполнена Тогда
		Возврат;
	КонецЕсли;

	ИнициализацияВыполнена = Истина;

	ВалютаРегламентированногоУчета    = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаРегламентированногоУчетаНУ  = ВалютаРегламентированногоУчета;

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьФункциональныеОпцииФормы();

	УправлениеФормой(ЭтаФорма);

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПлательщикНалогаНаПрибыль  	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПлательщикНалогаНаПрибыльДо2015	= УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;

	ДатаНКУ2015 = '2015 01 01';
	ЭтоДокументДо2015 = (Объект.Дата < ДатаНКУ2015);
	
	Элементы.НМАСуммаМодернизацииНУ.Видимость = Форма.ПлательщикНалогаНаПрибыльДо2015;
	Элементы.НМАСтоимостьНУ.Видимость = Форма.ПлательщикНалогаНаПрибыль;
	Элементы.ГруппаСтоимостьНУ.Видимость = Форма.ПлательщикНалогаНаПрибыльДо2015;
	
	Если ЭтоДокументДо2015 Тогда
		Элементы.СтоимостьБУ.Заголовок = НСтр("ru='Общая сумма (БУ)';uk='Загальна сума (БО)'");
		Элементы.НМАСуммаМодернизацииБУ.Заголовок = НСтр("ru='Сумма модернизации (БУ)';uk='Сума модернізації (БО)'");
	Иначе
		Элементы.СтоимостьБУ.Заголовок = НСтр("ru='Общая сумма';uk='Загальна сума'");
		Элементы.НМАСуммаМодернизацииБУ.Заголовок = НСтр("ru='Сумма модернизации';uk='Сума модернізації'");
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляСпискаНМАСервер()

	Если НЕ УчетнаяПолитика.Существует(Объект.Организация, Объект.Дата) Тогда
		ТекстСообщения = НСтр("ru='Не задана учетная политика организации %1 на %2.';uk='Не задана облікова політика організації %1 на %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, Объект.Организация, Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	СписокНМА = Объект.НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив");
	ТаблицаАмортизацииБух = Новый ТаблицаЗначений();

	Запрос   = Новый Запрос;
	Запрос.УстановитьПараметр("Организация"   , Объект.Организация);
	Запрос.УстановитьПараметр("СписокНМА"     , СписокНМА.ВыгрузитьКолонку("НематериальныйАктив"));
	Запрос.УстановитьПараметр("Период"        , Объект.Дата);
	Запрос.УстановитьПараметр("СубконтоНМА"   , ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НематериальныеАктивы);
	Запрос.УстановитьПараметр("ДатаДока"      , Объект.Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПервоначальныеСведения.НематериальныйАктив КАК НематериальныйАктив,
	|	ПервоначальныеСведения.СрокПолезногоИспользования КАК СрокПолезногоИспользованияБУ,
	|	ПервоначальныеСведения.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботБУ,
	|	ПервоначальныеСведения.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимостьБУ,
	|	ПервоначальныеСведенияНУ.СрокПолезногоИспользования КАК СрокПолезногоИспользованияНУ,
	|	ВыработкаНМА.КоличествоОборот КАК ФактОбъемПродукцииРаботБУ,
	|	СтоимостьОстатки.СуммаОстатокДт КАК СтоимостьБУ,
	|	СтоимостьОстатки.СуммаНУОстатокДт КАК СтоимостьНУ,
	|	АмортизацияОстатки.СуммаОстатокКт КАК АмортизацияБУ
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И НематериальныйАктив В (&СписокНМА)) КАК ПервоначальныеСведения
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.ПервоначальныеСведенияНМАНалоговыйУчет.СрезПоследних(
	|		                    &Период,
	|		                    Организация = &Организация
	|		                    И НематериальныйАктив В (&СписокНМА)) КАК ПервоначальныеСведенияНУ
	|		ПО ПервоначальныеСведения.НематериальныйАктив = ПервоначальныеСведенияНУ.НематериальныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВыработкаНМА.Обороты(, &Период, , НематериальныйАктив В (&СписокНМА)) КАК ВыработкаНМА
	|		ПО ПервоначальныеСведения.НематериальныйАктив = ВыработкаНМА.НематериальныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&Период,
	|				Счет В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						СчетаБУ.СчетУчета
	|					ИЗ
	|						РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(&Период, Организация = &Организация
	|							И НематериальныйАктив В (&СписокНМА)) КАК СчетаБУ),
	|				&СубконтоНМА,
	|				Организация = &Организация
	|					И Субконто1 В (&СписокНМА)) КАК СтоимостьОстатки
	|		ПО ПервоначальныеСведения.НематериальныйАктив = СтоимостьОстатки.Субконто1
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&Период,
	|				Счет В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						СчетаБУ.СчетНачисленияАмортизации
	|					ИЗ
	|						РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(&Период, Организация = &Организация
	|							И НематериальныйАктив В (&СписокНМА)) КАК СчетаБУ),
	|				&СубконтоНМА,
	|				Организация = &Организация
	|					И Субконто1 В (&СписокНМА)) КАК АмортизацияОстатки
	|		ПО ПервоначальныеСведения.НематериальныйАктив = АмортизацияОстатки.Субконто1";
	ТЗ_БУ = Запрос.Выполнить().Выгрузить();

    Коэф                  = ?(Объект.НМА.Количество()>0, 1 / Объект.НМА.Количество(), 0);
	ПогрешностьБУ         = 0;
	ПогрешностьНУ         = 0;
	
	Для каждого Строка Из Объект.НМА Цикл

		// В соответствующие поля строки запишем данные из запроса
		СтрокаТЗБУ = ТЗ_БУ.Найти(Строка.НематериальныйАктив, "НематериальныйАктив");

		Если СтрокаТЗБУ = Неопределено Тогда

			Строка.СрокПолезногоИспользованияБУ = 0;
			Строка.ОбъемПродукцииРаботБУ        = 0;
			Строка.СтоимостьБУ                  = 0;
			Строка.СтоимостьНУ                  = 0;
			Строка.СуммаМодернизацииБУ          = 0;
			Строка.ЛиквидационнаяСтоимостьБУ    = 0;
			Строка.СуммаМодернизацииНУ          = 0;

		Иначе

			Строка.СрокПолезногоИспользованияБУ = СтрокаТЗБУ.СрокПолезногоИспользованияБУ;
			Строка.СрокПолезногоИспользованияНУ = СтрокаТЗБУ.СрокПолезногоИспользованияНУ;
			Строка.ОбъемПродукцииРаботБУ        = СтрокаТЗБУ.ОбъемПродукцииРаботБУ;
			Строка.СтоимостьБУ                  = СтрокаТЗБУ.СтоимостьБУ;
			Строка.СтоимостьНУ                  = СтрокаТЗБУ.СтоимостьНУ;
			Строка.СуммаМодернизацииБУ          = ОбщегоНазначенияРед12.ОкруглитьСУчетомПогрешности(Объект.СтоимостьБУ * Коэф, 2, ПогрешностьБУ);
			Строка.ЛиквидационнаяСтоимостьБУ    = СтрокаТЗБУ.ЛиквидационнаяСтоимостьБУ;

			Строка.СуммаМодернизацииНУ          = ОбщегоНазначенияРед12.ОкруглитьСУчетомПогрешности(Объект.СтоимостьНУ * Коэф, 2, ПогрешностьНУ);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПоместитьНМАВХранилище()

	ТаблицаНМА = Объект.НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаНМА);

КонецФункции

&НаСервере
Процедура ОбработкаВыбораНаСервере(Знач ВыбранноеЗначение)

	ДобавленныеСтроки = УправлениеНеоборотнымиАктивами.ОбработатьПодборНематериальныхАктивов(Объект.НМА, ВыбранноеЗначение);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСчетУчетаОбъектаСтроительства(Знач Организация, Знач ОбъектСтроительства)

	Возврат ПланыСчетов.Хозрасчетный.ИзготовлениеНематериальныхАктивов;

КонецФункции

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти