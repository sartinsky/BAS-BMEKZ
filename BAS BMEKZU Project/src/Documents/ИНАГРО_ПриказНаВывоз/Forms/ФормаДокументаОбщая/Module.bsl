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
		
	УстановитьПараметрыВыбораВидОперации();
	
	// Если форма вызвана в режиме смена вида операции - модифицируем сразу при открытии, 
	// чтобы можно было подтвердить или отказаться от изменения путем сохранения или 
	// отказа от сохранения документа.
	Если Параметры.Свойство("ИзменитьВидОперации")
		И Параметры.ИзменитьВидОперации Тогда
		
		// Не кэшируем переменную Объект, т.к. может вызываться Форма.ИзменитьРеквизиты(),
		// которая меняет Объект.
		Объект.ВидОперации = Параметры.ЗначенияЗаполнения.ВидОперации;
		
		УстановитьЗаголовокФормы();		
		УправлениеФормой(ЭтаФорма);
		
		Модифицированность = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если  ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		
		Если ИмяСобытия = "СозданЛабораторныйАнализ" ИЛИ ИмяСобытия = "ИзмененЛабораторныйАнализ" Тогда
			
			ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
			
			Если ИНАГРО_Элеватор.ЛабораторныйАнализПроверкаЗаполнения(Параметр.ДокументСсылка, ПолучитьПараметрыДляПроверкиЗаполнения(ТекущиеДанные)) Тогда				
				ТекущиеДанные.ЛабораторныйАнализ = Параметр.ДокументСсылка;
				КультурыЛабораторныйАнализПриИзменении(Неопределено);
				Модифицированность = Истина;
			КонецЕсли;

		КонецЕсли;
		
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИНАГРО_КонтрольПроцессов.КонтрольПриказаНаВывоз(ТекущийОбъект, Отказ);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	УстановитьЗаголовокФормы();	
		
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
	
	ДатаОкончанияДействияПриказаНовая = КонецДня(НачалоДня(Объект.Дата) + 86400 * СрокДействияПриказа);

	Если Объект.ДатаОкончанияДействияПриказа <> ДатаОкончанияДействияПриказаНовая Тогда		
		ТекстВопроса = НСтр("ru='Изменилась дата документа. Пересчитать дату окончания действия приказа?';uk='Змінилася дата документа. Перерахувати дату закінчення дії наказу?'");
		Оповещение = Новый ОписаниеОповещения("ДатаПриИзмененииЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);		
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ИНАГРО_ЭлеваторКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, ТекущаяДатаДокумента);
		
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
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
   	
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда 		
		Возврат;
	КонецЕсли;
	
	Объект.ДатаОкончанияДействияПриказа = ДатаОкончанияДействияПриказаНовая;
			
КонецПроцедуры  

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.Переоформление") Тогда
		Объект.ВидПеревозки = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыПеревозки.ПустаяСсылка"); 
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьОстаткиВТабличнойЧасти();
	
	УстановитьФункциональныеОпцииФормы();	
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		
		ПараметрыОтбораДоговора = ПолучитьПараметрыДляДоговоров();
		
		ИНАГРО_ЭлеваторЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(Объект.Дата, Объект.Организация, Объект.Владелец, Объект.ДоговорКонтрагента, ПараметрыОтбораДоговора);
				
		ВладелецПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииНаСервере()
	
	ЗаполнитьОстаткиВТабличнойЧасти();
	
	УстановитьФункциональныеОпцииФормы();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ЗаполнитьОстаткиВТабличнойЧасти();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()
	
	Объект.МестоХранения = Справочники.ИНАГРО_МестаХранения.ПустаяСсылка();
	
	ЗаполнитьОстаткиВТабличнойЧасти();

	УстановитьФункциональныеОпцииФормы(); 	
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВидХраненияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ВидХранения) Тогда
		
		ПараметрыОтбораДоговора = ПолучитьПараметрыДляДоговоров();
		
		ИНАГРО_ЭлеваторЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(Объект.Дата, Объект.Организация, Объект.Владелец, Объект.ДоговорКонтрагента, ПараметрыОтбораДоговора);		
		
		ЗаполнитьОстаткиВТабличнойЧасти();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УрожайПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Урожай) Тогда
		
		ПараметрыОтбораДоговора = ПолучитьПараметрыДляДоговоров();
		
		ИНАГРО_ЭлеваторЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(Объект.Дата, Объект.Организация, Объект.Владелец, Объект.ДоговорКонтрагента, ПараметрыОтбораДоговора);
		
		ЗаполнитьОстаткиВТабличнойЧасти();
		
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыКультуры

&НаКлиенте
Процедура КультурыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;	
	
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, ЕдиницаИзмерения, Остаток");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Организация, Владелец, ДоговорКонтрагента, 
		|Склад, ВидХранения, Урожай,
		|Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);	
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);
		
	КультурыНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);

	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КультурыНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, ДанныеОбъекта)
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.Номенклатура.БазоваяЕдиницаИзмерения;
	
	Документы.ИНАГРО_ПриказНаВывоз.ЗаполнитьОстаткиВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыФасовкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Фасовка) Тогда
		
		ДанныеСтрокиТаблицы = Новый Структура("Фасовка, Количество, ФизическийВес");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);		
				
		КультурыФасовкаПриИзмененииНаСервере(ДанныеСтрокиТаблицы);	
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
		
	КонецЕсли;		
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КультурыФасовкаПриИзмененииНаСервере(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.ФизическийВес = СтрокаТабличнойЧасти.Фасовка.Вес * СтрокаТабличнойЧасти.Количество;			
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Фасовка) Тогда
		
		ДанныеСтрокиТаблицы = Новый Структура("Фасовка, Количество, ФизическийВес");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);		
				
		КультурыКоличествоПриИзмененииНаСервере(ДанныеСтрокиТаблицы);	
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
		
	КонецЕсли;

	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КультурыКоличествоПриИзмененииНаСервере(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.ФизическийВес = СтрокаТабличнойЧасти.Фасовка.Вес * СтрокаТабличнойЧасти.Количество;			
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыЛабораторныйАнализПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные; 	
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"ЛабораторныйАнализ, НомерАнализа, Влажность, 
		|СорнаяПримесь, ЗерноваяПримесь, ЗачетныйВес");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные); 
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);

	ИНАГРО_Элеватор.ЛабораторныйАнализПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ПараметрыДляРасчетаЗачетногоВеса);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыЛабораторныйАнализНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ПараметрыОтбора.Вставить("Организация",        Объект.Организация);		
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ПараметрыОтбора.Вставить("Владелец",           Объект.Владелец);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ПараметрыОтбора.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);		
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		ПараметрыОтбора.Вставить("Склад",              Объект.Склад);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.ВидХранения) Тогда
		ПараметрыОтбора.Вставить("ВидХранения",        Объект.ВидХранения);
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		ПараметрыОтбора.Вставить("Номенклатура",       ТекущиеДанные.Номенклатура);
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор",  ПараметрыОтбора);
	ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
	
	ОткрытьФорму("Документ.ИНАГРО_ЛабораторныйАнализ.Форма.ФормаВыбора", ПараметрыФормы, Элемент, УникальныйИдентификатор, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыФизическийВесПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	ТекущиеДанные.Сумма = ТекущиеДанные.ФизическийВес * ТекущиеДанные.Цена;

	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Фасовка) Тогда
		
		ДанныеСтрокиТаблицы = Новый Структура("Фасовка, Количество, ФизическийВес");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);		
				
		КультурыФизическийВесПриИзмененииНаСервере(ДанныеСтрокиТаблицы);	
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
		
	КонецЕсли;	

КонецПроцедуры

&НаСервереБезКонтекста
Процедура КультурыФизическийВесПриИзмененииНаСервере(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.Количество = Окр(?(СтрокаТабличнойЧасти.Фасовка.Вес = 0, 0, СтрокаТабличнойЧасти.ФизическийВес / СтрокаТабличнойЧасти.Фасовка.Вес));
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыВлажностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);

КонецПроцедуры

&НаКлиенте
Процедура КультурыСорнаяПримесьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);

КонецПроцедуры

&НаКлиенте
Процедура КультурыЗерноваяПримесьИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);

КонецПроцедуры

&НаКлиенте
Процедура КультурыЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
	
	ТекущиеДанные.Сумма = ТекущиеДанные.ФизическийВес * ТекущиеДанные.Цена;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЛабораторныйАнализ(Команда)
	
	Если ТекущийЭлемент = Элементы.Культуры Тогда
		
		ТекущиеДанные = Элементы.Культуры.ТекущиеДанные;
		
		Если    Объект.Культуры.Количество() = 0
			ИЛИ Элементы.Культуры.ТекущиеДанные = Неопределено Тогда			
			Возврат;
		Иначе
			
			ЗначенияЗаполнения = Новый Структура;
			ЗначенияЗаполнения.Вставить("Ссылка",             ПредопределенноеЗначение("Документ.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка"));
			ЗначенияЗаполнения.Вставить("Дата",               Объект.Дата);
			ЗначенияЗаполнения.Вставить("Организация",        Объект.Организация);
			ЗначенияЗаполнения.Вставить("Владелец",           Объект.Владелец);
			ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
			ЗначенияЗаполнения.Вставить("Склад",        	  Объект.Склад);
			ЗначенияЗаполнения.Вставить("ВидХранения",        Объект.ВидХранения);
			ЗначенияЗаполнения.Вставить("Урожай",             Объект.Урожай);
			ЗначенияЗаполнения.Вставить("Номенклатура",       ТекущиеДанные.Номенклатура);
			ЗначенияЗаполнения.Вставить("Влажность",          ТекущиеДанные.Влажность);
			ЗначенияЗаполнения.Вставить("СорнаяПримесь",      ТекущиеДанные.СорнаяПримесь);
			ЗначенияЗаполнения.Вставить("ЗерноваяПримесь",    ТекущиеДанные.ЗерноваяПримесь);
			
			ЗначенияЗаполнения.Вставить("МассаПартии",        ТекущиеДанные.ФизическийВес);
			
			ИНАГРО_ЭлеваторКлиент.СоздатьДокументНаОсновании(ЭтаФорма, ЗначенияЗаполнения);
			
		КонецЕсли;
		
	Иначе	
		
		ТекстСообщения = НСтр("ru='Лабораторный анализ можно создать только для строки табличной части!';uk='Лабораторний аналіз можна створити тільки для рядка табличної частини!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Культуры");
		ТекущийЭлемент = Элементы.Культуры;
		
		Возврат;	
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПереоформление(Команда)
	
	Если Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.Переоформление") Тогда
		ТекстСообщения = НСтр("ru='Приказ создан для отгрузки!';uk='Наказ створений для відвантаження!'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;

	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Ссылка", ПредопределенноеЗначение("Документ.ИНАГРО_Переоформление.ПустаяСсылка"));

	ИНАГРО_ЭлеваторКлиент.СоздатьДокументНаОсновании(ЭтаФорма, ЗначенияЗаполнения);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПереоформлениеВыборКультуры() Экспорт
	
	Если Объект.Культуры.Количество() > 0 Тогда
		
		СписокВыбора = Новый СписокЗначений;

		Для Каждого СтрокаТабличнойЧасти Из Объект.Культуры Цикл
			СписокВыбора.Добавить(СтрокаТабличнойЧасти.Номенклатура);  
		КонецЦикла;
		
		Если СписокВыбора.Количество() > 1 Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СписокВыбора", СписокВыбора);
			
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("СоздатьПереоформлениеЗавершение", ЭтотОбъект);

			ОткрытьФорму("ОбщаяФорма.ИНАГРО_ФормаВыбораКультуры", ПараметрыФормы, , Новый УникальныйИдентификатор(), , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		ИначеЕсли СписокВыбора.Количество() = 1 Тогда
			
			СоздатьПереоформлениеЗавершение(Новый Структура("Номенклатура", СписокВыбора.Получить(0).Значение), );
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьПереоформлениеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Ссылка",             Объект.Ссылка);	
		ЗначенияЗаполнения.Вставить("Организация",        Объект.Организация);
		ЗначенияЗаполнения.Вставить("ВидОперации",        Объект.ВидОперации);
		ЗначенияЗаполнения.Вставить("Владелец",           Объект.Владелец);
		ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);	
		ЗначенияЗаполнения.Вставить("Получатель", 		  Объект.Получатель);
		ЗначенияЗаполнения.Вставить("ДоговорПолучателя",  Объект.ДоговорПолучателя);
		ЗначенияЗаполнения.Вставить("Склад",        	  Объект.Склад);	
		ЗначенияЗаполнения.Вставить("МестоХранения",      Объект.МестоХранения);	
		ЗначенияЗаполнения.Вставить("Урожай",             Объект.Урожай);
		ЗначенияЗаполнения.Вставить("ВидХранения",        Объект.ВидХранения);
		ЗначенияЗаполнения.Вставить("ВидПеревозки",       Объект.ВидПеревозки);
		ЗначенияЗаполнения.Вставить("ПунктНазначения",    Объект.ПунктНазначения);
		ЗначенияЗаполнения.Вставить("Номенклатура",       РезультатЗакрытия.Номенклатура);
		
		Если Объект.Культуры.Количество() > 0 Тогда
			СтруктураОтбора = Новый Структура("Номенклатура", РезультатЗакрытия.Номенклатура);
			СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Культуры", СтруктураОтбора);
			Если СтрокаТабличнойЧасти <> Неопределено Тогда
				ЗначенияЗаполнения.Вставить("ЛабораторныйАнализ", СтрокаТабличнойЧасти.ЛабораторныйАнализ);
				ЗначенияЗаполнения.Вставить("НомерАнализа",       СтрокаТабличнойЧасти.НомерАнализа);
				ЗначенияЗаполнения.Вставить("Влажность",          СтрокаТабличнойЧасти.Влажность);
				ЗначенияЗаполнения.Вставить("СорнаяПримесь",      СтрокаТабличнойЧасти.СорнаяПримесь);
				ЗначенияЗаполнения.Вставить("ЗерноваяПримесь",    СтрокаТабличнойЧасти.ЗерноваяПримесь);
			КонецЕсли;
		КонецЕсли;
		
		ЗначенияЗаполнения.Вставить("ДоверенностьДата",   Объект.ДоверенностьДата);
		ЗначенияЗаполнения.Вставить("ДоверенностьНомер",  Объект.ДоверенностьНомер);
		ЗначенияЗаполнения.Вставить("ДоверенностьСерия",  Объект.ДоверенностьСерия);
		ЗначенияЗаполнения.Вставить("ДоверенностьЧерез",  Объект.ДоверенностьЧерез);
		ЗначенияЗаполнения.Вставить("Комментарий",        Объект.Комментарий);	
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения); 
		
		ОткрытьФорму("Документ.ИНАГРО_Переоформление.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор); 

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьТТНВывоз(Команда)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.Переоформление") Тогда
		ТекстСообщения = НСтр("ru='Приказ создан для вида операции ""Переоформление""!';uk='Наказ створений для виду операції ""Переоформлення""!'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ВидПеревозки) Тогда
		Если НЕ Объект.ВидПеревозки = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыПеревозки.Автотранспорт") Тогда
			ТекстСообщения = НСтр("ru='Приказ создан для вида перевозки ""Железнодорожный""!';uk='Наказ створений для виду перевезення ""Залізничний""!'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;		
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Ссылка", ПредопределенноеЗначение("Документ.ИНАГРО_ТТНВывоз.ПустаяСсылка"));
	
	ИНАГРО_ЭлеваторКлиент.СоздатьДокументНаОсновании(ЭтаФорма, ЗначенияЗаполнения);

КонецПроцедуры 

&НаКлиенте
Процедура СоздатьТТНВывозВыборКультуры() Экспорт
	
	Если Объект.Культуры.Количество() > 0 Тогда
		
		СписокВыбора = Новый СписокЗначений;

		Для Каждого СтрокаТабличнойЧасти Из Объект.Культуры Цикл
			СписокВыбора.Добавить(СтрокаТабличнойЧасти.Номенклатура);  
		КонецЦикла;
		
		Если СписокВыбора.Количество() > 1 Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СписокВыбора", СписокВыбора);
			
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("СоздатьТТНВывозЗавершение", ЭтотОбъект);

			ОткрытьФорму("ОбщаяФорма.ИНАГРО_ФормаВыбораКультуры", ПараметрыФормы, , Новый УникальныйИдентификатор(), , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		ИначеЕсли СписокВыбора.Количество() = 1 Тогда
			
			СоздатьТТНВывозЗавершение(Новый Структура("Номенклатура", СписокВыбора.Получить(0).Значение), );
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьТТНВывозЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Ссылка",                           Объект.Ссылка);	
		ЗначенияЗаполнения.Вставить("Организация",                      Объект.Организация);
		ЗначенияЗаполнения.Вставить("Владелец",                         Объект.Владелец);
		ЗначенияЗаполнения.Вставить("ДоговорКонтрагента",               Объект.ДоговорКонтрагента);	
		Если СобственноеПодразделение Тогда
			ЗначенияЗаполнения.Вставить("Получатель", 		            Объект.Получатель);
			ЗначенияЗаполнения.Вставить("ДоговорПолучателя",            Объект.ДоговорПолучателя);
		КонецЕсли;
		ЗначенияЗаполнения.Вставить("Склад",        	                Объект.Склад);	
		ЗначенияЗаполнения.Вставить("МестоХранения",                    Объект.МестоХранения);	
		ЗначенияЗаполнения.Вставить("Урожай",                           Объект.Урожай);
		ЗначенияЗаполнения.Вставить("ВидХранения",                      Объект.ВидХранения);
		ЗначенияЗаполнения.Вставить("ПунктНазначения",                  Объект.ПунктНазначения);		
		ЗначенияЗаполнения.Вставить("Номенклатура",                     РезультатЗакрытия.Номенклатура);
		
		Если Объект.Культуры.Количество() > 0 Тогда
			СтруктураОтбора = Новый Структура("Номенклатура", РезультатЗакрытия.Номенклатура);
			СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Культуры", СтруктураОтбора);
			Если СтрокаТабличнойЧасти <> Неопределено Тогда
				ЗначенияЗаполнения.Вставить("ЕстьФасовка",        ЗначениеЗаполнено(СтрокаТабличнойЧасти.Фасовка));
				ЗначенияЗаполнения.Вставить("ЛабораторныйАнализ", СтрокаТабличнойЧасти.ЛабораторныйАнализ);
				ЗначенияЗаполнения.Вставить("НомерАнализа",       СтрокаТабличнойЧасти.НомерАнализа);
				ЗначенияЗаполнения.Вставить("Влажность",          СтрокаТабличнойЧасти.Влажность);
				ЗначенияЗаполнения.Вставить("СорнаяПримесь",      СтрокаТабличнойЧасти.СорнаяПримесь);
				ЗначенияЗаполнения.Вставить("ЗерноваяПримесь",    СтрокаТабличнойЧасти.ЗерноваяПримесь);
			КонецЕсли;
		КонецЕсли;
		
		ЗначенияЗаполнения.Вставить("ПолучилПоДругомуДокументу",        Объект.ПолучилПоДругомуДокументу); 
		ЗначенияЗаполнения.Вставить("ДоверенностьСерия",                Объект.ДоверенностьСерия);
		ЗначенияЗаполнения.Вставить("ДоверенностьНомер",                Объект.ДоверенностьНомер);
		ЗначенияЗаполнения.Вставить("ДоверенностьДата",                 Объект.ДоверенностьДата);
		ЗначенияЗаполнения.Вставить("ДокументПодтверждающийПолномочия", Объект.ДокументПодтверждающийПолномочия);
		ЗначенияЗаполнения.Вставить("ДоверенностьЧерез",                Объект.ДоверенностьЧерез);
		ЗначенияЗаполнения.Вставить("Комментарий",                      Объект.Комментарий);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения); 
		
		ОткрытьФорму("Документ.ИНАГРО_ТТНВывоз.Форма.ФормаДокументаОбщая", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор); 
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьТТНВывозЖД(Команда)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.Переоформление") Тогда
		ТекстСообщения = НСтр("ru='Приказ создан для вида операции ""Переоформление""!';uk='Наказ створений для виду операції ""Переоформлення""!'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ВидПеревозки) Тогда
		Если НЕ Объект.ВидПеревозки = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыПеревозки.Железнодорожный") Тогда
			ТекстСообщения = НСтр("ru='Приказ создан для вида перевозки ""Автотранспорт""!';uk='Наказ створений для виду перевезення ""Автотранспорт""!'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Ссылка", ПредопределенноеЗначение("Документ.ИНАГРО_ТТНВывозЖД.ПустаяСсылка"));

	ИНАГРО_ЭлеваторКлиент.СоздатьДокументНаОсновании(ЭтаФорма, ЗначенияЗаполнения);
	
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьТТНВывозЖДВыборКультуры() Экспорт
	
	Если Объект.Культуры.Количество() > 0 Тогда
		
		СписокВыбора = Новый СписокЗначений;

		Для Каждого СтрокаТабличнойЧасти Из Объект.Культуры Цикл
			СписокВыбора.Добавить(СтрокаТабличнойЧасти.Номенклатура);  
		КонецЦикла;
		
		Если СписокВыбора.Количество() > 1 Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СписокВыбора", СписокВыбора);
			
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("СоздатьТТНВывозЖДЗавершение", ЭтотОбъект);

			ОткрытьФорму("ОбщаяФорма.ИНАГРО_ФормаВыбораКультуры", ПараметрыФормы, , Новый УникальныйИдентификатор(), , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		ИначеЕсли СписокВыбора.Количество() = 1 Тогда
			
			СоздатьТТНВывозЖДЗавершение(Новый Структура("Номенклатура", СписокВыбора.Получить(0).Значение), );
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьТТНВывозЖДЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Ссылка",             Объект.Ссылка);	
		ЗначенияЗаполнения.Вставить("Организация",        Объект.Организация);
		ЗначенияЗаполнения.Вставить("Владелец",           Объект.Владелец);
		ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);	
		ЗначенияЗаполнения.Вставить("Склад",        	  Объект.Склад);	
		ЗначенияЗаполнения.Вставить("МестоХранения",      Объект.МестоХранения);	
		ЗначенияЗаполнения.Вставить("Урожай",             Объект.Урожай);
		ЗначенияЗаполнения.Вставить("ВидХранения",        Объект.ВидХранения);		
		ЗначенияЗаполнения.Вставить("Номенклатура",       РезультатЗакрытия.Номенклатура);
		
		Если Объект.Культуры.Количество() > 0 Тогда
			СтруктураОтбора = Новый Структура("Номенклатура", РезультатЗакрытия.Номенклатура);
			СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Культуры", СтруктураОтбора);
			Если СтрокаТабличнойЧасти <> Неопределено Тогда
				ЗначенияЗаполнения.Вставить("ЛабораторныйАнализ", СтрокаТабличнойЧасти.ЛабораторныйАнализ);
				ЗначенияЗаполнения.Вставить("НомерАнализа",       СтрокаТабличнойЧасти.НомерАнализа);
				ЗначенияЗаполнения.Вставить("Влажность",          СтрокаТабличнойЧасти.Влажность);
				ЗначенияЗаполнения.Вставить("СорнаяПримесь",      СтрокаТабличнойЧасти.СорнаяПримесь);
				ЗначенияЗаполнения.Вставить("ЗерноваяПримесь",    СтрокаТабличнойЧасти.ЗерноваяПримесь);
			КонецЕсли;
		КонецЕсли;
		
		ЗначенияЗаполнения.Вставить("Комментарий",        Объект.Комментарий);	
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения); 
		
		ОткрытьФорму("Документ.ИНАГРО_ТТНВывозЖД.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор); 
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьФункциональныеОпцииФормы();	
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ДатаОкончанияДействияПриказаНовая = КонецДня(НачалоДня(Объект.Дата) + 86400 * СрокДействияПриказа);
		
		Если Объект.ДатаОкончанияДействияПриказа <> ДатаОкончанияДействияПриказаНовая Тогда		
			Объект.ДатаОкончанияДействияПриказа = ДатаОкончанияДействияПриказаНовая;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьЗаголовокФормы(); 	
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);	

	ПараметрыУчетаЭлеватора                       = ИНАГРО_Элеватор.ПолучитьПараметрыУчетаЭлеватора(Объект.Дата);
	ИспользоватьДополнительныйКонтрольДоговоров   = ПараметрыУчетаЭлеватора.ДополнительныйКонтрольДоговоров;
	ЛабораторияРаботаетВСистеме                   = ПараметрыУчетаЭлеватора.ЛабораторияРаботаетВСистеме;
	ВестиСправочникВодителей                      = ПараметрыУчетаЭлеватора.ВестиСправочникВодителей;
	ВестиСправочникАвтомобилей                    = ПараметрыУчетаЭлеватора.ВестиСправочникАвтомобилей; 
	РучноеУправлениеЗачетнымВесом                 = ПараметрыУчетаЭлеватора.РучноеУправлениеЗачетнымВесом;
	СрокДействияПриказа                           = ПараметрыУчетаЭлеватора.СрокДействияПриказа;

	СобственноеПодразделение                      = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитКонтрагента(Объект.Владелец, "СобственноеПодразделение");
	ВидимостьМестаХранения                        = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитСклада(Объект.Склад, "ВестиУчетПоМестамХранения");
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;	

	Если    Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.Уничтожение")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.ПустаяСсылка") Тогда
		
		Элементы.ДатаОкончанияДействияПриказа.Видимость  = Истина; 		
		Элементы.Получатель.Видимость                    = Ложь;		
		Элементы.ДоговорПолучателя.Видимость             = Ложь;		
		Элементы.НовыйСклад.Видимость                    = Истина;		
		Элементы.ВидПеревозки.Видимость                  = Истина;
		
		Элементы.ГруппаТипЛабораторногоАнализа.Видимость = Истина;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийПриказ.Отгрузка") Тогда
		
		Элементы.ДатаОкончанияДействияПриказа.Видимость  = Истина;				
		Элементы.Получатель.Видимость					 = Форма.СобственноеПодразделение;
		Элементы.ДоговорПолучателя.Видимость			 = Форма.СобственноеПодразделение;
		Элементы.НовыйСклад.Видимость				     = Форма.СобственноеПодразделение;		
		Элементы.ВидПеревозки.Видимость                  = Истина;
		Элементы.ПунктНазначения.Видимость               = Истина;  
		
		Элементы.ГруппаТипЛабораторногоАнализа.Видимость = Истина;
		
	Иначе
		
		Элементы.ДатаОкончанияДействияПриказа.Видимость  = Истина;
		Элементы.Получатель.Видимость                    = Истина;
		Элементы.ДоговорПолучателя.Видимость             = Истина;		
		Элементы.НовыйСклад.Видимость                    = Ложь;
		Элементы.ВидПеревозки.Видимость                  = Ложь;
		Элементы.ПунктНазначения.Видимость               = Ложь;
		
		Элементы.ГруппаТипЛабораторногоАнализа.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.МестоХранения.Видимость              = Форма.ВидимостьМестаХранения;
	
	Элементы.ГруппаРеквизитыДоверенностиЛевая.Видимость = НЕ Объект.ПолучилПоДругомуДокументу; 
	Элементы.ДокументПодтверждающийПолномочия.Видимость = Объект.ПолучилПоДругомуДокументу;	
	
	Элементы.КультурыЛабораторныйАнализ.Видимость = Форма.ЛабораторияРаботаетВСистеме;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораВидОперации()
	
	МассивВидовОпераций = Документы.ИНАГРО_ПриказНаВывоз.ПолучитьФиксированныйМассивВидовОпераций();
	
	ПараметрМассивВидовОпераций = Новый ПараметрВыбора("Отбор.Ссылка", МассивВидовОпераций);
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(ПараметрМассивВидовОпераций);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	
	Элементы.ВидОперации.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	ОбъектФормы = ЭтаФорма.Объект;

	ТекстЗаголовка = НСтр("ru='Приказ на вывоз';uk='Наказ на вивезення'");
	
	Если ЗначениеЗаполнено(ОбъектФормы.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2';uk=' %1 від %2'"), ОбъектФормы.Номер, ОбъектФормы.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru=' (создание)';uk=' (створення)'");
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ТекстЗаголовка + " (" + Строка(ОбъектФормы.ВидОперации) + ")";

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиВТабличнойЧасти()

	Документы.ИНАГРО_ПриказНаВывоз.ЗаполнитьОстаткиВТабличнойЧасти(Объект, "Культуры");

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыДляДоговоров()

	ПараметрыОтбора = Новый Структура("ВидХранения, Урожай");
	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Объект);

	Возврат ПараметрыОтбора;

КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыДляПроверкиЗаполнения(СтрокаТабличнойЧасти)
	
	ПараметрыДляПроверкиЗаполнения = Новый Структура("Склад, ВидХранения, Урожай");
	ЗаполнитьЗначенияСвойств(ПараметрыДляПроверкиЗаполнения, Объект);
	ПараметрыДляПроверкиЗаполнения.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);

	Возврат ПараметрыДляПроверкиЗаполнения; 

КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыДляРасчетаЗачетногоВеса(СтрокаТабличнойЧасти)
	
	ПараметрыДляРасчетаЗачетногоВеса = Новый Структура(
		"Ссылка, Дата, Организация,
		|Владелец, ДоговорКонтрагента, Номенклатура,
		|Склад, Влажность, СорнаяПримесь,
		|ФизическийВес, ЗачетныйВес");
	ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, Объект);
	ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, СтрокаТабличнойЧасти);
	
	Возврат ПараметрыДляРасчетаЗачетногоВеса; 

КонецФункции

#КонецОбласти  

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		
		ИмяКоманды      = Команда.Имя;
		АдресНастроек   = ЭтотОбъект.ПараметрыПодключаемыхКоманд.АдресТаблицыКоманд;
		ОписаниеКоманды = ПодключаемыеКомандыКлиентПовтИсп.ОписаниеКоманды(ИмяКоманды, АдресНастроек);
		
        Если ОписаниеКоманды.Идентификатор = "ПропускФ196" ИЛИ 
            ОписаниеКоманды.Идентификатор = "ПропускФ196_2021" Тогда		
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Команда",              Команда);
			ДополнительныеПараметры.Вставить("ИдентификаторКоманды", ОписаниеКоманды.Идентификатор);
			
			Оповещение = Новый ОписаниеОповещения("ВводЧислаЗавершение", ЭтотОбъект, ДополнительныеПараметры); 
			ПоказатьВводЧисла(Оповещение, 0, Нстр("ru='Введите количество экземпляров';uk='Введіть кількість екземплярів'"), 15, 0);
			
		Иначе
			ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
		КонецЕсли; 
		
	Иначе
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	КонецЕсли;

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

&НаКлиенте 
Процедура ВводЧислаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 
	
	Если РезультатЗакрытия <> Неопределено Тогда 
		ЗаписатьВыбранноеКоличество(РезультатЗакрытия, ДополнительныеПараметры.ИдентификаторКоманды);		
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, ДополнительныеПараметры.Команда, Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВыбранноеКоличество(РезультатЗакрытия, ИдентификаторКоманды) 
	
	Документы.ИНАГРО_ПриказНаВывоз.ЗаписатьВыбранноеКоличество(РезультатЗакрытия, ИдентификаторКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура КультурыСуммаПриИзменении(Элемент) 
	
	СтрокаТаблицы = Элементы.Культуры.ТекущиеДанные;
	
	Если СтрокаТаблицы.ФизическийВес = 0 Тогда
		СтрокаТаблицы.Цена = 0;
	Иначе
		СтрокаТаблицы.Цена = СтрокаТаблицы.Сумма / СтрокаТаблицы.ФизическийВес;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 