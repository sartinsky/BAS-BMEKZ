#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СотрудникСсылка") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "СотрудникСсылка");
				
		ДокументыПоНачислениям.Параметры.УстановитьЗначениеПараметра("СотрудникСсылка", Параметры.СотрудникСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти