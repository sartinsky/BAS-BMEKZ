
Процедура ПриЗаписи(Отказ)
	Если Основная Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	скEDI_Организации.Ссылка
		               |ИЗ
		               |	Справочник.скEDI_Организации КАК скEDI_Организации
		               |ГДЕ
		               |	скEDI_Организации.Ссылка <> &Ссылка
		               |	И скEDI_Организации.Основная";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
		Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
			ОрганизацияОбъект = ВыборкаРезультатаЗапроса.Ссылка.ПолучитьОбъект();
			ОрганизацияОбъект.Основная = Ложь;
			ОрганизацияОбъект.Записать();
		КонецЦикла;
	КонецЕсли; 
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	//Отказ = Не МонопольныйРежим();
КонецПроцедуры
