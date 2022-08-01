#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА


// Процедура определяет возможный вид корректировки налогового кредита, по переданным данным
//
// Параметры
//  Данные  – Строка табличной части, структура, строка таблицы. Должна содержать реквизиты (колонки):
//  			НалоговоеНазначение, НалоговоеНазначениеНовое
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВидыКорректировокНалоговогоКредита  - вид корректировки. Если неопределен - пустая ссылка.
//
Функция ОпределитьВидКорректировкиНК(Данные) Экспорт
	
	Если    НЕ ЗначениеЗаполнено(Данные.НалоговоеНазначение)
		ИЛИ НЕ ЗначениеЗаполнено(Данные.НалоговоеНазначениеНовое)
		ИЛИ (Данные.НалоговоеНазначениеНовое = Данные.НалоговоеНазначение) Тогда 
		
		Возврат  Перечисления.ВидыКорректировокНалоговогоКредита.ПустаяСсылка();
		
	КонецЕсли; 
	
	НалоговыйКредитВход  =      УчетНДС.ЕстьПравоНаНалоговыйКредит(Данные.НалоговоеНазначение)
						    ИЛИ Данные.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально;
	НалоговыйКредитВыход = УчетНДС.ЕстьПравоНаНалоговыйКредит(Данные.НалоговоеНазначениеНовое)
							ИЛИ Данные.НалоговоеНазначениеНовое = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально;
	
	Если НалоговыйКредитВход = НалоговыйКредитВыход Тогда
		
		Возврат Перечисления.ВидыКорректировокНалоговогоКредита.НетКорректировок;
		
	ИначеЕсли НалоговыйКредитВход И НЕ НалоговыйКредитВыход Тогда
		
		Возврат Перечисления.ВидыКорректировокНалоговогоКредита.ПотеряПраваНаНалоговыйКредит;
		
	Иначе
		
		Возврат Перечисления.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит;
		
	КонецЕсли;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА


// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоЗатратам - результат запроса по табличной части "Затраты",
//  СтруктураШапкиДокумента   - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуЗатрат(РезультатЗапросаПоЗатратам)
	
	ТаблицаТоваров = РезультатЗапросаПоЗатратам.Выгрузить();
	
	ТаблицаТоваров.Колонки.Добавить("ВидКорректировкиНалоговогоКредита",Новый ОписаниеТипов("ПеречислениеСсылка.ВидыКорректировокНалоговогоКредита"));
	ТаблицаТоваров.Колонки.Добавить("БазаНДС", 							ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(15,2));
	
	Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.СтавкаНДС) Тогда
			СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
		КонецЕсли;
		
		СтрокаТаблицы.ВидКорректировкиНалоговогоКредита = ОпределитьВидКорректировкиНК(СтрокаТаблицы);
		СтрокаТаблицы.БазаНДС  				  = СтрокаТаблицы.НДС*100/УчетНДС.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС);
	
	КонецЦикла;
	
	Возврат ТаблицаТоваров;
	
КонецФункции // ПодготовитьТаблицуЗатрат()


Процедура ПроверитьВозможностьКорректировки(Таблица, ИмяТабличнойЧасти, Отказ, Заголовок)

	ПредставлениеТабличнойЧасти = Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Представление();
	
	ПропорцНДС = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Пропорционально;
	ОблНДС	   = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_Облагаемая;
	
	Для каждого СтрокаТЧ  Из Таблица Цикл
		
		СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер ""%1"": ';uk='У рядку номер ""%1"": '"), СокрЛП(СтрокаТЧ.НомерСтроки));
		СтрокаСообщения = НСтр("ru='Корректировка между указанными налоговыми назначениями не предусмотрена!';uk='Коригування між вказаними податковими призначеннями не передбачене!'");	
		
		ВыдаватьСообщение = Ложь;
		
		Если СтрокаТЧ.НалоговоеНазначениеНовое = ПропорцНДС Тогда
		
			ВыдаватьСообщение = Истина;
			
		ИначеЕсли СтрокаТЧ.НалоговоеНазначение      = ПропорцНДС 
			    И СтрокаТЧ.НалоговоеНазначениеНовое = ОблНДС Тогда
			
			ВыдаватьСообщение = Истина;
			
		КонецЕсли;
		
		
		Если ВыдаватьСообщение Тогда
			
			
			СтрокаСообщения = СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения;
			Поле = "Затраты[" + Формат(СтрокаТЧ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].НалоговоеНазначениеНовое";								
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,ЭтотОбъект, Поле, "Объект",Отказ);

			
		КонецЕсли;
		
	КонецЦикла; 		

КонецПроцедуры

Процедура ПроверитьЗаполнениеМетодКорректировкиНалоговогоКредитаВТабличнойЧасти(Таблица, ИмяТабличнойЧасти, Отказ, Заголовок)
	
	ПредставлениеТабличнойЧасти = Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Представление();
	
	Для каждого СтрокаТЧ  Из Таблица Цикл
		
		СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер ""%1"": ';uk='У рядку номер ""%1"": '"), СокрЛП(СтрокаТЧ.НомерСтроки));
		СтрокаСообщения = НСтр("ru='Неверное значение метода корректировки налогового кредита (""Метод корректировки"")!';uk='Невірне значення методу коригування податкового кредиту (""Метод коригування"")!'");	
		
		Если 
			(  СтрокаТЧ.ВидКорректировкиНалоговогоКредита = Перечисления.ВидыКорректировокНалоговогоКредита.ПотеряПраваНаНалоговыйКредит
			И СтрокаТЧ.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыйКредит)	
			ИЛИ 
			(     СтрокаТЧ.ВидКорректировкиНалоговогоКредита = Перечисления.ВидыКорректировокНалоговогоКредита.НетКорректировок
			И НЕ СтрокаТЧ.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НеКорректировать)	 Тогда
			
			СтрокаСообщения = СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения;
			Поле = "Затраты[" + Формат(СтрокаТЧ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].МетодКорректировкиНалоговогоКредита";								
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,ЭтотОбъект, Поле, "Объект",Отказ);
			
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры 

// Проверяет правильность заполнения строк табличной части "Затраты".
//
// Параметры:
// Параметры: 
//  ТаблицаПоЗатратам        - таблица значений, содержащая данные для проведения и проверки ТЧ Затраты
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиЗатраты(ТаблицаПоЗатратам, Отказ, Заголовок)
	
	ИмяТабличнойЧасти = "Затраты";
	
	ПроверитьВозможностьКорректировки(ТаблицаПоЗатратам, ИмяТабличнойЧасти, Отказ, Заголовок);
	
	Если НЕ Отказ Тогда
		ПроверитьЗаполнениеМетодКорректировкиНалоговогоКредитаВТабличнойЧасти(ТаблицаПоЗатратам, ИмяТабличнойЧасти, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиЗатраты()

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоЗатратам,Отказ, Заголовок);
	
	ДвиженияПоРегиструОжидаемыйИПодтвержденныйНДСПродаж(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоЗатратам, Отказ, Заголовок);
	
	ПроводкиПоНДС(СтруктураШапкиДокумента, ТаблицаПоЗатратам, Отказ, Заголовок);
	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегиструОжидаемыйИПодтвержденныйНДСПродаж(РежимПроведения, СтруктураШапкиДокумента, 
	ПроводкиПоЗатратам, Отказ, Заголовок)
	
	// для метода корректировки "На обязательства" отражаем в регистре НДСПРодажа, далее в кнге продаж
	// отразится документом НалоговаяНалкданая (Вид операции - Условная продажа)
	НаборДвижений = Движения.ОжидаемыйИПодтвержденныйНДСПродаж;
	
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвиженийОжидаемыйИПодтвержденныйНДСПродаж = НаборДвижений.ВыгрузитьКолонки();
	
	ТаблицаКопия = ПроводкиПоЗатратам.Скопировать();
	ТаблицаКопия.Колонки.Добавить("СобытиеНДС");
	
	// оставим только строки с методом корректировки "на обязательства" и ненулевой суммой обязательств
	Инд = 0;
	Пока Инд < ТаблицаКопия.Количество() Цикл
		СтрокаТаблицы = ТаблицаКопия[Инд];
		
		Если  НЕ СтрокаТаблицы.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства 
			ИЛИ СтрокаТаблицы.НДС = 0 Тогда
			
			ТаблицаКопия.Удалить(СтрокаТаблицы);
			
		Иначе
			
			Если СтрокаТаблицы.ВидКорректировкиНалоговогоКредита = Перечисления.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит Тогда
				СтрокаТаблицы.СобытиеНДС = Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.УсловнаяПродажаВозврат;
			Иначе	
			    СтрокаТаблицы.СобытиеНДС = Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.УсловнаяПродажа;
			КонецЕсли;
			
			Инд = Инд + 1;
			
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаКопия.Колонки.НДС.Имя 	= "СуммаНДС";
	ТаблицаКопия.Свернуть("СтавкаНДС, СобытиеНДС","СуммаНДС, БазаНДС");
	
	// Заполним таблицу движений.
	ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаКопия, ТаблицаДвиженийОжидаемыйИПодтвержденныйНДСПродаж);
	
	ТаблицаДвиженийОжидаемыйИПодтвержденныйНДСПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация			  , "Организация");
	ТаблицаДвиженийОжидаемыйИПодтвержденныйНДСПродаж.ЗаполнитьЗначения(Перечисления.КодыОперацийОжидаемыйИПодтвержденныйНДСПродаж.ОжидаемыйНДС, "КодОперации");
	
	Если ТаблицаДвиженийОжидаемыйИПодтвержденныйНДСПродаж.Количество()>0 Тогда
		
		НаборДвижений.мПериод            = СтруктураШапкиДокумента.Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвиженийОжидаемыйИПодтвержденныйНДСПродаж;
		
		Если Не Отказ Тогда
			Движения.ОжидаемыйИПодтвержденныйНДСПродаж.ВыполнитьПриход();
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроводкиПоНДС(СтруктураШапкиДокумента, ПроводкиПоЗатратам, Отказ, Заголовок)
	
	ПроводкиБУ = Движения.Хозрасчетный;	
	// Проводки по НДС
	
	// Суммы, по корректировкам налоговых обязательств (условная продажа)
	ТаблицаКопия = ПроводкиПоЗатратам.Скопировать();
	
	// оставим только строки с методом корректировки кроме "не корректировать" и ненулевой суммой обязательств
	Инд = 0;
	Пока Инд < ТаблицаКопия.Количество() Цикл
		СтрокаТаблицы = ТаблицаКопия[Инд];
		
		Если    СтрокаТаблицы.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НеКорректировать
			ИЛИ СтрокаТаблицы.НДС = 0 Тогда
			
			ТаблицаКопия.Удалить(СтрокаТаблицы);
			
		Иначе
			
			Инд = Инд + 1;
			
		КонецЕсли;
	КонецЦикла;	
	
	Для каждого СтрокаТаблицы Из ТаблицаКопия Цикл
		
		
		Если СтрокаТаблицы.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства 
			И НЕ СтрокаТаблицы.ВидКорректировкиНалоговогоКредита = Перечисления.ВидыКорректировокНалоговогоКредита.ВосстановлениеПраваНаНалоговыйКредит Тогда
			
			// условная продажа
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период                     = СтруктураШапкиДокумента.Дата;
			Проводка.Активность                 = Истина;
			Проводка.Организация                = СтруктураШапкиДокумента.Организация;
			
			Проводка.Сумма                      = СтрокаТаблицы.НДС;
			
			Проводка.СчетДт						= СтрокаТаблицы.СчетЗатрат;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1 , СтрокаТаблицы.Субконто1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2 , СтрокаТаблицы.Субконто2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3 , СтрокаТаблицы.Субконто3);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
				
				Проводка.НалоговоеНазначениеДт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
				
				Если НЕ Проводка.НалоговоеНазначениеДт  = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность Тогда
					Проводка.СуммаНУДт = СтрокаТаблицы.НДС;	
				КонецЕсли;
			
			КонецЕсли;
			
			Проводка.СчетКт						= СтруктураШапкиДокумента.СчетУчетаНДС_НО;
			
			Проводка.Содержание					= НСтр("ru='Налоговые обязательства по НДС (условная продажа)';uk=""Податкові зобов'язання по ПДВ (умовний продаж)""",Локализация.КодЯзыкаИнформационнойБазы());
			
		Иначе	// на кредит
			
			// восстановление нал. кредита
			// 1. уменьшаем сумму показанных затрат по списанию ТЗР (сторно)
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период                     = СтруктураШапкиДокумента.Дата;
			Проводка.Активность                 = Истина;
			Проводка.Организация                = СтруктураШапкиДокумента.Организация;
			
			Проводка.Сумма                      = - СтрокаТаблицы.НДС;
			Проводка.СчетДт						= СтрокаТаблицы.СчетЗатрат;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1 , СтрокаТаблицы.Субконто1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2 , СтрокаТаблицы.Субконто2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3 , СтрокаТаблицы.Субконто3);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
				Проводка.НалоговоеНазначениеДт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
				Если НЕ Проводка.НалоговоеНазначениеДт  = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность Тогда
					Проводка.СуммаНУДт = - СтрокаТаблицы.НДС;	
				КонецЕсли;
			КонецЕсли;
			
			Проводка.СчетКт						= СтрокаТаблицы.СчетТЗР;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НоменклатурныеГруппы" , СтрокаТаблицы.НоменклатурнаяГруппа);
			
			Проводка.НалоговоеНазначениеКт = СтрокаТаблицы.НалоговоеНазначение;
			Проводка.СуммаНУКт = - СтрокаТаблицы.НДС;
			
			Проводка.Содержание					= НСтр("ru='Восстановление налогового кредита по НДС';uk='Відновлення податкового кредиту по ПДВ'",Локализация.КодЯзыкаИнформационнойБазы());
			
			// Относим сумму на налоговый кредит
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период                     = СтруктураШапкиДокумента.Дата;
			Проводка.Активность                 = Истина;
			Проводка.Организация                = СтруктураШапкиДокумента.Организация;
			
			Проводка.Сумма                      = СтрокаТаблицы.НДС;
			
			Проводка.СчетДт						= СтруктураШапкиДокумента.СчетУчетаКорректировкиНДСКредит;
			
			Проводка.СчетКт						= СтрокаТаблицы.СчетТЗР;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НоменклатурныеГруппы" , СтрокаТаблицы.НоменклатурнаяГруппа);
			
			Проводка.НалоговоеНазначениеКт = СтрокаТаблицы.НалоговоеНазначение;
			Проводка.СуммаНУКт = СтрокаТаблицы.НДС;
			
			Проводка.Содержание					= НСтр("ru='Налоговый кредит по НДС';uk='Податковий кредит по ПДВ'",Локализация.КодЯзыкаИнформационнойБазы());
			Если СтрокаТаблицы.МетодКорректировкиНалоговогоКредита = Перечисления.МетодыКорректировкиНалоговогоКредита.НаНалоговыеОбязательства Тогда
				
				Проводка.СчетДт						= СтруктураШапкиДокумента.СчетУчетаНДС_НО;
				Проводка.Содержание					= НСтр("ru='Налоговые обязательства по НДС (условная продажа) - (сторно)';uk=""Податкові зобов'язання з ПДВ (умовний продаж) - (сторно)""",Локализация.КодЯзыкаИнформационнойБазы());
			
			КонецЕсли;
		
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура определяет параметры регл. учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"       , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, КонецМесяца(СтруктураШапкиДокумента.Дата)));
	
КонецПроцедуры // ПодготовитьПараметрыУчетнойПолитики

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт
	
	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке();
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, );
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(ТаблицаПоЗатратам, Отказ, Заголовок) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗатрат", Затраты.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЗатрат.НомерСтроки,
	|	ТаблицаЗатрат.Сумма,
	|	ТаблицаЗатрат.СчетТЗР,
	|	ТаблицаЗатрат.НоменклатурнаяГруппа,
	|	ТаблицаЗатрат.СчетЗатрат,
	|	ТаблицаЗатрат.Субконто1,
	|	ТаблицаЗатрат.Субконто2,
	|	ТаблицаЗатрат.Субконто3,
	|	ТаблицаЗатрат.НалоговоеНазначениеДоходовИЗатрат,
	|	ТаблицаЗатрат.СуммаНДС КАК НДС,
	|	ТаблицаЗатрат.НалоговоеНазначение,
	|	ТаблицаЗатрат.НалоговоеНазначениеНовое,
	|	ТаблицаЗатрат.МетодКорректировкиНалоговогоКредита,
	|	ТаблицаЗатрат.СтавкаНДС
	|ПОМЕСТИТЬ ВТ_ТаблицаЗатрат
	|ИЗ
	|	&ТаблицаЗатрат КАК ТаблицаЗатрат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаЗатрат.Сумма,
	|	ВТ_ТаблицаЗатрат.СчетТЗР,
	|	ВТ_ТаблицаЗатрат.НоменклатурнаяГруппа,
	|	ВТ_ТаблицаЗатрат.СчетЗатрат,
	|	ВТ_ТаблицаЗатрат.Субконто1,
	|	ВТ_ТаблицаЗатрат.Субконто2,
	|	ВТ_ТаблицаЗатрат.Субконто3,
	|	ВТ_ТаблицаЗатрат.НалоговоеНазначениеДоходовИЗатрат,
	|	ВТ_ТаблицаЗатрат.НДС,
	|	ВТ_ТаблицаЗатрат.НалоговоеНазначение,
	|	ВТ_ТаблицаЗатрат.НалоговоеНазначениеНовое,
	|	ВТ_ТаблицаЗатрат.МетодКорректировкиНалоговогоКредита,
	|	ВТ_ТаблицаЗатрат.СтавкаНДС,
	|	ВТ_ТаблицаЗатрат.НомерСтроки
	|ИЗ
	|	ВТ_ТаблицаЗатрат КАК ВТ_ТаблицаЗатрат";
	
	РезультатЗапросаПоЗатратам = Запрос.Выполнить();
	
	// Подготовим таблицы товаров для проведения.
	ТаблицаПоЗатратам = ПодготовитьТаблицуЗатрат(РезультатЗапросаПоЗатратам);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоЗатратам;
	
	// Заголовок для сообщений об ошибках проведения.
	
	// Проверка ручной корректировки
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);
	  
	ПодготовитьТаблицыДокумента(ТаблицаПоЗатратам, Отказ, Заголовок);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоЗатратам, Отказ, Заголовок);
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	//Заполним счет учета НДС по-умолчанию
	СчетУчетаНДС_НО 	= ПланыСчетов.Хозрасчетный.УсловнаяПродажа;
	СчетУчетаКорректировкиНДСКредит = ПланыСчетов.Хозрасчетный.КорректировкиНалоговогоКредита;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Перем Заголовок, ТаблицаПоЗатратам;
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ПодготовитьТаблицыДокумента(ТаблицаПоЗатратам, Отказ, Заголовок);
	
	// Проверить заполнение ТЧ 
	ПроверитьЗаполнениеТабличнойЧастиЗатраты(ТаблицаПоЗатратам, Отказ, Заголовок);
	
	Если НЕ УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Затраты.НалоговоеНазначениеДоходовИЗатрат");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли
