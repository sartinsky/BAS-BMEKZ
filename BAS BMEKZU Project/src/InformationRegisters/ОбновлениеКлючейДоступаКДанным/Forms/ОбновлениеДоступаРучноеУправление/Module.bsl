
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не СтандартныеПодсистемыСервер.ВерсияПрограммыОбновленаДинамически() Тогда
		СпискиСОграничением = УправлениеДоступомСлужебныйПовтИсп.СпискиСОграничением();
	Иначе
		СпискиСОграничением = УправлениеДоступомСлужебный.ДействующиеПараметрыОграниченияДоступа(Неопределено,
			Неопределено, Ложь);
	КонецЕсли;
	
	Списки = Новый Массив;
	Списки.Добавить("Справочник.НаборыГруппДоступа");
	Для Каждого ОписаниеСписка Из СпискиСОграничением Цикл
		ПолноеИмя = ОписаниеСписка.Ключ;
		Списки.Добавить(ПолноеИмя);
		Если Не УправлениеДоступомСлужебный.ЭтоСсылочныйТипТаблицы(ПолноеИмя) Тогда
			Продолжить;
		КонецЕсли;
		ПустаяСсылка = ПредопределенноеЗначение(ПолноеИмя + ".ПустаяСсылка");
		ТипыОбъектовОбновленияДоступа.Добавить(ПустаяСсылка, Строка(ТипЗнч(ПустаяСсылка)));
		ИменаТаблицТиповОбъектовОбновленияДоступа.Добавить(ПустаяСсылка, ПолноеИмя);
	КонецЦикла;
	ТипыОбъектовОбновленияДоступа.СортироватьПоПредставлению();
	
	Идентификаторы = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(Списки);
	
	Для Каждого ОписаниеИдентификатора Из Идентификаторы Цикл
		СпискиДляОбновления.Добавить(ОписаниеИдентификатора.Значение,
			Строка(ОписаниеИдентификатора.Значение));
	КонецЦикла;
	
	СпискиДляОбновления.СортироватьПоПредставлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектОбновленияДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущийЭлементТипа = ТипыОбъектовОбновленияДоступа.НайтиПоЗначению(
		ВыбранныйТипОбъектаОбновленияДоступа);
	
	Если ТекущийЭлементТипа = Неопределено Тогда
		ТекущийЭлементТипа = ТипыОбъектовОбновленияДоступа[0];
	КонецЕсли;
	
	ТипыОбъектовОбновленияДоступа.ПоказатьВыборЭлемента(
		Новый ОписаниеОповещения("ОбъектОбновленияДоступаНачалоВыбораПродолжение", ЭтотОбъект),
		НСтр("ru='Выбор типа данных';uk='Вибір типу даних'"),
		ТекущийЭлементТипа);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьДоступКОбъекту(Команда)
	
	Если Не ЗначениеЗаполнено(ОбъектОбновленияДоступа) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Выберите объект.';uk='Виберіть об''єкт.'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступКОбъекту(Команда)
	
	ПоказатьПредупреждение(, ОбновитьДоступКОбъектуНаСервере());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапланироватьОбновлениеДоступаКоВсемЭлементамОтмеченныхСписков(Команда)
	
	ЗапланироватьОбновлениеДоступаКоВсемЭлементамОтмеченныхСписковНаСервере();
	
	Оповестить("Запись_ОбновлениеКлючейДоступаКДанным", Новый Структура, Неопределено);
	Оповестить("Запись_ОбновлениеКлючейДоступаПользователей", Новый Структура, Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбновитьДоступКОбъектуНаСервере()
	
	Если Не ЗначениеЗаполнено(ОбъектОбновленияДоступа) Тогда
		Возврат НСтр("ru='Выберите объект.';uk='Виберіть об''єкт.'");
	КонецЕсли;
	
	УправлениеДоступомСлужебный.ОчиститьКэшЗначенийГруппДоступаДляРасчетаПрав();
	
	ПолноеИмя = ОбъектОбновленияДоступа.Метаданные().ПолноеИмя();
	ИдентификаторТранзакции = Новый УникальныйИдентификатор;
	
	Текст = "";
	
	ОбновитьДоступКОбъектуДляВидаПользователей(ОбъектОбновленияДоступа,
		ПолноеИмя, ИдентификаторТранзакции, Ложь, Текст);
	
	ОбновитьДоступКОбъектуДляВидаПользователей(ОбъектОбновленияДоступа,
		ПолноеИмя, ИдентификаторТранзакции, Истина, Текст);
	
	Возврат Текст;
	
КонецФункции

&НаСервере
Процедура ОбновитьДоступКОбъектуДляВидаПользователей(СсылкаНаОбъект, ПолноеИмя, ИдентификаторТранзакции, ДляВнешнихПользователей, Текст)
	
	ПараметрыОграничения = УправлениеДоступомСлужебный.ПараметрыОграничения(ПолноеИмя,
		ИдентификаторТранзакции, ДляВнешнихПользователей);
	
	Текст = Текст + ?(Текст = "", "", Символы.ПС + Символы.ПС);
	Если ДляВнешнихПользователей Тогда
		Если ПараметрыОграничения.ДоступЗапрещен Тогда
			Текст = Текст + НСтр("ru='Для внешних пользователей (доступ запрещен):';uk='Для зовнішніх користувачів (доступ заборонений):'");
			
		ИначеЕсли ПараметрыОграничения.ОграничениеОтключено Тогда
			Текст = Текст + НСтр("ru='Для внешних пользователей (ограничение отключено):';uk='Для зовнішніх користувачів (обмеження вимкнено):'");
		Иначе
			Текст = Текст + НСтр("ru='Для внешних пользователей:';uk='Для зовнішніх користувачів:'");
		КонецЕсли;
	Иначе
		Если ПараметрыОграничения.ДоступЗапрещен Тогда
			Текст = Текст + НСтр("ru='Для пользователей (доступ запрещен):';uk='Для користувачів (доступ заборонений):'");
			
		ИначеЕсли ПараметрыОграничения.ОграничениеОтключено Тогда
			Текст = Текст + НСтр("ru='Для пользователей (ограничение отключено):';uk='Для користувачів (обмеження вимкнено):'");
		Иначе
			Текст = Текст + НСтр("ru='Для пользователей:';uk='Для користувачів:'");
		КонецЕсли;
	КонецЕсли;
	
	КлючДоступаИсточникаУстарел = УправлениеДоступомСлужебный.КлючДоступаИсточникаУстарел(
		СсылкаНаОбъект, ПараметрыОграничения);
	
	ЕстьИзмененияПрав = Ложь;
	
	УправлениеДоступомСлужебный.ОбновитьКлючиДоступаЭлементовДанныхПриЗаписи(СсылкаНаОбъект,
		ПараметрыОграничения, ИдентификаторТранзакции, Истина, ЕстьИзмененияПрав);
	
	Если ПараметрыОграничения.ОграничениеОтключено
	 Или ПараметрыОграничения.ДоступЗапрещен
	 Или ПараметрыОграничения.ИспользуетсяОграничениеПоВладельцу Тогда
		
		Если Не ПараметрыОграничения.Свойство("ТекстЗапросаЭлементовДанныхДляОчисткиКлючей") Тогда
			Если КлючДоступаИсточникаУстарел Тогда
				Текст = Текст + Символы.ПС + НСтр("ru='1. У объекта установлен всегда разрешенный ключ доступа.';uk='1. У об''єкта встановлений завжди дозволений ключ доступу.'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru='1. Обновление не требуется. У объекта ключ доступа уже всегда разрешенный.';uk='1. Оновлення не потрібне. У об''єкта ключ доступу вже завжди дозволений.'");
			КонецЕсли;
		Иначе
			Если КлючДоступаИсточникаУстарел Тогда
				Текст = Текст + Символы.ПС + НСтр("ru='1. У объекта очищен ключ доступа.';uk='1. У об''єкта очищенj ключ доступу.'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru='1. Обновление не требуется. У объекта ключ доступа уже пустой.';uk='1. Оновлення не потрібне. У об''єкта ключ доступу вже порожній.'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если КлючДоступаИсточникаУстарел Тогда
			Текст = Текст + Символы.ПС + НСтр("ru='1. У объекта обновлен ключ доступа.';uk='1. У об''єкта оновлено ключ доступу.'");
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru='1. Обновление не требуется. У объекта ключ доступа не устарел.';uk='1. Оновлення не потрібне. У об''єкта ключ доступу не застарів.'");
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыОграничения.ОграничениеОтключено
	 Или ПараметрыОграничения.ДоступЗапрещен
	 Или ПараметрыОграничения.ИспользуетсяОграничениеПоВладельцу Тогда
		
		Если Не ПараметрыОграничения.Свойство("ТекстЗапросаЭлементовДанныхДляОчисткиКлючей") Тогда
			Если ЕстьИзмененияПрав Тогда
				Текст = Текст + Символы.ПС
					+ НСтр("ru='2. У всегда разрешенного ключа доступа обновлен состав
                                 |   групп доступа или пользователей или внешних пользователей.'
                                 |;uk='2. У завжди дозволеного ключа доступу оновлений склад
                                 |груп доступу або користувачів або зовнішніх користувачів.'");
			Иначе
				Текст = Текст + Символы.ПС
					+ НСтр("ru='2. Обновление не требуется. У всегда разрешенного ключа доступа
                                 |   состав групп доступа, пользователей и внешних пользователей не устарел.'
                                 |;uk='2. Оновлення не потрібне. У завжди дозволеного ключа доступу
                                 |склад груп доступу користувачів і зовнішніх користувачів не застарів.'");
			КонецЕсли;
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru='2. Обновление не требуется. Пустой ключ доступа всегда запрещен.';uk='2. Оновлення не потрібне. Порожній ключ доступу завжди заборонений.'");
		КонецЕсли;
		
	ИначеЕсли ЕстьИзмененияПрав Тогда
		Если ПараметрыОграничения.ЕстьОграничениеПоПользователям Тогда
			Если ДляВнешнихПользователей Тогда
				Текст = Текст + Символы.ПС + НСтр("ru='2. У ключа доступа обновлен состав внешних пользователей.';uk='2. У ключа доступу оновлений склад зовнішніх користувачів.'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru='2. У ключа доступа обновлен состав пользователей.';uk='2. У ключа доступу оновлений склад користувачів.'");
			КонецЕсли;
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru='2. У ключа доступа обновлен состав групп доступа.';uk='2. У ключа доступу оновлений склад груп доступу.'");
		КонецЕсли;
	Иначе
		Если ПараметрыОграничения.ЕстьОграничениеПоПользователям Тогда
			Если ДляВнешнихПользователей Тогда
				Текст = Текст + Символы.ПС + НСтр("ru='2. Обновление не требуется. У ключа доступа состав внешних пользователей не устарел.';uk='2. Оновлення не потрібне. У ключа доступу склад зовнішніх користувачів не застарів.'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru='2. Обновление не требуется. У ключа доступа состав пользователей не устарел.';uk='2. Оновлення не потрібне. У ключа доступу склад користувачів не застарів.'");
			КонецЕсли;
		Иначе
			Текст = Текст + Символы.ПС + НСтр("ru='2. Обновление не требуется. У ключа доступа состав групп доступа не устарел.';uk='2. Оновлення не потрібне. У ключа доступу склад груп доступу не застарів.'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗапланироватьОбновлениеДоступаКоВсемЭлементамОтмеченныхСписковНаСервере()
	
	Списки = Новый Массив;
	Для Каждого ЭлементСписка Из СпискиДляОбновления Цикл
		Если ЭлементСписка.Пометка Тогда
			Списки.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если Списки.Количество() = СпискиДляОбновления.Количество() Тогда
		Списки = Неопределено;
	КонецЕсли;
	
	УправлениеДоступомСлужебный.ОчиститьКэшЗначенийГруппДоступаДляРасчетаПрав();
	УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступа(Списки);
	
	УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Ложь);
	УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Истина);
	
КонецПроцедуры

// Продолжение обработчика события ОбъектОбновленияДоступаНачалоВыбора.
&НаКлиенте
Процедура ОбъектОбновленияДоступаНачалоВыбораПродолжение(ВыбранныйЭлемент, Неопределен) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныйТипОбъектаОбновленияДоступа = ВыбранныйЭлемент.Значение;
	Если ТипЗнч(ОбъектОбновленияДоступа) <> ТипЗнч(ВыбранныйТипОбъектаОбновленияДоступа) Тогда
		ОбъектОбновленияДоступа = ВыбранныйТипОбъектаОбновленияДоступа;
	КонецЕсли;
	
	ЗначениеДоступаНачалоВыбораЗавершение();
	
КонецПроцедуры

// Завершение обработчика события ОбъектОбновленияДоступаНачалоВыбора.
&НаКлиенте
Процедура ЗначениеДоступаНачалоВыбораЗавершение()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ОбъектОбновленияДоступа);
	
	ЭлементСписка = ИменаТаблицТиповОбъектовОбновленияДоступа.НайтиПоЗначению(
		ВыбранныйТипОбъектаОбновленияДоступа);
	
	Если ЭлементСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяФормыВыбора = ЭлементСписка.Представление + ".ФормаВыбора";
	
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, Элементы.ОбъектОбновленияДоступа);
	
КонецПроцедуры

#КонецОбласти
