#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Типовая форма П5
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СменаШтатногоРасписания";
	КомандаПечати.Представление = НСтр("ru='Изменение штатного расписания организации';uk='Зміна штатного розкладу організації'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Реестр документов ""Изменение штатного расписания организаций""';uk='Реєстр документів ""Зміна штатного розкладу організацій""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;

КонецПроцедуры

Функция ПечатьСменаШтатногоРасписания(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СменаШтатногоРасписания_П1";
	
	// Параметры документа
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ПолеСлева = 0;
	ТабДок.ПолеСправа = 0;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		// запоминаем области макета
		Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ИНАГРО_УтвержденноеШтатноеРасписаниеОрганизаций.ПФ_MXL_ШтатноеРасписание");
		
		// печать производится на языке, указанном в настройках пользователя
		КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
		Макет.КодЯзыкаМакета = КодЯзыкаПечать;	
		
		МассивВидовРуководителей = Новый Массив();
		МассивВидовРуководителей.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		МассивВидовРуководителей.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы);
		
		Запрос = Новый Запрос;		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность.Представление КАК ДолжностьРуководителя,
			|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо.Наименование) КАК ФИОРуководителя,
			|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо КАК ОтветственноеЛицо
			|ИЗ
			|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
			|			&ДатаАктуальности,
			|			ОтветственноеЛицо В (&ВидЛица)
			|				И СтруктурнаяЕдиница = &Организация) КАК ОтветственныеЛицаОрганизацийСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&ДатаАктуальности, ) КАК ФИОФизЛицСрезПоследних
			|		ПО ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо = ФИОФизЛицСрезПоследних.ФизическоеЛицо";
		
		Запрос.УстановитьПараметр("ВидЛица", МассивВидовРуководителей);
		Запрос.УстановитьПараметр("ДатаАктуальности", Ссылка.Дата);
		Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
	
		ЗапросДляПодвала = Запрос.Выполнить();
			
		Запрос = Новый Запрос;		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.Подразделение КАК Подразделение,
			|	ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.Должность КАК Должность,
			|	ЕСТЬNULL(ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.КоличествоСтавок, 0) КАК КоличествоСтавок,
			|	ЕСТЬNULL(ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.МинимальнаяТарифнаяСтавка, 0) КАК МинимальнаяТарифнаяСтавка,
			|	ЕСТЬNULL(ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.МаксимальнаяТарифнаяСтавка, 0) КАК МаксимальнаяТарифнаяСтавка,
			|	ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки.ВидРасчета КАК ВидРасчета,
			|	ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки.Показатель1 КАК Показатель1,
			|	ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки.Показатель2 КАК Показатель2,
			|	1 КАК КоличествоСтрок
			|ИЗ
			|	Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.ШтатныеЕдиницы КАК ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.Надбавки КАК ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки
			|		ПО ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.Ссылка = ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки.Ссылка
			|			И ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.Подразделение = ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки.Подразделение
			|			И ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.Должность = ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийНадбавки.Должность
			|ГДЕ
			|	ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.Ссылка = &Ссылка
			|	И ИНАГРО_ИзменениеШтатногоРасписанияОрганизацийШтатныеЕдиницы.КоличествоСтавок > 0";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выгрузить();
		
		КолСтавокТаб = Выборка.Скопировать();
		КолСтавокТаб.Свернуть("Подразделение, Должность, КоличествоСтавок");
		КолСтавок = КолСтавокТаб.Итог("КоличествоСтавок");
	
		КопияТаб = Выборка.Скопировать();
		КопияТаб.Свернуть("ВидРасчета");
		
		// Получаем список ВидовРасчета
		//СписокНадбавок = Новый СписокЗначений;
		//Для каждого СтрокаКопииТаб Из КопияТаб Цикл
		//	Если СтрокаКопииТаб.ВидРасчета <> NULL Тогда
		//		СписокНадбавок.Добавить(СтрокаКопииТаб.ВидРасчета);
		//	КонецЕсли;	
		//КонецЦикла;
		
		// Исключим показатели "Процент"
		СписокНадбавок = Новый СписокЗначений;
		Для каждого СтрокаКопииТаб Из КопияТаб Цикл
			Если СтрокаКопииТаб.ВидРасчета <> NULL Тогда
				СведенияОВидеРасчета = ИНАГРО_ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьСведенияОВидеРасчетаСхемыМотивации(СтрокаКопииТаб.ВидРасчета);
				ЕстьПоказательПроцент = Ложь;
				Для СчПоказателей = 1 По 6 Цикл
					Если СчПоказателей <= СведенияОВидеРасчета["КоличествоПоказателей"] Тогда
						Если СведенияОВидеРасчета["Показатель" + СчПоказателей + "Наименование"] = "Процент" Тогда
							ЕстьПоказательПроцент = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла; 
				Если НЕ ЕстьПоказательПроцент Тогда
					СписокНадбавок.Добавить(СтрокаКопииТаб.ВидРасчета);
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла; 
		
		Пока СписокНадбавок.Количество() < 3  Цикл
			СписокНадбавок.Добавить("");
		КонецЦикла; 
		КолНадбавок = СписокНадбавок.Количество();
		
		// Заполнение шапки
		ШапкаДоНадбавок = Макет.ПолучитьОбласть("Шапка|ДоНадбавок");
		ШапкаДоНадбавок.Параметры.НазваниеОрганизации = Ссылка.Организация.НаименованиеПолное;   
		ШапкаДоНадбавок.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Ссылка.Номер, Истина, Истина);
		ШапкаДоНадбавок.Параметры.ДатаДокумента = Ссылка.Дата;
		ШапкаДоНадбавок.Параметры.ДатаАктуальности = Ссылка.Дата;
		ТабДок.Вывести(ШапкаДоНадбавок);
			
		ШапкаНадбавка = Макет.ПолучитьОбласть("Шапка|Надбавка");	
	   	Для СчетчикНадбавок = 0 По КолНадбавок - 1 Цикл	
			ТабДок.Присоединить(ШапкаНадбавка);		
		КонецЦикла;
				
		ШапкаПослеНадбавок = Макет.ПолучитьОбласть("Шапка|ПослеНадбавок");
		ШапкаПослеНадбавок.Параметры.ШтатВКоличестве = НСтр("ru='штат в количестве "+КолСтавок+" единиц';uk='штат в кількості "+КолСтавок+" одиниць'",КодЯзыкаПечать);
		ТабДок.Присоединить(ШапкаПослеНадбавок);
		
		НомерВерхнейСтрокиШапки = ТабДок.ВысотаТаблицы+1;
		ШапкаЛистаДоНадбавка = Макет.ПолучитьОбласть("ШапкаЛиста|ДоНадбавок");
		ТабДок.Вывести(ШапкаЛистаДоНадбавка);
		
		ШапкаЛистаНадбавка = Макет.ПолучитьОбласть("ШапкаЛиста|Надбавка");
	    Для СчетчикНадбавок = 0 По КолНадбавок - 1 Цикл
	    	ШапкаЛистаНадбавка.Параметры.ИмяНадбавки = СписокНадбавок[СчетчикНадбавок];
	    	ШапкаЛистаНадбавка.Параметры.НомерКолонки = 6 + СчетчикНадбавок;
	    	ТабДок.Присоединить(ШапкаЛистаНадбавка);	
		КонецЦикла;
		
		ОбластьШапкиНадбавок = ТабДок.Область(НомерВерхнейСтрокиШапки,ШапкаЛистаДоНадбавка.ШиринаТаблицы+1, НомерВерхнейСтрокиШапки,ШапкаЛистаДоНадбавка.ШиринаТаблицы+КолНадбавок*3);
		ОбластьШапкиНадбавок.Объединить();
		ОбластьШапкиНадбавок.Текст = "Надбавки, грн";
	
		ШапкаЛистаПослеНадбавок = Макет.ПолучитьОбласть("ШапкаЛиста|ПослеНадбавок");
		ШапкаЛистаПослеНадбавок.Параметры.НомерКолонкиФонд = 6+КолНадбавок;
		ШапкаЛистаПослеНадбавок.Параметры.НомерКолонкиПримечание = 6+КолНадбавок+1;
		ТабДок.Присоединить(ШапкаЛистаПослеНадбавок);
		
		// строки листа
		СтрокаДоНадбавок = Макет.ПолучитьОбласть("Строка|ДоНадбавок");
		СтрокаНадбавка = Макет.ПолучитьОбласть("Строка|Надбавка");		
		СтрокаПослеНадбавок = Макет.ПолучитьОбласть("Строка|ПослеНадбавок");
				
		СуммаСтавок = 0;
		СуммаМинСтавки = 0;
		СуммаМаксСтавки = 0;
						
		КолонкиСуммирования = "КоличествоСтавок,МинимальнаяТарифнаяСтавка,МаксимальнаяТарифнаяСтавка,КоличествоСтрок";
		Ном = 0;
		
		Для каждого ЭлементСписка Из СписокНадбавок Цикл		
			Если ЭлементСписка.Значение <> "" Тогда
				КолонкаНаим = "Надбавка"+Строка(Ном);
				
				Выборка.Колонки.Добавить(КолонкаНаим);
				КолонкиСуммирования = КолонкиСуммирования + "," + КолонкаНаим;
				Ном = Ном + 1; 
			КонецЕсли;
		КонецЦикла; 
				
		Для каждого Стр Из Выборка Цикл
			Если ЗначениеЗаполнено(Стр.ВидРасчета) Тогда
						
				Ном = 0;
				Для каждого ЭлСписка Из СписокНадбавок Цикл				
					Если Стр.ВидРасчета = ЭлСписка.Значение Тогда
						Стр["Надбавка"+Строка(Ном)] = Стр.Показатель1 + Стр.Показатель2;
					КонецЕсли;
					Ном = Ном +1;		
				КонецЦикла; 	
			КонецЕсли;
			
		КонецЦикла;
		
		Выборка.Свернуть("Подразделение,Должность",КолонкиСуммирования);	
		
		СуммаМинСтавкиСНадбавками = 0;
		СуммаМаксСтавкиСНадбавками = 0;
		
		// Заполнение ТабЧасти
		Для каждого Строка Из Выборка Цикл
			СтрокаДоНадбавок.Параметры.ПодразделениеОрганизацииПредставление = Строка.Подразделение;
			СтрокаДоНадбавок.Параметры.ПодразделениеОрганизацииКод = Строка.Подразделение.Код;
			СтрокаДоНадбавок.Параметры.ДолжностьПредставление = Строка.Должность;
			СтрокаДоНадбавок.Параметры.КоличествоСтавок = Строка.КоличествоСтавок / Строка.КоличествоСтрок;
			СтрокаДоНадбавок.Параметры.ОкладТарифнаяСтавка	= "" + Строка.МинимальнаяТарифнаяСтавка/Строка.КоличествоСтрок + " - " + Строка.МаксимальнаяТарифнаяСтавка/Строка.КоличествоСтрок;
			ТабДок.Вывести(СтрокаДоНадбавок);
			
			СуммаСтавок = СуммаСтавок + (Строка.КоличествоСтавок / Строка.КоличествоСтрок);
			СуммаМинСтавки = СуммаМинСтавки + (Строка.МинимальнаяТарифнаяСтавка / Строка.КоличествоСтрок);
			СуммаМаксСтавки = СуммаМаксСтавки + (Строка.МаксимальнаяТарифнаяСтавка / Строка.КоличествоСтрок);
			
			РазмерНадбавок = 0;
			Для Счетчик=0 По КолНадбавок-1 Цикл
				Если Не СписокНадбавок[Счетчик].Значение = "" Тогда				
					СтрокаНадбавка.Параметры.РазмерНадбавки = Строка["Надбавка"+Строка(Счетчик)];
					РазмерНадбавок = РазмерНадбавок + СтрокаНадбавка.Параметры.РазмерНадбавки;
				Иначе
					СтрокаНадбавка.Параметры.РазмерНадбавки = ""; 
				КонецЕсли;	
				ТабДок.Присоединить(СтрокаНадбавка);	
			КонецЦикла;
			
			МинСтавкаСНадбавкой = Строка.КоличествоСтавок * (Строка.МинимальнаяТарифнаяСтавка + РазмерНадбавок);
			МаксСтавкаСНадбавкой = Строка.КоличествоСтавок * (Строка.МаксимальнаяТарифнаяСтавка + РазмерНадбавок);
			
			СтрокаПослеНадбавок.Параметры.МесячныйФонд = "" + МинСтавкаСНадбавкой + " - " + МаксСтавкаСНадбавкой;
			ТабДок.Присоединить(СтрокаПослеНадбавок);	
			
			СуммаМинСтавкиСНадбавками = СуммаМинСтавкиСНадбавками + МинСтавкаСНадбавкой;
			СуммаМаксСтавкиСНадбавками = СуммаМаксСтавкиСНадбавками + МаксСтавкаСНадбавкой;
		КонецЦикла; 
		
		// подвал листа
		ПодвалЛистаДоНадбавок = Макет.ПолучитьОбласть("ПодвалЛиста|ДоНадбавок");
		ПодвалЛистаНадбавка = Макет.ПолучитьОбласть("ПодвалЛиста|Надбавка");
		ПодвалЛистаПослеНадбавок = Макет.ПолучитьОбласть("ПодвалЛиста|ПослеНадбавок");

		ПодвалЛистаДоНадбавок.Параметры.КоличествоСтавок = СуммаСтавок;
		ПодвалЛистаДоНадбавок.Параметры.ОкладТарифнаяСтавка = "" + СуммаМинСтавки + " - " + СуммаМаксСтавки;	
		ТабДок.Вывести(ПодвалЛистаДоНадбавок);
		
		Для СчетчикНадбавок=0 По КолНадбавок-1 Цикл                 
			ТабДок.Присоединить(ПодвалЛистаНадбавка);	
		КонецЦикла;
		
		ПодвалЛистаПослеНадбавок.Параметры.МесячныйФонд	= "" + СуммаМинСтавкиСНадбавками + " - " + СуммаМаксСтавкиСНадбавками;
		ТабДок.Присоединить(ПодвалЛистаПослеНадбавок);

		НомерВерхнейСтрокиПодвала = ТабДок.ВысотаТаблицы+1;
		
		ПодвалДоНадбавок = Макет.ПолучитьОбласть("Подвал|ДоНадбавок");
		ПодвалНадбавка = Макет.ПолучитьОбласть("Подвал|Надбавка");
		ПодвалПослеНадбавок = Макет.ПолучитьОбласть("Подвал|ПослеНадбавок");
	
		ПодвалДоНадбавок.Параметры.КоличествоСтавок = СуммаСтавок;
		ПодвалДоНадбавок.Параметры.ОкладТарифнаяСтавка = "" + СуммаМинСтавки + " - " + СуммаМаксСтавки;	
				
		ВыборкаДляПодвала = ЗапросДляПодвала.Выбрать();
		Если ВыборкаДляПодвала.НайтиСледующий(Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы, "ОтветственноеЛицо") Тогда
			ПодвалДоНадбавок.Параметры.ДолжностьРуководителя = ВыборкаДляПодвала.ДолжностьРуководителя;
		КонецЕсли;
		ТабДок.Вывести(ПодвалДоНадбавок);
		
		Для СчетчикНадбавок=0 По КолНадбавок-1 Цикл                 
			ТабДок.Присоединить(ПодвалНадбавка);	
		КонецЦикла;

		ШиринаДляПодписи = КолНадбавок*3-1;
		НомерЛевойКолонкиДляПодписи = ПодвалДоНадбавок.ШиринаТаблицы+2;
		НомерПравойКолонкиДляПодписи = НомерЛевойКолонкиДляПодписи + ШиринаДляПодписи-1;
		ЛинияДляПодписи = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1);
		
		// Объединим ячейки для 2-ух подписей руководителей
		Для СчетчикНадбавок=1 По 2 Цикл
			НомерСтрокиДляПодписи = НомерВерхнейСтрокиПодвала+СчетчикНадбавок*2;
			ОбластьВерхнейСтрокиПодписи = ТабДок.Область(НомерСтрокиДляПодписи,НомерЛевойКолонкиДляПодписи, НомерСтрокиДляПодписи,НомерПравойКолонкиДляПодписи);
			ОбластьВерхнейСтрокиПодписи.Объединить();
			ОбластьВерхнейСтрокиПодписи.ГраницаСнизу = ЛинияДляПодписи;
			ОбластьНижнейСтрокиПодписи = ТабДок.Область(НомерСтрокиДляПодписи+1,НомерЛевойКолонкиДляПодписи, НомерСтрокиДляПодписи+1,НомерПравойКолонкиДляПодписи);
			ОбластьНижнейСтрокиПодписи.Объединить();
			ОбластьНижнейСтрокиПодписи.Текст = НСтр("ru='личная подпись';uk='особистий підпис'",КодЯзыкаПечать);
		КонецЦикла;	
		
		ПодвалПослеНадбавок.Параметры.МесячныйФонд	= "" + СуммаМинСтавкиСНадбавками + " - " + СуммаМаксСтавкиСНадбавками;
		
		ВыборкаДляПодвала = ЗапросДляПодвала.Выбрать();
		Если ВыборкаДляПодвала.НайтиСледующий(Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер,"ОтветственноеЛицо") Тогда
			ПодвалПослеНадбавок.Параметры.ФИОРуководителяГБ = ВыборкаДляПодвала.ФИОРуководителя;
		КонецЕсли;

		ВыборкаДляПодвала = ЗапросДляПодвала.Выбрать();
		Если ВыборкаДляПодвала.НайтиСледующий(Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы,"ОтветственноеЛицо") Тогда
			ПодвалПослеНадбавок.Параметры.ФИОРуководителяКС = ВыборкаДляПодвала.ФИОРуководителя;
		КонецЕсли;
		
		ТабДок.Присоединить(ПодвалПослеНадбавок);
		
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
				
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СменаШтатногоРасписания")  Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СменаШтатногоРасписания", НСтр("ru='Изменение штатного расписания организации';uk='Зміна штатного розкладу організації'"), 
		ПечатьСменаШтатногоРасписания(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Отчет.ИНАГРО_УтвержденноеШтатноеРасписаниеОрганизаций.ПФ_MXL_ШтатноеРасписание", ,Истина);
		
	КонецЕсли; 	
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли