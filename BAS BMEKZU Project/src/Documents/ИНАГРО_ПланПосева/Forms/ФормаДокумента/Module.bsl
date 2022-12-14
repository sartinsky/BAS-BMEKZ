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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВозвратКоординат" Тогда
		ВозвратКоординат(Параметр);
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
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
	ТекущаяДатаДокумента);
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если (Объект.Поля.Количество() > 0) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?';uk='Таблична частина буде очищена. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("ОчиститьТаблицуПоляЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе 		
		Возврат;		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицуПоляЗавершение(РезультатВопроса, Параметры) Экспорт 
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;		
	Иначе 		
		Объект.Поля.Очистить();	
		Объект.КоординатыПосева.Очистить();		
	КонецЕсли;
			     
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоля

&НаКлиенте
Процедура ПоляПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Поля.ТекущиеДанные;
	
	УдалитьСтрокиКоординат(ТекущиеДанные.НомерСтроки);
	
	Для Каждого СтрокаТЧ Из Объект.КоординатыПосева Цикл
		Если СтрокаТЧ.НомерСтрокиПосева > ТекущиеДанные.НомерСтроки Тогда
			СтрокаТЧ.НомерСтрокиПосева = СтрокаТЧ.НомерСтрокиПосева - 1;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПоляПодразделениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Поля.ТекущиеДанные;
			
	Если ЗначениеЗаполнено(ТекущиеДанные.Подразделение) Тогда
				
		ПоляПодразделениеПриИзмененииНаСервере(ТекущиеДанные.Подразделение, ТекущиеДанные.НомерСтроки);
		
		ТекущиеДанные.КоординатыУстановлены = УстановитьКоординаты;
		
	Иначе
		ТекущиеДанные.КоординатыУстановлены = Ложь;				
	КонецЕсли;	 
	
КонецПроцедуры

&НаСервере
Процедура ПоляПодразделениеПриИзмененииНаСервере(Подразделение, НомерСтроки)
	 	 	
	Для каждого Строка Из Подразделение.КоординатыПоля Цикл
		НоваяСтрока = Объект.КоординатыПосева.Добавить();
		НоваяСтрока.НомерСтрокиПосева = НомерСтроки;
		НоваяСтрока.Широта 			  = Строка.ИНАГРО_Широта;
		НоваяСтрока.Долгота 		  = Строка.ИНАГРО_Долгота;
	КонецЦикла;
	
	Если Подразделение.КоординатыПоля.Количество() = 0 Тогда
		УстановитьКоординаты = Ложь;
	Иначе
		УстановитьКоординаты = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоляКоординатыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ТекущиеДанные = Элементы.Поля.ТекущиеДанные;
		
	ПараметрыФормы = Новый Структура;	
	ПараметрыФормы.Вставить("НомерРедактируемойСтроки",        ТекущиеДанные.НомерСтроки);
	ПараметрыФормы.Вставить("АдресКоординатыПосеваВХранилище", ПоместитьКоординатыПосеваВХранилище());
		
	ОткрытьФорму("Документ.ИНАГРО_ПланПосева.Форма.ФормаРедактированияКоординат", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
		
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	 	
	Если Объект.Поля.Количество() > 0 Тогда 		
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок); 
		Возврат;
	КонецЕсли;
	
    ЗаполнитьНаСервере();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;			
	КонецЕсли;
	
	Объект.Поля.Очистить();
	Объект.КоординатыПосева.Очистить();	
	
	ЗаполнитьНаСервере();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()

	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПодразделенияОрганизаций.Ссылка КАК Подразделение,
		|	ПодразделенияОрганизаций.ИНАГРО_Площадь КАК Площадь
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|ГДЕ
		|	ПодразделенияОрганизаций.Владелец = &Организация
		|	И ПодразделенияОрганизаций.ИНАГРО_ПризнакПоля = ИСТИНА
		|	И НЕ ПодразделенияОрганизаций.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Результат = Запрос.Выполнить();
	
	Объект.Поля.Загрузить(Результат.Выгрузить());
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКоординаты(Команда)
	
	Если Объект.Поля.Количество() > 0 Тогда
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("КоординатыУстановлены", Истина);
		КоординатыУстановлены = Объект.Поля.НайтиСтроки(ПараметрыПоиска);
		
		Если КоординатыУстановлены.Количество() > 0 Тогда
			ТекстВопроса = НСтр("ru='Перед установкой координаты будут очищены. Установить?';uk='Перед встановленням координати будуть очищені. Встановити?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьКоординатыЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Заголовок);
		КонецЕсли;
		
	Иначе
		УстановитьКоординатыНаСервере();
	КонецЕсли;    	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКоординатыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
        Возврат;		
	КонецЕсли;
	
	Объект.КоординатыПосева.Очистить();	
	
	УстановитьКоординатыНаСервере();

КонецПроцедуры

&НаСервере
Процедура УстановитьКоординатыНаСервере()

	Для каждого	Строка Из Объект.Поля Цикл
		
		Если ЗначениеЗаполнено(Строка.Подразделение) Тогда
			
			Для каждого Строка1 Из Строка.Подразделение.КоординатыПоля Цикл
				НоваяСтрока = Объект.КоординатыПосева.Добавить();
				НоваяСтрока.НомерСтрокиПосева = Строка.НомерСтроки;
				НоваяСтрока.Долгота = Строка1.ИНАГРО_Долгота;
				НоваяСтрока.Широта  = Строка1.ИНАГРО_Широта;
			КонецЦикла;
			
			Если Строка.Подразделение.КоординатыПоля.Количество() = 0 Тогда
				Строка.КоординатыУстановлены = Ложь;
			Иначе
				Строка.КоординатыУстановлены = Истина;
			КонецЕсли;
			
		Иначе
			Строка.КоординатыУстановлены = Ложь;				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьСостояниеДокумента();
			
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиКоординат(НомерСтроки)
	
	// Удалим старые строки
	МассивСтрок = Объект.КоординатыПосева.НайтиСтроки(Новый Структура("НомерСтрокиПосева", НомерСтроки));
	
	Для Каждого Строка Из МассивСтрок Цикл
		Объект.КоординатыПосева.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратКоординат(Параметры)
	
	ТекущиеДанные = Элементы.Поля.ТекущиеДанные;
		
	ВозвратКоординатНаСервере(Параметры.АдресКоординатыВХранилище, ТекущиеДанные.НомерСтроки);
	
	ТекущиеДанные.КоординатыУстановлены = УстановитьКоординаты;
	
	Модифицированность = Истина;
			
КонецПроцедуры

&НаСервере
Процедура ВозвратКоординатНаСервере(Параметры, НомерСтроки)
		
	ТаблицаКоординатыПосева = ПолучитьИзВременногоХранилища(Параметры);
	
	Если ТаблицаКоординатыПосева <> Неопределено Тогда
		// Удалим старые строки
		УдалитьСтрокиКоординат(НомерСтроки);
		
		Для Каждого СтрокаТаблицаКоординатыПосева Из ТаблицаКоординатыПосева Цикл
			НоваяСтрока = Объект.КоординатыПосева.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицаКоординатыПосева);
			НоваяСтрока.НомерСтрокиПосева = НомерСтроки;
		КонецЦикла;	 		
		
	КонецЕсли; 	
		
	Если Объект.КоординатыПосева.Количество() <> 0 Тогда 
		УстановитьКоординаты = Истина;
	Иначе
		УстановитьКоординаты = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ПоместитьКоординатыПосеваВХранилище()

	ВходящаяТаблица = Объект.КоординатыПосева.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(ВходящаяТаблица, УникальныйИдентификатор);

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