Функция ПолучитьСвойстваСчета(Знач Счет) Экспорт

	ДанныеСчета = Новый Структура;
	ДанныеСчета.Вставить("Ссылка"                         , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ДанныеСчета.Вставить("Наименование"                   , "");
	ДанныеСчета.Вставить("Код"                            , "");
	ДанныеСчета.Вставить("Родитель"                       , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ДанныеСчета.Вставить("Вид"                            , Неопределено);
	ДанныеСчета.Вставить("Забалансовый"                   , Ложь);
	ДанныеСчета.Вставить("ЗапретитьИспользоватьВПроводках", Ложь);
	ДанныеСчета.Вставить("Валютный"                       , Ложь);
	ДанныеСчета.Вставить("Количественный"                 , Ложь);
	//ИНАГРО ++ 
	ДанныеСчета.Вставить("Поштучный"                 	  , Ложь);
	//ИНАГРО --
	ДанныеСчета.Вставить("НалоговыйУчет"                  , Ложь);
	ДанныеСчета.Вставить("УчетСуммНУ"                  	  , Ложь);
	ДанныеСчета.Вставить("УчетПоНалоговымНазначениямНДС"  , Ложь);
	ДанныеСчета.Вставить("КоличествоСубконто"             , 0);
	
	МаксКоличествоСубконто	= ПолучитьМаксКоличествоСубконто();
	
	Для ИндексСубконто = 1 По МаксКоличествоСубконто Цикл
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      Ложь);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", Ложь);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат ДанныеСчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", Счет);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка,
	|	Хозрасчетный.Родитель,
	|	Хозрасчетный.Код,
	|	Хозрасчетный.Наименование,
	|	Хозрасчетный.Вид,
	|	Хозрасчетный.Забалансовый,
	|	Хозрасчетный.ЗапретитьИспользоватьВПроводках,
	|	Хозрасчетный.Валютный,
	|	Хозрасчетный.Количественный,
	// ИНАГРО ++ 
	|	Хозрасчетный.Поштучный,
	// ИНАГРО ++ 
	|	Хозрасчетный.УчетСуммНУ,
	|	Хозрасчетный.УчетПоНалоговымНазначениямНДС,
	|	Хозрасчетный.НалоговыйУчет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.Наименование КАК Наименование,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения,
	|	ХозрасчетныйВидыСубконто.ТолькоОбороты КАК ТолькоОбороты,
	|	ХозрасчетныйВидыСубконто.Суммовой КАК Суммовой
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.Ссылка = &Счет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ХозрасчетныйВидыСубконто.НомерСтроки";
	
	МассивРезультатов	= Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеСчета, Выборка);
	КонецЕсли;
		
	ВыборкаВидыСубконто	= МассивРезультатов[1].Выбрать();
		
	ДанныеСчета.КоличествоСубконто	= ВыборкаВидыСубконто.Количество();
		
	ИндексСубконто	= 0;
		
	Пока ВыборкаВидыСубконто.Следующий() Цикл
		
		ИндексСубконто	= ИндексСубконто + 1;
		
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   ВыборкаВидыСубконто.ВидСубконто);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  ВыборкаВидыСубконто.Наименование);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   ВыборкаВидыСубконто.ТипЗначения);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      ВыборкаВидыСубконто.Суммовой);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", ВыборкаВидыСубконто.ТолькоОбороты);
		
	КонецЦикла;
	
	Возврат ДанныеСчета;
	
КонецФункции

Функция ПолучитьМаксКоличествоСубконто() Экспорт

	Возврат Метаданные.ПланыСчетов.Хозрасчетный.МаксКоличествоСубконто;

КонецФункции

Функция ВедетсяУчетПоСкладам(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоСкладам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады;

	Возврат УчетПоСкладам;

КонецФункции 

Функция ВедетсяСуммовойУчетПоСкладам(Счет) Экспорт

	СвойстваСчета      = ПолучитьСвойстваСчета(Счет);

	Если СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
		Возврат СвойстваСчета.ВидСубконто1Суммовой;
	ИначеЕсли СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
		Возврат СвойстваСчета.ВидСубконто2Суммовой;
	ИначеЕсли СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады Тогда
		Возврат СвойстваСчета.ВидСубконто3Суммовой;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция НаСчетеВедетсяПартионныйУчет(Счет) Экспорт

	СвойстваСчета  = ПолучитьСвойстваСчета(Счет);

	ПартионныйУчет = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии;

	Возврат ПартионныйУчет;

КонецФункции 

Функция НаСчетеВедетсяУчетПоОтгрузкам(Счет) Экспорт

	СвойстваСчета  = ПолучитьСвойстваСчета(Счет);

	УчетПоОтгрузкам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами;

	Возврат УчетПоОтгрузкам;

КонецФункции // НаСчетеВедетсяУчетПоОтгрузкам()

Функция КомиссионныйТовар(Счет) Экспорт

	Комиссионный = ТипЗнч(Счет) = Тип("ПланСчетовСсылка.Хозрасчетный")
		И Счет <> ПланыСчетов.Хозрасчетный.ПустаяСсылка()
		
		И Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссиюВсего);

	Возврат Комиссионный;

КонецФункции


Функция НаСчетеВедетсяУчетПоДокументамРасчетов(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоДокументамРасчетов = СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами
		ИЛИ СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами;

	Возврат УчетПоДокументамРасчетов;

КонецФункции

Функция НаСчетеВедетсяУчетПоКонтрагентам(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоКонтрагентам = СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты
		ИЛИ СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты;

	Возврат УчетПоКонтрагентам;

КонецФункции 

Функция НаСчетеВедетсяУчетПоДоговорам(Счет) Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоДоговорам = СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры
		ИЛИ СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;

	Возврат УчетПоДоговорам;

КонецФункции

Функция НаСчетеВедетсяУчетПоНоменклатурнымГруппам(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоНомГруппам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы;

	Возврат УчетПоНомГруппам;

КонецФункции

Функция НаСчетеВедетсяУчетПоСтатьямЗатрат(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);

	УчетПоСтатьямЗатрат = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат;

	Возврат УчетПоСтатьямЗатрат;

КонецФункции

Функция СчетВИерархии(Счет, Эталон) Экспорт

	Результат = Ложь;
	Если ЗначениеЗаполнено(Счет) Тогда
		Если ТипЗнч(Эталон) = Тип("Массив") Тогда
			Для каждого СчетЭталон Из Эталон Цикл
				Если Счет = СчетЭталон ИЛИ Счет.ПринадлежитЭлементу(СчетЭталон) Тогда
					Результат = Истина;
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
		Иначе	
			Результат = Счет = Эталон ИЛИ Счет.ПринадлежитЭлементу(Эталон);
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;

КонецФункции

Функция СчетаВИерархии(СчетГруппа) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СчетГруппа) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетГруппа", СчетГруппа);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&СчетГруппа)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");

КонецФункции


// Определяет счет учета материалов, переданных в переработку
Функция СчетУчетаМатериалыПереданныеВПереработку(Знач СчетВыбранныйПользователем = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(СчетВыбранныйПользователем)
		И СчетВыбранныйПользователем.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.МатериалыПереданныеВПереработку) Тогда
		Возврат СчетВыбранныйПользователем;
	Иначе
		Возврат ПланыСчетов.Хозрасчетный.МатериалыПереданныеВПереработку;
	КонецЕсли;
	
КонецФункции

// Определяет счет учета материалов, принятых в переработку и затем использованных
Функция СчетУчетаМатериалыПринятыеВПереработкуВПроизводстве(Знач СчетВыбранныйПользователем = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(СчетВыбранныйПользователем) Тогда
		Возврат СчетВыбранныйПользователем;
	Иначе
		Возврат ПланыСчетов.Хозрасчетный.МатериалыПринятыеВПереработкуВПроизводстве;
	КонецЕсли;
	
КонецФункции


Функция ДатаНачалаПереоценкиВалютыПоПравиламПриказа627() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаНачалаПереоценкиВалютыПоПравиламПриказа627 = Константы.ДатаНачалаПереоценкиВалютыПоПравиламПриказа627.Получить();
	Если НЕ ЗначениеЗаполнено(ДатаНачалаПереоценкиВалютыПоПравиламПриказа627) Тогда
		ДатаНачалаПереоценкиВалютыПоПравиламПриказа627 = '20131001';
	КонецЕсли;
	Возврат ДатаНачалаПереоценкиВалютыПоПравиламПриказа627;
	
КонецФункции

Функция ИспользуетсяОборотнаяНоменклатураВНТТ() Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ);

	ИспользуетсяОборотнаяНоменклатура = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура;

	Возврат ИспользуетсяОборотнаяНоменклатура;

КонецФункции // ИспользуетсяОборотнаяНоменклатура

Функция ИспользуетсяРазделениеПоСтавкамНДСВНТТ() Экспорт

	СвойстваСчета = ПолучитьСвойстваСчета(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ);

	ИспользуетсяРазделениеПоСтавкамНДС = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС;

	Возврат ИспользуетсяРазделениеПоСтавкамНДС;

КонецФункции // ИспользуетсяРазделениеПоСтавкамНДСВНТТ

