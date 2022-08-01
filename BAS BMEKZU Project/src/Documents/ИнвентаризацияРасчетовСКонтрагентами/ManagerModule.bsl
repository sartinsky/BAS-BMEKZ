#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

	// Акт инвентаризации расчетов (ИНВ-17)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНВ17";
	КомандаПечати.Представление = НСтр("ru='Акт инвентаризации расчетов (ИНВ-17)';uk='Акт інвентаризації розрахунків (ІНВ-17)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Инвентаризация2015";
	КомандаПечати.Представление =НСтр("ru='Акт инвентаризации (прик. Минфина №572 от 17.06.2015)';uk='Акт інвентаризації (нак. Мінфіна №572 від 17.06.2015)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Акт инвентаризации расчетов""';uk='Реєстр документів ""Акт інвентаризації розрахунків""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ПричинаПроведенияИнвентаризации");
	
	Возврат Результат;
	
КонецФункции


// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ17") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ИНВ17", НСтр("ru='ИНВ-17 (акт инвентаризации)';uk='ІНВ-17 (акт інвентаризації)'"), 
			ПечатьИНВ17(МассивОбъектов, ОбъектыПечати,ПараметрыВывода), , "Документ.ИнвентаризацияРасчетовСКонтрагентами.ПФ_MXL_ИНВ17", , Истина);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Инвентаризация2015") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Инвентаризация2015", НСтр("ru='Акт инвентаризации (прик. Минфина №572 от 17.06.2015)';uk='Акт інвентаризації (нак. Мінфіна №572 від 17.06.2015)'"), 
			 ПечатьИнвентаризации_2015(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИнвентаризацияРасчетовСКонтрагентами.ПФ_MXL_UK_Инвентаризация2015", , Истина);
	КонецЕсли;
	
	//ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

Функция ПечатьИНВ17(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	УстановитьПривилегированныйРежим(Истина);
	
	УстановитьПривилегированныйРежим(Истина);

	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	// Варианты заголовков разделов с подписями печатной формы	
	ЗаголовокРазделаПодписей = Новый Структура();
	ЗаголовокРазделаПодписей.Вставить("ПредседательКомиссии", НСтр("ru='Председатель комиссии';uk='Голова комісії'", КодЯзыкаПечать) );
	ЗаголовокРазделаПодписей.Вставить("ЧленыКомиссии", НСтр("ru='Члены комиссии';uk='Члени комісії'", КодЯзыкаПечать) );
	
	//	Данные для шапки акта
	ЗапросДокумент = Новый Запрос;
	
	ЗапросДокумент.Текст = 
	"ВЫБРАТЬ
	|	Инвентаризация.Дата КАК Дата,
	|	Инвентаризация.Организация КАК Организация,
	|	Инвентаризация.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации,
	|	Инвентаризация.ДатаОкончанияИнвентаризации КАК ДатаОкончанияИнвентаризации,
	|	Инвентаризация.ДокументОснованиеВид КАК ДокументОснованиеВид,
	|	Инвентаризация.ДокументОснованиеДата КАК ДокументОснованиеДата,
	|	Инвентаризация.ДокументОснованиеНомер КАК ДокументОснованиеНомер,
	|	Инвентаризация.Номер КАК НомерДокумента
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами КАК Инвентаризация
	|ГДЕ
	|	Инвентаризация.Ссылка = &ТекущийДокумент";  
	
	//	Данные строк таблиц
	ЗапросКонтрагенты = Новый Запрос;
	
	ЗапросКонтрагенты.Текст = 
	"ВЫБРАТЬ
	|	Инвентаризация.ВидЗадолженности КАК ВидЗадолженности,
	|	Инвентаризация.Контрагент КАК Контрагент,
	|	ЕСТЬNULL(Инвентаризация.Контрагент.Наименование, """") КАК КонтрагентНаименование,
	|	ЕСТЬNULL(ПОДСТРОКА(Инвентаризация.Контрагент.НаименованиеПолное, 1, 200), """") КАК КонтрагентНаименованиеПолное,
	|	Инвентаризация.СчетРасчетов КАК СчетРасчетов,
	|	ПРЕДСТАВЛЕНИЕ(Инвентаризация.СчетРасчетов) КАК СчетРасчетовПредставление,
	|	СУММА(Инвентаризация.Подтверждено + Инвентаризация.НеПодтверждено) КАК Всего,
	|	СУММА(Инвентаризация.Подтверждено) КАК Подтверждено,
	|	СУММА(Инвентаризация.НеПодтверждено) КАК НеПодтверждено,
	|	СУММА(Инвентаризация.ИстекСрокДавности) КАК ИстекСрокДавности
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами.Контрагенты КАК Инвентаризация
	|ГДЕ
	|	Инвентаризация.Ссылка = &ТекущийДокумент
	|
	|СГРУППИРОВАТЬ ПО
	|	Инвентаризация.ВидЗадолженности,
	|	Инвентаризация.Контрагент,
	|	Инвентаризация.СчетРасчетов,
	|	ЕСТЬNULL(Инвентаризация.Контрагент.Наименование, """"),
	|	ЕСТЬNULL(ПОДСТРОКА(Инвентаризация.Контрагент.НаименованиеПолное, 1, 200), """")
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентНаименование,
	|	Инвентаризация.СчетРасчетов.Порядок
	|ИТОГИ
	|	СУММА(Всего),
	|	СУММА(Подтверждено),
	|	СУММА(НеПодтверждено),
	|	СУММА(ИстекСрокДавности)
	|ПО
	|	ВидЗадолженности";
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияРасчетов_ИНВ17";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияРасчетовСКонтрагентами.ПФ_MXL_Инв17");
	
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
		
		ЗапросДокумент.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
		Выборка = ЗапросДокумент.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);
		
		ЗапросКонтрагенты.УстановитьПараметр("ТекущийДокумент", Ссылка);
		РезультатКонтрагенты = ЗапросКонтрагенты.Выполнить();
		
		
		// Формирование шапки
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(Выборка);
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Выборка.Организация, Выборка.Дата);

		Шапка.Параметры.Организация    = ?(ПустаяСтрока(ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,"ПолноеНаименование,",,КодЯзыкаПечать)),Выборка.НаименованиеОрганизации,
										ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,"ПолноеНаименование,  КодПоЕДРПОУ, КодПоДРФО,",,КодЯзыкаПечать));
		
		Шапка.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НомерДокумента,Истина,Истина);
		Шапка.Параметры.ДеньДокумента  = День(Выборка.Дата);
		Шапка.Параметры.МесяцДокумента = Сред(Формат(Выборка.Дата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'", КодЯзыкаПечать)), 
		Найти(Формат(Выборка.Дата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'",КодЯзыкаПечать)), " "));
		
		Шапка.Параметры.ДеньОснования = День(Выборка.ДокументОснованиеДата);
		Шапка.Параметры.МесяцОснования = Сред(Формат(Выборка.ДокументОснованиеДата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'", КодЯзыкаПечать)), 
		Найти(Формат(Выборка.ДокументОснованиеДата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'", КодЯзыкаПечать)), " "));
		Шапка.Параметры.ДокументОснованиеНомер = Выборка.ДокументОснованиеНомер;
		
		ТабДокумент.Вывести(Шапка);
		
		// Формирование строк дебиторской задолженности
		ПодвалТаблицыДт = Макет.ПолучитьОбласть("ПодвалТаблицыДт");
		СтрокаТаблицыДт = Макет.ПолучитьОбласть("СтрокаТаблицыДт");
		
		ВыборкаПоВидуЗадолженности = РезультатКонтрагенты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если ВыборкаПоВидуЗадолженности.НайтиСледующий(Перечисления.ВидыЗадолженности.Дебиторская, "ВидЗадолженности") Тогда
			
			ПодвалТаблицыДт.Параметры.Заполнить(ВыборкаПоВидуЗадолженности);
			
			ВыборкаПоКонтрагенту = ВыборкаПоВидуЗадолженности.Выбрать();
			Пока ВыборкаПоКонтрагенту.Следующий() Цикл
				СтрокаТаблицыДт.Параметры.Заполнить(ВыборкаПоКонтрагенту);
				СтрокаТаблицыДт.Параметры.КонтрагентПредставление = ?(ПустаяСтрока(ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное),
				ВыборкаПоКонтрагенту.КонтрагентНаименование, ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное);
				ТабДокумент.Вывести(СтрокаТаблицыДт);
			КонецЦикла;
			
		КонецЕсли;
		
		ТабДокумент.Вывести(ПодвалТаблицыДт);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Шапка оборотной стороны Акта
		ШапкаОборот = Макет.ПолучитьОбласть("ШапкаОборот");
		ТабДокумент.Вывести(ШапкаОборот);
		
		// Формирование строк кредиторской задолженности
		ПодвалТаблицыКт = Макет.ПолучитьОбласть("ПодвалТаблицыКт");
		СтрокаТаблицыКт = Макет.ПолучитьОбласть("СтрокаТаблицыКт");
		
		ВыборкаПоВидуЗадолженности.Сбросить();
		Если ВыборкаПоВидуЗадолженности.НайтиСледующий(Перечисления.ВидыЗадолженности.Кредиторская, "ВидЗадолженности") Тогда
			
			ПодвалТаблицыКт.Параметры.Заполнить(ВыборкаПоВидуЗадолженности);
			
			ВыборкаПоКонтрагенту = ВыборкаПоВидуЗадолженности.Выбрать();
			Пока ВыборкаПоКонтрагенту.Следующий() Цикл
				СтрокаТаблицыКт.Параметры.Заполнить(ВыборкаПоКонтрагенту);
				СтрокаТаблицыКт.Параметры.КонтрагентПредставление = ?(ПустаяСтрока(ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное),
				ВыборкаПоКонтрагенту.КонтрагентНаименование, ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное);
				ТабДокумент.Вывести(СтрокаТаблицыКт);
			КонецЦикла;
			
		КонецЕсли;
		
		ТабДокумент.Вывести(ПодвалТаблицыКт);
		
		// Подвал печатной формы
		Подвал = Макет.ПолучитьОбласть("Подвал");
		ТабДокумент.Вывести(Подвал);
		
		Подпись = Макет.ПолучитьОбласть("Подпись");   	
		
		// Выведем подпись председателя инвентаризационной комиссии
		Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
		Подпись.Параметры.Должность                = ВыборкаПоКомиссии.ПредседательКомиссииДолжность;
		Подпись.Параметры.РасшифровкаПодписи       = ВыборкаПоКомиссии.ПредседательКомиссииФИО;
		
		ТабДокумент.Вывести(Подпись);
		
		// Выведем подписи членов комиссии
		ВыводитьЗаголовок = Истина;
		
		// Сформируем список членов комиссии
		СписокЧленовКомиссии = Новый Массив();	
		
		НаименованиеЧленовКомиссии = Новый Массив;
		НаименованиеЧленовКомиссии.Добавить("ПервыйЧленКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ВторойЧленКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ТретийЧленКомиссии");
		
		// Сначала выведем членов комиссии из выборки
		Для Каждого ЧленКомиссии Из НаименованиеЧленовКомиссии Цикл
			
			Если НЕ ТабДокумент.ПроверитьВывод(Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
				
			КонецЕсли;
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок,ЗаголовокРазделаПодписей.ЧленыКомиссии,"");
			Подпись.Параметры.Должность                = ВыборкаПоКомиссии[ЧленКомиссии + "Должность"];
			Подпись.Параметры.РасшифровкаПодписи       = ВыборкаПоКомиссии[ЧленКомиссии + "ФИО"];
			
			ТабДокумент.Вывести(Подпись);
			
			ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
			
		КонецЦикла;     	
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
		НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьИнвентаризации_2015(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);

	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	
	// Варианты заголовков разделов с подписями печатной формы	
	ЗаголовокРазделаПодписей = Новый Структура();
	ЗаголовокРазделаПодписей.Вставить("ПредседательКомиссии", НСтр("ru='Голова комісії';uk='Голова комісії'", КодЯзыкаПечать) );
	ЗаголовокРазделаПодписей.Вставить("ЧленыКомиссии", НСтр("ru='Члени комісії';uk='Члени комісії'", КодЯзыкаПечать) );
	
	//	Данные для шапки акта
	ЗапросДокумент = Новый Запрос;
	
	ЗапросДокумент.Текст = 
	"ВЫБРАТЬ
	|	Инвентаризация.Дата КАК Дата,
	|	Инвентаризация.Организация КАК Организация,
	|	Инвентаризация.Организация.Наименование КАК НаименованиеОрганизации,
	|	Инвентаризация.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации,
	|	Инвентаризация.ДатаОкончанияИнвентаризации КАК ДатаОкончанияИнвентаризации,
	|	Инвентаризация.ДокументОснованиеВид КАК ДокументОснованиеВид,
	|	Инвентаризация.ДокументОснованиеДата КАК ДокументОснованиеДата,
	|	Инвентаризация.ДокументОснованиеНомер КАК ДокументОснованиеНомер,
	|	Инвентаризация.Номер КАК НомерДокумента
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами КАК Инвентаризация
	|ГДЕ
	|	Инвентаризация.Ссылка = &ТекущийДокумент";  
	
	//	Данные строк таблиц
	ЗапросКонтрагенты = Новый Запрос;
	
	ЗапросКонтрагенты.Текст = 
	"ВЫБРАТЬ
	|	Инвентаризация.ВидЗадолженности КАК ВидЗадолженности,
	|	Инвентаризация.Контрагент КАК Контрагент,
	|	ЕСТЬNULL(Инвентаризация.Контрагент.Наименование, """") КАК КонтрагентНаименование,
	|	ЕСТЬNULL(ПОДСТРОКА(Инвентаризация.Контрагент.НаименованиеПолное, 1, 200), """") КАК КонтрагентНаименованиеПолное,
	|	ЕСТЬNULL(Инвентаризация.Контрагент.КодПоЕДРПОУ, """") КАК КодПоЕДРПОУ,
	|	Инвентаризация.СчетРасчетов КАК СчетРасчетов,
	|	ПРЕДСТАВЛЕНИЕ(Инвентаризация.СчетРасчетов) КАК СчетРасчетовПредставление,
	|	СУММА(Инвентаризация.Подтверждено + Инвентаризация.НеПодтверждено) КАК Всего,
	|	СУММА(Инвентаризация.Подтверждено) КАК Подтверждено,
	|	СУММА(Инвентаризация.НеПодтверждено) КАК НеПодтверждено,
	|	СУММА(Инвентаризация.ИстекСрокДавности) КАК ИстекСрокДавности
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами.Контрагенты КАК Инвентаризация
	|ГДЕ
	|	Инвентаризация.Ссылка = &ТекущийДокумент
	|
	|СГРУППИРОВАТЬ ПО
	|	Инвентаризация.ВидЗадолженности,
	|	Инвентаризация.Контрагент,
	|	Инвентаризация.СчетРасчетов,
	|	ЕСТЬNULL(Инвентаризация.Контрагент.Наименование, """"),
	|	ЕСТЬNULL(ПОДСТРОКА(Инвентаризация.Контрагент.НаименованиеПолное, 1, 200), """"),
	|	ЕСТЬNULL(Инвентаризация.Контрагент.КодПоЕДРПОУ, """")
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентНаименование,
	|	Инвентаризация.СчетРасчетов.Порядок
	|ИТОГИ
	|	СУММА(Всего),
	|	СУММА(Подтверждено),
	|	СУММА(НеПодтверждено),
	|	СУММА(ИстекСрокДавности)
	|ПО
	|	ВидЗадолженности";
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияРасчетов_Инвентаризация2015";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияРасчетовСКонтрагентами.ПФ_MXL_UK_Инвентаризация2015");
	
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
		
		ЗапросДокумент.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
		Выборка = ЗапросДокумент.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);
		
		ЗапросКонтрагенты.УстановитьПараметр("ТекущийДокумент", Ссылка);
		РезультатКонтрагенты = ЗапросКонтрагенты.Выполнить();
		
		
		// Формирование шапки
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(Выборка);
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Выборка.Организация, Выборка.Дата);
		
		
		
		Шапка.Параметры.Организация    = ?(ПустаяСтрока(ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,"ПолноеНаименование,",,КодЯзыкаПечать)),Выборка.НаименованиеОрганизации,
										ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,"ПолноеНаименование,",,КодЯзыкаПечать));
		
		КодЕДРПОУ = ?(СведенияОбОрганизации.КодПоЕДРПОУ = Неопределено,СокрЛП(СведенияОбОрганизации.КодПоДРФО),СокрЛП(СведенияОбОрганизации.КодПоЕДРПОУ));
			
			Если Не ПустаяСтрока(КодЕДРПОУ) И СтрДлина(КодЕДРПОУ) = 8 Тогда
				Шапка.Параметры.КодЕДРПОУ1 = Сред(КодЕДРПОУ, 1, 1);
				Шапка.Параметры.КодЕДРПОУ2 = Сред(КодЕДРПОУ, 2, 1);
				Шапка.Параметры.КодЕДРПОУ3 = Сред(КодЕДРПОУ, 3, 1);
				Шапка.Параметры.КодЕДРПОУ4 = Сред(КодЕДРПОУ, 4, 1);
				Шапка.Параметры.КодЕДРПОУ5 = Сред(КодЕДРПОУ, 5, 1);
				Шапка.Параметры.КодЕДРПОУ6 = Сред(КодЕДРПОУ, 6, 1);
				Шапка.Параметры.КодЕДРПОУ7 = Сред(КодЕДРПОУ, 7, 1);
				Шапка.Параметры.КодЕДРПОУ8 = Сред(КодЕДРПОУ, 8, 1);
			КонецЕсли;

		
		Шапка.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НомерДокумента,Истина,Истина);
		Шапка.Параметры.ДеньДокумента  = День(Выборка.Дата);
		Шапка.Параметры.МесяцДокумента = Сред(Формат(Выборка.Дата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'", КодЯзыкаПечать)), 
		Найти(Формат(Выборка.Дата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'",КодЯзыкаПечать)), " "));
		
		Шапка.Параметры.ДеньОснования = День(Выборка.ДокументОснованиеДата);
		Шапка.Параметры.МесяцОснования = Сред(Формат(Выборка.ДокументОснованиеДата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'", КодЯзыкаПечать)), 
		Найти(Формат(Выборка.ДокументОснованиеДата, "ДЛФ=ДД;"+НСтр("ru='Л=ru';uk='Л=uk'", КодЯзыкаПечать)), " "));
		Шапка.Параметры.ДокументОснованиеНомер = Выборка.ДокументОснованиеНомер;
		
		ТабДокумент.Вывести(Шапка);
		
		ШапкаТаблицы 	= Макет.ПолучитьОбласть("ШапкаТаблицы");
		Нумерация	 	= Макет.ПолучитьОбласть("НумерацияКолонок");	
		СтрокаТаблицыДт	= Макет.ПолучитьОбласть("СтрокаТаблицыДт");
		ПодвалТаблицыДт	= Макет.ПолучитьОбласть("ПодвалТаблицыДт");
		СтрокаТаблицыКт	= Макет.ПолучитьОбласть("СтрокаТаблицыКт");
		ПодвалТаблицыКт	= Макет.ПолучитьОбласть("ПодвалТаблицыКт");
		
		// выведем шапку таблицы дебиторы
		ШапкаТаблицы.Параметры.ПараметрКолонки = "дебіторами";
		ШапкаТаблицы.Параметры.ЗаголовокШапки  = "1.  За  дебіторською  заборгованістю";
		ШапкаТаблицы.Параметры.ВидКонтрагента  = "Дебітор";
		ШапкаТаблицы.Параметры.ДтКт  			= "дебіторської";
		ШапкаТаблицы.Параметры.РасходДоход	= "витрати";
		ТабДокумент.Вывести(ШапкаТаблицы);
		ТабДокумент.Вывести(Нумерация);

		
		// Формирование строк дебиторской задолженности
		
		ВыборкаПоВидуЗадолженности = РезультатКонтрагенты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если ВыборкаПоВидуЗадолженности.НайтиСледующий(Перечисления.ВидыЗадолженности.Дебиторская, "ВидЗадолженности") Тогда
			
			ПодвалТаблицыДт.Параметры.Заполнить(ВыборкаПоВидуЗадолженности);
			
			ВыборкаПоКонтрагенту = ВыборкаПоВидуЗадолженности.Выбрать();
			Пока ВыборкаПоКонтрагенту.Следующий() Цикл
				СтрокаТаблицыДт.Параметры.Заполнить(ВыборкаПоКонтрагенту);
				СтрокаТаблицыДт.Параметры.КонтрагентПредставление = ?(ПустаяСтрока(ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное),
				ВыборкаПоКонтрагенту.КонтрагентНаименование, ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное);
				СтрокаТаблицыДт.Параметры.КодПоЕДРПОУ = ВыборкаПоКонтрагенту.КодПоЕДРПОУ;
				СтрокаТаблицыДт.Параметры.СчетРасчетовПредставление = ВыборкаПоКонтрагенту.СчетРасчетовПредставление;
				Если НЕ ТабДокумент.ПроверитьВывод(СтрокаТаблицыДт) Тогда
					// Выведем разрыв страницы
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабДокумент.Вывести(Нумерация);
					ТабДокумент.Вывести(СтрокаТаблицыДт);
				Иначе
					ТабДокумент.Вывести(СтрокаТаблицыДт);
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
		
		Если НЕ ТабДокумент.ПроверитьВывод(ПодвалТаблицыДт) Тогда
			// Выведем разрыв страницы
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабДокумент.Вывести(Нумерация);
			ТабДокумент.Вывести(ПодвалТаблицыДт);
		Иначе
			ТабДокумент.Вывести(ПодвалТаблицыДт);
		КонецЕсли;
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ШапкаТаблицы.Параметры.ПараметрКолонки = "кредиторами";
		ШапкаТаблицы.параметры.ЗаголовокШапки  = "2.  За  кредиторською  заборгованістю";
		ШапкаТаблицы.Параметры.ВидКонтрагента  = "Кредитор";
		ШапкаТаблицы.Параметры.ДтКт  			= "кредіторської";
		ШапкаТаблицы.Параметры.РасходДоход	= "доходи";
		ТабДокумент.Вывести(ШапкаТаблицы);
		ТабДокумент.Вывести(Нумерация);
		
		ВыборкаПоВидуЗадолженности.Сбросить();
		Если ВыборкаПоВидуЗадолженности.НайтиСледующий(Перечисления.ВидыЗадолженности.Кредиторская, "ВидЗадолженности") Тогда
			
			ПодвалТаблицыКт.Параметры.Заполнить(ВыборкаПоВидуЗадолженности);
			
			ВыборкаПоКонтрагенту = ВыборкаПоВидуЗадолженности.Выбрать();
			Пока ВыборкаПоКонтрагенту.Следующий() Цикл
				СтрокаТаблицыКт.Параметры.Заполнить(ВыборкаПоКонтрагенту);
				СтрокаТаблицыКт.Параметры.КонтрагентПредставление = ?(ПустаяСтрока(ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное),
				ВыборкаПоКонтрагенту.КонтрагентНаименование, ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное);
				СтрокаТаблицыКт.Параметры.КодПоЕДРПОУ = ВыборкаПоКонтрагенту.КодПоЕДРПОУ;
				СтрокаТаблицыКт.Параметры.СчетРасчетовПредставление = ВыборкаПоКонтрагенту.СчетРасчетовПредставление;
				Если НЕ ТабДокумент.ПроверитьВывод(СтрокаТаблицыКт) Тогда
				// Выведем разрыв страницы
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабДокумент.Вывести(Нумерация);
					ТабДокумент.Вывести(СтрокаТаблицыКт);
				Иначе
					ТабДокумент.Вывести(СтрокаТаблицыКт);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если НЕ ТабДокумент.ПроверитьВывод(ПодвалТаблицыКт) Тогда
			// Выведем разрыв страницы
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабДокумент.Вывести(Нумерация);
			ТабДокумент.Вывести(ПодвалТаблицыКт);
		Иначе
			ТабДокумент.Вывести(ПодвалТаблицыКт);
		КонецЕсли;
			
	// Подвал печатной формы
		Подвал = Макет.ПолучитьОбласть("Подвал");
		
		Если НЕ ТабДокумент.ПроверитьВывод(Подвал) Тогда
			// Выведем разрыв страницы
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабДокумент.Вывести(Подвал);
		Иначе
			ТабДокумент.Вывести(Подвал);
		КонецЕсли;
		
		Подпись = Макет.ПолучитьОбласть("Подпись"); 
		
			// Выведем подпись председателя инвентаризационной комиссии
		Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
		Подпись.Параметры.Должность                = ВыборкаПоКомиссии.ПредседательКомиссииДолжность;
		Подпись.Параметры.РасшифровкаПодписи       = ВыборкаПоКомиссии.ПредседательКомиссииФИО;
		
		ТабДокумент.Вывести(Подпись);
		
		// Выведем подписи членов комиссии
		ВыводитьЗаголовок = Истина;
		
		// Сформируем список членов комиссии
		СписокЧленовКомиссии = Новый Массив();	
		
		НаименованиеЧленовКомиссии = Новый Массив;
		НаименованиеЧленовКомиссии.Добавить("ПервыйЧленКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ВторойЧленКомиссии");
		НаименованиеЧленовКомиссии.Добавить("ТретийЧленКомиссии");
		
		// Сначала выведем членов комиссии из выборки
		Для Каждого ЧленКомиссии Из НаименованиеЧленовКомиссии Цикл
			
			Если НЕ ТабДокумент.ПроверитьВывод(Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
				
			КонецЕсли;
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок,ЗаголовокРазделаПодписей.ЧленыКомиссии,"");
			Подпись.Параметры.Должность                = ВыборкаПоКомиссии[ЧленКомиссии + "Должность"];
			Подпись.Параметры.РасшифровкаПодписи       = ВыборкаПоКомиссии[ЧленКомиссии + "ФИО"];
			
			ТабДокумент.Вывести(Подпись);
			
			ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
			
		КонецЦикла;     	
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
		НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
	
	Возврат ТабДокумент;
	
КонецФункции // ПечатьИнвентаризации_2015()

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты, ДокументОбъектИлиФорма = Неопределено, ВФорме = Ложь) Экспорт

	МассивНепроверяемыхРеквизитов = Новый Массив();

	// Если Контрагент или СчетРасчетов не заполнены, то ошибка не выведется, т.к. визуально табличная часть
	//  Контрагенты на форме не представлена. Надо обрабатывать вручную.
	МассивНепроверяемыхРеквизитов.Добавить("Контрагенты.Контрагент");
	МассивНепроверяемыхРеквизитов.Добавить("Контрагенты.СчетРасчетов");

	Если ВФорме Тогда
		Объект = ДокументОбъектИлиФорма.Объект;
		ДокументОбъект = Неопределено;
	Иначе
		Объект = ДокументОбъектИлиФорма;
		ДокументОбъект = ДокументОбъектИлиФорма;
	КонецЕсли;

	// Таблицы значений можно проверить только в форме
	Если ВФорме Тогда
		НомерСтрокиДебиторов  = 0;
		НомерСтрокиКредиторов = 0;
		Для Каждого СтрокаТаблицы Из Объект.Контрагенты Цикл
			// В каждой строке табличной части "Контрагенты" должно быть заполнено или Подтверждено или НеПодтверждено
			Если (СтрокаТаблицы.Подтверждено = 0) И (СтрокаТаблицы.НеПодтверждено = 0) Тогда
				Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Колонка",
						"Корректность",
						НСтр("ru='Всего';uk='Всього'"),
						НомерСтрокиДебиторов + 1,
						"Дебиторы",
						"Должна быть заполнена хотя бы одна из сумм: Подтверждено или Не подтверждено.");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дебиторы[" + Формат(НомерСтрокиДебиторов, "ЧН=0; ЧГ=") + "].Всего", , Отказ);
				Иначе
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Колонка",
						"Корректность",
						НСтр("ru='Всего';uk='Всього'"),
						НомерСтрокиКредиторов + 1,
						"Кредиторы",
						"Должна быть заполнена хотя бы одна из сумм: Подтверждено или Не подтверждено.");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Кредиторы[" + Формат(НомерСтрокиКредиторов, "ЧН=0; ЧГ=") + "].Всего", , Отказ);
				КонецЕсли;
			КонецЕсли;
			Если СтрокаТаблицы.Контрагент.Пустая() Тогда
				Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Колонка",
						"Заполнение",
						НСтр("ru='Контрагент';uk='Контрагент'"),
						НомерСтрокиДебиторов + 1,
						"Дебиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дебиторы[" + Формат(НомерСтрокиДебиторов, "ЧН=0; ЧГ=") + "].Контрагент", , Отказ);
				Иначе
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Колонка",
						"Заполнение",
						НСтр("ru='Контрагент';uk='Контрагент'"),
						НомерСтрокиКредиторов + 1,
						"Кредиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Кредиторы[" + Формат(НомерСтрокиКредиторов, "ЧН=0; ЧГ=") + "].Контрагент", , Отказ);
				КонецЕсли;
			КонецЕсли;
			Если СтрокаТаблицы.СчетРасчетов.Пустая() Тогда
				Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Колонка",
						"Заполнение",
						НСтр("ru='СчетРасчетов';uk='СчетРасчетов'"),
						НомерСтрокиДебиторов + 1,
						"Дебиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дебиторы[" + Формат(НомерСтрокиДебиторов, "ЧН=0; ЧГ=") + "].СчетРасчетов", , Отказ);
				Иначе
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(
						"Колонка",
						"Заполнение",
						НСтр("ru='СчетРасчетов';uk='СчетРасчетов'"),
						НомерСтрокиКредиторов + 1,
						"Кредиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Кредиторы[" + Формат(НомерСтрокиКредиторов, "ЧН=0; ЧГ=") + "].СчетРасчетов", , Отказ);
				КонецЕсли;
			КонецЕсли;
			Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				НомерСтрокиДебиторов  = НомерСтрокиДебиторов + 1;
			Иначе
				НомерСтрокиКредиторов = НомерСтрокиКредиторов + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#КонецЕсли