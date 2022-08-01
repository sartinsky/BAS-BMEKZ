
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ВызватьИсключение НСтр("ru='Резервное копирование и восстановление данных необходимо настроить средствами операционной системы или другими сторонними средствами.';uk='Резервне копіювання і відновлення даних необхідно налаштувати засобами операційної системи або іншими сторонніми засобами.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ВызватьИсключение НСтр("ru='Резервное копирование недоступно в веб-клиенте.';uk='Резервне копіювання недоступно у веб-клиєнті.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru='В клиент-серверном варианте работы резервное копирование следует выполнять сторонними средствами (средствами СУБД).';uk='У клієнт-серверному варіанті роботи резервне копіювання варто виконувати сторонніми засобами (засобами СУБД).'");
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	ПарольАдминистратораИБ = НастройкиРезервногоКопирования.ПарольАдминистратораИБ;
	Объект.КаталогСРезервнымиКопиями = НастройкиРезервногоКопирования.КаталогХраненияРезервныхКопий;
	
	Если КоличествоСеансовИнформационнойБазы() > 1 Тогда
		
		Элементы.СтраницыСтатусаВосстановления.ТекущаяСтраница = Элементы.СтраницаАктивныеПользователи;
		
	КонецЕсли;
	
	ИнформацияОПользователе = РезервноеКопированиеИБСервер.ИнформацияОПользователе();
	ТребуетсяВводПароля = ИнформацияОПользователе.ТребуетсяВводПароля;
	Если ТребуетсяВводПароля Тогда
		АдминистраторИБ = ИнформацияОПользователе.Имя;
	Иначе
		Элементы.ГруппаАвторизации.Видимость = Ложь;
		ПарольАдминистратораИБ = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Элементы.ГруппаComcntrФайловыйРежим.Видимость = Ложь;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекущаяСтраница = Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница;
	Если ТекущаяСтраница <> Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		Возврат;
	КонецЕсли;
		
	ТекстПредупреждения = НСтр("ru='Прервать подготовку к восстановлению данных?';uk='Перервати підготовку до оновлення даних?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(ЭтотОбъект,
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("ИстечениеВремениОжидания");
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗавершениеРаботыПользователей" И Параметр.КоличествоСеансов <= 1
		И Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = Элементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
			НачатьРезервноеКопирование();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьФайлРезервнойКопии();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейНажатие(Элемент)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей(, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОбновитьВерсиюКомпонентыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФормаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	Страницы = Элементы.СтраницыЗагрузкиДанных;
	
	РезультатПодключения = РезервноеКопированиеИБКлиент.ПроверитьДоступКИнформационнойБазе(ПарольАдминистратораИБ);
	Если РезультатПодключения.ОшибкаПодключенияКомпоненты Тогда
		Элементы.СтраницыСтатусаВосстановления.ТекущаяСтраница = Элементы.СтраницаОшибкаПодключения;
		ОбнаруженнаяОшибкаПодключения = РезультатПодключения.КраткоеОписаниеОшибки;
		Возврат;
	Иначе
		УстановитьПараметрыРезервногоКопирования();
	КонецЕсли;

	Страницы.ТекущаяСтраница = Элементы.СтраницаИнформацииИВыполненияРезервногоКопирования; 
	Элементы.Закрыть.Доступность = Истина;
	Элементы.Готово.Доступность = Ложь;
	
	КоличествоСеансовИнформационнойБазы = КоличествоСеансовИнформационнойБазы();
	Элементы.КоличествоАктивныхПользователей.Заголовок = КоличествоСеансовИнформационнойБазы;
	
	УстановитьБлокировкуСоединений = Истина;
	СоединенияИБВызовСервера.УстановитьБлокировкуСоединений(НСтр("ru='Выполняется восстановление информационной базы.';uk='Виконується відновлення інформаційної бази.'"), "РезервноеКопирование");
	
	Если КоличествоСеансовИнформационнойБазы = 1 Тогда
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(УстановитьБлокировкуСоединений);
		СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса(Ложь);
		НачатьРезервноеКопирование();
	Иначе
		СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(УстановитьБлокировкуСоединений);
		УстановитьОбработчикОжиданияНачалаРезервногоКопирования();
		УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", , ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подключает обработчик ожидания истечения таймаута перед принудительным стартом резервного копирования/восстановления
// данных.
&НаКлиенте
Процедура УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ИстечениеВремениОжидания", 300, Истина);
	
КонецПроцедуры

// Подключает обработчик ожидания при отложенном резервном копировании.
&НаКлиенте
Процедура УстановитьОбработчикОжиданияНачалаРезервногоКопирования() 
	
	ПодключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения", 60);
	
КонецПроцедуры

// Функция запрашивает у пользователя и возвращает путь к файлу или каталогу.
&НаКлиенте
Процедура ВыбратьФайлРезервнойКопии()
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Фильтр = НСтр("ru='Резервная копия базы (*.zip, *.1CD)|*.zip;*.1cd';uk='Резервна копія бази (*.zip, *.1CD)|*.zip;*.1cd'");
	ДиалогОткрытияФайла.Заголовок= НСтр("ru='Выберите файл резервной копии';uk='Виберіть файл резервної копії'");
	ДиалогОткрытияФайла.ПроверятьСуществованиеФайла = Истина;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		Объект.ФайлЗагрузкиРезервнойКопии = ДиалогОткрытияФайла.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
#Если ВебКлиент Тогда
	ТекстСообщения = НСтр("ru='Восстановление не доступно в веб-клиенте.';uk='Відновлення не доступно у веб-клієнті.'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Возврат Ложь;
#КонецЕсли
	
	РеквизитыЗаполнены = Истина;
	
	Если ТребуетсяВводПароля И ПустаяСтрока(ПарольАдминистратораИБ) Тогда
		ТекстСообщения = НСтр("ru='Не задан пароль администратора.';uk='Не заданий пароль адміністратора.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПарольАдминистратораИБ");
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;
	
	Объект.ФайлЗагрузкиРезервнойКопии = СокрЛП(Объект.ФайлЗагрузкиРезервнойКопии);
	ИмяФайла = СокрЛП(Объект.ФайлЗагрузкиРезервнойКопии);
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		ТекстСообщения = НСтр("ru='Не выбран файл с резервной копией.';uk='Не обраний файл із резервною копією.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат Ложь;
	КонецЕсли;
	
	ФайлАрхива = Новый Файл(ИмяФайла);
	Если ВРег(ФайлАрхива.Расширение) <> ".ZIP" Или ВРег(ФайлАрхива.Расширение) <> ".1CD"  Тогда
		
		ТекстСообщения = НСтр("ru='Выбранный файл не является архивом с резервной копией.';uk='Обраний файл не є архівом з резервною копією.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат РеквизитыЗаполнены;
		
	КонецЕсли;
	
	Если ВРег(ФайлАрхива.Расширение) = ".1CD" Тогда
		
		Если ВРег(ФайлАрхива.ИмяБезРасширения) <> "1CV8" Тогда
		
			ТекстСообщения = НСтр("ru='Выбранный файл не является резервной копией (неправильное имя файла информационной базы).';uk='Обраний файл не є резервною копією (неправильне ім''я файлу інформаційної бази).'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
			Возврат Ложь;
		КонецЕсли;
		
		Возврат РеквизитыЗаполнены;
	КонецЕсли;
	
	ZipФайл = Новый ЧтениеZipФайла(ИмяФайла);
	Если ZipФайл.Элементы.Количество() <> 1 Тогда
		
		ТекстСообщения = НСтр("ru='Выбранный файл не является архивом с резервной копией (содержит более одного файла).';uk='Обраний файл не є архівом з резервною копією (містить більше одного файлу).'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат Ложь;
		
	КонецЕсли;
	
	ФайлВАрхиве = ZipФайл.Элементы[0];
	
	Если ВРег(ФайлВАрхиве.Расширение) <> "1CD" Тогда
		
		ТекстСообщения = НСтр("ru='Выбранный файл не является архивом с резервной копией (не содержит файл информационной базы).';uk='Обраний файл не є архівом з резервною копією (не містить файл інформаційної бази).'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ВРег(ФайлВАрхиве.ИмяБезРасширения) <> "1CV8" Тогда
		
		ТекстСообщения = НСтр("ru='Выбранный файл не является архивом с резервной копией (неправильное имя файла информационной базы).';uk='Обраний файл не є архівом з резервною копією (неправильне ім''я файлу інформаційної бази).'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат РеквизитыЗаполнены;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры обработчиков ожидания.

&НаКлиенте
Процедура ИстечениеВремениОжидания()
	
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ОтменитьПодготовку();
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодготовку()
	
	Элементы.НадписьНеУдалось.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1.
        |Подготовка к восстановлению данных из резервной копии отменена. Информационная база разблокирована.'
        |;uk='%1.
        |Підготовка до відновлення даних з резервної копії скасована. Інформаційна база розблокована.'"),
		СоединенияИБ.СообщениеОНеотключенныхСеансах());
	Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
	Элементы.Готово.Видимость = Ложь;
	Элементы.Закрыть.Заголовок = НСтр("ru='Закрыть';uk='Закрити'");
	Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	
	СоединенияИБ.РазрешитьРаботуПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаНаЕдинственностьПодключения()
	
	Если КоличествоСеансовИнформационнойБазы() = 1 Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРезервноеКопирование() 
	
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления();
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(), 
		"Информация",
		НСтр("ru='Выполняется восстановление данных информационной базы:';uk='Виконується оновлення даних інформаційної бази:'") + " " + ИмяГлавногоФайлаСкрипта);
	
	ЗакрытьФормуБезусловно = Истина;
	Закрыть();
	
	ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
	
	ПутьКПрограммеЗапуска = СтандартныеПодсистемыКлиент.ПапкаСистемныхПриложений() + "mshta.exe";
	
	СтрокаЗапуска = """%1"" ""%2"" [p1]%3[/p1]";
	СтрокаЗапуска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗапуска,
		ПутьКПрограммеЗапуска, ИмяГлавногоФайлаСкрипта, РезервноеКопированиеИБКлиент.СтрокаUnicode(ПарольАдминистратораИБ));
		
	ОбщегоНазначенияКлиентСервер.ЗапуститьПрограмму(СтрокаЗапуска);
	
	ЗавершитьРаботуСистемы(Ложь);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подготовки восстановления данных.

&НаКлиенте
Функция СформироватьФайлыСкриптаОбновления() 
	
	ПараметрыКопирования = РезервноеКопированиеИБКлиент.КлиентскиеПараметрыРезервногоКопирования();
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	СоздатьКаталог(ПараметрыКопирования.КаталогВременныхФайловОбновления);
	
	// Структура параметров необходима для их определения на клиенте и передачи на сервер.
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяФайлаПрограммы"			, ПараметрыКопирования.ИмяФайлаПрограммы);
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации"	, ПараметрыКопирования.СобытиеЖурналаРегистрации);
	СтруктураПараметров.Вставить("ИмяCOMСоединителя"			, ПараметрыРаботыКлиента.ИмяCOMСоединителя);
	СтруктураПараметров.Вставить("ЭтоБазоваяВерсияКонфигурации"	, ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации);
	СтруктураПараметров.Вставить("ИнформационнаяБазаФайловая"	, ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая);
	СтруктураПараметров.Вставить("ПараметрыСкрипта"				, РезервноеКопированиеИБКлиент.ПараметрыАутентификацииАдминистратораОбновления(ПарольАдминистратораИБ));
	
	ИменаМакетов = "ДопФайлРезервногоКопирования";
	ИменаМакетов = ИменаМакетов + ",ЗаставкаВосстановления";
	
	ТекстыМакетов = ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[0]);
	
	ИмяФайлаСкрипта = ПараметрыКопирования.КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, РезервноеКопированиеИБКлиент.КодировкаФайловПрограммыРезервногоКопированияИБ());
	
	// Вспомогательный файл: helpers.js.
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[1]);
	ФайлСкрипта.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "helpers.js", РезервноеКопированиеИБКлиент.КодировкаФайловПрограммыРезервногоКопированияИБ());
	
	ИмяГлавногоФайлаСкрипта = Неопределено;
	// Вспомогательный файл: splash.png.
	БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.png");
	// Вспомогательный файл: splash.ico.
	БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.ico");
	// Вспомогательный файл: progress.gif.
	БиблиотекаКартинок.ДлительнаяОперация48.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "progress.gif");
	// Главный файл заставки: splash.hta.
	ИмяГлавногоФайлаСкрипта = ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.hta";
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[2]);
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, РезервноеКопированиеИБКлиент.КодировкаФайловПрограммыРезервногоКопированияИБ());
	
	ФайлЛога = Новый ТекстовыйДокумент;
	ФайлЛога.Вывод = ИспользованиеВывода.Разрешить;
	ФайлЛога.УстановитьТекст(СтандартныеПодсистемыКлиент.ИнформацияДляПоддержки());
	ФайлЛога.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "templog.txt", КодировкаТекста.Системная);
	
	Возврат ИмяГлавногоФайлаСкрипта;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации)
	
	// Запись накопленных событий ЖР.
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Результат = Новый Массив();
	Результат.Добавить(ПолучитьТекстСкрипта(СтруктураПараметров));
	
	ИменаМакетовМассив = СтрРазделить(ИменаМакетов, ",");
	Для каждого ИмяМакета Из ИменаМакетовМассив Цикл
		Результат.Добавить(Обработки.РезервноеКопированиеИБ.ПолучитьМакет(ИмяМакета).ПолучитьТекст());
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстСкрипта(СтруктураПараметров)
	
	// Файл обновления конфигурации: main.js.
	ШаблонСкрипта = Обработки.РезервноеКопированиеИБ.ПолучитьМакет("МакетФайлаЗагрузкаИБ");
	
	Скрипт = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	Скрипт.УдалитьСтроку(1);
	Скрипт.УдалитьСтроку(Скрипт.КоличествоСтрок());
	
	Текст = ШаблонСкрипта.ПолучитьОбласть("ОбластьРезервногоКопирования");
	Текст.УдалитьСтроку(1);
	Текст.УдалитьСтроку(Текст.КоличествоСтрок());
	
	Возврат ВставитьПараметрыСкрипта(Скрипт.ПолучитьТекст(), СтруктураПараметров) + Текст.ПолучитьТекст();
	
КонецФункции

&НаСервере
Функция ВставитьПараметрыСкрипта(Знач Текст, Знач СтруктураПараметров)
	
	Результат = Текст;
	
	ПараметрыСкрипта = СтруктураПараметров.ПараметрыСкрипта;
	СтрокаСоединенияИнформационнойБазы = ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы + ПараметрыСкрипта.СтрокаПодключения;
	
	Если СтрЗаканчиваетсяНа(СтрокаСоединенияИнформационнойБазы, ";") Тогда
		СтрокаСоединенияИнформационнойБазы = Лев(СтрокаСоединенияИнформационнойБазы, СтрДлина(СтрокаСоединенияИнформационнойБазы) - 1);
	КонецЕсли;
	
	ИмяИсполняемогоФайлаПрограммы = КаталогПрограммы() + СтруктураПараметров.ИмяФайлаПрограммы;
	
	// Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе; 
	СтрокаПутиКИнформационнойБазе	= ?(ПризнакФайловогоРежима, ПутьКИнформационнойБазе, "");
	СтрокаКаталога = ПроверитьКаталогНаУказаниеКорневогоЭлемента(Объект.КаталогСРезервнымиКопиями);
	
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаПрограммы]"     , ПодготовитьТекст(ИмяИсполняемогоФайлаПрограммы));
	Результат = СтрЗаменить(Результат, "[ПараметрПутиКИнформационнойБазе]"   , ПодготовитьТекст(ПараметрПутиКИнформационнойБазе));
	Результат = СтрЗаменить(Результат, "[СтрокаПутиКФайлуИнформационнойБазы]", ПодготовитьТекст(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", ""))));
	Результат = СтрЗаменить(Результат, "[СтрокаСоединенияИнформационнойБазы]", ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы));
	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораОбновления]"       , ПодготовитьТекст(ИмяПользователя()));
	Результат = СтрЗаменить(Результат, "[СобытиеЖурналаРегистрации]"         , ПодготовитьТекст(СтруктураПараметров.СобытиеЖурналаРегистрации));
	Результат = СтрЗаменить(Результат, "[ФайлРезервнойКопии]"                , ПодготовитьТекст(Объект.ФайлЗагрузкиРезервнойКопии));
	Результат = СтрЗаменить(Результат, "[ИмяCOMСоединителя]"                 , ПодготовитьТекст(СтруктураПараметров.ИмяCOMСоединителя));
	Результат = СтрЗаменить(Результат, "[ИспользоватьCOMСоединитель]"        , ?(СтруктураПараметров.ЭтоБазоваяВерсияКонфигурации, "false", "true"));
	// Используется КаталогВременныхФайлов, т.к. автоматическое удаление временного каталога не допустимо.
	Результат = СтрЗаменить(Результат, "[КаталогВременныхФайлов]"            , ПодготовитьТекст(КаталогВременныхФайлов()));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПроверитьКаталогНаУказаниеКорневогоЭлемента(СтрокаКаталога)
	
	Если СтрЗаканчиваетсяНа(СтрокаКаталога, ":\") Тогда
		Возврат Лев(СтрокаКаталога, СтрДлина(СтрокаКаталога) - 1) ;
	Иначе
		Возврат СтрокаКаталога;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПодготовитьТекст(Знач Текст)
	
	Строка = СтрЗаменить(Текст, "\", "\\");
	Строка = СтрЗаменить(Строка, "'", "\'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("'%1'", Строка);
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыРезервногоКопирования()
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	ПараметрыРезервногоКопирования.Вставить("АдминистраторИБ", АдминистраторИБ);
	ПараметрыРезервногоКопирования.Вставить("ПарольАдминистратораИБ", ?(ТребуетсяВводПароля, ПарольАдминистратораИБ, ""));
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

&НаСервере
Функция КоличествоСеансовИнформационнойБазы()
	
	Возврат СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь, Ложь);
	
КонецФункции

#КонецОбласти
