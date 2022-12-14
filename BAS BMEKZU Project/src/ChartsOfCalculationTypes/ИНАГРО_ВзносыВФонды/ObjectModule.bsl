#Область СлужебныеПроцедурыИФункции

// Проверяет правильность заполнения реквизитов вида расчета 
// для некуоторых случаев выдает сообщение об бошибке
// для некоторых - возвращает текст сообщения
// 	Параметры:
//		ВидРасчета - объект Вид расчета
//		Отказ - признак отказа (проверка не прошла)
//	Возвращаемое значение:
//		ТекстСообщения - текст сообщения о результате проверки.
Функция ПроверитьНастройкуВидаРасчетаВзносы(ВидРасчета, Отказ) Экспорт
	
	МетаданныеВидаРасчета = ВидРасчета.Метаданные();
	
	Если НЕ ЗначениеЗаполнено(ВидРасчета.Наименование) Тогда
		ТекстСообщения = НСтр("ru='Необходимо задать имя расчета!';uk=""Необхідно задати ім'я розрахунку!""");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ВидРасчета.Код) Тогда
		ТекстСообщения = НСтр("ru='Необходимо задать код расчета!';uk='Необхідно задати код розрахунку!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат "";
	КонецЕсли; 
	
КонецФункции

#КонецОбласти