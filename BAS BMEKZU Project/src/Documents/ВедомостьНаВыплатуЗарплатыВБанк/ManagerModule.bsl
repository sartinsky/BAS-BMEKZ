
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
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";

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
	
	// Список перечислений
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СписокПеречислений";
	КомандаПечати.Представление = НСтр("ru='Список перечислений';uk='Список перерахувань'");
	

	
	// Список перечислений в Microsoft Word
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СписокПеречислений";
	КомандаПечати.Представление = НСтр("ru='Список перечислений в Microsoft Word';uk='Список перерахувань в Microsoft Word'");
	КомандаПечати.ФорматСохранения = ТипФайлаТабличногоДокумента.DOCX;
	
	
	// Список перечисления налогов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СписокПеречисленийНалоги";
	КомандаПечати.Представление = НСтр("ru='Список перечисления налогов';uk='Список перерахування податків'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Ведомость на выплату зарплаты через банк""';uk='Реєстр документів ""Відомість на виплату зарплати через банк""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокПеречислений") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокПеречислений", НСтр("ru='Список получателей';uk='Список одержувачів'"), ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ВедомостьНаВыплатуЗарплатыВБанк.ПФ_MXL_СписокПеречислений", , Истина);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокПеречисленийНалоги") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокПеречисленийНалоги", НСтр("ru='Список налогов';uk='Список податків'"), ПечатьСписокПеречисленийНалоги(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ВедомостьНаВыплатуЗарплатыВБанк.ПФ_MXL_СписокПеречисленийНалоги", , Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВедомостьНаВыплатуЗарплатыВБанк_СписокПеречислений";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВедомостьНаВыплатуЗарплатыВБанк.ПФ_MXL_СписокПеречислений");
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
    Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	// получаем данные для печати
	ВыборкаШапок = ВыборкаДляПечатиШапки(МассивОбъектов);
	ВыборкаСтрок = ВыборкаДляПечатиТаблицы(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// подсчитываем количество страниц документа - для корректного разбиения на страницы
		ВсегоСтрокДокумента = ВыборкаСтрок.Количество();

		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		// массив с двумя строками - для разбиения на страницы
	    ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		// выводим данные о документе
 		ОбластьМакетаШапкаДокумента.Параметры.Дата = ВыборкаШапок.Дата;
 		ОбластьМакетаШапкаДокумента.Параметры.Организация = ВРег(ВыборкаШапок.Организация.НаименованиеПолное);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		// выводим данные по строкам документа.
		ВыборкаСтрок.Сбросить();
		Пока ВыборкаСтрок.НайтиСледующий(ВыборкаШапок.Ссылка, "Ведомость") Цикл
		
			ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаСтрок);
			ОбластьМакетаСтрока.Параметры.Физлицо = ВыборкаСтрок.Фамилия +" "+ ВыборкаСтрок.Имя +" "+ ВыборкаСтрок.Отчество;
			ОбластьМакетаСтрока.Параметры.КодПоДРФО = ?(СокрЛП(ВыборкаСтрок.КодПоДРФО)="",""," (" +  ВыборкаСтрок.КодПоДРФО + ")");
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ТабличныйДокумент.ПроверитьВывод(ВыводимыеОбласти);

			Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ТабличныйДокумент.ПроверитьВывод(ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаСтрок.Сумма;
			Итого = Итого + ВыборкаСтрок.Сумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаШапок);
		ОбластьМакетаПодвал.Параметры.Итого = Итого;
		ОбластьМакетаПодвал.Параметры.Руководитель = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(ОбластьМакетаПодвал.Параметры.Руководитель);
		ОбластьМакетаПодвал.Параметры.ГлавныйБухгалтер = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(ОбластьМакетаПодвал.Параметры.ГлавныйБухгалтер);
		ОбластьМакетаПодвал.Параметры.Бухгалтер = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(ОбластьМакетаПодвал.Параметры.Бухгалтер);
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьСписокПеречисленийНалоги(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВедомостьНаВыплатуЗарплатыВБанк_СписокПеречисленийНалоги";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВедомостьНаВыплатуЗарплатыВБанк.ПФ_MXL_СписокПеречисленийНалоги");
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
    Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	// получаем данные для печати
	ВыборкаШапок = ВыборкаДляПечатиШапки(МассивОбъектов);
	ВыборкаСтрок = ВыборкаДляПечатиТаблицыНалоги(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		НомерСтроки = 0;
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// подсчитываем количество страниц документа - для корректного разбиения на страницы
		ВсегоСтрокДокумента = ВыборкаСтрок.Количество();

		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		// массив с двумя строками - для разбиения на страницы
	    ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		// выводим данные о документе
 		ОбластьМакетаШапкаДокумента.Параметры.Дата = ВыборкаШапок.Дата;
 		ОбластьМакетаШапкаДокумента.Параметры.Организация = ВРег(ВыборкаШапок.Организация.НаименованиеПолное);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		// выводим данные по строкам документа.
		ВыборкаСтрок.Сбросить();
		Пока ВыборкаСтрок.НайтиСледующий(ВыборкаШапок.Ссылка, "Ведомость") Цикл
			
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьМакетаСтрока.Параметры.НомерСтроки = НомерСтроки;
			ОбластьМакетаСтрока.Параметры.Сумма = ВыборкаСтрок.Сумма;
			Если ВыборкаСтрок.ПорядокНалога = 1 Тогда
				ОбластьМакетаСтрока.Параметры.Налог = "ПДФО (" + Строка(ВыборкаСтрок.Налог) + ")";
			ИначеЕсли ВыборкаСтрок.ПорядокНалога = 2 Тогда
				ОбластьМакетаСтрока.Параметры.Налог = "Військовий збір (" + Строка(ВыборкаСтрок.Налог) + ")";
			Иначе
				ОбластьМакетаСтрока.Параметры.Налог = ВыборкаСтрок.Налог;	
			КонецЕсли;	
			
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ТабличныйДокумент.ПроверитьВывод(ВыводимыеОбласти);

			Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ТабличныйДокумент.ПроверитьВывод(ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаСтрок.Сумма;
			Итого = Итого + ВыборкаСтрок.Сумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаШапок);
		ОбластьМакетаПодвал.Параметры.Итого = Итого;
		ОбластьМакетаПодвал.Параметры.Руководитель = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(ОбластьМакетаПодвал.Параметры.Руководитель);
		ОбластьМакетаПодвал.Параметры.ГлавныйБухгалтер = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(ОбластьМакетаПодвал.Параметры.ГлавныйБухгалтер);
		ОбластьМакетаПодвал.Параметры.Бухгалтер = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(ОбластьМакетаПодвал.Параметры.Бухгалтер);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует запрос по документу
//
// Параметры: 
//  Ведомости - массив ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечатиШапки(Ведомости)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ведомости", Ведомости);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьВБанк.Ссылка КАК Ссылка,
	|	ВедомостьВБанк.Номер КАК Номер,
	|	ВедомостьВБанк.Дата КАК Дата,
	|	ВедомостьВБанк.ПериодРегистрации КАК ПериодРегистрации,
	|	ВедомостьВБанк.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ВедомостьВБанк.Организация.НаименованиеПолное КАК СТРОКА(300)) КАК НазваниеОрганизации,
	|	ВедомостьВБанк.Организация.КодПоЕДРПОУ КАК КодПоЕДРПОУ,
	|	ВедомостьВБанк.Подразделение.Наименование КАК Подразделение,
	|	ВедомостьВБанк.СуммаПоДокументу КАК СуммаПоДокументу,
	|	ВедомостьВБанк.Руководитель,
	|	ВедомостьВБанк.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
	|	ВедомостьВБанк.ГлавныйБухгалтер,
	|	ВедомостьВБанк.Бухгалтер
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК ВедомостьВБанк
	|ГДЕ
	|	ВедомостьВБанк.Ссылка В(&Ведомости)";

	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	ИменаПолейОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	ИменаПолейОтветственныхЛиц.Добавить("Бухгалтер");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.Номер,
	|	ДанныеДокументов.Дата,
	|	ДанныеДокументов.ПериодРегистрации,
	|	ДанныеДокументов.Организация,
	|	ДанныеДокументов.НазваниеОрганизации,
	|	ДанныеДокументов.КодПоЕДРПОУ,
	|	ДанныеДокументов.Подразделение,
	|	ДанныеДокументов.СуммаПоДокументу,
	|	ЕСТЬNULL(ВТФИОГлавБухПоследние.Фамилия, """") + "" "" + ЕСТЬNULL(ВТФИОГлавБухПоследние.Имя, """") + "" "" + ЕСТЬNULL(ВТФИОГлавБухПоследние.Отчество, """") КАК ГлавныйБухгалтер,
	|	ЕСТЬNULL(ВТФИОРуководителейПоследние.Фамилия, """") + "" "" + ЕСТЬNULL(ВТФИОРуководителейПоследние.Имя, """") + "" "" + ЕСТЬNULL(ВТФИОРуководителейПоследние.Отчество, """") КАК Руководитель,
	|	ДанныеДокументов.РуководительДолжность,
	|	ЕСТЬNULL(ВТФИОБухгалтерПоследние.Фамилия, """") + "" "" + ЕСТЬNULL(ВТФИОБухгалтерПоследние.Имя, """") + "" "" + ЕСТЬNULL(ВТФИОБухгалтерПоследние.Отчество, """") КАК Бухгалтер
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОРуководителейПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОРуководителейПоследние.Ссылка
	|			И ДанныеДокументов.Руководитель = ВТФИОРуководителейПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОГлавБухПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОГлавБухПоследние.Ссылка
	|			И ДанныеДокументов.ГлавныйБухгалтер = ВТФИОГлавБухПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОБухгалтерПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОБухгалтерПоследние.Ссылка
	|			И ДанныеДокументов.Бухгалтер = ВТФИОБухгалтерПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокументов.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеДокументов.Дата, ГОД),
	|	ДанныеДокументов.Номер";
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

// Формирует запрос по табличной части документа
//
// Параметры: 
//  Ведомости - массив ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк
//
// Возвращаемое значение:
//  Выборка из результата запроса
//
Функция ВыборкаДляПечатиТаблицы(Ведомости)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ведомости", Ведомости);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьВБанкЗарплата.Ссылка КАК Ссылка,
	|	ВедомостьВБанкЗарплата.Ссылка.Дата КАК Период,
	|	ВедомостьВБанкЗарплата.НомерСтроки КАК НомерСтроки,
	|	ВедомостьВБанкЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьВБанкЗарплата.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ВедомостьВБанкЗарплата.КВыплате КАК КВыплате
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьВБанкЗарплата
	|ГДЕ
	|	ВедомостьВБанкЗарплата.Ссылка В(&Ведомости);
	|ВЫБРАТЬ
	|	ДанныеДокументов.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Период КАК Период,
	|	ДанныеДокументов.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокументов.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокументов.НомерЛицевогоСчета КАК НомерЛицевогоСчета
	|ПОМЕСТИТЬ ВТДанные
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов";
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = 
		КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
    		Запрос.МенеджерВременныхТаблиц,
    		"ВТДанные");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "Фамилия, Имя, Отчество");

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ведомость,
	|	ДанныеДокументов.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокументов.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	КадровыеДанныеФизическихЛиц.Фамилия,
	|	КадровыеДанныеФизическихЛиц.Имя,
	|	КадровыеДанныеФизическихЛиц.Отчество,
	|	ДанныеДокументов.КВыплате КАК Сумма,
	|	ДанныеДокументов.ФизическоеЛицо.КодПоДРФО КАК КодПоДРФО
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО ДанныеДокументов.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|ГДЕ
	|	ДанныеДокументов.КВыплате > 0
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.НомерСтроки,
	|	КадровыеДанныеФизическихЛиц.Фамилия,
	|	ДанныеДокументов.НомерЛицевогоСчета,
	|	КадровыеДанныеФизическихЛиц.Имя,
	|	ДанныеДокументов.КВыплате,
	|	ДанныеДокументов.ФизическоеЛицо.КодПоДРФО,
	|	ДанныеДокументов.Ссылка,
	|	КадровыеДанныеФизическихЛиц.Отчество
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ведомость,
	|	НомерСтроки";

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

Функция ВыборкаДляПечатиТаблицыНалоги(Ведомости)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ведомости", Ведомости);
	Запрос.УстановитьПараметр("ВоенныйСбор", УчетНДФЛ.ЗначенияВоенныйСбор().ВидСтавки);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьВБанкНДФЛ.Ссылка КАК Ссылка,
	|   ВЫБОР 
	|   	КОГДА ВидыДоходов.ВидСтавкиРезидента = &ВоенныйСбор
	|   		ТОГДА 2 
	|   	ИНАЧЕ 1
	|   КОНЕЦ КАК ПорядокНалога,
	|	ВедомостьВБанкНДФЛ.ДоходНДФЛ КАК Налог,
	|	ВедомостьВБанкНДФЛ.Налог КАК Сумма
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.НДФЛ КАК ВедомостьВБанкНДФЛ
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|   Справочник.ВидыДоходовНДФЛ КАК ВидыДоходов
	|   ПО ВедомостьВБанкНДФЛ.ДоходНДФЛ = ВидыДоходов.Ссылка
	|ГДЕ
	|	ВедомостьВБанкНДФЛ.Ссылка В(&Ведомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВедомостьВБанкВзносы.Ссылка КАК Ссылка,
	|   3 КАК ПорядокНалога,
	|	ВедомостьВБанкВзносы.Налог КАК Налог,
	|	ВедомостьВБанкВзносы.Сумма КАК Сумма
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Взносы КАК ВедомостьВБанкВзносы
	|ГДЕ
	|	ВедомостьВБанкВзносы.Ссылка В(&Ведомости)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВедомостьВБанкВзносыФОТ.Ссылка КАК Ссылка,
	|   4 КАК ПорядокНалога,
	|	ВедомостьВБанкВзносыФОТ.Налог КАК Налог,
	|	ВедомостьВБанкВзносыФОТ.Сумма КАК Сумма
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.ВзносыФОТ КАК ВедомостьВБанкВзносыФОТ
	|ГДЕ
	|	ВедомостьВБанкВзносыФОТ.Ссылка В(&Ведомости)
	|";
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ведомость,
	|	ДанныеДокументов.ПорядокНалога КАК ПорядокНалога,
	|	ДанныеДокументов.Налог КАК Налог,
	|	СУММА(ДанныеДокументов.Сумма)
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.ПорядокНалога,
	|	ДанныеДокументов.Налог
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокНалога";

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру, используемую для заполнения документа
Функция ДанныеЗаполненияНезачисленнымиСтроками() Экспорт
	ДанныеЗаполненияНезачисленнымиСтроками = Новый Структура;
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("ЭтоДанныеЗаполненияНезачисленнымиСтроками");
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("Ведомость", Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПустаяСсылка());
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("Физлица", Новый Массив);
	Возврат ДанныеЗаполненияНезачисленнымиСтроками
КонецФункции	

Функция ЭтоДанныеЗаполненияНезачисленнымиСтроками(ДанныеЗаполнения) Экспорт
	Возврат ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЭтоДанныеЗаполненияНезачисленнымиСтроками")
КонецФункции	

// Создает новый документ на основании существующего,
// перенося в новый документ только указанных физических лиц
// 
// Параметры:
//	Документ - исходный документ (объект или ссылка)
//  Физлица - массив физических лиц
//
// Возвращаемое значение:
//	ДокументОбъект 
//
Функция СкопироватьЧастично(Документ, Физлица) Экспорт
	
	Копия = Документ.Ссылка.Скопировать();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудники", Копия.Зарплата.Выгрузить(, "Сотрудник"));
	Запрос.УстановитьПараметр("Физлица", Физлица);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&Сотрудники КАК Сотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	ФизическиеЛица.Ссылка КАК Физлицо
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО (ФизическиеЛица.Ссылка = Сотрудники.Сотрудник)";
	ВыборкаРаботников = Запрос.Выполнить().Выбрать();
	
	ПараметрыОтбора = Новый Структура("Сотрудник");
	Пока ВыборкаРаботников.Следующий() Цикл
		Если Физлица.Найти(ВыборкаРаботников.Физлицо) = Неопределено Тогда
			ПараметрыОтбора.Сотрудник = ВыборкаРаботников.Сотрудник;
			УдаляемыеСтроки = Копия.Зарплата.НайтиСтроки(ПараметрыОтбора);
			Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
				Копия.Зарплата.Удалить(УдаляемаяСтрока);
			КонецЦикла	
		КонецЕсли	
	КонецЦикла;	
	
	Возврат Копия
	
КонецФункции

Функция РеквизитыОтветственныхЛиц() Экспорт   
	Возврат ВзаиморасчетыССотрудниками.ВедомостьРеквизитыОтветственныхЛиц();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьЗарплатныйПроект() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьНаВыплатуЗарплатыВБанк.Ссылка
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК ВедомостьНаВыплатуЗарплатыВБанк
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВБанк.ЗарплатныйПроект = ЗНАЧЕНИЕ(Справочник.ЗарплатныеПроекты.ПустаяСсылка)
	|	И ВедомостьНаВыплатуЗарплатыВБанк.УдалитьБанк <> ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НАЧАЛОПЕРИОДА(ВедомостьНаВыплатуЗарплатыВБанк.Дата, ГОД),
	|	ВедомостьНаВыплатуЗарплатыВБанк.Номер";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Ведомость = Выборка.Ссылка.ПолучитьОбъект();
		
		Ведомость.ОбменДанными.Загрузка = Истина;
		
		ЗарплатныйПроект = 
			ЗарплатныеПроекты.ЗарплатныйПроектПоОрганизацииИБанку(
				Ведомость.Организация, 
				Ведомость.УдалитьБанк);
				
		Если НЕ ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
			ЗарплатныйПроект =
				ЗарплатныеПроекты.НовыйЗарплатныйПроектПоОрганизацииИБанку(
					Ведомость.Организация, 
					Ведомость.УдалитьБанк);
		КонецЕсли;	
		
		Ведомость.ЗарплатныйПроект = ЗарплатныйПроект;
		
		Ведомость.Записать();
	
	КонецЦикла
	
КонецПроцедуры	

Процедура ЗаполнитьНомерЛицевогоСчета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьНаВыплатуЗарплатыВБанкЗарплата
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.НомерЛицевогоСчета = """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	НАЧАЛОПЕРИОДА(ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Дата, ГОД),
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Номер";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Ведомость = Выборка.Ссылка.ПолучитьОбъект();
		
		Ведомость.ОбменДанными.Загрузка = Истина;
		
		ЛицевыеСчетаСотрудников = ЗарплатныеПроекты.ЛицевыеСчетаСотрудников(
				Ведомость.Зарплата.ВыгрузитьКолонку("Сотрудник"),
				Истина,
				Ведомость.Организация,
				Ведомость.ПериодРегистрации,
				Ведомость.ЗарплатныйПроект);
		
		Для Каждого СтрокаТЧ Из Ведомость.Зарплата Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.НомерЛицевогоСчета) Тогда
				СтрокаЛС = ЛицевыеСчетаСотрудников.Найти(СтрокаТЧ.Сотрудник, "Сотрудник");
				Если СтрокаЛС <> Неопределено Тогда
					СтрокаТЧ.НомерЛицевогоСчета = СтрокаЛС.НомерЛицевогоСчета;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Ведомость.Записать();
	
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли