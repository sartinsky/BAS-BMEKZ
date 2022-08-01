
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущаяПапка") Тогда
		Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяПапка;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		Для каждого ЭлементФормы Из Элементы.КоманднаяПанель.ПодчиненныеЭлементы Цикл
			
			Элементы.Переместить(ЭлементФормы, Элементы.ФормаКоманднаяПанель);
			
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КоманднаяПанель", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
