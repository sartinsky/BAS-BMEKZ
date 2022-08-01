#Область СлужебныйПрограммныйИнтерфейс

Функция ПравоЗапуск() Экспорт
	
	Возврат НСтр("ru='Запуск';uk='Запуск'");
	
КонецФункции

Функция ПравоЗапускИАдминистрирование() Экспорт
	
	Возврат НСтр("ru='Запуск и администрирование';uk='Запуск і адміністрування'");
	
КонецФункции

Функция РольВладелец() Экспорт
	
	Возврат НСтр("ru='Владелец';uk='Власник'");
	
КонецФункции

Функция РольАдминистратор() Экспорт
	
	Возврат НСтр("ru='Администратор';uk='Адміністратор'");
	
КонецФункции

Функция РольПользователь() Экспорт
	
	Возврат НСтр("ru='Пользователь';uk='Користувач'");
	
КонецФункции

Функция РольОператор() Экспорт
	
	Возврат НСтр("ru='Оператор';uk='Оператор'");
	
КонецФункции

Функция ПредставлениеРоли(Идентификатор) Экспорт
	
	Если Идентификатор = "owner" Тогда
		Возврат РольВладелец();
	ИначеЕсли Идентификатор = "administrator" Тогда
		Возврат РольАдминистратор();
	ИначеЕсли Идентификатор = "user" Тогда  
		Возврат РольПользователь();
	ИначеЕсли Идентификатор = "operator" Тогда
		Возврат РольОператор();
	КонецЕсли;
	
КонецФункции

Функция ИдентификаторAPIРоли(Представление) Экспорт
	
	Если Представление = РольВладелец() Тогда
		Возврат "owner";
	ИначеЕсли Представление = РольАдминистратор() Тогда
		Возврат "administrator";
	ИначеЕсли Представление = РольПользователь() Тогда
		Возврат "user";
	ИначеЕсли Представление = РольОператор() Тогда
		Возврат "operator";
	КонецЕсли;
	
КонецФункции

Функция ИдентификаторAPIПрава(Представление) Экспорт
	
	Если Представление = ПравоЗапуск() Тогда
		Возврат "user";
	ИначеЕсли Представление = ПравоЗапускИАдминистрирование() Тогда
		Возврат "administrator";
	КонецЕсли;
	
КонецФункции

#КонецОбласти