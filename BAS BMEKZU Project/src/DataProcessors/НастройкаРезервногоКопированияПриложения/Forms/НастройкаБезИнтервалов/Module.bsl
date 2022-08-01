#Область ОписаниеПеременных

&НаКлиенте
Перем ОтветПередЗакрытием;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		Отказ = Истина;
		ВызватьИсключение НСтр("ru='Для корректной работы необходим режим толстого, тонкого или ВЕБ-клиента.';uk='Для коректної роботи необхідний режим товстого, тонкого або ВЕБ-клієнта.'");
		
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеОбластейДанных.ПолучитьНастройкиРезервногоКопированияОбласти(
		РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиРезервногоКопирования);
	
	Для НомерМесяца = 1 По 12 Цикл
		Элементы.МесяцФормированияЕжегодныхКопий.СписокВыбора.Добавить(НомерМесяца, 
			Формат(Дата(2, НомерМесяца, 1), "ДФ=MMMM"));
	КонецЦикла;
	
	ЧасовойПояс = ЧасовойПоясСеанса();
	ЧасовойПоясОбласти = ЧасовойПояс + " (" + ПредставлениеЧасовогоПояса(ЧасовойПояс) + ")";
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтветПередЗакрытием = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), 
		РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
КонецПроцедуры
		
&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт	
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьНастройкиРезервногоКопирования();
	КонецЕсли;
	ОтветПередЗакрытием = Истина;
    Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПоУмолчанию(Команда)
	
	УстановитьПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНастройкиРезервногоКопирования();
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПоУмолчаниюНаСервере()
	
	НастройкиРезервногоКопирования = РезервноеКопированиеОбластейДанных.ПолучитьНастройкиРезервногоКопированияОбласти();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиРезервногоКопирования);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиРезервногоКопирования()

	СоответствиеНастроек = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	
	НастройкиРезервногоКопирования = Новый Структура;
	Для Каждого КлючИЗначение Из СоответствиеНастроек Цикл
		НастройкиРезервногоКопирования.Вставить(КлючИЗначение.Значение, ЭтотОбъект[КлючИЗначение.Значение]);
	КонецЦикла;
	
	РезервноеКопированиеОбластейДанных.УстановитьНастройкиРезервногоКопированияОбласти(
		РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), НастройкиРезервногоКопирования);
		
КонецПроцедуры

#КонецОбласти
