&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода",             Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода",              Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ТипДанных",                 Отчет.ТипДанных);
	ПараметрыОтчета.Вставить("ИмяОбъекта",                Отчет.ИмяОбъекта);
	ПараметрыОтчета.Вставить("ИмяТаблицы",                Отчет.ИмяТаблицы);
	ПараметрыОтчета.Вставить("Группировка",               Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок",         ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал",            ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки",         ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления",           МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных",     ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета",       БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных", Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("Организация",               Неопределено);
	ПараметрыОтчета.Вставить("Заголовок",                 Заголовок);
		
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
	Если ЗначениеЗаполнено(Отчет.ИмяТаблицы) Тогда
		ШаблонЗаголовка = НСтр("ru='Универсальный отчет: %1 ""%2"" - таблица ""%3""%4';uk='Універсальний звіт: %1 ""%2"" - таблиця ""%3""%4'");
	Иначе
		ШаблонЗаголовка = НСтр("ru='Универсальный отчет: %1 ""%2""%4';uk='Універсальний звіт: %1 ""%2""%4'");
	КонецЕсли;
	
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка,
		ПолучитьПредставлениеЗначения(Элементы.ТипДанных.СписокВыбора, Отчет.ТипДанных),
		ПолучитьПредставлениеЗначения(Элементы.ИмяОбъекта.СписокВыбора, Отчет.ИмяОбъекта),
		ПолучитьПредставлениеЗначения(Элементы.ИмяТаблицы.СписокВыбора, Отчет.ИмяТаблицы),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));
		
	Форма.Заголовок =  ТекстЗаголовка;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеЗначения(Список, Значение)
	
	ЭлементСписка = Список.НайтиПоЗначению(Значение);
	Если ЭлементСписка = Неопределено Тогда
		Возврат Строка(Значение);
	Иначе
		Возврат ЭлементСписка.Представление;
	КонецЕсли;

