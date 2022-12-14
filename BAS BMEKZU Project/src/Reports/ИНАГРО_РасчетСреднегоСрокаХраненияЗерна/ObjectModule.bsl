
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	Настройки.ПараметрыДанных.Элементы.Найти("Сводный").Значение = Сводный;
	Настройки.ПараметрыДанных.Элементы.Найти("Сводный").Использование = Истина;
	ПустаяДата = '00010101000000';
	
	Если    Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение = ПустаяДата 
		ИЛИ Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение.Дата = ПустаяДата Тогда
		Сообщить(НСтр("ru='Не указана конечная дата формирования отчета';uk='Не вказана кінцева дата формування звіту'"));
		Возврат;
	КонецЕсли;
	
	Если Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение.Дата < Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Значение.Дата Тогда
		Сообщить(НСтр("ru='Не верно указана дата формирования отчета, начальная дата не может быть больше конечной даты';uk='Не вірно вказана дата формування звіту, початкова дата не може бути більше кінцевої дати'"));
		Возврат;	
	КонецЕсли;  
	
	Если  Сводный = 1 Тогда
		Настройки.ПараметрыДанных.Элементы.Найти("ВладелецЗаголовок").Значение  = "";
	Иначе 
		Настройки.ПараметрыДанных.Элементы.Найти("ВладелецЗаголовок").Значение  = НСтр("ru = 'Владелец:'; uk = 'Власник:'");
	КонецЕсли;

	//ПериодОтчета = Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета");
	//Если НЕ ПериодОтчета.Использование Тогда
	//	Настройки.ПараметрыДанных.Элементы.Найти("ДатаОкончания").Значение = ТекущаяДата();
	//	Настройки.ПараметрыДанных.Элементы.Найти("ДатаОкончания").Использование = Истина;
	//	
	//КонецЕсли; 
	
	Для Каждого ЭлОтбора Из Настройки.Отбор.Элементы Цикл
		Если Строка(ЭлОтбора.ЛевоеЗначение) = "Склад" Тогда
			Если ЭлОтбора.Использование = Истина Тогда
				НазваниеСклада = ЭлОтбора.ПравоеЗначение;
			Иначе
				НазваниеСклада = "";
			КонецЕсли;
		ИначеЕсли Строка(ЭлОтбора.ЛевоеЗначение) = "Урожай" Тогда
			Если ЭлОтбора.Использование = Истина Тогда
				НазваниеУрожая = ЭлОтбора.ПравоеЗначение;
			Иначе
				НазваниеУрожая = "";
			КонецЕсли;
		ИначеЕсли Строка(ЭлОтбора.ЛевоеЗначение) = "Владелец" Тогда
			Если ЭлОтбора.Использование = Истина И Сводный = 2 Тогда
				НазваниеВладельца = ЭлОтбора.ПравоеЗначение;
			Иначе
				НазваниеВладельца = "";
			КонецЕсли;
		ИначеЕсли Строка(ЭлОтбора.ЛевоеЗначение) = "ВидХранения" Тогда
			Если ЭлОтбора.Использование = Истина Тогда
				НазваниеВидаХранения = ЭлОтбора.ПравоеЗначение;
			Иначе
				НазваниеВидаХранения = "";
			КонецЕсли;	
		КонецЕсли; 	
	КонецЦикла; 	
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, ,ДанныеРасшифровки, Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
		
	Для индСтр=1 По ДокументРезультат.ВысотаТаблицы Цикл
		Для индКол=1 По ДокументРезультат.ШиринаТаблицы  Цикл
			ЗначениеЯчейки = СокрЛП(ДокументРезультат.Область(индСтр, индКол).Текст); 
			
			Если ЗначениеЯчейки = "НазваниеСклада" Тогда			
				ДокументРезультат.Область(индСтр, индКол, индСтр, индКол).Текст = НазваниеСклада;				
			ИначеЕсли ЗначениеЯчейки = "НазваниеУрожая" Тогда			
				ДокументРезультат.Область(индСтр, индКол, индСтр, индКол).Текст = НазваниеУрожая;
			ИначеЕсли ЗначениеЯчейки = "НазваниеВладельца" Тогда			
				ДокументРезультат.Область(индСтр, индКол, индСтр, индКол).Текст = НазваниеВладельца;				
			ИначеЕсли ЗначениеЯчейки = "НазваниеВидаХранения" Тогда			
				ДокументРезультат.Область(индСтр, индКол, индСтр, индКол).Текст = НазваниеВидаХранения;
			КонецЕсли;
		КонецЦикла; 		
	КонецЦикла;	
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
