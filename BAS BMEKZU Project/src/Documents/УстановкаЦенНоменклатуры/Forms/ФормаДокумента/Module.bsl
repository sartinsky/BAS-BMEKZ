#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.НеПроводитьНулевыеЗначения = Истина;
	КонецЕсли;

	УстановитьСостояниеДокумента();	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда	
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбработанаТабличнаяЧастьТовары" И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		ОбработкаОповещенияОбработкиТабличнойЧастиТоварыНаСервере(Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
		УстановитьСостояниеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Элементы.Товары.ТекущиеДанные, ПриИзмененииНоменклатуры(
																ТекущиеДанные.Номенклатура, Объект.Дата, Объект.ТипЦен));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьПоПоступлению(Команда)

	ДокументПоступление = Неопределено;

	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ДобавитьПоПоступлениюЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоПоступлениюЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    // Теперь нужно выбрать документ, по которому будем заполнять
    ДокументПоступление = Результат;
    
    Если НЕ ЗначениеЗаполнено(ДокументПоступление) Тогда 
        Возврат; // ничего не выбрали.
    КонецЕсли;
    
    ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоЦенамНоменклатуры(Команда)
	
	ЗаполнитьТовары(Ложь, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГруппеНоменклатуры(Команда)

	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораГруппы",,,,,, Новый ОписаниеОповещения("ЗаполнитьПоГруппеНоменклатурыЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГруппеНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Группа = Результат;
    
    Если ЗначениеЗаполнено(Группа) Тогда
        ЗаполнитьТовары(Истина, Ложь, Истина, Группа);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНоменклатуре(Команда)
	
	ЗаполнитьТовары(Истина, Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлению(Команда)

	// Если заполняем, то почистим ТЧ
	Если Объект.Товары.Количество() > 0 Тогда
                       
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоПоступлениюЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
        Возврат;
	КонецЕсли;
	
	// Теперь нужно выбрать документ, по которому будем заполнять
	ЗаполнитьПоПоступлениюФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    Объект.Товары.Очистить();
    
    ЗаполнитьПоПоступлениюФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюФрагмент()
    
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ЗаполнитьПоПоступлениюФрагментЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюФрагментЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ДокументПоступление = Результат;
    
    Если НЕ ЗначениеЗаполнено(ДокументПоступление) Тогда 
        Возврат; // ничего не выбрали.
    КонецЕсли;
    
    ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЦенамНоменклатуры(Команда)

	ЗаполнитьТовары(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПоЦенамНоменклатуры(Команда)

	ЗаполнитьТовары(Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТовары(Команда)
	
	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора, 
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьТовары(Команда)

	ПараметрыФормы = ПолучитьПараметрыОбработкиТабличнойЧастиТовары();
	
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ИзменениеТаблицыТоваров.Форма.Форма", ПараметрыФормы,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьТовары(Очистить, Обновить, ПоНоменклатуре = Ложь, Группа = Неопределено)
	
	Если Объект.Товары.Количество() <> 0 
		И Очистить Тогда
		
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьТоварыЗавершение", ЭтотОбъект, Новый Структура("Группа, Обновить, Очистить, ПоНоменклатуре", Группа, Обновить, Очистить, ПоНоменклатуре)), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
        Возврат; 

	КонецЕсли;
	
	ЗаполнитьТоварыФрагмент(Группа, Обновить, Очистить, ПоНоменклатуре);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТоварыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Группа = ДополнительныеПараметры.Группа;
    Обновить = ДополнительныеПараметры.Обновить;
    Очистить = ДополнительныеПараметры.Очистить;
    ПоНоменклатуре = ДополнительныеПараметры.ПоНоменклатуре;
    
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    
    ЗаполнитьТоварыФрагмент(Группа, Обновить, Очистить, ПоНоменклатуре);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТоварыФрагмент(Знач Группа, Знач Обновить, Знач Очистить, Знач ПоНоменклатуре)
    
    ЗаполнитьТоварыСервер(Очистить, Обновить, ПоНоменклатуре, Группа);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыСервер(Очистить, Обновить, ПоНоменклатуре = Ложь, Группа = Неопределено)
	
	Если Очистить Тогда
		Объект.Товары.Очистить();
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним все требуемые реквизиты
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЦен", Объект.Дата);
	Запрос.УстановитьПараметр("ТипЦен",  Объект.ТипЦен);
	Запрос.УстановитьПараметр("Ложь",    Ложь);
	Запрос.УстановитьПараметр("Группа",  Группа);
	Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.ТипЦен,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Валюта,
	|	ЦеныНоменклатурыСрезПоследних.Цена
	|ПОМЕСТИТЬ ВТЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаЦен, ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатуры.Цена ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ ЦеныНоменклатуры.Цена
	|	КОНЕЦ КАК Цена,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатуры.Валюта ЕСТЬ NULL 
	|			ТОГДА ТипыЦенСправочник.ВалютаЦены
	|		ИНАЧЕ ЦеныНоменклатуры.Валюта
	|	КОНЕЦ КАК Валюта
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ПО СправочникНоменклатура.Ссылка = ЦеныНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыЦенНоменклатуры КАК ТипыЦенСправочник
	|		ПО (ЦеныНоменклатуры.ТипЦен = ТипыЦенСправочник.Ссылка)
	|ГДЕ
	|	СправочникНоменклатура.ЭтоГруппа = &Ложь";
	Если НЕ ПоНоменклатуре Тогда
		Текст = Текст + 
		" И
		|	ТипыЦенСправочник.Ссылка = &ТипЦен	
		|";
	КонецЕсли;
	Если ЗначениеЗаполнено(Группа) Тогда
		Текст = Текст + 
		" И
		|	СправочникНоменклатура.Ссылка В ИЕРАРХИИ (&Группа)
		|";
	КонецЕсли;
    Запрос.Текст = Текст;
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);
                                                                            
		СтрокиТабличнойЧасти = Объект.Товары.НайтиСтроки(СтруктураОтбора);
		Если СтрокиТабличнойЧасти.Количество() = 0 Тогда
			Если Обновить Тогда
				Продолжить;
			Иначе
				СтрокаТабличнойЧасти = Объект.Товары.Добавить();
				СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;
			КонецЕсли;
		Иначе
			СтрокаТабличнойЧасти = СтрокиТабличнойЧасти[0];
		КонецЕсли;
		СтрокаТабличнойЧасти.Цена   = Выборка.Цена;
		СтрокаТабличнойЧасти.Валюта = Выборка.Валюта;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Валюта) Тогда
			СтрокаТабличнойЧасти.Валюта = Объект.ТипЦен.ВалютаЦены;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Производит перезаполнение и установку необходимых полей в строке табличной части.
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части, которую необходимо перезаполнить.
//
&НаСервереБезКонтекста
Функция ПриИзмененииНоменклатуры(Номенклатура, Дата, ТипЦен)
	
	ВыходныеПараметры = новый Структура("Цена,Валюта");
	
	Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда

		// Ничего делать не надо
		Возврат ВыходныеПараметры;

	КонецЕсли;

	// Заполним все требуемые реквизиты
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЦен", Дата);
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныНоменклатуры.Цена КАК Цена,
	|	ЦеныНоменклатуры.Валюта КАК Валюта
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&ДатаЦен,
	|			ТипЦен = &ТипЦен
	|				И Номенклатура = &Номенклатура) КАК ЦеныНоменклатуры";

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ВыходныеПараметры.Цена   = 0;
		ВыходныеПараметры.Валюта = ТипЦен.ВалютаЦены;
	Иначе
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ВыходныеПараметры.Цена   = Выборка.Цена;
			ВыходныеПараметры.Валюта = Выборка.Валюта;
		КонецЦикла;
	КонецЕсли;

	Возврат ВыходныеПараметры;
	
КонецФункции

&НаСервере
// Процедура выполняет заполнение табличной части 
// копированием из выбранного пользователем документа Поступления.
//
// Параметры:
//  ДокументПоступление - Документ поступления, данными которого надо заполнить табличную часть.
//  ЧиститьТипыЦен      - Признак необходимости очистки типов цен перед заполнением.
//
Процедура ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление, ЧиститьТипыЦен = Истина)

	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("ДокументОснование", ДокументПоступление);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	Док.ВалютаДокумента КАК ВалютаДокумента,
	|	Док.ТипЦен КАК ТипЦен,
	|	ЕСТЬNULL(Док.ТипЦен.ЦенаВключаетНДС, Док.СуммаВключаетНДС) КАК ТипЦенЦенаВключаетНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Товары.Цена КАК Цена,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	МИНИМУМ(Товары.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.ЕдиницаИзмерения,
	|	Товары.Цена,
	|	Товары.СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Результаты = Запрос.ВыполнитьПакет();
	
	Шапка = Результаты[0].Выбрать();
	Шапка.Следующий();
	
	Выборка = Результаты[1].Выбрать();

	Пока Выборка.Следующий() Цикл

		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);

		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Товары", СтруктураОтбора);

		Если СтрокаТабличнойЧасти = Неопределено Тогда

			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;

		КонецЕсли;
		Коэффициент = Справочники.Номенклатура.ПолучитьКоэффициентЕдиницыИзмерения(Выборка.Номенклатура, Выборка.ЕдиницаИзмерения);
		ЦенаЗаБазовуюЕдиницуТовара = Выборка.Цена / Коэффициент;
		
		СтрокаТабличнойЧасти.Цена  = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
		                                        ЦенаЗаБазовуюЕдиницуТовара,
		                                        Шапка.СуммаВключаетНДС,
		                                        Шапка.ТипЦенЦенаВключаетНДС,
		                                        УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Выборка.СтавкаНДС));

		СтрокаТабличнойЧасти.Валюта =  Шапка.ВалютаДокумента;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьТабличнуюЧастьПоПоступлению()

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	ЗаголовокПодбора = НСтр("ru='Подбор номенклатуры в %1 (%2)';uk='Підбір номенклатури %1 (%2)'");
	
	Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		Параметрыформы.Вставить("ПоказыватьЦены", Истина);
	КонецЕсли;
	
	Если ИмяТаблицы = "Товары" Тогда
		ПредставлениеТаблицы = НСтр("ru='Товары';uk='Товари'");
		
		ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
		ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
	КонецЕсли;
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);

	ПараметрыФормы.Вставить("ЕстьЦена"    	, Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Ложь);
	ПараметрыФормы.Вставить("ДатаРасчетов"	, ДатаРасчетов);
	ПараметрыФормы.Вставить("ТипЦен"      	, Объект.ТипЦен);
	ПараметрыФормы.Вставить("Заголовок"   	, ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"  	, ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"  	, ИмяТаблицы);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)
	
	ВидПодбора = "";
	
	Возврат ВидПодбора;	

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		СтруктураОтбора = Новый Структура("Номенклатура", СтрокаТовара.Номенклатура);
		СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти(ИмяТаблицы, СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли - новую не добавляем.
		Иначе
			
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара);
		КонецЕсли;		
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуТабличнойЧасти(ИмяТабличнойЧасти, СтруктураОтбора)

	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

&НаСервере
Функция ПоместитьТоварыВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыОбработкиТабличнойЧастиТовары()

	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("АдресХранилищаТовары", 		ПоместитьТоварыВоВременноеХранилищеНаСервере());
	ПараметрыОбработки.Вставить("ЗаполнятьЦеныПоПокупке", 		Ложь);
	
	ПараметрыОбработки.Вставить("ДокументСсылка", 				Объект.Ссылка);
	ПараметрыОбработки.Вставить("ДокументДата", 				Объект.Дата);
	ПараметрыОбработки.Вставить("ДокументТипЦен", 				Объект.ТипЦен);

	Возврат ПараметрыОбработки;
	
КонецФункции 

&НаСервере
Процедура ОбработкаОповещенияОбработкиТабличнойЧастиТоварыНаСервере(Параметры)
	
	ТаблицаОбработки = ПолучитьИзВременногоХранилища(Параметры.АдресОбработаннойТабличнойЧастиТоварыВХранилище);
	Объект.Товары.Загрузить(ТаблицаОбработки);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти