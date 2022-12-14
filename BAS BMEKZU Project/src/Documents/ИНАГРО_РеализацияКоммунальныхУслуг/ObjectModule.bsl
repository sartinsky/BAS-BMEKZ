#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мВалютаРегламентированногоУчета;
Перем КурсЗачетаАвансаРегл;

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	// Заполнение реквизитов, специфичных для документа:
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Контрагент)
		И ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		Документы.ИНАГРО_РеализацияКоммунальныхУслуг.ЗаполнитьСчетаУчетаРасчетов(ЭтотОбъект);
	КонецЕсли;    
			
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Определяем условия проведения документа:
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	ПлательщикНалогаНаПрибыльДо2015  = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);
		
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "ВидДоговора, ВалютаВзаиморасчетов, 
		|СложныйНалоговыйУчет, СхемаНалоговогоУчета");
	ЭтоКомиссия          = РеквизитыДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером;
	Внешнеэкономический  = ЗначениеЗаполнено(ДоговорКонтрагента) И (РеквизитыДоговора.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);
	СложныйНалоговыйУчет = ЗначениеЗаполнено(ДоговорКонтрагента) И (РеквизитыДоговора.СложныйНалоговыйУчет);
	
	// Исключаем из проверки реквизиты, заполнение которых стало необязательным:
	МассивНепроверяемыхРеквизитов = Новый Массив();
	НеИспользуемыеТабличныеЧасти  = Новый Массив; 
		
	ОсновныеСписки = Новый Массив();
	ОсновныеСписки.Добавить("Услуги");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ОсновныеСписки, НеИспользуемыеТабличныеЧасти);
	
	ОбщегоНазначенияБП.ИсключитьИзПроверкиОсновныеТабличныеЧасти(
		ЭтотОбъект, 
		ОсновныеСписки, 
		ПроверяемыеРеквизиты); 	
	
	Если ЭтоКомиссия Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентом");
	КонецЕсли;

	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовПоАвансам"); // Не обязателен всегда
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДС(ПлательщикНДС, ЭтоКомиссия, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДС");		
	КонецЕсли;
	
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДСПодтвержденный(ПлательщикНДС, ЭтоКомиссия, Дата, СложныйНалоговыйУчет) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДСПодтвержденный");		
	КонецЕсли;
	
	Если ПлательщикНДС И ЭтоКомиссия Тогда
		
		Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
			// Проверку не выполняем
			
		ИначеЕсли НЕ РеквизитыДоговора.СхемаНалоговогоУчета = Справочники.СхемыНалоговогоУчетаПоДоговорамКонтрагентов.СКомиссионером_НК Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, "Корректность",
			    НСтр("ru='Договор';uk='Договір'"),,,
				НСтр("ru='В договоре комиссии указана неправильная схема налогового учета! Используйте схему для периода с 2011 года!';uk='У договорі комісії зазначена неправильна схема податкового обліку! Використайте схему для періоду з 2011 року!'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДоговорКонтрагента", "Объект", Отказ);
			
		ИначеЕсли НЕ СложныйНалоговыйУчет Тогда			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, "Корректность",
			    НСтр("ru='Договор';uk='Договір'"),,,
				НСтр("ru='По договорам комиссии с 2011 года в конфигурации реализован только ""Сложный налоговый учет"". Установите соответствующий флаг в договоре с контрагентом!';uk='За договорами комісії з 2011 року в конфігурації реалізований тільки ""Складний податковий облік"". Встановіть відповідний прапор в договорі з контрагентом!'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДоговорКонтрагента", "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если (Не ЕстьАвансДо01042011) ИЛИ (ЕстьАвансДо01042011 И НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СуммаВДВРПоАвансуДо01042011");		
	КонецЕсли;
	
	Если Не ПлательщикНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
	КонецЕсли;
	
	// Проверяем корректность заполнения реквизитов шапки:

	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстСообщения = "";
		Если НЕ УчетВзаиморасчетов.ПроверитьВозможностьПроведенияВРеглУчете(
			ЭтотОбъект, ДоговорКонтрагента, ТекстСообщения) Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, "Корректность",
				НСтр("ru='Договор';uk='Договір'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
				"ДоговорКонтрагента", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;

	// Исключаем из проверки те реквизиты табличных частей, обязательность которых
	//  зависит от значений других рекивизитов в строках табличных частей:
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначениеДоходовИЗатрат"); 

	// Получаем содержимое табличных частей объекта с вспомогательными реквизитами:
	СтруктураРезультатов = Новый Структура;
	ТаблицыДокумента = ПолучитьДанныеОбъектаДляПроверкиЗаполнения(СтруктураРезультатов, ЭтоКомиссия);
	
	НехозВНД_НДС = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность;
	НехозВНД_НП  = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность;
	
	// Для определения вида деятельности НДС
	ДопПараметрыОпределенияВДНДС = Новый Структура("БартерИЭкспорт");
	Если (РеквизитыДоговора.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета) 
	   И (РеквизитыДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный) Тогда
		// Бартер и экспорт
		ДопПараметрыОпределенияВДНДС.БартерИЭкспорт = Истина;
	Иначе
		ДопПараметрыОпределенияВДНДС.БартерИЭкспорт = Ложь;
	КонецЕсли;  
	
	// Проверка заполнения табличной части "Услуги"
	Если Не ПлательщикНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
	КонецЕсли;
	
	// Исключаем из проверки те реквизиты табличных частей, обязательность которых
	//  зависит от значений других рекивизитов в строках табличных частей:
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.НалоговоеНазначениеДоходовИЗатрат");
	
	Если ЭтоКомиссия И Услуги.Количество() > 0 Тогда

		// Табличная часть Услуги очистится перед записью

	ИначеЕсли Услуги.Количество() > 0 Тогда

		ВыборкаУслуг = ТаблицыДокумента[СтруктураРезультатов.Услуги].Выбрать();
		ИмяСписка = НСтр("ru='Услуги';uk='Послуги'");

		Пока ВыборкаУслуг.Следующий() Цикл
			Префикс = "Услуги[" + Формат(ВыборкаУслуг.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";

			Если ПлательщикНалогаНаПрибыльДо2015 Тогда   
				
				Если НЕ ЗначениеЗаполнено(ВыборкаУслуг.НалоговоеНазначениеДоходовИЗатрат) Тогда
					
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка",, 
						НСтр("ru='Налоговое назначение (доходов и затрат)';uk='Податкове призначення (доходів і витрат)'"),
						ВыборкаУслуг.НомерСтроки, ИмяСписка);
					Поле = Префикс + "НалоговоеНазначениеДоходовИЗатрат";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					
				ИначеЕсли ВыборкаУслуг.НалоговоеНазначениеДоходовИЗатрат = НехозВНД_НП Тогда 
					
					ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", 
						НСтр("ru='Налоговое назначение (доходов и затрат)';uk='Податкове призначення (доходів і витрат)'"),
						ВыборкаУслуг.НомерСтроки, ИмяСписка, 
						НСтр("ru='Вид налоговой деятельности при реализации не может быть ""Не хозяйственной деятельностью"".';uk='Вид податкової діяльності при реалізації не може бути ""Не господарською діяльністю"".'"));
					Поле = Префикс + "НалоговоеНазначениеДоходовИЗатрат";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
			
			// Налоговое назначение (по НДС) проверять не нужно - оно однозначно определяется по ставке НДС.
			
		КонецЦикла;
		
		// Схемы реализации должны быть заполнены правильно
		МассивРеквизитовДляПроверки = Новый Массив;
		МассивРеквизитовДляПроверки.Добавить("СчетДоходов");
		МассивРеквизитовДляПроверки.Добавить("СчетСебестоимости");
															 
		БухгалтерскийУчет.ПроверитьСхемыРеализацииТабличнойЧастиНаЗаполненость(
			ЭтотОбъект, 
			"Услуги", ИмяСписка, 
			"СхемаРеализации", НСтр("ru='Схема реализации';uk='Схема реалізації'") , 
			МассивРеквизитовДляПроверки, 
			Отказ);

	КонецЕсли;
	
	// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Почистим лишние в табличных частях.
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "ВалютаВзаиморасчетов");
	Внешнеэкономический = ЗначениеЗаполнено(ДоговорКонтрагента) И (РеквизитыДоговора.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);
		
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах.
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
				   
				   
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Дата);
	ПлательщикНалогаНаПрибыльДо2015  = УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(Организация, Дата);			   
	
	Если НЕ ПлательщикНДС Тогда
		// Организация - не плательщик НДС. Установим во всех ТЧ признак соответствующего учета НДС.
		НеОБлНДСДеятельность = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность;
		Для каждого СтрокаТЧ  Из Услуги Цикл
			СтрокаТЧ.НалоговоеНазначение = НеОБлНДСДеятельность;
		КонецЦикла; 
	КонецЕсли; 
	
	Если НЕ ПлательщикНалогаНаПрибыльДо2015 Тогда  				
		Для каждого СтрокаТЧ  Из Услуги Цикл
		    СтрокаТЧ.НалоговоеНазначениеДоходовИЗатрат = Неопределено;
		КонецЦикла; 		
	КонецЕсли; 
	
	Если ЕстьАвансДо01042011 Тогда
		Если НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ Тогда
			СуммаВДВРПоАвансуДо01042011	= СуммаДокумента; 
		КонецЕсли;
	Иначе	
		НеОтноситьСебестоимостьЗапасовНаРасходыПоНУ = Ложь;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПоУслугам;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

    мВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);	
	
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);	
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ, Заголовок);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ, Заголовок);
	КонецЕсли;
						
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений(); 
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект); 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать(); 

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
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
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация",             "ДоговорОрганизация");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидДоговора",             "ВидДоговора");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетов",   "ВедениеВзаиморасчетов");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВалютаВзаиморасчетов", 	 "ВалютаВзаиморасчетов");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетовНУ", "ВедениеВзаиморасчетовНУ");
   	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "СложныйНалоговыйУчет", 	 "СложныйНалоговыйУчет");
	ОбщегоНазначенияРед12.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "СхемаНалоговогоУчета",    "СхемаНалоговогоУчета");
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

КонецПроцедуры

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	РазрешитьУчетУслугБезПлановыхЦен = Не УчетнаяПолитика.ПорядокРаспределенияРасходовНаОказаниеУслуг(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата) = Перечисления.ПорядокРаспределенияРасходовНаОказаниеУслуг.ПоПлановымЦенам;
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015"        , УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС"                         , УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("СпособОценкиТоваровВРознице"	   , УчетнаяПолитика.СпособОценкиТоваровВРознице(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("РазрешитьУчетУслугБезПлановыхЦен", РазрешитьУчетУслугБезПлановыхЦен);
	
КонецПроцедуры

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ, Заголовок) Экспорт
	
	ПогрешностиОкругления     = Новый Соответствие;
	
	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Услуги".
	СтруктураПолей = Новый Структура();
	СтруктураПростыхПолей = Новый Структура;
	СтруктураСложныхПолей = Новый Структура; 		
	
	СтруктураПолей.Вставить("Контрагент",                        "Контрагент");
	СтруктураПолей.Вставить("ДоговорКонтрагента",                "ДоговорКонтрагента");
	СтруктураПолей.Вставить("Номенклатура",                      "Номенклатура");
	СтруктураПолей.Вставить("Содержание",                        "Содержание");
	СтруктураПолей.Вставить("Услуга",                            "Номенклатура.Услуга");
	СтруктураПолей.Вставить("БланкСтрогогоУчета",                "Номенклатура.БланкСтрогогоУчета");
	СтруктураПолей.Вставить("Количество",                        "Количество");
	СтруктураПолей.Вставить("Сумма",                             "Сумма");
	СтруктураПолей.Вставить("СтавкаНДС",                         "СтавкаНДС");
	СтруктураПолей.Вставить("НДС",                               "СуммаНДС");
	
	СтруктураПолей.Вставить("СхемаРеализации",                   "СхемаРеализации");
	СтруктураПолей.Вставить("СчетДоходовБУ",                     "СхемаРеализации.СчетДоходов");
	СтруктураПолей.Вставить("СубконтоДоходовБУ1",                "СхемаРеализации.СубконтоДоходов1");
	СтруктураПолей.Вставить("СубконтоДоходовБУ2",                "СхемаРеализации.СубконтоДоходов2");
	СтруктураПолей.Вставить("СубконтоДоходовБУ3",                "СхемаРеализации.СубконтоДоходов3");
	СтруктураПолей.Вставить("СчетРасходовБУ",                    "СхемаРеализации.СчетСебестоимости");
	СтруктураПолей.Вставить("СубконтоРасходовБУ1",               "СхемаРеализации.СубконтоСебестоимости1");
	СтруктураПолей.Вставить("СубконтоРасходовБУ2",               "СхемаРеализации.СубконтоСебестоимости2");
	СтруктураПолей.Вставить("СубконтоРасходовБУ3",               "СхемаРеализации.СубконтоСебестоимости3");
	СтруктураПолей.Вставить("НоменклатурнаяГруппа",              "Номенклатура.НоменклатурнаяГруппа");	
	СтруктураПолей.Вставить("СчетРасходовБУ",                    "СхемаРеализации.СчетСебестоимости"); 	
	
	СтруктураПолей.Вставить("НалоговоеНазначение",               "НалоговоеНазначение");
	СтруктураПолей.Вставить("ВидНалоговойДеятельности",          "НалоговоеНазначение.ВидНалоговойДеятельности");
	СтруктураПолей.Вставить("Амортизируется",                    "НалоговоеНазначение.Амортизируется");
	СтруктураПолей.Вставить("ВидДеятельностиНДС",                "НалоговоеНазначение.ВидДеятельностиНДС");
	СтруктураПолей.Вставить("НалоговоеНазначениеДоходовИЗатрат", "НалоговоеНазначениеДоходовИЗатрат");
	
	СтруктураПолей.Вставить("СчетУчетаНДС",                      "Ссылка.СчетУчетаНДС");
	
	СтруктураПолей.Вставить("ВедениеВзаиморасчетов",             "ДоговорКонтрагента.ВедениеВзаиморасчетов");
	СтруктураПолей.Вставить("ВалютаВзаиморасчетов" ,             "ДоговорКонтрагента.ВалютаВзаиморасчетов");
	СтруктураПолей.Вставить("ВедениеВзаиморасчетовНУ",           "ДоговорКонтрагента.ВедениеВзаиморасчетовНУ");
	СтруктураПолей.Вставить("СложныйНалоговыйУчет",              "ДоговорКонтрагента.СложныйНалоговыйУчет");
	СтруктураПолей.Вставить("ВидДоговора",                       "ДоговорКонтрагента.ВидДоговора");

	РезультатЗапросаПоУслугам = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Услуги", СтруктураПолей, СтруктураПростыхПолей, СтруктураСложныхПолей);

	// Подготовим таблицу услуг для проведения.
	ТаблицаПоУслугам = ПодготовитьТаблицуУслуг(РезультатЗапросаПоУслугам, СтруктураШапкиДокумента, ПогрешностиОкругления);
	
КонецПроцедуры

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Услуги",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуУслуг(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента, ПогрешностиОкругления)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();

	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		// для регламентного учета считаем НДС
		ТаблицаТоваров.ЗаполнитьЗначения(Перечисления.СтавкиНДС.БезНДС, "СтавкаНДС");
		ТаблицаТоваров.ЗаполнитьЗначения(0,                             "НДС");
	КонецЕсли;
	
	НалоговыйУчет.ДобавитьКолонкиТоваровРегл(ТаблицаТоваров, СтруктураШапкиДокумента, ПогрешностиОкругления, Ложь);

	Возврат ТаблицаТоваров;

КонецФункции 

// (*) Процедура выполняет движения по регистрам
//
// Данная процедура редактирована компанией ИН-АГРО. Внесены следующие изменения:
//	 Выполняется вызов процедуры ИНАГРО_РегистрацияРеализации для регистрации реализации услуг. 
// Далее по тексту процедуры внесенные изменения выделены комментариями "Начало/Конец: изменено компанией ИН-АГРО".
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ, Заголовок)
	
	ПроводкиБУ = Движения.Хозрасчетный;
	ДатаДока   = Дата;
	
	Комиссия = Ложь;
	
	// Проводки по реализации услуг
	Для каждого СтрокаТаблицы Из ТаблицаПоУслугам Цикл
		
		// Проводки по взаиморасчетам - авансы
		Если НЕ Комиссия Тогда
			
			ТаблицыДокумента = Новый Структура();
			ТаблицыДокумента.Вставить("ТаблицаПоУслугам",ТаблицаПоУслугам);
			
			ТаблицаАвансов = БухгалтерскийУчетРасчетовСКонтрагентами.ЗачетАванса(ЭтотОбъект, СтруктураШапкиДокумента , мВалютаРегламентированногоУчета, ТаблицыДокумента , Отказ, Заголовок, "АВ");
			
			КурсЗачетаАвансаРегл = ?(ТаблицаАвансов.Итог("СуммаВал") = 0, Неопределено, ТаблицаАвансов.Итог("Сумма") / ТаблицаАвансов.Итог("СуммаВал"));
			
		КонецЕсли; // Проводки по взаиморасчетам - авансы
		
		
		Если СтрокаТаблицы.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ИНАГРО_КоммунальныеУслуги Тогда 
			
			// Выручка
			Если СтрокаТаблицы.Сумма = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Проводка = ПроводкиБУ.Добавить();
			
			Проводка.Период          = Дата;
			Проводка.Активность      = Истина;
			Проводка.Организация     = СтруктураШапкиДокумента.Организация;
			Проводка.Сумма           = СтрокаТаблицы.ПроводкиСуммаСНДСРегл;
			Проводка.Содержание      = НСтр("ru='Оказание услуг';uk='Надання послуг'",Локализация.КодЯзыкаИнформационнойБазы());
			Проводка.НомерЖурнала    = "";
			
			Проводка.СчетДт          = СтруктураШапкиДокумента.СчетУчетаРасчетовСКонтрагентом;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", СтрокаТаблицы.Контрагент);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Договоры"   , СтрокаТаблицы.ДоговорКонтрагента);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт,  "ДокументыРасчетовСКонтрагентами", УправлениеВзаиморасчетами.ОпределитьДокументРасчетовСКонтрагентом(Ссылка));
			
			Проводка.ВалютаДт        = СтруктураШапкиДокумента.ВалютаДокумента;
			Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.ПроводкиСуммаСНДСВал;
			
			Проводка.СчетКт         = СтрокаТаблицы.СчетДоходовБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТаблицы.СубконтоДоходовБУ1);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаТаблицы.СубконтоДоходовБУ2);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, СтрокаТаблицы.СубконтоДоходовБУ3);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппа);
			
			Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
				Проводка.НалоговоеНазначениеКт  = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат; 
				Проводка.СуммаНУКт 				= НалоговыйУчет.УчестьСуммуАвансаДо01042011(СтруктураШапкиДокумента, СтрокаТаблицы.ПроводкиСуммаБезНДСРегл) + СтрокаТаблицы.ПроводкиСуммаНДСРегл;
			КонецЕсли;
			
			ИНАГРО_Общий.ИНАГРО_РегистрацияРеализации(СтрокаТаблицы, СтрокаТаблицы.Количество, СтрокаТаблицы.СуммаСНДСРегл, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Учет курсовых разниц
	Если (ВалютаДокумента <> мВалютаРегламентированногоУчета) Тогда
		БухгалтерскийУчетРед12.ПереоценкаСчетовДокументаРегл(ЭтотОбъект,СтруктураШапкиДокумента, мВалютаРегламентированногоУчета,Отказ,Заголовок);
	КонецЕсли;
	
	ТаблицаПоВторомуСобытиюНал = ДвиженияПоРегистрамНалоговогоУчета(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ);
	
	МасивДоговоров = ТаблицаПоУслугам.ВыгрузитьКолонку("ДоговорКонтрагента");
	// НДС 
	ПроводкиПоНДС(ПроводкиБУ, СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоВторомуСобытиюНал, Отказ);
	
	// Учет реализованных услуг
	ДвиженияПоРегиструРеализацияУслуг(СтруктураШапкиДокумента, ДатаДока, ТаблицаПоУслугам);
	
КонецПроцедуры 

Процедура ДвиженияПоРегиструРеализацияУслуг(СтруктураШапкиДокумента, ДатаДока, ТаблицаПоУслугам)
	
	Если НЕ СтруктураШапкиДокумента.РазрешитьУчетУслугБезПлановыхЦен Тогда
		Возврат;
	КонецЕсли;
	
	ТипСтатьяЗатрат = Тип("СправочникСсылка.СтатьиЗатрат"); 
	
	ДвиженияРеализацияУслуг = Движения["РеализацияУслуг"];
	
	Для Каждого СтрокаТаблицы Из ТаблицаПоУслугам Цикл
		
		СтрокаДвижения                       = ДвиженияРеализацияУслуг.Добавить();
		СтрокаДвижения.Период                = ДатаДока;
		СтрокаДвижения.Организация           = СтруктураШапкиДокумента.Организация;
		СтрокаДвижения.СчетРасходов          = СтрокаТаблицы.СчетРасходовБУ;
		СтрокаДвижения.НоменклатурнаяГруппа  = СтрокаТаблицы.НоменклатурнаяГруппа;
		
		ЕстьСтатьяЗатрат = Ложь;
		Для Счетчик = 1 По 3 Цикл
			Если ТипЗнч(СтрокаТаблицы["СубконтоРасходовБУ" + Счетчик]) = ТипСтатьяЗатрат Тогда
				ЕстьСтатьяЗатрат = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьСтатьяЗатрат = Истина Тогда
			СтрокаДвижения.СтатьяЗатрат = СтрокаТаблицы["СубконтоРасходовБУ" + Счетчик];
		КонецЕсли;
		
		СтрокаДвижения.Сумма                 = СтрокаТаблицы.СуммаБезНДСРегл;

		СтрокаДвижения.Сумма                 = СтрокаТаблицы.Сумма;
		СтрокаДвижения.Сумма                 = СтрокаТаблицы.СуммаБезНДСРегл;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроводкиПоНДС(ПроводкиБУ, СтруктураШапкиДокумента, ТаблицаПоУслугам, ТаблицаПоВторомуСобытиюНал, Отказ)
	
	Если СтруктураШапкиДокумента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
		// Это не наши ценности, следовательно НДС по ним учитывать не нужно
		Возврат;
	КонецЕсли;
	
	Если НЕ СтруктураШапкиДокумента.ЕстьНДС Тогда
		// Учет НДС не ведется
		Возврат;
	КонецЕсли;
	
	// Получим таблицу движений по счетам НДС
	
	// УСЛУГИ
	ТаблицаДвижений = ТаблицаПоУслугам.Скопировать();
	ТаблицаДвижений.Свернуть("Контрагент, ДоговорКонтрагента, СтавкаНДС, СчетДоходовБУ, СубконтоДоходовБУ1, СубконтоДоходовБУ2, СубконтоДоходовБУ3, НоменклатурнаяГруппа, СчетУчетаНДС, НалоговоеНазначениеДоходовИЗатрат","ПроводкиСуммаНДСРегл,ПроводкиСуммаНДСВал,ПроводкиСуммаНДСКурсНБУ");
	
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
			
			Если НЕ СтруктураШапкиДокумента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
				Проводка.СчетДт                     = СтрокаТаблицы.СчетДоходовБУ;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаТаблицы.СубконтоДоходовБУ1);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, СтрокаТаблицы.СубконтоДоходовБУ2);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, СтрокаТаблицы.СубконтоДоходовБУ3);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппа);
				
				Если СтруктураШапкиДокумента.ЕстьНалогНаПрибыльДо2015 Тогда
					Проводка.НалоговоеНазначениеДт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат; 
					Проводка.СуммаНУДт = СтрокаТаблицы.ПроводкиСуммаНДСРегл;
				КонецЕсли;
				
			Иначе	
				// С 2011 года согласно НК начисляются обязательства при поставке товаров по договорам комиссии.
				Проводка.СчетДт                     = СтруктураШапкиДокумента.СчетУчетаНДСПодтвержденный;
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", СтрокаТаблицы.Контрагент);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Договоры"   , СтрокаТаблицы.ДоговорКонтрагента);
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ДокументыРасчетовСКонтрагентами", НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка));
			КонецЕсли;
			
			Проводка.СчетКт                     = СтрокаТаблицы.СчетУчетаНДС;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Контрагент);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Договоры"   , ДоговорКонтрагента);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ДокументыРасчетовСКонтрагентами", НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка));
			
			НалоговыйУчет.РазбитьПроводкуПоНДСНаПервоеВтороеСобытие(ТаблицаПоВторомуСобытиюНал, ПроводкиБУ, Проводка, 
																	"Кт", СтруктураШапкиДокумента.СчетУчетаНДСПодтвержденный, 
																	СтруктураШапкиДокумента.ДоговорКонтрагента, 
																	НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента, Ссылка, Сделка), Сделка,
																	Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.Реализация,
																	СтрокаТаблицы.СтавкаНДС,	
																	,,,СтрокаТаблицы.ПроводкиСуммаНДСВал, СтрокаТаблицы.ПроводкиСуммаНДСКурсНБУ, КурсЗачетаАвансаРегл);
			
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДвиженияПоРегистрамНалоговогоУчета(СтруктураШапкиДокумента, ТаблицаПоУслугам, Отказ)
		
	ТаблицаПоВторомуСобытиюНал = НалоговыйУчет.СоздатьСтруктуруТаблицыНалоговыхСумм();
	
	Если Не СтруктураШапкиДокумента.ЕстьНДС Тогда
		Возврат ТаблицаПоВторомуСобытиюНал;
	КонецЕсли;
	
	// Отразим Продажи в регистре ПродажиНалоговыйУчет
	НаборДвижений = Движения.ПродажиНалоговыйУчет;
	
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	ТаблицаДвиженийТара = ТаблицаДвижений.Скопировать();
	
	// УСЛУГИ
	ТаблицаКопия = ТаблицаПоУслугам.Скопировать();
	ТаблицаКопия.Свернуть("ДоговорКонтрагента, СтавкаНДС","СуммаСНДСВал, СуммаНДСВал");
	ТаблицаПродаж = ТаблицаКопия.Скопировать();
		
	ТаблицаПродаж.Свернуть("ДоговорКонтрагента, СтавкаНДС","СуммаСНДСВал, СуммаНДСВал");
	ТаблицаПродаж.Колонки.СуммаСНДСВал.Имя = "СуммаВзаиморасчетов";
	ТаблицаПродаж.Колонки.СуммаНДСВал.Имя  = "СуммаНДС";
	
	ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПродаж, ТаблицаДвижений);
	ТаблицаДвижений.ЗаполнитьЗначения(Организация       , "Организация");
	ТаблицаДвижений.ЗаполнитьЗначения(ДоговорКонтрагента, "ДоговорКонтрагента");
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
			// Взаиморасчеты по договору по расчетным документам - необходимо заполнить в регистре реквизит РасчетныйДокумент.
			ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Сделка, "РасчетныйДокумент");
		КонецЕсли;			
		
	КонецЕсли;	
			
	Если НЕ Отказ И ТаблицаДвижений.Количество() > 0 Тогда
			
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
			
		Движения.ПродажиНалоговыйУчет.ВыполнитьПриход();
		Движения.ПродажиНалоговыйУчет.Записать();
			
	КонецЕсли;
	
	Если НЕ Отказ И ТаблицаДвиженийТара.Количество() > 0 Тогда
			
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвиженийТара;
			
		Движения.ПродажиНалоговыйУчет.ВыполнитьПриход();
		Движения.ПродажиНалоговыйУчет.Записать();
			
	КонецЕсли; 	
	
	// ОжидаемыйИПодтвержденныйНДСПродаж
	Если НЕ СтруктураШапкиДокумента.СложныйНалоговыйУчет Тогда
		
		// Движения формируются по данным рассчета "первого события" 
	   НалоговыйУчет.ДвиженияПоРегистрамНалоговогоУчетаУпрощенныйНалоговыйУчет(ЭтотОбъект, ТаблицаПоВторомуСобытиюНал);
	
	Иначе

		НаборДвижений = Движения.ОжидаемыйИПодтвержденныйНДСПродаж;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
		
		ТаблицаДвиженийТара = ТаблицаДвижений.Скопировать();
		
		// УСЛУГИ
		ТаблицаКопия = ТаблицаПоУслугам.Скопировать();
		ТаблицаКопия.Свернуть("ДоговорКонтрагента, СтавкаНДС","СуммаБезНДСВал,СуммаНДСВал");
		ТаблицаПродаж = ТаблицаКопия.Скопировать();
		
		ТаблицаПродаж.Колонки.СуммаБезНДСВал.Имя = "БазаНДС";
		ТаблицаПродаж.Колонки.СуммаНДСВал   .Имя = "СуммаНДС";
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПродаж, ТаблицаДвижений);
		ТаблицаДвижений.ЗаполнитьЗначения(Организация       , "Организация");
		ТаблицаДвижений.ЗаполнитьЗначения(ДоговорКонтрагента, "ДоговорКонтрагента");
		ТаблицаДвижений.ЗаполнитьЗначения(НалоговыйУчет.ОпределитьСделкуНалоговыйУчет(СтруктураШапкиДокумента,
																		СтруктураШапкиДокумента.Ссылка, 
																		СтруктураШапкиДокумента.Сделка),
										  								"Сделка");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СобытияОжидаемыйИПодтвержденныйНДСПродаж.Реализация, "СобытиеНДС");
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция готовит пакетный запрос для ОбработкиПроверкиЗаполнения.
//	Табличные части объекта (еще не сохраненного в информационной базе) выгружаются во временные таблицы,
//	соединяются с другими нужными талицами.
//
// Параметры:
//	СтруктураРезультатов - <Структура> - описание пакета запросов. 
//  Ключ - имя результата запроса, значение - индекс этого результата.
//
// Возвращает массив результатов запроса
Функция ПолучитьДанныеОбъектаДляПроверкиЗаполнения(СтруктураРезультатов, ЭтоКомиссия)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЭтоКомиссия",   ЭтоКомиссия);
	
	Запрос.Текст = "";
	
	Если Услуги.Количество() > 0 Тогда
		Запрос.УстановитьПараметр("ТаблицаУслуги", Услуги.Выгрузить());

		СтруктураРезультатов.Вставить("ТаблицаУслуги", СтруктураРезультатов.Количество());
		СтруктураРезультатов.Вставить("Услуги", СтруктураРезультатов.Количество());

		Запрос.Текст = Запрос.Текст + ?(ПустаяСтрока(Запрос.Текст), "", Символы.ПС + ";" + Символы.ПС) +
		"ВЫБРАТЬ
		|	ВремТаблица.НомерСтроки КАК НомерСтроки,
		|	ВремТаблица.Номенклатура КАК Номенклатура,
		|	ВремТаблица.Сумма КАК Сумма,
		|	ВремТаблица.СтавкаНДС КАК СтавкаНДС,
		|	ВремТаблица.СуммаНДС КАК СуммаНДС,
		|	ВремТаблица.СхемаРеализации КАК СхемаРеализации,
		|	ВремТаблица.НалоговоеНазначение КАК НалоговоеНазначение,
		|	ВремТаблица.НалоговоеНазначениеДоходовИЗатрат КАК НалоговоеНазначениеДоходовИЗатрат,
		|	ВремТаблица.Контрагент КАК Контрагент,
		|	ВремТаблица.ДоговорКонтрагента КАК ДоговорКонтрагента
		|ПОМЕСТИТЬ ТаблицаУслуги
		|ИЗ
		|	&ТаблицаУслуги КАК ВремТаблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТабицаДокумента.Номенклатура КАК Номенклатура,
		|	ТабицаДокумента.Сумма КАК Сумма,
		|	ТабицаДокумента.СтавкаНДС КАК СтавкаНДС,
		|	ТабицаДокумента.СуммаНДС КАК СуммаНДС,
		|	ТабицаДокумента.СхемаРеализации КАК СхемаРеализации,
		|	ТабицаДокумента.НалоговоеНазначение КАК НалоговоеНазначение,
		|	ТабицаДокумента.НалоговоеНазначениеДоходовИЗатрат КАК НалоговоеНазначениеДоходовИЗатрат,
		|	ТабицаДокумента.Контрагент КАК Контрагент,
		|	ТабицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента
		|ИЗ
		|	ТаблицаУслуги КАК ТабицаДокумента
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТабицаДокумента.НомерСтроки";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Возврат Запрос.ВыполнитьПакет();
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецЕсли