#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ПолеСлева			 = 0;
	ДокументРезультат.ПолеСправа		 = 0;
	ДокументРезультат.Защита             = Ложь;
	ДокументРезультат.ТолькоПросмотр     = Истина;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();   	
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , ДанныеРасшифровки);
	
	ТаблицаРезультатаЗапроса = Новый ТаблицаЗначений;

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультатаЗапроса);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	
	Макет = ЭтотОбъект.ПолучитьМакет("ПФ_MXL_UK_ЗХС_49");	
	
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	Для Каждого ЭлементПользовательскихНастроек Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементПользовательскихНастроек) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если  ТипЗнч(ЭлементПользовательскихНастроек.ПравоеЗначение) = Тип("СправочникСсылка.Организации")
			И ЭлементПользовательскихНастроек.Использование Тогда
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
			Организация = ЭлементПользовательскихНастроек.ПравоеЗначение;
			ОбластьШапка.Параметры.ЕДРПОУ      = Организация.КодПоЕДРПОУ;
			ОбластьШапка.Параметры.Организация = Организация.НаименованиеПолное;
			ДокументРезультат.Вывести(ОбластьШапка);
		КонецЕсли;
	КонецЦикла;	
	
	ПериодНастройка = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период");
	ПериодНастройкаПользовательская = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПериодНастройка.ИдентификаторПользовательскойНастройки);	
		
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.ДатаНачала    = ПериодНастройкаПользовательская.Значение.ДатаНачала;
	ОбластьЗаголовок.Параметры.ДатаОкончания = ПериодНастройкаПользовательская.Значение.ДатаОкончания;	
		
	ДокументРезультат.Вывести(ОбластьЗаголовок);
		
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	
	ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
	ВысотаШапки   					= ДокументРезультат.ВысотаТаблицы;		
    ДокументРезультат.ФиксацияСверху = ВысотаШапки;

	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область("R21");
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультатаЗапроса Цикл 
		
		ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьСтрокаТаблицы.Параметры.Заполнить(СтрокаТаблицы);
		
		Тип    = СокрЛП(СтрокаТаблицы.Тип);
		ПодТип = СтрокаТаблицы.ПодТип;
		ТипПодТип = "";
		Если ЗначениеЗаполнено(Тип) Тогда
			ТипПодТип = Тип + ", " + ПодТип;
		Иначе
			ТипПодТип = ПодТип;
		КонецЕсли;
		ОбластьСтрокаТаблицы.Параметры.ТипПодТип = ТипПодТип;
		
		МестоРазмещения = СтрокаТаблицы.Силос;
		Если НЕ ЗначениеЗаполнено(МестоРазмещения) Тогда
			МестоРазмещения = СтрокаТаблицы.Склад;
		КонецЕсли;
		ОбластьСтрокаТаблицы.Параметры.МестоРазмещения = МестоРазмещения;
		
		ДокументРезультат.Вывести(ОбластьСтрокаТаблицы);
		
	КонецЦикла;
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ДокументРезультат.Вывести(ОбластьПодвал);

КонецПроцедуры

#КонецОбласти    

#КонецЕсли