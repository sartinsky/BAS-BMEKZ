Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("UK_Макет");
	Макет.КодЯзыкаМакета = "ru";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.АвтоМасштаб = Истина;
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	ОбластьМакета    = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.НазваниеОрганизации = СведенияОбОрганизации.ПолноеНаименование;
	ОбластьМакета.Параметры.НалоговыйНомер = БухгалтерскийУчетПереопределяемый.ПолучитьКодОрганизации(СведенияОбОрганизации);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета    = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачГода",         ПараметрыОтчета.ДатаНачалаНарастающегоИтога);
	Запрос.УстановитьПараметр("НачКвартала",     Макс(ПараметрыОтчета.ДатаНачалаНарастающегоИтога, НачалоКвартала(ПараметрыОтчета.НачалоПериода)));
	Запрос.УстановитьПараметр("ПередНачПериода", ПараметрыОтчета.НачалоПериода - 1);
	Запрос.УстановитьПараметр("НачПериода",      ПараметрыОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонПериода",      КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация",     ПараметрыОтчета.Организация);
	
	Запрос.УстановитьПараметр("СтатьяРеализация",                Справочники.СтатьиНалоговыхДеклараций.ЕННК_ДоходыРеализация);
	Запрос.УстановитьПараметр("СтатьяВозвраты",                  Справочники.СтатьиНалоговыхДеклараций.ЕННК_ДоходыВозвраты);
	
	Запрос.УстановитьПараметр("СтатьяЗатратыСвязанныеСПриобретением", Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЗатратыСвязанныеСПриобретением);
	Запрос.УстановитьПараметр("СтатьяОплатаТруда",                    Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыОплатаТруда);
	Запрос.УстановитьПараметр("СтатьяЕСВ",                            Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЕСВ);
	Запрос.УстановитьПараметр("СтатьяДругиеЗатраты",                  Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыДругиеЗатраты);
	
	МассивСтатейЗатрат = Новый Массив;
	МассивСтатейЗатрат.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЗатратыСвязанныеСПриобретением);
	МассивСтатейЗатрат.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыОплатаТруда);
	МассивСтатейЗатрат.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЕСВ);
	МассивСтатейЗатрат.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыДругиеЗатраты);
	Запрос.УстановитьПараметр("ВсеСтатьиЗатрат", МассивСтатейЗатрат);
	
	МассивВсехСтатей = Новый Массив;
	МассивВсехСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ДоходыРеализация);
	МассивВсехСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ДоходыВозвраты);
	МассивВсехСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЗатратыСвязанныеСПриобретением);
	МассивВсехСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыОплатаТруда);
	МассивВсехСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыЕСВ);
	МассивВсехСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.ЕННК_ЗатратыДругиеЗатраты);
	Запрос.УстановитьПараметр("ВсеСтатьи", МассивВсехСтатей);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья2, 0) КАК Статья2,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья3, 0) КАК Статья3,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья2, 0) - ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья3, 0) КАК Статья4,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья6, 0) КАК Статья6,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья7, 0) КАК Статья7,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья8, 0) КАК Статья8,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья9, 0) КАК Статья9,
	|	0 КАК Статья10,
	|	ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья2, 0) - ЕСТЬNULL(КнигаДоходовРасходовИтог.Статья3, 0) КАК Статья11,
	|	КнигаДоходовРасходовИтог.ПериодМесяц КАК ПериодМесяц,
	|	КнигаДоходовРасходовИтог.ПериодДень КАК ПериодДень,
	|	КнигаДоходовРасходовИтог.Период КАК Период,
	|	КнигаДоходовРасходовИтог.Статья КАК Статья,
	|	ВЫБОР
	|		КОГДА КнигаДоходовРасходовИтог.Статья В (&ВсеСтатьиЗатрат)
	|			ТОГДА КнигаДоходовРасходовИтог.НомерПлатежногоДокумента
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяРеализация
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья2,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяВозвраты
	|					ТОГДА -ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья3,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЗатратыСвязанныеСПриобретением
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья6,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяОплатаТруда
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья7,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяЕСВ
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья8,
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаГода.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА ОборотСНачалаГода.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК Статья9,
	|		NULL КАК ПериодМесяц,
	|		NULL КАК ПериодДень,
	|		NULL КАК Период,
	|		NULL КАК Статья,
	|		NULL КАК НомерПлатежногоДокумента
	|	ИЗ
	|		РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу.Обороты(
	|				&НачГода,
	|				&ПередНачПериода,
	|				,
	|				Организация = &Организация
	|					И Статья В (&ВсеСтатьи)) КАК ОборотСНачалаГода
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяРеализация
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяВозвраты
	|					ТОГДА -ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
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
	|				КОГДА ОборотСНачалаКвартала.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА ОборотСНачалаКвартала.СуммаОборот
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		NULL,
	|		NULL,
	|		1,
	|		NULL,
	|		NULL
	|	ИЗ
	|		РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу.Обороты(
	|				&НачКвартала,
	|				&ПередНачПериода,
	|				,
	|				Организация = &Организация
	|					И Статья В (&ВсеСтатьи)) КАК ОборотСНачалаКвартала
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяРеализация
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		СУММА(ВЫБОР
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяВозвраты
	|					ТОГДА -КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ),
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
	|				КОГДА КнигаДоходовРасходов.Статья = &СтатьяДругиеЗатраты
	|					ТОГДА КнигаДоходовРасходов.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ),
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, МЕСЯЦ),
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, ДЕНЬ),
	|		КнигаДоходовРасходов.Период,
	|		КнигаДоходовРасходов.Статья,
	|		КнигаДоходовРасходов.НомерПлатежногоДокумента
	|	ИЗ
	|		РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу КАК КнигаДоходовРасходов
	|	ГДЕ
	|		КнигаДоходовРасходов.Организация = &Организация
	|		И КнигаДоходовРасходов.Статья В(&ВсеСтатьи)
	|		И КнигаДоходовРасходов.Период >= &НачПериода
	|		И КнигаДоходовРасходов.Период <= &КонПериода
	|	
	|	СГРУППИРОВАТЬ ПО
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, МЕСЯЦ),
	|		НАЧАЛОПЕРИОДА(КнигаДоходовРасходов.Период, ДЕНЬ),
	|		КнигаДоходовРасходов.Период,
	|		КнигаДоходовРасходов.Статья,
	|		КнигаДоходовРасходов.НомерПлатежногоДокумента) КАК КнигаДоходовРасходовИтог
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПериодМесяц,
	|	ПериодДень,
	|	КнигаДоходовРасходовИтог.Период
	|ИТОГИ
	|	СУММА(Статья2),
	|	СУММА(Статья3),
	|	СУММА(Статья4),
	|	СУММА(Статья6),
	|	СУММА(Статья7),
	|	СУММА(Статья8),
	|	СУММА(Статья9),
	|	СУММА(Статья10),
	|	СУММА(Статья11)
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
	
	ИтоговыеПоказатели = Новый Массив;
	ИтоговыеПоказатели.Добавить("Статья2");
	ИтоговыеПоказатели.Добавить("Статья3");
	ИтоговыеПоказатели.Добавить("Статья4");
	ИтоговыеПоказатели.Добавить("Статья6");
	ИтоговыеПоказатели.Добавить("Статья7");
	ИтоговыеПоказатели.Добавить("Статья8");
	ИтоговыеПоказатели.Добавить("Статья9");
	ИтоговыеПоказатели.Добавить("Статья10");
	ИтоговыеПоказатели.Добавить("Статья11");
	
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
				
				Для каждого ИтоговыйПоказатель ИЗ ИтоговыеПоказатели Цикл
					ПараметрыГод[ИтоговыйПоказатель] = ВыборкаПериоды[ИтоговыйПоказатель];
				КонецЦикла;
				
			КонецЕсли;
			
			//Получение оборотов с начала квартала
			Если ВыборкаПериоды.Следующий() Тогда
				
				Для каждого ИтоговыйПоказатель ИЗ ИтоговыеПоказатели Цикл
					ПараметрыКвартал[ИтоговыйПоказатель] = ВыборкаПериоды[ИтоговыйПоказатель];
				КонецЦикла;
				
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
					
				ПараметрыСтрока.Дата = Формат(ВыборкаДокументы.Период, "ДФ=dd.MM.yyyy");
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
			Для каждого ИтоговыйПоказатель ИЗ ИтоговыеПоказатели Цикл
				ПараметрыКвартал[ИтоговыйПоказатель] = ВыборкаМесяц[ИтоговыйПоказатель];
			КонецЦикла;
			
		Иначе
			
			Для каждого ИтоговыйПоказатель ИЗ ИтоговыеПоказатели Цикл
				ПараметрыКвартал[ИтоговыйПоказатель] = ПараметрыКвартал[ИтоговыйПоказатель] + ВыборкаМесяц[ИтоговыйПоказатель];
			КонецЦикла;
			
		КонецЕсли;
		
		
		Если СменаГода Тогда
			
			ТекГод               = Год;
			ПараметрыГод.Итого   = "Наростаючим підсумком" + Символы.ПС + "за " + Формат(ТекГод,"ДФ=yyyy") + " рік:";
			
			Для каждого ИтоговыйПоказатель ИЗ ИтоговыеПоказатели Цикл
				ПараметрыГод[ИтоговыйПоказатель] = ВыборкаМесяц[ИтоговыйПоказатель];
			КонецЦикла;
			
		Иначе
			
			Для каждого ИтоговыйПоказатель ИЗ ИтоговыеПоказатели Цикл
				ПараметрыГод[ИтоговыйПоказатель] = ПараметрыГод[ИтоговыйПоказатель] + ВыборкаМесяц[ИтоговыйПоказатель];
			КонецЦикла;
			
		КонецЕсли;
		
		
	КонецЦикла;
	
	ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Квартал"
	ТабДокумент.Вывести(ОбластьКвартал);
	ТабДокумент.ЗакончитьГруппуСтрок();//Закончить группу "Год"
	ТабДокумент.Вывести(ОбластьГод);
	
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Подвал"));
	
	ПоместитьВоВременноеХранилище(ТабДокумент, АдресХранилища);
	
КонецПроцедуры
