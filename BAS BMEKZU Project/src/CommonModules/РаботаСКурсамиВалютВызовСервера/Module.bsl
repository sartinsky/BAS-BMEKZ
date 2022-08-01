#Область СлужебныеПроцедурыИФункции

// Проверяет актуальность курсов всех валют.
//
Функция КурсыАктуальны() Экспорт
	Возврат РаботаСКурсамиВалют.КурсыАктуальны();
КонецФункции

&НаСервере
Функция ПоказатьРекламуЗагрузкиКурсовВалютФинансУА() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	ПоказываемРекламу = Истина;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Показываем рекламу, если:
	// - Включено регламентное задание ЗагрузкаКурсовВалют
	// - Текущему пользователю сегодня реклама еще не показывалась, дата последнего показа = текущая дата
	// - Код доступа к загрузке курсов валют с сайта 1c. finance.ua не актуален
	
	// 1
	ИспользоватьРегламентноеЗаданиеЗагрузкаКурсовВалют = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют.Использование;
	
	ПоказываемРекламу = ПоказываемРекламу И ИспользоватьРегламентноеЗаданиеЗагрузкаКурсовВалют;
	
	Если НЕ ПоказываемРекламу Тогда
		Возврат Ложь;
	КонецЕсли;		
	
	// 2
	ДатаПоказаРекламы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЗагрузкаКурсовВалют", "ДатаПоказаРекламы");
	Если ТипЗнч(ДатаПоказаРекламы) = Тип("Дата") Тогда
		ДатаПоказаРекламы = НачалоДня(ДатаПоказаРекламы);
	КонецЕсли;	
		
	ПоказываемРекламу = ПоказываемРекламу И (ДатаПоказаРекламы <> НачалоДня(ТекущаяДата()));
	
	Если НЕ ПоказываемРекламу Тогда
		Возврат Ложь;
	КонецЕсли;		
	
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПоказываемРекламу;
	
КонецФункции	

#КонецОбласти
