#Область ПрограммныйИнтерфейс

Процедура ТабельДанныеОВремениПередОкончаниемРедактирования(Форма, Элемент, НоваяСтрока, ОтменаРедактирования, Отказ) Экспорт
	
	ДанныеТекущейСтроки  = Форма.Элементы.ОтработанноеВремя.ТекущиеДанные;
	ДеньНачалаПериода    = День(Форма.Объект.ДатаНачалаПериода);
	ДеньОкончанияПериода = День(Форма.Объект.ДатаОкончанияПериода);
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		ОбозначенияВидовВремени = ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельОбозначенияВидовВремени(Форма.ОписаниеВидовВремени);
		ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельЗаполнитьИтогиПоСотруднику(ДанныеТекущейСтроки, ОбозначенияВидовВремени, ДеньНачалаПериода, ДеньОкончанияПериода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
