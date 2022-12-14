&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Настроено Тогда
		Соединение = Неопределено;
		ТекстОшибки = "";
		MSSQLServer_ПодключитьНаСервере(Соединение, ТекстОшибки, Ложь, Ложь);
	Иначе
		Элементы.ИмяСервера.ТолькоПросмотр = Ложь;
		Элементы.ИмяПользователя.ТолькоПросмотр = Ложь;
		Элементы.Пароль.ТолькоПросмотр = Ложь;
		Элементы.ИмяБазыДанных.ТолькоПросмотр = Ложь;
		Элементы.MSSQLServer_Подключить.Доступность = Истина;
		Элементы.MSSQLServer_Одключить.Доступность = Ложь;
		
		MSSQLServer_СоединениеНастроено = Ложь;
		MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Соединение не установлено'; uk = 'З''єднання не встановлено'");
		MSSQLServer_ОбъектыБДНастроены = Ложь;
		Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
		Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
		Элементы.MSSQLServer_ПроверитьОбъектыБД.Доступность = Ложь;
	КонецЕсли;
	ПрочитатьКонстантуТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументовНаСервере();
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ПодключитьНаСервере(Соединение, ТекстОшибки, СоздатьОбъектыБД, ОбновитьОбъектыБД)
	Если скEDI_ВнешниеХранилищаMSSQLServer.ПолучитьСоединение(Соединение, Объект.ИмяСервера, Объект.ИмяПользователя, Объект.Пароль, Объект.ИмяБазыДанных, ТекстОшибки) Тогда
		MSSQLServer_СоединениеНастроено = Истина;
		Элементы.ИмяСервера.ТолькоПросмотр = Истина;
		Элементы.ИмяПользователя.ТолькоПросмотр = Истина;
		Элементы.Пароль.ТолькоПросмотр = Истина;
		Элементы.ИмяБазыДанных.ТолькоПросмотр = Истина;
		Элементы.MSSQLServer_ПроверитьОбъектыБД.Доступность = Истина;
		Элементы.MSSQLServer_Подключить.Доступность = Ложь;
		Элементы.MSSQLServer_Одключить.Доступность = Истина;
		Если СоздатьОбъектыБД Тогда
			Записать();
			MSSQLServer_СоздатьОбъектыБДНаСервере(Соединение, ТекстОшибки);
		ИначеЕсли ОбновитьОбъектыБД Тогда
			Записать();
			MSSQLServer_ОбновитьБДНаСервере(Соединение, ТекстОшибки);
		КонецЕсли;
		MSSQLServer_ПроверитьНастройкиБДНаСервере(Соединение, ТекстОшибки);
	Иначе
		Объект.Настроено = Ложь;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Записать();
		КонецЕсли;
		Элементы.ИмяСервера.ТолькоПросмотр = Ложь;
		Элементы.ИмяПользователя.ТолькоПросмотр = Ложь;
		Элементы.Пароль.ТолькоПросмотр = Ложь;
		Элементы.ИмяБазыДанных.ТолькоПросмотр = Ложь;
		Элементы.MSSQLServer_Подключить.Доступность = Истина;
		Элементы.MSSQLServer_Одключить.Доступность = Ложь;
		
		MSSQLServer_СоединениеНастроено = Ложь;
		MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Соединение не установлено'; uk = 'З''єднання не встановлено'");
		MSSQLServer_ОбъектыБДНастроены = Ложь;
		Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
		Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
		Элементы.MSSQLServer_ПроверитьОбъектыБД.Доступность = Ложь;
	КонецЕсли;
	ПрочитатьКонстантуТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументовНаСервере();
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ОдключитьНаСервере()
	Объект.Настроено = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;
	
	Элементы.ИмяСервера.ТолькоПросмотр = Ложь;
	Элементы.ИмяПользователя.ТолькоПросмотр = Ложь;
	Элементы.Пароль.ТолькоПросмотр = Ложь;
	Элементы.ИмяБазыДанных.ТолькоПросмотр = Ложь;
	Элементы.MSSQLServer_Подключить.Доступность = Истина;
	Элементы.MSSQLServer_Одключить.Доступность = Ложь;
	
	MSSQLServer_СоединениеНастроено = Ложь;
	MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Соединение не установлено'; uk = 'З''єднання не встановлено'");
	MSSQLServer_ОбъектыБДНастроены = Ложь;
	Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
	Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
	Элементы.MSSQLServer_ПроверитьОбъектыБД.Доступность = Ложь;
	
	ОтменитьКакОсновноеХранилищеНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура MSSQLServer_Одключить(Команда)
	MSSQLServer_ОдключитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ПроверитьНастройкиБДНаСервере(Соединение, ТекстОшибки, Записывать = Истина)
	Настройки = Справочники.скEDI_ВнешниеХранилищаСодержимогоЭлектронныхДокументов.ПрочитатьXMLНастройкиMSSQLServer();
	
	Инфо = "";
	КвоОшибок = 0;
	КвоОбъектовКорректных = 0;
	КвоОбъектовСОшибками = 0;
	СписокОбъектовСОшибками = "";
	КвоОбъектовОтсутствуют = 0;
	СписокОбъектовОтсутствуют = "";
	
	Для Каждого ОбъектБазыДанных Из Настройки.МассивОбъектов Цикл
		ОбъектЕсть = Неопределено;
		ОбъектКорректен = Неопределено;
		ЕстьОшибки = Ложь;
		
		Если ЗначениеЗаполнено(ОбъектБазыДанных.ПроверкаНаличияОбъекта) Тогда
			ТекТекстОшибки = "";
			RecordSet = Неопределено;
			Если скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ОбъектБазыДанных.ПроверкаНаличияОбъекта, RecordSet, ТекТекстОшибки) Тогда
				Если RecordSet.EOF Тогда
					ОбъектЕсть = Ложь;
				Иначе
					ОбъектЕсть = Истина;
				КонецЕсли;
			Иначе
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьОшибки Тогда
			КвоОшибок = КвоОшибок + 1;
			ТекстОшибки = ТекТекстОшибки;
			Прервать;
		Иначе
			Если ЗначениеЗаполнено(ОбъектБазыДанных.ТестОбъекта) Тогда
				Если ОбъектЕсть <> Ложь Тогда
					ТекТекстОшибки = "";
					RecordSet = Неопределено;
					Если скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ОбъектБазыДанных.ТестОбъекта, RecordSet, ТекТекстОшибки) Тогда
						ОбъектЕсть = Истина;
						ОбъектКорректен = Истина;
					Иначе
						Если ОбъектЕсть = Истина Тогда
							ОбъектКорректен = Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ОбъектЕсть = Истина Тогда
			Если ОбъектКорректен = Ложь Тогда
				КвоОбъектовСОшибками = КвоОбъектовСОшибками + 1;
				СписокОбъектовСОшибками = СписокОбъектовСОшибками + ?(СписокОбъектовСОшибками = "", "", Символы.ПС) + ОбъектБазыДанных.Описание + " (" + ОбъектБазыДанных.ИмяОбъекта + ")";
			Иначе
				КвоОбъектовКорректных = КвоОбъектовКорректных + 1;
			КонецЕсли;
		ИначеЕсли ОбъектЕсть = Ложь Тогда
			КвоОбъектовОтсутствуют = КвоОбъектовОтсутствуют + 1;
			СписокОбъектовОтсутствуют = СписокОбъектовОтсутствуют + ?(СписокОбъектовОтсутствуют = "", "", Символы.ПС) + ОбъектБазыДанных.Описание + " (" + ОбъектБазыДанных.ИмяОбъекта + ")";
		Иначе
			
		КонецЕсли;
	КонецЦикла;
	
	
	Если КвоОшибок = 0 Тогда
		Если (КвоОбъектовКорректных = 0) и (КвоОбъектовСОшибками = 0) Тогда
			MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Необходимо создать объекты базы данных.'; uk = 'Необхідно створити об''єкти бази данних.'");
			MSSQLServer_ОбъектыБДНастроены = Ложь;
			Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Истина;
			Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
			Объект.Настроено = Ложь;
			Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
				Записать();
			КонецЕсли;
		ИначеЕсли (КвоОбъектовОтсутствуют = 0) и (КвоОбъектовСОшибками = 0) Тогда
			MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Объекты БД настроены корректно.'; uk = 'Об''єкти БД налаштовані корректно.'");
			MSSQLServer_ОбъектыБДНастроены = Истина;
			Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
			Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
			Объект.Настроено = Истина;
			
			ТекВерсия = Неопределено;
			ЕстьОбновления = Ложь;
			ЕстьОбновленияВерсия = "";
			Для Каждого ЭлементМассиваВерсий Из Настройки.МассивВерсий Цикл
				Если ТекВерсия = Неопределено Тогда
					Если ЗначениеЗаполнено(ЭлементМассиваВерсий.Тест) Тогда
						ТекТекстОшибки = "";
						RecordSet = Неопределено;
						Если скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ЭлементМассиваВерсий.Тест, RecordSet, ТекТекстОшибки) Тогда
							Если RecordSet.EOF Тогда
								Продолжить;
							Иначе
								ТекВерсия = ЭлементМассиваВерсий.НомерВерсии;
							КонецЕсли;
						Иначе
							Продолжить;
						КонецЕсли;
					Иначе
						Продолжить;
					КонецЕсли;
				Иначе
					Если ЭлементМассиваВерсий.Обновление.Количество() > 0 Тогда
						ЕстьОбновленияВерсия = ЭлементМассиваВерсий.НомерВерсии;
						ЕстьОбновления = Истина;
					Иначе
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Объект.Версия = ТекВерсия;
			
			Если ЕстьОбновления Тогда
				MSSQLServer_ОбъектыБДСостояние = MSSQLServer_ОбъектыБДСостояние
					+ Символы.ПС + НСтр("ru = 'Доступна новая версия'; uk = 'Доступна нова версія'") + ": " + ЕстьОбновленияВерсия;
				Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Истина;
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
				Записать();
			//КонецЕсли;
		Иначе
			MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Объекты БД настроены не корректно.'; uk = 'Об''єкти БД налаштовані не корректно.'");
			Если СписокОбъектовОтсутствуют <> "" Тогда
				MSSQLServer_ОбъектыБДСостояние = MSSQLServer_ОбъектыБДСостояние + Символы.ПС + НСтр("ru = 'Отсутствуют:'; uk = 'Відсутні:'") + Символы.ПС + СписокОбъектовОтсутствуют;
			КонецЕсли;
			Если СписокОбъектовСОшибками <> "" Тогда
				MSSQLServer_ОбъектыБДСостояние = MSSQLServer_ОбъектыБДСостояние + Символы.ПС + НСтр("ru = 'Есть ошибки:'; uk = 'Є помилки:'") + Символы.ПС + СписокОбъектовСОшибками;
			КонецЕсли;
			MSSQLServer_ОбъектыБДНастроены = Ложь;
			Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
			Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
			Объект.Настроено = Ложь;
			Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
				Записать();
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
		Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
		MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Ошибка'; uk = 'Помилка'");
		MSSQLServer_ОбъектыБДНастроены = Ложь;
		Объект.Настроено = Ложь;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Записать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ОбновитьБДНаСервере(Соединение, ТекстОшибки)
	Настройки = Справочники.скEDI_ВнешниеХранилищаСодержимогоЭлектронныхДокументов.ПрочитатьXMLНастройкиMSSQLServer();
	
	ТекВерсия = Неопределено;
	Для Каждого ЭлементМассиваВерсий Из Настройки.МассивВерсий Цикл
		Если ТекВерсия = Неопределено Тогда
			Если ЗначениеЗаполнено(ЭлементМассиваВерсий.Тест) Тогда
				ТекТекстОшибки = "";
				RecordSet = Неопределено;
				Если скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ЭлементМассиваВерсий.Тест, RecordSet, ТекТекстОшибки) Тогда
					Если RecordSet.EOF Тогда
						Продолжить;
					Иначе
						ТекВерсия = ЭлементМассиваВерсий.НомерВерсии;
					КонецЕсли;
				Иначе
					Продолжить;
				КонецЕсли;
			Иначе
				Продолжить;
			КонецЕсли;
		Иначе
			Если ЭлементМассиваВерсий.Обновление.Количество() > 0 Тогда
				ЕстьОшибки = Ложь;
				Для Каждого ЭлементОбновления из ЭлементМассиваВерсий.Обновление Цикл
					ТекТекстОшибки = "";
					RecordSet = Неопределено;
					Если не скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ЭлементОбновления, RecordSet, ТекТекстОшибки) Тогда
						ЕстьОшибки = Истина;
						ТекстОшибки = ТекТекстОшибки;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если ЕстьОшибки Тогда
					Прервать;
				Иначе
					ТекВерсия = ЭлементМассиваВерсий.НомерВерсии;
				КонецЕсли;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_СоздатьОбъектыБДНаСервере(Соединение, ТекстОшибки)
	Настройки = Справочники.скEDI_ВнешниеХранилищаСодержимогоЭлектронныхДокументов.ПрочитатьXMLНастройкиMSSQLServer();
	
	Инфо = "";
	КвоОшибок = 0;
	КвоОбъектовКорректных = 0;
	КвоОбъектовСОшибками = 0;
	СписокОбъектовСОшибками = "";
	КвоОбъектовОтсутствуют = 0;
	СписокОбъектовОтсутствуют = "";
	
	Для Каждого ОбъектБазыДанных Из Настройки.МассивОбъектов Цикл
		ОбъектЕсть = Неопределено;
		ОбъектКорректен = Неопределено;
		ЕстьОшибки = Ложь;
		
		Если ЗначениеЗаполнено(ОбъектБазыДанных.ПроверкаНаличияОбъекта) Тогда
			ТекТекстОшибки = "";
			RecordSet = Неопределено;
			Если скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ОбъектБазыДанных.ПроверкаНаличияОбъекта, RecordSet, ТекТекстОшибки) Тогда
				Если RecordSet.EOF Тогда
					ОбъектЕсть = Ложь;
				Иначе
					ОбъектЕсть = Истина;
				КонецЕсли;
			Иначе
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьОшибки Тогда
			КвоОшибок = КвоОшибок + 1;
			ТекстОшибки = ТекТекстОшибки;
			Прервать;
		Иначе
			Если ЗначениеЗаполнено(ОбъектБазыДанных.СозданиеОбъекта) Тогда
				Если ОбъектЕсть <> Истина Тогда
					ТекТекстОшибки = "";
					RecordSet = Неопределено;
					Если скEDI_ВнешниеХранилищаMSSQLServer.ВыполнитьЗапрос(Соединение, ОбъектБазыДанных.СозданиеОбъекта, RecordSet, ТекТекстОшибки) Тогда
					Иначе
						КвоОшибок = КвоОшибок + 1;
						ТекстОшибки = ТекТекстОшибки;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если КвоОшибок = 0 Тогда
	Иначе
		Элементы.MSSQLServer_СоздатьОбъектыБД.Доступность = Ложь;
		Элементы.MSSQLServer_ОбновитьОбъектыБД.Доступность = Ложь;
		MSSQLServer_ОбъектыБДСостояние = НСтр("ru = 'Ошибка'; uk = 'Помилка'");
		MSSQLServer_ОбъектыБДНастроены = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ВыполнитьПодключитьИПроверитьНаСервере(ТекстОшибки)
	Соединение = Неопределено;
	MSSQLServer_ПодключитьНаСервере(Соединение, ТекстОшибки, Ложь, Ложь);
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ВыполнитьСоздатьОбъектыИПроверитьНаСервере(ТекстОшибки)
	Соединение = Неопределено;
	MSSQLServer_ПодключитьНаСервере(Соединение, ТекстОшибки, Истина, Ложь);
