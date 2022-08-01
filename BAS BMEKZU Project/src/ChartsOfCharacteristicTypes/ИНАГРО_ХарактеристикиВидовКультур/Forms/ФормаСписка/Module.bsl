#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Текст = НСтр("ru='Есть возможность подобрать характеристики вида культур из классификатора.
|Подобрать?';uk='Є можливість підібрати характеристики виду культур з класифікатора.
|Підібрати?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Наименование",                                 Элемент.ТекущиеДанные.Наименование);
		ЗначенияЗаполнения.Вставить("ПолноеНаименование",                           Элемент.ТекущиеДанные.ПолноеНаименование);
		ЗначенияЗаполнения.Вставить("ТипХарактеристики",                            Элемент.ТекущиеДанные.ТипХарактеристики);
		ЗначенияЗаполнения.Вставить("ПоказыватьВСК",                                Элемент.ТекущиеДанные.ПоказыватьВСК);
		ЗначенияЗаполнения.Вставить("ПоказыватьВЖурналеЛабораторныхАнализов",       Элемент.ТекущиеДанные.ПоказыватьВЖурналеЛабораторныхАнализов);
		ЗначенияЗаполнения.Вставить("Порядок",                                      Элемент.ТекущиеДанные.Порядок);
		ЗначенияЗаполнения.Вставить("DRU_ТипХарактеристики",                        Элемент.ТекущиеДанные.DRU_ТипХарактеристики);
		ЗначенияЗаполнения.Вставить("DRU_КодХарактеристикиСкладскогоСвидетельства", Элемент.ТекущиеДанные.DRU_КодХарактеристикиСкладскогоСвидетельства);
		ЗначенияЗаполнения.Вставить("DRU_КодХарактеристикиСкладскойКвитанции",      Элемент.ТекущиеДанные.DRU_КодХарактеристикиСкладскойКвитанции);		
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьХарактеристикуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПодобратьХарактеристикуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзМакета(Неопределено);
	Иначе
		ОткрытьФорму("ПланВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
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
	
	ОткрытьФорму("ПланВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Форма.ФормаВыбораИзКлассификатора", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти