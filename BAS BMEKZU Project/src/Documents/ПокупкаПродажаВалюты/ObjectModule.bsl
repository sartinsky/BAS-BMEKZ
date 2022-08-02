#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, Отказ, Заголовок);

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ПроводкиБУ	= Движения.Хозрасчетный;
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты Тогда
		
		ДанныеОВалютеРегл   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРегламентированногоУчета, Дата);
		ДанныеОВалюте		= МодульВалютногоУчета.ПолучитьКурсВалюты(Валюта, Дата);
		
		СуммаГривневаяНБУ = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаВалютная, Валюта, ВалютаРегламентированногоУчета,
													 ДанныеОВалюте.Курс, ДанныеОВалютеРегл.Курс, 
													 ДанныеОВалюте.Кратность, ДанныеОВалютеРегл.Кратность);
													 
		СуммаКР = СуммаГривневая - СуммаГривневаяНБУ;
		СуммаКр = Окр(СуммаКр, 2);
		
		//1. Перебрасываем деньги между субсчетами "Деньги в пути"
		
		Проводка = ПроводкиБУ.Добавить();

		Проводка.Период      = Дата;
		Проводка.Организация = Организация;
		Проводка.Содержание  = НСтр("ru='Покупка валюты';uk='Купівля валюти'",Локализация.КодЯзыкаИнформационнойБазы());

		Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Банк);

        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
		
		Проводка.ВалютаДт        = Валюта;
		Проводка.ВалютнаяСуммаДт = СуммаВалютная;
		
		Проводка.Сумма  = СуммаГривневаяНБУ;
		
		//2. Комиссионные банка
		
		Если СуммаКомиссионные > 0 Тогда
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Комиссионные банка';uk='Комісійні банку'",Локализация.КодЯзыкаИнформационнойБазы());

			Проводка.СчетДт      = СчетЗатратКомиссионные;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратКомиссионные);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратКомиссионные);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратКомиссионные);
			
	        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			
			Проводка.Сумма  = СуммаКомиссионные;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУДт = Проводка.Сумма;
			КонецЕсли;

		КонецЕсли;	
		
		//3. Отчисление в пенсионный
		
		Если СуммаПенсионный > 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Начисление сбора в ПФ';uk='Нарахування збору в ПФ'",Локализация.КодЯзыкаИнформационнойБазы());
			
			Проводка.СчетДт      = СчетЗатратПенсионный;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратПенсионный);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратПенсионный);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратПенсионный);
			
			Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.РасчетыПоПенсионномуОбеспечению;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Налоги", Справочники.Налоги.ПенсионныйВалюта);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "СтатьиНалоговыхДеклараций", Справочники.СтатьиНалоговыхДеклараций.НП_Р2ПФВалют);
			
			Проводка.Сумма  = СуммаПенсионный;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУДт = Проводка.Сумма;
			КонецЕсли;
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Уменьшение задолженности перед ПФ';uk='Зменшення заборгованості перед ПФ'",Локализация.КодЯзыкаИнформационнойБазы());
			
			Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.РасчетыПоПенсионномуОбеспечению;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Налоги", Справочники.Налоги.ПенсионныйВалюта);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "СтатьиНалоговыхДеклараций", Справочники.СтатьиНалоговыхДеклараций.НП_Р2ПФВалют);
			
			Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			
			Проводка.Сумма  = СуммаПенсионный;
			
		КонецЕсли;

		//4. Курсовая разница
		Если СуммаКР > 0 Тогда
			
			// уплатили больше, чем зачислили в качестве покрытия купленной валюты - расходы
		
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Расходы: разница курсов покупки и НБУ';uk='Витрати: різниця курсів покупки й НБУ'",Локализация.КодЯзыкаИнформационнойБазы());

			Проводка.СчетДт      = СчетЗатратКурсоваяРазница;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратКурсоваяРазница);

	        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			
			Проводка.Сумма  = СуммаКР;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУДт = Проводка.Сумма;
			КонецЕсли;
			
		ИначеЕсли СуммаКР < 0 Тогда
			// уплатили меньше, чем зачислили в качестве покрытия купленной валюты - доходы
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Доходы: разница курсов покупки и НБУ';uk='Доходи: різниця курсів покупки й НБУ'",Локализация.КодЯзыкаИнформационнойБазы());

	        Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Банк);

			Проводка.СчетКт      = СчетДоходовКурсоваяРазница;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Субконто1ДоходовКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, Субконто2ДоходовКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, Субконто3ДоходовКурсоваяРазница);

			Проводка.Сумма  = -СуммаКР;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетКт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеКт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУКт = Проводка.Сумма;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПродажаВалюты Тогда
		
		ДанныеОВалютеРегл   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРегламентированногоУчета, Дата);
		ДанныеОВалюте		= МодульВалютногоУчета.ПолучитьКурсВалюты(Валюта, Дата);
		
		СуммаГривневаяНБУ = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаВалютная, Валюта, ВалютаРегламентированногоУчета,
													 ДанныеОВалюте.Курс, ДанныеОВалютеРегл.Курс, 
													 ДанныеОВалюте.Кратность, ДанныеОВалютеРегл.Кратность);
		РеестрОстатков=РегистрыБухгалтерии.Хозрасчетный;

		СтруктураОтбора = Новый Структура("Счет",ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте);
		СтруктураОтбора.Вставить("Организация", Организация);
		СтруктураОтбора.Вставить("Валюта", Валюта);
		СтруктураОтбора.Вставить("Субконто1", Банк);
		
		Реквизиты = "Счет,Валюта,Субконто1";
				
		РеестрОстатков=РеестрОстатков.Остатки(Дата,,СтруктураОтбора,Реквизиты,"Сумма,ВалютнаяСумма");
		КурсПоСреднему =0;
		Для каждого Стр из РеестрОстатков цикл
			ОстатокВалРегУчета = Стр.СуммаОстатокДт-Стр.СуммаОстатокКт;
			ОстатокИнаяВал = Стр.ВалютнаяСуммаОстатокДт-Стр.ВалютнаяСуммаОстатокКт;
			КурсПоСреднему = ?(ОстатокИнаяВал = 0, 0, ОстатокВалРегУчета/ОстатокИнаяВал);
		КонецЦикла;
		
		СуммаКР = СуммаВалютная*КурсПоСреднему - СуммаГривневаяНБУ;
		СуммаКР = Окр(СуммаКР, 2);
		
		СуммаРазницы = СуммаГривневая - СуммаГривневаяНБУ;
		
		Если Дата >= '20120101' Тогда
			//Алгоритм в соответствии с Приказом Минфина 1591
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Продажа валюты';uk='Продаж валюти'",Локализация.КодЯзыкаИнформационнойБазы());

			Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Банк);

	        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			
			Проводка.Сумма  		 = СуммаГривневая;
			Проводка.ВалютаКт        = Валюта;
			Проводка.ВалютнаяСуммаКт = СуммаВалютная;
			
			// Доход или расход от разницы курсов
			
			Если СуммаРазницы < 0 Тогда
				
				Проводка = ПроводкиБУ.Добавить();

				Проводка.Период      = Дата;
				Проводка.Организация = Организация;
				Проводка.Содержание  = НСтр("ru='Расходы на продажу валюты';uk='Витрати на продаж валюти'",Локализация.КодЯзыкаИнформационнойБазы());

				Проводка.СчетДт      = СчетЗатратСебестоимость;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратСебестоимость);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратСебестоимость);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратСебестоимость);
				
		        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
				Проводка.ВалютаКт    = Валюта;
				Проводка.Сумма  	 = - СуммаРазницы;
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
					Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
					Проводка.СуммаНУДт = Проводка.Сумма;
				КонецЕсли;
				
			ИначеЕсли СуммаРазницы > 0 Тогда
		
				Проводка = ПроводкиБУ.Добавить();

				Проводка.Период      = Дата;
				Проводка.Организация = Организация;
				Проводка.Содержание  = НСтр("ru='Доходы от продажи валюты';uk='Доходи від продажу валюти'",Локализация.КодЯзыкаИнформационнойБазы());

		        Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Банк);
	            Проводка.ВалютаДт    = Валюта;
				
		        Проводка.СчетКт      = СчетДоходовСебестоимость;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Субконто1ДоходовСебестоимость);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, Субконто2ДоходовСебестоимость);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, Субконто3ДоходовСебестоимость);

				Проводка.Сумма  	 = СуммаРазницы;
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетКт.НалоговыйУчет Тогда 
					Проводка.НалоговоеНазначениеКт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
					Проводка.СуммаНУКт = Проводка.Сумма;
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			//Алгоритм до Приказа Минфина 1591 (до 01.01.2012)
		
			//1. Ожидаемое поступление гривен
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Продажа валюты';uk='Продаж валюти'",Локализация.КодЯзыкаИнформационнойБазы());

			Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Банк);

	        Проводка.СчетКт      = СчетДоходовСебестоимость;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Субконто1ДоходовСебестоимость);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, Субконто2ДоходовСебестоимость);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, Субконто3ДоходовСебестоимость);
			
			Проводка.Сумма  = СуммаГривневая;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетКт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеКт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУКт = ?(СуммаРазницы>0,СуммаРазницы,0);
			КонецЕсли;
			
			//2. Себестоимость валюты
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Продажа валюты: Себестоимость валюты';uk='Продаж валюти: Собівартість валюти'",Локализация.КодЯзыкаИнформационнойБазы());

			
			Проводка.СчетДт      = СчетЗатратСебестоимость;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратСебестоимость);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратСебестоимость);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратСебестоимость);
			
	        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			
			Проводка.ВалютаКт        = Валюта;
			Проводка.ВалютнаяСуммаКт = СуммаВалютная;
			
			Проводка.Сумма  = СуммаГривневаяНБУ;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУДт = ?(СуммаРазницы<0,-СуммаРазницы,0);
			КонецЕсли;
		КонецЕсли;
		
		//3. Комиссионные банка
		
		Если СуммаКомиссионные > 0 Тогда

			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Комиссионные банка';uk='Комісійні банку'",Локализация.КодЯзыкаИнформационнойБазы());

			Проводка.СчетДт      = СчетЗатратКомиссионные;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратКомиссионные);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратКомиссионные);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратКомиссионные);

	        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВНациональнойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			
			Проводка.Сумма  = СуммаКомиссионные;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУДт = Проводка.Сумма;
			КонецЕсли;
			
		КонецЕсли;	

		//4. Курсовая разница
		Если СуммаКР > 0 Тогда
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Расходы: разница курсов покупки и НБУ';uk='Витрати: різниця курсів покупки й НБУ'",Локализация.КодЯзыкаИнформационнойБазы());

			Проводка.СчетДт      = СчетЗатратКурсоваяРазница;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Субконто1ЗатратКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Субконто2ЗатратКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Субконто3ЗатратКурсоваяРазница);
			
	        Проводка.СчетКт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Банк);
			Проводка.ВалютаКт        = Валюта;
			
			Проводка.Сумма  = СуммаКР;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетДт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеДт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУДт = Проводка.Сумма;
			КонецЕсли;
			
		ИначеЕсли СуммаКР < 0 Тогда
			
	
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = Дата;
			Проводка.Организация = Организация;
			Проводка.Содержание  = НСтр("ru='Доходы: разница курсов покупки и НБУ';uk='Доходи: різниця курсів покупки й НБУ'",Локализация.КодЯзыкаИнформационнойБазы());

	        Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПутиВИностраннойВалюте;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Банк);
            Проводка.ВалютаДт        = Валюта;
			
			Проводка.СчетКт      = СчетДоходовКурсоваяРазница;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Субконто1ДоходовКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, Субконто2ДоходовКурсоваяРазница);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, Субконто3ДоходовКурсоваяРазница);

			Проводка.Сумма  = -СуммаКР;
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 И Проводка.СчетКт.НалоговыйУчет Тогда 
				Проводка.НалоговоеНазначениеКт = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
				Проводка.СуммаНУКт = Проводка.Сумма;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

