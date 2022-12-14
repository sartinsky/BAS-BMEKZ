#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("УправлениеЗатратами",          УправлениеЗатратами);
	Параметры.Свойство("УправлениеБазойРаспределения", УправлениеБазойРаспределения);
	Параметры.Свойство("УправлениеРаспределением",     УправлениеРаспределением);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("УправлениеЗатратами",          УправлениеЗатратами);
	СтруктураВозврата.Вставить("УправлениеБазойРаспределения", УправлениеБазойРаспределения);
	СтруктураВозврата.Вставить("УправлениеРаспределением",     УправлениеРаспределением);
	
	Закрыть();

	Оповестить("РаспределениеЗатрат_Настройки", СтруктураВозврата, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();

КонецПроцедуры

#КонецОбласти