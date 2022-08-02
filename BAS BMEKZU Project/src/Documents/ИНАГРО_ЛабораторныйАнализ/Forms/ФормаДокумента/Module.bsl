#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		ЭтоНовый = Истина;
	Иначе
		ЭтоНовый = Ложь;		
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
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	Если ВладелецФормы <> Неопределено Тогда
		
		Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") И НЕ Объект.Ссылка.Пустая() И ЭтоНовый = Истина Тогда
			
			СтруктураВозврата = Новый Структура;
			СтруктураВозврата.Вставить("ДокументСсылка",               Объект.Ссылка);				
			СтруктураВозврата.Вставить("ИдентификаторВызывающейФормы", ВладелецФормы.УникальныйИдентификатор);				
			
			Оповестить("СозданЛабораторныйАнализ", СтруктураВозврата, ВладелецФормы);
			
		ИначеЕсли ТипЗнч(ВладелецФормы) <> Тип("ФормаКлиентскогоПриложения") И НЕ Объект.Ссылка.Пустая() И ЭтоНовый = Ложь Тогда
			
			ФормаВладелец = ВладелецФормы;
			Пока ТипЗнч(ФормаВладелец) <> Тип("ФормаКлиентскогоПриложения") Цикл
				ФормаВладелец = ФормаВладелец.Родитель;
			КонецЦикла;
			
			Индекс = СтрЗаменить(ВладелецФормы.Имя, "ЛабораторныйАнализ", "");

			СтруктураВозврата = Новый Структура;
			СтруктураВозврата.Вставить("ДокументСсылка",               Объект.Ссылка);				
			СтруктураВозврата.Вставить("ИдентификаторВызывающейФормы", ФормаВладелец.УникальныйИдентификатор);
			СтруктураВозврата.Вставить("Индекс",                       Индекс);	
			
			Оповестить("ИзмененЛабораторныйАнализ", СтруктураВозврата, ВладелецФормы);
			
		КонецЕсли;
		
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
	
	ЗаполнитьДобавленныеКолонкиТаблицыРезультаты();
	
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
Процедура ВладелецПриИзменении(Элемент)
	
	ПараметрыОтбораДоговора = ПолучитьПараметрыДляДоговоров();
	
	ИНАГРО_ЭлеваторЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(Объект.Дата, Объект.Организация, Объект.Владелец, Объект.ДоговорКонтрагента, ПараметрыОтбораДоговора);
	
	Объект.Получатель = Объект.Владелец;

КонецПроцедуры

&НаКлиенте
Процедура ТипЖурналаПриИзменении(Элемент)
	
	Если  ЗначениеЗаполнено(Объект.Организация)
		И ЗначениеЗаполнено(Объект.ТипЖурнала) Тогда
		
		ДанныеОбъекта = Новый Структура(
			"ВидЖурнала, ТипЖурнала, НомерАнализа,
			|НомерПробы");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);

		ТипЖурналаПриИзмененииНаСервере(ДанныеОбъекта);
		
		Объект.НомерАнализа = ДанныеОбъекта.НомерАнализа;
		
		ИзменитьНомер();
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТипЖурналаПриИзмененииНаСервере(ДанныеОбъекта)
	
	ДанныеОбъекта.НомерАнализа = Документы.ИНАГРО_ЛабораторныйАнализ.ЗаполнитьНомерАнализа(ДанныеОбъекта);	

КонецПроцедуры

&НаКлиенте
Процедура НомерАнализаПриИзменении(Элемент)
	
	ИзменитьНомер();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Номенклатура) Тогда		
		ЗаполнитьТабличнуюЧастьРезультаты();		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СушкаПриИзменении(Элемент)
	
	Если Объект.Вентилирование И НЕ Объект.Сушка Тогда
		Объект.Вентилирование = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СушитьАктивнымВентилированиемПриИзменении(Элемент)
	      
	Если Объект.Вентилирование И НЕ Объект.Сушка Тогда
		Объект.Сушка = Истина;
	КонецЕсли;

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезультаты

&НаКлиенте
Процедура РезультатыХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Результаты.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Характеристика, ЕдиницаИзмерения, Значение,
		|ДопИнформация");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные); 	
		
	РезультатыХарактеристикаПриИзмененииНаСервере(ДанныеСтрокиТаблицы, Объект.Номенклатура);	
		
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
			
КонецПроцедуры

&НаСервере
Процедура РезультатыХарактеристикаПриИзмененииНаСервере(СтрокаТабличнойЧасти, Номенклатура)
	
	ВыборВидаХарактеристикиИзСпискаЗавершениеНаСервере(СтрокаТабличнойЧасти);
	
	СтрокаТабличнойЧасти.ДопИнформация = "";
	
	ТипХарактеристики = СтрокаТабличнойЧасти.Характеристика.ТипХарактеристики;
	
	Если ТипХарактеристики <> Неопределено Тогда			
		Если ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ПроходСита Тогда
			СтрокаТабличнойЧасти.ДопИнформация = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Номенклатура, "ВидКультуры").ДиаметрСита;
		КонецЕсли;			
	КонецЕсли;
	
	ЗаполнитьДобавленныеКолонкиТаблицыРезультаты();

КонецПроцедуры

&НаКлиенте
Процедура РезультатыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
			
	ВидКультуры = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Объект.Номенклатура, "ВидКультуры");
	
	Если НЕ ЗначениеЗаполнено(ВидКультуры) Тогда			
		
		ДополнительныеПараметры = Новый Структура("Элемент", Элемент);					
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборВидаКультурыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("Справочник.ИНАГРО_ВидыКультур.Форма.ФормаВыбора", , , Новый УникальныйИдентификатор(), , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ВыборВидаХарактеристикиИзСписка(Элемент);
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура РезультатыЗначениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Результаты.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Характеристика, Значение, Вес, 
		|Удалить"); 
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	РезультатыЗначениеПриИзмененииНаСервере(ДанныеСтрокиТаблицы);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);	
	 	
КонецПроцедуры

