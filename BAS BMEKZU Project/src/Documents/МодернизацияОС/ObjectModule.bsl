#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Перем АмортизацияБА Экспорт; // ИНАГРО
	
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ЕстьНДС = УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата));
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыль"             , УчетнаяПолитика.ПлательщикНалогаНаПрибыль(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"       , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                        , ЕстьНДС);
	СтруктураШапкиДокумента.Вставить("УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ", УчетнаяПолитика.УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
	ДатаНКУ2015 = '2015 01 01';
	Если СтруктураШапкиДокумента.Дата >=  ДатаНКУ2015 Тогда
		СтруктураШапкиДокумента.Вставить("УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ", Ложь);
	КонецЕсли;	
	
	Если НЕ ЕстьНДС Тогда
		СтруктураШапкиДокумента.Вставить("НалоговоеНазначениеОбъектаСтроительства", Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность);
	КонецЕсли;									 
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоОС, ТаблицаМестонахождений, Отказ, Заголовок)

	ДатаДока       = Дата;
	ТекОрганизация = СтруктураШапкиДокумента.Организация;

	УправлениеНеоборотнымиАктивами.ДополнитьТабличнуюЧастьСведениямиОбОСБухНалогРегл(МоментВремени(), ТаблицаПоОС,
	                                                  СтруктураШапкиДокумента, 
													  Отказ, Заголовок, , Истина);

	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;								
													  
	ОперацииОС             		= Движения.СобытияОСОрганизаций;
	ПараметрыАмортизацииОС 		= Движения.ПараметрыАмортизацииОСБухгалтерскийУчет;
	ПараметрыАмортизацииОС_НУ 	= Движения.ПараметрыАмортизацииОСНалоговыйУчет;
	ПроводкиБУ             		= Движения.Хозрасчетный;
	
	// Подготовим таблицу с данными по амортизации для списания амортизации по направлениям затрат
	ТабАмортизации = Новый ТаблицаЗначений;
	ТабАмортизации.Колонки.Добавить("НаправлениеАмортизации", 	Новый ОписаниеТипов("СправочникСсылка.СпособыОтраженияРасходовПоАмортизации"));
	ТабАмортизации.Колонки.Добавить("ОбъектУчета", 				Новый ОписаниеТипов("СправочникСсылка.ОсновныеСредства"));
	ТабАмортизации.Колонки.Добавить("Сумма", 					ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТабАмортизации.Колонки.Добавить("СуммаНУ", 					ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТабАмортизации.Колонки.Добавить("СчетАмортизации", 			Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	ТабАмортизации.Колонки.Добавить("НалоговоеНазначение", 		Новый ОписаниеТипов("СправочникСсылка.НалоговыеНазначенияАктивовИЗатрат"));
	ТабАмортизации.Колонки.Добавить("Местонахождение",			Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
	
	НеОблНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
	
	ДатаНКУ2015 = '2015 01 01';
	ЭтоДокументДо2015 = (Дата < ДатаНКУ2015);
	
	Для Каждого СтрокаТЧ Из ТаблицаПоОС Цикл

		ТекОС = СтрокаТЧ.ОсновноеСредство;
		
		НепроизводственныйОС = (СтрокаТЧ.НалоговоеНазначение_ОС = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
		
		СуммаВСтоимостьБУ 	= 0;
		СуммаНаЗатратыБУ 	= 0;
		
		СуммаВСтоимостьНУ 	= Макс(0, СтрокаТЧ.СуммаМодернизацииНУ - СтрокаТЧ.СуммаУлучшенияВПределахНормНУ);
		СуммаНаЗатратыНУ 	= СтрокаТЧ.СуммаУлучшенияВПределахНормНУ;
		
		// в зависимости от вида улучшения
		Если ВидУлучшения = Перечисления.ВидыУлучшения.Ремонт Тогда
			Если СтруктураШапкиДокумента.УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ Тогда
				СуммаВСтоимостьБУ 	= Макс(0, СтрокаТЧ.СуммаМодернизацииНУ - СтрокаТЧ.СуммаУлучшенияВПределахНормНУ);
				СуммаНаЗатратыБУ 	= Макс(0, СтрокаТЧ.СуммаУлучшенияВПределахНормНУ + СтрокаТЧ.СуммаМодернизацииБУ - СтрокаТЧ.СуммаМодернизацииНУ);
			Иначе	
				СуммаВСтоимостьБУ 	= 0;
				СуммаНаЗатратыБУ 	= СтрокаТЧ.СуммаМодернизацииБУ;
			КонецЕсли;	
		Иначе // Модернизация 
			Если СтруктураШапкиДокумента.УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ Тогда
				СуммаВСтоимостьБУ 	= Макс(0, СтрокаТЧ.СуммаМодернизацииНУ - СтрокаТЧ.СуммаУлучшенияВПределахНормНУ);
				СуммаНаЗатратыБУ 	= Макс(0, СтрокаТЧ.СуммаУлучшенияВПределахНормНУ + СтрокаТЧ.СуммаМодернизацииБУ - СтрокаТЧ.СуммаМодернизацииНУ);
			Иначе	 
				СуммаВСтоимостьБУ 	= СтрокаТЧ.СуммаМодернизацииБУ;
				СуммаНаЗатратыБУ 	= 0;
			КонецЕсли;	
		КонецЕсли;	 
		
		Если НЕ ЭтоДокументДо2015 Тогда
			СуммаВСтоимостьНУ 	= СуммаВСтоимостьБУ;
			СуммаНаЗатратыНУ 	= СуммаНаЗатратыБУ;
			
			Если НепроизводственныйОС Тогда
				СуммаВСтоимостьНУ = 0;	
				СуммаНаЗатратыНУ = 0;
			КонецЕсли;	
		КонецЕсли;	
		
		// Движения по регистру СобытияОСОрганизаций
		Движение = ОперацииОС.Добавить();
		Движение.Период				= ДатаДока;
		Движение.ОсновноеСредство	= ТекОС;
		Движение.Организация		= ТекОрганизация;
		Движение.Событие 			= СтруктураШапкиДокумента.СобытиеОС;
		Движение.НазваниеДокумента	= Строка(СтруктураШапкиДокумента.Ссылка.Метаданные());
		Движение.НомерДокумента		= СтруктураШапкиДокумента.Номер;
		Движение.СуммаЗатратБУ		= СтрокаТЧ.СуммаМодернизацииБУ;
		

		Если СуммаВСтоимостьБУ > 0 Тогда
			// Движения по регистру ПараметрыАмортизации
			Движение = ПараметрыАмортизацииОС.Добавить();
			Движение.Период                                       = ДатаДока;
			Движение.ОсновноеСредство                             = ТекОС;
			Движение.Организация                                  = ТекОрганизация;
			Движение.СрокПолезногоИспользования                   = СтрокаТЧ.СрокПолезногоИспользованияБУ;
			Движение.СрокИспользованияДляВычисленияАмортизации    = СтрокаТЧ.СрокИспользованияДляВычисленияАмортизацииБУ;
			Движение.СтоимостьДляВычисленияАмортизации    		  = СтрокаТЧ.СтоимостьДляВычисленияАмортизацииБУ;
			Движение.ОбъемПродукцииРаботДляВычисленияАмортизации  = Макс(0, СтрокаТЧ.ОбъемПродукцииРаботБУ 
			                                                                - СтрокаТЧ.ФактОбъемПродукцииРаботБУ);
			Движение.ОбъемПродукцииРабот                          = СтрокаТЧ.ОбъемПродукцииРаботБУ;
			Движение.ЛиквидационнаяСтоимость                      = СтрокаТЧ.ЛиквидационнаяСтоимостьБУ;
		КонецЕсли;	

		Если СуммаВСтоимостьНУ > 0 Тогда
			// Движения по регистру ПараметрыАмортизацииНУ
			Движение = ПараметрыАмортизацииОС_НУ.Добавить();
			Движение.Период                                       = ДатаДока;
			Движение.ОсновноеСредство                             = ТекОС;
			Движение.Организация                                  = ТекОрганизация;
			Движение.СрокПолезногоИспользования                   = СтрокаТЧ.СрокПолезногоИспользованияНУ;
			Движение.СрокИспользованияДляВычисленияАмортизации    = СтрокаТЧ.СрокИспользованияДляВычисленияАмортизацииНУ;
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль Тогда
				Движение.СтоимостьДляВычисленияАмортизации    		  = СтрокаТЧ.СтоимостьДляВычисленияАмортизацииНУ;
			КонецЕсли;	
		КонецЕсли;
		
		// списание модернизации Д СчетУчета К СчетУчетаВнеоборотногоАктива
		Если СтрокаТЧ.СуммаМодернизацииБУ <> 0 ИЛИ СтрокаТЧ.СуммаМодернизацииНУ <> 0 Тогда

			Если СуммаВСтоимостьБУ <> 0 ИЛИ СуммаВСтоимостьНУ <> 0 Тогда
				
				Проводка = ПроводкиБУ.Добавить();

				Проводка.Период       = ДатаДока;
				Проводка.Организация  = ТекОрганизация;
				Проводка.Содержание   = НСтр("ru='Модернизация ""';uk='Модернізація ""'",Локализация.КодЯзыкаИнформационнойБазы()) + ТекОС + """";
				Проводка.НомерЖурнала = НСтр("ru='ОС';uk='ОЗ'",Локализация.КодЯзыкаИнформационнойБазы());
				Проводка.Сумма        = СуммаВСтоимостьБУ;
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
					
					Проводка.НалоговоеНазначениеДт  = СтрокаТЧ.НалоговоеНазначение_ОС;
					
				КонецЕсли;
					
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль Тогда
					
					Если СтрокаТЧ.НалоговоеНазначение_ОС = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
						Проводка.СуммаНУДт = 0;	
					Иначе	
						Проводка.СуммаНУДт = СуммаВСтоимостьНУ;
					КонецЕсли;	
					
				КонецЕсли;
				
				Проводка.СчетДт       = СтрокаТЧ.СчетУчетаБУ;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ОсновныеСредства", ТекОС);
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
					
					Проводка.НалоговоеНазначениеКт  = СтруктураШапкиДокумента.НалоговоеНазначениеОбъектаСтроительства;
					
				КонецЕсли;
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
					
					Если СтрокаТЧ.НалоговоеНазначение_ОС = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
						Проводка.СуммаНУКт = 0;	
					Иначе
					    Проводка.СуммаНУКт = СуммаВСтоимостьНУ;
					КонецЕсли;	
					
				КонецЕсли;
				
				Проводка.СчетКт       = СтруктураШапкиДокумента.СчетУчетаБУВнеоборотногоАктива;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ОбъектыСтроительства", СтруктураШапкиДокумента.ОбъектСтроительства);
				
				Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
					// организация - не плательщик НДС. 
					Если НепроизводственныйОС Тогда
						// Непроизводственное
						Проводка.НалоговоеНазначениеДт = СтрокаТЧ.НалоговоеНазначение_ОС;
					Иначе	
						Проводка.НалоговоеНазначениеДт = НеОблНДСДеятельность;
					КонецЕсли;	
					
					Проводка.НалоговоеНазначениеКт = НеОблНДСДеятельность;
				КонецЕсли;	
				
			КонецЕсли;	
 
			Если СуммаНаЗатратыБУ <> 0 ИЛИ СуммаНаЗатратыНУ <> 0 Тогда
				 НоваяСтрока = ТабАмортизации.Добавить();
				 
				 НоваяСтрока.Сумма                  = СуммаНаЗатратыБУ;
				 Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль Тогда
					 НоваяСтрока.СуммаНУ                = СуммаНаЗатратыНУ;
				 КонецЕсли;	 
				 НоваяСтрока.ОбъектУчета            = ТекОС;
				 НоваяСтрока.НаправлениеАмортизации = ?(СтруктураШапкиДокумента.ИспользоватьОбщийСпособОтраженияРасходов,
				                                       СтруктураШапкиДокумента.СпособОтраженияРасходов,
													   СтрокаТЧ.НаправлениеБУ);

				 НоваяСтрока.СчетАмортизации        = СтруктураШапкиДокумента.СчетУчетаБУВнеоборотногоАктива;
				 // ИНАГРО++
				 Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
					НоваяСтрока.НалоговоеНазначение = СтруктураШапкиДокумента.НалоговоеНазначениеОбъектаСтроительства;
				 Иначе	
					НоваяСтрока.НалоговоеНазначение = НеОблНДСДеятельность;
				 КонецЕсли;	
				 // ИНАГРО-- 
				 
				 ТекМестонахождение 				= ТаблицаМестонахождений.Найти(СтрокаТЧ.ОсновноеСредство,"ОС_БУ");
				 НоваяСтрока.Местонахождение 		= ?(ТекМестонахождение = Неопределено, Неопределено, ТекМестонахождение.Местонахождение_БУ);
				 
			 КонецЕсли;
			 
			 // ИНАГРО++
			 Если АмортизацияБА И ЗначениеЗаполнено(ИНАГРО_ДокументОперативногоУчета) И НЕ ИНАГРО_ДокументОперативногоУчета.НеПроводитьПоЗатратам  Тогда 
				
				Проводка = ПроводкиБУ.Добавить();
				
				Проводка.Организация 	= СтруктураШапкиДокумента.Организация;
				Проводка.Период 		= СтруктураШапкиДокумента.Дата;
				Проводка.Содержание		= НСтр("ru='Прих: себестоимость';uk='Прих: собівартість'");
				Проводка.Сумма			= СуммаВСтоимостьБУ;
				
				Проводка.СчетДт	= СтруктураШапкиДокумента.СчетУчетаБУВнеоборотногоАктива;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ОбъектыСтроительства", СтруктураШапкиДокумента.ОбъектСтроительства);
				
				Проводка.СчетКт = СтруктураШапкиДокумента.ИНАГРО_СчетЗатрат;				
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, ИНАГРО_СубконтоЗатрат1);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, ИНАГРО_СубконтоЗатрат2);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, ИНАГРО_СубконтоЗатрат3);
				
				Проводка.НалоговоеНазначениеДт = СтруктураШапкиДокумента.НалоговоеНазначениеОбъектаСтроительства;
				Проводка.НалоговоеНазначениеКт = ИНАГРО_НалоговоеНазначение;
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015
					И ИНАГРО_НалоговоеНазначение <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда
					Проводка.СуммаНУДт = СуммаВСтоимостьНУ;
					Проводка.СуммаНУКт = СуммаВСтоимостьНУ;
				КонецЕсли;
			
			КонецЕсли;
			// ИНАГРО--

		КонецЕсли;
		
	КонецЦикла;
	
	Если ТабАмортизации <> Неопределено Тогда
		
		// Вызов процедуры списания амортизации по направлениям.
		// Создаются движения по начислению амортизации.
		УправлениеНеоборотнымиАктивами.ПолучитьРаспределениеАмортизацииПоНаправлениямРегл(ПроводкиБУ,
		                                                   Отказ,
														   Заголовок,
														   ТабАмортизации,
														   СтруктураШапкиДокумента,
														   НСтр("ru='ОС';uk='ОЗ'",Локализация.КодЯзыкаИнформационнойБазы()),
														   НСтр("ru='Начисление амортизации ОС ""Способ - 100%""';uk='Нарахування амортизації ОЗ ""Спосіб - 100%""'",Локализация.КодЯзыкаИнформационнойБазы()));
		
	КонецЕсли;
													   
	// ИНАГРО++   
	Если НЕ Отказ И АмортизацияБА И ЗначениеЗаполнено(ЭтотОбъект.ИНАГРО_ДокументОперативногоУчета) Тогда 
		
		ТаблицаОС = ОС.Выгрузить();
		// Очистим ТаблицаОС от возможных ОС, которые не относятся к БА (например, если док. введен на основании ИнвентаризацияОС)
		// и дозаполним недостающие реквизиты 
		
		Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
			
			МодульИНАГРО_БиологическиеАктивы = ОбщегоНазначения.ОбщийМодуль("ИНАГРО_БиологическиеАктивы");
			
			ТаблицаОС = МодульИНАГРО_БиологическиеАктивы.ПолучитьИзОС_ОСБА(Дата, Организация, ТаблицаОС);		
			МодульИНАГРО_БиологическиеАктивы.МодернизацияОСБА(ЭтотОбъект, СтруктураШапкиДокумента, ТаблицаОС, Движения);
			
		КонецЕсли;
	
		Движения.Хозрасчетный.Записать();
		
		ИНАГРО_Общий.ИНАГРО_ДвиженияВыпускПродукции(СтруктураШапкиДокумента, Движения);
		
		Если НЕ ИНАГРО_ДокументОперативногоУчета.НеПроводитьПоЗатратам Тогда
			ИНАГРО_Общий.ИНАГРО_ДвиженияЗатратыОрганизации_Приход(СтруктураШапкиДокумента, Движения);
		КонецЕсли; 
	
	КонецЕсли;
	// ИНАГРО--

КонецПроцедуры


// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("ВидСобытияОС",
	                                 СтруктураШапкиДокумента.СобытиеОС.ВидСобытияОС);
	СтруктураШапкиДокумента.Вставить("НалоговоеНазначениеОбъектаСтроительства", 
	                                 СтруктураШапкиДокумента.ОбъектСтроительства.НалоговоеНазначение);
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок) Экспорт
	
	СтруктураПолей = Новый Структура;

	СтруктураПолей.Вставить("ОсновноеСредство",             "ОсновноеСредство");

	СтруктураПолей.Вставить("СтоимостьБУ",                  "СтоимостьБУ");
	СтруктураПолей.Вставить("СуммаМодернизацииБУ",          "СуммаМодернизацииБУ");
	СтруктураПолей.Вставить("АмортизацияБУ",                "АмортизацияБУ");
	СтруктураПолей.Вставить("АмортизацияЗаМесяцБУ",         "АмортизацияЗаМесяцБУ");
	СтруктураПолей.Вставить("ЛиквидационнаяСтоимостьБУ",    "ЛиквидационнаяСтоимостьБУ");
	
	СтруктураПолей.Вставить("СрокПолезногоИспользованияБУ", "СрокПолезногоИспользованияБУ");
	СтруктураПолей.Вставить("ФактСрокИспользованияБУ",      "ФактСрокИспользованияБУ");
	
	СтруктураПолей.Вставить("ОбъемПродукцииРаботБУ",        "ОбъемПродукцииРаботБУ");
	СтруктураПолей.Вставить("ФактОбъемПродукцииРаботБУ",    "ФактОбъемПродукцииРаботБУ");

	СтруктураПолей.Вставить("СуммаМодернизацииНУ",          "СуммаМодернизацииНУ");

	СтруктураПолей.Вставить("СтоимостьНУ",                  "СтоимостьНУ");
	СтруктураПолей.Вставить("АмортизацияНУ",                "АмортизацияНУ");
	СтруктураПолей.Вставить("АмортизацияЗаМесяцНУ",         "АмортизацияЗаМесяцНУ");
	СтруктураПолей.Вставить("ФактСрокИспользованияНУ",      "ФактСрокИспользованияНУ");
	СтруктураПолей.Вставить("СрокПолезногоИспользованияНУ", "СрокПолезногоИспользованияНУ");
	
	СтруктураПолей.Вставить("СуммаУлучшенияВПределахНормНУ", 			"СуммаУлучшенияВПределахНормНУ");
	
	СтруктураПолей.Вставить("СрокИспользованияДляВычисленияАмортизацииБУ", 	"СрокИспользованияДляВычисленияАмортизацииБУ");
	СтруктураПолей.Вставить("СрокИспользованияДляВычисленияАмортизацииНУ", 	"СрокИспользованияДляВычисленияАмортизацииНУ");
	СтруктураПолей.Вставить("СтоимостьДляВычисленияАмортизацииБУ", 			"СтоимостьДляВычисленияАмортизацииБУ");
	СтруктураПолей.Вставить("СтоимостьДляВычисленияАмортизацииНУ", 			"СтоимостьДляВычисленияАмортизацииНУ");
	
	РезультатЗапросаПоОС = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	// Специфические для конкретного документа действия
	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.Модернизация);
	КонецЕсли;

	СчетаУчета = УправлениеНеоборотнымиАктивами.ПолучитьСчетаУчетаОбъектовСтроительства(Организация, ОбъектСтроительства);
	Если НЕ ЗначениеЗаполнено(СчетУчетаБУВнеоборотногоАктива) Тогда
		СчетУчетаБУВнеоборотногоАктива = СчетаУчета.СчетУчетаБУ;
	КонецЕсли;
	
	// ИНАГРО++
	Если ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("ИНАГРО_ДокументОперативногоУчета") Тогда
		Если ДанныеЗаполнения.ИНАГРО_ДокументОперативногоУчета.Метаданные().Имя = "ИНАГРО_ПриплодИПривес" Тогда
			ЗаполнениеДокументов.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения); 			
		КонецЕсли;
		СобытиеОС = Неопределено;
	КонецЕсли;
	// ИНАГРО--  

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	ПлательщикНалогаНаПрибыль 	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);
	ПлательщикНалогаНаПрибыльДо2015 	= УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);
	ПлательщикНДС 				= УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	
	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

	УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ = УчетнаяПолитика.УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ(Организация, Дата);

	Если УвеличиватьСтоимостьОСНаСуммуУлучшенияВПорядкеНКУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидУлучшения");
	КонецЕсли;	
	
	Если ПлательщикНалогаНаПрибыль Тогда
		Если НЕ ЗначениеЗаполнено(ОбъектСтроительства.НалоговоеНазначение) Тогда
			ТекстСообщения = НСтр("ru='Не заполнено налоговое назначение у объекта строительства <%1>';uk=""Не заповнене податкове призначення у об'єкту будівництва <%1>""");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ОбъектСтроительства);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОбъектСтроительства", "Объект", Отказ);
		КонецЕсли;	
	КонецЕсли;	
	
	// Проверим что суммы модернизации относимые на каждый объект ОС в сумме равны данным из шапки документа
	Если ОС.Итог("СуммаМодернизацииБУ") <> СтоимостьБУ Тогда
		
		ТекстСообщения = НСтр("ru='По бухгалтерскому учету общая сумма модернизации, не соответствует в итоге суммам, отнесенным на основные средства!';uk='По бухгалтерському обліку загальна сума модернізації, не відповідає в підсумку сумам, віднесеним на основні засоби!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СтоимостьБУ", "Объект", Отказ);
							 
	КонецЕсли;

	Если ПлательщикНалогаНаПрибыльДо2015 Тогда
		 
		// Проверим что суммы модернизации относимые на каждый объект ОС в сумме равны данным из шапки документа
		Если ОС.Итог("СуммаМодернизацииНУ") <> СтоимостьНУ Тогда
			
			ТекстСообщения = НСтр("ru='По налоговому учету общая сумма модернизации, не соответствует в итоге суммам, отнесенным на основные средства!';uk='По податковому обліку загальна сума модернізації, не відповідає в підсумку сумам, віднесеним на основні засоби!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СтоимостьНУ", "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПлательщикНалогаНаПрибыльДо2015
		И ИспользоватьОбщийСпособОтраженияРасходов
		И Дата >= НалоговыйУчетПовтИсп.ДатаНачалаРаспределенияОПЗвНУ() Тогда
		
		Для Каждого СтрокаСпособа Из СпособОтраженияРасходов.Способы  Цикл
			
			Если УправлениеПроизводствомВызовСервера.ПолучитьХарактерЗатратПоСчетуЗатрат(СтрокаСпособа.СчетЗатрат,,Дата) = "ОПЗ" 
				И НЕ ЗначениеЗаполнено(СтрокаСпособа.НалоговоеНазначение)Тогда
				ТекстСообщения = НСтр("ru='В строке %1 табличной части способа отражения расходов %2 указан счет ОПЗ и не указано налоговое назначение НДС. Для отражения расходов по данному документу налоговое назначение НДС должно быть указано!';uk='У рядку %1 табличної частини способу відображення витрат %2 вказаний рахунок ЗВВ і не зазначене податкове призначення ПДВ. Для відображення витрат по даному документу податкове призначення ПДВ має бути зазначено!'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаСпособа.НомерСтроки, СпособОтраженияРасходов);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СпособОтраженияРасходов", "Объект", Отказ);
		    КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	
	Если ИспользоватьОбщийСпособОтраженияРасходов Тогда
		ПроверяемыеРеквизиты.Добавить("СпособОтраженияРасходов");
	КонецЕсли;	
	
	Если ВидУлучшения = Перечисления.ВидыУлучшения.Модернизация Тогда 
		ПроверитьЗаполнениеПараметровАмортизацииОС(Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Проверяет правильность заполнения строк табличной части "ОС".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеПараметровАмортизацииОС(Отказ)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация",     Организация);
	Запрос.УстановитьПараметр("Период",          Новый Граница(Дата, ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ВнешнийИсточник", ОС);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВнешнийИсточник.ОсновноеСредство КАК ОсновноеСредство,
	               |	ВнешнийИсточник.СрокИспользованияДляВычисленияАмортизацииБУ КАК СрокИспользованияДляВычисленияАмортизацииБУ,
	               |	ВнешнийИсточник.СрокИспользованияДляВычисленияАмортизацииНУ КАК СрокИспользованияДляВычисленияАмортизацииНУ,
	               |	ВнешнийИсточник.НомерСтроки КАК НомерСтроки,
	               |	ВнешнийИсточник.ОбъемПродукцииРаботБУ КАК ОбъемПродукцииРаботБУ
	               |ПОМЕСТИТЬ ОсновныеСредства
	               |ИЗ
	               |	&ВнешнийИсточник КАК ВнешнийИсточник
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ОсновноеСредство
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ОсновныеСредства.ОсновноеСредство КАК ОсновноеСредство,
	               |	ЕСТЬNULL(ПервоначальныеСведенияБУ.СпособНачисленияАмортизации, ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.ПустаяСсылка)) КАК СпособНачисленияАмортизацииБУ,
	               |	ЕСТЬNULL(ПервоначальныеСведенияНУ.СпособНачисленияАмортизации, ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.ПустаяСсылка)) КАК СпособНачисленияАмортизацииНУ,
	               |	ОсновныеСредства.СрокИспользованияДляВычисленияАмортизацииБУ КАК СрокИспользованияДляВычисленияАмортизацииБУ,
	               |	ОсновныеСредства.СрокИспользованияДляВычисленияАмортизацииНУ КАК СрокИспользованияДляВычисленияАмортизацииНУ,
	               |	ОсновныеСредства.НомерСтроки КАК НомерСтроки,
	               |	ОсновныеСредства.ОбъемПродукцииРаботБУ КАК ОбъемПродукцииРаботБУ
	               |ИЗ
	               |	ОсновныеСредства КАК ОсновныеСредства
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	               |				&Период,
	               |				ОсновноеСредство В
	               |					(ВЫБРАТЬ
	               |						ОсновныеСредства.ОсновноеСредство
	               |					ИЗ
	               |						ОсновныеСредства)) КАК ПервоначальныеСведенияБУ
	               |		ПО ОсновныеСредства.ОсновноеСредство = ПервоначальныеСведенияБУ.ОсновноеСредство
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет.СрезПоследних(
	               |				&Период,
	               |				ОсновноеСредство В
	               |					(ВЫБРАТЬ
	               |						ОсновныеСредства.ОсновноеСредство
	               |					ИЗ
	               |						ОсновныеСредства)) КАК ПервоначальныеСведенияНУ
	               |		ПО ОсновныеСредства.ОсновноеСредство = ПервоначальныеСведенияНУ.ОсновноеСредство";
	
	ТаблицаСведенийОС  = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТЧ Из ТаблицаСведенийОС Цикл

		Если ЗначениеЗаполнено(СтрокаТЧ.СпособНачисленияАмортизацииБУ) Тогда

			Если СтрокаТЧ.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.Производственный Тогда 
				Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ОбъемПродукцииРаботБУ) Тогда
					
					СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для основного средства ""%1"" в строке №%2 не заполнен реквизит ""Объем работ для амортизации (БУ)""!';uk='Для основного засобу ""%1"" в рядку №%2 не заповнений реквізит ""Обсяг робіт для амортизації (БО)""!'"), СтрокаТЧ.ОсновноеСредство, СтрокаТЧ.НомерСтроки);
					Поле = "ОС[" + Формат(СтрокаТЧ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОбъемПродукцииРаботБУ";								
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕСли;
			Иначе 
				Если НЕ ЗначениеЗаполнено(СтрокаТЧ.СрокИспользованияДляВычисленияАмортизацииБУ) Тогда
					СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для основного средства ""%1"" в строке №%2 не заполнен реквизит ""Срок использ. (БУ)""!';uk='Для основного засобу ""%1"" в рядку №%2 не заповнений реквізит ""Строк викор. (БО)""!'"), СтрокаТЧ.ОсновноеСредство, СтрокаТЧ.НомерСтроки);
					Поле = "ОС[" + Формат(СтрокаТЧ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СрокИспользованияДляВычисленияАмортизацииБУ";								
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(СтрокаТЧ.СпособНачисленияАмортизацииНУ) Тогда
			
			Если НЕ СтрокаТЧ.СпособНачисленияАмортизацииНУ = Перечисления.СпособыНачисленияАмортизацииОС.Производственный Тогда
				Если НЕ ЗначениеЗаполнено(СтрокаТЧ.СрокИспользованияДляВычисленияАмортизацииНУ) Тогда
					СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для основного средства ""%1"" в строке №%2 не заполнен реквизит ""Срок использ. (НУ)""!';uk='Для основного засобу ""%1"" в рядку №%2 не заповнений реквізит ""Строк викор. (ПО)""!'"), СтрокаТЧ.ОсновноеСредство, СтрокаТЧ.НомерСтроки);
					Поле = "ОС[" + Формат(СтрокаТЧ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СрокИспользованияДляВычисленияАмортизацииНУ";								
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,ЭтотОбъект, Поле, "Объект",Отказ);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиОС()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ,РежимПроведения)

	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоОС;
	
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
                                                                                                    
	// Получим данные учетной политики                                                             
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок);
	
	//проверка, нет ли списанных ОС в табличной части
	УправлениеНеоборотнымиАктивами.ПроверитьНаСписанность(МоментВремени(), Организация, ТаблицаПоОС, Отказ, Заголовок);

	// Подготовим таблицу местонахождения для ТабАмортизации
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("Период",       Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ВнешнийИсточник", ТаблицаПоОС);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
   	|	ВнешнийИсточник.ОсновноеСредство
	|ПОМЕСТИТЬ ОсновныеСредства
	|ИЗ &ВнешнийИсточник КАК ВнешнийИсточник
	|;
	|ВЫБРАТЬ
	|	ОсновныеСредства.ОсновноеСредство 									КАК ОсновноеСредство,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство 	КАК ОС_БУ,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение 	КАК Местонахождение_БУ
	|ИЗ
	|	ОсновныеСредства
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&Период, ОсновноеСредство В (ВЫБРАТЬ ОсновноеСредство ИЗ ОсновныеСредства) И Организация = &Организация) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
	|	ПО ОсновныеСредства.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство";
	ТаблицаМестонахождений = Запрос.Выполнить().Выгрузить();
	
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоОС, ТаблицаМестонахождений, Отказ, Заголовок);		
	
	Если ВидУлучшения = Перечисления.ВидыУлучшения.Ремонт Тогда // ИНАГРО
		ИНАГРО_Общий.ИНАГРО_ДвиженияЗатратыОрганизации_Приход(СтруктураШапкиДокумента, Движения);
	КонецЕсли;  
		
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	ДатаНКУ2015 = '2015 01 01';
	Если Дата >= ДатаНКУ2015 Тогда
		СтоимостьНУ = СтоимостьБУ;
		Для Каждого СтрокаОС Из ОС Цикл
			СтрокаОС.СуммаМодернизацииНУ = СтрокаОС.СуммаМодернизацииБУ;
		КонецЦикла; 
	КонецЕсли;	
	
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);
	
	Если НЕ Отказ Тогда
		Если НЕ ПлательщикНалогаНаПрибыль Тогда
			СтоимостьНУ = 0;	
			Для Каждого СтрокаОС Из ОС Цикл
				СтрокаОС.СуммаМодернизацииНУ = 0;
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли;	
	
	// ИНАГРО++
	Если Проведен И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения И АмортизацияБА		
		 И ЗначениеЗаполнено(ИНАГРО_ДокументОперативногоУчета) И ИНАГРО_ДокументОперативногоУчета.Проведен Тогда
		  
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Отмена проведения запрещена! Документ-основание ""%1"" проведен.';uk='Вiдміна проведення заборонено! Документ-підстава ""%1"" проведений'"),
			ИНАГРО_ДокументОперативногоУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);        		
		Отказ = Истина;
		
	КонецЕсли;
	// ИНАГРО--
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();
	
	// ИНАГРО++
	ИНАГРО_ДокументОперативногоУчета = Неопределено;
	ИНАГРО_БиологическийАктив 		 = Справочники.БиологическиеАктивы.ПустаяСсылка();
	ИНАГРО_Склад					 = Справочники.Склады.ПустаяСсылка();
	ИНАГРО_Комментарий 				 = "";
	// ИНАГРО--

КонецПроцедуры

Процедура ПередУдалением(Отказ) // ИНАГРО
	
	Если АмортизацияБА И ЗначениеЗаполнено(ИНАГРО_ДокументОперативногоУчета) И ИНАГРО_ДокументОперативногоУчета.Проведен Тогда
		  
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Удаление запрещено! Документ-основание ""%1"" проведен.';uk='Видалення заборонено! Документ-підстава ""%1"" проведений'"),
			ИНАГРО_ДокументОперативногоУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);         		
		Отказ = Истина;
		
	КонецЕсли;  	
	
КонецПроцедуры

// ИНАГРО++
АмортизацияБА = Ложь;
Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
	АмортизацияБА = Константы.ИНАГРО_НачислятьАмортизациюБА.Получить();
КонецЕсли;
// ИНАГРО-- 

#КонецЕсли