Функция СтруктураОбязательныхПолейШапки()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("Организация",НСтр("ru='Не указана организация!';uk='Не зазначена організація!'"));
	СтруктураПолей.Вставить("Банк",НСтр("ru='Не указан уполномоченный банк!';uk='Не зазначений уповноважений банк!'"));
	СтруктураПолей.Вставить("Валюта",НСтр("ru='Не указана валюта документа!';uk='Не зазначена валюта документа!'"));
	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейШапки()

Функция ДополнитьСтруктуруОбязательныхПолейШапкиРегл(СтруктураПолей)

	СтруктураПолей.Вставить("СчетДоходовКурсоваяРазница",НСтр("ru='Не указан счет доходов по курсовой разнице!';uk='Не зазначений рахунок доходів по курсовій різниці!'"));
	СтруктураПолей.Вставить("СчетЗатратКурсоваяРазница",НСтр("ru='Не указан счет затрат по курсовой разнице!';uk='Не зазначений рахунок витрат по курсовій різниці!'"));
		
	Если ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПокупкаВалюты Тогда
		СтруктураПолей.Вставить("СчетЗатратПенсионный",НСтр("ru='Не указан счет затрат по расчетам с ПФ!';uk=''Не зазначений рахунок витрат по розрахунках із ПФ!'"));
	Иначе
		СтруктураПолей.Вставить("СчетЗатратСебестоимость",НСтр("ru='Не указан счет затрат по себестоимости валюты!';uk='Не зазначений рахунок витрат за собівартістю валюти!'"));
		СтруктураПолей.Вставить("СчетДоходовСебестоимость",НСтр("ru='Не указан счет доходов по себестоимости валюты!';uk='Не зазначений рахунок доходів за собівартістю валюти!'"));
	КонецЕсли;
	
	СтруктураПолей.Вставить("СчетЗатратКомиссионные",НСтр("ru='Не указан счет затрат по комиссионным!';uk='Не зазначений рахунок витрат по комісійним!'"));
	
	Возврат СтруктураПолей;

КонецФункции // ДополнитьСтруктуруОбязательныхПолейШапкиРегл()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаПокупкуПродажуВалюты") Тогда
	
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
		Заявка = ДанныеЗаполнения;
 		Документы.ПокупкаПродажаВалюты.ЗаполнитьПоЗаявке(ЭтотОбъект);
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	// Заполнение реквизитов, специфичных для документа:
	Если ЗначениеЗаполнено(Организация) Тогда
		Документы.ПокупкаПродажаВалюты.УстановитьСчетаУчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
		
	Если ВидОперации = Перечисления.ВидыОперацийПокупкаПродажаВалюты.ПродажаВалюты Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетЗатратПенсионный");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("СчетЗатратСебестоимость");
		МассивНепроверяемыхРеквизитов.Добавить("СчетДоходовСебестоимость");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = НСтр("ru='Проведение документа ""';uk='Проведення документа ""'") + СокрЛП(Ссылка) + """: ";
	
    ОбязательныеПоляШапки = СтруктураОбязательныхПолейШапки();
	ОбязательныеПоляШапки = ДополнитьСтруктуруОбязательныхПолейШапкиРегл(ОбязательныеПоляШапки);
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015", УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация,СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС", УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация,СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьЕдиныйНалог", УчетнаяПолитика.ПлательщикЕдиногоНалога(СтруктураШапкиДокумента.Организация,СтруктураШапкиДокумента.Дата));
	
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецЕсли


