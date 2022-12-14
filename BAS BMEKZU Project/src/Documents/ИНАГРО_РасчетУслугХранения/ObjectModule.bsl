#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения); 
	
	Если ИНАГРО_Элеватор.ПолучитьПараметрУчетаЭлеватора(Дата, "РассчитыватьХранениеПоФизическомуВесу", Ложь) Тогда
		РассчитыватьХранениеПоФизическомуВесу = Истина;
	КонецЕсли;	
			
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
		Отказ = ПроверитьРасчетУслугВТекущемПериоде();
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
 	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаУслуг;
	
 	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);

	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);	
	
	// Движения по документу
	Если НЕ Отказ Тогда		
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок);				
	КонецЕсли;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект); 	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;	
	
	СтруктураШапкиДокумента   = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке(); 	
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента   = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");

КонецПроцедуры

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ТаблицаУслуг = СформироватьТаблицуУслуг();
	
	Если ТаблицаУслуг.Количество() > 0 Тогда
		ИНАГРО_Элеватор.ДвиженияПоРегиструРасчетыПоУслугам(Движения, ТаблицаУслуг, "Приход");
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура Рассчитать(Культура) Экспорт
	
	Если ЗначениеЗаполнено(Склад) Тогда 
		Если ПроверитьРасчетУслугВТекущемПериоде() Тогда
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	
	РассчитатьХранение(Культура);	
		
КонецПроцедуры

