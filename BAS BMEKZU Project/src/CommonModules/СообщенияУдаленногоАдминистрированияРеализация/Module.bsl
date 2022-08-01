////////////////////////////////////////////////////////////////////////////////
// ОБЩАЯ РЕАЛИЗАЦИЯ ОБРАБОТКИ СООБЩЕНИЙ УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}UpdateUser.
//
// Параметры:
//  Имя - строка, имя пользователя,
//  ПолноеИмя - строка, полное имя пользователя,
//  ХэшПароля - строка, сохраняемое значение пароля,
//  ИдентификаторПользователяПриложения - УникальныйИдентификатор,
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор,
//  НомерТелефона - строка, номер телефона пользователя,
//  АдресЭлектроннойПочты - строка, адрес электронной почты пользователя,
//  КодЯзыка - строка, код языка пользователя.
//
Процедура ОбновитьПользователя(Знач ДанныеПользователя) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЯзыкПользователя = РаботаВМоделиСервисаБТС.ЯзыкПоКоду(ДанныеПользователя.Language);
	
	Почта = ДанныеПользователя.EMail;
	
	Телефон = ДанныеПользователя.Phone;
	
	СтруктураАдресаЭП = РаботаВМоделиСервисаБТС.СоставПочтовогоАдреса(Почта);
	
	НачатьТранзакцию();
	Попытка
		Если ЗначениеЗаполнено(ДанныеПользователя.UserApplicationID) Тогда
			
			ПользовательОбластиДанных = Справочники.Пользователи.ПолучитьСсылку(ДанныеПользователя.UserApplicationID);
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ПользовательОбластиДанных);
			Блокировка.Заблокировать();
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	Пользователи.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Пользователи КАК Пользователи
			|ГДЕ
			|	Пользователи.ИдентификаторПользователяСервиса = &ИдентификаторПользователяСервиса";
			Запрос.УстановитьПараметр("ИдентификаторПользователяСервиса", ДанныеПользователя.UserServiceID);
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
			Блокировка.Заблокировать();
			
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда
				ПользовательОбластиДанных = Неопределено;
			Иначе
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				ПользовательОбластиДанных = Выборка.Ссылка;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПользовательОбластиДанных) Тогда
			ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
			ПользовательОбъект.ИдентификаторПользователяСервиса = ДанныеПользователя.UserServiceID;
		Иначе
			ПользовательОбъект = ПользовательОбластиДанных.ПолучитьОбъект();
		КонецЕсли;
		
		ПользовательОбъект.Наименование = ДанныеПользователя.FullName;
		
		РаботаВМоделиСервисаБТС.ОбновитьАдресЭлектроннойПочты(ПользовательОбъект, Почта, СтруктураАдресаЭП);
		
		РаботаВМоделиСервисаБТС.ОбновитьТелефон(ПользовательОбъект, Телефон);
		
		ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
		
		ОписаниеПользователяИБ.Имя = ДанныеПользователя.Name;
		
		ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
		ОписаниеПользователяИБ.АутентификацияOpenID = Истина;
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
		ОписаниеПользователяИБ.СохраняемоеЗначениеПароля = ДанныеПользователя.StoredPasswordValue;
		
		ОписаниеПользователяИБ.Язык = ЯзыкПользователя;
		
		// Эти свойства поддерживаются с версии 1.0.3.7.
		СвойстваОС = Новый Структура("OSAuthentication, OSUser");
		ЗаполнитьЗначенияСвойств(СвойстваОС, ДанныеПользователя);
		ОписаниеПользователяИБ.АутентификацияОС = СвойстваОС.OSAuthentication;
		ОписаниеПользователяИБ.ПользовательОС   = СвойстваОС.OSUser;
		
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОбработкаСообщенияКаналаУдаленногоАдминистрирования");
		ПользовательОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}PrepareApplication.
//
// Параметры:
//  КодОбластиДанных - число(7,0),
//  ИзВыгрузки - булево, признак создания области данных из файла с выгрузкой данных из локального режима
//               (data_dump.zip),
//  Вариант - строка, вариант файла начальных данных для области данных,
//  ИдентификаторВыгрузки - УникальныйИдентификатор, идентификатор файла выгрузки в хранилище менеджера сервиса.
//
Процедура ПодготовитьОбластьДанных(Знач КодОбластиДанных, Знач ИзВыгрузки, Знач Вариант, Знач ИдентификаторВыгрузки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если НЕ ЗначениеЗаполнено(Константы.РежимИспользованияИнформационнойБазы.Получить()) Тогда
			ТекстСообщения = НСтр("ru='Не установлен режим работы информационной базы';uk='Не встановлений режим роботи інформаційної бази'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Блокировка.Заблокировать();
		
		ДобавитьЗаписьВРСОбластиДанных(КодОбластиДанных, Перечисления.СтатусыОбластейДанных.Новая, ИдентификаторВыгрузки, 0, ?(ИзВыгрузки, "", Вариант));
		
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(КодОбластиДанных);
		
		ПараметрыМетода.Добавить(ИдентификаторВыгрузки);
		Если Не ИзВыгрузки Тогда
			ПараметрыМетода.Добавить(Вариант);
		КонецЕсли;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "РаботаВМоделиСервиса.ПодготовитьОбластьДанныхКИспользованию");
		ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
		ПараметрыЗадания.Вставить("Ключ"         , "1");
		ПараметрыЗадания.Вставить("ОбластьДанных", КодОбластиДанных);
		ПараметрыЗадания.Вставить("ЭксклюзивноеВыполнение", Истина);
		
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}DeleteApplication.
//
// Параметры:
//  КодОбластиДанных - число(7,0).
//
Процедура УдалитьОбластьДанных(Знач КодОбластиДанных) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Прочитать();
		Если НЕ МенеджерЗаписи.Выбран() Тогда
			
			ШаблонСообщения = НСтр("ru='Область данных %1 не существует. Предположительно, попытка удаления области данных после неудачной конвертации.';uk='Область даних %1 не існує. Імовірно, спроба видалення області даних після невдалої конвертації.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОбластиДанных);
			
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрацииУдаленноеАдминистрированиеУдалитьОбласть(),
				УровеньЖурналаРегистрации.Предупреждение,, КодОбластиДанных, 
				ТекстСообщения);
				
			// Отправить сообщение о завершении удаления области в менеджер сервиса.
			ТипСообщения = СообщенияКонтрольУдаленногоАдминистрированияИнтерфейс.СообщениеОбластьДанныхУдалена();
			Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(ТипСообщения);
			Сообщение.Body.Zone = КодОбластиДанных;
			
			СообщенияВМоделиСервиса.ОтправитьСообщение(
				Сообщение,
				РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
			ЗафиксироватьТранзакцию();
			
			Возврат;
			
		КонецЕсли;
		
		МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.КУдалению;
		МенеджерЗаписи.Повтор = 0;
		
		КопияМенеджера = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(КопияМенеджера, МенеджерЗаписи);
		МенеджерЗаписи = КопияМенеджера;
		
		МенеджерЗаписи.Записать();
		
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(КодОбластиДанных);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "РаботаВМоделиСервиса.ОчиститьОбластьДанных");
		ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
		ПараметрыЗадания.Вставить("Ключ"         , "1");
		ПараметрыЗадания.Вставить("ОбластьДанных", КодОбластиДанных);
		
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}PrepareCustomApplication.
//
// Параметры:
//  КодОбластиДанных - число(7,0),
//  ИдентификаторВыгрузки - УникальныйИдентификатор, идентификатор файла выгрузки в хранилище менеджера сервиса.
//  СопоставлениеПользователей - ТаблицаЗначений - описание см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеИзАрхива().
//  ОбщиеДанные - Булево - признак того, что это общие данные.
//
Процедура ПодготовитьОбластьИзВыгрузки(Знач КодОбластиДанных, Знач ИдентификаторВыгрузки, Знач СопоставлениеПользователей, ОбщиеДанные = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если НЕ ЗначениеЗаполнено(Константы.РежимИспользованияИнформационнойБазы.Получить()) Тогда
			ТекстСообщения = НСтр("ru='Не установлен режим работы информационной базы';uk='Не встановлений режим роботи інформаційної бази'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Блокировка.Заблокировать();
		
		ДобавитьЗаписьВРСОбластиДанных(КодОбластиДанных, Перечисления.СтатусыОбластейДанных.ПустаяСсылка(), ИдентификаторВыгрузки, 0, , ОбщиеДанные);
		
		// Знач КодОбластиДанных, Знач СписокПользователей, Знач ПредставлениеПриложения, Знач ЧасовойПоясПриложения
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(КодОбластиДанных);
		ПараметрыМетода.Добавить(ИдентификаторВыгрузки);
		ПараметрыМетода.Добавить(СопоставлениеПользователей);
		ПараметрыМетода.Добавить(ОбщиеДанные);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "РаботаВМоделиСервисаБТС.ПодготовитьОбластьИзВыгрузки");
		ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
		Если ОбщиеДанные Тогда
			ПараметрыЗадания.Вставить("ОбластьДанных", -1);
		Иначе
			ПараметрыЗадания.Вставить("ОбластьДанных", КодОбластиДанных);
			ПараметрыЗадания.Вставить("Ключ", "1");
		КонецЕсли;
		ПараметрыЗадания.Вставить("ЭксклюзивноеВыполнение", Истина);
		ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
		
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetApplicationAccess.
//
// Параметры:
//  Имя - строка, имя пользователя,
//  ХэшПароля - строка, сохраняемое значение пароля,
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор,
//  ДоступРазрешен - булево, флаг предоставления доступа пользователю к области данных,
//  КодЯзыка - строка, код языка пользователя.
//
Процедура УстановитьДоступКОбластиДанных(Знач Имя, Знач ХэшПароля,
		Знач ИдентификаторПользователяСервиса,
		Знач ДоступРазрешен, Знач КодЯзыка = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		ПользовательОбластиДанных = ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(ИдентификаторПользователяСервиса);
		
		ЯзыкПользователяИБ = РаботаВМоделиСервисаБТС.ЯзыкПоКоду(КодЯзыка);
		
		ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", ДоступРазрешен);
		ОписаниеПользователяИБ.Имя = Имя;
		ОписаниеПользователяИБ.Язык = ЯзыкПользователяИБ;
		ОписаниеПользователяИБ.СохраняемоеЗначениеПароля = ХэшПароля;
		ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
		ОписаниеПользователяИБ.АутентификацияOpenID = Истина;
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
		
		ПользовательОбъект = ПользовательОбластиДанных.ПолучитьОбъект();
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОбработкаСообщенияКаналаУдаленногоАдминистрирования");
		ПользовательОбъект.Записать();
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом
// http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetServiceManagerEndPoint.
//
// Параметры:
//  УзелОбменаСообщениями - ПланОбменаСсылка.ОбменСообщениями.
//
Процедура УстановитьКонечнуюТочкуМенеджераСервиса(УзелОбменаСообщениями) Экспорт
	
	Константы.КонечнаяТочкаМенеджераСервиса.Установить(УзелОбменаСообщениями);
	ОбщегоНазначения.УстановитьПараметрыРазделенияИнформационнойБазы(Истина);
	РаботаВМоделиСервисаБТС.ПриУстановкеКонечнойТочкиМенеджераСервиса();
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetIBParams.
//
// Параметры:
//  Параметры - Структура, содержащая значения параметров, которые необходимо установить для информационной базы.
//
Процедура УстановитьПараметрыИБ(Параметры) Экспорт
	
	НачатьТранзакцию();
	Попытка
		ТаблицаПараметров = РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ();
		
		ИзменяемыеПараметры = Новый Структура;
		
		// Проверка корректности списка параметров.
		Для каждого КлючИЗначение Из Параметры Цикл
			
			СтрокаПараметра = ТаблицаПараметров.Найти(КлючИЗначение.Ключ, "Имя");
			Если СтрокаПараметра = Неопределено Тогда
				ШаблонСообщения = НСтр("ru='Не известное имя параметра %1';uk='Не відоме ім''я параметра %1'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КлючИЗначение.Ключ);
				ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииУдаленноеАдминистрированиеУстановитьПараметры(),
					УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
				Продолжить;
			ИначеЕсли СтрокаПараметра.ЗапретЗаписи Тогда
				ШаблонСообщения = НСтр("ru='Параметр %1 может использоваться только для чтения';uk='Параметр %1 може використовуватися тільки для читання'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КлючИЗначение.Ключ);
				ВызватьИсключение(ТекстСообщения);
			КонецЕсли;
			
			ИзменяемыеПараметры.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			
		КонецЦикла;
		
		ТехнологияСервисаИнтеграцияСБСП.ПриУстановкеЗначенийПараметровИБ(ИзменяемыеПараметры);
		РаботаВМоделиСервисаПереопределяемый.ПриУстановкеЗначенийПараметровИБ(ИзменяемыеПараметры);
		
		Для каждого КлючИЗначение Из ИзменяемыеПараметры Цикл
			
			Константы[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииУдаленноеАдминистрированиеУстановитьПараметры(), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetApplicationParams.
//
// Параметры:
//  КодОбластиДанных - число(7,0),
//  ПредставлениеОбластиДанных - строка,
//  ЧасовойПоясОбластиДанных - строка.
//
Процедура УстановитьПараметрыОбластиДанных(Знач КодОбластиДанных,
		Знач ПредставлениеОбластиДанных,
		Знач ЧасовойПоясОбластиДанных = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		Если Не ПустаяСтрока(ПредставлениеОбластиДанных) Тогда
			
			РаботаВМоделиСервисаБТС.ОбновитьСвойстваПредопределенныхУзлов(ПредставлениеОбластиДанных);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	РаботаВМоделиСервисаБТС.ОбновитьПараметрыТекущейОбластиДанных(ПредставлениеОбластиДанных, ЧасовойПоясОбластиДанных);
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetFullControl.
//
// Параметры:
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор,
//  ДоступРазрешен - булево, флаг предоставления доступа пользователю к области данных.
//
Процедура УстановитьПолныеПраваОбластиДанных(Знач ИдентификаторПользователяСервиса, Знач ДоступРазрешен) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		ПользовательОбластиДанных = ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(ИдентификаторПользователяСервиса);
		
		Если ПользователиСлужебный.ЗапретРедактированияРолей()
			И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			
			МодульУправлениеДоступомСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебныйВМоделиСервиса");
			МодульУправлениеДоступомСлужебныйВМоделиСервиса.УстановитьПринадлежностьПользователяКГруппеАдминистраторы(ПользовательОбластиДанных, ДоступРазрешен);
			
		Иначе
			
			ПользовательИБ = ПолучитьПользователяИБПоПользователюОбластиДанных(ПользовательОбластиДанных);
			
			РольПолныеПрава = Метаданные.Роли.ПолныеПрава;
			Если ДоступРазрешен Тогда
				Если НЕ ПользовательИБ.Роли.Содержит(РольПолныеПрава) Тогда
					ПользовательИБ.Роли.Добавить(РольПолныеПрава);
				КонецЕсли;
			Иначе
				Если ПользовательИБ.Роли.Содержит(РольПолныеПрава) Тогда
					ПользовательИБ.Роли.Удалить(РольПолныеПрава);
				КонецЕсли;
			КонецЕсли;
			
			Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтандартныеПодсистемыСервер.ВерсияБиблиотеки(), "2.3.4.5") >= 0 Тогда
				ПользователиСлужебный.ЗаписатьПользователяИнформационнойБазы(ПользовательИБ, Ложь);
			Иначе
				ПользователиСлужебный.ЗаписатьПользователяИнформационнойБазы(ПользовательИБ, ПользовательОбластиДанных);
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetDefaultUserRights.
//
// Параметры:
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор.
//  ДоступРазрешен - булево, флаг предоставления доступа пользователю к области данных.
//
Процедура УстановитьПраваПользователяПоУмолчанию(Знач ИдентификаторПользователяСервиса, Знач ДоступРазрешен = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		ПользовательОбластиДанных = ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(ИдентификаторПользователяСервиса);
        Если ДоступРазрешен Тогда
    	    РаботаВМоделиСервисаПереопределяемый.УстановитьПраваПоУмолчанию(ПользовательОбластиДанных);
        КонецЕсли; 
   		РаботаВМоделиСервисаБТСПереопределяемый.УстановитьПраваПоУмолчанию(ПользовательОбластиДанных, ДоступРазрешен);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetAPIAccess.
//
// Параметры:
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор,
//  ДоступРазрешен - булево, флаг предоставления доступа пользователю к области данных.
//
Процедура УстановитьДоступКAPIОбластиДанных(Знач ИдентификаторПользователяСервиса, Знач ДоступРазрешен) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		ПользовательОбластиДанных = ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(ИдентификаторПользователяСервиса);
        ПользовательОбъект = ПользовательОбластиДанных.ПолучитьОбъект();
        ПользовательОбъект.Служебный = ДоступРазрешен;
        ПользовательОбъект.Записать();
		РаботаВМоделиСервисаБТСПереопределяемый.УстановитьДоступКAPIОбластиДанных(ПользовательОбластиДанных, ДоступРазрешен);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}SetApplicationsRating.
//
// Параметры:
//  ТаблицаРейтинга - ТаблицаЗначений, содержащая рейтинг активности областей данных, колонки:
//    ОбластьДанных - число(7,0),
//    Рейтинг - число(7,0),
//  Замещать - булево, флаг замещения существующих записей в рейтинге активности областей данных.
//
Процедура УстановитьРейтингОбластейДанных(Знач ТаблицаРейтинга, Знач Замещать) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.РейтингАктивностиОбластейДанных.СоздатьНаборЗаписей();
	
	Если Замещать Тогда
		Набор.Загрузить(ТаблицаРейтинга);
		Набор.Записать();
	Иначе
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РейтингАктивностиОбластейДанных");
		ЭлементБлокировки.ИсточникДанных = ТаблицаРейтинга;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОбластьДанныхВспомогательныеДанные", "ОбластьДанныхВспомогательныеДанные");
		НачатьТранзакцию();
		
		Попытка
			Блокировка.Заблокировать();
			
			Для каждого СтрокаРейтинга Из ТаблицаРейтинга Цикл
				Набор.Очистить();
				Набор.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(СтрокаРейтинга.ОбластьДанныхВспомогательныеДанные);
				Запись = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, СтрокаРейтинга);
				Набор.Записать();
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}BindApplication.
//
// Параметры:
//  Параметры - Структура, содержащая значения параметров, которые необходимо установить для области данных.
//
Процедура ПрикрепитьОбластьДанных(Параметры) Экспорт
	
	РаботаВМоделиСервисаБТС.ПрикрепитьОбластьДанных(Параметры.Zone, Параметры.UsersList.Item, Параметры.Presentation, Параметры.TimeZone);
	
КонецПроцедуры

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}PrepareApplicationForMigration.
//
// Параметры:
//  КодОбластиДанных - Число(7,0) - номер области.
//  Параметры - Структура - параметры, которые необходимо установить для области данных.
//
Процедура ПодготовитьОбластьДанныхДляМиграции(КодОбластиДанных, Параметры) Экспорт
	
	Если Не ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		ТекстСообщения = НСтр("ru='Миграция приложений не поддерживается';uk='Міграція програм не підтримується'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если Не ЗначениеЗаполнено(Константы.РежимИспользованияИнформационнойБазы.Получить()) Тогда
			ТекстСообщения = НСтр("ru='Не установлен режим работы информационной базы';uk='Не встановлений режим роботи інформаційної бази'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Блокировка.Заблокировать();
		
		ДобавитьЗаписьВРСОбластиДанных(КодОбластиДанных, Перечисления.СтатусыОбластейДанных.ПустаяСсылка());
		
		// Добавление служебного пользователя.
		Роли = Новый Массив;
		Роли.Добавить("ПолныеПрава");
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя", Параметры.ИмяПользователя);
		ОписаниеПользователяИБ.Вставить("Пароль", Параметры.ПарольПользователя);
		ОписаниеПользователяИБ.Вставить("Роли", Роли);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", Ложь);
		
		Пользователь = Справочники.Пользователи.СоздатьЭлемент();
		Пользователь.Наименование = Параметры.ИмяПользователя;
		Пользователь.Служебный = Истина;
		Пользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		Пользователь.Записать();

		МодульМиграцияПриложений = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("МиграцияПриложений");
		МодульМиграцияПриложений.НачатьЗагрузку(Параметры.Пользователи);
		
		РаботаВМоделиСервисаБТС.ОбновитьПараметрыТекущейОбластиДанных(Параметры.Наименование, Параметры.ЧасовойПояс);
		
		ТипСообщения = СообщенияКонтрольУдаленногоАдминистрированияИнтерфейс.СообщениеОбластьДанныхПодготовлена();
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(ТипСообщения);
		Сообщение.Body.Zone = КодОбластиДанных;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение, РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса(), Истина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

// Генерирует код узла плана обмена для заданной области данных.
//
// Параметры:
// НомерОбласти - Число - Значение разделителя. 
//
// Возвращаемое значение:
// Строка - Код узла плана обмена для заданной области. 
//
Функция КодУзлаПланаОбменаВСервисе(Знач НомерОбласти) Экспорт
	
	Если ТипЗнч(НомерОбласти) <> Тип("Число") Тогда
		ВызватьИсключение НСтр("ru='Неправильный тип параметра номер [1].';uk='Неправильний тип параметра номер [1].'");
	КонецЕсли;
	
	Результат = "S0[НомерОбласти]";
	
	Возврат СтрЗаменить(Результат, "[НомерОбласти]", Формат(НомерОбласти, "ЧЦ=7; ЧВН=; ЧГ=0"));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(Знач ИдентификаторПользователяСервиса)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ИдентификаторПользователяСервиса = &ИдентификаторПользователяСервиса";
	Запрос.УстановитьПараметр("ИдентификаторПользователяСервиса", ИдентификаторПользователяСервиса);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Результат.Пустой() Тогда
		ШаблонСообщения = НСтр("ru='Не найден пользователь с идентификатором пользователя сервиса %1';uk='Не знайдений користувач з ідентифікатором користувача сервісу %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИдентификаторПользователяСервиса);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

Функция ПолучитьПользователяИБПоПользователюОбластиДанных(Знач ПользовательОбластиДанных) Экспорт
	
	ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПользовательОбластиДанных, "ИдентификаторПользователяИБ");
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
	Если ПользовательИБ = Неопределено Тогда
		ШаблонСообщения = НСтр("ru='Для пользователя области данных с идентификатором %1 не существует пользователя информационной базы';uk='Для користувача області даних з ідентифікатором %1 не існує користувача інформаційної бази'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПользовательОбластиДанных.УникальныйИдентификатор());
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат ПользовательИБ;
	
КонецФункции

// Обработка входящих сообщений с типом http://www.1c.ru/SaaS/RemoteAdministration/App/a.b.c.d}PrepareAndBindApplication.
Процедура ПодготовитьИПрикрепитьОбластьДанных(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если НЕ ЗначениеЗаполнено(Константы.РежимИспользованияИнформационнойБазы.Получить()) Тогда
			ТекстСообщения = НСтр("ru='Не установлен режим работы информационной базы';uk='Не встановлений режим роботи інформаційної бази'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Блокировка.Заблокировать();
		
		ДобавитьЗаписьВРСОбластиДанных(Параметры.Zone, Перечисления.СтатусыОбластейДанных.ПустаяСсылка());
		
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(Параметры.Zone);
		ПараметрыМетода.Добавить(СписокПользователей(Параметры.UsersList));
		ПараметрыМетода.Добавить(Параметры.Presentation);
		ПараметрыМетода.Добавить(Параметры.TimeZone);
		ПараметрыМетода.Добавить(Параметры.DataFileId);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода"    , "РаботаВМоделиСервисаБТС.ПодготовитьИПрикрепитьОбластьДанных");
		ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
		ПараметрыЗадания.Вставить("Ключ"         , "1");
		ПараметрыЗадания.Вставить("ОбластьДанных", Параметры.Zone);
		ПараметрыЗадания.Вставить("ЭксклюзивноеВыполнение", Истина);
		
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрацииУдаленноеАдминистрированиеУстановитьПараметры() Экспорт
	
	Возврат НСтр("ru='Удаленное администрирование в модели сервиса.Установить параметры';uk='Віддалене адміністрування в моделі сервісу.Встановити параметри'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция СобытиеЖурналаРегистрацииУдаленноеАдминистрированиеУдалитьОбласть() Экспорт
	
	Возврат НСтр("ru='Удаленное администрирование в модели сервиса.Удалить область';uk='Віддалене адміністрування в моделі сервісу.Видалити область'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Процедура ДобавитьЗаписьВРСОбластиДанных(Знач КодОбластиДанных, Знач Статус, Знач ИдентификаторВыгрузки = Неопределено, 
	Знач Повтор = 0, Знач Вариант = "", ОбщиеДанные = Ложь)
	
	Если ОбщиеДанные Тогда
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = КодОбластиДанных;
		МенеджерЗаписи.Прочитать();
		ПроверитьНаличиеОбластиДанных(МенеджерЗаписи, КодОбластиДанных);
		
		МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = КодОбластиДанных;
		МенеджерЗаписи.Статус = Статус;
		МенеджерЗаписи.ИдентификаторВыгрузки = ИдентификаторВыгрузки;
		МенеджерЗаписи.Повтор = Повтор;
		МенеджерЗаписи.Вариант = Вариант;
	Иначе
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Прочитать();
		
		// Проверка, что нет такой области
		ПроверитьНаличиеОбластиДанных(МенеджерЗаписи, КодОбластиДанных);
		
		МенеджерЗаписи.Статус = Статус;
		МенеджерЗаписи.ИдентификаторВыгрузки = ИдентификаторВыгрузки;
		МенеджерЗаписи.Повтор = Повтор;
		МенеджерЗаписи.Вариант = Вариант;
		
		КопияМенеджера = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(КопияМенеджера, МенеджерЗаписи);
		МенеджерЗаписи = КопияМенеджера;
	КонецЕсли;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ПроверитьНаличиеОбластиДанных(Знач МенеджерЗаписи, Знач КодОбластиДанных)
	
	Если МенеджерЗаписи.Выбран() Тогда
		Если МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Удалена Тогда
			ШаблонСообщения = НСтр("ru='Область данных %1 удалена';uk='Область даних %1 вилучена'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОбластиДанных);
			ВызватьИсключение(ТекстСообщения);
		ИначеЕсли МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.КУдалению Тогда
			ШаблонСообщения = НСтр("ru='Область данных %1 в процессе удаления';uk='Область даних %1 в процесі вилучення'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОбластиДанных);
			ВызватьИсключение(ТекстСообщения);
		ИначеЕсли МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Новая Тогда
			ШаблонСообщения = НСтр("ru='Область данных %1 в процессе подготовки к использованию';uk='Область даних %1 в процесі підготовки до використання'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОбластиДанных);
			ВызватьИсключение(ТекстСообщения);
		ИначеЕсли МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Используется Тогда
			ШаблонСообщения = НСтр("ru='Область данных %1 используется.';uk='Область даних %1 використовується.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОбластиДанных);
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СписокПользователей(Знач СписокПользователей)
	
	МассивПользователей = Новый Массив;
	
	Для Каждого Пользователь Из СписокПользователей.Item Цикл 
		СтруктураПользователя = СтруктураПользователя();
		ЗаполнитьЗначенияСвойств(СтруктураПользователя, Пользователь);
		МассивПользователей.Добавить(СтруктураПользователя);
	КонецЦикла;;
	
	Возврат МассивПользователей;
	
КонецФункции

Функция СтруктураПользователя()
	
	Пользователь = Новый Структура;
	Пользователь.Вставить("Name", "");
	Пользователь.Вставить("FullName", "");
	Пользователь.Вставить("StoredPasswordValue", "");
	Пользователь.Вставить("Language", "");
	Пользователь.Вставить("EMail", "");
	Пользователь.Вставить("Phone", "");
	Пользователь.Вставить("UserServiceID", Неопределено);
	Пользователь.Вставить("UserApplicationID", Неопределено);
	Пользователь.Вставить("OSAuthentication", Ложь);
	Пользователь.Вставить("OSUser", "");
	
	Возврат Пользователь;
	
КонецФункции

#КонецОбласти
