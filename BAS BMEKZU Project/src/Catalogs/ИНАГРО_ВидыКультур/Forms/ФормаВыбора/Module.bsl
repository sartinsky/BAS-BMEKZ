#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзМакета(Команда)
	
	СтрокаПоиска = "";
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
		СтрокаПоиска = ТекДанные.Код;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("СтрокаПоиска", СтрокаПоиска);
	
	ОткрытьФорму("Справочник.ИНАГРО_ВидыКультур.Форма.ФормаВыбораИзКлассификатора", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Текст = НСтр("ru='Есть возможность подобрать вид культуры из классификатора.
|Подобрать?';uk='Є можливість підібрати вид культури з класифікатора.
|Підібрати?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код",          Элемент.ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", Элемент.ТекущиеДанные.Наименование);
		ЗначенияЗаполнения.Вставить("ГОСТ",         Элемент.ТекущиеДанные.ГОСТ);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьВидКультурыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура ВопросПодобратьВидКультурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзМакета(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.ИНАГРО_ВидыКультур.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти