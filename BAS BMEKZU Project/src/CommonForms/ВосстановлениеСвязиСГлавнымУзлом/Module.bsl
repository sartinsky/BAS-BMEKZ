
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ГлавныйУзел = Константы.ГлавныйУзел.Получить();
	
	Если Не ЗначениеЗаполнено(ГлавныйУзел) Тогда
		ВызватьИсключение НСтр("ru='Главный узел не сохранен.';uk='Головний вузол не збережений.'");
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		ВызватьИсключение НСтр("ru='Главный узел установлен.';uk='Головний вузол установлений.'");
	КонецЕсли;
	
	Элементы.ТекстПредупреждения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.ТекстПредупреждения.Заголовок, Строка(ГлавныйУзел));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Восстановить(Команда)
	
	ВосстановитьНаСервере();
	
	Закрыть(Новый Структура("Отказ", Ложь));
	
КонецПроцедуры

&НаКлиенте
Процедура Отключить(Команда)
	
	ОтключитьНаСервере();
	
	Закрыть(Новый Структура("Отказ", Ложь));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	Закрыть(Новый Структура("Отказ", Истина));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ОтключитьНаСервере()
	
	НачатьТранзакцию();
	Попытка
		ГлавныйУзел = Константы.ГлавныйУзел.Получить();
		
		ГлавныйУзелМенеджер = Константы.ГлавныйУзел.СоздатьМенеджерЗначения();
		ГлавныйУзелМенеджер.Значение = Неопределено;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ГлавныйУзелМенеджер);
		
		ЭтоАвтономноеРабочееМесто = Константы.ЭтоАвтономноеРабочееМесто.СоздатьМенеджерЗначения();
		ЭтоАвтономноеРабочееМесто.Прочитать();
		Если ЭтоАвтономноеРабочееМесто.Значение Тогда
			ЭтоАвтономноеРабочееМесто.Значение = Ложь;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭтоАвтономноеРабочееМесто);
		КонецЕсли;
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
			МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
			МодульОбменДаннымиСервер.УдалитьНастройкиСинхронизацииСГлавнымУзломРИБ(ГлавныйУзел);
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.ВосстановитьПредопределенныеЭлементы();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВосстановитьНаСервере()
	
	ГлавныйУзел = Константы.ГлавныйУзел.Получить();
	
	ПланыОбмена.УстановитьГлавныйУзел(ГлавныйУзел);
	
КонецПроцедуры

#КонецОбласти
