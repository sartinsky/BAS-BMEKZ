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
		
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если  ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		
		Если ИмяСобытия = "СозданЛабораторныйАнализ" ИЛИ ИмяСобытия = "ИзмененЛабораторныйАнализ" Тогда
			
			ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;		
			
			Если ИНАГРО_Элеватор.ЛабораторныйАнализПроверкаЗаполнения(Параметр.ДокументСсылка, ПолучитьПараметрыДляПроверкиЗаполнения()) Тогда
				ТекущиеДанные.ЛабораторныйАнализ = Параметр.ДокументСсылка;
				СписокТТНЛабораторныйАнализПриИзменении(Неопределено);
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
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеКолонкиТаблицыСписокТТН();
	
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
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();	
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБухгалтерскомУчетеПриИзменении(Элемент)
		
	Если Объект.ОтражатьВБухгалтерскомУчете Тогда		
		ТекстВопроса = НСтр("ru='Установить счета бухгалтерского учета в соответствии со значениями по умолчанию?';uk='Встановити рахунки бухгалтерського обліку відповідно до значень за замовчуванням?'");
	Иначе
		ТекстВопроса = НСтр("ru='Очистить счета бухгалтерского учета?';uk='Очистити рахунки бухгалтерського обліку?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОтражатьВБухгалтерскомУчетеПриИзмененииЗавершение", ЭтотОбъект, Параметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБухгалтерскомУчетеПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		УправлениеФормой(ЭтаФорма);
		Возврат;
	КонецЕсли; 	
	
	ЗаполнитьСчетаУчетаВТабличнойЧасти();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовПанелиОсновные

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()	
	
	МестоХранения = Справочники.ИНАГРО_МестаХранения.ПустаяСсылка();

	УстановитьФункциональныеОпцииФормы(); 	
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура НовыйСкладПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		НовыйСкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НовыйСкладПриИзмененииНаСервере()
	
	НовоеМестоХранения = Справочники.ИНАГРО_МестаХранения.ПустаяСсылка();

	УстановитьФункциональныеОпцииФормы(); 	
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокТТН

&НаКлиенте
Процедура СписокТТНПриИзменении(Элемент)
		
	ОбновитьИтоги(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СписокТТНПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	УстановитьДоступностьПоказателейКачества(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура СписокТТНПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
		
	Если НоваяСтрока И ОтменаРедактирования Тогда
		ОбновитьИтоги(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокТТНВладелецПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Владелец) Тогда
		
		ПараметрыОтбораДоговора = ПолучитьПараметрыДляДоговоров();
		
		ИНАГРО_ЭлеваторЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(Объект.Дата, Объект.Организация, ТекущиеДанные.Владелец, ТекущиеДанные.ДоговорКонтрагента, ПараметрыОтбораДоговора);				
				
	КонецЕсли; 	

КонецПроцедуры

&НаКлиенте
Процедура СписокТТНТТНПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
	"ТТН, НомерТТН, Владелец, 
	|ДоговорКонтрагента, ФизическийВес, Транспорт,
	|СчетУчетаБУ, НовыйСчетУчетаБУ, ИндексКартинки
	|");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
	"Дата, Организация, Склад,
	|Номенклатура, ОтражатьВБухгалтерскомУчете"); 
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);

	СписокТТНТТНПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьДобавленныеКолонкиСтрокиТаблицыСписокТТН(ДанныеСтрокиТаблицы);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокТТНТТНПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)	
	
	СтрокаТабличнойЧасти.НомерТТН           = СтрокаТабличнойЧасти.ТТН.Номер;
	СтрокаТабличнойЧасти.Владелец           = СтрокаТабличнойЧасти.ТТН.Владелец;
	СтрокаТабличнойЧасти.ДоговорКонтрагента = СтрокаТабличнойЧасти.Владелец.ОсновнойДоговорКонтрагента;
	СтрокаТабличнойЧасти.ФизическийВес      = СтрокаТабличнойЧасти.ТТН.Вес;
	СтрокаТабличнойЧасти.Транспорт          = Строка(СтрокаТабличнойЧасти.ТТН.НомерТранспорта);

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		ДанныеОбъекта.Номенклатура, ДанныеОбъекта);	
		
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Документы.ИНАГРО_РеестрТТНВнутр.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, СведенияОНоменклатуре);
		
КонецПроцедуры

&НаКлиенте
Процедура СписокТТНФизическийВесПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
	
	ТекущиеДанные.ЗачетныйВес   = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);

	ОбновитьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТТНЛабораторныйАнализПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;	
	
	ДанныеСтрокиТаблицы = Новый Структура(					
		"ЛабораторныйАнализ, НомерАнализа, Влажность,
		|СорнаяПримесь, ЗерноваяПримесь, ЗачетныйВес,
		|Масличность");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);

	ИНАГРО_Элеватор.ЛабораторныйАнализПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ПараметрыДляРасчетаЗачетногоВеса);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);		
	
	УстановитьДоступностьПоказателейКачества(ТекущиеДанные);
	
	УправлениеФормой(ЭтаФорма);		
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТТНЛабораторныйАнализНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	ПараметрыОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ПараметрыОтбора.Вставить("Организация",        Объект.Организация);		
	КонецЕсли;	
	Если ЗначениеЗаполнено(ТекущиеДанные.Владелец) Тогда
		ПараметрыОтбора.Вставить("Владелец",           ТекущиеДанные.Владелец);
	КонецЕсли;	
	Если ЗначениеЗаполнено(ТекущиеДанные.ДоговорКонтрагента) Тогда
		ПараметрыОтбора.Вставить("ДоговорКонтрагента", ТекущиеДанные.ДоговорКонтрагента);		
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		ПараметрыОтбора.Вставить("Склад",              Объект.Склад);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.ВидХранения) Тогда
		ПараметрыОтбора.Вставить("ВидХранения",        Объект.ВидХранения);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ПараметрыОтбора.Вставить("Номенклатура",       Объект.Номенклатура);
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор",  ПараметрыОтбора);
	ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
	
	ОткрытьФорму("Документ.ИНАГРО_ЛабораторныйАнализ.Форма.ФормаВыбора", ПараметрыФормы, Элемент, УникальныйИдентификатор, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЛабораторныйАнализ(Команда)
	
	Если ТекущийЭлемент = Элементы.СписокТТН Тогда
		
		ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
		
		Если Объект.СписокТТН.Количество() = 0 ИЛИ ТекущиеДанные = Неопределено Тогда			
			Возврат;
		Иначе
			
			ЗначенияЗаполнения = Новый Структура;
			ЗначенияЗаполнения.Вставить("Дата",               Объект.Дата);
			ЗначенияЗаполнения.Вставить("Ссылка",             ПредопределенноеЗначение("Документ.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка"));
			ЗначенияЗаполнения.Вставить("Организация",        Объект.Организация);
			ЗначенияЗаполнения.Вставить("Склад",        	  Объект.Склад);
			ЗначенияЗаполнения.Вставить("ВидХранения",        Объект.ВидХранения);
			ЗначенияЗаполнения.Вставить("Урожай",             Объект.Урожай);
			ЗначенияЗаполнения.Вставить("Номенклатура",       Объект.Номенклатура);
			ЗначенияЗаполнения.Вставить("Владелец",           ТекущиеДанные.Владелец);
			ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", ТекущиеДанные.ДоговорКонтрагента);
			ЗначенияЗаполнения.Вставить("Влажность",          ТекущиеДанные.Влажность);
			ЗначенияЗаполнения.Вставить("СорнаяПримесь",      ТекущиеДанные.СорнаяПримесь);
			ЗначенияЗаполнения.Вставить("ЗерноваяПримесь",    ТекущиеДанные.ЗерноваяПримесь);
			
			ЗначенияЗаполнения.Вставить("МассаПартии",        ТекущиеДанные.ФизическийВес);	
			
			ИНАГРО_ЭлеваторКлиент.СоздатьДокументНаОсновании(ЭтаФорма, ЗначенияЗаполнения);
			
		КонецЕсли;
		
	Иначе	
		
		ТекстСообщения = НСтр("ru='Лабораторный анализ можно создать только для строки табличной части!';uk='Лабораторний аналіз можна створити тільки для рядка табличної частини!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.СписокТТН");
		ТекущийЭлемент = Элементы.СписокТТН;
		
		Возврат;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсемТекущийАнализ(Команда)
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
		КонецЕсли;
	
	ТекущееЗначениеЛабАнализа      = ТекущиеДанные.ЛабораторныйАнализ;
	ТекущееЗначениеНомерАнализа    = ТекущиеДанные.НомерАнализа;
	ТекущееЗначениеВлажности       = ТекущиеДанные.Влажность;
	ТекущееЗначениеСорнаяПримесь   = ТекущиеДанные.СорнаяПримесь;
	ТекущееЗначениеЗерноваяПримесь = ТекущиеДанные.ЗерноваяПримесь;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СписокТТН Цикл
		СтрокаТабличнойЧасти.ЛабораторныйАнализ = ТекущееЗначениеЛабАнализа;
		СтрокаТабличнойЧасти.НомерАнализа       = ТекущееЗначениеНомерАнализа;
		СтрокаТабличнойЧасти.Влажность          = ТекущееЗначениеВлажности;
		СтрокаТабличнойЧасти.СорнаяПримесь      = ТекущееЗначениеСорнаяПримесь;
		СтрокаТабличнойЧасти.ЗерноваяПримесь    = ТекущееЗначениеЗерноваяПримесь;
		ПараметрыДляРасчетаЗачетногоВеса        = ПолучитьПараметрыДляРасчетаЗачетногоВеса(ТекущиеДанные);
		СтрокаТабличнойЧасти.ЗачетныйВес        = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);
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

	ТекущаяДатаДокумента = Объект.Дата;	

	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьДобавленныеКолонкиТаблицыСписокТТН();	
	
	УправлениеФормой(ЭтаФорма);  	
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);	
	
	ТекущийПользователь          = Пользователи.ТекущийПользователь();	
		
	ЛабораторияРаботаетВСистеме  = ИНАГРО_Элеватор.ПолучитьПараметрУчетаЭлеватора(Объект.Дата, "ЛабораторияРаботаетВСистеме", Истина);
	
	ВидимостьМестаХранения       = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитСклада(Объект.Склад, "ВестиУчетПоМестамХранения");
	ВидимостьНовогоМестаХранения = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитСклада(Объект.НовыйСклад, "ВестиУчетПоМестамХранения");
	
	ВидимостьМасличность         = ИНАГРО_Элеватор.ПолучитьВидимостьМасличность(Объект.Дата);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;	
	
	Элементы.ДатаОкончанияИнвентаризации.Видимость = Объект.Перевес;
	
	Элементы.СписокТТНЛабораторныйАнализ.Видимость = Форма.ЛабораторияРаботаетВСистеме;	
	Элементы.СписокТТНФизическийВес.Доступность    =  ИНАГРО_ЭлеваторУправлениеПользователями.ЗапретитьВручнуюИзменятьВесТТН(Форма.ТекущийПользователь);	
	Элементы.СписокТТНСчетУчетаБУ.Видимость        = Объект.ОтражатьВБухгалтерскомУчете;
	Элементы.СписокТТННовыйСчетУчетаБУ.Видимость   = Объект.ОтражатьВБухгалтерскомУчете;
	
	Элементы.МестоХранения.Видимость		 	   = Форма.ВидимостьМестаХранения;
	Элементы.НовоеМестоХранения.Видимость		   = Форма.ВидимостьНовогоМестаХранения;	
	
	// Масличность
	Элементы.СписокТТНМасличность.Видимость        = Форма.ВидимостьМасличность;

	ОбновитьИтоги(Форма)
				
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьПоказателейКачества(СтрокаТабличнойЧасти)
	
	СписокРеквизитов = Новый Структура("Влажность, СорнаяПримесь, ЗерноваяПримесь");	
	ИНАГРО_ЭлеваторКлиентСервер.УстановитьДоступностьРеквизитовПоНастройке(ЭтаФорма, СписокРеквизитов, ЛабораторияРаботаетВСистеме, ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЛабораторныйАнализ), "СписокТТН");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти()
	
	Если Объект.СписокТТН.Количество() > 0 Тогда
		Документы.ИНАГРО_РеестрТТНВнутр.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "СписокТТН");
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблицыСписокТТН()
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СписокТТН Цикл			
		ЗаполнитьДобавленныеКолонкиСтрокиТаблицыСписокТТН(СтрокаТабличнойЧасти);		
	КонецЦикла;		
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицыСписокТТН(СтрокаТабличнойЧасти)
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ТТН) Тогда
		Если СтрокаТабличнойЧасти.ТТН.Проведен Тогда
			СтрокаТабличнойЧасти.ИндексКартинки = 1;
		ИначеЕсли СтрокаТабличнойЧасти.ТТН.ПометкаУдаления Тогда
			СтрокаТабличнойЧасти.ИндексКартинки = 2;
		Иначе
			СтрокаТабличнойЧасти.ИндексКартинки = 0;
		КонецЕсли; 
	КонецЕсли; 			
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)

	Объект = Форма.Объект; 
		
	Форма.ИтогиВес         = Объект.СписокТТН.Итог("ФизическийВес");
	Форма.ИтогиЗачетныйВес = Объект.СписокТТН.Итог("ЗачетныйВес");			

КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыДляДоговоров()
	
	ПараметрыОтбора = Новый Структура("ВидХранения, Урожай");
	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Объект);

	Возврат ПараметрыОтбора;

КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыДляПроверкиЗаполнения()
	
	ПараметрыДляПроверкиЗаполнения = Новый Структура(
		"Склад, ВидХранения, Урожай,
		|Номенклатура");
	ЗаполнитьЗначенияСвойств(ПараметрыДляПроверкиЗаполнения, Объект);

	Возврат ПараметрыДляПроверкиЗаполнения; 

КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыДляРасчетаЗачетногоВеса(СтрокаТабличнойЧасти)
	
	ПараметрыДляРасчетаЗачетногоВеса = Новый Структура(
		"Ссылка, Дата, Организация,
		|Владелец, ДоговорКонтрагента, Номенклатура,
		|Склад, Влажность, СорнаяПримесь,
		|ФизическийВес, ЗачетныйВес     
		|");
	ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, Объект);
	ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, СтрокаТабличнойЧасти);
	
	Возврат ПараметрыДляРасчетаЗачетногоВеса; 

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