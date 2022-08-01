////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	Если Не Параметры.ОткрытьОбновлениеПрограммы Тогда
		Элементы.КнопкаДополнительная.Видимость = Ложь;
		Элементы.КнопкаДополнительная.Доступность = Ложь;
		Элементы.КнопкаОсновная.Заголовок = "Закрыть";
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НажатиеНаКнопкуДополнительная(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НажитиеНаКнопкуОсновная(Команда)
	
	Закрыть();
	
	Если Параметры.ОткрытьОбновлениеПрограммы Тогда
		ПолучениеОбновленийПрограммыКлиент.ОбновитьПрограмму();
	КонецЕсли;
	
КонецПроцедуры

