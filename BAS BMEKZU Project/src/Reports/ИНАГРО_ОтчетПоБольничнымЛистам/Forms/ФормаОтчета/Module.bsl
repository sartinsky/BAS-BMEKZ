#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Для этого отчета, период только месяц
	ЭтаФорма.ВидПериода = Перечисления.ДоступныеПериодыОтчета.Месяц;
	
	Отчет.НачалоПериода = НачалоМесяца(ТекущаяДата());
	Отчет.КонецПериода = КонецМесяца(ТекущаяДата());
	
	Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	ПериодПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
		
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
		
	Настройки.ДополнительныеСвойства.Вставить("НачалоПериода", Отчет.НачалоПериода);
	Настройки.ДополнительныеСвойства.Вставить("КонецПериода", Отчет.КонецПериода);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Настройки.ДополнительныеСвойства.Свойство("НачалоПериода") Тогда
	
		Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНачала").Значение = Настройки.ДополнительныеСвойства.НачалоПериода;
		Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНачала").Использование = Истина;	
		
		Отчет.НачалоПериода = Настройки.ДополнительныеСвойства.НачалоПериода;
		Отчет.КонецПериода = КонецМесяца(Отчет.НачалоПериода);

		Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
		
	КонецЕсли; 
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ВыборПериодаКлиент.ПериодПриИзменении(Элемент, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	ПериодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()

	Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНачала").Значение = Отчет.НачалоПериода;
	Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНачала").Использование = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода, ВидПериода", Отчет.НачалоПериода, Отчет.КонецПериода, ВидПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, Элементы.Период, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры   

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
		
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
		
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru='Отчет по больничным листам за ';uk='Звіт по лікарняним листам за '") + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

#КонецОбласти