#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
	
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	ИНАГРО_ЭлеваторЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения); 
	
	ВремяПрибытия = ТекущаяДата();
  	ВремяВыбытия  = ТекущаяДата();	
			
	Весовщик      = Пользователи.ТекущийПользователь();
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда		
		
		ВремяНачалаДня = ИНАГРО_Элеватор.ПолучитьПараметрУчетаЭлеватора(Дата, "ВремяНачалаДня", 0);
				
		Дата = Дата + 60 * 60 * ВремяНачалаДня; 

	КонецЕсли;  
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если НЕ Отказ Тогда
		ДвиженияПоРегиструРасчетыПоУслугам();		
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
	
	ВесБрутто  = 0;
	ВесБрутто1 = 0;
	ВесТары    = 0;
	ВесТары1   = 0;
	ВесНетто   = 0;
	ВесНетто1  = 0; 	
		
	Вес        = 0;
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Процедура ДвиженияПоРегиструРасчетыПоУслугам()
	
	ТаблицаУслуг = СформироватьТаблицуУслуг();
	
	Если ТаблицаУслуг.Количество() > 0 Тогда
		ИНАГРО_Элеватор.ДвиженияПоРегиструРасчетыПоУслугам(Движения, ТаблицаУслуг, "Приход");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
	ТаблицаУслуг.Колонки.Добавить("ВидХранения");
	ТаблицаУслуг.Колонки.Добавить("Урожай");
	ТаблицаУслуг.Колонки.Добавить("Количество");
	ТаблицаУслуг.Колонки.Добавить("Стоимость"); 
	
	Культура = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Номенклатура, "ВидКультуры").ВидКультурыДляРасчетаСтоимостиУслуги;
	
	ТекущаяЦена = ИНАГРО_Элеватор.ПолучитьЦенуУслугиЭлеватора(Организация, Дата, Владелец, ДоговорКонтрагента, Культура, , ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Взвешивание"));
	
	Если ТекущаяЦена <> 0 Тогда 													 
		НоваяСтрока = ТаблицаУслуг.Добавить();
		НоваяСтрока.ДатаРасчета        = Дата;
		НоваяСтрока.Ссылка             = Ссылка; 
		НоваяСтрока.Организация        = Организация;
		НоваяСтрока.Контрагент         = Владелец;
		НоваяСтрока.ДоговорКонтрагента = ДоговорКонтрагента;
		НоваяСтрока.Номенклатура       = ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Взвешивание");
		НоваяСтрока.Культура           = Номенклатура;
		НоваяСтрока.Количество         = 1;
		НоваяСтрока.Стоимость          = НоваяСтрока.Количество * ТекущаяЦена;
	КонецЕсли;
	
	Возврат ТаблицаУслуг;
	
КонецФункции

#КонецОбласти

#КонецЕсли