Процедура РассчитатьХранение(КультураП, СписокУсловий = Неопределено) Экспорт	
	
	ДатаРасчета = ТекущаяДата();
	
	Если СписокУсловий = Неопределено Тогда
		
		СписокУсловий = Документы.ИНАГРО_РасчетУслугХранения.ПолучитьСписокУсловий(ЭтотОбъект);
		
	Иначе
		
		ПараметрыОтбора = Новый Структура;
		
    	Ит = 0;		
		Пока Ит < СписокУсловий.Количество() Цикл			
			ЗначСписка = СписокУсловий.Получить(Ит);			
			Если ЗначСписка.Представление = "Номенклатура" Тогда
        		ПараметрыОтбора.Вставить("Культура", ЗначСписка.Значение);
			ИначеЕсли ЗначСписка.Представление = "Владелец" Тогда
        		ПараметрыОтбора.Вставить("Контрагент", ЗначСписка.Значение);
			ИначеЕсли ЗначСписка.Представление = "Договор" Тогда
        		ПараметрыОтбора.Вставить("ДоговорКонтрагента", ЗначСписка.Значение);
			Иначе	
        		ПараметрыОтбора.Вставить(ЗначСписка.Представление, ЗначСписка.Значение);
			КонецЕсли;			
	    	Ит = Ит + 1;			
		КонецЦикла;
		
        НайденныеСтроки = Список.НайтиСтроки(ПараметрыОтбора);
		КоличествоСтрок = НайденныеСтроки.Количество();
		
		Ит = 0;		
		Пока Ит < КоличествоСтрок Цикл
			СтрокДок = НайденныеСтроки.Получить(Ит);
			Список.Удалить(СтрокДок);                            
			Ит = Ит + 1;
		КонецЦикла;
		
	КонецЕсли;
	
	Фильтр = СформироватьФильтрЗапроса(СписокУсловий);
	
	Запрос = Новый Запрос;
	ФильтрПоКультурам = " ИСТИНА ";
	Если ЗначениеЗаполнено(КультураП) Тогда
		Запрос.УстановитьПараметр("Культура", КультураП);
		ФильтрПоКультурам = ФильтрПоКультурам + " И ИНАГРО_ДополнительныеРеквизитыНоменклатуры.Номенклатура = &Культура"
	КонецЕсли;
	
	СписокНеДопустимыхСкладов = ВыбратьНедопустимыеСклады();
	Фильтр = Фильтр + " И Склад НЕ В (&Склады)"; 
	Запрос.УстановитьПараметр("Склады", СписокНедопустимыхСкладов);
	
	Ит = 0;
	Пока Ит < СписокУсловий.Количество() Цикл
		ЗначСписка = СписокУсловий.Получить(Ит);
		Запрос.УстановитьПараметр(ЗначСписка.Представление, ЗначСписка.Значение);
		Ит = Ит + 1;
	КонецЦикла;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИНАГРО_ПараметрыУчетаЭлеватораСрезПоследних.СписыватьУсушкуПоСкладскомуУчету КАК СписыватьУсушкуПоСкладскомуУчету
		|ПОМЕСТИТЬ ПараметрыУчетаЭлеватора
		|ИЗ
		|	РегистрСведений.ИНАГРО_ПараметрыУчетаЭлеватора.СрезПоследних(&Дата, ) КАК ИНАГРО_ПараметрыУчетаЭлеватораСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИНАГРО_ОстаткиОстатки.Организация КАК Организация,
		|	НоменклатураПоДопРеквизиту.Номенклатура КАК Культура,
		|	ИНАГРО_ОстаткиОстатки.Владелец КАК Контрагент,
		|	ИНАГРО_ОстаткиОстатки.Договор КАК ДоговорКонтрагента,
		|	ИНАГРО_ОстаткиОстатки.Склад КАК Склад,
		|	ИНАГРО_ОстаткиОстатки.Урожай КАК Урожай,
		|	ИНАГРО_ОстаткиОстатки.ВидХранения КАК ВидХранения,
		|	СУММА(ВЫБОР
		|			КОГДА &РассчитыватьХранениеПоФизическомуВесу
		|				ТОГДА ВЫБОР
		|						КОГДА ЕСТЬNULL(ПараметрыУчетаЭлеватора.СписыватьУсушкуПоСкладскомуУчету, ЛОЖЬ)
		|							ТОГДА ЕСТЬNULL(ИНАГРО_ОстаткиОстатки.ВесОстаток, 0)
		|						ИНАЧЕ ЕСТЬNULL(ИНАГРО_ОстаткиОстатки.ВесОстаток, 0) - ЕСТЬNULL(ИНАГРО_ОстаткиОстатки.УбыльВесаПриСушкеОстаток, 0)
		|					КОНЕЦ
		|			ИНАЧЕ ЕСТЬNULL(ИНАГРО_ОстаткиОстатки.ЗачетныйВесОстаток, 0)
		|		КОНЕЦ) КАК Остаток
		|ИЗ
		|	(ВЫБРАТЬ
		|		ИНАГРО_ДополнительныеРеквизитыНоменклатуры.Номенклатура КАК Номенклатура
		|	ИЗ
		|		РегистрСведений.ИНАГРО_ДополнительныеРеквизитыНоменклатуры КАК ИНАГРО_ДополнительныеРеквизитыНоменклатуры
		|	ГДЕ
		|		ИНАГРО_ДополнительныеРеквизитыНоменклатуры.ВидКультуры.РассчитыватьХранение = ИСТИНА
		|		И &ФильтрПоКультурам) КАК НоменклатураПоДопРеквизиту
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ИНАГРО_Остатки.Остатки(&Дата, &Фильтр) КАК ИНАГРО_ОстаткиОстатки
		|		ПО НоменклатураПоДопРеквизиту.Номенклатура = ИНАГРО_ОстаткиОстатки.Номенклатура,
		|	ПараметрыУчетаЭлеватора КАК ПараметрыУчетаЭлеватора
		|
		|СГРУППИРОВАТЬ ПО
		|	ИНАГРО_ОстаткиОстатки.Владелец,
		|	ИНАГРО_ОстаткиОстатки.Склад,
		|	ИНАГРО_ОстаткиОстатки.Организация,
		|	ИНАГРО_ОстаткиОстатки.ВидХранения,
		|	ИНАГРО_ОстаткиОстатки.Урожай,
		|	ИНАГРО_ОстаткиОстатки.Договор,
		|	НоменклатураПоДопРеквизиту.Номенклатура";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрПоКультурам", ФильтрПоКультурам);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Фильтр", Фильтр);
	
	Запрос.УстановитьПараметр("РассчитыватьХранениеПоФизическомуВесу", РассчитыватьХранениеПоФизическомуВесу);
	
	текДата = НачалоПериодаРасчета ;
	
	Пока текДата <= КонецПериодаРасчета Цикл			   
		
		Запрос.УстановитьПараметр("Дата", Новый Граница(КонецДня(текДата), ВидГраницы.Включая));
		
		Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Номенклатура_Хранение = ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Хранение");
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Остаток <= 0 Тогда
				Продолжить;
			КонецЕсли;	
			
			СобственноеПодразделение = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитКонтрагента(Выборка.Контрагент, "СобственноеПодразделение");
			Если СобственноеПодразделение Тогда
				Продолжить;
			КонецЕсли;	
			
			НоваяСтрока = Список.Добавить();
			НоваяСтрока.ДатаРасчета        = текДата;
			НоваяСтрока.Организация        = Выборка.Организация;
			НоваяСтрока.Контрагент         = Выборка.Контрагент;
			НоваяСтрока.ДоговорКонтрагента = Выборка.ДоговорКонтрагента;
			НоваяСтрока.Культура           = Выборка.Культура;
			НоваяСтрока.Склад              = Выборка.Склад;
			НоваяСтрока.Урожай             = Выборка.Урожай;
			НоваяСтрока.ВидХранения        = Выборка.ВидХранения;
			НоваяСтрока.КилограммоДни      = Выборка.Остаток;
			НоваяСтрока.ТонноДни           = Окр(Выборка.Остаток / 1000, 5);
			НоваяСтрока.ТонноМесяцы        = Окр(НоваяСтрока.ТонноДни / ПолучитьКоличествоДнейВМесяце(НачалоПериодаРасчета, КонецПериодаРасчета), 5);
			НоваяСтрока.ЕдиницаИзмерения   = ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Хранение").БазоваяЕдиницаИзмерения;
			НоваяСтрока.Количество 		   = НоваяСтрока.ТонноДни;
			
			ВидКультурыДляРасчетаСтоимостиУслуги = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Выборка.Культура, "ВидКультуры").ВидКультурыДляРасчетаСтоимостиУслуги;
			
			НоваяСтрока.Цена               = ИНАГРО_Элеватор.ПолучитьЦенуУслугиЭлеватора(Выборка.Организация,
						                                                                 текДата,
																						 Выборка.Контрагент,
																						 Выборка.ДоговорКонтрагента,
																						 ВидКультурыДляРасчетаСтоимостиУслуги,
																						 Выборка.Урожай,
																						 Номенклатура_Хранение);

		КонецЦикла;	
		
		текДата = текДата + 60*60*24;
		
	КонецЦикла;

	Список.Сортировать("ДатаРасчета, Контрагент, ДоговорКонтрагента, Склад, Урожай, Культура");
	
КонецПроцедуры

Функция ПроверитьРасчетУслугВТекущемПериоде() 
	
	Результат = Ложь;
	
	СписокСклад = ВыбратьНедопустимыеСклады();
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Если СписокСклад.НайтиПоЗначению(Склад) <> Неопределено Тогда
			Результат = Истина;
			ТекстСообщения = ".";
		КонецЕсли;
	Иначе
		МассивСкладов = Список.ВыгрузитьКолонку("Склад");
		ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(МассивСкладов);
		Для Каждого Элемент Из МассивСкладов Цикл
			Если СписокСклад.НайтиПоЗначению(Элемент) <> Неопределено Тогда
				Результат = Истина;
				ТекстСообщения = " по складу " + Элемент + ".";
				Прервать;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;	
	
	Если Результат = Истина Тогда		
		ТекстСообщения = НСтр("ru='В этом периоде уже производился расчет услуг';uk='В цьому періоді вже проводився розрахунок послуг'" + ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	  

Функция ВыбратьНедопустимыеСклады()
	
	Запрос = Новый Запрос;
	
   	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИНАГРО_РасчетУслугХраненияСписок.Склад КАК Склад
		|ИЗ
		|	Документ.ИНАГРО_РасчетУслугХранения.Список КАК ИНАГРО_РасчетУслугХраненияСписок
		|ГДЕ
		|	ИНАГРО_РасчетУслугХраненияСписок.Ссылка.Проведен = ИСТИНА
		|	И ИНАГРО_РасчетУслугХраненияСписок.Ссылка.Дата >= &НачалоПериода
		|	И ИНАГРО_РасчетУслугХраненияСписок.Ссылка.Дата <= &КонецПериода
		|	И ИНАГРО_РасчетУслугХраненияСписок.Ссылка.Организация = &Организация
		|	И ИНАГРО_РасчетУслугХраненияСписок.Ссылка.Ссылка <> &Ссылка";
				   
	Запрос.УстановитьПараметр("Ссылка",        ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериодаРасчета);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериодаРасчета);
	
 	РезультатЗапрос = Запрос.Выполнить().Выгрузить();
	
	СписокНеДопустимыхСкладов = Новый СписокЗначений;
	
	Если РезультатЗапрос.Количество() > 0 Тогда
		СписокНеДопустимыхСкладов.ЗагрузитьЗначения(РезультатЗапрос.ВыгрузитьКолонку("Склад"));
	КонецЕсли;
	
	Возврат СписокНедопустимыхСкладов;
	
КонецФункции	

Функция СформироватьФильтрЗапроса(СписокУсловий, ПустоеУсловие = Истина)
	
	Фильтр = " ";
	Ит     = 0;
	
	Пока Ит < СписокУсловий.Количество() Цикл
		ЗначСписка = СписокУсловий.Получить(Ит);
  		Если ПустоеУсловие Тогда
			Фильтр = Фильтр + ЗначСписка.Представление + " = &" + ЗначСписка.Представление +" И ";
		Иначе
			Фильтр = Фильтр + " И " + ЗначСписка.Представление + "= &" + ЗначСписка.Представление;
		КонецЕсли;
		Ит = Ит + 1;
	КонецЦикла;	
	
	Фильтр = Лев(Фильтр, СтрДлина(Фильтр) - 2);
	
	Возврат Фильтр;
	
КонецФункции

Функция ПолучитьКоличествоДнейВМесяце(ДатаНачалаПериода, ДатаКонцаПериода)
	
	Если НачалоМесяца(ДатаНачалаПериода) = НачалоМесяца(ДатаКонцаПериода) Тогда
		// Если период хранения находится в рамках одного месяца
		// Берем для точности реальное к-во дней в месяце.
		ДнейВМесяце = День(КонецМесяца (ДатаКонцаПериода));
	Иначе
		ДнейВМесяце = 30;
	КонецЕсли;
	
	Возврат ДнейВМесяце;
	
КонецФункции

Функция СформироватьТаблицуУслуг()
	
	ТаблицаУслуг = Новый ТаблицаЗначений;
	ТаблицаУслуг.Колонки.Добавить("ДатаРасчета");
	ТаблицаУслуг.Колонки.Добавить("Ссылка"); 
	ТаблицаУслуг.Колонки.Добавить("Организация");
	ТаблицаУслуг.Колонки.Добавить("Контрагент");
	ТаблицаУслуг.Колонки.Добавить("ДоговорКонтрагента");
	ТаблицаУслуг.Колонки.Добавить("Номенклатура");
	ТаблицаУслуг.Колонки.Добавить("Культура");
	ТаблицаУслуг.Колонки.Добавить("Склад");
	ТаблицаУслуг.Колонки.Добавить("Урожай");
	ТаблицаУслуг.Колонки.Добавить("ВидХранения");
	ТаблицаУслуг.Колонки.Добавить("Количество");
	ТаблицаУслуг.Колонки.Добавить("Стоимость");  	 
	
	Номенклатура_Хранение = ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Хранение");
	
	Для Каждого текСтрока Из Список Цикл
		
		НоваяСтрока                    = ТаблицаУслуг.Добавить();
		НоваяСтрока.ДатаРасчета        = текСтрока.ДатаРасчета;
		НоваяСтрока.Ссылка             = Ссылка; 
		НоваяСтрока.Организация        = текСтрока.Организация;
		НоваяСтрока.Контрагент         = текСтрока.Контрагент;
		НоваяСтрока.ДоговорКонтрагента = текСтрока.ДоговорКонтрагента;
		НоваяСтрока.Номенклатура       = Номенклатура_Хранение;
		НоваяСтрока.Культура           = текСтрока.Культура;
		НоваяСтрока.Склад              = текСтрока.Склад;
		НоваяСтрока.Урожай             = текСтрока.Урожай;
		НоваяСтрока.ВидХранения        = текСтрока.ВидХранения;
		НоваяСтрока.Количество         = текСтрока.Количество;
		НоваяСтрока.Стоимость          = текСтрока.Сумма;
		
	КонецЦикла;
	
	Возврат ТаблицаУслуг;
	
КонецФункции

#КонецОбласти

#КонецЕсли

