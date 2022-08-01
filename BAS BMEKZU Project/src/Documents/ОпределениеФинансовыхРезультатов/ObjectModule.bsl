#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мКонДата;
Перем мПроводкиБУ;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Возвращает массив со счетами финансовых результатов
//
// Возвращаемое значение:
//   Массив 
//
Функция ПолучитьМассивСчетовФинансовыхРезультатов()

	МассивСчетов = Новый Массив;
	
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатЧрезвычайныхСобытий);
	
	Возврат МассивСчетов;
	
КонецФункции // ПолучитьМассивСчетовФинансовыхРезультатов()
 
// Формирует соответствие счетов доходов (расходов) субсчетам финансовых результатов.
//
// Возвращаемое значение:
//   Соответствие, в котором ключом является счет доходов (расходов), а значением счет финансового результата.
//
Функция ПолучитьСоответствиеСчетов()

	// Операционная деятельность
	СоответствиеСчетов = Новый Соответствие;
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДоходыОтРеализации, 		ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругойОперационныйДоход, 	ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты, 		ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда, 		ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия, 	
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.Амортизация, 				ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты, ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации, 	ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	
	// остатки выбираем всегда, а закрываем по опции
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы,
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
																					
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы,	ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт, 			ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа, 
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.НалогНаПрибыльОтОбычнойДеятельности,
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементамНалогНаПрибыль,
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	
	// Финансовая деятельность
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДоходОтУчастияВКапитале,	ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ПрочиеФинансовыеДоходы,	ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты,			ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале,	ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	
	// Другая обычная деятельность
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеДоходы,				ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам,	ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности,	ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	
	// Чрезвычайная деятельность
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ЧрезвычайныеДоходы,		ПланыСчетов.Хозрасчетный.РезультатЧрезвычайныхСобытий);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ЧрезвычайныеЗатраты,		ПланыСчетов.Хозрасчетный.РезультатЧрезвычайныхСобытий);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементамЧрезвычайныеЗатраты,
																					ПланыСчетов.Хозрасчетный.РезультатЧрезвычайныхСобытий);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементамЧрезвычайныеЗатраты,
																					ПланыСчетов.Хозрасчетный.РезультатЧрезвычайныхСобытий);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.НалогНаПрибыльОтЧрезвычайныхСобытий,
																					ПланыСчетов.Хозрасчетный.РезультатЧрезвычайныхСобытий);
	
	// Всем подчиненным счетам установим такое же соответствие.
	МассивСчетов = Новый Массив;
	Для каждого Элемент Из СоответствиеСчетов Цикл
		МассивСчетов.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Хозрасчетный.Ссылка КАК Ссылка,
	               |	Хозрасчетный.Код КАК Код,
	               |	Хозрасчетный.Родитель
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	               |
	               |ГДЕ
	               |	Хозрасчетный.Ссылка В ИЕРАРХИИ(&МассивСчетов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Хозрасчетный.Ссылка.Код
	               |
	               |ИТОГИ КОЛИЧЕСТВО(Код) ПО
	               |	Ссылка ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	
	ВыборкаПодчиненных = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПодчиненных.Следующий() Цикл
	
		Если СоответствиеСчетов[ВыборкаПодчиненных.Ссылка] = Неопределено 
			И СоответствиеСчетов[ВыборкаПодчиненных.Родитель] <> Неопределено Тогда
		
			СоответствиеСчетов.Вставить(ВыборкаПодчиненных.Ссылка, СоответствиеСчетов[ВыборкаПодчиненных.Родитель]);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат СоответствиеСчетов;

КонецФункции // ПолучитьСоответствиеСчетов()

// Устанавливает значение субконто в проводке по счету-назначению, если на нем есть такой же вид 
//  субконто, как и на счете-источнике.
//
// Параметры
//  СчетИсточника		– ПланСчетовСсылка – счет, откуда берется информация о субконто
//  СчетНазначение		– ПланСчетовСсылка – счет, по которому формируется проводка
//  ПроводкаСубконто	– РегистрБухгалтерииСубконто – коллекция субконто в проводке
//  НомерСубконтоИсточника - Число - номер субконто по счету источника, значение которого передается
//  ЗначениеСубконто 	- Произвольный - значение субконто для установки в проводку
//
Процедура УстановитьСовпадающееПоВидуСубконто(СчетИсточник, СчетНазначение, ПроводкаСубконто, НомерСубконтоИсточника, ЗначениеСубконто)

	Если ЗначениеСубконто = NULL Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если НомерСубконтоИсточника > СчетИсточник.ВидыСубконто.Количество() Тогда
			
		Возврат;
			
	КонецЕсли;
	
	ВидСубконто = СчетИсточник.ВидыСубконто[НомерСубконтоИсточника - 1].ВидСубконто;
	
	Если СчетНазначение.ВидыСубконто.Найти(ВидСубконто) <> Неопределено Тогда
	
		ПроводкаСубконто.Вставить(ВидСубконто, ЗначениеСубконто);
	
	КонецЕсли;

КонецПроцедуры // УстановитьСовпадающееПоВидуСубконто()

// ////////////////////////////////////////////////////////////////////////////////
// // ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет настройки субконто на счетах, которые требуются для правильной работы алгоритма
//
// Параметры
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьНастройкиСубконто(Отказ)

	// Проверяем счета финансовых результатов
	
	МассивСчетовФинРез = ПолучитьМассивСчетовФинансовыхРезультатов();
	
	Для каждого СчетФинРез Из МассивСчетовФинРез Цикл
	
		Для каждого ВидСубконтоСтрока Из СчетФинРез.ВидыСубконто Цикл
		
			Если НЕ ВидСубконтоСтрока.ТолькоОбороты Тогда
			
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='На счетах финансовых результатов допускается аналитический учет только по оборотам (проверьте счет %1, вид субконто ""%2"")!';uk='На рахунках фінансових результатів допускається аналітичний облік тільки по оборотах (перевірте рахунок %1, вид субконто ""%2"")!'"), СчетФинРез, ВидСубконтоСтрока.ВидСубконто);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , "Объект", Отказ);
				
			КонецЕсли; 
		
		КонецЦикла; 
	
	КонецЦикла; 

КонецПроцедуры // ПроверитьНастройкиСубконто()
 

// Выполняет движения по регистрам 
//
Процедура ЗакрытиеДоходовИРасходов(СтруктураШапкиДокумента, Отказ, Заголовок)

	Если НЕ СтруктураШапкиДокумента.ЗакрыватьДоходыИРасходы Тогда
		Возврат;
	КонецЕсли;
	
	// Закрываем счета неоперационных расходов на счет финансового результата.
	// (Операционные расходы закрываются при расчете себестоимости).
	
	// Составим соответствие счетов доходов (расходов) субсчетам финансовых результатов.
	СоответствиеСчетов = ПолучитьСоответствиеСчетов();
	
	// Определим остатки на счетах доходов и расходов
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Счет КАК Счет,
	               |	ХозрасчетныйОстатки.Счет.Вид КАК ВидСчета,
	               |	ХозрасчетныйОстатки.Счет.Код КАК КодСчета,
	               |	ХозрасчетныйОстатки.Субконто1 КАК Субконто1,
	               |	ХозрасчетныйОстатки.Субконто2 КАК Субконто2,
	               |	ХозрасчетныйОстатки.Субконто3 КАК Субконто3,
	               |	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток,
	               |	ХозрасчетныйОстатки.НалоговоеНазначение,
	               |	ХозрасчетныйОстатки.СуммаНУОстаток
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецМесяца, Счет В (&МассивСчетов), , Организация = &Организация) КАК ХозрасчетныйОстатки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КодСчета";
				   
	Запрос.УстановитьПараметр("КонецМесяца", МоментВремени());
	Запрос.УстановитьПараметр("Организация", СтруктураШапкиДокумента.Организация);
	
	МассивСчетов = Новый Массив;
	Для каждого Элемент Из СоответствиеСчетов Цикл
		МассивСчетов.Добавить(Элемент.Ключ);
	КонецЦикла; 
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаОстатков.Следующий() Цикл
		
		СчетФинансовыхРезультатов = СоответствиеСчетов[ВыборкаОстатков.Счет];
		Если СчетФинансовыхРезультатов = Неопределено Тогда
		
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для счета %1 не определен счет финансовых результатов! Остаток на счете не закрыт.';uk='Для рахунку %1 не визначений рахунок фінансових результатів! Залишок на рахунку не закритий.'"), ВыборкаОстатков.КодСчета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , "Объект", Отказ);
			Продолжить;
			
		КонецЕсли;
		
		ЗакрыватьБУ = Истина;
		ЗакрыватьНУ = Истина;
		// остатки выбираем всегда, а закрываем по опции
		Если ВыборкаОстатков.Счет = ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы ИЛИ ВыборкаОстатков.Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы) Тогда 
			ЗакрыватьБУ = СтруктураШапкиДокумента.НеРаспределятьОПЗнаСебестоимостьПродукции;
			ЗакрыватьНУ = СтруктураШапкиДокумента.Дата < НалоговыйУчетПовтИсп.ДатаНачалаРаспределенияОПЗвНУ();
		КонецЕсли;
		
		Если ЗакрыватьБУ И ЗакрыватьНУ Тогда
			Если ВыборкаОстатков.СуммаОстаток = 0 И ВыборкаОстатков.СуммаНУОстаток = 0 Тогда
				Продолжить;
			КонецЕсли;
		ИначеЕсли ЗакрыватьБУ И НЕ ЗакрыватьНУ Тогда
			Если ВыборкаОстатков.СуммаОстаток = 0 Тогда
				Продолжить;
			КонецЕсли;
		ИначеЕсли НЕ ЗакрыватьБУ И ЗакрыватьНУ Тогда
			Если ВыборкаОстатков.СуммаНУОстаток = 0 Тогда
				Продолжить;
			КонецЕсли;
		ИначеЕсли НЕ ЗакрыватьБУ И НЕ ЗакрыватьНУ Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаОстатков.ВидСчета = ВидСчета.Активный Тогда
			
			Проводка = мПроводкиБУ.Добавить();
			Проводка.Период                    = мКонДата;
			Проводка.Организация               = СтруктураШапкиДокумента.Организация;
			
			Проводка.СчетДт                    = СчетФинансовыхРезультатов;
			// Стараемся "передать" информацию о субконто из доходов (расходов) в фин. рез-ты
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 3, ВыборкаОстатков.Субконто3);
			
			Проводка.СчетКт                    = ВыборкаОстатков.Счет;
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 3, ВыборкаОстатков.Субконто3);
			
			Если ЗакрыватьНУ Тогда
				Если Проводка.СчетДт.НалоговыйУчет Тогда
					Проводка.НалоговоеНазначениеДт	   = ВыборкаОстатков.НалоговоеНазначение;
					Проводка.СуммаНУДт                 = ВыборкаОстатков.СуммаНУОстаток;
				КонецЕсли;
				Если Проводка.СчетКт.НалоговыйУчет Тогда
					Проводка.НалоговоеНазначениеКт	   = ВыборкаОстатков.НалоговоеНазначение;
					Проводка.СуммаНУКт                 = ВыборкаОстатков.СуммаНУОстаток;
				КонецЕсли;
			КонецЕсли;
			
			Если ЗакрыватьБУ Тогда
				Проводка.Сумма                     = ВыборкаОстатков.СуммаОстаток;
			КонецЕсли;			
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: закрытие расходов';uk='Фінансові результати: закриття витрат'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала              = НСтр("ru='ФР';uk='ФР'",Локализация.КодЯзыкаИнформационнойБазы());
			
		Иначе
			
			Проводка = мПроводкиБУ.Добавить();
			Проводка.Период                    = мКонДата;
			Проводка.Организация               = СтруктураШапкиДокумента.Организация;
			
			Проводка.СчетДт                    = ВыборкаОстатков.Счет;
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 3, ВыборкаОстатков.Субконто3);
			
			Проводка.СчетКт                    = СчетФинансовыхРезультатов;
			// Стараемся "передать" информацию о субконто из доходов (расходов) в фин. рез-ты
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 3, ВыборкаОстатков.Субконто3);
			
			Если ЗакрыватьНУ Тогда
				Если Проводка.СчетДт.НалоговыйУчет Тогда
					Проводка.НалоговоеНазначениеДт	   = ВыборкаОстатков.НалоговоеНазначение;
					Проводка.СуммаНУДт                 = - ВыборкаОстатков.СуммаНУОстаток;
				КонецЕсли;
				Если Проводка.СчетКт.НалоговыйУчет Тогда
					Проводка.НалоговоеНазначениеКт	   = ВыборкаОстатков.НалоговоеНазначение;
					Проводка.СуммаНУКт                 = - ВыборкаОстатков.СуммаНУОстаток;
				КонецЕсли;
			КонецЕсли;
			
			Если ЗакрыватьБУ Тогда
				Проводка.Сумма                     = - ВыборкаОстатков.СуммаОстаток;
			КонецЕсли;
			
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: закрытие доходов';uk='Фінансові результати: закриття доходів'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала              = НСтр("ru='ФР';uk='ФР'",Локализация.КодЯзыкаИнформационнойБазы());
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	ПроведениеСервер.ЗаписатьНаборЗаписейБезЗамещенияТекущихДвижений(мПроводкиБУ);

КонецПроцедуры

// Выполняет движения по регистрам 
//
Процедура РасчетПрибылиУбытка(СтруктураШапкиДокумента, Отказ, Заголовок)

	Если НЕ СтруктураШапкиДокумента.РассчитыватьПрибыльУбыток Тогда
		Возврат;
	КонецЕсли;
	
	// Определим остатки на счетах финансовых результатов и использованной прибыли
	МассивСчетов = ПолучитьМассивСчетовФинансовыхРезультатов();
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ПрибыльИспользованнаяВОтчетномПериоде);
	
	СтруктураОтбора = Новый Структура("Счет, Организация", МассивСчетов, СтруктураШапкиДокумента.Организация);
	
	ТаблицаОстатков = РегистрыБухгалтерии.Хозрасчетный.Остатки(Новый Граница(МоментВремени(),ВидГраницы.Включая),,СтруктураОтбора,"Счет,НалоговоеНазначение","Сумма,СуммаНУ");
	
	ФинансовыйРезультат = ТаблицаОстатков.Итог("СуммаОстатокДт") - ТаблицаОстатков.Итог("СуммаОстатокКт");
	
	СчетПрибылиУбытка = Неопределено;
	Если ФинансовыйРезультат < 0 Тогда
		
		// Прибыль
		СчетПрибылиУбытка = ПланыСчетов.Хозрасчетный.НераспределеннаяПрибыль;
		
	Иначе
		
		// Убыток
		СчетПрибылиУбытка = ПланыСчетов.Хозрасчетный.НепокрытыйУбыток;
		
	КонецЕсли;
	
	// Закрываем все остатки на счет прибыли (убытка)
	Для каждого СтрокаОстатка Из ТаблицаОстатков Цикл
		
		Остаток = СтрокаОстатка.СуммаОстатокДт - СтрокаОстатка.СуммаОстатокКт;
		ОстатокНУ = СтрокаОстатка.СуммаНУОстатокДт - СтрокаОстатка.СуммаНУОстатокКт;
		
		Если Остаток > 0 Тогда
		
			Проводка = мПроводкиБУ.Добавить();
			Проводка.Период                    = мКонДата;
			Проводка.Организация               = СтруктураШапкиДокумента.Организация;
			Проводка.СчетДт                    = СчетПрибылиУбытка;
			Проводка.СчетКт                    = СтрокаОстатка.Счет;
			Проводка.Сумма                     = Остаток;
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: формирование прибыли/убытка';uk='Фінансові результати: формування прибутку/збитку'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала              = НСтр("ru='ФР';uk='ФР'",Локализация.КодЯзыкаИнформационнойБазы());
			
			Если Проводка.СчетКт.НалоговыйУчет Тогда
				Проводка.НалоговоеНазначениеКт	   = СтрокаОстатка.НалоговоеНазначение;
				Проводка.СуммаНУКт                 = ОстатокНУ;
			КонецЕсли;
			
		Иначе
			
			Проводка = мПроводкиБУ.Добавить();
			Проводка.Период                    = мКонДата;
			Проводка.Организация               = СтруктураШапкиДокумента.Организация;
			Проводка.СчетДт                    = СтрокаОстатка.Счет;
			Проводка.СчетКт                    = СчетПрибылиУбытка;
			Проводка.Сумма                     = -Остаток;
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: формирование прибыли/убытка';uk='Фінансові результати: формування прибутку/збитку'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала              = НСтр("ru='ФР';uk='ФР'",Локализация.КодЯзыкаИнформационнойБазы());
		
			Если Проводка.СчетДт.НалоговыйУчет Тогда
				Проводка.НалоговоеНазначениеДт	   = СтрокаОстатка.НалоговоеНазначение;
				Проводка.СуммаНУДт                 = -ОстатокНУ;
			КонецЕсли;
			
		КонецЕсли; 
	
	КонецЦикла; 

	ПроведениеСервер.ЗаписатьНаборЗаписейБезЗамещенияТекущихДвижений(мПроводкиБУ);

КонецПроцедуры

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ, Заголовок)

	Если СтруктураШапкиДокумента.ЗакрыватьДоходыИРасходы Тогда
		
		ЗакрытиеДоходовИРасходов(СтруктураШапкиДокумента, Отказ, Заголовок);
		
	КонецЕсли;

	Если СтруктураШапкиДокумента.РассчитыватьПрибыльУбыток Тогда
		
		РасчетПрибылиУбытка(СтруктураШапкиДокумента, Отказ, Заголовок);
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	мКонДата    = Дата;
 	мПроводкиБУ = Движения.Хозрасчетный;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);	
	СтруктураШапкиДокумента.Вставить("НеРаспределятьОПЗнаСебестоимостьПродукции", УчетнаяПолитика.НеРаспределятьОПЗнаСебестоимостьПродукции(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));

	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьНастройкиСубконто(Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецЕсли
