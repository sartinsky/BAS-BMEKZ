
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДействиеПомощникКопирования(Команда)
	
	СтруктураПараметров = Новый Структура;
	
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если НЕ ТекСтрока = Неопределено Тогда
		СтруктураПараметров.Вставить("КонтрагентИсточник", ТекСтрока.Контрагент);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.НоменклатураКонтрагентов.Форма.ФормаКопирования",СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()

	Элементы.ФормаДействиеПомощникКопирования.Доступность = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НоменклатураКонтрагентов);

КонецПроцедуры

#КонецОбласти
