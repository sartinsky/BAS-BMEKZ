
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.КомпоновщикНастроекПользовательскиеНастройки.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Отчет.Сводный = 1;
	Отбор = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы;
	ПользовательскиеНастройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	Владелец = Новый ПолеКомпоновкиДанных("Владелец");
	Для каждого Стр Из Отбор Цикл
		Если Стр.ЛевоеЗначение = Владелец Тогда
			Стр.Использование = Ложь;
			Стр.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			Идентификатор = Стр.ИдентификаторПользовательскойНастройки; 
			СтрокаНастроек = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор);
			Если ТипЗнч(СтрокаНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				СтрокаНастроек.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
			КонецЕсли; 			
		КонецЕсли;		
	КонецЦикла;
	
	Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);

КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Отбор(Команда)
	Элементы.КомпоновщикНастроекПользовательскиеНастройки.Видимость = Не Элементы.КомпоновщикНастроекПользовательскиеНастройки.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура СводныйПриИзменении(Элемент)
	
	Отбор = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы; 
	 Если Отчет.Сводный = 1 Тогда	 
		 Владелец = Новый ПолеКомпоновкиДанных("Владелец");
		 Для каждого Стр Из Отбор Цикл
			 Если Стр.ЛевоеЗначение = Владелец Тогда
				 Стр.Использование = Ложь;
				 Стр.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				 Идентификатор = Стр.ИдентификаторПользовательскойНастройки; 
				 СтрокаНастроек = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор);
				 Если ТипЗнч(СтрокаНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
					 СтрокаНастроек.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
				 КонецЕсли; 			
			 КонецЕсли;		
		 КонецЦикла;
	 Иначе
		 Владелец = Новый ПолеКомпоновкиДанных("Владелец");
		 Для каждого Стр Из Отбор Цикл
			 Если Стр.ЛевоеЗначение = Владелец Тогда
				 Стр.Использование = Ложь;
				 Стр.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				 Идентификатор = Стр.ИдентификаторПользовательскойНастройки; 
				 СтрокаНастроек = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор);
				 Если ТипЗнч(СтрокаНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
					 СтрокаНастроек.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;	
				 КонецЕсли; 			
			 КонецЕсли;		
		 КонецЦикла;
		 
	 КонецЕсли; 

КонецПроцедуры

#КонецОбласти 
