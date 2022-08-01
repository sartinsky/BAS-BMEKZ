#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборОсновныхСредств.Форма.Форма" Тогда
		ОбработкаВыбораПодборСервер(ВыбранноеЗначение);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ПодготовитьФормуНаСервере();

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	ТребуетсяВызовСервера = Ложь;

	// Проверим наличие строк в табличной части.
	Если Объект.ОС.Количество() > 0 Тогда
		ТребуетсяВызовСервера = НЕ ЗначениеЗаполнено(МаксПериодПервоначальныхСведенийОС) 
			ИЛИ (МаксПериодПервоначальныхСведенийОС >= Объект.Дата);
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	ЗаполнитьРеквизитыТЧ();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) И Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьРеквизитыТЧ();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСПриИзменении(Элемент)

	Если Элементы.ОС.ТекущиеДанные <> Неопределено Тогда
		РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование = Истина Тогда
		СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
		СтрокаТЧ.СтоимостьПоДаннымУчета = 0;
		СтрокаТЧ.НаличиеПоДаннымУчета   = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)

	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	СтрокаТЧ.СтоимостьПоДаннымУчета = 0;
	СтрокаТЧ.НаличиеПоДаннымУчета   = Ложь;

	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
		СтрокаТЧ.МОЛ = Неопределено;
	Иначе
		ДополнительныеПоля = ПолучитьДополнительныеПоляОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, ДополнительныеПоля);
		МаксПериодПервоначальныхСведенийОС = Макс(МаксПериодПервоначальныхСведенийОС, ДополнительныеПоля.Период);
		
		СтрокаТЧ.БалансоваяСтоимость = СтрокаТЧ.СтоимостьПоДаннымУчета - СтрокаТЧ.НакопленнаяАмортизация;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСНаличиеФактическоеПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.ОС.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.НаличиеФактическое Тогда
		Если ТекущаяСтрокаТЧ.СтоимостьФактическая = 0 Тогда
			ТекущаяСтрокаТЧ.СтоимостьФактическая = ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета;
		КонецЕсли;
	Иначе
		ТекущаяСтрокаТЧ.СтоимостьФактическая = 0;
	КонецЕсли;

	РассчитатьВычисляемыеПоляПоСтроке(ТекущаяСтрокаТЧ);

КонецПроцедуры

&НаКлиенте
Процедура ОССтоимостьФактическаяПриИзменении(Элемент)

	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ОСНаличиеПоДаннымУчетаПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.ОС.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.НаличиеПоДаннымУчета Тогда
		Если ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета = 0 Тогда
			ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета = ТекущаяСтрокаТЧ.СтоимостьФактическая;
		КонецЕсли;
	Иначе
		ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета = 0;
	КонецЕсли;

	РассчитатьВычисляемыеПоляПоСтроке(ТекущаяСтрокаТЧ);

КонецПроцедуры

&НаКлиенте
Процедура ОССтоимостьПоДаннымУчетаПриИзменении(Элемент)

	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборОС(Команда)

	ПараметрыФормы = Новый Структура;
	Если Объект.ОС.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("АдресОСВХранилище", ПоместитьОСВХранилище());
	КонецЕсли;

	ОткрытьФорму("Обработка.ПодборОсновныхСредств.Форма.Форма", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборСервер(Знач ВыбранноеЗначение)

	ДобавленныеСтроки = УчетОС.ОбработатьПодборОсновныхСредств(Объект.ОС, ВыбранноеЗначение);
	ЗаполнитьРеквизитыТЧ();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)

	Если НЕ ПродолжитьЗаполнениеИзОстатков() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ОС.Количество() <> 0 Тогда 
		ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!
|Продолжить?';uk='При заповненні існуючі дані будуть перераховані!
|Продовжити?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоОстаткамЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;

    ЗаполнитьПоОстаткамСервер();
КонецПроцедуры

&НаКлиенте
Функция ПродолжитьЗаполнениеИзОстатков()

	ОчиститьСообщения();

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоОстаткамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьПоОстаткамСервер();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамСервер()

	Объект.ОС.Очистить();

	ТаблицаОС = ОстаткиОС();

	Для каждого СтрокаОС Из ТаблицаОС Цикл
		НоваяСтрока = Объект.ОС.Добавить();
		НоваяСтрока.ОсновноеСредство        = СтрокаОС.ОсновноеСредство;
		НоваяСтрока.СтоимостьПоДаннымУчета  = СтрокаОС.ВосстановительнаяСтоимость;
		НоваяСтрока.СчетУчета               = СтрокаОС.СчетУчета;
		НоваяСтрока.НаличиеПоДаннымУчета    = Истина;
		НоваяСтрока.СтоимостьФактическая    = 0;
		НоваяСтрока.НаличиеФактическое      = Ложь;
		РассчитатьВычисляемыеПоляПоСтроке(НоваяСтрока);
	КонецЦикла;

	ЗаполнитьРеквизитыТЧ();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеУчета(Команда)

	Если НЕ ПродолжитьЗаполнениеИзОстатков() Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ОС.Количество() <> 0 Тогда 
		ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!
|Продолжить?';uk='При заповненні існуючі дані будуть перераховані!
|Продовжити?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьДанныеУчетаЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	
    ЗаполнитьДанныеУчетаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеУчетаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьДанныеУчетаСервер();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеУчетаСервер()

	СписокОС = Объект.ОС.Выгрузить(, "ОсновноеСредство");

	ТаблицаОС = ОстаткиОС(СписокОС);
	ТаблицаОС.Индексы.Добавить("ОсновноеСредство");

	Для каждого СтрокаОС Из Объект.ОС Цикл
		ОстатокОС = ТаблицаОС.Найти(СтрокаОС.ОсновноеСредство, "ОсновноеСредство");
		Если ОстатокОС <> Неопределено Тогда
			СтрокаОС.СтоимостьПоДаннымУчета = ОстатокОС.ВосстановительнаяСтоимость;
			СтрокаОС.НаличиеПоДаннымУчета   = Истина;
			СтрокаОС.СчетУчета   			= ОстатокОС.СчетУчета;
		Иначе
			СтрокаОС.СтоимостьПоДаннымУчета = 0;
			СтрокаОС.НаличиеПоДаннымУчета   = Ложь;
		КонецЕсли;
		РассчитатьВычисляемыеПоляПоСтроке(СтрокаОС);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактическиеДанные(Команда)

	ОчиститьСообщения();
	Если Объект.ОС.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='Табличная часть по основным средствам пуста';uk='Таблична частина по основним засобам порожня'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!
|Продолжить?';uk='При заповненні існуючі дані будуть перераховані!
|Продовжити?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьФактическиеДанныеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактическиеДанныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    Для каждого СтрокаОС Из Объект.ОС Цикл
        СтрокаОС.СтоимостьФактическая = СтрокаОС.СтоимостьПоДаннымУчета;
        СтрокаОС.НаличиеФактическое   = СтрокаОС.НаличиеПоДаннымУчета;
        РассчитатьВычисляемыеПоляПоСтроке(СтрокаОС);
    КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСоставКомиссии(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента= Объект.Дата;

	ЗаполнитьРеквизитыТЧ();

	Для каждого Строка Из Объект.ОС Цикл
		РассчитатьВычисляемыеПоляПоСтроке(Строка);
	КонецЦикла;

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыТЧ()

	ТаблицаОС = Объект.ОС.Выгрузить();

	ТаблицаНомеров = УчетОС.ПолучитьТаблицуИнвентарныхНомеровОС(ТаблицаОС,
		Объект.Организация, Объект.Дата);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаНомеров.ВыгрузитьКолонку("ИнвентарныйНомер"), "ИнвентарныйНомер");

	ТаблицаМОЛ = ПолучитьТаблицуМОЛОС(ТаблицаОС, Объект.Организация, Объект.Дата, Объект.МОЛ);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаМОЛ.ВыгрузитьКолонку("МОЛ"), "МОЛ");
	
	ТаблицаПараметрыОС = ПолучитьТаблицуПараметрыОС(ТаблицаОС, Объект.Организация, Объект.Дата);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаПараметрыОС.ВыгрузитьКолонку("НакопленнаяАмортизация"), "НакопленнаяАмортизация");
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаПараметрыОС.ВыгрузитьКолонку("СрокПолезногоИспользования"), "СрокПолезногоИспользования");

	ТаблицаСчетУчета = ПолучитьТаблицуСчетУчетаОС(ТаблицаОС, Объект.Организация, Объект.Дата);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаСчетУчета.ВыгрузитьКолонку("СчетУчета"), "СчетУчета");

	Объект.ОС.Загрузить(ТаблицаОС);

	// Запомним максимальную дату первоначальных сведений ОС
	ТаблицаНомеров.Сортировать("Период");
	Если ТаблицаНомеров.Количество() > 0 Тогда
		МаксПериодПервоначальныхСведенийОС = ТаблицаНомеров[ТаблицаНомеров.Количество() - 1].Период;
	Иначе
		МаксПериодПервоначальныхСведенийОС = '0001-01-01';
	КонецЕсли;
	
	Если ТаблицаМОЛ.Количество() > 0 Тогда
		ТаблицаМОЛ.Сортировать("Период");
		МаксПериодПервоначальныхСведенийОС = Макс(МаксПериодПервоначальныхСведенийОС, 
			ТаблицаМОЛ[ТаблицаМОЛ.Количество()-1].Период);
	КонецЕсли;
	
	Если ТаблицаСчетУчета.Количество() > 0 Тогда
		ТаблицаСчетУчета.Сортировать("Период");
		МаксПериодПервоначальныхСведенийОС = Макс(МаксПериодПервоначальныхСведенийОС, 
			ТаблицаСчетУчета[ТаблицаСчетУчета.Количество()-1].Период);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ОстаткиОС(Знач СписокОС = Неопределено)

	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("ДатаОстатков",  Объект.Дата);
	Запрос.УстановитьПараметр("Организация",   Объект.Организация);
	Запрос.УстановитьПараметр("Подразделение", Объект.ПодразделениеОрганизации);
	Запрос.УстановитьПараметр("СписокОС",      СписокОС);

	Запрос.УстановитьПараметр("МОЛ", Объект.МОЛ);
	

	УсловиеОС = ?(ЗначениеЗаполнено(СписокОС), "И ОсновноеСредство В(&СписокОС)", "");
	УсловиеПодразделение = ?(ЗначениеЗаполнено(Объект.ПодразделениеОрганизации), " И Местонахождение = &Подразделение", "");
	УсловиеМОЛ = ?(ЗначениеЗаполнено(Объект.МОЛ), " И МОЛ = &МОЛ", "");

	Запрос.Текст =
	"ВЫБРАТЬ
	|	МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство КАК ОсновноеСредство,
	|	МестонахождениеОСБухгалтерскийУчет.Местонахождение КАК Местонахождение
	|ПОМЕСТИТЬ МестонахождениеОСБУ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&ДатаОстатков) КАК МестонахождениеОСБухгалтерскийУчет
	|ГДЕ
	|	Организация = &Организация " + УсловиеОС + УсловиеПодразделение + УсловиеМОЛ + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МестонахождениеОСБУ.ОсновноеСредство КАК ОсновноеСредство,
	|	МестонахождениеОСБУ.Местонахождение КАК ПодразделениеОрганизации,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчета
	|ПОМЕСТИТЬ ОсновныеСредства
	|	ИЗ
	|		МестонахождениеОСБУ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(&ДатаОстатков, Организация = &Организация
	|																				 " + УсловиеОС + ") КАК СчетаБухгалтерскогоУчетаОССрезПоследних
	|		ПО МестонахождениеОСБУ.ОсновноеСредство = СчетаБухгалтерскогоУчетаОССрезПоследних.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ХозрасчетныйОстатки_ВосстановительнаяСтоимость.СуммаОстатокДт, 0) КАК ВосстановительнаяСтоимость,
	|	ХозрасчетныйОстатки_ВосстановительнаяСтоимость.Счет КАК СчетУчета,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки_ВосстановительнаяСтоимость.Субконто1 КАК Справочник.ОсновныеСредства) КАК ОсновноеСредство
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&ДатаОстатков,
	|			Счет В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ОсновныеСредства.СчетУчета
	|				ИЗ
	|					ОсновныеСредства),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация
	|				И (ВЫРАЗИТЬ(Субконто1 КАК Справочник.ОсновныеСредства)) В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ОсновныеСредства.ОсновноеСредство
	|					ИЗ
	|						ОсновныеСредства)) КАК ХозрасчетныйОстатки_ВосстановительнаяСтоимость";

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТаблицуМОЛОС(Знач ТаблицаОС, Знач Организация, Знач Дата, Знач Мол)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаОС", ТаблицаОС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство КАК ОсновноеСредство,
	|	МестонахождениеОСБухгалтерскийУчет.МОЛ,
	|	МестонахождениеОСБухгалтерскийУчет.Период
	|ПОМЕСТИТЬ ТаблицаМОЛ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						ТаблицаОС.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК ТаблицаОС)) КАК МестонахождениеОСБухгалтерскийУчет
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЕСТЬNULL(ТаблицаМОЛ.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ,
	|	ЕСТЬNULL(ТаблицаМОЛ.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК Период
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаМОЛ КАК ТаблицаМОЛ
	|		ПО ТаблицаОС.ОсновноеСредство = ТаблицаМОЛ.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить();

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТаблицуПараметрыОС(Знач ТаблицаОС, Знач Организация, Знач Дата)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаОС", ТаблицаОС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("СубконтоОС", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПараметрыАмортизацииОСБухгалтерскийУчет.ОсновноеСредство КАК ОсновноеСредство,
	|	ПараметрыАмортизацииОСБухгалтерскийУчет.СрокПолезногоИспользования,
	|	ЕСТЬNULL(АмортизацияОС.СуммаОстатокКт, 0) КАК НакопленнаяАмортизация,
	|	ПараметрыАмортизацииОСБухгалтерскийУчет.Период
	|ПОМЕСТИТЬ ТаблицаПараметрыОС
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						ТаблицаОС.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК ТаблицаОС)) КАК ПараметрыАмортизацииОСБухгалтерскийУчет
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&Дата,
	|				Счет В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						СчетаБУ.СчетНачисленияАмортизации
	|					ИЗ
	|						РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(&Дата, Организация = &Организация
	|							И ОсновноеСредство В 
	|							(ВЫБРАТЬ
	|								ТаблицаОС.ОсновноеСредство
	|							ИЗ
	|								ТаблицаОС КАК ТаблицаОС)) КАК СчетаБУ),
	|				&СубконтоОС,
	|				Организация = &Организация
	|					И Субконто1 В 
	|							(ВЫБРАТЬ
	|								ТаблицаОС.ОсновноеСредство
	|							ИЗ
	|								ТаблицаОС КАК ТаблицаОС)) КАК АмортизацияОС
	|		ПО ПараметрыАмортизацииОСБухгалтерскийУчет.ОсновноеСредство = АмортизацияОС.Субконто1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЕСТЬNULL(ТаблицаПараметрыОС.СрокПолезногоИспользования, 0) КАК СрокПолезногоИспользования,
	|	ЕСТЬNULL(ТаблицаПараметрыОС.НакопленнаяАмортизация, 0) КАК НакопленнаяАмортизация,
	|	ЕСТЬNULL(ТаблицаПараметрыОС.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК Период
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПараметрыОС КАК ТаблицаПараметрыОС
	|		ПО ТаблицаОС.ОсновноеСредство = ТаблицаПараметрыОС.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить();

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТаблицуСчетУчетаОС(Знач ТаблицаОС, Знач Организация, Знач Дата)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаОС", ТаблицаОС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетаБухгалтерскогоУчетаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	СчетаБухгалтерскогоУчетаОС.СчетУчета,
	|	СчетаБухгалтерскогоУчетаОС.Период
	|ПОМЕСТИТЬ ТаблицаСчетУчета
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						ТаблицаОС.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК ТаблицаОС)) КАК СчетаБухгалтерскогоУчетаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЕСТЬNULL(ТаблицаСчетУчета.СчетУчета, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)) КАК СчетУчета,
	|	ЕСТЬNULL(ТаблицаСчетУчета.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК Период
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСчетУчета КАК ТаблицаСчетУчета
	|		ПО ТаблицаОС.ОсновноеСредство = ТаблицаСчетУчета.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить();

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМОЛОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)

	СведенияМОЛ = Новый Структура;
	СведенияМОЛ.Вставить("МОЛ", 	Справочники.ФизическиеЛица.ПустаяСсылка());
	СведенияМОЛ.Вставить("Период", 	'0001-01-01');

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(МестонахождениеОСБухгалтерскийУчет.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ,
	|	МестонахождениеОСБухгалтерскийУчет.Период
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчет";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СведенияМОЛ.МОЛ 	= Выборка.МОЛ;
		СведенияМОЛ.Период 	= Выборка.Период;
	КонецЕсли;

	Возврат СведенияМОЛ;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПараметрыОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)

	СведенияПараметрыОС = Новый Структура;
	СведенияПараметрыОС.Вставить("НакопленнаяАмортизация", 	0);
	СведенияПараметрыОС.Вставить("СрокПолезногоИспользования", 	0);
	СведенияПараметрыОС.Вставить("Период", 	'0001-01-01');

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("СубконтоОС",    	  ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПараметрыАмортизацииОСБухгалтерскийУчет.Период КАК Период,
	|	ПараметрыАмортизацииОСБухгалтерскийУчет.ОсновноеСредство КАК ОсновноеСредство,
	|	ЕСТЬNULL(ПараметрыАмортизацииОСБухгалтерскийУчет.СрокПолезногоИспользования, 0) КАК СрокПолезногоИспользования,
	|	ЕСТЬNULL(АмортизацияОС.СуммаОстатокКт, 0) КАК НакопленнаяАмортизация
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В (&ОсновноеСредство)) КАК ПараметрыАмортизацииОСБухгалтерскийУчет
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&Дата,
	|				Счет В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						СчетаБУ.СчетНачисленияАмортизации
	|					ИЗ
	|						РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(&Дата, Организация = &Организация
	|							И ОсновноеСредство В (&ОсновноеСредство)) КАК СчетаБУ),
	|				&СубконтоОС,
	|				Организация = &Организация
	|					И Субконто1 В (&ОсновноеСредство)) КАК АмортизацияОС
	|		ПО ПараметрыАмортизацииОСБухгалтерскийУчет.ОсновноеСредство = АмортизацияОС.Субконто1";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СведенияПараметрыОС.НакопленнаяАмортизация 	= Выборка.НакопленнаяАмортизация;
		СведенияПараметрыОС.СрокПолезногоИспользования 	= Выборка.СрокПолезногоИспользования;
		СведенияПараметрыОС.Период 	= Выборка.Период;
	КонецЕсли;

	Возврат СведенияПараметрыОС;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСчетУчетаОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)

	СведенияСчетОС = Новый Структура();
	СведенияСчетОС.Вставить("СчетУчета", 	ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	СведенияСчетОС.Вставить("Период", 		'0001-01-01');

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(СчетаБухгалтерскогоУчетаОС.СчетУчета, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)) КАК СчетУчета,
	|	СчетаБухгалтерскогоУчетаОС.Период
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОС";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СведенияСчетОС.СчетУчета 	= Выборка.СчетУчета;
		СведенияСчетОС.Период 		= Выборка.Период;
	КонецЕсли;

	Возврат СведенияСчетОС;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДополнительныеПоляОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)

	СведенияОбИнвентарномНомереОС = УчетОС.СведенияОбИнвентарномНомереОС(ОсновноеСредство,
		Организация, Дата);
	
	СведенияМОЛ 	= ПолучитьМОЛОС(ОсновноеСредство, Организация, Дата);
	СведенияСчетОС 	= ПолучитьСчетУчетаОС(ОсновноеСредство, Организация, Дата);
	
	СведенияПараметрыОС = ПолучитьПараметрыОС(ОсновноеСредство, Организация, Дата);
		
	МаксПериод = Макс(СведенияОбИнвентарномНомереОС.Период,
		СведенияМОЛ.Период, СведенияСчетОС.Период);

	Результат = Новый Структура;
	Результат.Вставить("ИнвентарныйНомер", 	СведенияОбИнвентарномНомереОС.ИнвентарныйНомер);
	Результат.Вставить("МОЛ", 				СведенияМОЛ.МОЛ);
	Результат.Вставить("СчетУчета", 		СведенияСчетОС.СчетУчета);
	Результат.Вставить("Период", 			МаксПериод);
	
	Если СведенияПараметрыОС <> Неопределено Тогда
		Результат.Вставить("НакопленнаяАмортизация", СведенияПараметрыОС.НакопленнаяАмортизация);
		Результат.Вставить("СрокПолезногоИспользования", СведенияПараметрыОС.СрокПолезногоИспользования);
	КонецЕсли;	

	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьВычисляемыеПоляПоСтроке(Строка)

	РазницаПоНаличию   = Число(Строка.НаличиеФактическое) - Число(Строка.НаличиеПоДаннымУчета);
	РазницаПоСтоимости = Строка.СтоимостьФактическая - Строка.СтоимостьПоДаннымУчета;

	Строка.ИзлишекКоличество = ?(РазницаПоНаличию > 0, РазницаПоНаличию, 0);
	Строка.НедостачаКоличество = ?(РазницаПоНаличию < 0, -РазницаПоНаличию, 0);
	Строка.ИзлишекСумма = ?(РазницаПоСтоимости > 0, РазницаПоСтоимости, 0);
	Строка.НедостачаСумма = ?(РазницаПоСтоимости < 0, -РазницаПоСтоимости, 0);
	
	Строка.БалансоваяСтоимость = Строка.СтоимостьПоДаннымУчета - Строка.НакопленнаяАмортизация;

КонецПроцедуры

&НаСервере
Функция ПоместитьОСВХранилище()

	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаОС);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

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