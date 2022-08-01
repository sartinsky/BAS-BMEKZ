#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		// ИНАГРО++
		Параметры.Свойство("IDСтроки", ИНАГРО_IDСтроки);
		ИНАГРО_ЭтоНовый = Истина;
	Иначе
		ИНАГРО_ЭтоНовый = Ложь;
		// ИНАГРО-- 
	КонецЕсли;

	ПерерасчетПроизведен = Истина;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборОсновныхСредств.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
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
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьДобавленныеКолонкиТаблиц();
	ПерерасчетПроизведен = Истина;	
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии() // ИНАГРО
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИНАГРО_ОбъектыБСПУ") Тогда
		
		Если НЕ Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ИНАГРО_ДокументОперативногоУчета) И ИНАГРО_ЭтоНовый = Истина Тогда
			
			СтруктураВозврата = Новый Структура;
			СтруктураВозврата.Вставить("ДокументСсылка", Объект.Ссылка);
			СтруктураВозврата.Вставить("IDСтроки",  	 ИНАГРО_IDСтроки);
			
			Если ТипЗнч(Объект.ИНАГРО_ДокументОперативногоУчета) = Тип("ДокументСсылка.ИНАГРО_РеализацияБиологическихАктивов") Тогда						
				Оповестить("РеализацияБА_ВозвратДокументСсылкаОС", СтруктураВозврата, ЭтаФорма); 			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти    //ОбработчикиСобытийФормы

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
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
		
	Если НЕ ТребуетсяВызовСервера Тогда
		// Проверим наличие строк в табличной части.
		Если Объект.ОС.Количество() > 0 Тогда
			ТребуетсяВызовСервера = НЕ ЗначениеЗаполнено(МаксПериодПервоначальныхСведенийОС) 
				ИЛИ (МаксПериодПервоначальныхСведенийОС >= Объект.Дата);
		КонецЕсли;
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДокПодготовкаКПередачеОСПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(Объект.ДокПодготовкаКПередачеОС) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ОС.Количество() > 0 Тогда

		ПоказатьВопрос(Новый ОписаниеОповещения("ДокПодготовкаКПередачеОСПриИзмененииЗавершение", ЭтотОбъект), НСтр("ru='При заполнении существующие данные в табличной части будут удалены.
|Продолжить?';uk='При заповненні існуючі дані в табличній частині будуть вилучені.
|Продовжити?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
        Возврат;
	КонецЕсли;

    ЗаполнитьДокументПоПодготовкеКПередаче();
КонецПроцедуры

&НаКлиенте
Процедура ДокПодготовкаКПередачеОСПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьДокументПоПодготовкеКПередаче();

КонецПроцедуры

&НаКлиенте
Процедура ЦеныИВалютаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВалютаДоИзменения    = Объект.ВалютаДокумента;
	КурсДоИзменения    	 = Объект.КурсВзаиморасчетов;
	КратностьДоИзменения = Объект.КратностьВзаиморасчетов;

	// Формирование структуры параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента"     , Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс"                , Объект.КурсВзаиморасчетов);
	СтруктураПараметров.Вставить("Кратность"           , Объект.КратностьВзаиморасчетов);
	СтруктураПараметров.Вставить("СуммаВключаетНДС"    , Объект.СуммаВключаетНДС);
	СтруктураПараметров.Вставить("Контрагент"          , Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор"             , Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация"         , Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента"       , Объект.Дата);
	СтруктураПараметров.Вставить("ПересчитатьЦены"     , Ложь);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения", Ложь);
	СтруктураПараметров.Вставить("АвторасчетНДС"	   , Объект.АвторасчетНДС);	
	СтруктураПараметров.Вставить("ПлательщикНДС"	   , ПлательщикНДС);

	ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,, Новый ОписаниеОповещения("ЦеныИВалютаНажатиеЗавершение", ЭтотОбъект, Новый Структура("ВалютаДоИзменения, КратностьДоИзменения, КурсДоИзменения", ВалютаДоИзменения, КратностьДоИзменения, КурсДоИзменения)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦеныИВалютаНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВалютаДоИзменения = ДополнительныеПараметры.ВалютаДоИзменения;
    КратностьДоИзменения = ДополнительныеПараметры.КратностьДоИзменения;
    КурсДоИзменения = ДополнительныеПараметры.КурсДоИзменения;
    
    
    СтруктураЦеныИВалюта = Результат;
    
    Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") И СтруктураЦеныИВалюта.БылиВнесеныИзменения Тогда
        
        Объект.ВалютаДокумента         = СтруктураЦеныИВалюта.ВалютаДокумента;
        Объект.КурсВзаиморасчетов      = СтруктураЦеныИВалюта.Курс;
        Объект.КратностьВзаиморасчетов = СтруктураЦеныИВалюта.Кратность;
        Объект.СуммаВключаетНДС        = СтруктураЦеныИВалюта.СуммаВключаетНДС;
		Объект.АвторасчетНДС 		   = СтруктураЦеныИВалюта.АвторасчетНДС;
        
        Модифицированность = Истина;
        
        ПересчитатьНДС = СтруктураЦеныИВалюта.СуммаВключаетНДС <> СтруктураЦеныИВалюта.ПредСуммаВключаетНДС;
        Если СтруктураЦеныИВалюта.ПересчитатьЦены ИЛИ ПересчитатьНДС Тогда
            ЗаполнитьРассчитатьСуммы(ВалютаДоИзменения, 
            КурсДоИзменения, 
            КратностьДоИзменения, 
            СтруктураЦеныИВалюта.ПересчитатьЦены, 
            ПересчитатьНДС);
		КонецЕсли;
		
		Если Объект.АвторасчетНДС Тогда
			// соответствие для хранения погрешностей округлений
			ПогрешностиОкругления = Новый Соответствие();
			// пересчет сумм НДС с учетом ошибок округления
			УчетНДСКлиентСервер.ПересчитатьНДСсУчетомПогрешностиОкругления(Объект.ОС, Объект.Ссылка, Объект.СуммаВключаетНДС, ПогрешностиОкругления, "ОС", Строка(Объект.ВалютаДокумента));
			// Установим признак перерасчета сумм НДС
			ПерерасчетПроизведен = ИСТИНА;
			ЗаполнитьДобавленныеКолонкиТаблиц();
			ОбновитьИтоги(ЭтотОбъект); 
		КонецЕсли;
        
        СформироватьНадписьЦеныИВалюта(ЭтаФорма);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");

КонецПроцедуры

&НаКлиенте
Процедура ПолучилНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейБП.ПредставительКонтрагентаНачалоВыбора(Объект.Контрагент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	ГрузополучательПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучилПоДругомуДокументуПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти	 //ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока И НЕ Копирование Тогда
		ПриДобавленииОС(ЭтаФорма, Элементы.ОС.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)

	Если НоваяСтрока И ОтменаРедактирования Тогда
		Элемент.ТекущиеДанные.Всего = Элемент.ТекущиеДанные.Сумма + ?(Объект.СуммаВключаетНДС, 0, Элемент.ТекущиеДанные.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСПриИзменении(Элемент)

	ОбновитьИтоги(ЭтаФорма);
	ПерерасчетПроизведен = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ОСПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И ОтменаРедактирования Тогда
		ОбновитьИтоги(ЭтаФорма);
		ПерерасчетПроизведен = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)

	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
	Иначе
		СтруктураСведений 					= СведенияОбИнвентарномНомереОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
		СтрокаТЧ.ИнвентарныйНомер 			= СтруктураСведений.ИнвентарныйНомер;
		МаксПериодПервоначальныхСведенийОС 	= Макс(МаксПериодПервоначальныхСведенийОС, СтруктураСведений.Период);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОССчетДоходовПриИзменении(Элемент)

	СтрокаТаблицы = Элементы.ОС.ТекущиеДанные;

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СтрокаТаблицы.СчетДоходов);

	ПоляОбъекта = Новый Структура("Субконто1", "Субконто");
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(СтрокаТаблицы.СчетДоходов, СтрокаТаблицы, ПоляОбъекта, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОССубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтрокаТаблицы = Элементы.ОС.ТекущиеДанные;

	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("СчетУчета", СтрокаТаблицы.СчетДоходов);
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);

КонецПроцедуры

&НаКлиенте
Процедура ОССуммаПриИзменении(Элемент)

	ПересчитатьСуммуНДСПоТекущейСтроке();

КонецПроцедуры

&НаКлиенте
Процедура ОССтавкаНДСПриИзменении(Элемент)

	ПересчитатьСуммуНДСПоТекущейСтроке();

КонецПроцедуры

&НаКлиенте
Процедура ОССуммаНДСПриИзменении(Элемент)

	Строка = Элементы.ОС.ТекущиеДанные;
	Строка.Всего = Строка.Сумма + ?(Объект.СуммаВключаетНДС, 0, Строка.СуммаНДС);

КонецПроцедуры

&НаКлиенте
Процедура ОССтоимостьБУПриИзменении(Элемент)
	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОСАмортизацияБУПриИзменении(Элемент)
	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОСАмортизацияЗаМесяцБУПриИзменении(Элемент)
	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОССтоимостьНУПриИзменении(Элемент)
	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОСАмортизацияНУПриИзменении(Элемент)
	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОСАмортизацияЗаМесяцНУПриИзменении(Элемент)
	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка) // ИНАГРО
	
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() И ЗначениеЗаполнено(Объект.ИНАГРО_ДокументОперативногоУчета) Тогда	
		
		СтандартнаяОбработка = Ложь;
		
		МодульИНАГРО_БиологическиеАктивы = ОбщегоНазначенияКлиент.ОбщийМодуль("ИНАГРО_БиологическиеАктивы");
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Ссылка", МодульИНАГРО_БиологическиеАктивы.СформироватьСписокОС(Объект.ИНАГРО_БиологическийАктив, Объект.ИНАГРО_Склад, Объект.Дата));
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
		ОткрытьФорму("Справочник.ОсновныеСредства.ФормаВыбора", ПараметрыФормы, Элемент);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти	 //ОбработчикиСобытийЭлементовТаблицыФормыОС

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)

	ОсновноеСредство = УправлениеВнеоборотнымиАктивамиКлиент.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));

	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда

		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаОС(Команда)

	Если Объект.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Заполнение возможно только в непроведенном документе';uk='Заповнення можливе тільки в непроведеному документі'"), 60);
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат;
	КонецЕсли;

	ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны!
|Продолжить?';uk='При заповненні існуючі дані будуть перераховані!
|Продовжити?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьДляСпискаОСЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСпискаОСЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьДляСпискаОССервер();

КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ПараметрыФормы = Новый Структура;
	Если Объект.ОС.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("АдресОСВХранилище", ПоместитьОСВХранилище());
	КонецЕсли;

	ОткрытьФорму("Обработка.ПодборОсновныхСредств.Форма.Форма", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСоставКомиссии(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

#КонецОбласти    //ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();

	ТекущаяДатаДокумента = Объект.Дата;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	ДоговорУказан = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.ДоговорКонтрагента, "ВидДоговора, ВалютаВзаиморасчетов, ВедениеВзаиморасчетов, СложныйНалоговыйУчет");
	
	ВедениеВзаиморасчетовПоРасчетнымДокументам = ДоговорУказан И РеквизитыДоговора.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам;
	СложныйНалоговыйУчет = ДоговорУказан И РеквизитыДоговора.СложныйНалоговыйУчет;
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	РеализацияТоваровУслугФормы.ЗаполнитьСписокАдресовДоставки(ЭтаФорма, Объект.Контрагент, Объект.Грузополучатель);

	УправлениеФормой(ЭтаФорма);

	УстановитьЗаголовкиКолонок();
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПлательщикНДС				= УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);
	ПлательщикНалогаНаПрибыль  	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПлательщикНалогаНаПрибыльДо2015  	= УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	// Доступность взаимосвязанных полей
	Элементы.ДоговорКонтрагента.Доступность       = ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент);
	Элементы.ДокПодготовкаКПередачеОС.Доступность = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);

	Элементы.Сделка.Доступность = Форма.ВедениеВзаиморасчетовПоРасчетнымДокументам;
	
	Элементы.СчетУчетаНДС.Доступность                     = Форма.ПлательщикНДС;
	Элементы.СчетУчетаНДСПодтвержденный.Доступность       = Форма.ПлательщикНДС И НЕ Форма.СложныйНалоговыйУчет;
	
	Элементы.ГруппаРеквизитыДоверенностиЛевая.Видимость = НЕ Объект.ПолучилПоДругомуДокументу; 
	Элементы.ДокументПодтверждающийПолномочия.Видимость = Объект.ПолучилПоДругомуДокументу; 
	
	Элементы.ОСНалоговоеНазначениеДоходовИЗатрат.Видимость = Форма.ПлательщикНалогаНаПрибыльДо2015;
	
	Элементы.ГруппаДанныеОперативногоУчета.Видимость = ЗначениеЗаполнено(Объект.ИНАГРО_ДокументОперативногоУчета); // ИНАГРО
	
	Элементы.ОССтавкаНДС.Видимость 			= Форма.ПлательщикНДС;
	Элементы.ОССуммаНДС.Видимость 			= Форма.ПлательщикНДС;
	
	Элементы.ГруппаИтогиВсегоНДС.Видимость 	= Форма.ПлательщикНДС;
	
	ОбновитьИтоги(Форма);
	СформироватьНадписьЦеныИВалюта(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДляСпискаОССервер()

	Если НЕ УчетнаяПолитика.Существует(Объект.Организация, Объект.Дата) Тогда
		ТекстСообщения = НСтр("ru='Не задана учетная политика организации %1 на %2.';uk='Не задана облікова політика організації %1 на %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, Объект.Организация, Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ДокПодготовкаКПередачеОС) Тогда
	
		УправлениеНеоборотнымиАктивами.ЗаполнитьТабличнуюЧастьОсновныхСредств(Объект.Дата, Объект.ОС, Объект.Организация, ПлательщикНалогаНаПрибыль);
		
		Для Каждого Строка Из Объект.ОС Цикл
			РассчитатьВычисляемыеПоляПоСтроке(Строка);
			ПриДобавленииОС(ЭтаФорма, Строка);
		КонецЦикла;
		
	Иначе
		
		ЗаполнитьДокументПоПодготовкеКПередаче();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьВычисляемыеПоляПоСтроке(Строка)

	Строка.ОставшаясяСтоимостьБУ = Строка.СтоимостьБУ - Строка.АмортизацияБУ - Строка.АмортизацияЗаМесяцБУ;
	Строка.ОставшаясяСтоимостьНУ = Строка.СтоимостьНУ - Строка.АмортизацияНУ - Строка.АмортизацияЗаМесяцНУ;

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

// Обслуживание цен / валют / налогов:

 &НаСервере
Процедура ЗаполнитьРассчитатьСуммы(ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, ПересчитатьЦены = Ложь, ПересчитатьНДС = Ложь)

	Если ПересчитатьЦены Тогда
		Если КурсДоИзменения <> 0 И КратностьДоИзменения <> 0 Тогда
			СтруктураКурса = Новый Структура("Курс, Кратность", КурсДоИзменения, КратностьДоИзменения);
		Иначе
			СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДоИзменения, Объект.Дата);
		КонецЕсли;
	КонецЕсли;

	Для каждого СтрокаТаблицы Из Объект.ОС Цикл
		ЗаполнитьРассчитатьСуммыВСтроке(СтрокаТаблицы,ВалютаДоИзменения,
			СтруктураКурса, ПересчитатьЦены, ПересчитатьНДС, Истина, 0);
	КонецЦикла;

	ОбновитьИтоги(ЭтаФорма);
	ПерерасчетПроизведен = Ложь;	

	Если ПересчитатьНДС Тогда
		УстановитьЗаголовкиКолонок();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСуммыВСтроке(СтрокаТаблицы, ВалютаПередИзменением, СтруктураКурса, ПересчитатьЦены, ПересчитатьНДС, ЕстьНДС, ЗначениеПустогоКоличества)

	Если ПересчитатьЦены Тогда
		Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
			СтрокаТаблицы.Сумма,
			ВалютаПередИзменением, Объект.ВалютаДокумента, 
			СтруктураКурса.Курс, Объект.КурсВзаиморасчетов,
			СтруктураКурса.Кратность, Объект.КратностьВзаиморасчетов);
	Иначе
		Сумма = СтрокаТаблицы.Сумма;
	КонецЕсли;

	// Признак того, что цена включает НДС, хранится в реквизите СуммаВключаетНДС документа
	ЦенаВключаетНДС = ?(ПересчитатьНДС, НЕ Объект.СуммаВключаетНДС, Объект.СуммаВключаетНДС);

	Если ЕстьНДС Тогда
		СтрокаТаблицы.Сумма = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
			Сумма, ЦенаВключаетНДС, Объект.СуммаВключаетНДС, 
			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));

		СтрокаТаблицы.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
			СтрокаТаблицы.Сумма, Объект.СуммаВключаетНДС, 
			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));

		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	Иначе
		СтрокаТаблицы.Сумма = СтрокаТаблицы.Цена * ?(СтрокаТаблицы.Количество = 0, ЗначениеПустогоКоличества, СтрокаТаблицы.Количество);
	КонецЕсли;

КонецПроцедуры

// Серверная обработка изменения реквизитов:

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	ДатаОбработатьИзменение();
	УстановитьЗаголовкиКолонок();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ДатаОбработатьИзменение()

	ПредыдущаяОрганизацияПлательщикНДС = ПлательщикНДС;
	
	УстановитьФункциональныеОпцииФормы();
	
	// Если изменился статус плательщика НДС необходимо перезаполнить ставки НДС
	Если ПредыдущаяОрганизацияПлательщикНДС <> ПлательщикНДС Тогда
		ПересчитатьСуммыПриИзмененииПризнакаПлательщикНДС();
	КонецЕсли;
	
	Если (Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
	ЗаполнитьИнвентарныеНомераОС();

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	Объект.Сделка = Неопределено;
	
	ПредыдущаяОрганизацияПлательщикНДС = ПлательщикНДС;
	
	УстановитьФункциональныеОпцииФормы();
	
	// Если изменился статус плательщика НДС необходимо перезаполнить ставки НДС
	Если ПредыдущаяОрганизацияПлательщикНДС <> ПлательщикНДС Тогда
		ПересчитатьСуммыПриИзмененииПризнакаПлательщикНДС();
	КонецЕсли;
	
	ЗаполнитьИнвентарныеНомераОС();
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентОбработатьИзменение();
	КонецЕсли;
	
	УстановитьЗаголовкиКолонок();	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	КонтрагентОбработатьИзменение();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентОбработатьИзменение()

	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(
		Объект.ДоговорКонтрагента, Объект.Контрагент, Объект.Организация,
		БухгалтерскийУчетПереопределяемый.ПолучитьМассивВидовДоговоров(, Истина));
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаОбработатьИзменение();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаПриИзмененииНаСервере()
	
	ДоговорКонтрагентаОбработатьИзменение();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Дата"                 , Объект.Дата);
	ПараметрыОбъекта.Вставить("ДоговорКонтрагента"   , Объект.ДоговорКонтрагента);
	ПараметрыОбъекта.Вставить("Контрагент"           , Объект.Контрагент);
	ПараметрыОбъекта.Вставить("СчетУчета"            , Объект.СчетУчетаРасчетовПоАвансам);
	ПараметрыОбъекта.Вставить("Организация"          , Объект.Организация);
	ПараметрыОбъекта.Вставить("ОстаткиОбороты"       , "Кт");
	ПараметрыОбъекта.Вставить("ТипыДокументов"       , "Метаданные.Документы.ПередачаОС.Реквизиты.Сделка.Тип");

	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);
		
КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаОбработатьИзменение()

	ВалютаДоИзменения = Объект.ВалютаДокумента;
	КурсДоИзменения   = Объект.КурсВзаиморасчетов;
	КратностьДоИзменения = Объект.КратностьВзаиморасчетов;

	ДоговорУказан     = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.ДоговорКонтрагента, "ВидДоговора, ВалютаВзаиморасчетов, ВедениеВзаиморасчетов, СложныйНалоговыйУчет");
	
	Объект.ВалютаДокумента         = РеквизитыДоговора.ВалютаВзаиморасчетов;
	СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
	Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
	Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;

	ПересчитатьЦены = Объект.ВалютаДокумента <> ВалютаДоИзменения
		ИЛИ Объект.КурсВзаиморасчетов <> КурсДоИзменения;
	ПересчитатьНДС = Ложь;

	Если Объект.ОС.Количество() > 0 И ПересчитатьЦены Тогда
		ЗаполнитьРассчитатьСуммы(ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, ПересчитатьЦены, ПересчитатьНДС);
	КонецЕсли;
	
	ВедениеВзаиморасчетовПоРасчетнымДокументам = ДоговорУказан И РеквизитыДоговора.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам;
	СложныйНалоговыйУчет = ДоговорУказан И РеквизитыДоговора.СложныйНалоговыйУчет;
	
	Если Не ВедениеВзаиморасчетовПоРасчетнымДокументам Тогда
		Если ЗначениеЗаполнено(Объект.Сделка) Тогда
			Объект.Сделка = Неопределено;
		КонецЕсли;	
	КонецЕсли;
		
	Документы.ПередачаОС.ЗаполнитьСчетаУчетаРасчетов(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ГрузополучательПриИзмененииНаСервере()
	
	ГрузополучательОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ГрузополучательОбработатьИзменение()
	
	РеализацияТоваровУслугФормы.ЗаполнитьСписокАдресовДоставки(ЭтаФорма, Объект.Контрагент, Объект.Грузополучатель);
	Если Элементы.АдресДоставки.СписокВыбора.Количество() > 0 Тогда
		Объект.АдресДоставки = Элементы.АдресДоставки.СписокВыбора[0].Значение;
	Иначе
		Объект.АдресДоставки = "";
	КонецЕсли;
	
КонецПроцедуры

// Внешний вид, содержание надписей и т.п.

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)

	Форма.ИтогиВсего = Форма.Объект.ОС.Итог("Всего");

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиКолонок()
	
	//ЗаголовокСумма = ?(Объект.СуммаВключаетНДС, НСтр("ru='Сумма с НДС';uk='Сума з ПДВ'"), НСтр("ru='Сумма без НДС';uk='Сума без ПДВ'"));
	ЗаголовокСумма = ?(ПлательщикНДС, ?(Объект.СуммаВключаетНДС, НСтр("ru='Сумма с НДС';uk='Сума з ПДВ'"), НСтр("ru='Сумма без НДС';uk='Сума без ПДВ'")), НСтр("ru='Сумма';uk='Сума'"));
	
	Элементы.ОССумма.Заголовок = ЗаголовокСумма;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьНадписьЦеныИВалюта(Форма)
	
	Объект = Форма.Объект;
	СтруктураНадписи = Новый Структура(
		"ВалютаДокумента, Курс, Кратность, ВалютаРегламентированногоУчета",
		Объект.ВалютаДокумента,
		Объект.КурсВзаиморасчетов,
		Объект.КратностьВзаиморасчетов,
		Форма.ВалютаРегламентированногоУчета);
	Если Форма.ПлательщикНДС Тогда 
		СтруктураНадписи.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
		СтруктураНадписи.Вставить("АвторасчетНДС", 	  Объект.АвторасчетНДС);
	КонецЕсли; 
	Форма.ЦеныИВалюта = ОбщегоНазначенияБПКлиентСервер.СформироватьНадписьЦеныИВалюта(СтруктураНадписи);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет)

	ПоляФормы = Новый Структура("Субконто1", "ОССубконто");

	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, Неопределено, Истина);

КонецПроцедуры // УстановитьЗаголовкиИДоступностьСубконто()

// Обслуживание подбора:

&НаСервере
Функция ПоместитьОСВХранилище()

	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаОС);

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)

	ДобавленныеСтроки = УчетОС.ОбработатьПодборОсновныхСредств(Объект.ОС, ВыбранноеЗначение);

	Для каждого СтрокаОС Из ДобавленныеСтроки Цикл
		ПриДобавленииОС(ЭтаФорма, СтрокаОС);
	КонецЦикла;

	ЗаполнитьИнвентарныеНомераОС();
	ОбновитьИтоги(ЭтаФорма);
	ПерерасчетПроизведен = Ложь;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)

	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)

	НачальныйИндекс = Объект.ОС.Количество();
	Если УчетОС.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство) Тогда

		Для Индекс = НачальныйИндекс По Объект.ОС.Количество() - 1 Цикл
			СтрокаОС = Объект.ОС[Индекс];
			ПриДобавленииОС(ЭтаФорма, СтрокаОС);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Заполнение табличных частей по основаниям:

&НаСервере
Процедура ЗаполнитьДокументПоПодготовкеКПередаче()

	Объект.ОС.Очистить();

	ТаблицаПодготовкиКПередаче = Объект.ДокПодготовкаКПередачеОС.ОС.Выгрузить();
	Если ТаблицаПодготовкиКПередаче.Количество() > 0 Тогда
		Объект.ОС.Загрузить(ТаблицаПодготовкиКПередаче);
	КонецЕсли;

	ЗаполнитьИнвентарныеНомераОС();

	Для Каждого Строка Из Объект.ОС Цикл
		
		Строка.СтоимостьБУ = Строка.СтоимостьБУ - Строка.АмортизацияБУ - Строка.АмортизацияЗаМесяцБУ;
		Строка.СтоимостьНУ = Строка.СтоимостьНУ - Строка.АмортизацияНУ - Строка.АмортизацияЗаМесяцНУ;
		
		Строка.АмортизацияБУ        = 0;
		Строка.АмортизацияНУ        = 0;
		Строка.АмортизацияЗаМесяцБУ = 0;
		Строка.АмортизацияЗаМесяцНУ = 0;
		
		РассчитатьВычисляемыеПоляПоСтроке(Строка);
		ПриДобавленииОС(ЭтаФорма, Строка);
		
	КонецЦикла;
	
КонецПроцедуры

// Прочий функционал:

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	Для каждого Строка Из Объект.ОС Цикл
		
		Строка.Всего = Строка.Сумма + ?(Объект.СуммаВключаетНДС, 0, Строка.СуммаНДС);
		
		РассчитатьВычисляемыеПоляПоСтроке(Строка);
		
	КонецЦикла;
	
	ЗаполнитьИнвентарныеНомераОС();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнвентарныеНомераОС()

	ТаблицаОС = Объект.ОС.Выгрузить();

	ТаблицаНомеров = УчетОС.ПолучитьТаблицуИнвентарныхНомеровОС(ТаблицаОС,
		Объект.Организация, Объект.Дата);

	ТаблицаОС.ЗагрузитьКолонку(ТаблицаНомеров.ВыгрузитьКолонку("ИнвентарныйНомер"), "ИнвентарныйНомер");
	Объект.ОС.Загрузить(ТаблицаОС);

	// Запомним максимальную дату первоначальных сведений ОС
	ТаблицаНомеров.Сортировать("Период", Новый СравнениеЗначений);
	Если ТаблицаНомеров.Количество() > 0 Тогда
		МаксПериодПервоначальныхСведенийОС = ТаблицаНомеров[ТаблицаНомеров.Количество() - 1].Период;
	Иначе
		МаксПериодПервоначальныхСведенийОС = '0001-01-01';
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОбИнвентарномНомереОС(ОсновноеСредство, Организация, Дата)

	Возврат УчетОС.СведенияОбИнвентарномНомереОС(ОсновноеСредство, Организация, Дата);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриДобавленииОС(Форма, СтрокаТабличнойЧасти)

	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
		Если НЕ Форма.ПлательщикНДС Тогда
			СтрокаТабличнойЧасти.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС");
		Иначе
			СтрокаТабличнойЧасти.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20");
		КонецЕсли;
	КонецЕсли;

	СтрокаТабличнойЧасти.СчетПродажиОС = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.НеоборотныеАктивыИГруппыВыбытияУдерживаемыеДляПродажи");
	
	СтрокаТабличнойЧасти.СхемаРеализации = ПредопределенноеЗначение("Справочник.СхемыРеализации.НО");

КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуНДСПоТекущейСтроке()

	Строка = Элементы.ОС.ТекущиеДанные;
	ОбщегоНазначенияБПКлиент.ПересчитатьСуммуНДС(Строка, Объект.СуммаВключаетНДС);
	Строка.Всего = Строка.Сумма + ?(Объект.СуммаВключаетНДС, 0, Строка.СуммаНДС);

КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммыПриИзмененииПризнакаПлательщикНДС()
	
	МетаданныеДокумента = Объект.Ссылка.Метаданные();
	ПараметрыОбъекта = Новый Структура("Организация, Дата, ПлательщикНДС", Объект.Организация, Объект.Дата, ПлательщикНДС);

	Если Не ПлательщикНДС Тогда
		//организацию-плательщика поменяли на неплательщика, сумма не включала НДС - надо пересчитать;
		ПересчитатьНДС = Не Объект.СуммаВключаетНДС;			
		
		Объект.СуммаВключаетНДС = Истина;
	Иначе
		//организацию-неплательщика поменяли на плательщика;
		ПересчитатьНДС = Ложь;
		
		//заполним ставки до пересчета цены
		Для Каждого Строка Из Объект.ОС Цикл
			ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ПараметрыОбъекта, "ОС", МетаданныеДокумента);
		КонецЦикла;

	КонецЕсли;
			
	ЗаполнитьРассчитатьСуммы( 
		Объект.ВалютаДокумента, 
		Объект.КурсВзаиморасчетов, 
		Объект.КратностьВзаиморасчетов,
		Ложь, // ПересчитатьЦены
		ПересчитатьНДС
	);
	
	Если Не ПлательщикНДС Тогда
		//организацию-плательщика поменяли на неплательщика 
		
		//заполним ставки после пересчета цены
		// и пересчитаем зависимые от ставки колонки СуммаНДС, Всего
		Для Каждого Строка Из Объект.ОС Цикл
			ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(Строка, ПараметрыОбъекта, "ОС", МетаданныеДокумента);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(Строка, Объект.СуммаВключаетНДС);
		КонецЦикла;
	
		ЗаполнитьДобавленныеКолонкиТаблиц();
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти    //СлужебныеПроцедурыИФункции

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

#КонецОбласти    //СлужебныеПроцедурыИФункцииБСП