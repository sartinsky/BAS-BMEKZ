
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ОШИБКАМИ

// Формирует текст сообщения, подставляя значения
// параметров в шаблоны сообщений.
//
// Параметры
//  ВидПоля       - Строка - может принимать значения:
//                  Поле, Колонка, Список
//  ВидСообщения  - Строка - может принимать значения:
//                  Заполнение, Корректность
//  Параметр1     - Строка - имя поля
//  Параметр2     - Строка - номер строки
//  Параметр3     - Строка - имя списка
//  Параметр4     - Строка - текст сообщения о некорректности заполнения
//
// Возвращаемое значение:
//   Строка - текст сообщения
//
Функция ПолучитьТекстСообщения(ВидПоля = "Поле", ВидСообщения = "Заполнение",
	Параметр1 = "", Параметр2 = "",	Параметр3 = "", Параметр4 = "") Экспорт

	ТекстСообщения = "";

	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru='Поле ""%1"" не заполнено';uk='Поле ""%1"" не заповнене'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru='Поле ""%1"" заполнено некорректно.
|
|%4';uk='Поле ""%1"" заповнене некоректно.
|
|%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru='Не заполнена колонка ""%1"" в строке %2 списка ""%3""';uk='Не заповнений стовпчик ""%1"" у рядку %2 списку ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru='Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
|
|%4';uk='Некоректно заповнений стовпчик ""%1"" у рядку %2 списку ""%3"".
|
|%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru='Не введено ни одной строки в список ""%3""';uk='Не введено жодного рядка в список ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru='Некорректно заполнен список ""%3"".
|
|%4';uk='Некоректно заповнений список ""%3"".
|
|%4'");
		КонецЕсли;
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметр1, Параметр2, Параметр3, Параметр4);

КонецФункции // ПолучитьТекстСообщения()


// Функция убирает из текста сообщения служебную информацию
//
// Параметры
//  ТекстСообщения, Строка, исходный текст сообщения//
// Возвращаемое значение:
//   Строка
//
Функция СформироватьТекстСообщения(Знач ТекстСообщения) Экспорт

	НачалоСлужебногоСообщения    = Найти(ТекстСообщения, "{");
	ОкончаниеСлужебногоСообщения = Найти(ТекстСообщения, "}:");

	Если ОкончаниеСлужебногоСообщения > 0
		И НачалоСлужебногоСообщения > 0
		И НачалоСлужебногоСообщения < ОкончаниеСлужебногоСообщения Тогда

		ТекстСообщения = Лев(ТекстСообщения, (НачалоСлужебногоСообщения - 1)) +
		                 Сред(ТекстСообщения, (ОкончаниеСлужебногоСообщения + 2));

	КонецЕсли;

	Возврат СокрЛП(ТекстСообщения);

КонецФункции // ()

Процедура СообщитьОбОшибке(Знач ТекстСообщения, Отказ = Ложь, Заголовок = "", Знач Статус = Неопределено, ВызыватьИсключение = Истина) Экспорт

	Если Статус = Неопределено Тогда
		Статус = СтатусСообщения.Важное;
	КонецЕсли;

	ТекстСообщения = СформироватьТекстСообщения(ТекстСообщения);
	Отказ = Истина;

	#Если ВнешнееСоединение Тогда

		Если ВызыватьИсключение Тогда
			Если ЗначениеЗаполнено(Заголовок) Тогда
				ТекстСообщения = Заголовок + Символы.ПС + ТекстСообщения;
				Заголовок = "";
			КонецЕсли;

			ВызватьИсключение (ТекстСообщения);
		КонецЕсли;

	#Иначе

		Если ЗначениеЗаполнено(Заголовок) Тогда
			Сообщить(Заголовок);
			Заголовок = "";
		КонецЕсли;

		Сообщить(ТекстСообщения, Статус);

	#КонецЕсли

КонецПроцедуры // СообщитьОбОшибке()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ТИПАМИ

// Служебная функция, предназначенная для получения описания типов строки, заданной длины.
//
// Параметры:
//  ДлинаСтроки - число, длина строки.
//
// Возвращаемое значение:
//  Объект "ОписаниеТипов" для строки указанной длины.
//
Функция ПолучитьОписаниеТиповСтроки(ДлинаСтроки) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));

	КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная);

	Возврат Новый ОписаниеТипов(Массив, , КвалификаторСтроки);

КонецФункции // ПолучитьОписаниеТиповСтроки()

// Служебная функция, предназначенная для получения описания типов числа, заданной разрядности.
//
// Параметры:
//  Разрядность 			- число, разряд числа.
//  РазрядностьДробнойЧасти - число, разряд дробной части.
//  ЗнакЧисла				- ДопустимыйЗнак, знак числа
//
// Возвращаемое значение:
//  Объект "ОписаниеТипов" для числа указанной разрядности.
//
Функция ПолучитьОписаниеТиповЧисла(Разрядность, РазрядностьДробнойЧасти = 0, ЗнакЧисла = Неопределено) Экспорт

	Если ЗнакЧисла = Неопределено Тогда
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти);
	Иначе
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	КонецЕсли;

	Возврат Новый ОписаниеТипов("Число", КвалификаторЧисла);

КонецФункции // ПолучитьОписаниеТиповЧисла()

// Служебная функция, предназначенная для получения описания типов даты
//
// Параметры:
//  ЧастиДаты - системное перечисление ЧастиДаты.
//
Функция ПолучитьОписаниеТиповДаты(ЧастиДаты) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Дата"));

	КвалификаторДаты = Новый КвалификаторыДаты(ЧастиДаты);

	Возврат Новый ОписаниеТипов(Массив, , , КвалификаторДаты);

КонецФункции // ПолучитьОписаниеТиповДаты()

////////////////////////////////////////////////////////////////////////////////
// МАТЕМАТИКА

// Функция выполняет пропорциональное распределение суммы в соответствии
// с заданными коэффициентами распределения
//
// Параметры:
//		ИсхСумма - распределяемая сумма
//		МассивКоэф - массив коэффициентов распределения
//		Точность - точность округления при распределении. Необязателен.
//
//	Возврат:
//		МассивСумм - массив размерностью равный массиву коэффициентов, содержит
//			суммы в соответствии с весом коэффициента (из массива коэффициентов)
//          В случае если распределить не удалось (сумма = 0, кол-во коэф. = 0,
//          или суммарный вес коэф. = 0), тогда возвращается значение Неопределено
//
Функция РаспределитьПропорционально(Знач ИсхСумма, МассивКоэф, Знач Точность = 2) Экспорт

	Если МассивКоэф.Количество() = 0 Или ИсхСумма = 0 Или ИсхСумма = Null Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИндексМакс = 0;
	МаксЗнач   = 0;
	РаспрСумма = 0;
	СуммаКоэф  = 0;

	Для К = 0 По МассивКоэф.Количество() - 1 Цикл

		МодульЧисла = ?(МассивКоэф[К] > 0, МассивКоэф[К], - МассивКоэф[К]);

		Если МаксЗнач < МодульЧисла Тогда
			МаксЗнач = МодульЧисла;
			ИндексМакс = К;
		КонецЕсли;

		СуммаКоэф = СуммаКоэф + МассивКоэф[К];

	КонецЦикла;

	Если СуммаКоэф = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	МассивСумм = Новый Массив(МассивКоэф.Количество());

	Для К = 0 По МассивКоэф.Количество() - 1 Цикл
		МассивСумм[К] = Окр(ИсхСумма * МассивКоэф[К] / СуммаКоэф, Точность, 1);
		РаспрСумма = РаспрСумма + МассивСумм[К];
	КонецЦикла;

	// Погрешности округления отнесем на коэффициент с максимальным весом
	Если Не РаспрСумма = ИсхСумма Тогда
		МассивСумм[ИндексМакс] = МассивСумм[ИндексМакс] + ИсхСумма - РаспрСумма;
	КонецЕсли;

	Возврат МассивСумм;

КонецФункции // РаспределитьПропорционально()

// Предназначена для получения пустого значения заданного типа:
//	примитивного, или ссылочного. Используется
//
// Параметры:
//	ЗаданныйТип   - тип, пустое значение которого нужно получить
//
Функция ПустоеЗначениеТипа(ЗаданныйТип) Экспорт

	Если ЗаданныйТип = Тип("Число") Тогда
		Возврат 0;

	ИначеЕсли ЗаданныйТип = Тип("Строка") Тогда
		Возврат "";

	ИначеЕсли ЗаданныйТип = Тип("Дата") Тогда
		Возврат '00010101000000';

	ИначеЕсли ЗаданныйТип = Тип("Булево") Тогда
		Возврат Ложь;

	Иначе
		Возврат Новый (ЗаданныйТип);

	КонецЕсли;

КонецФункции // ПустоеЗначениеТипа();

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С МАССИВАМИ

// Удаление из массива пустых элементов
//
// Параметры:
//   МассивЭлементов - Массив
//
Процедура УдалитьНеЗаполненныеЭлементыМассива(МассивЭлементов) Экспорт

	Колво = МассивЭлементов.Количество();
	Для н=1 По Колво Цикл
		Если НЕ ЗначениеЗаполнено(МассивЭлементов[Колво-н]) Тогда
			МассивЭлементов.Удалить(Колво-н);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Функция проверяет, что две переданные даты находятся между разными элементами 
// упорядоченного массива.
//
// Параметры:
//	Дата1, Дата2 - две даты, которые необходимо проверить
//	ИнтервалДат - упорядоченный массив дат, каждый элемент которого определяет 
//					новую границу интервала
//
Функция ДатыПринадлежатРазнымИнтервалам(Знач Дата1, Знач Дата2, ИнтервалДат) Экспорт

	Результат = Ложь;

	Индекс1 = -1;
	
	Индекс2 = -1;
	
	Дата1 = НачалоДня(Дата1);
	Дата2 = НачалоДня(Дата2);
	
	ВГраницаИнтервалаДат = ИнтервалДат.ВГраница();
	Для ТекИндекс = 0 По ВГраницаИнтервалаДат Цикл
		ДатаИнтервала = НачалоДня(ИнтервалДат[ТекИндекс]);
	
		Если ДатаИнтервала <= Дата1 Тогда
			Индекс1 = ТекИндекс;
		КонецЕсли;
		
		Если ДатаИнтервала <= Дата2 Тогда
			Индекс2 = ТекИндекс;
		КонецЕсли;
		
	КонецЦикла;

	Если Индекс1 <> Индекс2 Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФУНКЦИОНАЛЬНЫМИ ОПЦИЯМИ

Процедура УстановитьПараметрОрганизацияФункциональныхОпцийФормы(Форма, Организация, Период = Неопределено) Экспорт

	ПараметрыФО = Новый Структура();
	ПараметрыФО.Вставить("Организация", Организация);
	Если Период <> Неопределено Тогда
		ПараметрыФО.Вставить("Период", НачалоМесяца(Период));
		// Приводим к началу месяца для того, чтобы сократить пространство кэшируемых значений.
		// Параметр "Организация" используется в функциональных опциях, привязанных к регистрам сведений с периодичностью Месяц или реже.
	КонецЕсли;
	
	Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

Процедура УстановитьПараметрыФункциональныхОпцийФормыДокумента(Форма) Экспорт
	
	УстановитьПараметрОрганизацияФункциональныхОпцийФормы(Форма, Форма.Объект.Организация, Форма.Объект.Дата);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

Функция ПолучитьИнформациюКурсаВалютыСтрокой(Валюта, Курс, Кратность, ВалютаРегламентированногоУчета, СформироватьСкобки = Ложь) Экспорт

	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		Возврат "";

	Иначе
		Возврат ?(СформироватьСкобки, "   ( ", "") + Кратность + " "
		      + СокрЛП(Валюта)
		      + " = "
		      + Курс + " "
		      + СокрЛП(ВалютаРегламентированногоУчета)
		      + ?(СформироватьСкобки, " )", "");
	КонецЕсли;

КонецФункции // ПолучитьИнформациюКурсаВалютыСтрокой()

// Функция возвращает текст надписи "Цены и валюта".
//
Функция СформироватьНадписьЦеныИВалюта(СтруктураНадписи) Экспорт
	Перем ВалютаРегламентированногоУчета;
	
	ТекстНадписи = "";
	
	Если НЕ СтруктураНадписи.Свойство("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета) Тогда
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
	// Валюта.
	Если СтруктураНадписи.Свойство("ВалютаДокумента") Тогда
		Если ЗначениеЗаполнено(СтруктураНадписи.ВалютаДокумента) Тогда
			Если (СтруктураНадписи.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда
				ТекстНадписи = НСтр("ru='%1 %2 = %3 %4';uk='%1 %2 = %3 %4'");
				ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстНадписи,
					СтруктураНадписи.Кратность,
					СтруктураНадписи.ВалютаДокумента,
					СтруктураНадписи.Курс,
					ВалютаРегламентированногоУчета);
			ИначеЕсли НЕ СтруктураНадписи.Свойство("СуммаВключаетНДС") 
				И НЕ СтруктураНадписи.Свойство("ТипЦен") Тогда 
				ТекстНадписи = НСтр("ru='Валюта: <нет>';uk='Валюта: <немає>'");
				ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Валюта: %1';uk='Валюта: %1'"),
					ВалютаРегламентированногоУчета);
			КонецЕсли;
		ИначеЕсли СтруктураНадписи.ВалютаДокумента <> Неопределено Тогда // Передана пустая ссылка
			ТекстНадписи = НСтр("ru='Валюта: <нет>';uk='Валюта: <немає>'");
		КонецЕсли;
	КонецЕсли;

	// Флаг сумма включает НДС.
	Если СтруктураНадписи.Свойство("СуммаВключаетНДС") Тогда
		Если ТипЗнч(СтруктураНадписи.СуммаВключаетНДС) = Тип("Булево") Тогда
			ТекстНадписи = ТекстНадписи + ?(ПустаяСтрока(ТекстНадписи), "", ", ")
				+ ?(СтруктураНадписи.СуммаВключаетНДС, НСтр("ru='Цена включает НДС';uk='Ціна включає ПДВ'"), НСтр("ru='Цена не включает НДС';uk='Ціна не включає ПДВ'"));
		КонецЕсли;
	КонецЕсли;

	// Тип цен.
	Если СтруктураНадписи.Свойство("ТипЦен") Тогда
		Если ЗначениеЗаполнено(СтруктураНадписи.ТипЦен) Тогда
			ТекстНадписи = ТекстНадписи + ?(ПустаяСтрока(ТекстНадписи), "", ", ") + НСтр("ru='Тип цен: %1';uk='Тип цін: %1'");
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНадписи, СтруктураНадписи.ТипЦен);
		ИначеЕсли ПустаяСтрока(ТекстНадписи) Тогда
			ТекстНадписи = НСтр("ru='Тип цен: <не указан>';uk='Тип цін: <не вказано>'");
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураНадписи.Свойство("АвторасчетНДС") Тогда
		Если СтруктураНадписи.АвторасчетНДС Тогда
			ТекстНадписи = ТекстНадписи + ?(ПустаяСтрока(ТекстНадписи), "", ", ")+  НСтр("ru='Автоматический расчет НДС';uk='Автоматичний розрахунок ПДВ'");
		КонецЕсли;
	КонецЕсли;

	Возврат ТекстНадписи;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАСТРОЙКИ ПАРАМЕТРОВ УЧЕТА

Функция СтруктураПараметровУчета() Экспорт

	Возврат Новый Структура(
		"ВестиПартионныйУчет,
		|СкладскойУчет,
		|ИспользоватьОборотнуюНоменклатуру,
		|РазделятьПоСтавкамНДС,
		|ВестиРасчетыПоДокументам,
		|ИспользоватьКлассыСчетовВКачествеГрупп,
		|КассыОбособленныхПодразделений,
		|ВестиУчетПоРаботникам,
		|УчетЗарплатыИКадровВоВнешнейПрограмме,
		|КадровыйУчет");

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ СО СПИСКАМИ

Функция ПолучитьСтруктуруОтбораСписка(КоллекцияЭлементовОтбора) Экспорт
	
	СтруктураОтбора = Новый Структура;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементовОтбора Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементОтбора.Использование Тогда
			
			Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда 
				
				СтруктураОтбора.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураОтбора;
	
КонецФункции

// Функция формирует список доступных способов расчета комиссионного вознаграждения, 
// в зависимости от типа комиссиионного договора
//
Функция СформироватьСписокСпособовРасчетаКомиссионногоВознаграждения() Экспорт

	СписокСпособов = Новый СписокЗначений;
	
	СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается"), НСтр("ru='Не рассчитывается';uk='Не розраховується'"));
	СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтРазностиСуммПродажиИПоступления"), НСтр("ru='Процент от разности сумм продажи и поступления';uk='Відсоток від різниці сум продажу й надходження'"));
	СписокСпособов.Добавить(ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтСуммыПродажи"), НСтр("ru='Процент от суммы продажи';uk='Відсоток від суми продажу'"));

	Возврат СписокСпособов;

КонецФункции // СформироватьСписокСпособовРасчетаКомиссионногоВознаграждения()


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ С ОБОСОБЛЕННЫМИ ПОДРАЗДЕЛЕНИЯМИ
//

Процедура УстановитьЗначениеПолеОрганизация(ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Ключ = СтрЗаменить(Строка(ВключатьОбособленныеПодразделения) + Организация.УникальныйИдентификатор(), "-", "");
	ПолеОрганизация = Ключ;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СТРОКОВЫЕ ФУНКЦИИ

Функция ОставитьВСтрокеТолькоЦифры(ИсходнаяСтрока) Экспорт
	
	СтрокаРезультат = "";
	
	Для а = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, а, 1);
		КодСимвола = КодСимвола(ТекущийСимвол);
		Если КодСимвола >= 48 И КодСимвола <= 57 Тогда
			СтрокаРезультат = СтрокаРезультат + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаРезультат;
	
КонецФункции

// Функция преобразует строку к множественному числу
//
// Параметры: 
//  Слово1 - форма слова в ед числе      ("шкаф")
//  Слово2 - форма слова для числит 2-4  ("шкафа")
//  Слово3 - форма слова для числит 5-10 ("шкафов")
//  ЦелоеЧисло - целое число
//
// Возвращаемое значение:
//  строку - одну из строк в зависимости от параметра ЦелоеЧисло
//
// Описание:
//  Предназначена для формирования "правильной" подписи к числительным
//
Функция ФормаМножественногоЧисла(Слово1, Слово2, Слово3, Знач ЦелоеЧисло) Экспорт
	
	// Изменим знак целого числа, иначе отрицательные числа будут неправильно преобразовываться
	Если ЦелоеЧисло < 0 Тогда
		ЦелоеЧисло = -1 * ЦелоеЧисло;
	КонецЕсли;
	
	Если ЦелоеЧисло <> Цел(ЦелоеЧисло) Тогда 
		// для нецелых чисел - всегда вторая форма
		Возврат Слово2;
	КонецЕсли;
	
	// остаток
	Остаток = ЦелоеЧисло%10;
	Если (ЦелоеЧисло >10) И (ЦелоеЧисло<20) Тогда
		// для второго десятка - всегда третья форма
		Возврат Слово3;
	ИначеЕсли Остаток=1 Тогда
		Возврат Слово1;
	ИначеЕсли (Остаток>1) И (Остаток<5) Тогда
		Возврат Слово2;
	Иначе
		Возврат Слово3;
	КонецЕсли;

КонецФункции


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ СО СПИСКОМ ДОСТУПНЫХ ОРГАНИЗАЦИЙ

// Функция проверяет, что у текущего пользователя разрешено требуемое право доступа по RLS на указанную организацию.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация, доступ к которой нужно проверить
//  ПравоНаИзменение - Булево
//			- Истина - если нужно проверить, что у пользователя есть право на изменение;
//		 	- Ложь - если нужно проверить, что у него есть право на чтение
//Возвращаемое значение:
//  Булево:
// 		Истина 	- Есть требуемое право, 
//		Ложь 	- в противном случае
//
Функция ОрганизацияДоступна(Организация, ПравоНаИзменение = Ложь) Экспорт
	
	МассивДоступныхОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ПравоНаИзменение);

	Возврат МассивДоступныхОрганизаций.Найти(Организация) <> Неопределено;	
	
КонецФункции	

// Удаляет из переданного списка организаций недоступные текущему пользователю
// 
// Параметры:
//	СписокОрганизаций - СписокЗначений - Список организаций, доступ к которым нужно проверить 
//		* СправочникСсылка.Организации 
//  ПравоНаИзменение - Булево 
//		Истина - если нужно проверить, что у пользователя есть право на изменение;
//		Ложь - если нужно проверить, что у него есть право на чтение
//
Процедура УбратьНедоступныеОрганизацииИзСписка(СписокОрганизаций, ПравоНаИзменение = Ложь) Экспорт
	
	Если ТипЗнч(СписокОрганизаций) = Тип("СписокЗначений") Тогда
		
		НедоступныеОрганизации = Новый Массив;
		
		ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ПравоНаИзменение);	
		
		Для Каждого ЭлементСписка Из СписокОрганизаций Цикл
			
			Если ДоступныеОрганизации.Найти(ЭлементСписка.Значение) = Неопределено Тогда
				
				  НедоступныеОрганизации.Добавить(ЭлементСписка);
				
			КонецЕсли;	
				
		КонецЦикла;	
		
		Для Каждого ЭлементСписка Из НедоступныеОрганизации Цикл
			
			 СписокОрганизаций.Удалить(ЭлементСписка);
			
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры	

