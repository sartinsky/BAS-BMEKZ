#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Установка параметров учетной политики по умолчанию
//
// Параметры:
// ЗаписьРегистра - Строка - установка режима записи регистра.
// ДанныеЗаполнения - данные заполнения регистра.
//
Процедура УстановкаПараметровУчетнойПолитикиПоУмолчанию(ЗаписьРегистра, ДанныеЗаполнения) Экспорт

	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "Организация", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "Период", НачалоГода(ТекущаяДатаСеанса()));
	
	// Запасы
	УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, "СпособОценкиБА", 
		Перечисления.СпособыОценки.ПоСредней);
			
КонецПроцедуры

// Установка параметров учетной политики по умолчанию на период
//
// Параметры:
// ЗаписьРегистра - Строка - установка режима записи регистра
//
Процедура УстановкаПараметровУчетнойПолитикиПоУмолчаниюНаПериод(ЗаписьРегистра) Экспорт


КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗначениеРеквизита(ЗаписьРегистра, ДанныеЗаполнения, ИмяРеквизита, ЗначениеПоУмолчанию)

	Если НЕ ДанныеЗаполнения.Свойство(ИмяРеквизита, ЗаписьРегистра[ИмяРеквизита]) Тогда
		ЗаписьРегистра[ИмяРеквизита] = ЗначениеПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
