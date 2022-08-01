#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Приказ
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru='Накладная';uk='Накладна'");
   	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
    КомандаПечати.СписокФорм    = "ФормаСписка,ФормаВыбораПриказа,ФормаДокумента";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Приказ на перемещение""';uk='Реєстр документів ""Наказ на переміщення""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
    Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
        
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", НСтр("ru='Накладная';uk='Накладна'"), 
            ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИНАГРО_ПриказНаПеремещение.ПФ_MXL_Накладная", , Истина);
            
    КонецЕсли;
	
	
КонецПроцедуры

Функция ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
    
    УстановитьПривилегированныйРежим(Истина);
    
    ЗапросШапка = Новый Запрос;
    ЗапросШапка.Текст =
		"ВЫБРАТЬ
		|	ИНАГРО_ПриказНаПеремещение.Организация.НаименованиеПолное КАК Организация,
		|	ИНАГРО_ПриказНаПеремещение.Номер КАК НомерДок,
		|	ИНАГРО_ПриказНаПеремещение.Дата КАК ДатаДок,
		|	ИНАГРО_ПриказНаПеремещение.Склад КАК Склад,
		|	ИНАГРО_ПриказНаПеремещение.Организация КАК ОрганизацияПредставление,
		|	ИНАГРО_ПриказНаПеремещение.Владелец КАК Владелец,
		|	ИНАГРО_ПриказНаПеремещение.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ИНАГРО_ПриказНаПеремещение.Ссылка КАК Ссылка,
		|	ИНАГРО_ПриказНаПеремещение.НовыйСклад КАК Куда
		|ИЗ
		|	Документ.ИНАГРО_ПриказНаПеремещение КАК ИНАГРО_ПриказНаПеремещение
		|ГДЕ
		|	ИНАГРО_ПриказНаПеремещение.Ссылка = &ТекущийДокумент";

    
    ЗапросКультуры = Новый Запрос;
    ЗапросКультуры.Текст =  
		"ВЫБРАТЬ
		|	ИНАГРО_ПриказНаПеремещениеКультуры.Номенклатура КАК Номенклатура,
		|	ИНАГРО_ПриказНаПеремещениеКультуры.ФизическийВес КАК Вес,
		|	ИНАГРО_ПриказНаПеремещениеКультуры.Влажность КАК Влажность,
		|	ИНАГРО_ПриказНаПеремещениеКультуры.СорнаяПримесь КАК СорнаяПримесь,
		|	ИНАГРО_ПриказНаПеремещениеКультуры.ЗерноваяПримесь КАК ЗерноваяПримесь,
		|	ИНАГРО_ПриказНаПеремещениеКультуры.ЗачетныйВес КАК ЗачетныйВес
		|ИЗ
		|	Документ.ИНАГРО_ПриказНаПеремещение.Культуры КАК ИНАГРО_ПриказНаПеремещениеКультуры
		|ГДЕ
		|	ИНАГРО_ПриказНаПеремещениеКультуры.Ссылка = &ТекущийДокумент";
                        
    ТабДокумент = Новый ТабличныйДокумент;
    ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНАГРО_ПриказНаПеремещение.Накладная";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_ПриказНаПеремещение.ПФ_MXL_Накладная");
    
    // печать производится на языке, указанном в настройках пользователя
    КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
    Макет.КодЯзыкаМакета = КодЯзыкаПечать;
    
    ПервыйДокумент = Истина;

    Для каждого Ссылка Из МассивОбъектов Цикл
        
        Если Не ПервыйДокумент Тогда
            ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
        КонецЕсли;
        ПервыйДокумент = Ложь;
        
        // Запомним номер строки, с которой начали выводить текущий документ.
        НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
        
        ЗапросКультуры.УстановитьПараметр("ТекущийДокумент", Ссылка);
        РезультатКультуры = ЗапросКультуры.Выполнить().Выгрузить();
        
        ЗапросШапка.УстановитьПараметр("ТекущийДокумент", Ссылка);
        РезультатШапка = ЗапросШапка.Выполнить().Выбрать();
        РезультатШапка.Следующий();
        
        Шапки = Макет.ПолучитьОбласть("Шапка");	
        
        Шапки.Параметры.Заполнить(РезультатШапка);	
        ВремяНачалаДня              = ИНАГРО_Элеватор.ПолучитьПараметрУчетаЭлеватора(РезультатШапка.ДатаДок, "ВремяНачалаДня", 0);
        Шапки.Параметры.ДатаДок     = Формат(РезультатШапка.ДатаДок, "ДФ='дд ММММ гггг';Л="+ Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать));
        ЗавСкладомСрез              = РегистрыСведений.ОтветственныеЛица.СрезПоследних(РезультатШапка.ДатаДок,Новый Структура ("СтруктурнаяЕдиница",РезультатШапка.Склад));
        ЗавНовогоСкладаСрез         = РегистрыСведений.ОтветственныеЛица.СрезПоследних(РезультатШапка.ДатаДок,Новый Структура ("СтруктурнаяЕдиница",РезультатШапка.Куда));
         
        Если ЗавСкладомСрез.Количество()<>0 Тогда
            Шапки.Параметры.ЗавСкладом = ЗавСкладомСрез[0].ФизическоеЛицо;
        КонецЕсли;
        
        Если ЗавНовогоСкладаСрез.Количество()<>0 Тогда
            Шапки.Параметры.ЗавНовымСкладом = ЗавНовогоСкладаСрез[0].ФизическоеЛицо;	
        КонецЕсли;
        ТабДокумент.Вывести(Шапки);
        
        // Строка	
        ОблСтрока = Макет.ПолучитьОбласть("Строка");
        ЗачВес = 0;
        Для каждого Строка Из РезультатКультуры Цикл
            ОБлСтрока.Параметры.Заполнить(Строка);
            
            ПараметрыДляРасчетаЗачетногоВеса = Новый Структура(
            "Ссылка, Дата, Организация,
            |Владелец, ДоговорКонтрагента, Номенклатура,
            |Склад, Влажность, СорнаяПримесь,
            |ФизическийВес, ЗачетныйВес,     
            |");
            
            ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, Строка);
            ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, РезультатШапка);
            ПараметрыДляРасчетаЗачетногоВеса.Вставить("ФизическийВес",Строка.Вес);
            ПараметрыДляРасчетаЗачетногоВеса.Вставить("Организация",РезультатШапка.Организация);
            ПараметрыДляРасчетаЗачетногоВеса.Вставить("Дата",РезультатШапка.ДатаДок);

            ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);
            ОблСтрока.Параметры.ЗачетныйВес = ЗачетныйВес;
            ЗачВес = ЗачетныйВес + ЗачВес;
            ТабДокумент.Вывести(ОблСтрока);
        КонецЦикла;                  
        
        // итого зачетного веса
        ТЗ = Новый ТаблицаЗначений;
        ТЗ.Колонки.Добавить("ЗачВес");
        Стр = ТЗ.Добавить();
        Стр.ЗачВес = ЗачВес;
        Итого = ТЗ.Итог("ЗачВес");
        
        //Дно
        ОблДно = Макет.ПолучитьОбласть("Дно");
        ОблДно.Параметры.ВесИтого = РезультатКультуры.Итог("Вес");
        ОблДно.Параметры.ЗачетныйВесИтого = Итого;
        Руководители = ИНАГРО_Элеватор.ОтветственныеЛицаОрганизации(РезультатШапка.ОрганизацияПредставление, РезультатШапка.ДатаДок);
        ОблДно.Параметры.ФИОДиректора = Руководители.Руководитель;
        ОблДно.Параметры.НачальникВТЛ = Руководители.НачальникВТЛ;
        
        ТабДокумент.Вывести(ОблДно);	
        
        ОблРазделитель = Макет.ПолучитьОбласть("Разделитель");
        ТабДокумент.Вывести(ОблРазделитель);
        
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
        НомерСтрокиНачало, ОбъектыПечати, Ссылка);
        
	КонецЦикла;
	
    Возврат ТабДокумент;
    
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
