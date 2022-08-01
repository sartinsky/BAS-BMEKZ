
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Настройки = КомпоновщикНастроек.ПолучитьНастройки(); 
		
	ПериодОтчета = Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета");
	Если НЕ ПериодОтчета.Использование Тогда
		Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение.ДатаНачала = '00010101';
		Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение.ДатаОкончания = '39991231235959';
		Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Использование = Истина;
	ИначеЕсли Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение.ДатаОкончания = '00010101' Тогда
		Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение.ДатаОкончания = '39991231235959';
	КонецЕсли; 	
		
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, ,ДанныеРасшифровки, Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
