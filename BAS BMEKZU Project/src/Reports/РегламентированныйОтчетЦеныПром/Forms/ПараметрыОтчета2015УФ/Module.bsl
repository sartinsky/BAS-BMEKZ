
&НаСервере
Процедура ПолучитьДопРеквизитыНоменклатурыНаСервере(СписокЗначений)

	СписокЗначений.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.Свойство КАК Реквизит
	               |ИЗ
	               |	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты
	               |ГДЕ
	               |	НЕ НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("НаборСвойств", Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокЗначений.Добавить(Выборка.Реквизит);
	КонецЦикла;
	
	Если СписокЗначений.Количество() = 0 Тогда
		СписокЗначений.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка());	
	КонецЕсли;
	
КонецПроцедуры

// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мПараметры = Новый Структура();
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	Организация = Параметры.Организация;
	
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	
	ИспользоватьКодНПП 		= Параметры.ИспользоватьКодНПП;
	Если Не (ИспользоватьКодНПП = Истина ИЛИ ИспользоватьКодНПП = Ложь) Тогда
		ИспользоватьКодНПП = Ложь	
	КонецЕсли;
	
	КодНПП 			= Параметры.КодНПП;
	
	ИДКонфигурации = РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации();
	
	Если ИДКонфигурации  =  "ЕРП" Тогда
		ОписаниеТипа = Новый ОписаниеТипов("СправочникСсылка.ВидыЦен");
		Элементы.ТипЦен.ОграничениеТипа = ОписаниеТипа;
		Элементы.ТипЦен.ВыбиратьТип = Ложь;
	Иначе
		ОписаниеТипа = Новый ОписаниеТипов("СправочникСсылка.ТипыЦенНоменклатуры");
		Элементы.ТипЦен.ОграничениеТипа = ОписаниеТипа;
		Элементы.ТипЦен.ВыбиратьТип = Ложь;
	КонецЕсли;
	ТипЦен 			= Параметры.ТипЦен;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ИспользоватьКодНПП", ИспользоватьКодНПП);
		
	УправлениеЭУ(СтруктураПараметров);
	
	ПолучитьДопРеквизитыНоменклатурыНаСервере(Элементы.КодНПП.СписокВыбора);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеЭУ(СтруктураПараметров)
	
	СтруктураПараметров.Элементы.КодНПП.Видимость = СтруктураПараметров.ИспользоватьКодНПП;
	
КонецПроцедуры // УправлениеЭУ()

// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть();
	
КонецПроцедуры // Сохранить()

// ПередЗакрытием()
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы <> Неопределено Тогда 
		
		Если ЗавершениеРаботы И Модифицированность Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
		
	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриЗакрытии()
	
	ВладелецФормы.СтруктураРеквизитовФормы.КодНПП 				= КодНПП;
	ВладелецФормы.СтруктураРеквизитовФормы.ИспользоватьКодНПП 	= ИспользоватьКодНПП;
	ВладелецФормы.СтруктураРеквизитовФормы.ТипЦен 				= ТипЦен;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированныйОтчетЦеныПром_ИспользоватьКодНПП", ИспользоватьКодНПП);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированныйОтчетЦеныПром_КодНПП", 		 КодНПП);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированныйОтчетЦеныПром_ТипЦен",			ТипЦен);	
	
	мПрограммноеЗакрытие = Истина;
	Отказ = Истина;
	
	ПараметрыВозврата = Новый Структура();
	
	Закрыть(ПараметрыВозврата);
	
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры)Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		мПрограммноеЗакрытие = Истина;
		Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКодНПППриИзменении(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ИспользоватьКодНПП", ИспользоватьКодНПП);
		
	УправлениеЭУ(СтруктураПараметров);
	
	Модифицированность = Истина;	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользоватьКодНПП Тогда
		ПроверяемыеРеквизиты.Добавить("КодНПП");		
	КонецЕсли;
	
КонецПроцедуры
