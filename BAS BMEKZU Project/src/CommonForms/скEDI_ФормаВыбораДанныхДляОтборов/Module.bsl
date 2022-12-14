
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолеОтбора = Неопределено;
	Если НЕ Параметры.Свойство("ПолеОтбора", ПолеОтбора) Тогда
		Отказ = Истина;
		Возврат;		
	КонецЕсли;
	
	Если ПолеОтбора = "ВидЭлектронногоДокумента" или ПолеОтбора = "ВидЭлектронногоДокументаДокументыНДС" Тогда
		СписокТекущий = Неопределено;
		Если Параметры.Свойство("СписокТекущий", СписокТекущий) Тогда
			Все = Ложь;
			Для Каждого СтрокаСписка из СписокТекущий Цикл
				Если СтрокаСписка.Значение = Неопределено Тогда
					Все = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			ТипыЭлектронныхДокументов = Новый СписокЗначений;
			Если ПолеОтбора = "ВидЭлектронногоДокумента" Тогда
				ТипыЭлектронныхДокументов.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.ДокументСВложениями"));
				ТипыЭлектронныхДокументов.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.ПервичныйДокумент"));
			ИначеЕсли ПолеОтбора = "ВидЭлектронногоДокументаДокументыНДС" Тогда
				ТипыЭлектронныхДокументов.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.НалоговаяНакладная"));
				ТипыЭлектронныхДокументов.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_ТипыЭлектронныхДокументов.Приложение2КНалоговойНакладной"));
			КонецЕсли;
			
			Организация = Неопределено;
			Если Параметры.Свойство("Организация", Организация) Тогда
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	скEDI_ВидыЭлектронныхДокументов.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.скEDI_ВидыЭлектронныхДокументов КАК скEDI_ВидыЭлектронныхДокументов
				|ГДЕ
				|	скEDI_ВидыЭлектронныхДокументов.Владелец = &Организация
				|	И скEDI_ВидыЭлектронныхДокументов.ТипДокумента В(&ТипыЭлектронныхДокументов)";
				
				Запрос.УстановитьПараметр("Организация", Организация);
				Запрос.УстановитьПараметр("ТипыЭлектронныхДокументов", ТипыЭлектронныхДокументов);
				Выборка = Запрос.Выполнить().Выбрать();
				
				Пока Выборка.Следующий() Цикл
					ДобавитьЗначениеВСписок(Выборка.Ссылка, Все, СписокТекущий);
				КонецЦикла;
			КонецЕсли;
		Иначе
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ПолеОтбора = "СостояниеЭлектронногоДокумента" или ПолеОтбора = "СостояниеЭлектронногоДокументаДокументыНДС" Тогда
		СписокТекущий = Неопределено;
		Если Параметры.Свойство("СписокТекущий", СписокТекущий) Тогда
			Все = Ложь;
			Для Каждого СтрокаСписка из СписокТекущий Цикл
				Если СтрокаСписка.Значение = Неопределено Тогда
					Все = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	скEDI_СостоянияЭлектронныхДокументов.Ссылка
			|ИЗ
			|	Перечисление.скEDI_СостоянияЭлектронныхДокументов КАК скEDI_СостоянияЭлектронныхДокументов";
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				ДобавитьЗначениеВСписок(Выборка.Ссылка, Все, СписокТекущий);
			КонецЦикла;
		Иначе
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ПолеОтбора = "СостояниеЭлектронногоДокументаРегистрацияВДФС" или ПолеОтбора = "СостояниеЭлектронногоДокументаРегистрацияВДФСДокументыНДС" Тогда
		СписокТекущий = Неопределено;
		Если Параметры.Свойство("СписокТекущий", СписокТекущий) Тогда
			Все = Ложь;
			Для Каждого СтрокаСписка из СписокТекущий Цикл
				Если СтрокаСписка.Значение = Неопределено Тогда
					Все = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	скEDI_СостоянияЭлектронныхДокументовРегистрацияВДФС.Ссылка
			|ИЗ
			|	Перечисление.скEDI_СостоянияЭлектронныхДокументовРегистрацияВДФС КАК скEDI_СостоянияЭлектронныхДокументовРегистрацияВДФС";
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				ДобавитьЗначениеВСписок(Выборка.Ссылка, Все, СписокТекущий);
			КонецЦикла;
			//ДобавитьЗначениеВСписок(Перечисления.скEDI_СостоянияЭлектронныхДокументовРегистрацияВДФС.ПустаяСсылка(), Все, СписокТекущий, Нстр("ru = '<Неопределено>'; uk = '<Невизначено>'"));
		Иначе
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ПолеОтбора = "СоответствиеЭлектронныхДокументов" или ПолеОтбора = "СоответствиеЭлектронныхДокументовДокументыНДС" Тогда
		СписокТекущий = Неопределено;
		Если Параметры.Свойство("СписокТекущий", СписокТекущий) Тогда
			Все = Ложь;
			Для Каждого СтрокаСписка из СписокТекущий Цикл
				Если СтрокаСписка.Значение = Неопределено Тогда
					Все = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			ДобавитьЗначениеВСписок(ПредопределенноеЗначение("Перечисление.скEDI_СоответствиеДокументов1СиЭлектронныхДокументов.ЕстьДокумент1СиЭлектронныйДокумент"), Все, СписокТекущий);
			ДобавитьЗначениеВСписок(ПредопределенноеЗначение("Перечисление.скEDI_СоответствиеДокументов1СиЭлектронныхДокументов.ЕстьДокумент1СнетЭлектронногоДокумента"), Все, СписокТекущий);
			ДобавитьЗначениеВСписок(ПредопределенноеЗначение("Перечисление.скEDI_СоответствиеДокументов1СиЭлектронныхДокументов.ЕстьЭлектронныйДокументНетДокумент1С"), Все, СписокТекущий);
		Иначе
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ПолеОтбора = "ОтборВхИсх" или ПолеОтбора = "ОтборВхИсхДокументыНДС" Тогда
		СписокТекущий = Неопределено;
		Если Параметры.Свойство("СписокТекущий", СписокТекущий) Тогда
			Все = Ложь;
			Для Каждого СтрокаСписка из СписокТекущий Цикл
				Если СтрокаСписка.Значение = Неопределено Тогда
					Все = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			ДобавитьЗначениеВСписок(ПредопределенноеЗначение("Перечисление.скEDI_ВхИсхЭлектронныйДокумент.Исходящий"), Все, СписокТекущий);
			ДобавитьЗначениеВСписок(ПредопределенноеЗначение("Перечисление.скEDI_ВхИсхЭлектронныйДокумент.Входящий"), Все, СписокТекущий);
		Иначе
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗначениеВСписок(Значение, ОтборПоВсем, СписокТекущий, Представление = "");
	Если ОтборПоВсем Тогда
		Отметка = Ложь;
	Иначе
		Отметка = СписокТекущий.НайтиПоЗначению(Значение) <> Неопределено;
	КонецЕсли;
	СписокДанныхДляВыбора.Добавить(Значение, Представление, Отметка);
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	СписокДляОтбора = Новый СписокЗначений;
	Если Все Тогда
		СписокДляОтбора.Добавить(Неопределено, НСтр("ru = 'Все'; uk = 'Всі'"));
	Иначе
		Для Каждого Элемент Из СписокДанныхДляВыбора Цикл
			Если Элемент.Пометка Тогда
				СписокДляОтбора.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Закрыть(СписокДляОтбора);
КонецПроцедуры

&НаКлиенте
Процедура СписокДанныхДляВыбораПриИзменении(Элемент)
	ЕстьПомеченые = Ложь;
	НетНепомеченых = Истина;
	Для Каждого Элемент Из СписокДанныхДляВыбора Цикл
		Если Элемент.Пометка Тогда
			ЕстьПомеченые = Истина;
		Иначе
			НетНепомеченых = Ложь;
		КонецЕсли;
	КонецЦикла;
	Все = НетНепомеченых или Не ЕстьПомеченые;
КонецПроцедуры