&НаСервере
Процедура РезультатыЗначениеПриИзмененииНаСервере(СтрокаТабличнойЧасти)
	
	УправлениеФормойНаСервере();
	
	СтрокаТабличнойЧасти.Удалить = Ложь;
	
	КоэффициентНавеса     = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Объект.Номенклатура, "ВидКультуры").КоэффициентНавеса;	
	ТекущаяХарактеристика = СтрокаТабличнойЧасти.Характеристика;
	
	Если КоэффициентНавеса <> 0 Тогда				
		ТипХарактеристики = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.НайтиПоНаименованию(ТекущаяХарактеристика).ТипХарактеристики;
		Если    ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ВидСорнойПримеси
			ИЛИ ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ВидЗерновойПримеси
			ИЛИ ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ПроходСита Тогда
			СтрокаТабличнойЧасти.Вес = (СтрокаТабличнойЧасти.Значение * КоэффициентНавеса) / 100;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущаяХарактеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Влажность Тогда 
		Объект.Влажность = СтрокаТабличнойЧасти.Значение;
	КонецЕсли;
	
	Если ТекущаяХарактеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.СорнаяПримесь Тогда 
		Объект.СорнаяПримесь = СтрокаТабличнойЧасти.Значение;
	КонецЕсли;
	
	Если ТекущаяХарактеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ЗерноваяПримесь Тогда 
		Объект.ЗерноваяПримесь = СтрокаТабличнойЧасти.Значение;
	КонецЕсли;	
	
	Если  НЕ СуммарноеЗначениеСорнойПримеси = 0
		И НЕ СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.СорнаяПримесь Тогда
		
		СтруктураОтбора = Новый Структура("Характеристика", ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.СорнаяПримесь);
		НайденнаяСтрока = НайтиСтрокуТабличнойЧасти(СтруктураОтбора);
		
		Если НайденнаяСтрока <> Неопределено Тогда
			НайденнаяСтрока.Значение = СуммарноеЗначениеСорнойПримеси;
			Объект.СорнаяПримесь = НайденнаяСтрока.Значение;
			НайденнаяСтрока.Удалить = Ложь;
			УправлениеФормойНаСервере();			
		КонецЕсли;
		
	КонецЕсли;
	
	Если  НЕ СуммарноеЗначениеЗерновойПримеси = 0
		И НЕ СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ЗерноваяПримесь Тогда
		
		СтруктураОтбора = Новый Структура("Характеристика", ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ЗерноваяПримесь);
		НайденнаяСтрока = НайтиСтрокуТабличнойЧасти(СтруктураОтбора);
		
		Если НайденнаяСтрока <> Неопределено Тогда
			НайденнаяСтрока.Значение = СуммарноеЗначениеЗерновойПримеси;
			Объект.ЗерноваяПримесь = НайденнаяСтрока.Значение;
			НайденнаяСтрока.Удалить = Ложь;
			УправлениеФормойНаСервере();  			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сорт(Команда)
	
	Объект.Сорт = НСтр("ru='рядовое';uk='рядове'");
	
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура МетодОпределенияСтекловидности(Команда)
	
	Объект.МетодОпределенияСтекловидности = НСтр("ru='по срезу зерна';uk='по зрізу зерна'");

	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокХарактеристик(Команда)
	
	ЗаполнитьТабличнуюЧастьРезультаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСредневзвешеннымиЗначениями(Команда)
	
	ПараметрыФормы = Новый Структура(
		"Организация, Склад, Владелец,
		|ДоговорКонтрагента, Номенклатура, ТипЖурнала,
		|Урожай, ВидХранения, Силос,
		|ДатаОкончания, ДатаНачала");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Объект);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьСредневзвешеннымиЗначениямиЗавершение", ЭтотОбъект);

	ОткрытьФорму("Документ.ИНАГРО_ЛабораторныйАнализ.Форма.ФормаВводаПараметровВыборки", ПараметрыФормы, , Новый УникальныйИдентификатор(), , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСредневзвешеннымиЗначениямиЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		Если  РезультатЗакрытия.АдресХарактеристикиВХранилище <> Неопределено
			И РезультатЗакрытия.КвоЛабАнализов <> Неопределено Тогда
			ЗаполнитьСредневзвешеннымиЗначениямиЗавершениеНаСервере(РезультатЗакрытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСредневзвешеннымиЗначениямиЗавершениеНаСервере(РезультатЗакрытия)
	
	Объект.Результаты.Очистить();
	
	НовыеВидыХарактеристик = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Объект.Номенклатура, "ВидКультуры").ВидыХарактеристик.ВыгрузитьКолонку("ВидХарактеристики");
	
	ТаблицаХарактеристик = ПолучитьИзВременногоХранилища(РезультатЗакрытия.АдресХарактеристикиВХранилище);

	Для Каждого НоваяХарактеристика Из НовыеВидыХарактеристик Цикл
		
		НоваяСтрока = Объект.Результаты.Добавить();
		НоваяСтрока.Удалить          = Истина;
		НоваяСтрока.Характеристика   = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.НайтиПоНаименованию(НоваяХарактеристика);
		НоваяСтрока.ЕдиницаИзмерения = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.НайтиПоНаименованию(НоваяХарактеристика).ЕдиницаИзмерения;
		ДанныеВидСвойства            = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.НайтиПоНаименованию(НоваяХарактеристика);
		НоваяСтрока.Значение         = ДанныеВидСвойства.ТипЗначения.ПривестиЗначение(НоваяСтрока.Значение);	
		
		Если НоваяСтрока.Характеристика.ТипХарактеристики=Перечисления.ИНАГРО_ТипыХарактеристик.ПроходСита тогда
			НоваяСтрока.ДопИнформация = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Объект.Номенклатура,"ВидКультуры").ДиаметрСита;
		КонецЕсли;
		
		Если НоваяСтрока.Характеристика.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			НоваяСтрока.Значение = ПолучитьЗначениеХарактеристики(ТаблицаХарактеристик, НоваяСтрока.Характеристика, РезультатЗакрытия.КвоЛабАнализов);
			НоваяСтрока.Удалить = Ложь;
		КонецЕсли;
		
		Если НоваяСтрока.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Влажность Тогда 
			Объект.Влажность = НоваяСтрока.Значение;
		КонецЕсли;
		
		Если НоваяСтрока.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.СорнаяПримесь Тогда 
			Объект.СорнаяПримесь = НоваяСтрока.Значение;
		КонецЕсли;
		
		Если НоваяСтрока.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ЗерноваяПримесь Тогда 
			Объект.ЗерноваяПримесь = НоваяСтрока.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЯдро(Команда)
	
	 РассчитатьЯдроНаСервере();

КонецПроцедуры

&НаСервере
Процедура РассчитатьЯдроНаСервере()
	
	СтруктураОтбора = Новый Структура("Характеристика", ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Ядро);
				
	НайденаяСтрока = НайтиСтрокуТабличнойЧасти(СтруктураОтбора);
		
	Если НайденаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СДЗ_ = 0; 
	ЗДЗ_ = 0; 
	ДЗ_  = 0; 
	ПЛ_  = 0; 
	ОБ_  = 0;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Результаты Цикл
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.СорнаяПримесь Тогда
			СДЗ_ = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;	
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ЗерноваяПримесь Тогда
			ЗДЗ_ = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;	
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.МелкоеЗерно Тогда
			ДЗ_  = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;	
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.Пленчатость Тогда
			ПЛ_  = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;	
		Если СтрокаТабличнойЧасти.Характеристика = ПланыВидовХарактеристик.ИНАГРО_ХарактеристикиВидовКультур.ОбрушеныхЗерен Тогда
			ОБ_  = СтрокаТабличнойЧасти.Значение;
		КонецЕсли;	
	КонецЦикла;
	
	НайденаяСтрока.Значение = ((100 - (СДЗ_ + ЗДЗ_ + ДЗ_)) * (100 - ПЛ_) / 100) + (ОБ_ * 0.7);
	НайденаяСтрока.Удалить  = Ложь;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьДобавленныеКолонкиТаблицыРезультаты();
	
	УправлениеФормойНаСервере();	
	
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
	
	Синий    = Новый Цвет(47, 95, 237);
	Красный  = Новый Цвет(255, 0, 0);	
		
	Элементы.НадписьСуммарноеЗначениеСорнойПримеси.Заголовок    = НСтр("ru='Всего Сорная прим.: ';uk='Всього Сміттєва дом.: '") + Форма.СуммарноеЗначениеСорнойПримеси + "%;";
	Элементы.НадписьСуммарноеЗначениеСорнойПримеси.ЦветТекста   = ?(Форма.СуммарноеЗначениеСорнойПримеси <> Объект.СорнаяПримесь, Красный, Синий);
	Элементы.НадписьСуммарноеЗначениеЗерновойПримеси.Заголовок  = НСтр("ru='Всего Зерновая прим.: ';uk='Всього Зернова дом.: '") + Форма.СуммарноеЗначениеЗерновойПримеси + "%;";
	Элементы.НадписьСуммарноеЗначениеЗерновойПримеси.ЦветТекста = ?(Форма.СуммарноеЗначениеЗерновойПримеси <> Объект.ЗерноваяПримесь, Красный, Синий);
		
КонецПроцедуры

&НаСервере
Процедура УправлениеФормойНаСервере()
	
	РассчитатьСуммарноеЗначенияСорнойЗерновойПримеси();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммарноеЗначенияСорнойЗерновойПримеси()
	
	СуммарноеЗначениеСорнойПримеси 	 = 0;
	СуммарноеЗначениеЗерновойПримеси = 0;
	
	Для Каждого СтрРезультатов Из Объект.Результаты Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрРезультатов.Характеристика) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрРезультатов.Характеристика.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			
			Если НЕ СтрРезультатов.Значение = Неопределено Тогда
				Если СтрРезультатов.Характеристика.ТипЗначения.СодержитТип(Тип("Число")) Тогда
					Если СтрРезультатов.Характеристика.ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ВидСорнойПримеси
						И ЗначениеЗаполнено(СтрРезультатов.Значение) Тогда
						СуммарноеЗначениеСорнойПримеси = СуммарноеЗначениеСорнойПримеси + СтрРезультатов.Значение;
					ИначеЕсли СтрРезультатов.Характеристика.ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ВидЗерновойПримеси
						И ЗначениеЗаполнено(СтрРезультатов.Значение) Тогда
						СуммарноеЗначениеЗерновойПримеси = СуммарноеЗначениеЗерновойПримеси + СтрРезультатов.Значение;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНомер()
	
	Если ЗначениеЗаполнено(Объект.Номер) Тогда
		Объект.Номер = "";		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧастьРезультаты()
		
	Если Объект.Результаты.Количество()> 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьТабличнуюЧастьРезультатыЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);  
	Иначе
		ЗаполнитьТабличнуюЧастьРезультатыНаСервере();
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧастьРезультатыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
   	
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда 		
		Возврат;
	КонецЕсли;
	
	Объект.Результаты.Очистить();  	
	
	ЗаполнитьТабличнуюЧастьРезультатыНаСервере();	
			
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьРезультатыНаСервере()
	
	Документы.ИНАГРО_ЛабораторныйАнализ.ЗаполнитьТабличнуюЧастьРезультаты(Объект);
	
	ЗаполнитьДобавленныеКолонкиТаблицыРезультаты();	
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблицыРезультаты()
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Результаты Цикл
			
		Если СтрокаТабличнойЧасти.Характеристика.ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ВидСорнойПримеси Тогда
			СтрокаТабличнойЧасти.ЦветФона = 1;
		ИначеЕсли СтрокаТабличнойЧасти.Характеристика.ТипХарактеристики = Перечисления.ИНАГРО_ТипыХарактеристик.ВидЗерновойПримеси Тогда
			СтрокаТабличнойЧасти.ЦветФона = 2; 			
		Иначе
			СтрокаТабличнойЧасти.ЦветФона = 0;			
		КонецЕсли;
		
	КонецЦикла;		
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВидаКультурыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		
		СписокВыбора.Очистить();
		
		ВыборВидаКультурыЗавершениеНаСервере(РезультатЗакрытия);
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборВидаХарактеристикиИзСпискаЗавершение", ЭтаФорма);
		
		ПоказатьВыборИзСписка(ОповещениеОЗакрытии, СписокВыбора, ДополнительныеПараметры.Элемент);
		
	КонецЕсли;  
		 	
КонецПроцедуры
	
&НаСервере
Процедура ВыборВидаКультурыЗавершениеНаСервере(Знач Выбор)
	
	СписокВыбора.ЗагрузитьЗначения(Выбор.ВидыХарактеристик.ВыгрузитьКолонку("ВидХарактеристики")); 		
			 	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВидаХарактеристикиИзСпискаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
		
	Если РезультатЗакрытия <> Неопределено Тогда
		
		ТекущиеДанные = Элементы.Результаты.ТекущиеДанные;
				
		ДанныеСтрокиТаблицы = Новый Структура("Характеристика, ЕдиницаИзмерения, Значение");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
		ДанныеСтрокиТаблицы.Вставить("Характеристика", РезультатЗакрытия.Значение); 
		
		ВыборВидаХарактеристикиИзСпискаЗавершениеНаСервере(ДанныеСтрокиТаблицы);
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыборВидаХарактеристикиИзСпискаЗавершениеНаСервере(СтрокаТабличнойЧасти);
	
	Характеристика = СтрокаТабличнойЧасти.Характеристика;
	
	Если ЗначениеЗаполнено(Характеристика) Тогда
		СтрокаТабличнойЧасти.Характеристика   = Характеристика;		
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = Характеристика.ЕдиницаИзмерения;	
		СтрокаТабличнойЧасти.Значение         = Характеристика.ТипЗначения.ПривестиЗначение(СтрокаТабличнойЧасти.Значение);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ВыборВидаХарактеристикиИзСписка(Элемент)
	
	СписокВыбора.Очистить();	
		
	ВыборВидаКультурыЗавершениеНаСервере(ВидКультуры);	
		
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборВидаХарактеристикиИзСпискаЗавершение", ЭтаФорма);
			
	ПоказатьВыборИзСписка(ОповещениеОЗакрытии, СписокВыбора, Элемент);
			 	
КонецПроцедуры 

&НаСервере
Функция ПолучитьЗначениеХарактеристики(ТаблицаХарактеристик, Характеристика, КвоЛабАнализов)
	
	Рез = 0;
	
	СтрТабХарактеристик = ТаблицаХарактеристик.Найти(Характеристика);
	
	Если СтрТабХарактеристик <> Неопределено Тогда
		Если КвоЛабАнализов = 1 Тогда
			Рез = СтрТабХарактеристик.КачествоЗерна;
		Иначе			
			Рез = ИНАГРО_Элеватор.Процент(СтрТабХарактеристик.Вес, СтрТабХарактеристик.ЦентнероПроценты);
		КонецЕсли
	КонецЕсли;	
	
	Возврат Рез;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыДляДоговоров()

	ПараметрыОтбора = Новый Структура("ВидХранения, Урожай");
	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Объект);

	Возврат ПараметрыОтбора;

КонецФункции

&НаСервере
Функция НайтиСтрокуТабличнойЧасти(СтруктураОтбора)
	
	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект.Результаты.НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;
	
	Возврат СтрокаТабличнойЧасти;
	
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