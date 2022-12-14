#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыИФункцииПечати
	
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Команда печати Начисление по больничному листу
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БольничныйЛист";
	КомандаПечати.Представление = НСтр("ru='Больничный лист';uk='Лікарняний лист'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	
	// Расчет стажа
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РасчетСтажа";
	КомандаПечати.Представление = НСтр("ru='Расчет стажа';uk='Розрахунок стажу'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";	
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Больничный лист""';uk='Реєстр документів ""Лікарняний лист""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
			
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "БольничныйЛист")  Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "БольничныйЛист", НСтр("ru='Больничный лист';uk='Лікарняний лист'"), 
		ПечатьБольничногоЛиста(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИНАГРО_НачислениеПоБольничномуЛисту.ПФ_XML_БольничныйЛист", ,Истина);
		
	КонецЕсли; 	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетСтажа") Тогда  		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РасчетСтажа", НСтр("ru='Расчет стажа';uk='Розрахунок стажу'"), 
		ПечатьРасчетСтажа(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИНАГРО_НачислениеПоБольничномуЛисту.ПФ_XML_РасчетСтажа", ,Истина);
	КонецЕсли; 		
	
КонецПроцедуры

Функция СформироватьЗапросДляПечати(Ссылка)
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Ссылка КАК Ссылка,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.НомерБольничногоЛиста КАК НомерБольничногоЛиста,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.СерияБольничногоЛиста КАК СерияБольничногоЛиста,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Дата КАК Дата,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.ДатаНачала КАК ДатаНачала,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.ДатаОкончания КАК ДатаОкончания,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Организация КАК Организация,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.ПериодРасчетаСреднегоНачало КАК ПериодРасчетаСреднегоНачало,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.ПериодРасчетаСреднегоКонец КАК ПериодРасчетаСреднегоКонец,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Сотрудник КАК Сотрудник,
	               |	ИНАГРО_РаботникиОрганизацийСрезПоследних.Должность КАК Должность,
	               |	ИНАГРО_РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации КАК Подразделение,
	               |	ФизическиеЛица.Наименование КАК НаименованиеСотрудника,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Сотрудник.ИНАГРО_ТабельныйНомер КАК ТабельныйНомер,
	               |	ФизическиеЛица.КодПоДРФО КАК КодПоДРФО,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Номер КАК Номер,
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.НомерСлучаяНетрудоспособности КАК НомерСлучаяНетрудоспособности
	               |ИЗ
	               |	Документ.ИНАГРО_НачислениеПоБольничномуЛисту КАК ИНАГРО_НачислениеПоБольничномуЛисту
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&Дата, Организация = &Организация) КАК ИНАГРО_РаботникиОрганизацийСрезПоследних
	               |		ПО ИНАГРО_НачислениеПоБольничномуЛисту.Сотрудник = ИНАГРО_РаботникиОрганизацийСрезПоследних.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	               |		ПО ИНАГРО_НачислениеПоБольничномуЛисту.Сотрудник.ФизическоеЛицо = ФизическиеЛица.Ссылка
	               |ГДЕ
	               |	ИНАГРО_НачислениеПоБольничномуЛисту.Ссылка = &Ссылка";
				   
	Запрос.УстановитьПараметр("Дата", Ссылка.Дата);
	Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
	Возврат Запрос.Выполнить();

КонецФункции
	
Функция ПечатьБольничногоЛиста(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_БольничныйЛист";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_НачислениеПоБольничномуЛисту.ПФ_XML_БольничныйЛист");
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Ссылка.Организация, ССылка.Дата);
		
	    Выборка = СформироватьЗапросДляПечати(Ссылка).Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
			ОбластьШапка.Параметры.Сотрудник = Выборка.НаименованиеСотрудника;
			ОбластьШапка.Параметры.ТабельныйНомер = Выборка.ТабельныйНомер;
			ОбластьШапка.Параметры.КодПоДРФО = Выборка.КодПоДРФО;
			ОбластьШапка.Параметры.Организация = СведенияОбОрганизации.ПолноеНаименование;
			ОбластьШапка.Параметры.Подразделение = Выборка.Подразделение;
			ОбластьШапка.Параметры.Номер = Выборка.Номер;
			ОбластьШапка.Параметры.Дата = Формат(Выборка.Дата,"ДФ=dd.MM.yyyy"); 
			ОбластьШапка.Параметры.ДатаНачала = Формат(Выборка.ДатаНачала,"ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.ДатаОкончания = Формат(Выборка.ДатаОкончания,"ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.ПериодРасчетаСреднегоНачало = Формат(Выборка.ПериодРасчетаСреднегоНачало,"ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.ПериодРасчетаСреднегоКонец = Формат(Выборка.ПериодРасчетаСреднегоКонец,"ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.НомерБольничногоЛиста = Выборка.НомерСлучаяНетрудоспособности + "-" + Выборка.НомерБольничногоЛиста;
			ОбластьШапка.Параметры.СерияБольничногоЛиста = Выборка.СерияБольничногоЛиста;
		КонецЦикла; 
		ТабДокумент.Вывести(ОбластьШапка);
		
		ОбластьШапкаРасчетаСреднего = Макет.ПолучитьОбласть("ШапкаРасчетаСреднего");
		ТабДокумент.Вывести(ОбластьШапкаРасчетаСреднего);
		Если Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДнямСПраздниками ИЛИ Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДням Тогда
			ОбластьШапкаДни = Макет.ПолучитьОбласть("ШапкаРасчетаСреднегоКалендарные");
		Иначе
			ОбластьШапкаДни = Макет.ПолучитьОбласть("ШапкаРасчетаСреднегоОтработано");
		КонецЕсли;
		ТабДокумент.Присоединить(ОбластьШапкаДни);
		
		ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаСреднего");
		
		Если Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДнямСПраздниками ИЛИ Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДням Тогда
			ОбластьСтрокиДни = Макет.ПолучитьОбласть("СтрокаСреднегоКалендарные");
		Иначе
			ОбластьСтрокиДни = Макет.ПолучитьОбласть("СтрокаСреднегоОтработано");
		КонецЕсли;	
		
		табСредняя = Ссылка.РасчетСреднего.Выгрузить();
		табСредняя.Колонки.Добавить("РезультатПропорционально");
		Для каждого стрСредняя Из табСредняя Цикл
			Если стрСредняя.ВидРасчета = ПланыВидовРасчета.ИНАГРО_СреднийЗаработок.БольничныйПропорционально Тогда
				стрСредняя.РезультатПропорционально = стрСредняя.Результат;
				стрСредняя.Результат = 0;
				стрСредняя.ОтработаноДней = 0;
				стрСредняя.ОтработаноЧасов = 0;
				стрСредняя.КалендарныеДни = 0; 
			КонецЕсли;
		КонецЦикла;
		
		Если Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДнямСПраздниками ИЛИ Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДням Тогда
			табСредняя.Свернуть("БазовыйПериодНачало","Результат,РезультатПропорционально,СуммаПредела,КалендарныеДни");
		Иначе
			табСредняя.Свернуть("БазовыйПериодНачало","Результат,РезультатПропорционально,СуммаПредела,ОтработаноДней,ОтработаноЧасов");
		КонецЕсли;
		
		СуммаДляРасчета=0;
		Для Каждого СтрокаТЧ Из табСредняя Цикл
			ОбластьСтроки.Параметры.Результат = СтрокаТЧ.Результат;
			ОбластьСтроки.Параметры.РезультатПропорционально = СтрокаТЧ.РезультатПропорционально;
			ОбластьСтроки.Параметры.СуммаПредела = СтрокаТЧ.СуммаПредела;
			Если Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДнямСПраздниками ИЛИ Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДням Тогда
				ОбластьСтрокиДни.Параметры.КалендарныеДни = СтрокаТЧ.КалендарныеДни;
			Иначе	
				ОбластьСтрокиДни.Параметры.ОтработаноДней = СтрокаТЧ.ОтработаноДней;
				ОбластьСтрокиДни.Параметры.ОтработаноЧасов = СтрокаТЧ.ОтработаноЧасов;
			КонецЕсли;
			ОбластьСтроки.Параметры.Месяц = СтрокаТЧ.БазовыйПериодНачало;
			ОбластьСтроки.Параметры.Год = Формат(Год(СтрокаТЧ.БазовыйПериодНачало),"ЧГ=0");
			ТабДокумент.Вывести(ОбластьСтроки);
			ТабДокумент.Присоединить(ОбластьСтрокиДни); 
		КонецЦикла;
		
		ОбластьИтогиСреднего 									= Макет.ПолучитьОбласть("ИтогиСреднего");
		ОбластьИтогиСреднего.Параметры.Результат				= табСредняя.Итог("Результат");
		ОбластьИтогиСреднего.Параметры.РезультатПропорционально	= табСредняя.Итог("РезультатПропорционально");
		Если Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДнямСПраздниками ИЛИ Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоКалендарнымДням Тогда
			ОбластьИтогиСреднегоДни = Макет.ПолучитьОбласть("ИтогиСреднегоКалендарные");
			ОбластьИтогиСреднегоДни.Параметры.КалендарныеДни			= табСредняя.Итог("КалендарныеДни");
		Иначе	
			ОбластьИтогиСреднегоДни = Макет.ПолучитьОбласть("ИтогиСреднегоОтработано");
			ОбластьИтогиСреднегоДни.Параметры.ОтработаноДней			= табСредняя.Итог("ОтработаноДней");
			ОбластьИтогиСреднегоДни.Параметры.ОтработаноЧасов			= табСредняя.Итог("ОтработаноЧасов");
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьИтогиСреднего);
		ТабДокумент.Присоединить(ОбластьИтогиСреднегоДни); 
		
		ОбластьШапка2 = Макет.ПолучитьОбласть("Шапка2");
		
		Начисления = Ссылка.Начисления;
		
		Если Начисления.Количество() > 0
			И (Начисления[0].ВидРасчета = ПланыВидовРасчета.ИНАГРО_Начисления.ОплатаПоСреднемуБЛ
			ИЛИ Начисления[0].ВидРасчета = ПланыВидовРасчета.ИНАГРО_Начисления.ОплатаПоСреднемуБЛОрганизации
			ИЛИ Начисления[0].ВидРасчета = ПланыВидовРасчета.ИНАГРО_Начисления.ОплатаПоСреднемуБЛПоБеременностиИРодам
			ИЛИ Начисления[0].ВидРасчета = ПланыВидовРасчета.ИНАГРО_Начисления.ОплатаПоСреднемуБЛТравмаНаПроизводстве) Тогда
			ОбластьШапка2.Параметры.СреднедневнаяОграниченнаяПределомТекст = ?(Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоРабочимЧасам,НСтр("ru='Среднечасовая ограниченная пределом:';uk='Середньогодинна обмежена межею:'",КодЯзыкаПечать),НСтр("ru='Среднедневная ограниченная пределом:';uk='Середньоденна обмежена межею:'",КодЯзыкаПечать));
			ОбластьШапка2.Параметры.ПределСреднее = ?(Ссылка.СуммаПределаСредней > Ссылка.СуммаСредней,Ссылка.СуммаСредней,Ссылка.СуммаПределаСредней);
		КонецЕсли;
		ОбластьШапка2.Параметры.Процент = Ссылка.ПроцентОплаты;
		Если Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоРабочимДням Тогда
			ОбластьШапка2.Параметры.ДнейЧасов = НСтр("ru='Раб.дней';uk='Роб.днів'",КодЯзыкаПечать);
		ИначеЕсли Ссылка.ВидУчетаВремениДляСредней = Перечисления.ИНАГРО_ВидыУчетаВремениДляСредней.ПоРабочимЧасам Тогда
			ОбластьШапка2.Параметры.ДнейЧасов = НСтр("ru='Часов';uk='Годин'",КодЯзыкаПечать);
		Иначе 
			ОбластьШапка2.Параметры.ДнейЧасов = НСтр("ru='Кален.дней';uk='Кален.днів'",КодЯзыкаПечать);
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьШапка2);
		
		ОбластьСтроки2 = Макет.ПолучитьОбласть("СтрокаНачисления");
		ИтогОплаченоДнейЧасов = 0;	
		Для Каждого СтрокаТЧ Из Начисления Цикл
			ОбластьСтроки2.Параметры.Заполнить(СтрокаТЧ);
			Если НЕ СтрокаТЧ.Сторно Тогда 
				ОбластьСтроки2.Параметры.НормаДнейЧасов = СтрокаТЧ.ОплаченоДнейЧасов;
				ИтогОплаченоДнейЧасов = ИтогОплаченоДнейЧасов + СтрокаТЧ.ОплаченоДнейЧасов;  
			Иначе
				ОбластьСтроки2.Параметры.НормаДнейЧасов = 0;
			КонецЕсли;	
			ТабДокумент.Вывести(ОбластьСтроки2);
		КонецЦикла;
		
		ОбластьИтогиНачислений = Макет.ПолучитьОбласть("ИтогиНачислений");
		ОбластьИтогиНачислений.Параметры.НормаДнейЧасов = ИтогОплаченоДнейЧасов;
		ОбластьИтогиНачислений.Параметры.Результат = Начисления.Итог("Результат");
		ТабДокумент.Вывести(ОбластьИтогиНачислений);
		
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ОбластьПодвал.Параметры.Ответственный = Ссылка.Ответственный.ФизическоеЛицо;
		ТабДокумент.Вывести(ОбластьПодвал);		
			 						
	КонецЦикла;	
	
	Возврат ТабДокумент;
		
КонецФункции

Функция ПечатьРасчетСтажа(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	УстановитьПривилегированныйРежим(Истина);
		
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_НачислениеПоБольничномуЛисту.ПФ_XML_РасчетСтажа");
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Ссылка.Организация, Ссылка.Дата);
		
	    Выборка = СформироватьЗапросДляПечати(Ссылка).Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
			ОбластьШапка.Параметры.Сотрудник = Выборка.НаименованиеСотрудника;
			ОбластьШапка.Параметры.ТабельныйНомер = Выборка.ТабельныйНомер;
			ОбластьШапка.Параметры.КодПоДРФО = Выборка.КодПоДРФО;
			ОбластьШапка.Параметры.Организация = СведенияОбОрганизации.ПолноеНаименование;
			ОбластьШапка.Параметры.Подразделение = Выборка.Подразделение;
			ОбластьШапка.Параметры.Дата = Формат(Выборка.Дата,"ДФ=dd.MM.yyyy"); 
			ОбластьШапка.Параметры.ДатаНачала = Формат(Выборка.ДатаНачала,"ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.ДатаОкончания = Формат(Выборка.ДатаОкончания,"ДФ=dd.MM.yyyy");
			//ОбластьШапка.Параметры.ПериодРасчетаСреднегоНачало = Формат(Выборка.ПериодРасчетаСреднегоНачало,"ДФ=dd.MM.yyyy");
			//ОбластьШапка.Параметры.ПериодРасчетаСреднегоКонец = Формат(Выборка.ПериодРасчетаСреднегоКонец,"ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.НомерБольничногоЛиста = Выборка.НомерСлучаяНетрудоспособности + "-" + Выборка.НомерБольничногоЛиста;
			ОбластьШапка.Параметры.СерияБольничногоЛиста = Выборка.СерияБольничногоЛиста;
		КонецЦикла; 
		ТабДокумент.Вывести(ОбластьШапка);
	
	ОбластьСтажПоДаннымПФУШапка = Макет.ПолучитьОбласть("СтажПоДаннымПФУШапка");
	ОбластьСтажПоДаннымПФУ = Макет.ПолучитьОбласть("СтажПоДаннымПФУ");
	ОбластьНачальныйСтаж = Макет.ПолучитьОбласть("НачальныйСтаж"); 
	ОбластьСтажДоНачалаБольничного = Макет.ПолучитьОбласть("СтажДоНачалаБольничного");
	ОбластьОбщийСтаж = Макет.ПолучитьОбласть("ОбщийСтаж");
	
	СтруктураСтажа = ИНАГРО_ПроведениеРасчетов.РасчетСтраховогоСтажа(Ссылка.ДатаНачала, Ссылка.Организация, Ссылка.Сотрудник);
	ТаблицаСтажаПоСправкеПодробная = СтруктураСтажа.ТаблицаСтажаПоСправкеПодробная; 
	
	Если НЕ (СтруктураСтажа.ЛетНачальногоСтажа = 0 И СтруктураСтажа.МесяцевНачальногоСтажа = 0 И СтруктураСтажа.ДнейНачальногоСтажа = 0) Тогда
		ОбластьНачальныйСтаж.Параметры.Заполнить(СтруктураСтажа);
		ТабДокумент.Вывести(ОбластьНачальныйСтаж);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаСтажаПоСправкеПодробная",ТаблицаСтажаПоСправкеПодробная);
	Запрос.УстановитьПараметр("ДатаНачалаСобытия",Ссылка.ДатаНачала);
	Запрос.УстановитьПараметр("Год",Год(Ссылка.ДатаНачала));
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаСтажа.Год КАК Год,
	|	ТаблицаСтажа.Месяц КАК Месяц,
	|	ТаблицаСтажа.МесяцыСтажа КАК МесяцыСтажа,
	|	ТаблицаСтажа.ДниСтажа КАК ДниСтажа
	|ПОМЕСТИТЬ ВТТаблицаСтажа
	|ИЗ
	|	&ТаблицаСтажаПоСправкеПодробная КАК ТаблицаСтажа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТаблицаСтажа.Год КАК Год,
	|	ВТТаблицаСтажа.Месяц КАК Месяц,
	|	ВТТаблицаСтажа.МесяцыСтажа,
	|	ВТТаблицаСтажа.ДниСтажа
	|ИЗ
	|	ВТТаблицаСтажа КАК ВТТаблицаСтажа
	|
	|УПОРЯДОЧИТЬ ПО
	|	Год,
	|	Месяц";
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		ОбластьСтажПоДаннымПФУШапка.Параметры.Заполнить(СтруктураСтажа);
		ОбластьСтажПоДаннымПФУШапка.Параметры.ПериодС = Формат(СтруктураСтажа.МинимальныйПериодСправки,"ДФ=dd.MM.yyyy"); 
		ОбластьСтажПоДаннымПФУШапка.Параметры.ПериодПо = Формат(СтруктураСтажа.МаксимальныйПериодСправки,"ДФ=dd.MM.yyyy");
		
		ТабДокумент.Вывести(ОбластьСтажПоДаннымПФУШапка);	
		Пока Выборка.СледующийПоЗначениюПоля("Год") Цикл
			МесяцыСтажа = 0;
			ДниСтажа = 0;	
			ОбластьСтажПоДаннымПФУ.Параметры.Год = "";
			Для Инд = 1 по 12 Цикл
				ОбластьСтажПоДаннымПФУ.Параметры["ДниСтажа" + Инд] = "";	
			КонецЦикла;	
			ОбластьСтажПоДаннымПФУ.Параметры.Год = Формат(Дата(Выборка.Год,1,1),"ДФ=yyyy");
			Пока Выборка.Следующий() Цикл
				Если Выборка.Месяц = Дата(1, 1, 1) и Выборка.Год < Год(Ссылка.ДатаНачала) Тогда
					МесяцыСтажа = Выборка.МесяцыСтажа;
					ДниСтажа = Выборка.ДниСтажа;	
				Иначе	
					ОбластьСтажПоДаннымПФУ.Параметры["ДниСтажа" + Месяц(Выборка.Месяц)] = Выборка.ДниСтажа;
				КонецЕсли;	
			КонецЦикла;	
			Если МесяцыСтажа = 0 И ДниСтажа = 0 Тогда
				Запрос.УстановитьПараметр("ТекущийГод",Выборка.Год);
				Запрос.Текст = "ВЫБРАТЬ
				|	ВТТаблицаСтажа.Год КАК Год,
				|	ВТТаблицаСтажа.Месяц КАК Месяц,
				|	ВТТаблицаСтажа.МесяцыСтажа,
				|	ВЫБОР КОГДА ВТТаблицаСтажа.МесяцыСтажа = 0 ТОГДА ВТТаблицаСтажа.ДниСтажа ИНАЧЕ 0 КОНЕЦ КАК ДниСтажа
				|ПОМЕСТИТЬ ВТТаблицаСтажаДоДатыНачала
				|ИЗ
				|	ВТТаблицаСтажа КАК ВТТаблицаСтажа
				|ГДЕ
				|	ВТТаблицаСтажа.Год = &ТекущийГод
				|	И ВТТаблицаСтажа.Месяц < НАЧАЛОПЕРИОДА(&ДатаНачалаСобытия, МЕСЯЦ)
				|	И ВТТаблицаСтажа.Месяц <> ДАТАВРЕМЯ(1,1,1)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	СУММА(ВТТаблицаСтажа.МесяцыСтажа) КАК МесяцыСтажа,
				|	СУММА(ВТТаблицаСтажа.ДниСтажа) КАК ДниСтажа
				|ИЗ
				|	ВТТаблицаСтажаДоДатыНачала КАК ВТТаблицаСтажа
				|; 
				|УНИЧТОЖИТЬ ВТТаблицаСтажаДоДатыНачала";
				ВыборкаИтог = Запрос.Выполнить().Выбрать();
				Если ВыборкаИтог.Следующий() Тогда
					МесяцыСтажа = ВыборкаИтог.МесяцыСтажа + Цел(ВыборкаИтог.ДниСтажа/30);
					ДниСтажа = ВыборкаИтог.ДниСтажа - Цел(ВыборкаИтог.ДниСтажа/30)*30;	         
				КонецЕсли;	
			КонецЕсли;	
			ОбластьСтажПоДаннымПФУ.Параметры.МесяцыСтажа = МесяцыСтажа;
			ОбластьСтажПоДаннымПФУ.Параметры.ДниСтажа = ДниСтажа;
			ТабДокумент.Вывести(ОбластьСтажПоДаннымПФУ);
		КонецЦикла;	
	КонецЕсли;
	
	Если НЕ (СтруктураСтажа.ЛетСтажаДоНачалаСобытия = 0 И СтруктураСтажа.МесяцевСтажаДоНачалаСобытия = 0 И СтруктураСтажа.ДнейСтажаДоНачалаСобытия = 0) Тогда
		ОбластьСтажДоНачалаБольничного.Параметры.Заполнить(СтруктураСтажа);
		ОбластьСтажДоНачалаБольничного.Параметры.ДатаОтсчетаДоНачалаСобытия = Формат(СтруктураСтажа.ДатаОтсчетаДоНачалаСобытия,"ДФ=dd.MM.yyyy"); 
		ТабДокумент.Вывести(ОбластьСтажДоНачалаБольничного);
	КонецЕсли;
	
	ОбластьОбщийСтаж.Параметры.Заполнить(СтруктураСтажа);
	Если СтруктураСтажа.ЛетСтажаЗа12Месяцев > 0 Тогда 
		ОбластьОбщийСтаж.Параметры.МесяцевСтажаЗа12Месяцев = 12;
		ОбластьОбщийСтаж.Параметры.ДнейСтажаЗа12Месяцев = 0;
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьОбщийСтаж);	
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодвал.Параметры.Ответственный = Ссылка.Ответственный.ФизическоеЛицо.Наименование;
	ТабДокумент.Вывести(ОбластьПодвал);	
	КонецЦикла;	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
