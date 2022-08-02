
// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	Организация = Параметры.Организация;
	
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	
	ДатаНач = Параметры.ДатаНач;
	ДатаКон = Параметры.ДатаКон;
	ВключатьГПХ = Параметры.ВключатьГПХ;
	
КонецПроцедуры // ПриСозданииНаСервере()

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
	
	ВладелецФормы.СтруктураРеквизитовФормы.ДатаНач = ДатаНач;
	ВладелецФормы.СтруктураРеквизитовФормы.ДатаКон = ДатаКон;
	ВладелецФормы.СтруктураРеквизитовФормы.ВключатьГПХ = ВключатьГПХ;
	
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
Процедура ДатаНачПриИзменении(Элемент)
	Если ДатаКон < ДатаНач Тогда
		ДатаКон = ДатаНач;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДатаКонПриИзменении(Элемент)
	Если ДатаКон < ДатаНач Тогда
		ДатаКон = ДатаНач;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаКонОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры