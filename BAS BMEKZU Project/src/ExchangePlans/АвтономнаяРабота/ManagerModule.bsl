#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных     = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Ложь;
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену    = НСтр("ru='Предназначен для обеспечения работы с приложением в автономном режиме.';uk='Призначений для забезпечення роботи з програмою в автономному режимі.'");
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru='Настройки обмена автономного рабочего места';uk='Настройки обміну автономного робочого місця'");
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = "ИспользоватьОтборПоОрганизациям, Организации";
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
	// Отборы
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	ОписаниеВарианта.Отборы.Вставить("ИспользоватьОтборПоОрганизациям", Ложь);
	ОписаниеВарианта.Отборы.Вставить("Организации", СтруктураТабличнойЧастиОрганизации);
	
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя.
// Прикладной разработчик на основе установленных отборов на узле должен сформировать 
// строку описания ограничений удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена.
//  ВерсияКорреспондента   - Строка    - версия корреспондента.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//
// Возвращаемое значение:
//  Строка - описание ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Описание = ?(НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям,
		НСтр("ru='В автономном рабочем месте доступна только часть данных.';uk='В автономному робочому місці доступна лише частина даних.'"),
		НСтр("ru='В автономном рабочем месте доступны все данные.';uk='В автономному робочому місці доступні всі дані.'"));
	
	Возврат Описание;
	
КонецФункции

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли