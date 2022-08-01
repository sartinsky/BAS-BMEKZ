#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// Уведомим о появлении функционала рабочей даты
	ЭтаФорма.НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	 
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента = ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента
	 	И ЭтаФорма.Параметры.Ключ.Пустая()
	  	И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));

	// Активизировать первую непустую табличную часть
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокТабличныхЧастей.Добавить("Остатки",      	"Остатки");
	СписокТабличныхЧастей.Добавить("Расчеты", 		"Расчеты");
	СписокТабличныхЧастей.Добавить("Вывоз",      	"Вывоз");
	
	АктивизироватьТабличнуюЧасть = ОбщегоНазначенияБПВызовСервера.ПолучитьПервуюНепустуюВидимуюТабличнуюЧасть(ЭтаФорма, СписокТабличныхЧастей);
		ОбщегоНазначенияБПВызовСервера.АктивизироватьЭлементФормы(ЭтаФорма, АктивизироватьТабличнуюЧасть);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
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
	
	ЗаполнитьДобавленныеКолонкиТаблицыСформированныеДокументы();

	УстановитьСостояниеДокумента();
	
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
	ТребуетсяВызовСервера = ИНАГРО_ЭлеваторКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата,ТекущаяДатаДокумента);
	
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
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
		
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда				
		
		ПараметрыОтбораДоговора = ПолучитьПараметрыДляДоговоров();
		
		ИНАГРО_ЭлеваторЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(Объект.Дата, Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента, ПараметрыОтбораДоговора);				
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПолучилПоДругомуДокументуПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеДвиженияФормы36НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.ОписаниеДвиженияФормы36",
		НСтр("ru='Описание движения формы 36';uk='Опис руху форми 36'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыРасчеты

&НаКлиенте
Процедура РасчетыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Расчеты.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, Цена"); 	
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, ДоговорКонтрагента, ТипЦен");	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
	РасчетыНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ТекущиеДанные.Цена = ДанныеСтрокиТаблицы.Цена;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура РасчетыНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)
	
	СтрокаТабличнойЧасти.Цена = Ценообразование.ПолучитьЦенуНоменклатуры(СтрокаТабличнойЧасти.Номенклатура,
	                                                                     ДанныеОбъекта.ТипЦен,
																		 ДанныеОбъекта.Дата,
																		 ДанныеОбъекта.ДоговорКонтрагента.ВалютаВзаиморасчетов);

КонецПроцедуры

&НаКлиенте
Процедура РасчетыКоличествоПриИзменении(Элемент)
	
	РасчетыКоличествоЦенаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыЦенаПриИзменении(Элемент)
	
	РасчетыКоличествоЦенаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыКоличествоЦенаПриИзменении()
	
	ТекущиеДанные = Элементы.Расчеты.ТекущиеДанные;
	
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыВывоз

&НаКлиенте
Процедура ВывозПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		
		ТекущиеДанные = Элементы.Вывоз.ТекущиеДанные;
		
		НоменклатураВ = ТекущиеДанные.Номенклатура; 
		СкладВ        = ТекущиеДанные.Склад;
		УрожайВ       = ТекущиеДанные.Урожай;
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Вывоз Цикл
			
			Если НоменклатураВ <> СтрокаТабличнойЧасти.Номенклатура Тогда
				Продолжить;
			КонецЕсли;
			Если СкладВ <> СтрокаТабличнойЧасти.Склад Тогда
				Продолжить;
			КонецЕсли;
			Если УрожайВ <> СтрокаТабличнойЧасти.Урожай Тогда
				Продолжить;
			КонецЕсли;
			Если ТекущиеДанные.НомерСтроки = СтрокаТабличнойЧасти.НомерСтроки Тогда
				Продолжить;
			КонецЕсли;	
			
			ТекущиеДанные.Количество = СтрокаТабличнойЧасти.Количество - СтрокаТабличнойЧасти.КоличествоФасовки; 
			
		КонецЦикла;
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ВывозВидФасовкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Вывоз.ТекущиеДанные;
	
	ВидФасовки        = ТекущиеДанные.ВидФасовки;
	УслугаВидаФасовки = ПолучитьУслугуВидаФасовки(ВидФасовки);
	
	Если ЗначениеЗаполнено(ВидФасовки) Тогда
		
		Если ЗначениеЗаполнено(УслугаВидаФасовки) Тогда
			ТекущиеДанные.Услуга = УслугаВидаФасовки;
		Иначе
			ТекущиеДанные.Услуга = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
			ТекстСообщения = НСтр("ru='В видах фасовки не заполнена тара.';uk='У видах фасування не заповнена тара.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;		
			
	Иначе
		
		ТекущиеДанные.Услуга         = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ТекущиеДанные.КоличествоТара = 0;
		ТекущиеДанные.Цена           = 0;
		ТекущиеДанные.Сумма          = 0;		
			
	КонецЕсли;
	
	ДанныеСтрокиТаблицы = Новый Структура("Урожай, Услуга");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, Контрагент,
		|ДоговорКонтрагента, Номенклатура");	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ТекущиеДанные.Цена = ПолучитьЦенуУслугиЭлеватора(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ВывозКоличествоФасовкиПриИзменении(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ВывозУслугаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Вывоз.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура("Урожай, Услуга");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, Контрагент,
		|ДоговорКонтрагента, Номенклатура");	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ТекущиеДанные.Цена = ПолучитьЦенуУслугиЭлеватора(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывозКоличествоФасовкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Вывоз.ТекущиеДанные;
	
	ВидФасовки     = ТекущиеДанные.ВидФасовки;
	
	Если НЕ ЗначениеЗаполнено(ВидФасовки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.КоличествоФасовки > ТекущиеДанные.Количество Тогда
		ТекущиеДанные.КоличествоФасовки = ТекущиеДанные.Количество;
	КонецЕсли;	
	
	ВесВидаФасовки = ПолучитьВесВидаФасовки(ВидФасовки);

	ТекущиеДанные.КоличествоТара    = ?(ВесВидаФасовки = 0, 0, Цел(ТекущиеДанные.КоличествоФасовки / ВесВидаФасовки));
	ТекущиеДанные.КоличествоФасовки = ТекущиеДанные.КоличествоТара * ВесВидаФасовки; 
	ТекущиеДанные.Сумма             = ТекущиеДанные.Цена * ТекущиеДанные.КоличествоТара;
	
	Объект.ТараДолг = Объект.Вывоз.Итог("Сумма")
	
КонецПроцедуры

&НаКлиенте
Процедура ВывозКоличествоТараПриИзменении(Элемент)
	
	ВывозКоличествоТараЦенаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ВывозЦенаПриИзменении(Элемент)
	
	ВывозКоличествоТараЦенаПриИзменении();
		
КонецПроцедуры

&НаКлиенте
Процедура ВывозСуммаПриИзменении(Элемент)
	
	Объект.ТараДолг = Объект.Вывоз.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура ВывозКоличествоТараЦенаПриИзменении()
	
	ТекущиеДанные = Элементы.Вывоз.ТекущиеДанные;	
	
	ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.КоличествоТара;
	
	Объект.ТараДолг = Объект.Вывоз.Итог("Сумма");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьОстатки(Команда)
	
	ПолучитьОстаткиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьОстаткиНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИНАГРО_ОстаткиОстатки.Номенклатура КАК Номенклатура,
		|	ИНАГРО_ОстаткиОстатки.ВесОстаток КАК Количество,
		|	ИНАГРО_ОстаткиОстатки.Склад КАК Склад,
		|	ИНАГРО_ОстаткиОстатки.Урожай КАК Урожай,
		|	ИНАГРО_ОстаткиОстатки.ВидФасовки КАК ВидФасовки,
		|	ЛОЖЬ КАК ФасовкаОстатки
		|ИЗ
		|	РегистрНакопления.ИНАГРО_Остатки.Остатки(
		|			&Период,
		|			Организация = &Организация
		|				И Владелец = &Владелец
		|				И Договор = &Договор) КАК ИНАГРО_ОстаткиОстатки";
	
	Запрос.УстановитьПараметр("Период",      Объект.Дата);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Владелец",    Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор",     Объект.ДоговорКонтрагента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Объект.Остатки.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Остатки.Добавить();
		НоваяСтрока.Номенклатура = Выборка.Номенклатура;
		НоваяСтрока.Склад        = Выборка.Склад;
		НоваяСтрока.Урожай       = Выборка.Урожай;
		НоваяСтрока.Количество   = Выборка.Количество;
		Если НЕ ЗначениеЗаполнено(Выборка.ВидФасовки) Тогда  
			НоваяСтрока.Фасовка = Ложь;
		Иначе
			НоваяСтрока.Фасовка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет = &Счет,
		|			&ПорядокСубконто,
		|			Организация = &Организация
		|				И Субконто1 = &Контрагент
		|				И Субконто2 = &Договор) КАК ХозрасчетныйОстатки";
	
	ПорядокСубконто = Новый Массив();
	ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос.УстановитьПараметр("Период",          Объект.Дата);
	Запрос.УстановитьПараметр("Организация",     Объект.Организация);
	Запрос.УстановитьПараметр("Контрагент",      Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор",         Объект.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Счет",            ПланыСчетов.Хозрасчетный.РасчетыСОтечественнымиПокупателями);
	Запрос.УстановитьПараметр("ПорядокСубконто", ПорядокСубконто);

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Объект.ОбщийДолг = 0; 
	Иначе 
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			Объект.ОбщийДолг = Выборка.СуммаОстаток;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Пересчитать(Команда)
		
	Объект.Взаиморасчеты = Объект.ОбщийДолг + Объект.ТараДолг - Объект.РасчетСуммой - Объект.Расчеты.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьОстатки(Команда)
	
	СкопироватьОстаткиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьОстаткиНаСервере()
	
	Дата                 = Объект.Дата;
	ТипЦен               = Объект.ТипЦен;
	ВалютаВзаиморасчетов = Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	
	Объект.Расчеты.Очистить();
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Остатки Цикл
		
		Если СтрокаТабличнойЧасти.Фасовка Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.Расчеты.Добавить();
		НоваяСтрока.Номенклатура = СтрокаТабличнойЧасти.Номенклатура;
		НоваяСтрока.Склад        = СтрокаТабличнойЧасти.Склад;
		НоваяСтрока.Урожай       = СтрокаТабличнойЧасти.Урожай;
		НоваяСтрока.Количество   = СтрокаТабличнойЧасти.Количество;
		НоваяСтрока.Цена         = Ценообразование.ПолучитьЦенуНоменклатуры(НоваяСтрока.Номенклатура, ТипЦен, Дата, ВалютаВзаиморасчетов);
		НоваяСтрока.Сумма        = НоваяСтрока.Цена * СтрокаТабличнойЧасти.Количество;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьВывоз(Команда)
	
	ПодготовитьВывозНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьВывозНаСервере()
	
	Объект.Вывоз.Очистить();
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Остатки Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
		
		НайденнаяСтрока = Объект.Расчеты.НайтиСтроки(Отбор);		
		Количество      = СтрокаТабличнойЧасти.Количество;
		
		Если НайденнаяСтрока.Количество() <> 0 Тогда
			
			Количество = СтрокаТабличнойЧасти.Количество - НайденнаяСтрока[0].Количество;
			
			Если Количество <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		НоваяСтрока = Объект.Вывоз.Добавить();
		НоваяСтрока.Номенклатура = СтрокаТабличнойЧасти.Номенклатура;
		НоваяСтрока.Склад        = СтрокаТабличнойЧасти.Склад;
		НоваяСтрока.Урожай       = СтрокаТабличнойЧасти.Урожай;
		НоваяСтрока.Количество   = СтрокаТабличнойЧасти.Количество;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументы(Команда)
	
	СформироватьДокументыНаСервере();
	
	Если Объект.ОткрыватьДокументы Тогда
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.СформированныеДокументы Цикл
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ", СтрокаТабличнойЧасти.Документ);
			
			ИмяДокумента = ПолучитьИмяСформированногоДокумента(СтрокаТабличнойЧасти.Документ);
			
			Если ИмяДокумента = "ИНАГРО_АктФасовки" ИЛИ  ИмяДокумента = "ИНАГРО_ПриказНаВывоз" Тогда 
				ИмяФормыДокумента = ".Форма.ФормаДокументаОбщая";
			Иначе
				ИмяФормыДокумента = ".Форма.ФормаДокумента";
			КонецЕсли;
			
			ОткрытьФорму("Документ." + ИмяДокумента + ИмяФормыДокумента, ПараметрыФормы, , УникальныйИдентификатор, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура СформироватьДокументыНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.СформироватьДокументы();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЗаполнитьДобавленныеКолонкиТаблицыСформированныеДокументы();
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции	

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;		

	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьДобавленныеКолонкиТаблицыСформированныеДокументы();

	УправлениеФормой(ЭтаФорма);

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;	
		
	Элементы.ГруппаРеквизитыДоверенностиЛевая.Видимость = НЕ Объект.ПолучилПоДругомуДокументу; 
	Элементы.ДокументПодтверждающийПолномочия.Видимость = Объект.ПолучилПоДругомуДокументу;	
		
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблицыСформированныеДокументы()
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СформированныеДокументы Цикл			
		ЗаполнитьДобавленныеКолонкиСтрокиТаблицыСформированныеДокументы(СтрокаТабличнойЧасти);		
	КонецЦикла;		
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицыСформированныеДокументы(СтрокаТабличнойЧасти)
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Документ) Тогда
		Если СтрокаТабличнойЧасти.Документ.Проведен Тогда
			СтрокаТабличнойЧасти.ИндексКартинки = 1;
		ИначеЕсли СтрокаТабличнойЧасти.Документ.ПометкаУдаления Тогда
			СтрокаТабличнойЧасти.ИндексКартинки = 2;
		Иначе
			СтрокаТабличнойЧасти.ИндексКартинки = 0;
		КонецЕсли; 
	КонецЕсли; 			
		
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыДляДоговоров()
	
	ПараметрыОтбора = Новый Структура("ВидХранения, Урожай");
	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Объект);
	
	Возврат ПараметрыОтбора;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЦенуУслугиЭлеватора(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)
	
	ВидКультурыДляРасчетаСтоимостиУслуги = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(ДанныеОбъекта.Номенклатура, "ВидКультуры").ВидКультурыДляРасчетаСтоимостиУслуги;
	
	Цена = ИНАГРО_Элеватор.ПолучитьЦенуУслугиЭлеватора(ДанныеОбъекта.Организация,
	                                                   ДанныеОбъекта.Дата, 
													   ДанныеОбъекта.Контрагент,
													   ДанныеОбъекта.ДоговорКонтрагента,
													   ВидКультурыДляРасчетаСтоимостиУслуги,
													   СтрокаТабличнойЧасти.Урожай,
													   СтрокаТабличнойЧасти.Услуга);
	
	Возврат Цена;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьУслугуВидаФасовки(ВидФасовки)
	
	УслугаВидаФасовки = ВидФасовки.Услуга;
	
	Возврат УслугаВидаФасовки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВесВидаФасовки(ВидФасовки)
	
	ВесВидаФасовки = ВидФасовки.Вес;
	
	Возврат ВесВидаФасовки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяСформированногоДокумента(ДокументСсылка)
	
	ИмяДокумента = ДокументСсылка.Метаданные().Имя;
	
	Возврат ИмяДокумента;
	
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