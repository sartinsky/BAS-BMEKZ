#Область ПрограммныйИнтерфейс

// Процедура записывает значение по умолчанию для передаваемого пользователя и настройки.
//
//  Параметры:
//  	Настройка    - Строка - вид настройки
//  	Значение     - значение настройки
//  	Пользователь - СправочникСсылка.Пользователи - текущий Пользователь программы, для которого устанавливается настройка
//
Процедура УстановитьЗначениеПоУмолчанию(Настройка, Значение, Пользователь = Неопределено) Экспорт

	Если    ВРег(Настройка) = ВРег("ВидХранения")
		ИЛИ ВРег(Настройка) = ВРег("ЗаполнениеПредРасчБезОтходов")
		ИЛИ ВРег(Настройка) = ВРег("ИнтерактивноеФормированиеТиповыхДокументов")
		ИЛИ ВРег(Настройка) = ВРег("КонтролироватьОстаткиУслуг")
		ИЛИ ВРег(Настройка) = ВРег("ОсновнойСкладЭлеватора")
		ИЛИ ВРег(Настройка) = ВРег("ОсновнойТипХранения")
		ИЛИ ВРег(Настройка) = ВРег("ОтражатьВБухгалтерскомУчете")
		ИЛИ ВРег(Настройка) = ВРег("ПоказыватьВДокументахОстатокВЗачетномВесе")
		ИЛИ ВРег(Настройка) = ВРег("СпособХранения")
		ИЛИ ВРег(Настройка) = ВРег("УбыльПриХранении")
		ИЛИ ВРег(Настройка) = ВРег("Урожай") Тогда		
				
		ХранилищеОбщихНастроек.Сохранить(ВРег(Настройка), "Элеватор", Значение, , Пользователь);

	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
//  Параметры:
//  	Настройка    - Строка - вид настройки, значение по умолчанию которой необходимо получить
//  	Пользователь - СправочникСсылка.Пользователи - Пользователь программы, настройка которого
//					   запрашивается, если параметр не передается настройка возвращается для текущего пользователя
//
//  Возвращаемое значение:
//  	- ЛюбаяСсылка - значение по умолчанию для настройки
//      - Булево      - значение по умолчанию для настройки
//
Функция ПолучитьЗначениеПоУмолчанию(Настройка, Пользователь = Неопределено) Экспорт

	НастройкаВРег       = ВРег(Настройка);
	НастройкаТипаСсылка = Ложь;

	Если НастройкаВРег = ВРег("ВидХранения") Тогда
		ПустоеЗначение = Справочники.ИНАГРО_ВидыХранения.ПустаяСсылка();
		ИмяОбъекта = "Справочник.ИНАГРО_ВидыХранения";
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("ЗаполнениеПредРасчБезОтходов") Тогда
		ПустоеЗначение = Ложь;
		НастройкаТипаСсылка = Ложь;
	ИначеЕсли НастройкаВРег = ВРег("ИнтерактивноеФормированиеТиповыхДокументов") Тогда
		ПустоеЗначение = Ложь;
		НастройкаТипаСсылка = Ложь;
	ИначеЕсли НастройкаВРег = ВРег("КонтролироватьОстаткиУслуг") Тогда
		ПустоеЗначение = Ложь;
		НастройкаТипаСсылка = Ложь;
	ИначеЕсли НастройкаВРег = ВРег("ОсновнойСкладЭлеватора") Тогда
		ПустоеЗначение = Справочники.Склады.ПустаяСсылка();
		ИмяОбъекта = "Справочник.Склады";
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("ОсновнойТипХранения") Тогда
		ПустоеЗначение = Перечисления.ИНАГРО_ТипыХранения.ПустаяСсылка();
		ИмяОбъекта = "Перечисление.ИНАГРО_ТипыХранения";
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("ОтражатьВБухгалтерскомУчете") Тогда
		ПустоеЗначение = Ложь;		
		НастройкаТипаСсылка = Ложь;
	ИначеЕсли НастройкаВРег = ВРег("ПоказыватьВДокументахОстатокВЗачетномВесе") Тогда
		ПустоеЗначение = Ложь;		
		НастройкаТипаСсылка = Ложь;
	ИначеЕсли НастройкаВРег = ВРег("СпособХранения") Тогда
		ПустоеЗначение = Перечисления.ИНАГРО_СпособХранения.ПустаяСсылка();
		ИмяОбъекта = "Перечисление.ИНАГРО_СпособХранения";
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("УбыльПриХранении") Тогда
		ПустоеЗначение = Перечисления.ИНАГРО_СпособХранения.ПустаяСсылка();
		ИмяОбъекта = "Перечисление.ИНАГРО_СпособХранения";
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("Урожай") Тогда
		ПустоеЗначение = Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка();
		ИмяОбъекта = "Справочник.ИНАГРО_ВидыУрожая";
		НастройкаТипаСсылка = Истина;		
	Иначе
		Возврат Неопределено;
	КонецЕсли;

	ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить(НастройкаВРег, "Элеватор", , Пользователь);

	Если ТипЗнч(ЗначениеНастройки) = ТипЗнч(ПустоеЗначение) Тогда
		Если НастройкаТипаСсылка Тогда
			Если НЕ ОбщегоНазначения.СсылкаСуществует(ЗначениеНастройки) Тогда
				ЗначениеНастройки = ПустоеЗначение;
			Иначе
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("Ссылка", ЗначениеНастройки);
				Запрос.Текст = 
					"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					|	ЗначенияОбъекта.Ссылка
					|ИЗ
					|	" + ИмяОбъекта + " КАК ЗначенияОбъекта
					|ГДЕ
					|	ЗначенияОбъекта.Ссылка = &Ссылка";
				Результат = Запрос.Выполнить();
				Если Результат.Пустой() Тогда
					ЗначениеНастройки = ПустоеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ЗначениеНастройки = ПустоеЗначение;
	КонецЕсли;
	
	Возврат ?(ЗначениеНастройки = Неопределено, ПустоеЗначение, ЗначениеНастройки);
	
КонецФункции

// Процедура предназначена для заполнения общих реквизитов документов,
// вызывается в обработчиках событий "ПриОткрытии" в модулях форм всех документов.
//
// Параметры:
//  ДокументОбъект                 - объект редактируемого документа,
//  ТекущийПользователь            - ссылка на справочник, определяет текущего пользователя  
Процедура ЗаполнитьШапкуДокумента(ДокументОбъект, ТекущийПользователь = Неопределено) Экспорт
	
	МетаданныеДокумента = ДокументОбъект.Метаданные();	
		
	// Вид хранения
	Если МетаданныеДокумента.Реквизиты.Найти("ВидХранения") <> Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.ВидХранения) Тогда
			ДокументОбъект.ВидХранения = ПолучитьЗначениеПоУмолчанию("ВидХранения", ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;
	
	// Склад для элеватора
	Если МетаданныеДокумента.Реквизиты.Найти("Склад") <> Неопределено Тогда		
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.Склад) Тогда
			ДокументОбъект.Склад = ПолучитьЗначениеПоУмолчанию("ОсновнойСкладЭлеватора", ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;			
	
	// Тип хранения
	Если МетаданныеДокумента.Реквизиты.Найти("ТипХранения") <> Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.ТипХранения) Тогда
			ДокументОбъект.ТипХранения = ПолучитьЗначениеПоУмолчанию("ОсновнойТипХранения", ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;
	
	// Способ хранения
	Если МетаданныеДокумента.Реквизиты.Найти("СпособХранения") <> Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.СпособХранения) Тогда
			ДокументОбъект.СпособХранения = ПолучитьЗначениеПоУмолчанию("СпособХранения", ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;
	
	// Урожай
	Если МетаданныеДокумента.Реквизиты.Найти("Урожай") <> Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.Урожай) Тогда
			ДокументОбъект.Урожай = ПолучитьЗначениеПоУмолчанию("Урожай", ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;
	
	// Отражать в бухгалтерском учете
	Если МетаданныеДокумента.Реквизиты.Найти("ОтражатьВБухгалтерскомУчете") <> Неопределено Тогда
		ДокументОбъект.ОтражатьВБухгалтерскомУчете = ПолучитьЗначениеПоУмолчанию("ОтражатьВБухгалтерскомУчете", ТекущийПользователь);
	КонецЕсли; 
	
КонецПроцедуры 

// Устанавливает доступность реквизитов ввода веса ТТН
//
//  Параметры:
//  	Форма - форма объекта
//
Процедура ЗаполнитьДополнительныеРеквизиты(Форма) Экспорт
	
	Объект 	 = Форма.Объект;
	Элементы = Форма.Элементы;
	
	МетаданныеДокумента            = Объект.Ссылка.Метаданные();	
	ТекущийПользователь            = Пользователи.ТекущийПользователь();	
	ЗапретитьВручнуюИзменятьВесТТН = ИНАГРО_ЭлеваторУправлениеПользователями.ЗапретитьВручнуюИзменятьВесТТН(ТекущийПользователь);
	
	Если Элементы <> Неопределено Тогда
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесБрутто", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесБрутто") <> Неопределено) Тогда
			Элементы.ВесБрутто.Доступность       = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесБрутто1", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесБрутто1") <> Неопределено) Тогда
			Элементы.ВесБрутто1.Доступность      = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесТары", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесТары") <> Неопределено) Тогда
			Элементы.ВесТары.Доступность         = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесТары1", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесТары1") <> Неопределено) Тогда
			Элементы.ВесТары1.Доступность        = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесБруттоВывоз", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесБруттоВывоз") <> Неопределено) Тогда
			Элементы.ВесБруттоВывоз.Доступность  = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесТарыВывоз", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесТарыВывоз") <> Неопределено)  Тогда
			Элементы.ВесТарыВывоз.Доступность    = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесБрутто1Вывоз", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесБрутто1Вывоз") <> Неопределено) Тогда
			Элементы.ВесБрутто1Вывоз.Доступность = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
		Если (ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ВесТары1Вывоз", МетаданныеДокумента) <> Неопределено
			И Элементы.Найти("ВесТары1Вывоз") <> Неопределено) Тогда
			Элементы.ВесТары1Вывоз.Доступность   = НЕ ЗапретитьВручнуюИзменятьВесТТН;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет общие действия при измененнии контрагента
