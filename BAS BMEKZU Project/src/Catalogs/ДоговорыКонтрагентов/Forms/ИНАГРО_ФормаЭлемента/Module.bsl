#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	СрокОплатыПокупателей = Константы.СрокОплатыПокупателей.Получить();
	СрокОплатыПоставщикам = Константы.СрокОплатыПоставщикам.Получить();

	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	Если Параметры.Свойство("ОткрытИзПлатежки") Тогда
		Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() И Параметры.Свойство("IDСтроки") И Параметры.Свойство("ОткрытИзПередачиПая") Тогда 		
		Параметры.Свойство("IDСтроки",            ИНАГРО_IDСтроки);
		Параметры.Свойство("ОткрытИзПередачиПая", ОткрытИзПередачиПая);	 		
	КонецЕсли;   
	
	// Ограничение списка выбора поля "Вид договора"
	
	Если Параметры.Свойство("ВидДоговораДоступныеЗначения") Тогда
		Элементы.ВидДоговора.РежимВыбораИзСписка = Истина;
		Элементы.ВидДоговора.СписокВыбора.ЗагрузитьЗначения(Параметры.ВидДоговораДоступныеЗначения);
	КонецЕсли;

	ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтаФорма);

	РеквизитыДоговора = ПолучитьСтрокуРеквизитовДоговора(Объект.Номер, Объект.Дата);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();

	УправлениеФормой(ЭтаФорма);

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// Подсистема "Свойства"
	Если ИмяСобытия = "ЗаписанаНоваяСхемаУчета" Тогда
		Объект.СхемаНалоговогоУчета = Параметр
	ИначеЕсли ИмяСобытия = "ЗаписьРегистраНормативнаяОценкаЗемли" Тогда
		ЗаполнитьДобавленныеКолонкиТаблиц(); 
	ИначеЕсли УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	Если Не Отказ И Объект.Ссылка.Пустая() Тогда
		
		СохраняемыеЗначенияРеквизитов = Новый Структура(
			"ВедениеВзаиморасчетов,ВедениеВзаиморасчетовНУ,ВалютаВзаиморасчетов,СложныйНалоговыйУчет,
			|ВидДеятельностиДляДДС,СхемаНалоговогоУчета,СхемаНалоговогоУчетаПоТаре,МногостороннееСоглашениеОРазделеПродукции");	
		ЗаполнитьЗначенияСвойств(СохраняемыеЗначенияРеквизитов, Объект);
		
		ХранилищеОбщихНастроек.Сохранить("ДоговорыКонтрагентов_СохраняемыеЗначенияРеквизитов",, СохраняемыеЗначенияРеквизитов);	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ОткрытИзПередачиПая Тогда		
		
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("СправочникСсылка", Объект.Ссылка);
		СтруктураВозврата.Вставить("IDСтроки",  	   ИНАГРО_IDСтроки); 		
		
		Оповестить("ПередачаПая_ВозвратДоговорКонтрагента", СтруктураВозврата, ЭтаФорма); 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.НаименованиеДляПечати) Тогда
		Объект.НаименованиеДляПечати = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	СформироватьНаименованиеДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	СформироватьНаименованиеДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора)
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее")) Тогда
		Объект.ТипЦен = Неопределено;
		Объект.СпособРасчетаКомиссионногоВознаграждения = Неопределено;
		Объект.ПроцентКомиссионногоВознаграждения = 0;
		Объект.УстановленСрокОплаты = Ложь;
		Объект.СрокОплаты = 0;
		Объект.СложныйНалоговыйУчет = Истина;
		УстановитьВедениеВзаиморасчетовНУ();
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора)
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"))
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом")) Тогда
		Если Объект.ВедениеВзаиморасчетов = ПредопределенноеЗначение("Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам") Тогда
			Объект.ВедениеВзаиморасчетов = ПредопределенноеЗначение("Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом");
			УстановитьВедениеВзаиморасчетовНУ();
		КонецЕсли;
	КонецЕсли;

	ЭтоДоговорПриобретения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));

	ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтаФорма);
	Если ЗначениеЗаполнено(Объект.СпособРасчетаКомиссионногоВознаграждения) Тогда
		Если Элементы.СпособРасчетаКомиссионногоВознаграждения.СписокВыбора.НайтиПоЗначению(Объект.СпособРасчетаКомиссионногоВознаграждения) = Неопределено Тогда
			Объект.СпособРасчетаКомиссионногоВознаграждения = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
    УстановитьСхемуНалогообложения();
	
	УстановитьРеквизитыНалоговыхДокументов();
	
	// ИНАГРО ++
	Если ЗначениеЗаполнено(Объект.ВидДоговора) 
		И Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаЗемли")
		И НЕ ЗначениеЗаполнено(Объект.ИНАГРО_КодНДФЛ) Тогда
		
		Объект.ИНАГРО_КодНДФЛ = ПредопределенноеЗначение("Справочник.ВидыДоходовНДФЛ.Код08");
			
	КонецЕсли;

	Если ЗначениеЗаполнено(Объект.ВидДоговора) 
		И Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаИмущества")
		И НЕ ЗначениеЗаполнено(Объект.ИНАГРО_КодНДФЛ) Тогда
		
		Объект.ИНАГРО_КодНДФЛ = ПредопределенноеЗначение("Справочник.ВидыДоходовНДФЛ.Код195");
			
	КонецЕсли;
	// ИНАГРО --
	
	УправлениеФормой(ЭтаФорма);

	// Возможна ситуация, когда, например, ВедениеВзаиморасчетовНУ = ПоРасчетнымДокументам, 
	// а при изменении на вид договора СКомиссионером или СКомитентом
	// он должен измениться на ПоДоговоруВЦелом (в целом не относится в этому ООП, но создавать другой смысла не вижу).
	УстановитьВедениеВзаиморасчетовНУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидВзаиморасчетовПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УстановленСрокОплатыПриИзменении(Элемент)

	Если Объект.УстановленСрокОплаты Тогда
		Если (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером")) Тогда
			Объект.СрокОплаты = СрокОплатыПокупателей;
		ИначеЕсли (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом")) Тогда
			Объект.СрокОплаты = СрокОплатыПоставщикам;
		КонецЕсли;
	Иначе
		СрокОплаты = 0;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");

КонецПроцедуры

&НаКлиенте
Процедура ВедениеВзаиморасчетовПриИзменении(Элемент)
	
	УстановитьВедениеВзаиморасчетовНУ();
		
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СложныйНалоговыйУчетПриИзменении(Элемент)
	
	УстановитьВедениеВзаиморасчетовНУ();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеСхемыУчета(Команда)
	
	ПараметрыФормы	= Новый Структура(
		"ТекущаяСтрока, ПараметрВыборГруппИЭлементов",
		Объект.СхемаНалоговогоУчета, ИспользованиеГруппИЭлементов.Элементы);
		
	ОткрытьФорму("Справочник.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ФормаВыбора", ПараметрыФормы, Элементы.СхемаНалоговогоУчета)	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	ВалютаРегламентированногоУчета = Форма.ВалютаРегламентированногоУчета;

	ЭтоДоговорКомиссии     = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));
		
	ЭтоДоговорПриобретения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"))
		ИЛИ (ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() И Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаЗемли")) 
		ИЛИ (ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() И Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаИмущества")); 
		
	ЭтоДоговорАренды       = ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ()
		И (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаЗемли")
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаИмущества")); 
		
	ЭтоДоговорРеализации   = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_КоммунальныеУслуги"); 
	
	ДоступностьКомиссионногоВознаграждения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));
		
	// Группа "Ведение взаиморасчетов"

	Элементы.УстановленСрокОплаты.Доступность = (Объект.ВидДоговора <> ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));

	Если Объект.УстановленСрокОплаты Тогда
		Элементы.ГруппаСтраницыСрокОплаты.ТекущаяСтраница = Элементы.ГруппаСрокОплатыУстановлен;
	Иначе
		Элементы.ГруппаСтраницыСрокОплаты.ТекущаяСтраница = Элементы.ГруппаСрокОплатыНеУстановлен;
	КонецЕсли;
	
	Если (ЭтоДоговорРеализации ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") ИЛИ ЭтоДоговорАренды) Тогда
		Элементы.ВедениеВзаиморасчетов.Доступность = Истина;
	Иначе
		Элементы.ВедениеВзаиморасчетов.Доступность	= Ложь;
	КонецЕсли;
	
	Элементы.ВедениеВзаиморасчетовНУ.Доступность = НЕ Объект.СложныйНалоговыйУчет И Объект.ВедениеВзаиморасчетов = ПредопределенноеЗначение("Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам");
	
	// Группа "Комиссионное вознаграждение"

	Элементы.ГруппаКомиссионноеВознаграждение.Доступность = ДоступностьКомиссионногоВознаграждения;
	
	// Группа "Аренда земли"

	Элементы.ГруппаАрендаЗемли.Видимость = ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ()
		И (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаЗемли")
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком")
		И Объект.ВидВзаиморасчетов = ПредопределенноеЗначение("Справочник.ВидыВзаиморасчетов.АрендаЗемли")));
		
	// Группа "Аренда имущества"

	Элементы.ГруппаАрендаИмущества.Видимость = (ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ()
		И Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ИНАГРО_АрендаИмущества"));
		
	// Группа "Элеватор"
		
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБЭМКЗУ() Тогда
		Если Объект.ВидВзаиморасчетов = ПредопределенноеЗначение("Справочник.ВидыВзаиморасчетов.ДоговорХранения") 
			ИЛИ Объект.ВидВзаиморасчетов = ПредопределенноеЗначение("Справочник.ВидыВзаиморасчетов.ДоговорПереработки") Тогда 
			Элементы.ГруппаЭлеватор.Видимость = Истина;
		Иначе 
			Элементы.ГруппаЭлеватор.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаЭлеватор.Видимость = Ложь;
	КонецЕсли;	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста                                       
Процедура ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;


	СписокСпособов = ОбщегоНазначенияБПКлиентСервер.СформироватьСписокСпособовРасчетаКомиссионногоВознаграждения();
	СписокВыбора = Элементы.СпособРасчетаКомиссионногоВознаграждения.СписокВыбора;
	СписокВыбора.Очистить();
	Для Каждого ЭлементСписка Из СписокСпособов Цикл
		СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтрокуРеквизитовДоговора(Номер, Дата)
	
	НомерДоговора = ?(ЗначениеЗаполнено(Номер), Номер, "");
	
	ДатаДоговора = ?(ЗначениеЗаполнено(Дата), НСтр("ru='от ';uk='від '",Локализация.КодЯзыкаИнформационнойБазы()) + Формат(Дата, "ДФ=dd.MM.yyyy"), "");
	
	Возврат НомерДоговора + ?(ПустаяСтрока(НомерДоговора), "", " ") + ДатаДоговора;
	
КонецФункции

&НаКлиенте
Процедура СформироватьНаименованиеДоговора()
	
	ТекстНаименования = Объект.Наименование;
	
	НовыеРеквизитыДоговора = ПолучитьСтрокуРеквизитовДоговора(Объект.Номер, Объект.Дата); 
	
	Если ПустаяСтрока(ТекстНаименования) Тогда
		ТекстНаименования = НовыеРеквизитыДоговора;
	ИначеЕсли Найти(ТекстНаименования, РеквизитыДоговора) > 0 Тогда
		ТекстНаименования = СтрЗаменить(ТекстНаименования, РеквизитыДоговора, НовыеРеквизитыДоговора);
	КонецЕсли;
	
	РеквизитыДоговора = НовыеРеквизитыДоговора;
	
	Если (Не ЗначениеЗаполнено(Объект.НаименованиеДляПечати)) ИЛИ (Объект.НаименованиеДляПечати = Объект.Наименование) Тогда
		Объект.НаименованиеДляПечати = ТекстНаименования;
	КонецЕсли;
	
	Объект.Наименование = ТекстНаименования;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВедениеВзаиморасчетовНУ()

	Если Объект.СложныйНалоговыйУчет  Тогда
		
		Объект.ВедениеВзаиморасчетовНУ = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом
		
	Иначе
		
		Объект.ВедениеВзаиморасчетовНУ = Объект.ВедениеВзаиморасчетов;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСхемуНалогообложения()
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
		Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомиссионером_НК;
		Объект.СложныйНалоговыйУчет = Истина;
	ИначеЕсли Объект.ВидДоговора =  Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
		Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомитентом_НК;
		Объект.СложныйНалоговыйУчет = Истина;
	ИначеЕсли Объект.ВидДоговора =  Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.Бартер;
	Иначе
		Если Не Объект.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
			Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ВЭД;		
		Иначе	
			Объект.СхемаНалоговогоУчета =  Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.ПоПервомуСобытию;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРеквизитыНалоговыхДокументов()
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Бартер;
	ИначеЕсли Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером
		  ИЛИ Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
	    Объект.ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Комиссия;
	Иначе
		Объект.ВидДоговораПоГК = Справочники.ВидыДоговоровПоГК.Поставка;
	КонецЕсли;	
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный Тогда
		Объект.ФормаРасчетов = НСтр("ru='Бартер';uk='Бартер'");  	
	Иначе		
		Объект.ФормаРасчетов = НСтр("ru='Оплата с текущего счета';uk='Оплата з поточного рахунку'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц() 
	
	Если Объект.ИНАГРО_СписокУчастков.Количество() > 0 Тогда
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.ИНАГРО_СписокУчастков Цикл
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Договор", Объект.Ссылка);
			ПараметрыОтбора.Вставить("Участок", СтрокаТабличнойЧасти.Участок);
			
			Значение = РегистрыСведений.ИНАГРО_НормативнаяОценкаЗемли.ПолучитьПоследнее( , ПараметрыОтбора);

			СтрокаТабличнойЧасти.Актуальность = Значение.Актуальность; 
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

