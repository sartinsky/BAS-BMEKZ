#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ПутьКФорме") Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтотОбъект,
														Элементы.ИнформационныеСсылки,
														1,
														20,
														Ложь,
														Параметры.ПутьКФорме);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

