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

	УстановитьПериодРасчета();

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
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыФормыВыбора = Новый Структура("НачалоПериода, КонецПериода", Объект.НачалоПериодаРасчета, Объект.КонецПериодаРасчета);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыФормыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры)  Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.НачалоПериодаРасчета = РезультатВыбора.НачалоПериода;
	Объект.КонецПериодаРасчета  = РезультатВыбора.КонецПериода;
		
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	Если Объект.Список.Количество() > 0 Тогда		
		ТекстВопроса = НСтр("ru='Перед расчетом будет очищена табличная часть. Продолжить?';uk='Перед розрахунком буде очищена таблична частина. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("РассчитатьЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);  
	Иначе
		РассчитатьНаСервере();
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
   	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда		 
		Возврат;
	КонецЕсли;	
		
	Объект.Список.Очистить();	
		
	РассчитатьНаСервере();	
		
КонецПроцедуры

&НаСервере
Процедура РассчитатьНаСервере() 
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Рассчитать(Объект.Номенклатура);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект"); 
		
	УправлениеФормой(ЭтаФорма);
	
	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти  

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УстановитьПериодРасчета();
		Объект.РассчитыватьХранениеПоФизическомуВесу = ИНАГРО_Элеватор.ПолучитьПараметрУчетаЭлеватора(Объект.Дата, "РассчитыватьХранениеПоФизическомуВесу", Ложь);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);	
	
	//РассчитыватьХранениеПоФизическомуВесу = ИНАГРО_Элеватор.ПолучитьПараметрУчетаЭлеватора(Объект.Дата, "РассчитыватьХранениеПоФизическомуВесу", Ложь);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста  
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;  
	Объект   = Форма.Объект;	 
	
	Элементы.СписокОрганизация.Видимость                     = НЕ ЗначениеЗаполнено(Объект.Организация);
	Элементы.СписокКонтрагент.Видимость                      = НЕ ЗначениеЗаполнено(Объект.Контрагент);
	Элементы.СписокДоговорКонтрагента.Видимость              = НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	Элементы.СписокКультура.Видимость                        = НЕ ЗначениеЗаполнено(Объект.Номенклатура);
	Элементы.СписокСклад.Видимость                           = НЕ ЗначениеЗаполнено(Объект.Склад);
	Элементы.СписокУрожай.Видимость                          = НЕ ЗначениеЗаполнено(Объект.Урожай);
	Элементы.СписокВидХранения.Видимость                     = НЕ ЗначениеЗаполнено(Объект.ВидХранения);
	//Элементы.РассчитыватьХранениеПоФизическомуВесу.Видимость = Форма.РассчитыватьХранениеПоФизическомуВесу;
		
	Элементы.НадписьДатаПоследнегоРасчета.Заголовок = ?(Объект.ДатаРасчета = '00010101', "",
	                                                    НСтр("ru='Дата последнего расчета документа ';uk='Дата останнього розрахунку документа '") + Объект.ДатаРасчета);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодРасчета()
	
	Объект.НачалоПериодаРасчета = НачалоМесяца(Объект.Дата);
	Объект.КонецПериодаРасчета  = КонецМесяца(Объект.Дата);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
		
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		
		ИмяКоманды      = Команда.Имя;
		АдресНастроек   = ЭтотОбъект.ПараметрыПодключаемыхКоманд.АдресТаблицыКоманд;
		ОписаниеКоманды = ПодключаемыеКомандыКлиентПовтИсп.ОписаниеКоманды(ИмяКоманды, АдресНастроек);
		
		Если ОписаниеКоманды.Идентификатор = "РасчетХранения" Тогда
		
			СписокВыбора = Новый СписокЗначений; 
			СписокВыбора.Добавить(2, НСтр("ru='Установить отбор';uk='Встановити відбір'")); 
			СписокВыбора.Добавить(1, "Все");
	
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Команда", Команда);

			Оповещение = Новый ОписаниеОповещения("ВыборПечатнойФормыЗавершение", ЭтотОбъект, ДополнительныеПараметры);            
			СписокВыбора.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите тип печатной формы.'; uk = 'Виберіть тип друкованої форми.'"));
						
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
Процедура ВыборПечатнойФормыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	 		
	Если РезультатЗакрытия <> Неопределено Тогда		
		ЗаписатьВыбраннуюПечатнуюФорму(РезультатЗакрытия, ДополнительныеПараметры); 
	Иначе 	
		ПоказатьПредупреждение( , НСтр("ru='Не выбран тип печатной формы!';uk='Не вибрано тип друкованої форми!'"));
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаписатьВыбраннуюПечатнуюФорму(РезультатЗакрытия, ДополнительныеПараметры)
	
	ВыбранныйЭлемент = РезультатЗакрытия.Значение;
	
	СтруктураОтборов = Новый Структура("НачалоХранения, КонецХранения, Урожай, Склад, Контрагент, Культура");
	
	Если ВыбранныйЭлемент = 1 Тогда		
		ЗаписатьВыбраннуюПечатнуюФормуНаСервере(СтруктураОтборов);		
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, ДополнительныеПараметры.Команда, Объект);		
	Иначе
		ЗаполнитьОтборы(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьВыбраннуюПечатнуюФормуНаСервере(СтруктураОтборов)
	
	Документы.ИНАГРО_РасчетУслугХранения.ЗаписатьВыбраннуюПечатнуюФорму(СтруктураОтборов);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнитьОтборы(ДополнительныеПараметры)
	
	ОповещенияОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьОтборыЗавершение", ЭтотОбъект,ДополнительныеПараметры);
	ОткрытьФорму("Документ.ИНАГРО_РасчетУслугХранения.Форма.ФормаПечать", ,ЭтаФорма, , , ,ОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);  
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗаполнитьОтборыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") И РезультатЗакрытия <> Неопределено Тогда
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, ДополнительныеПараметры.Команда, Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 
