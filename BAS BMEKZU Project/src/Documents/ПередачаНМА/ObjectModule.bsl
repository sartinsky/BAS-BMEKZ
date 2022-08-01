#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мВалютаРегламентированногоУчета;

Перем КурсЗачетаАвансаРегл;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА
 
// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыль"             , УчетнаяПолитика.ПлательщикНалогаНаПрибыль(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"		  , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                        , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента, ПогрешностиОкругления)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	ТаблицаТоваров.Колонки.Добавить("ВидДеятельностиНДС", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДеятельностиНДС"));
	
	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		
		// для регламентного учета считаем НДС
		ТаблицаТоваров.ЗаполнитьЗначения(Перечисления.СтавкиНДС.БезНДС, "СтавкаНДС");
		ТаблицаТоваров.ЗаполнитьЗначения(0                            , "НДС");
		
	КонецЕсли;

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		
		СтрокаТаблицы.ВидДеятельностиНДС  = УчетНДС.ПолучитьВидДеятельностиНДС(СтрокаТаблицы.СтавкаНДС);
		
	КонецЦикла;

	НалоговыйУчет.ДобавитьКолонкиТоваровРегл(ТаблицаТоваров, СтруктураШапкиДокумента, ПогрешностиОкругления, Ложь);
	
	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, 
	                          ТаблицаПоТоварам, ТаблицаМестонахождений, Отказ, Заголовок)

	ТекОрганизация = СтруктураШапкиДокумента.Организация;
	ДатаДока       = Дата;
	НомерЖурнала   = НСтр("ru='НА';uk='НА'",Локализация.КодЯзыкаИнформационнойБазы());

	ПроводкиБУ = Движения.Хозрасчетный;

	ТаблицыДокумента = Новый Структура();
   	ТаблицыДокумента.Вставить("ТаблицаПоТоварам",ТаблицаПоТоварам);
		
	ТаблицаАвансов = БухгалтерскийУчетРасчетовСКонтрагентами.ЗачетАванса(ЭтотОбъект, СтруктураШапкиДокумента , мВалютаРегламентированногоУчета, ТаблицыДокумента , Отказ, Заголовок, НомерЖурнала);
		
	КурсЗачетаАвансаРегл = ?(ТаблицаАвансов.Итог("СуммаВал") = 0, Неопределено, ТаблицаАвансов.Итог("Сумма") / ТаблицаАвансов.Итог("СуммаВал"));
	
	ВыручкаПоБУ = ТаблицаПоТоварам.Скопировать();
	ВыручкаПоБУ.Свернуть("СчетДоходовБУ, 
						  |СубконтоДоходовБУ1,
						  |СубконтоДоходовБУ2,
						  |СубконтоДоходовБУ3,
						  |НалоговоеНазначениеДоходовИЗатрат",
						  "ПроводкиСуммаСНДСРегл, 
						  |ПроводкиСуммаБезНДСРегл, 
						  |ОстСтоимостьНУ, 
						  |ПроводкиСуммаСНДСВал");

	Для каждого СтрокаТаблицы из ВыручкаПоБУ Цикл

		// Выручка
		Если СтрокаТаблицы.ПроводкиСуммаСНДСРегл = 0
			 И СтрокаТаблицы.ПроводкиСуммаСНДСВал = 0 Тогда
			
			Продолжить;
			
		КонецЕсли;

		Проводка = ПроводкиБУ.Добавить();

		Проводка.Период       = ДатаДока;
		Проводка.Организация  = СтруктураШапкиДокумента.Организация;
		Проводка.Сумма        = СтрокаТаблицы.ПроводкиСуммаСНДСРегл;
		Проводка.Содержание   = НСтр("ru='Реализация НМА';uk='Реалізація НМА'",Локализация.КодЯзыкаИнформационнойБазы());
		Проводка.НомерЖурнала = НомерЖурнала;

		Проводка.СчетДт = СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"Контрагенты", СтруктураШапкиДокумента.Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"Договоры",    СтруктураШапкиДокумента.ДоговорКонтрагента);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт,Проводка.СубконтоДт,"ДокументыРасчетовСКонтрагентами", УправлениеВзаиморасчетами.ОпределитьДокументРасчетовСКонтрагентом(СтруктураШапкиДокумента.Ссылка,СтруктураШапкиДокумента.Сделка));
		Проводка.ВалютаДт        = СтруктураШапкиДокумента.ВалютаДокумента;
		Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.ПроводкиСуммаСНДСВал;

		Проводка.СчетКт = СтрокаТаблицы.СчетДоходовБУ;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТаблицы.СубконтоДоходовБУ1);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаТаблицы.СубконтоДоходовБУ2);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, СтрокаТаблицы.СубконтоДоходовБУ3);

		СуммаНУДоход = Макс(СтрокаТаблицы.ПроводкиСуммаБезНДСРегл - СтрокаТаблицы.ОстСтоимостьНУ, 0);
		СуммаНУДоходСНДС = Макс(СтрокаТаблицы.ПроводкиСуммаСНДСРегл - СтрокаТаблицы.ОстСтоимостьНУ, 0);
		
		// если доход
		Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И СуммаНУДоход > 0 Тогда
			
			Проводка.НалоговоеНазначениеКт  = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
			Проводка.СуммаНУКт 				= СуммаНУДоходСНДС;
			
		КонецЕсли;
		
	КонецЦикла;

	// Продажи (нал. учет)	
	ТаблицаПоВторомуСобытиюНал = ДвиженияПоРегистрамНалоговогоУчета(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ);
	
	// НДС 
	ПроводкиПоНДС(ПроводкиБУ, СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоВторомуСобытиюНал, Отказ);
	
	//Учет курсовых разниц
	Если (ВалютаДокумента <> мВалютаРегламентированногоУчета) Тогда
		
		БухгалтерскийУчетРед12.ПереоценкаСчетовДокументаРегл(ЭтотОбъект,СтруктураШапкиДокумента, мВалютаРегламентированногоУчета,Отказ,Заголовок);
		
	КонецЕсли; // Учет курсовых разниц
	
	////////////////////////////////////////////////////
	// Движения по регистрам подсистемы НематериальныеАктивы
	
	СостояниеНМА = Движения.СостоянияНМАОрганизаций;

	УправлениеНеоборотнымиАктивами.ДополнитьТабличнуюЧастьСведениямиОбНМАБухНалогРегл(МоментВремени(), ТаблицаПоТоварам,
	                                                  СтруктураШапкиДокумента, 
													  Отказ, Заголовок);

	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;								
	
	// Подготовим таблицу с данными по амортизации для списания амортизации по направлениям затрат
	ТабАмортизации = Новый ТаблицаЗначений;
	ТабАмортизации.Колонки.Добавить("НаправлениеАмортизации", 
									Новый ОписаниеТипов("СправочникСсылка.СпособыОтраженияРасходовПоАмортизации"));
	ТабАмортизации.Колонки.Добавить("ОбъектУчета", 
									Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы"));
	ТабАмортизации.Колонки.Добавить("Сумма", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТабАмортизации.Колонки.Добавить("СуммаНУ", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТабАмортизации.Колонки.Добавить("СчетАмортизации");
	ТабАмортизации.Колонки.Добавить("НалоговоеНазначение", 		Новый ОписаниеТипов("СправочникСсылка.НалоговыеНазначенияАктивовИЗатрат"));
	ТабАмортизации.Колонки.Добавить("Местонахождение",			Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		
	Для Каждого СтрокаНМА Из ТаблицаПоТоварам Цикл
			
		Если СтрокаНМА.АмортизацияЗаМесяцБУ > 0 Тогда
				
			НоваяСтрока = ТабАмортизации.Добавить();
				
			НоваяСтрока.Сумма                  	= СтрокаНМА.АмортизацияЗаМесяцБУ;
			НоваяСтрока.СуммаНУ                	= СтрокаНМА.АмортизацияЗаМесяцНУ;
			НоваяСтрока.ОбъектУчета            	= СтрокаНМА.НематериальныйАктив;
			НоваяСтрока.НаправлениеАмортизации 	= СтрокаНМА.НаправлениеБУ;
			НоваяСтрока.СчетАмортизации        	= СтрокаНМА.СчетНачисленияАмортизацииБУ;
			НоваяСтрока.НалоговоеНазначение 	= СтрокаНМА.НалоговоеНазначение_НМА;
			
			ТекМестонахождение 					= ТаблицаМестонахождений.Найти(СтрокаНМА.НематериальныйАктив,"НМА_БУ");
			НоваяСтрока.Местонахождение 		= ?(ТекМестонахождение = Неопределено, Неопределено, ТекМестонахождение.Местонахождение_БУ);
			
		КонецЕсли;
			
	КонецЦикла;
		
	// Вызов процедуры списания амортизации по направлениям.
	// Создаются движения по начислению амортизации.
	УправлениеНеоборотнымиАктивами.ПолучитьРаспределениеАмортизацииПоНаправлениямРегл(ПроводкиБУ,
													   Отказ,
													   Заголовок,
													   ТабАмортизации,
													   СтруктураШапкиДокумента,
													   НомерЖурнала,
													   НСтр("ru='Начисление амортизации НМА';uk='Нарахування амортизації НМА'",Локализация.КодЯзыкаИнформационнойБазы()));

	НеОблНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
	
	// Создание движений документа по БУ	
	Для Каждого СтрокаТЧ Из ТаблицаПоТоварам Цикл

		ТекНМА = СтрокаТЧ.НематериальныйАктив;

		НепроизводственноеНМА = (СтрокаТЧ.НалоговоеНазначение_НМА = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
		
		// Движения по регистру СостоянияНМАОрганизаций
		Движение = СостояниеНМА.Добавить();
		Движение.Период               = ДатаДока;
		Движение.НематериальныйАктив  = ТекНМА;
		Движение.Организация          = ТекОрганизация;
		Движение.Состояние            = Перечисления.ВидыСостоянийНМА.Списан;
			
		// списание амортизации Д СчетНачисленияАмортизации К СчетУчета
		СуммаПроводки 	= СтрокаТЧ.АмортизацияБУ + СтрокаТЧ.АмортизацияЗаМесяцБУ;
		СуммаПроводкиНУ = СтрокаТЧ.АмортизацияНУ + СтрокаТЧ.АмортизацияЗаМесяцНУ;
			
		Если СуммаПроводки <> 0 Тогда
				
			Проводка = ПроводкиБУ.Добавить();
				
			Проводка.Период       = ДатаДока;
			Проводка.Активность   = Истина;
			Проводка.Организация  = ТекОрганизация;
			Проводка.Содержание   = НСтр("ru='Списана амортизация';uk='Списано амортизацію'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала = НомерЖурнала;
			Проводка.Сумма        = СуммаПроводки;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
				
				Проводка.НалоговоеНазначениеДт = СтрокаТЧ.НалоговоеНазначение_НМА;
				
			КонецЕсли;	
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль Тогда
				
				Проводка.СуммаНУДт = СуммаПроводкиНУ;
				
			КонецЕсли;
			
			Проводка.СчетДт = СтрокаТЧ.СчетНачисленияАмортизацииБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НематериальныеАктивы", ТекНМА);
				
			Проводка.СчетКт = СтрокаТЧ.СчетУчетаБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НематериальныеАктивы", ТекНМА);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
				
				Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
				
			КонецЕсли;	
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль Тогда
				
				Проводка.СуммаНУКт = СуммаПроводкиНУ;
				
			КонецЕсли;
			
			Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
				// организация - не плательщик НДС. 
				Если НепроизводственноеНМА Тогда
					// Непроизводственное
					Проводка.НалоговоеНазначениеДт = СтрокаТЧ.НалоговоеНазначение_НМА;
					Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
				Иначе	
					Проводка.НалоговоеНазначениеДт = НеОблНДСДеятельность;
					Проводка.НалоговоеНазначениеКт = НеОблНДСДеятельность;
				КонецЕсли;	
			КонецЕсли;	
			
		КонецЕсли;

		// списание остаточной стоимости Д СчетРасходов К СчетУчета
		СуммаПроводки = СтрокаТЧ.СтоимостьБУ - СтрокаТЧ.АмортизацияБУ - СтрокаТЧ.АмортизацияЗаМесяцБУ;
		
		Если СуммаПроводки <> 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период       = ДатаДока;
			Проводка.Организация  = ТекОрганизация;
			Проводка.Содержание   = НСтр("ru='Списана ост. стоимость';uk='Списана зал. вартість'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала = НомерЖурнала;
			Проводка.Сумма        = СуммаПроводки;
			
			Проводка.СчетДт = СтрокаТЧ.СчетРасходовБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаТЧ.СубконтоРасходовБУ1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаТЧ.СубконтоРасходовБУ2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаТЧ.СубконтоРасходовБУ3);
			
			Проводка.СчетКт = СтрокаТЧ.СчетУчетаБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НематериальныеАктивы", ТекНМА);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
				
				Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
				
			КонецЕсли;	
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыль Тогда
				
				Если СтрокаТЧ.НалоговоеНазначение_НМА <> Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность Тогда 
					Проводка.СуммаНУКт = СтрокаТЧ.ОстСтоимостьНУ;
				КонецЕсли;	
				
			КонецЕсли;
			
			СуммаНУРасход = Макс(СтрокаТЧ.ОстСтоимостьНУ - СтрокаТЧ.ПроводкиСуммаБезНДСРегл, 0);
			
			// если расход
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И СуммаНУРасход > 0 Тогда
				
				Проводка.НалоговоеНазначениеДт  = СтрокаТЧ.НалоговоеНазначениеДоходовИЗатрат;
				Проводка.СуммаНУДт 				= СуммаНУРасход;
				
			КонецЕсли;
			
			Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
				// организация - не плательщик НДС. 
				Если НепроизводственноеНМА Тогда
					// Непроизводственное
					Проводка.НалоговоеНазначениеКт = СтрокаТЧ.НалоговоеНазначение_НМА;
				Иначе	
					Проводка.НалоговоеНазначениеКт = НеОблНДСДеятельность;
				КонецЕсли;	
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;

	УправлениеНеоборотнымиАктивами.ПроверкаДублированияЗаписейСостоянийНМА(СтруктураШапкиДокумента.Организация, ДатаДока, Движения.СостоянияНМАОрганизаций,Отказ,Заголовок);


КонецПроцедуры // ДвиженияПоРегистрамРегл()

Процедура ПроводкиПоНДС(ПроводкиБУ, СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоВторомуСобытиюНал, Отказ)
	
	Если СтруктураШапкиДокумента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
		// Это не наши ценности, следовательно НДС по ним учитывать не нужно
		Возврат;
	КонецЕсли;
	
	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		// Учет НДС не ведется
		Возврат;
	КОнецЕсли;

	// Получим таблицу движений по счетам НДС
	
	// ТОВАРЫ
	ТаблицаДвижений = ТаблицаПоТоварам.Скопировать();
	ТаблицаДвижений.Свернуть("СтавкаНДС,
							 |СчетДоходовБУ,
						     |СубконтоДоходовБУ1,
						     |СубконтоДоходовБУ2,
						     |СубконтоДоходовБУ3,
						     |СчетУчетаНДС,
						     |НалоговоеНазначениеДоходовИЗатрат",
						     "ПроводкиСуммаНДСРегл,
						     |ПроводкиСуммаНДСВал, 
						     |ПроводкиСуммаБезНДСРегл,
						     |ОстСтоимостьНУ,
							 |ПроводкиСуммаНДСКурсНБУ");
	
	Для Каждого СтрокаТаблицы Из ТаблицаДвижений Цикл
		
		Если    СтрокаТаблицы.ПроводкиСуммаНДСРегл <> 0 
			ИЛИ СтрокаТаблицы.ПроводкиСуммаНДСВал  <> 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период                     = СтруктураШапкиДокумента.Дата;
			Проводка.Активность                 = Истина;
			Проводка.Организация                = СтруктураШапкиДокумента.Организация;
			Проводка.Сумма                      = СтрокаТаблицы.ПроводкиСуммаНДСРегл;
			Проводка.Содержание                 = НСтр("ru='НДС: налоговые обязательства: отгрузка';uk=""ПДВ: податкові зобов'язання: відвантаження""",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала               = "";

			Проводка.СчетДт                     = СтрокаТаблицы.СчетДоходовБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаТаблицы.СубконтоДоходовБУ1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаТаблицы.СубконтоДоходовБУ2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаТаблицы.СубконтоДоходовБУ3);

			СуммаНУДоход = Макс(СтрокаТаблицы.ПроводкиСуммаБезНДСРегл - СтрокаТаблицы.ОстСтоимостьНУ, 0);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И СуммаНУДоход > 0 Тогда
				
				Проводка.НалоговоеНазначениеДт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
				Проводка.СуммаНУДт = СтрокаТаблицы.ПроводкиСуммаНДСРегл;
				
			КонецЕсли;
			
			Проводка.СчетКт                     = СтрокаТаблицы.СчетУчетаНДС;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", СтруктураШапкиДокумента.Контрагент);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Договоры"   , СтруктураШапкиДокумента.ДоговорКонтрагента);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ДокументыРасчетовСКонтрагентами", НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка));
			
			НалоговыйУчет.РазбитьПроводкуПоНДСНаПервоеВтороеСобытие(ТаблицаПоВторомуСобытиюНал, ПроводкиБУ, Проводка, 
													  "Кт", СтруктураШапкиДокумента.СчетУчетаНДСПодтвержденный, 
													  СтруктураШапкиДокумента.ДоговорКонтрагента, 
													  НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка), Сделка,
													  Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.Реализация,
													  СтрокаТаблицы.СтавкаНДС,
													  ,,,СтрокаТаблицы.ПроводкиСуммаНДСВал, СтрокаТаблицы.ПроводкиСуммаНДСКурсНБУ,КурсЗачетаАвансаРегл);
			
			
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

Функция ДвиженияПоРегистрамНалоговогоУчета(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ)

	ТаблицаПоВторомуСобытиюНал = НалоговыйУчет.СоздатьСтруктуруТаблицыНалоговыхСумм();

	Если Не СтруктураШапкиДокумента.ЕстьНДС Тогда
		Возврат ТаблицаПоВторомуСобытиюНал;
		
	КонецЕсли;
	
	Если  СтруктураШапкиДокумента.ЕстьНалогНаПрибыль 
	  ИЛИ СтруктураШапкиДокумента.ЕстьНДС Тогда
		
		//Отразим Продажи в регистре ПродажиНалоговыйУчет
		НаборДвижений = Движения.ПродажиНалоговыйУчет;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		// ТОВАРЫ
		ТаблицаПродаж = ТаблицаПоТоварам.Скопировать();
		ТаблицаПродаж.Свернуть("СтавкаНДС","СуммаСНДСВал, СуммаНДСВал");
		
		ТаблицаПродаж.Колонки.СуммаСНДСВал.Имя = "СуммаВзаиморасчетов";
		ТаблицаПродаж.Колонки.СуммаНДСВал.Имя  = "СуммаНДС";
		
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПродаж, ТаблицаДвижений);
		ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация       , "Организация");
		ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ДоговорКонтрагента, "ДоговорКонтрагента");
		ТаблицаДвижений.ЗаполнитьЗначения(НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента,
																		СтруктураШапкиДокумента.Ссылка, 
																		СтруктураШапкиДокумента.Сделка),
										  "Сделка");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СобытияПродажиНалоговыйУчет.РеализацияПокупателю, "Событие");
		
		Если СтруктураШапкиДокумента.СложныйНалоговыйУчет Тогда
			
			// очистим налоговые реквизиты
			ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтавкиНДС.ПустаяСсылка(), 			"СтавкаНДС");
			ТаблицаДвижений.ЗаполнитьЗначения(0, 												"СуммаНДС");
			
		Иначе		
			// упрощенный налоговый учет
			Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
				ТаблицаДвижений.ЗаполнитьЗначения(0, 												"СуммаНДС");	
				ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтавкиНДС.ПустаяСсылка(), 			"СтавкаНДС");
			КонецЕсли;
			
			Если СтруктураШапкиДокумента.ВедениеВзаиморасчетовНУ = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам Тогда
				// взаиморасчеты по договору по расчетным документам - необходимо заполнить в регистре реквизит РасчетныйДокумент
				ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Сделка, "РасчетныйДокумент");
			КонецЕсли;			
			
		КонецЕсли;	
		
		Если НЕ Отказ И ТаблицаДвижений.Количество() > 0 Тогда
				
			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
				
			Движения.ПродажиНалоговыйУчет.ВыполнитьПриход();
			Движения.ПродажиНалоговыйУчет.Записать();
				
		КонецЕсли;
		
	КонецЕсли;	
		
	// ОжидаемыйИПодтвержденныйНДСПродаж
	Если НЕ СтруктураШапкиДокумента.СложныйНалоговыйУчет Тогда
		
		// Движения формируются по данным рассчета "первого события" 
	   НалоговыйУчет.ДвиженияПоРегистрамНалоговогоУчетаУпрощенныйНалоговыйУчет(ЭтотОбъект, ТаблицаПоВторомуСобытиюНал);
	
	ИначеЕсли СтруктураШапкиДокумента.ЕстьНДС Тогда

		НаборДвижений = Движения.ОжидаемыйИПодтвержденныйНДСПродаж;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		// ТОВАРЫ
		ТаблицаПродаж = ТаблицаПоТоварам.Скопировать();
		ТаблицаПродаж.Свернуть("СтавкаНДС","СуммаБезНДСВал, СуммаНДСВал");
		
		ТаблицаПродаж.Колонки.СуммаБезНДСВал.Имя = "БазаНДС";
		ТаблицаПродаж.Колонки.СуммаНДСВал   .Имя = "СуммаНДС";
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПродаж, ТаблицаДвижений);
		ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация       , "Организация");
		ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ДоговорКонтрагента, "ДоговорКонтрагента");
			ТаблицаДвижений.ЗаполнитьЗначения(НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента,
																			СтруктураШапкиДокумента.Ссылка, 
																			СтруктураШапкиДокумента.Сделка),
											  	"Сделка");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.Реализация       , "СобытиеНДС");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийОжидаемыйИПодтвержденныйНДСПродаж.ОжидаемыйНДС, "КодОперации");

		Если НЕ Отказ И ТаблицаДвижений.Количество() > 0 Тогда
			
			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
		
			Движения.ОжидаемыйИПодтвержденныйНДСПродаж.ВыполнитьПриход();
			Движения.ОжидаемыйИПодтвержденныйНДСПродаж.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаПоВторомуСобытиюНал;	
	
КонецФункции

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация"          , "ДоговорОрганизация");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидДоговора"          , "ВидДоговора");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Сделка"              , "ВидОперации"          , "СделкаВидОперации");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетов", "ВедениеВзаиморасчетов");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВалютаВзаиморасчетов" , "ВалютаВзаиморасчетов");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетовНУ", "ВедениеВзаиморасчетовНУ");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "СложныйНалоговыйУчет", 	"СложныйНалоговыйУчет");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок) Экспорт
	
	ПогрешностиОкругления = Новый Соответствие;
	
	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "НМА".
	СтруктураПолей = Новый Структура();
	СтруктураПростыхПолей = Новый Структура;
	СтруктураСложныхПолей = Новый Структура;
	
	СтруктураПолей.Вставить("НематериальныйАктив" , "НематериальныйАктив");
	СтруктураПолей.Вставить("Сумма"               , "Сумма");
	СтруктураПолей.Вставить("СтавкаНДС"           , "СтавкаНДС");
	СтруктураПолей.Вставить("НДС"                 , "СуммаНДС");
	СтруктураПолей.Вставить("НомерСтроки"         , "НомерСтроки");
	СтруктураПолей.Вставить("СтоимостьБУ"         , "СтоимостьБУ");
	СтруктураПолей.Вставить("АмортизацияБУ"       , "АмортизацияБУ");
	СтруктураПолей.Вставить("АмортизацияЗаМесяцБУ", "АмортизацияЗаМесяцБУ");
	СтруктураПолей.Вставить("СтоимостьНУ"         , "СтоимостьНУ");
	СтруктураПолей.Вставить("АмортизацияНУ"       , "АмортизацияНУ");
	СтруктураПолей.Вставить("АмортизацияЗаМесяцНУ", "АмортизацияЗаМесяцНУ");
	
	СтруктураПолей.Вставить("СхемаРеализации"    , "СхемаРеализации");
	СтруктураПолей.Вставить("СчетДоходовБУ"      , "СхемаРеализации.СчетДоходов");
	СтруктураПолей.Вставить("СубконтоДоходовБУ1" , "СхемаРеализации.СубконтоДоходов1");
	СтруктураПолей.Вставить("СубконтоДоходовБУ2" , "СхемаРеализации.СубконтоДоходов2");
	СтруктураПолей.Вставить("СубконтоДоходовБУ3" , "СхемаРеализации.СубконтоДоходов3");
	СтруктураПолей.Вставить("СчетРасходовБУ"     , "СхемаРеализации.СчетСебестоимости");
	СтруктураПолей.Вставить("СубконтоРасходовБУ1", "СхемаРеализации.СубконтоСебестоимости1");
	СтруктураПолей.Вставить("СубконтоРасходовБУ2", "СхемаРеализации.СубконтоСебестоимости2");
	СтруктураПолей.Вставить("СубконтоРасходовБУ3", "СхемаРеализации.СубконтоСебестоимости3");
	СтруктураПолей.Вставить("НалоговоеНазначениеДоходовИЗатрат", "НалоговоеНазначениеДоходовИЗатрат");

	СтруктураПолей.Вставить("СчетУчетаНДС"    	, "Ссылка.СчетУчетаНДС");

	СтруктураСложныхПолей.Вставить("ОстСтоимостьНУ"    	, "СтоимостьНУ - АмортизацияНУ - АмортизацияЗаМесяцНУ");
	
 	РезультатЗапросаПоТоварам = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураПолей, СтруктураПростыхПолей, СтруктураСложныхПолей);

	// Подготовим таблицу товаров для проведения
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента, ПогрешностиОкругления);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
 	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если АвторасчетНДС Тогда
		
		// соответствие для хранения погрешностей округлений
		ПогрешностиОкругления = Новый Соответствие();
		// пересчет сумм НДС с учетом ошибок округления
		УчетНДСКлиентСервер.ПересчитатьНДСсУчетомПогрешностиОкругления(НМА, Ссылка, СуммаВключаетНДС, ПогрешностиОкругления, "НМА", Строка(ВалютаДокумента));
		
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "НМА");

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоТоварам;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = НСтр("ru='Проведение документа ""';uk='Проведення документа ""'") + СокрЛП(Ссылка) + """: ";
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	// Получим данные учетной политики
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);

	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	
	//Проверим на возможность проведения в БУ и НУ
	УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтруктураШапкиДокумента, СтруктураШапкиДокумента.ДоговорКонтрагента, Отказ, Заголовок);
	
	//проверка, нет ли списанных НМА в табличной части
	УправлениеНеоборотнымиАктивами.ПроверитьНаСписанностьНМА(МоментВремени(), Организация, ТаблицаПоТоварам, Отказ, Заголовок);
	

	// Подготовим таблицу местонахождения для ТабАмортизации
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТекОрганизация",  Организация);
	Запрос.УстановитьПараметр("ТекПериод",       Дата);
	Запрос.УстановитьПараметр("ВнешнийИсточник", ТаблицаПоТоварам);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
   	|	НематериальныйАктив
	|ПОМЕСТИТЬ НематериальныеАктивы
	|ИЗ &ВнешнийИсточник КАК ВнешнийИсточник
	|";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НематериальныеАктивы.НематериальныйАктив 								КАК НематериальныйАктив,
	|	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив 	КАК НМА_БУ,
	|	МестонахождениеНМАБухгалтерскийУчетСрезПоследних.Местонахождение 		КАК Местонахождение_БУ
	|ИЗ
	|	НематериальныеАктивы
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеНМАБухгалтерскийУчет.СрезПоследних(&ТекПериод, НематериальныйАктив В (ВЫБРАТЬ НематериальныйАктив ИЗ НематериальныеАктивы) И Организация = &ТекОрганизация) КАК МестонахождениеНМАБухгалтерскийУчетСрезПоследних
	|	ПО НематериальныеАктивы.НематериальныйАктив = МестонахождениеНМАБухгалтерскийУчетСрезПоследних.НематериальныйАктив";
	ТаблицаМестонахождений = Запрос.Выполнить().Выгрузить();
	
	// Движения по документу
	Если НЕ Отказ Тогда
		
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаМестонахождений, Отказ, Заголовок);
		
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();
	
	// ИНАГРО
	Движения.Хозрасчетный.Записать();
	ИНАГРО_Общий.ИНАГРО_ДвиженияЗатратыОрганизации_Приход(СтруктураШапкиДокумента, Движения);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Контрагент)
		И ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		Документы.ПередачаНМА.ЗаполнитьСчетаУчетаРасчетов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	ПлательщикНДС 	= УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	ПлательщикНП 	= УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);
	ПлательщикНалогаНаПрибыльДо2015  = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);

	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "ВидДоговора, ВалютаВзаиморасчетов, 
		|СложныйНалоговыйУчет, СхемаНалоговогоУчета");
	ЭтоКомиссия          = РеквизитыДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером;
	СложныйНалоговыйУчет = ЗначениеЗаполнено(ДоговорКонтрагента) И РеквизитыДоговора.СложныйНалоговыйУчет;
	
	Если ЭтоКомиссия Тогда

		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентом");

	КонецЕсли;
	
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДС(ПлательщикНДС, ЭтоКомиссия, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДС");		
	КонецЕсли;
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДСПодтвержденный(ПлательщикНДС, ЭтоКомиссия, Дата, СложныйНалоговыйУчет) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДСПодтвержденный");		
	КонецЕсли;
	
	Если Не ПлательщикНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СтавкаНДС");
	КонецЕсли;
	
	Если Не ПлательщикНалогаНаПрибыльДо2015 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НМА.НалоговоеНазначениеДоходовИЗатрат");
	КонецЕсли;
	
	Если НЕ ЭтоКомиссия Тогда
		// Схемы реализации должны быть заполнены правильно
		МассивРеквизитовДляПроверки = Новый Массив;
		МассивРеквизитовДляПроверки.Добавить("СчетДоходов");
		МассивРеквизитовДляПроверки.Добавить("СчетСебестоимости");
															 
		БухгалтерскийУчет.ПроверитьСхемыРеализацииТабличнойЧастиНаЗаполненость(
			ЭтотОбъект, 
			"НМА", НСтр("ru='НМА';uk='НМА'"), 
			"СхемаРеализации", НСтр("ru='Схема реализации';uk='Схема реалізації'") , 
			МассивРеквизитовДляПроверки, 
			Отказ
		);

    КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
#КонецЕсли