КонецПроцедуры

&НаСервере
Процедура MSSQLServer_ВыполнитьОбновитьОбъектыИПроверитьНаСервере(ТекстОшибки)
	Соединение = Неопределено;
	MSSQLServer_ПодключитьНаСервере(Соединение, ТекстОшибки, Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура MSSQLServer_Подключить(Команда)
	ТекстОшибки = "";
	MSSQLServer_ВыполнитьПодключитьИПроверитьНаСервере(ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура MSSQLServer_ПроверитьОбъектыБД(Команда)
	ТекстОшибки = "";
	MSSQLServer_ВыполнитьПодключитьИПроверитьНаСервере(ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура MSSQLServer_СоздатьОбъектыБД(Команда)
	ТекстОшибки = "";
	MSSQLServer_ВыполнитьСоздатьОбъектыИПроверитьНаСервере(ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКонстантуТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументовНаСервере()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Константы.скEDI_ТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументов.Получить() = Объект.Ссылка Тогда
			ОсновноеХранилище = Истина;
			Элементы.УстановитьКакОсновноеХранилище.Доступность = Ложь;
			Элементы.ОтменитьКакОсновноеХранилище.Доступность = Истина;
		Иначе
			ОсновноеХранилище = Ложь;
			Если Объект.Настроено Тогда
				Элементы.УстановитьКакОсновноеХранилище.Доступность = Истина;
			Иначе
				Элементы.УстановитьКакОсновноеХранилище.Доступность = Ложь;
			КонецЕсли;
			Элементы.ОтменитьКакОсновноеХранилище.Доступность = Ложь;
		КонецЕсли;
	Иначе
		ОсновноеХранилище = Ложь;
		Элементы.УстановитьКакОсновноеХранилище.Доступность = Ложь;
		Элементы.ОтменитьКакОсновноеХранилище.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьКакОсновноеХранилищеНаСервере()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Объект.Настроено Тогда
			Константы.скEDI_ТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументов.Установить(Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	ПрочитатьКонстантуТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКакОсновноеХранилище(Команда)
	УстановитьКакОсновноеХранилищеНаСервере();
КонецПроцедуры


&НаСервере
Процедура ОтменитьКакОсновноеХранилищеНаСервере()
	Константы.скEDI_ТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументов.Установить(ПредопределенноеЗначение("Справочник.скEDI_ВнешниеХранилищаСодержимогоЭлектронныхДокументов.ПустаяСсылка"));
	ПрочитатьКонстантуТекущееВнешнееХранилищеСодержимогоЭлектронныхДокументовНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ОтменитьКакОсновноеХранилище(Команда)
	ОтменитьКакОсновноеХранилищеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура MSSQLServer_ОбновитьОбъектыБД(Команда)
	ТекстОшибки = "";
	MSSQLServer_ВыполнитьОбновитьОбъектыИПроверитьНаСервере(ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры



