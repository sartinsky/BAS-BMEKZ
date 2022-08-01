////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Процедуры и функции данного модуля содержат служебные события, на которые может подписаться
// прикладной разработчик для расширенной возможности выгрузки и загрузки данных.
//

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает версию интерфейса обработчиков выгрузки / загрузки данных 1.0.0.0.
//
Функция ВерсияОбработчиков1_0_0_0() Экспорт
	
	Возврат "1.0.0.0";
	
КонецФункции

// Возвращает версию интерфейса обработчиков выгрузки / загрузки данных 1.0.0.1.
//
Функция ВерсияОбработчиков1_0_0_1() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация событий при выгрузке данных

// Формирует массив метаданных, требующих аннотацию ссылок при выгрузке.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыТребующиеАннотациюСсылокПриВыгрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Интегрированные обработчики
	ВыгрузкаЗагрузкаНеразделенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаСовместноРазделенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаПредопределенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаУзловПлановОбменов.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		МодульПользователиСлужебныйВМоделиСервисаБТС = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПользователиСлужебныйВМоделиСервисаБТС");
		МодульПользователиСлужебныйВМоделиСервисаБТС.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	КонецЕсли;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, поддерживающих сопоставление ссылок при загрузке.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий БСП
	ТехнологияСервисаИнтеграцияСБСП.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, не требующих сопоставление ссылок при загрузке.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий БСП
	ТехнологияСервисаИнтеграцияСБСП.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, исключаемых из загрузки/выгрузки.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки() Экспорт
	
	Типы = Новый Массив();
	
	РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		МодульИнформационныйЦентрСлужебный = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ИнформационныйЦентрСлужебный");
		МодульИнформационныйЦентрСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ДополнительныеОтчетыИОбработкиВМоделиСервиса");
		МодульДополнительныеОтчетыИОбработкиВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		МодульОбменДаннымиВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ОбменДаннымиВМоделиСервиса");
		МодульОбменДаннымиВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.РасширенияВМоделиСервиса") Тогда
		МодульРасширенияВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РасширенияВМоделиСервиса");
		МодульРасширенияВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ФайловыеФункцииВМоделиСервиса") Тогда
		МодульФайловыеФункцииСлужебныйВМоделиСервисаБТС = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ФайловыеФункцииСлужебныйВМоделиСервисаБТС");
		МодульФайловыеФункцииСлужебныйВМоделиСервисаБТС.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПодсистемыЦККВМоделиСервиса") Тогда
		МодульИнцидентыЦККСлужебный = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ИнцидентыЦККСлужебный");
		МодульИнцидентыЦККСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.УправлениеТарифамиВМоделиСервиса") Тогда
		МодульТарификацияСлужебный = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ТарификацияСлужебный");
		МодульТарификацияСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ПроверкаИКорректировкаДанных") Тогда
		МодульПроверкаИКорректировкаДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПроверкаИКорректировкаДанных");
		МодульПроверкаИКорректировкаДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		МодульМиграцияПриложений = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("МиграцияПриложений");
		МодульМиграцияПриложений.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданийВнешнийИнтерфейс") Тогда
		МодульОчередьЗаданийВнешнийИнтерфейс = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ОчередьЗаданийВнешнийИнтерфейс");
		МодульОчередьЗаданийВнешнийИнтерфейс.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ПоставляемыеДанныеОбластейДанных") Тогда
		МодульПоставляемыеДанныеОбластейДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПоставляемыеДанныеОбластейДанных");
		МодульПоставляемыеДанныеОбластейДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
    
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ИнтеграцияОбъектовОбластейДанных") Тогда
		МодульИнтеграцияОбъектовОбластейДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ИнтеграцияОбъектовОбластейДанных");
		МодульИнтеграцияОбъектовОбластейДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
    
	// Обработчики событий БСП
	ТехнологияСервисаИнтеграцияСБСП.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация событий при загрузке данных


// Возвращает зависимости типов при замене ссылок.
//
// Возвращаемое значение:
//	Соответствие:
//		Ключ - Строка - имя метаданных, которые зависят от других метаданных.
//		Значение - Массив - массив имен метаданных от которых зависит объект метаданных, хранящееся в ключе.
//
Функция ПолучитьЗависимостиТиповПриЗаменеСсылок() Экспорт
	
	// Интегрированные обработчики
	Возврат ВыгрузкаЗагрузкаНеразделенныхДанных.ЗависимостиТиповПриЗаменеСсылок();
	
КонецФункции

// Выполняет ряд действий после загрузки данных
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//  Сериализация - ОбъектXDTO {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}InfoBaseUser,
//    сериализация пользователя информационной базы,
//  ПользовательИБ - ПользовательИнформационнойБазы, десериализованный из выгрузки,
//  Отказ - Булево, при установке значения данного параметры внутри этой процедуры в
//    значение Ложь загрузка пользователя информационной базы будет пропущена.
//
Процедура ВыполнитьДействияПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		МодульПользователиСлужебныйВМоделиСервисаБТС = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПользователиСлужебныйВМоделиСервисаБТС");
		МодульПользователиСлужебныйВМоделиСервисаБТС.ПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ);
	КонецЕсли;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ);
	
КонецПроцедуры

// Выполняет ряд действий после загрузки пользователя информационной базы.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//  Сериализация - ОбъектXDTO {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}InfoBaseUser,
//    сериализация пользователя информационной базы,
//  ПользовательИБ - ПользовательИнформационнойБазы, десериализованный из выгрузки.
//
Процедура ВыполнитьДействияПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		МодульПользователиСлужебныйВМоделиСервисаБТС = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПользователиСлужебныйВМоделиСервисаБТС");
		МодульПользователиСлужебныйВМоделиСервисаБТС.ПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ);
	КонецЕсли;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ);
	
КонецПроцедуры

// Выполняет ряд действий после загрузки пользователей информационной базы.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыполнитьДействияПослеЗагрузкиПользователейИнформационнойБазы(Контейнер) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		МодульПользователиСлужебныйВМоделиСервисаБТС = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПользователиСлужебныйВМоделиСервисаБТС");
		МодульПользователиСлужебныйВМоделиСервисаБТС.ПослеЗагрузкиПользователейИнформационнойБазы(Контейнер);
	КонецЕсли;
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиПользователейИнформационнойБазы(Контейнер);
	
КонецПроцедуры

#КонецОбласти