КонецФункции

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
					
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура УстановитьПоУмолчаниюТипДанных()
	
	Если ПустаяСтрока(Отчет.ТипДанных) Тогда
		Отчет.ТипДанных = "РегистрыНакопления";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьПоУмолчаниюОбъект()
	
	Если ПустаяСтрока(Отчет.ИмяОбъекта)
		И Элементы.ИмяОбъекта.СписокВыбора.Количество() > 0 Тогда
		Отчет.ИмяОбъекта = Элементы.ИмяОбъекта.СписокВыбора[0].Значение;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьПоУмолчаниюТаблицу()
	
	СписокВыбораТаблиц = Элементы.ИмяТаблицы.СписокВыбора;
	Если СписокВыбораТаблиц.Количество() > 1 Тогда
		Отчет.ИмяТаблицы = СписокВыбораТаблиц[1].Значение;
		Элементы.ИмяТаблицы.Видимость = Истина;
	Иначе
		Элементы.ИмяТаблицы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияЭлементовФормы()
	ОбновитьСписокВыбораТипДанных();
	УстановитьПоУмолчаниюТипДанных();
	ОбновитьСписокВыбораОбъектов();
	УстановитьПоУмолчаниюОбъект();
	ОбновитьСписокВыбораТаблиц();
	УстановитьПоУмолчаниюТаблицу();	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораТипДанных()
	
    Элементы.ТипДанных.СписокВыбора.Очистить();
	Элементы.ТипДанных.СписокВыбора.Добавить("Документы", НСтр("ru='Документ';uk='Документ'"), , БиблиотекаКартинок.Документ);
	Элементы.ТипДанных.СписокВыбора.Добавить("Справочники", НСтр("ru='Справочник';uk='Довідник'"), , БиблиотекаКартинок.Справочник);
	Элементы.ТипДанных.СписокВыбора.Добавить("РегистрыНакопления", НСтр("ru='Регистр накопления';uk='Регістр накопичення'"), , БиблиотекаКартинок.РегистрНакопления);
	Элементы.ТипДанных.СписокВыбора.Добавить("РегистрыСведений", НСтр("ru='Регистр сведений';uk='Регістр відомостей'"), , БиблиотекаКартинок.РегистрСведений);
	Элементы.ТипДанных.СписокВыбора.Добавить("РегистрыБухгалтерии", НСтр("ru='Регистр бухгалтерии';uk='Регістр бухгалтерії'"), , БиблиотекаКартинок.РегистрБухгалтерии);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораОбъектов()
	
	Элементы.ИмяОбъекта.СписокВыбора.Очистить();
	Если НЕ ЗначениеЗаполнено(Отчет.ТипДанных) Тогда
		Возврат;
	КонецЕсли;
	СписокОбъектов = Новый СписокЗначений;
	Для каждого Объект Из Метаданные[Отчет.ТипДанных] Цикл
		Элементы.ИмяОбъекта.СписокВыбора.Добавить(Объект.Имя, Объект.Синоним);
	КонецЦикла;
	Элементы.ИмяОбъекта.СписокВыбора.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораТаблиц()
	Элементы.ИмяТаблицы.СписокВыбора.Очистить();
	Если НЕ ЗначениеЗаполнено(Отчет.ТипДанных) 
		ИЛИ НЕ ЗначениеЗаполнено(Отчет.ИмяОбъекта) Тогда
		Возврат;
	КонецЕсли;
	СписокВыбораТаблиц = Элементы.ИмяТаблицы.СписокВыбора;
	СписокВыбораТаблиц.Добавить("", "");
	Если Отчет.ТипДанных = "Документы" ИЛИ Отчет.ТипДанных = "Справочники" Тогда
		Для каждого ТабличнаяЧасть Из Метаданные[Отчет.ТипДанных][Отчет.ИмяОбъекта].ТабличныеЧасти Цикл
			СписокВыбораТаблиц.Добавить(ТабличнаяЧасть.Имя, ТабличнаяЧасть.Синоним);
		КонецЦикла;
	ИначеЕсли Отчет.ТипДанных = "РегистрыНакопления" Тогда
		Если Метаданные[Отчет.ТипДанных][Отчет.ИмяОбъекта].ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
			СписокВыбораТаблиц.Добавить("ОстаткиИОбороты", НСтр("ru='Остатки и обороты';uk='Залишки й обороти'"));
		Иначе
			СписокВыбораТаблиц.Добавить("Обороты", НСтр("ru='Обороты';uk='Обороти'"));
		КонецЕсли;
	ИначеЕсли Отчет.ТипДанных = "РегистрыСведений" Тогда 
		Если Метаданные[Отчет.ТипДанных][Отчет.ИмяОбъекта].ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		Иначе
			СписокВыбораТаблиц.Добавить("СрезПоследних", НСтр("ru='Срез последних';uk='Зріз останніх'"));
			СписокВыбораТаблиц.Добавить("СрезПервых",    НСтр("ru='Срез первых';uk='Зріз перших'"));
		КонецЕсли;
	ИначеЕсли Отчет.ТипДанных = "РегистрыБухгалтерии" Тогда
		СписокВыбораТаблиц.Добавить("ОстаткиИОбороты",   НСтр("ru='Остатки и обороты';uk='Залишки й обороти'"));
		СписокВыбораТаблиц.Добавить("Остатки",           НСтр("ru='Остатки';uk='Залишки'"));
		СписокВыбораТаблиц.Добавить("Обороты",           НСтр("ru='Обороты';uk='Обороти'"));
		СписокВыбораТаблиц.Добавить("ОборотыДтКт",       НСтр("ru='Обороты Дт/Кт';uk='Обороти Дт/Кт'"));
		СписокВыбораТаблиц.Добавить("ДвиженияССубконто", НСтр("ru='Движения с субконто';uk='Рухи з субконто'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИсточникПриИзмененииНаСервере(ИмяИсточника)
	Если ИмяИсточника = "ТипДанных" Тогда
		ОбновитьСписокВыбораОбъектов();
		УстановитьПоУмолчаниюОбъект();
	КонецЕсли;
	Если ИмяИсточника = "ТипДанных" ИЛИ ИмяИсточника = "ИмяОбъекта" Тогда
		ОбновитьСписокВыбораТаблиц();
		УстановитьПоУмолчаниюТаблицу();
	КонецЕсли;
	ИнициализироватьОтчет(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОтчет(ОчиститьНастройки = Ложь)
	
	Если ПустаяСтрока(Отчет.ТипДанных) ИЛИ ПустаяСтрока(Отчет.ИмяОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОчиститьНастройки Тогда
		Отчет.Группировка.Очистить();
	КонецЕсли;
	
	СКД = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	СКД.ПоляИтога.Очистить();

	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	СКД.НаборыДанных[0].Запрос = Отчеты.УниверсальныйОтчетПоМетаданным.СформироватьЗапросПоМетаданным(ПараметрыОтчета);
	Отчеты.УниверсальныйОтчетПоМетаданным.ДобавитьПоляНабораДанных(ПараметрыОтчета, СКД);
	
 	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);	
 
 	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Отчет.КомпоновщикНастроек.Восстановить(); 
    Отчет.КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	Если ОчиститьНастройки Тогда
		Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
		
		Отчеты.УниверсальныйОтчетПоМетаданным.ЗаполнитьСтруктуруПоУмолчанию(ПараметрыОтчета, Отчет.КомпоновщикНастроек);
		Отчеты.УниверсальныйОтчетПоМетаданным.ДобавитьПоказатели(ПараметрыОтчета, Отчет.КомпоновщикНастроек);
	КонецЕсли;
	
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
		Отчет.КомпоновщикНастроек, "Title", Метаданные[Отчет.ТипДанных][Отчет.ИмяОбъекта].Синоним);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
		Отчет.КомпоновщикНастроек, "TitleOutput", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
		Отчет.КомпоновщикНастроек, "FilterOutput", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
		Отчет.КомпоновщикНастроек, "DataParametersOutput", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ВыборПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Выбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Выбор"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
	
	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВыборПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		
		Если Элемент.ТекущаяСтрока = Неопределено Тогда
			ТекущаяСтрока = Неопределено;
		Иначе
			ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Выбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		КонецЕсли;

		Если ТипЗнч(ТекущаяСтрока) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			ЭлементВыбора = ТекущаяСтрока.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			Если ТекущаяСтрока.Родитель <> Неопределено Тогда
				ЭлементВыбора = ТекущаяСтрока.Родитель.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			Иначе
				ЭлементВыбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			КонецЕсли;
		Иначе
			ЭлементВыбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		КонецЕсли;
		ЭлементВыбора.Поле =  Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		
		Элемент.ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Выбор.ПолучитьИдентификаторПоОбъекту(ЭлементВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПередНачаломИзменения(Форма, Элемент, Отказ)
	
	Если Найти(Элемент.ТекущийЭлемент.Имя, "ВыборПоле") > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"          , "Выбор");
		ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Выбор"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"  , Элемент.ТекущиеДанные.Поле);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Элемент", Элемент);
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
		   		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;	
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		РедактируемаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Выбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		
		РедактируемаяСтрока.Использование = Истина;
		РедактируемаяСтрока.Поле          = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
    Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ИнициализацияЭлементовФормы();
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	// Сохраним настройки выбранных полей
	Отчет.КомпоновщикНастроек.Настройки.Выбор.ИдентификаторПользовательскойНастройки = "Выбор";
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Отчет.КомпоновщикНастроек.Настройки.Выбор.ИдентификаторПользовательскойНастройки = "Выбор";
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	Отчет.КомпоновщикНастроек.Настройки.Выбор.ИдентификаторПользовательскойНастройки = "";
	
	ОбновитьСписокВыбораОбъектов();
	ОбновитьСписокВыбораТаблиц();
    СписокВыбораТаблиц = Элементы.ИмяТаблицы.СписокВыбора;
	Элементы.ИмяТаблицы.Видимость = СписокВыбораТаблиц.Количество() > 1;
		
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
		
	ИнициализироватьОтчет();
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяОбъектаПриИзменении(Элемент)
	
	Отчет.ИмяТаблицы = "";
	
	ИсточникПриИзмененииНаСервере("ИмяОбъекта");
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяТаблицыПриИзменении(Элемент)
	
	ИнициализироватьОтчет(Истина);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДанныхПриИзменении(Элемент)
	
	Отчет.ИмяОбъекта = "";
	Отчет.ИмяТаблицы = "";
	ИсточникПриИзмененииНаСервере("ТипДанных");
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

// Показатели

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиВыборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ВыборПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиВыборПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиВыборПередНачаломИзменения(Элемент, Отказ)
	
	ВыборПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

// Оформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьПериод(Команда)
			
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
		
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

