
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.Получатель) Тогда
		
		Элементы.Получатель.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
