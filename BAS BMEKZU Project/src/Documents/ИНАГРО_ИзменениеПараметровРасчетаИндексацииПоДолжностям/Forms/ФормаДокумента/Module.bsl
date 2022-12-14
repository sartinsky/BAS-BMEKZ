#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Заполним реквизиты из значений заполнения
		Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда 
			Объект.Организация = Параметры.Организация;
		КонецЕсли;
		Если Параметры.Свойство("Подразделение") И ЗначениеЗаполнено(Параметры.Подразделение) Тогда 
			Объект.Подразделение = Параметры.Подразделение;
		КонецЕсли;
		
		УстановитьФункциональныеОпцииФормы();
		
	КонецЕсли;
		
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
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПодготовитьФормуНаСервере(); 

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСостояниеДокумента(); 	 	

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоШтатномуРасписанию(Команда)
	
	Если Объект.ШтатныеЕдиницы.Количество() > 0 Тогда
		 
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Оповещение = Новый ОписаниеОповещения("ОчиститьТаблицуШтатныеЕдиницыЗавершение", ЭтотОбъект, "ШтатноеРасписание");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		АвтозаполнениеПоШтатномуРасписанию(Объект.Организация, Объект.Дата);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШтатнойРасстановке(Команда)
	
	Если Объект.ШтатныеЕдиницы.Количество() > 0 Тогда
		 
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Оповещение = Новый ОписаниеОповещения("ОчиститьТаблицуШтатныеЕдиницыЗавершение", ЭтотОбъект, "ШтатнаяРасстановка");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		АвтозаполнениеПоШтатнойРасстановке(Объект.Организация, Объект.Дата);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента();
			
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, Объект.Дата);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицуШтатныеЕдиницыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
   	
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
        Возврат;
	Иначе 
		Объект.ШтатныеЕдиницы.Очистить();
	КонецЕсли;
	
	Если ДополнительныеПараметры = "ШтатноеРасписание" Тогда
		АвтозаполнениеПоШтатномуРасписанию(Объект.Организация, Объект.Дата);
	Иначе
		АвтозаполнениеПоШтатнойРасстановке(Объект.Организация, Объект.Дата);	
	КонецЕсли;
		     
КонецПроцедуры

#Область ОбработчикиСобытийАвтозаполнениеРасчет

&НаСервере
// Выполняет автозаполнение.
//
Процедура АвтозаполнениеПоШтатномуРасписанию(Организация, ДатаАктуальности)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаАктуальности", ДатаАктуальности);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ШтатноеРасписаниеОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	ШтатноеРасписаниеОрганизаций.Должность КАК Должность
		|ИЗ
		|	РегистрСведений.ИНАГРО_ШтатноеРасписаниеОрганизаций.СрезПоследних(&ДатаАктуальности, ПодразделениеОрганизации.Владелец = &Организация ) КАК ШтатноеРасписаниеОрганизаций
		|ГДЕ
		|	ШтатноеРасписаниеОрганизаций.КоличествоСтавок > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПодразделениеОрганизации.Наименование,
		|	Должность.Наименование";
		
	Объект.ШтатныеЕдиницы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
// Выполняет автозаполнение.
//
Процедура АвтозаполнениеПоШтатнойРасстановке(Организация, ДатаАктуальности)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаАктуальности", ДатаАктуальности);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Должность КАК Должность
		|ИЗ
		|	РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация ) КАК РаботникиОрганизаций
		|ГДЕ
		|	РаботникиОрганизаций.ЗанимаемыхСтавок > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПодразделениеОрганизации.Наименование,
		|	Должность.Наименование";
		
	Объект.ШтатныеЕдиницы.Загрузить(Запрос.Выполнить().Выгрузить()); 
	
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