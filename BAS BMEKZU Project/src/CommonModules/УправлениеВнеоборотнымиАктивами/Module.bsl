

// ПРОЧИЕ

// Позволяет определить есть ли в табличной части документа строки с дублирующимеся
// значениями заданных реквизитов (всех одновременно).
// При нахождении дублей формирует сообщения пользователю.
//
// Параметры
//  Объект            - Объект ссылочного типа
//  ИмяТабличнойЧасти - Имя табличной части, в которой нужно искать дубли
//  ПоляПроверки      - Структура с перечнем реквизитов, по которым нужно искать дубли.
//                      Ключ структуры - имя реквизита, значение - признак необходимости
//                      поиска дублей в том числе по пустым значениям. Истина - искать
//                      дубли по пустым значениям реквизита, любое другое значение - 
//                      игнорировать строки, в которых реквизит не заполнен
//  Отказ             - Признак отказа от дальнейшей обработки. В случае нахождения дублей
//                      выставляется в Истина.
//
// Возвращаемое значение:
//   Булево - Истина - ошибок (дублей) не обнаружено, Ложь - в противном случае.
//
Функция ПроверитьОтсутствиеДублейВТабличнойЧасти(Объект, ИмяТабличнойЧасти, ПоляПроверки, Отказ) Экспорт
	
	СтруктураОтбора = Новый Структура;
	
	ПоляПроверкиСтрокой = "";
	Для Каждого КлючИЗначение Из ПоляПроверки Цикл
		ПоляПроверкиСтрокой = ПоляПроверкиСтрокой + ", " + КлючИЗначение.Ключ;
		СтруктураОтбора.Вставить(КлючИЗначение.Ключ);
	КонецЦикла;
	ПоляПроверкиСтрокой = Сред(ПоляПроверкиСтрокой, 3);
	
	НаборыЗначений = Объект[ИмяТабличнойЧасти].Выгрузить(, ПоляПроверкиСтрокой);
	НаборыЗначений.Колонки.Добавить("__КоличествоВхождений", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповЧисла(10));
	НаборыЗначений.ЗаполнитьЗначения(1, "__КоличествоВхождений");
	НаборыЗначений.Свернуть(ПоляПроверкиСтрокой, "__КоличествоВхождений");
	
	НайденыДубли = Ложь;
	
	Если ПоляПроверки.Количество() > 1 Тогда
		ШаблонСообщенияОбОшибке = НСтр("ru='Значения %1 повторяются в строках %2.';uk='Значення %1 повторюються в рядках %2.'");
	Иначе
		ШаблонСообщенияОбОшибке = НСтр("ru='Значение %1 повторяется в строках %2.';uk='Значення %1 повторюється у рядках %2.'");
	КонецЕсли;
	ТекстСообщения = "";
	
	Если НаборыЗначений.Количество() <> Объект[ИмяТабличнойЧасти].Количество() Тогда
		// Есть дубли
		Для Каждого НаборЗначений Из НаборыЗначений Цикл
			Если НаборЗначений.__КоличествоВхождений = 1 Тогда
				Продолжить;
			КонецЕсли;
			
			ЗначенияСтрокой = "";
			
			ПропуститьНаборЗначений = Ложь;
			Для Каждого КлючИЗначение Из ПоляПроверки Цикл
				Если КлючИЗначение.Значение <> Истина Тогда
					Если НЕ ЗначениеЗаполнено(НаборЗначений[КлючИЗначение.Ключ]) Тогда
						ПропуститьНаборЗначений = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
				
				ЗначенияСтрокой = ЗначенияСтрокой + ", """ + НаборЗначений[КлючИЗначение.Ключ] + """";
			КонецЦикла;
			Если ПропуститьНаборЗначений Тогда
				Продолжить;
			КонецЕсли;
			
			НайденыДубли = Истина;
			
			ЗначенияСтрокой = Сред(ЗначенияСтрокой, 3);
			
			НомераСтрок = "";
			ЗаполнитьЗначенияСвойств(СтруктураОтбора, НаборЗначений);
			СтрокиДубли = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
			Для Каждого СтрокаДубль Из СтрокиДубли Цикл
				НомераСтрок = НомераСтрок + ", " + Формат(СтрокаДубль.НомерСтроки, "ЧГ=");
			КонецЦикла;
			НомераСтрок = Сред(НомераСтрок, 3);
			
			ТекстСообщения = ТекстСообщения + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщенияОбОшибке, ЗначенияСтрокой, НомераСтрок);
		КонецЦикла;
	КонецЕсли;
	
	Если НайденыДубли Тогда
		ПредставленияРеквизитов = "";
		МетаданныеТабличнойЧасти = Объект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти];
		Для Каждого КлючИЗначение Из ПоляПроверки Цикл
			ПредставленияРеквизитов = ПредставленияРеквизитов + ", """
				+ МетаданныеТабличнойЧасти.Реквизиты[КлючИЗначение.Ключ].Представление() + """";
		КонецЦикла;
		ПредставленияРеквизитов = Сред(ПредставленияРеквизитов, 3);
		
		Если ПоляПроверки.Количество() > 1 Тогда
			ШаблонСообщения = НСтр("ru='Значения в колонках %1 не должны повторяться.';uk='Значення у колонках %1 не повинні повторюватися.'");
		Иначе
			ШаблонСообщения = НСтр("ru='Значения в колонке %1 не должны повторяться.';uk='Значення у колонці %1 не повинні повторюватися.'");
		КонецЕсли;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПредставленияРеквизитов)
			+ ТекстСообщения;
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("СПИСОК", "КОРРЕКТНОСТЬ", , ,
			МетаданныеТабличнойЧасти.Представление(), ТекстСообщения);
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект, ИмяТабличнойЧасти);
		
		Отказ = Истина;
	КонецЕсли;
	
	Возврат НЕ НайденыДубли;
	
КонецФункции // ПроверитьОтсутствиеДублейВТабличнойЧасти()


