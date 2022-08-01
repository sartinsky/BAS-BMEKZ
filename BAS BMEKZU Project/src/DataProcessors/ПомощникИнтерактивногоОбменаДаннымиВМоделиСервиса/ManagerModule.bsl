#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ВыгрузкаДанныхДляСопоставления

Процедура ПриНачалеВыгрузкиДанныхДляСопоставления(НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание = Истина) Экспорт
	
	КлючФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Выгрузка данных для сопоставления (%1)';uk='Вивантаження даних для співставлення (%1)'"),
		НастройкиВыгрузки.Корреспондент);

	Если ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Выгрузка данных для сопоставления для ""%1"" уже выполняется.';uk='Вивантаження даних для співставлення для ""%1"" вже виконується.'"),
			НастройкиВыгрузки.Корреспондент);
	КонецЕсли;
		
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиВыгрузки", НастройкиВыгрузки);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Выгрузка данных для сопоставления (%1).';uk='Вивантаження даних для співставлення (%1).'"),
		НастройкиВыгрузки.Корреспондент);
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ЗапуститьНеВФоне    = Ложь;
	ПараметрыВыполнения.ЗапуститьВФоне      = Истина;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникИнтерактивногоОбменаДаннымиВМоделиСервиса.ВыгрузитьДанныеДляСопоставления",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	ПриНачалеДлительнойОперации(ФоновоеЗадание, ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если Не ПродолжитьОжидание
		И Не ПараметрыОбработчика.Отказ Тогда
		ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ФоновоеЗаданиеВыполнено");
		ПродолжитьОжидание = Истина;
	КонецЕсли;
	
	ПараметрыОбработчика.ДополнительныеПараметры.Вставить("НастройкиВыгрузки", НастройкиВыгрузки);
	
КонецПроцедуры

Процедура ПриОжиданииВыгрузкиДанныхДляСопоставления(ПараметрыОбработчика, ПродолжитьОжидание = Истина) Экспорт
	
	Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ОжиданиеСессииПомещенияДанныхДляСопоставления") Тогда
		
		ПриОжиданииСессииОбменаСообщениямиСистемы(
			ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии, ПродолжитьОжидание);
			
	Иначе
		ЗаданиеВыполнено = Ложь;
		
		Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ФоновоеЗаданиеВыполнено") Тогда
			ЗаданиеВыполнено = Истина;
		Иначе
			ПриОжиданииДлительнойОперации(ПараметрыОбработчика, ПродолжитьОжидание);
			
			ЗаданиеВыполнено = Не ПродолжитьОжидание И Не ПараметрыОбработчика.Отказ;
		КонецЕсли;
		
		Если ЗаданиеВыполнено Тогда
			
			Результат = ПолучитьИзВременногоХранилища(ПараметрыОбработчика.АдресРезультата);
	
			Если Результат.ДанныеВыгружены Тогда
				
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ОжиданиеСессииПомещенияДанныхДляСопоставления");
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ПараметрыОбработчикаСессии");
				
				ПриНачалеПомещенияДанныхДляСопоставления(ПараметрыОбработчика.ДополнительныеПараметры.НастройкиВыгрузки,
					ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии, ПродолжитьОжидание);
			Иначе
					
				ПараметрыОбработчика.Отказ = Истина;
				ПараметрыОбработчика.СообщениеОбОшибке = Результат.СообщениеОбОшибке;
				ПродолжитьОжидание = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииВыгрузкиДанныхДляСопоставления(ПараметрыОбработчика, СтатусЗавершения) Экспорт
	
	ИнициализироватьСтатусЗавершенияДлительнойОперации(СтатусЗавершения);
	
	Если ПараметрыОбработчика.Отказ Тогда
		ЗаполнитьЗначенияСвойств(СтатусЗавершения, ПараметрыОбработчика, "Отказ, СообщениеОбОшибке");
	Иначе
		ПараметрыОбработчикаСессии = ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии;
		
		Результат = Новый Структура;
		Результат.Вставить("ДанныеВыгружены",   Истина);
		Результат.Вставить("СообщениеОбОшибке", "");
		
		Если ПараметрыОбработчикаСессии.Отказ Тогда
			Результат.ДанныеВыгружены   = Ложь;
			Результат.СообщениеОбОшибке = ПараметрыОбработчикаСессии.СообщениеОбОшибке;
		КонецЕсли;
		
		СтатусЗавершения.Результат = Результат;
		
	КонецЕсли;
	
	ПараметрыОбработчика = Неопределено;
	
КонецПроцедуры

Процедура ПриНачалеПомещенияДанныхДляСопоставления(НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание = Истина)
	
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(НастройкиВыгрузки.Корреспондент);
	
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
		ПсевдонимПредопределенногоУзла = ОбменДаннымиСервер.ПсевдонимПредопределенногоУзла(НастройкиВыгрузки.Корреспондент);
	
		Если ЗначениеЗаполнено(ПсевдонимПредопределенногоУзла) Тогда
			// Требуется корректировка кода узла отправителя.
			КодЭтогоПриложения = СокрЛП(ПсевдонимПредопределенногоУзла);
		Иначе
			КодЭтогоПриложения = ОбменДаннымиСервер.ИдентификаторЭтогоУзлаДляОбмена(НастройкиВыгрузки.Корреспондент);
		КонецЕсли;
	Иначе
		КодЭтогоПриложения = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		// Отправляем сообщение корреспонденту.
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеЗагрузитьСообщениеОбмена());
			
		Сообщение.Body.CorrespondentZone = НастройкиВыгрузки.ОбластьДанныхКорреспондента;
		Сообщение.Body.ExchangePlan      = ИмяПланаОбмена;
		Сообщение.Body.CorrespondentCode = КодЭтогоПриложения;
		
		Сообщение.Body.MessageForDataMatching = Истина;
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("Интерфейс", "3.0.1.1");
		ДополнительныеСвойства.Вставить("СообщениеДляСопоставленияДанных", Истина);
		
		Сообщение.AdditionalInfo = СериализаторXDTO.ЗаписатьXDTO(ДополнительныеСвойства);
		
		ПараметрыОбработчика.ИдентификаторОперации = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
			
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = СообщениеОбОшибке;
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
		
		ПродолжитьОжидание = Ложь;
	КонецПопытки;
	
	Если Не ПараметрыОбработчика.Отказ Тогда
		СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаЗагрузкаДанных

Процедура ПриНачалеВыгрузкиДанных(НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание = Истина) Экспорт
	
	КлючФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Обмен данными (%1)';uk='Обмін даними (%1)'"),
		НастройкиВыгрузки.Корреспондент);

	Если ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Обмен данными с ""%1"" уже выполняется.';uk='Обмін даними з ""%1"" вже виконується.'"),
			НастройкиВыгрузки.Корреспондент);
	КонецЕсли;
		
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиВыгрузки", НастройкиВыгрузки);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Обмен данными (%1).';uk='Обмін даними (%1).'"),
		НастройкиВыгрузки.Корреспондент);
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ЗапуститьНеВФоне    = Ложь;
	ПараметрыВыполнения.ЗапуститьВФоне      = Истина;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникИнтерактивногоОбменаДаннымиВМоделиСервиса.ВыгрузитьЗагрузитьДанныеПоТребованию",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	ПриНачалеДлительнойОперации(ФоновоеЗадание, ПараметрыОбработчика, ПродолжитьОжидание);
	
	Если Не ПродолжитьОжидание
		И Не ПараметрыОбработчика.Отказ Тогда
		ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ФоновоеЗаданиеВыполнено");
		ПродолжитьОжидание = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОжиданииВыгрузкиДанных(ПараметрыОбработчика, ПродолжитьОжидание = Истина) Экспорт
	
	Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ОжиданиеСессииВыгрузкиЗагрузкиДанных") Тогда
		
		ПриОжиданииСессииОбменаСообщениямиСистемы(
			ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии, ПродолжитьОжидание);
			
	Иначе
		ЗаданиеВыполнено = Ложь;
		
		Если ПараметрыОбработчика.ДополнительныеПараметры.Свойство("ФоновоеЗаданиеВыполнено") Тогда
			ЗаданиеВыполнено = Истина;
		Иначе
			ПриОжиданииДлительнойОперации(ПараметрыОбработчика, ПродолжитьОжидание);
			
			ЗаданиеВыполнено = Не ПродолжитьОжидание И Не ПараметрыОбработчика.Отказ;
		КонецЕсли;
		
		Если ЗаданиеВыполнено Тогда
			
			Результат = ПолучитьИзВременногоХранилища(ПараметрыОбработчика.АдресРезультата);
			
			Если Результат.Свойство("ПараметрыОбработчикаСессии") Тогда
			
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ОжиданиеСессииВыгрузкиЗагрузкиДанных");
				ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ПараметрыОбработчикаСессии", Результат.ПараметрыОбработчикаСессии);
				
				ПродолжитьОжидание = Истина;
				
			Иначе
				
				ПродолжитьОжидание = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииВыгрузкиДанных(ПараметрыОбработчика, СтатусЗавершения) Экспорт
	
	ИнициализироватьСтатусЗавершенияДлительнойОперации(СтатусЗавершения);
	
	Если ПараметрыОбработчика.Отказ Тогда
		ЗаполнитьЗначенияСвойств(СтатусЗавершения, ПараметрыОбработчика, "Отказ, СообщениеОбОшибке");
	Иначе
		ПараметрыОбработчикаСессии = ПараметрыОбработчика.ДополнительныеПараметры.ПараметрыОбработчикаСессии;
		
		Результат = Новый Структура;
		Результат.Вставить("ДанныеВыгружены",   Истина);
		Результат.Вставить("СообщениеОбОшибке", "");
		
		Если ПараметрыОбработчикаСессии.Отказ Тогда
			Результат.ДанныеВыгружены   = Ложь;
			Результат.СообщениеОбОшибке = ПараметрыОбработчикаСессии.СообщениеОбОшибке;
		КонецЕсли;
		
		СтатусЗавершения.Результат = Результат;
		
	КонецЕсли;
	
	ПараметрыОбработчика = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СессииОбменаСообщениями

Процедура ПриОжиданииСессииОбменаСообщениямиСистемы(ПараметрыОбработчика, ПродолжитьОжидание = Истина) Экспорт
	
	СтатусСессии = "";
	Попытка
		СтатусСессии = СтатусСессии(ПараметрыОбработчика.ИдентификаторОперации);
	Исключение
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииМониторСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
			
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = СообщениеОбОшибке;
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
		
		ПродолжитьОжидание  = Ложь;
		Возврат;
	КонецПопытки;
	
	Если СтатусСессии = "Успешно" Тогда
		
		ПродолжитьОжидание = Ложь;
		
	ИначеЕсли СтатусСессии = "Ошибка" Тогда
		
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.ИдентификаторОперации = Неопределено;
		ПродолжитьОжидание  = Ложь;
		
	Иначе
		
		ПродолжитьОжидание = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СтатусСессии(Знач Сессия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегистрыСведений.СессииОбменаСообщениямиСистемы.СтатусСессии(Сессия);
	
КонецФункции

#КонецОбласти

#Область РаботаСДлительнымиОперациями

// Для внутреннего использования.
//
Процедура ПриНачалеДлительнойОперации(ФоновоеЗадание, ПараметрыОбработчика, ПродолжитьОжидание = Истина)
	
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, ФоновоеЗадание);
	
	Если ФоновоеЗадание.Статус = "Выполняется" Тогда
		ПараметрыОбработчика.АдресРезультата       = ФоновоеЗадание.АдресРезультата;
		ПараметрыОбработчика.ИдентификаторОперации = ФоновоеЗадание.ИдентификаторЗадания;
		ПараметрыОбработчика.ДлительнаяОперация    = Истина;
		
		ПродолжитьОжидание = Истина;
		Возврат;
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		ПараметрыОбработчика.АдресРезультата    = ФоновоеЗадание.АдресРезультата;
		ПараметрыОбработчика.ДлительнаяОперация = Ложь;
		
		ПродолжитьОжидание = Ложь;
		Возврат;
	Иначе
		ПараметрыОбработчика.СообщениеОбОшибке = ФоновоеЗадание.КраткоеПредставлениеОшибки;
		Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
			ПараметрыОбработчика.СообщениеОбОшибке = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ПараметрыОбработчика.Отказ = Истина;
		ПараметрыОбработчика.ДлительнаяОперация = Ложь;
		
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования.
//
Процедура ПриОжиданииДлительнойОперации(ПараметрыОбработчика, ПродолжитьОжидание = Истина)
	
	Если ПараметрыОбработчика.Отказ
		Или Не ПараметрыОбработчика.ДлительнаяОперация Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ЗаданиеВыполнено = Ложь;
	Попытка
		ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыОбработчика.ИдентификаторОперации);
	Исключение
		ПараметрыОбработчика.Отказ             = Истина;
		ПараметрыОбработчика.СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(),
			УровеньЖурналаРегистрации.Ошибка, , , ПараметрыОбработчика.СообщениеОбОшибке);
	КонецПопытки;
		
	Если ПараметрыОбработчика.Отказ Тогда
		ПродолжитьОжидание = Ложь;
		Возврат;
	КонецЕсли;
	
	ПродолжитьОжидание = Не ЗаданиеВыполнено;
	
КонецПроцедуры

Процедура ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчика, ФоновоеЗадание)
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ФоновоеЗадание",          ФоновоеЗадание);
	ПараметрыОбработчика.Вставить("Отказ",                   Ложь);
	ПараметрыОбработчика.Вставить("СообщениеОбОшибке",       "");
	ПараметрыОбработчика.Вставить("ДлительнаяОперация",      Ложь);
	ПараметрыОбработчика.Вставить("ИдентификаторОперации",   Неопределено);
	ПараметрыОбработчика.Вставить("АдресРезультата",         Неопределено);
	ПараметрыОбработчика.Вставить("ДополнительныеПараметры", Новый Структура);
	
КонецПроцедуры

Функция ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Ключ",      КлючФоновогоЗадания);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	АктивныеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат (АктивныеФоновыеЗадания.Количество() > 0);
	
КонецФункции

Процедура ИнициализироватьСтатусЗавершенияДлительнойОперации(СтатусЗавершения)
	
	СтатусЗавершения = Новый Структура;
	СтатусЗавершения.Вставить("Отказ",             Ложь);
	СтатусЗавершения.Вставить("СообщениеОбОшибке", "");
	СтатусЗавершения.Вставить("Результат",         Неопределено);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиФоновыхЗаданий

Процедура ВыгрузитьДанныеДляСопоставления(Параметры, АдресРезультата) Экспорт
	
	НастройкиВыгрузки = Неопределено;
	Параметры.Свойство("НастройкиВыгрузки", НастройкиВыгрузки);
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеВыгружены",   Истина);
	Результат.Вставить("СообщениеОбОшибке", "");
	
	Отказ = Ложь;
	Попытка
		ОбменДаннымиВМоделиСервиса.ВыполнитьВыгрузкуДанных(Отказ, НастройкиВыгрузки.Корреспондент);
	Исключение
		Результат.ДанныеВыгружены = Ложь;
		Результат.СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.СообщениеОбОшибке);
	КонецПопытки;
		
	Результат.ДанныеВыгружены = Результат.ДанныеВыгружены И Не Отказ;
	
	Если Не Результат.ДанныеВыгружены
		И ПустаяСтрока(Результат.СообщениеОбОшибке) Тогда
		Результат.СообщениеОбОшибке = НСтр("ru='При выполнении выгрузки данных для сопоставления возникли ошибки (см. Журнал регистрации).';uk='При виконанні вивантаження даних для зіставлення виникли помилки (див. Журнал реєстрації).'");
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ВыгрузитьЗагрузитьДанныеПоТребованию(Параметры, АдресРезультата) Экспорт
	
	НастройкиВыгрузки = Неопределено;
	Параметры.Свойство("НастройкиВыгрузки", НастройкиВыгрузки);
	
	ПараметрыОбработчикаСессии = Неопределено;
	ИнициализироватьПараметрыОбработчикаДлительнойОперации(ПараметрыОбработчикаСессии, Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Если НастройкиВыгрузки.Свойство("ДополнениеВыгрузки") Тогда
			ЗарегистрироватьДанныеДополненияВыгрузки(НастройкиВыгрузки.ДополнениеВыгрузки);
		КонецЕсли;
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс.СообщениеПротолкнутьСинхронизациюДвухПриложений());
			
		Сообщение.Body.CorrespondentZone = НастройкиВыгрузки.ОбластьДанныхКорреспондента;
		
		ПараметрыОбработчикаСессии.ИдентификаторОперации = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПараметрыОбработчикаСессии.Отказ = Истина;
		ПараметрыОбработчикаСессии.СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , ПараметрыОбработчикаСессии.СообщениеОбОшибке);
	КонецПопытки;
	
	Если Не ПараметрыОбработчикаСессии.Отказ Тогда
		СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыОбработчикаСессии", ПараметрыОбработчикаСессии);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

// Регистрирует дополнительные данные по настройкам
//
// Параметры:
//     ОбработкаВыгрузки - Структура, ОбработкаОбъект.ИнтерактивноеИзменениеВыгрузки - инициализированный объект.
//
Процедура ЗарегистрироватьДанныеДополненияВыгрузки(Знач ОбработкаВыгрузки)
	
	Если ТипЗнч(ОбработкаВыгрузки) = Тип("Структура") Тогда
		Обработка = Обработки.ИнтерактивноеИзменениеВыгрузки.Создать();
		ЗаполнитьЗначенияСвойств(Обработка, ОбработкаВыгрузки, , "ДополнительнаяРегистрация, ДополнительнаяРегистрацияСценарияУзла");
		
		Обработка.КомпоновщикОтбораВсехДокументов.ЗагрузитьНастройки(ОбработкаВыгрузки.КомпоновщикОтбораВсехДокументовНастройки);
		
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(Обработка.ДополнительнаяРегистрация, ОбработкаВыгрузки.ДополнительнаяРегистрация);
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(Обработка.ДополнительнаяРегистрацияСценарияУзла, ОбработкаВыгрузки.ДополнительнаяРегистрацияСценарияУзла);
	Иначе
		Обработка = ОбработкаВыгрузки;
	КонецЕсли;
	
	Если Обработка.ВариантВыгрузки <= 0 Тогда
		// Не добавлять
		Возврат;
		
	ИначеЕсли Обработка.ВариантВыгрузки = 1 Тогда
		// За период с отбором, очищаем дополнительную
		Обработка.ДополнительнаяРегистрация.Очистить();
		
	ИначеЕсли Обработка.ВариантВыгрузки = 2 Тогда
		// Детально настроено, очищаем общее
		Обработка.КомпоновщикОтбораВсехДокументов = Неопределено;
		Обработка.ПериодОтбораВсехДокументов      = Неопределено;
		
	КонецЕсли;
	
	Обработка.ЗарегистрироватьДополнительныеИзменения();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли