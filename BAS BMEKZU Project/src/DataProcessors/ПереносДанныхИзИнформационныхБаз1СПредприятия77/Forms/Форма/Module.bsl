
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Процедура ПолучитьФайлыКонверации(ПрефиксМакета, Параметры)
	
	ИмяВременногоФайлаПравил  = КаталогВременныхФайлов() + ПрефиксМакета + "_ACC8.xml";
	ДвоичныеДанныеФайлаПравил = Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПолучитьМакет(ПрефиксМакета + "_xml");
	ДвоичныеДанныеФайлаПравил.Записать(ИмяВременногоФайлаПравил);
	
	ИмяВременногоФайлаОбработки  = КаталогВременныхФайлов() + ПрефиксМакета + "_ACC8.ert";
	ДвоичныеДанныеФайлаОбработки = Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПолучитьМакет(ПрефиксМакета + "_ert");
	ДвоичныеДанныеФайлаОбработки.Записать(ИмяВременногоФайлаОбработки);
	
	Параметры.АдресФайлаПравил    = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаПравил, Новый УникальныйИдентификатор);
	Параметры.АдресФайлаОбработки = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаОбработки, Новый УникальныйИдентификатор);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлы(ПрефиксМакета)
	
	ДополнительныеПараметры = Новый Структура("ПрефиксМакета", ПрефиксМакета);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	АдресаФайлов = Новый Структура("АдресФайлаПравил, АдресФайлаОбработки");
	ПрефиксМакета = ДополнительныеПараметры.ПрефиксМакета;
	ПолучитьФайлыКонверации(ПрефиксМакета, АдресаФайлов);
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		
		ДиалогВыбораФайла				= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораФайла.Заголовок		= "Укажите каталог для записи файлов конвертации";
		
		ДополнительныеПараметры.Вставить("АдресаФайлов", АдресаФайлов);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловВыборКаталогаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДиалогВыбораФайла.Показать(ОписаниеОповещения);
		
	Иначе
		
		Попытка
			
			ПолучитьФайл(АдресаФайлов.АдресФайлаПравил, ПрефиксМакета + "_ACC8.xml", Истина);
			Состояние(НСтр("ru='Файл правил выгрузки успешно сохранен';uk='Файл правил вивантаження успішно збережений'"), , АдресаФайлов.АдресФайлаПравил);
						
			ПолучитьФайл(АдресаФайлов.АдресФайлаОбработки, ПрефиксМакета + "_ACC8.ert", Истина);
			Состояние(НСтр("ru='Файл обработки выгрузки успешно сохранен';uk='Файл обробки вивантаження успішно збережений'"), , АдресаФайлов.АдресФайлаОбработки);
			
			УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаПравил);
			УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаОбработки);
			
		Исключение
			ШаблонСообщения = НСтр("ru='При записи файла возникла ошибка
|%1';uk='При записі файлу відбулася помилка
|%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ОписаниеОшибки = ИнформацияОбОшибке();
			
			ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловВыборКаталогаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Каталог       = ВыбранныеФайлы.Получить(0);
		ПрефиксМакета = ДополнительныеПараметры.ПрефиксМакета;
		АдресаФайлов  = ДополнительныеПараметры.АдресаФайлов;
		
		ПередаваемыеФайлы = Новый Массив;
		ПереданныеФайлы   = Новый Массив;
		МассивВызовов     = Новый Массив;
		
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Каталог + "\" + ПрефиксМакета + "_ACC8.xml", АдресаФайлов.АдресФайлаПравил);			
		ПередаваемыеФайлы.Добавить(ОписаниеФайла);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Каталог + "\" + ПрефиксМакета + "_ACC8.ert", АдресаФайлов.АдресФайлаОбработки);			
		ПередаваемыеФайлы.Добавить(ОписаниеФайла);
		
		МассивВызовов.Добавить(Новый Массив);
		
		МассивВызовов[0].Добавить("ПолучитьФайлы");
		МассивВызовов[0].Добавить(ПередаваемыеФайлы);
		МассивВызовов[0].Добавить(ПереданныеФайлы);
		МассивВызовов[0].Добавить("");
		МассивВызовов[0].Добавить(Ложь);
		
		ДополнительныеПараметры.Вставить("ПередаваемыеФайлы", ПередаваемыеФайлы);
		ДополнительныеПараметры.Вставить("Каталог", Каталог);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловЗапросРазрешенийЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьЗапросРазрешенияПользователя(ОписаниеОповещения, МассивВызовов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловЗапросРазрешенийЗавершение(РазрешенияПолучены, ДополнительныеПараметры) Экспорт
	
	Если РазрешенияПолучены Тогда
		
		ПередаваемыеФайлы = ДополнительныеПараметры.ПередаваемыеФайлы;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПолучениеФайлов(ОписаниеОповещения, ПередаваемыеФайлы, ДополнительныеПараметры.Каталог, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеФайловЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	ПрефиксМакета = ДополнительныеПараметры.ПрефиксМакета;
	Каталог       = ДополнительныеПараметры.Каталог;
	АдресаФайлов  = ДополнительныеПараметры.АдресаФайлов;
	
	ШаблонСообщения = НСтр("ru='Обработка выгрузки %1 и правила конвертации %2 записаны в каталог: %3';uk='Обробка вивантаження %1 і правила конвертації %2 записані в каталог: %3'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
	                 ПрефиксМакета + "_ACC8.ert", ПрефиксМакета + "_ACC8.xml", Каталог);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаПравил);
	УдалитьИзВременногоХранилища(АдресаФайлов.АдресФайлаОбработки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки)

	ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзИБНажатие()
	
	ОткрытьФорму("Обработка.ПереносДанныхИзИнформационныхБаз1СПредприятия77.Форма.ФормаЗагрузкаИзИБ");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаНажатие()
	
	ОткрытьФорму("Обработка.ПереносДанныхИзИнформационныхБаз1СПредприятия77.Форма.ФормаЗагрузкаИзФайла");
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ГиперссылкаЗагрузкаИБНажатие(Элемент)
	
	ЗагрузитьИзИБНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаЗагрузкаИБНажатие(Элемент)
	
	ЗагрузитьИзИБНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЗагрузкаФайлНажатие(Элемент)
		
    ЗагрузитьИзФайлаНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаЗагрузкаФайлНажатие(Элемент)
		
    ЗагрузитьИзФайлаНажатие();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлыБухгалтерия77(Команда)
	
	ЗаписатьФайлы("ACC");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	
	Если ЗначениеЗаполнено(СистемнаяИнфо.ИнформацияПрограммыПросмотра)
		ИЛИ НЕ ПараметрыСоединения.Свойство("File") Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
