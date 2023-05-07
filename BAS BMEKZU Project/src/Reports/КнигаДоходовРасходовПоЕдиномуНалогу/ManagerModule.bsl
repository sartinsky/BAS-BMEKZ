

Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("UK_Макет2023");
	
	ТабДокумент.Очистить();
	ОбластьМакета    = Макет.ПолучитьОбласть("Шапка");
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	ОбластьМакета.Параметры.НазваниеОрганизации = СведенияОбОрганизации.ПолноеНаименование;
	ОбластьМакета.Параметры.НалоговыйНомер = БухгалтерскийУчетПереопределяемый.ПолучитьКодОрганизации(СведенияОбОрганизации);
	ТабДокумент.Вывести(ОбластьМакета);
	ОбластьМакета    = Макет.ПолучитьОбласть("ЗаголовокТаблицыДоходы");
	ТабДокумент.Вывести(ОбластьМакета);
	ВысотаЗаголовка     = ТабДокумент.ВысотаТаблицы;
	
	Отчеты.КнигаДоходовПоЕдиномуНалогу.СформироватьОтчет(ПараметрыОтчета, АдресХранилища, ТабДокумент);
	
	ОбластьМакета    = Макет.ПолучитьОбласть("ЗаголовокТаблицыРасходы");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачГода",         ПараметрыОтчета.ДатаНачалаНарастающегоИтога);
	Запрос.УстановитьПараметр("НачКвартала",     Макс(ПараметрыОтчета.ДатаНачалаНарастающегоИтога, НачалоКвартала(ПараметрыОтчета.НачалоПериода)));
	Запрос.УстановитьПараметр("ПередНачПериода", ПараметрыОтчета.НачалоПериода - 1);
	Запрос.УстановитьПараметр("НачПериода",      ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонПериода",      КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация",     ПараметрыОтчета.Организация);
	
	Запрос.УстановитьПараметр("СтатьяЗатратыСвязанныеСПриобретением", Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЗатратыСвязанныеСПриобретением);
	Запрос.УстановитьПараметр("СтатьяОплатаТруда",                    Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыОплатаТруда);
	Запрос.УстановитьПараметр("СтатьяЕСВ",                            Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЕСВ);
	Запрос.УстановитьПараметр("СтатьяДругиеЗатраты",                  Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыДругиеЗатраты);
	Запрос.УстановитьПараметр("СтатьяЗатраты",                        Справочники.СтатьиНалоговыхДеклараций.ЕННК_Затраты);
	Запрос.УстановитьПараметр("СтатьяЗатратыПроизводствоСХПродукции", Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыПроизводствоСХПродукции);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья3, 0) КАК Статья3,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья4, 0) КАК Статья4,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья5, 0) КАК Статья5,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья6, 0) КАК Статья6,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья7, 0) КАК Статья7,  
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья8, 0) КАК Статья8,  
	|	КнигаДоходовРасходовИтог.ПериодМесяц КАК ПериодМесяц,
	|	КнигаДоходовРасходовИтог.ПериодДень КАК ПериодДень,
	|	КнигаДоходовРасходовИтог.Период,
	|	КнигаДоходовРасходовИтог.Статья
	|ИЗ
	|	(ВЫБРАТЬ
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья3,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяОплатаТруда
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья4,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЕСВ
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья5,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЗатратыПроизводствоСХПродукции
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья6,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0    
	|			КОНЕЦ) КАК Статья7,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяОплатаТруда
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЕСВ
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЗатратыПроизводствоСХПродукции
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья8,
	|		NULL КАК ПериодМесяц,
	|		NULL КАК ПериодДень,
	|		NULL КАК Период,
	|		NULL КАК Статья
	|	ИЗ
	|		РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу.Обороты(&НачГода, &ПередНачПериода, , Организация = &Организация) КАК ОборотСНачалаГода
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяОплатаТруда
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяЕСВ
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяЗатратыПроизводствоСХПродукции
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяОплатаТруда
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяЕСВ
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0 
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяЗатратыПроизводствоСХПродукции
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0 
	|			КОНЕЦ),
	|		NULL,
	|		NULL,
	|		1,
	|		NULL
	|	ИЗ
	|		РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу.Обороты(&НачКвартала, &ПередНачПериода, , Организация = &Организация) КАК ОборотСНачалаКвартала
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяОплатаТруда
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяЕСВ
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяЗатратыПроизводствоСХПродукции
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ), 
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ), 
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяОплатаТруда
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяЕСВ
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0   
	|			КОНЕЦ) + СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяЗатратыПроизводствоСХПродукции
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0   
	|			КОНЕЦ),
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, МЕСЯЦ),
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, ДЕНЬ),
	|		КнигаДоходовРасходов.Период,
	|		КнигаДоходовРасходов.Статья
	|	ИЗ
	|		РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу КАК КнигаДоходовРасходов
	|	ГДЕ
	|		КнигаДоходовРасходов.Организация = &Организация
	|		И КнигаДоходовРасходов.Статья В ИЕРАРХИИ(&СтатьяЗатраты)
	|		И КнигаДоходовРасходов.Период >= &НачПериода
	|		И КнигаДоходовРасходов.Период <= &КонПериода
	|	
	|	СГРУППИРОВАТЬ ПО
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, МЕСЯЦ),
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, ДЕНЬ),
	|		КнигаДоходовРасходов.Период,
	|		КнигаДоходовРасходов.Статья) КАК КнигаДоходовРасходовИтог
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПериодМесяц,
	|	ПериодДень,
	|	КнигаДоходовРасходовИтог.Период
	|ИТОГИ
	|	СУММА(Статья3),
	|	СУММА(Статья4),
	|	СУММА(Статья5),
	|	СУММА(Статья6), 
	|	СУММА(Статья7),
	|	СУММА(Статья8) 
	|ПО
	|	ПериодМесяц,
	|	ПериодДень";
	ВыборкаМесяц = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбластьСтрока    = Макет.ПолучитьОбласть("Строка");
	ОбластьДень      = Макет.ПолучитьОбласть("День");
	ОбластьМесяц     = Макет.ПолучитьОбласть("Месяц");
	ОбластьКвартал   = Макет.ПолучитьОбласть("Квартал");
	ОбластьГод       = Макет.ПолучитьОбласть("Год");
	ПараметрыСтрока  = ОбластьСтрока.Параметры;
	ПараметрыДень    = ОбластьДень.Параметры;
	ПараметрыМесяц   = ОбластьМесяц.Параметры;
	ПараметрыКвартал = ОбластьКвартал.Параметры;
	ПараметрыГод     = ОбластьГод.Параметры;
	ТекГод           = НачалоГода(ПараметрыОтчета.НачалоПериода);
	ТекКвартал       = НачалоКвартала(ПараметрыОтчета.НачалоПериода);
	
	ТабДокумент.НачатьГруппуСтрок("Год");
	ПараметрыГод.Итого   = "Наростаючим підсумком" + Символы.ПС + "за " + Формат(ТекГод,"ДФ=yyyy") + " рік:";
	
	ТабДокумент.НачатьГруппуСтрок("Квартал");
	ПараметрыКвартал.Итого   = "Наростаючим підсумком" + Символы.ПС + "за "
								+ Формат(ТекКвартал,"ДФ=q") + " квартал "
								+ Формат(ТекКвартал,"ДФ=yyyy") + " року:";
	
	Если ВыборкаМесяц.Следующий() Тогда
									
		ВыборкаДень = ВыборкаМесяц.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если ВыборкаДень.Следующий() Тогда
			
			ВыборкаПериоды = ВыборкаДень.Выбрать();
			
			//Получение оборотов с начала года
			Если ВыборкаПериоды.Следующий() Тогда
				
				ПараметрыГод.Статья3 = ВыборкаПериоды.Статья3;
				ПараметрыГод.Статья4 = ВыборкаПериоды.Статья4;
				ПараметрыГод.Статья5 = ВыборкаПериоды.Статья5;
				ПараметрыГод.Статья6 = ВыборкаПериоды.Статья6;
				ПараметрыГод.Статья7 = ВыборкаПериоды.Статья7;  
				ПараметрыГод.Статья8 = ВыборкаПериоды.Статья8;  
				
			КонецЕсли;
			
			//Получение оборотов с начала квартала
			Если ВыборкаПериоды.Следующий() Тогда
				
				ПараметрыКвартал.Статья3 = ВыборкаПериоды.Статья3;
				ПараметрыКвартал.Статья4 = ВыборкаПериоды.Статья4;
				ПараметрыКвартал.Статья5 = ВыборкаПериоды.Статья5;
				ПараметрыКвартал.Статья6 = ВыборкаПериоды.Статья6;
				ПараметрыКвартал.Статья7 = ВыборкаПериоды.Статья7;
				ПараметрыКвартал.Статья8 = ВыборкаПериоды.Статья8;  
				
			КонецЕсли;
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	Начало = Истина;
	
	Пока ВыборкаМесяц.Следующий() Цикл
		
		Месяц         = ВыборкаМесяц.ПериодМесяц;
		Квартал       = НачалоКвартала(Месяц);
		Год           = НачалоГода(Месяц);
		СменаКвартала = (Квартал <> ТекКвартал);
		СменаГода     = (Год <> ТекГод);
		
		Если Не Начало Тогда
			
			Если СменаКвартала Тогда
				
				ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Квартал"
				ТабДокумент.Вывести(ОбластьКвартал);	
				
			КонецЕсли;
			
			Если СменаГода Тогда
				
				ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Год"
				ТабДокумент.Вывести(ОбластьГод);
				
			КонецЕсли;
			
			Если СменаКвартала Тогда
				
				Если СменаГода Тогда
					
					ТабДокумент.НачатьГруппуСтрок("Год");
					
				КонецЕсли;
				
				ТабДокумент.НачатьГруппуСтрок("Квартал");
				
			КонецЕсли;
			
		Иначе
			
			Начало = Ложь
			
		КонецЕсли;
				
		ТабДокумент.НачатьГруппуСтрок("Месяц");
		
		ВыборкаДень =  ВыборкаМесяц.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаДень.Следующий() Цикл
		
			ТабДокумент.НачатьГруппуСтрок("День");
			
			ВыборкаДокументы = ВыборкаДень.Выбрать();
			
			Пока ВыборкаДокументы.Следующий() Цикл
				
				ПараметрыСтрока.Заполнить(ВыборкаДокументы);
					
				ПараметрыСтрока.ДатаНомер = Формат(ВыборкаДокументы.Период, "ДФ=dd.MM.yyyy");
				ТабДокумент.Вывести(ОбластьСтрока);							
				
			КонецЦикла;
			
			ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "День"
			ПараметрыДень.Заполнить(ВыборкаДень);
			День = ВыборкаДень.ПериодДень;
			ПараметрыДень.Итого = "Разом за " + Формат(День, "ДЛФ=D") + ":";
			ТабДокумент.Вывести(ОбластьДень);
		
		КонецЦикла;
		
		ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Месяц"
		ПараметрыМесяц.Заполнить(ВыборкаМесяц);
		Месяц = ВыборкаМесяц.ПериодМесяц;
		ПараметрыМесяц.Итого = "Разом за " + Формат(Месяц, "Л=uk_UA; ДФ='MMMM yyyy'") + ":";
	    ТабДокумент.Вывести(ОбластьМесяц);
		
		Если СменаКвартала Тогда
			
			ТекКвартал               = Квартал;
			ПараметрыКвартал.Итого   = "Наростаючим підсумком" + Символы.ПС + "за "
			                           + Формат(ТекКвартал,"ДФ=q") + " квартал "
			                           + Формат(ТекКвартал,"ДФ=yyyy") + " року:";
			ПараметрыКвартал.Статья3 = ВыборкаМесяц.Статья3;
			ПараметрыКвартал.Статья4 = ВыборкаМесяц.Статья4;
			ПараметрыКвартал.Статья5 = ВыборкаМесяц.Статья5;
			ПараметрыКвартал.Статья6 = ВыборкаМесяц.Статья6;
			ПараметрыКвартал.Статья7 = ВыборкаМесяц.Статья7;   
			ПараметрыКвартал.Статья8 = ВыборкаМесяц.Статья8;   
			
		Иначе
			
			ПараметрыКвартал.Статья3 = ВыборкаМесяц.Статья3
			                           + ПараметрыКвартал.Статья3;
			ПараметрыКвартал.Статья4 = ВыборкаМесяц.Статья4
			                           + ПараметрыКвартал.Статья4;
			ПараметрыКвартал.Статья5 = ВыборкаМесяц.Статья5
			                           + ПараметрыКвартал.Статья5;
			ПараметрыКвартал.Статья6 = ВыборкаМесяц.Статья6
			                           + ПараметрыКвартал.Статья6;
			ПараметрыКвартал.Статья7 = ВыборкаМесяц.Статья7
			                           + ПараметрыКвартал.Статья7;
			ПараметрыКвартал.Статья8 = ВыборкаМесяц.Статья8   
			                           + ПараметрыКвартал.Статья8;

		КонецЕсли;
		
		
		Если СменаГода Тогда
			
			ТекГод               = Год;
			ПараметрыГод.Итого   = "Наростаючим підсумком" + Символы.ПС + "за " + Формат(ТекГод,"ДФ=yyyy") + " рік:";
			
			ПараметрыГод.Статья3 = ВыборкаМесяц.Статья3;
			ПараметрыГод.Статья4 = ВыборкаМесяц.Статья4;
			ПараметрыГод.Статья5 = ВыборкаМесяц.Статья5;
			ПараметрыГод.Статья6 = ВыборкаМесяц.Статья6;
			ПараметрыГод.Статья7 = ВыборкаМесяц.Статья7;
			ПараметрыГод.Статья8 = ВыборкаМесяц.Статья8;
			
		Иначе
			
			ПараметрыГод.Статья3 = ВыборкаМесяц.Статья3
			                       + ПараметрыГод.Статья3;
			ПараметрыГод.Статья4 = ВыборкаМесяц.Статья4
			                       + ПараметрыГод.Статья4;
			ПараметрыГод.Статья5 = ВыборкаМесяц.Статья5
			                       + ПараметрыГод.Статья5;
			ПараметрыГод.Статья6 = ВыборкаМесяц.Статья6
			                       + ПараметрыГод.Статья6;
			ПараметрыГод.Статья7 = ВыборкаМесяц.Статья7
			                       + ПараметрыГод.Статья7;
			ПараметрыГод.Статья8 = ВыборкаМесяц.Статья8   
			                       + ПараметрыГод.Статья8;
			
		КонецЕсли;
		
		
	КонецЦикла;
	
	ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Квартал"
	ТабДокумент.Вывести(ОбластьКвартал);
	ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Год"
	ТабДокумент.Вывести(ОбластьГод);
	ОбластьПодвал   = Макет.ПолучитьОбласть("Подвал");
	ТабДокумент.Вывести(ОбластьПодвал);
	
	ПоместитьВоВременноеХранилище(ТабДокумент, АдресХранилища);
	
КонецПроцедуры