//
//  Параметры:
//      Дата                - Дата
//  	Организация         - СправочникСсылка.Организации
//  	Контрагент          - СправочникСсылка.Контрагенты
//  	ДоговорКонтрагента  - СправочникСсылка.ДоговорыКонтрагентов
//      СтруктураПараметров - Структура - структура дополнительных параметров
//
Процедура ПриИзмененииЗначенияКонтрагента(Дата, Организация, Контрагент, ДоговорКонтрагента, СтруктураПараметров = Неопределено) Экспорт
	
	ИНАГРО_ЭлеваторЗаполнениеДокументовСервер.ПриИзмененииЗначенияКонтрагента(Дата, Организация, Контрагент, ДоговорКонтрагента, СтруктураПараметров);
		
КонецПроцедуры

// Заполняет тип номер журнала весовой
//
//  Параметры:
//  	Объект - ДокументОбъект, ДанныеФормыСтруктура
//
Процедура ЗаполнитьТипНомерЖурналаВесовой(Объект) Экспорт
	
	ИНАГРО_ЭлеваторЗаполнениеДокументовСервер.ЗаполнитьТипНомерЖурналаВесовой(Объект);
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает параметры видов документов
//
//	Параметры:
//  	ИмяРеквизита
//		ЗначениеРеквизита
//
//	Возвращаемое значение:
//
//
Функция ПолучитьПараметрыВидовДокументов(ИмяРеквизита, ЗначениеРеквизита) Экспорт
	
	Возврат ИНАГРО_ЭлеваторЗаполнениеДокументовСервер.ПолучитьПараметрыВидовДокументов(ИмяРеквизита, ЗначениеРеквизита);
	
КонецФункции

#КонецОбласти

