#Область ОбработчикиСобытийФормы

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
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПодготовитьФормуНаСервере();
	
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
Процедура ОрганизацияПриИзменении(Элемент)

	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	ТребуетсяВызовСервера = Ложь;

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура СпецРежимНалогообложенияПриИзменении(Элемент)
	
	ЭлементСпискаЗначений = Элемент.СписокВыбора.НайтиПоЗначению(Объект.СпецРежимНалогообложения);
	РасшифровкаСпецРежимНалогообложения = ?(ЭлементСпискаЗначений = Неопределено, "", ЭлементСпискаЗначений.Представление);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоПриходу(Команда)

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстПредупреждения = НСтр("ru='Заполнить документ можно только после его записи';uk='Заповнити документ можна тільки після його запису'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;	

	Если Объект.ОС.Количество() > 0 Тогда
		ТекстВопроса	= НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьПоПриходуЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьПоПриходуЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьПоПриходуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
    	Объект.ОС.Очистить();
		
		ЗаполнитьПоПриходуЗавершение();
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПриходуЗавершение()
    
    ДатаНач = НачалоГода(Объект.Дата);
    ДатаКон = КонецДня(Объект.Дата);
    
    ПараметрыФормыВыбора = Новый Структура("НачалоПериода,КонецПериода", ДатаНач, ДатаКон);
    ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
    ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыФормыВыбора, , , , , ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиОС

&НаКлиенте
Процедура ОСДатаНачалаИспользованияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	ТекущиеДанные.ДатаФормированияКредита = ТекущиеДанные.ДатаНачалаИспользования;
КонецПроцедуры

&НаКлиенте
Процедура ОСБазаНДСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	
	ДанныеСтроки = ДанныеСтроки(ТекущиеДанные);
	
	РассчитатьСуммуНДСиПропорционально(ДанныеСтроки, КоэффициентПропорциональногоНДС);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаНДСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	
	ДанныеСтроки = ДанныеСтроки(ТекущиеДанные);
	
	РассчитатьСуммуНДСиПропорционально(ДанныеСтроки, КоэффициентПропорциональногоНДС);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ТекущаяДатаДокумента			= Объект.Дата;
	
	Если Элементы.СпецРежимНалогообложения.СписокВыбора.Количество() = 0 Тогда
		УчетНДС.ЗаполнитьСписокВыбораСпецРежимаНалогообложения(Элементы.СпецРежимНалогообложения.СписокВыбора);
	КонецЕсли;
	ЭлементСпискаЗначений 				= Элементы.СпецРежимНалогообложения.СписокВыбора.НайтиПоЗначению(Объект.СпецРежимНалогообложения);
	РасшифровкаСпецРежимНалогообложения = ?(ЭлементСпискаЗначений = Неопределено, "", ЭлементСпискаЗначений.Представление);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	КоэффициентПропорциональногоНДС = НалоговыйУчет.ПолучитьКоэффициентПропорциональногоНДС(Объект.Организация, Объект.Дата);

КонецПроцедуры 

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();

КонецПроцедуры

&НаКлиенте
Функция ДанныеСтроки(СтрокаТабличнойЧасти)
	
	ДанныеСтроки = Новый Структура("СуммаНДС, БазаНДС, СуммаНДСПропорциональноКредит");
	
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТабличнойЧасти);
	
	Возврат ДанныеСтроки;
	
КонецФункции

&НаСервере
Процедура РассчитатьСуммуНДСиПропорционально(Строка, КоэффициентПропорциональногоНДС)
    
    Строка.СуммаНДС = Строка.БазаНДС * УчетНДС.ПолучитьСтавкуНДС(Перечисления.СтавкиНДС.НДС20) / 100;
	
	РассчитатьСуммуНДСПропорционально(Строка, КоэффициентПропорциональногоНДС);

КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуНДСПропорционально(Строка, КоэффициентПропорциональногоНДС)
    
    Строка.СуммаНДСПропорциональноКредит = Строка.СуммаНДС * КоэффициентПропорциональногоНДС;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Сообщить(НСтр("ru='Заполнение не произведено!';uk='Заповнення не виконано'"));
		Возврат;
	КонецЕсли;

	ЗаполнитьПоПриходуНаСервере(РезультатВыбора.НачалоПериода, РезультатВыбора.КонецПериода);
	
	Если Объект.ОС.Количество() > 0 Тогда
		ТекстПредупреждения = НСтр("ru='Режим налогообложения НДС, даты формирования кредита и суммы в табличной части необходимо проверить и при необходимости откорректировать вручную!';uk='Режим оподаткування ПДВ, дати формування кредиту та суми у табличній частині потрібно перевірити та при необхідності відкоригувати вручну!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	Иначе	
		ТекстПредупреждения = НСтр("ru='Нет данных для заполнения!';uk='Немає даних для заповнення!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПриходуНаСервере(ДатаНач, ДатаКон)
	
	// Заполнение документа происходит следующим образом: после указания даты начала выборки будет произведен 
	// анализ поступления на 10-й и 11-й счета по пропорцинальному налоговому назначению по НДС. Все суммы в табличной части будут получены расчетным образом 
	// даты возникновения кредита будет приравнена к дате поступления  
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА Обороты.Субконто1 ССЫЛКА Справочник.ОсновныеСредства
	               |			ТОГДА Обороты.Субконто1
	               |		КОГДА Обороты.Субконто1 ССЫЛКА Справочник.НематериальныеАктивы
	               |			ТОГДА Обороты.Субконто1
	               |		КОГДА Обороты.Субконто1 ССЫЛКА Справочник.Номенклатура
	               |			ТОГДА Обороты.Субконто1
	               |		КОГДА Обороты.Субконто2 ССЫЛКА Справочник.ОсновныеСредства
	               |			ТОГДА Обороты.Субконто2
	               |		КОГДА Обороты.Субконто2 ССЫЛКА Справочник.НематериальныеАктивы
	               |			ТОГДА Обороты.Субконто2
	               |		КОГДА Обороты.Субконто2 ССЫЛКА Справочник.Номенклатура
	               |			ТОГДА Обороты.Субконто2
	               |		КОГДА Обороты.Субконто3 ССЫЛКА Справочник.ОсновныеСредства
	               |			ТОГДА Обороты.Субконто3
	               |		КОГДА Обороты.Субконто3 ССЫЛКА Справочник.НематериальныеАктивы
	               |			ТОГДА Обороты.Субконто3
	               |		КОГДА Обороты.Субконто3 ССЫЛКА Справочник.Номенклатура
	               |			ТОГДА Обороты.Субконто3
	               |		ИНАЧЕ НЕОПРЕДЕЛЕНО
	               |	КОНЕЦ КАК НеоборотныйАктив,
	               |	НАЧАЛОПЕРИОДА(Обороты.Период, МЕСЯЦ) КАК ДатаНачалаИспользования,
	               |	НАЧАЛОПЕРИОДА(Обороты.Период, МЕСЯЦ) КАК ДатаФормированияКредита,
	               |	Обороты.СуммаОборотДт КАК СуммаОборот
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(
	               |			&ДатаНач,
	               |			&ДатаКон,
	               |			МЕСЯЦ,
	               |			Счет В ИЕРАРХИИ (&СчетаОС),
	               |			,
	               |			НалоговоеНазначение = &ПропорциональныйНДС
	               |				И Организация = &Организация,
	               |			,
	               |			) КАК Обороты
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Обороты.Период";
	
	Запрос.УстановитьПараметр("ДатаНач", 		ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", 		ДатаКон);	
	Запрос.УстановитьПараметр("Организация", 	Объект.Организация);	
	Запрос.УстановитьПараметр("ПропорциональныйНДС", 	Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально);	
	СчетаОС = Новый Массив();
	СчетаОС.Добавить(ПланыСчетов.Хозрасчетный.ОсновныеСредства);
	СчетаОС.Добавить(ПланыСчетов.Хозрасчетный.ДругиеНеоборотныеМатериальныеАктивыГруппа);
	СчетаОС.Добавить(ПланыСчетов.Хозрасчетный.НематериальныеАктивы);
	Запрос.УстановитьПараметр("СчетаОС", СчетаОС);	
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	ЗначениеСтавкиНДС20 = УчетНДС.ПолучитьСтавкуНДС(Перечисления.СтавкиНДС.НДС20) / 100;
	
	// теперь проведем расчет базы, суммы НДС и налогового кредита. На текущий момент в колонке СуммаОборот находится стоимость ОС, которая включает частично НДС, не относящийся на кредит.
	Пока Выборка.Следующий() Цикл
		
		ТекущаяСтрока = Объект.ОС.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Выборка);
		
		ТекущаяСтрока.БазаНДС = Выборка.СуммаОборот / (1 + ЗначениеСтавкиНДС20 * (1 - КоэффициентПропорциональногоНДС));		
		
		ТекущаяСтрока.СуммаНДС = ТекущаяСтрока.БазаНДС * ЗначениеСтавкиНДС20;
		
		ТекущаяСтрока.СуммаНДСПропорциональноКредит = (ТекущаяСтрока.СуммаНДС + ТекущаяСтрока.БазаНДС) - Выборка.СуммаОборот;
	
	КонецЦикла;
	
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
