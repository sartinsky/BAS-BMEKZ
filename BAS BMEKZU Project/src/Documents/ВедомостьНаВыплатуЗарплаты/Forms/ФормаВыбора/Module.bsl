
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.Отбор);
	КонецЕсли;
	
КонецПроцедуры

