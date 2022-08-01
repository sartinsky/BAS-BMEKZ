#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Дата = ТекущаяДатаСеанса();
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// Уведомим о появлении функционала рабочей даты
	ЭтаФорма.НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	 
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента = ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента
	 	И ЭтаФорма.Параметры.Ключ.Пустая()
	  	И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры // ПриСозданииНаСервере

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриЧтенииНаСервере

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	УстановитьЗаголовокФормы();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьСостояниеДокумента();

КонецПроцедуры // ПослеЗаписиНаСервере

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда	
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаВыбора

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		УстановитьДоступностьКомандыВставки(ЭтотОбъект, Истина);
	КонецЕсли;
	
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
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;

	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры // ДатаПриИзменении

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры // ДатаПриИзмененииНаСервере

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	ЗаполнениеДокументов.ПриИзмененииЗначенияОрганизации(Объект, Пользователи.ТекущийПользователь());
	
	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры // ОрганизацияПриИзмененииНаСервере

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстВопроса = НСтр("ru='Перезаполнить учетные количества и суммы? %ПредупреждениеОЗаписиДокумента%';uk='Перезаповнити облікові кількості і суми? %ПредупреждениеОЗаписиДокумента%'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ПредупреждениеОЗаписиДокумента%", 
						?(Модифицированность, Символы.ПС + НСтр("ru='(Перед заполнением документ будет записан!)';uk='(Перед заповненням документ буде записаний!)'"), 
						""));
		Если Объект.Товары.Количество() = 0  Тогда 
			СкладПриИзмененииНаСервере(Ложь);
			Возврат;
		КонецЕсли;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("СкладПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Да Тогда	
        СкладПриИзмененииНаСервере(Истина);
    Иначе 	
        СкладПриИзмененииНаСервере(Ложь);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере(Перезаполнять)

	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "ТипСклада");
	Объект.ОтветственноеЛицо = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(Объект.Склад, Объект.Дата);
	
	Если ЗначениеЗаполнено(Объект.ОтветственноеЛицо) И Перезаполнять Тогда
		ПерезаполнитьУчетныеКоличестваНаСервере();
	КонецЕсли;
	
	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры // СкладПриИзмененииНаСервере

&НаКлиенте
Процедура ОтветственноеЛицоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ОтветственноеЛицо) Тогда
		Если Объект.Товары.Количество() = 0 Тогда
			ОтветственноеЛицоПриИзмененииНаСервере(Ложь);
			Возврат;
		КонецЕсли;	
		
		ТекстВопроса = НСтр("ru='Перезаполнить учетные количества и суммы? %ПредупреждениеОЗаписиДокумента%';uk='Перезаповнити облікові кількості і суми? %ПредупреждениеОЗаписиДокумента%'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ПредупреждениеОЗаписиДокумента%", 
				?(Модифицированность, Символы.ПС + НСтр("ru='(Перед заполнением документ будет записан!)';uk='(Перед заповненням документ буде записаний!)'"), 
				""));
		ПоказатьВопрос(Новый ОписаниеОповещения("ОтветственноеЛицоПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственноеЛицоПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Да Тогда;
        ОтветственноеЛицоПриИзмененииНаСервере(Истина);
    Иначе 
        ОтветственноеЛицоПриИзмененииНаСервере(Ложь);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОтветственноеЛицоПриИзмененииНаСервере(Перезаполнять)
	
	Если ЗначениеЗаполнено(Объект.Склад) И ЗначениеЗаполнено(Объект.ОтветственноеЛицо) Тогда
		Отбор = Новый Структура("СтруктурнаяЕдиница", Объект.Склад);
		СрезПоследних   = РегистрыСведений.ОтветственныеЛица.СрезПоследних(Объект.Дата, Отбор);
		
		Если СрезПоследних.Количество() = 0 Тогда
			Объект.Склад = Справочники.Склады.ПустаяСсылка();
		Иначе
			Если Объект.ОтветственноеЛицо <> СрезПоследних[0].ФизическоеЛицо Тогда
				Объект.Склад = Справочники.Склады.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Склад) ИЛИ ЗначениеЗаполнено(Объект.ОтветственноеЛицо) Тогда	
		Если Перезаполнять Тогда
			ПерезаполнитьУчетныеКоличестваНаСервере();
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиСобытийТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		Элемент.ТекущиеДанные.Отклонение = Элемент.ТекущиеДанные.Количество 
											- Элемент.ТекущиеДанные.КоличествоУчет;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, СчетУчетаБУ, ЕдиницаИзмерения, Коэффициент,
		|Количество, КоличествоУчет,
		|Цена, ЦенаВРознице,
		|Сумма, СуммаУчет,
		|Отклонение");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ТоварыНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры // ТоварыНоменклатураПриИзменении

&НаСервереБезКонтекста
Процедура ТоварыНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)
	
	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СведенияОНоменклатуре.БазоваяЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Коэффициент			= СведенияОНоменклатуре.Коэффициент;
	
	СтрокаТабличнойЧасти.Цена = 0;
	
	РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	
	Документы.ИнвентаризацияТоваровНаСкладе.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Товары", СведенияОНоменклатуре);
	
	ЗаполнитьДобавленныеКолонкиСтрокиТаблицыТовары(СтрокаТабличнойЧасти);
	
КонецПроцедуры // ТоварыНоменклатураПриИзмененииНаСервере

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, СчетУчетаБУ, ЕдиницаИзмерения, Коэффициент,
		|Количество, КоличествоУчет,
		|Цена, ЦенаВРознице,
		|Сумма, СуммаУчет,
		|Отклонение");
		
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ТоварыЕдиницаИзмеренияПриИзмененииНаСервере(ДанныеСтрокиТаблицы);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры // ТоварыЕдиницаИзмеренияПриИзменении

&НаСервереБезКонтекста
Процедура ТоварыЕдиницаИзмеренияПриИзмененииНаСервере(СтрокаТабличнойЧасти)
	
	СтароеЗначениеКоэффициента = СтрокаТабличнойЧасти.Коэффициент;
	
	ОбработкаТабличныхЧастей.ЗаполнитьКоэффициентТабЧасти(СтрокаТабличнойЧасти);
	
	СтрокаТабличнойЧасти.КоличествоУчет = СтрокаТабличнойЧасти.КоличествоУчет * СтароеЗначениеКоэффициента 
											 / СтрокаТабличнойЧасти.Коэффициент;

	СтрокаТабличнойЧасти.Количество     = СтрокаТабличнойЧасти.Количество * СтароеЗначениеКоэффициента 
											 / СтрокаТабличнойЧасти.Коэффициент;
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);

	ЗаполнитьДобавленныеКолонкиСтрокиТаблицыТовары(СтрокаТабличнойЧасти);

КонецПроцедуры // ТоварыЕдиницаИзмеренияПриИзмененииНаСервере

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	СтрокаТабличнойЧасти.Сумма = РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУчетПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.СуммаУчет = Элементы.Товары.ТекущиеДанные.Цена 
											* Элементы.Товары.ТекущиеДанные.КоличествоУчет;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	СтрокаТабличнойЧасти.Цена = ?(СтрокаТабличнойЧасти.Количество = 0, 0, 
									СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоОстаткамЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок);
        Возврат; 
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИНАГРО_СчетУчетаБУ) Тогда // ИНАГРО
		ИНАГРО_ЗаполнитьПоОстаткамНаСервере();
	Иначе
		ЗаполнитьПоОстаткамНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Если ЗначениеЗаполнено(Объект.ИНАГРО_СчетУчетаБУ) Тогда // ИНАГРО
			ИНАГРО_ЗаполнитьПоОстаткамНаСервере();
		Иначе
			ЗаполнитьПоОстаткамНаСервере();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьУчетныеДанные(Команда)
	
	Если Объект.Товары.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ТекстВопроса = НСтр("ru='Перезаполнить учетные количества и суммы? %ПредупреждениеОЗаписиДокумента%';uk='Перезаповнити облікові кількості і суми? %ПредупреждениеОЗаписиДокумента%'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ПредупреждениеОЗаписиДокумента%", 
		?(Модифицированность, Символы.ПС + НСтр("ru='(Перед заполнением документ будет записан!)';uk='(Перед заповненням документ буде записаний!)'"), 
		""));
	ПоказатьВопрос(Новый ОписаниеОповещения("ПерезаполнитьУчетныеДанныеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьУчетныеДанныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
        ПерезаполнитьУчетныеКоличестваНаСервере();
    КонецЕсли;

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
Процедура ВыбратьСоставКомиссии(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры // ВыбратьСоставКомиссии

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	ИмяТаблицы = ПолучитьИмяТекущейТабличнойЧасти();
	Если ПустаяСтрока(ИмяТаблицы) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	КоличествоСтрок = Элементы[ИмяТаблицы].ВыделенныеСтроки.Количество();
	Если КоличествоСтрок = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	СкопироватьСтрокиНаСервере(ИмяТаблицы);
	ОбработкаТабличныхЧастейКлиент.ОповеститьОКопированииСтрокВБуферОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	ИмяТаблицы = ПолучитьИмяТекущейТабличнойЧасти();
	Если ПустаяСтрока(ИмяТаблицы) Тогда
		
		Возврат;
		
	КонецЕсли;
	КоличествоСтрок = ВставитьСтрокиНаСервере(ИмяТаблицы);
	ОбработкаТабличныхЧастейКлиент.ОповеститьОВставкеСтрокИзБуфераОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента	= Объект.Дата;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "ТипСклада");
	
	УстановитьЗаголовокФормы();

	УправлениеФормой(ЭтаФорма);

	ЗаполнитьДобавленныеКолонкиТаблиц();

	УстановитьСостояниеДокумента();
	
	// Проверка буфера обмена на наличие скопированных строк
	УстановитьДоступностьКомандыВставки(ЭтотОбъект, Не ОбщегоНазначения.ПустойБуферОбмена());
	
КонецПроцедуры // ПодготовитьФормуНаСервере

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	УчетВПродажныхЦенах	= (УчетнаяПолитика.СпособОценкиТоваровВРознице(Объект.Организация, Объект.Дата)
		= Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости);
	
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "ТипСклада");
	Если ТипСклада <> Перечисления.ТипыСкладов.ОптовыйСклад
		И УчетВПродажныхЦенах Тогда
		РассчитыватьСуммаВРознице = Истина;
	Иначе
		РассчитыватьСуммаВРознице = Ложь;
	КонецЕсли;

	НТТ = (ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);
	

КонецПроцедуры // УстановитьФункциональныеОпцииФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы     = Форма.Элементы;
	ОбъектФормы  = Форма.Объект;
	
	Элементы.ТоварыЦенаВРознице.Видимость 	   = Форма.НТТ;
	Элементы.ТоварыЦена.Видимость 		       = НЕ Форма.НТТ;
	
КонецПроцедуры // УправлениеФормой

&НаСервере
Процедура УправлениеФормойНаСервере() Экспорт
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры // УправлениеФормойНаСервере

&НаСервере
Процедура УстановитьЗаголовокФормы() Экспорт
	
	ОбъектФормы = ЭтаФорма.Объект;

	ТекстЗаголовка = НСтр("ru='Инвентаризация товаров на складе';uk='Інвентаризація товарів на складі'");
	
	Если ЗначениеЗаполнено(ОбъектФормы.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2';uk=' %1 від %2'"), ОбъектФормы.Номер, ОбъектФормы.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru=' (создание)';uk=' (створення)'");
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ТекстЗаголовка;

КонецПроцедуры // УстановитьЗаголовокФормы

// Заполняет табличную часть данными регистра бухгалтерии
//	Используется процедура из модуля объекта
//
// Параметры
//  Нет
//
&НаСервере
Процедура ЗаполнитьПоОстаткамНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Товары.Очистить();
	ДокументОбъект.ЗаполнитьПоОстаткамНаСкладе();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

// Заполняет табличную часть данными регистра бухгалтерии
//	Используется процедура из модуля объекта
//
// Параметры
//  Нет
//
&НаСервере
Процедура ПерезаполнитьУчетныеКоличестваНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	Если ДокументОбъект.Модифицированность() Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	ДокументОбъект.ПерезаполнитьУчетныеКоличества();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере(ИмяТабличнойЧасти = "")

	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Товары" Тогда
		Документы.ИнвентаризацияТоваровНаСкладе.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Товары");
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	Для каждого СтрокаТаблицы Из Объект.Товары Цикл
		ЗаполнитьДобавленныеКолонкиСтрокиТаблицыТовары(СтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицыТовары(СтрокаТаблицы)

	СтрокаТаблицы.Отклонение = СтрокаТаблицы.Количество - СтрокаТаблицы.КоличествоУчет;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	ЗаголовокПодбора = НСтр("ru='Подбор номенклатуры в %1 (%2)';uk='Підбір номенклатури %1 (%2)'");
	
	Если ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка") Тогда
		Параметрыформы.Вставить("ПоказыватьЦены", Истина);
	КонецЕсли;
	
	ПредставлениеТаблицы = НСтр("ru='Товары';uk='Товари'");
	
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы.Вставить("ЕстьЦена"      , Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"        , ВалютаРегламентированногоУчета);
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");
	
	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)
	
	ВидПодбора = "";
	
	Если ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка") Тогда
		ВидПодбора = "НТТ";
	КонецЕсли;
	
	Возврат ВидПодбора;	

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		
		ТаблицаТоваров = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
		
	Иначе
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
		
	КонецЕсли;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
		
	КоличествоДобавленныхСтрок = 0;
		
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтрокаТабличнойЧасти = Неопределено;
		Если Не ЭтоВставкаИзБуфера Тогда
		
			СтруктураОтбора = Новый Структура("Номенклатура, Цена, ЕдиницаИзмерения", СтрокаТовара.Номенклатура, СтрокаТовара.Цена, СтрокаТовара.ЕдиницаИзмерения);
			СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти(ИмяТаблицы, СтруктураОтбора);
			
		КонецЕсли;
			
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли - увеличиваем количество.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
			
			ЗаполнитьДобавленныеКолонкиСтрокиТаблицыТовары(СтрокаТабличнойЧасти);
			РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
		Иначе
			
			Если ЭтоВставкаИзБуфера
				И БухгалтерскийУчетПереопределяемый.НоменклатураЯвляетсяУслугой(СтрокаТовара.Номенклатура) Тогда
					
				Продолжить;
					
			КонецЕсли;
			
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
			КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок + 1;
			
			Если НЕ (ЭтоВставкаИзБуфера 
				И Найти(СписокСвойств, "СчетУчетаБУ") <> 0 
				И ЗначениеЗаполнено(СтрокаТовара["СчетУчетаБУ"])) Тогда
			
				СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТабличнойЧасти.Номенклатура);
				Документы.ИнвентаризацияТоваровНаСкладе.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
					ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТаблицы, СчетаУчета);
			КонецЕсли;
			
			ЗаполнитьДобавленныеКолонкиСтрокиТаблицыТовары(СтрокаТабличнойЧасти);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭтоВставкаИзБуфера Тогда
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок;
	КонецЕсли

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РассчитатьСуммуТабЧасти(Знач СтрокаТабличнойЧасти)
	
	ЦенаУчет = Неопределено;
	
	Если СтрокаТабличнойЧасти.КоличествоУчет <> 0 Тогда
		ЦенаУчет = СтрокаТабличнойЧасти.СуммаУчет / СтрокаТабличнойЧасти.КоличествоУчет;
	КонецЕсли;
	
	Если ЦенаУчет <> Неопределено И СтрокаТабличнойЧасти.Цена = Окр(ЦенаУчет, 2) Тогда
		Сумма = СтрокаТабличнойЧасти.СуммаУчет * СтрокаТабличнойЧасти.Количество / СтрокаТабличнойЧасти.КоличествоУчет;
	Иначе
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
		Сумма = СтрокаТабличнойЧасти.Сумма;
	КонецЕсли;
	
	Возврат Сумма;
	
КонецФункции

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
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ИНАГРО_ЗаполнитьПоОстаткамНаСервере() // ИНАГРО
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Товары.Очистить();
	ДокументОбъект.ИНАГРО_ЗаполнитьПоОстаткамНаСкладе();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

#Область КопированиеВставкаСтрокЧерезБуферОбмена

&НаСервере
Процедура СкопироватьСтрокиНаСервере(ИмяТаблицы)
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(Объект[ИмяТаблицы], 
		Элементы[ИмяТаблицы].ВыделенныеСтроки, Объект.Ссылка.Метаданные().Имя);

КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере(ИмяТаблицы)
	
	ПараметрыВставки = ОбработкаТабличныхЧастей.ПолучитьПараметрыВставкиДанныхИзБуфераОбмена(Объект.Ссылка, ИмяТаблицы);
	ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки);
	ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ПараметрыВставки, ПараметрыВставки.ИмяТаблицы);
	
	Возврат ПараметрыВставки.КоличествоДобавленныхСтрок;
	
КонецФункции

&НаКлиенте
Функция ПолучитьИмяТекущейТабличнойЧасти()
	
	Возврат "Товары";
	
КонецФункции

&НаСервере
Процедура ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки)

	СписокСвойств = Новый Массив;
	СписокСвойств.Добавить("Номенклатура");
	СписокСвойств.Добавить("ЕдиницаИзмерения");
	СписокСвойств.Добавить("Коэффициент");
	СписокСвойств.Добавить("Количество");
	СписокСвойств.Добавить("КоличествоУчет");
	СписокСвойств.Добавить("Цена");
	СписокСвойств.Добавить("ЦенаВРознице");
	СписокСвойств.Добавить("Сумма");
	СписокСвойств.Добавить("СуммаУчет");
	Если ПараметрыВставки.ПоказыватьВДокументахСчетаУчета Тогда
		СписокСвойств.Добавить("СчетУчетаБУ");
	КонецЕсли;
	
	ПараметрыВставки.СписокСвойств = ОбработкаТабличныхЧастей.ПолучитьСписокСвойствИмеющихсяВТаблицеДанных(
		ПараметрыВставки.Данные, СписокСвойств);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандыВставки(Форма, Доступность)

	Доступность = Не Форма.ТолькоПросмотр И Доступность;
	Элементы = Форма.Элементы;
	Элементы.ТоварыВставитьСтроки.Доступность					 = Доступность;
	Элементы.ТоварыКонтекстноеМенюВставитьСтроки.Доступность	 = Доступность;

КонецПроцедуры

#КонецОбласти

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