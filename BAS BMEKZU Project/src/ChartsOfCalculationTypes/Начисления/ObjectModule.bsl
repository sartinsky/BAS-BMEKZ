#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Если КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Индексация Тогда
	//	РасчетЗарплаты.ПроверитьУникальностьНачисленияПоКатегории(Ссылка, КатегорияНачисленияИлиНеоплаченногоВремени, Отказ);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) И Не ДополнительныеСвойства.Свойство("ИзменениеПланаВидовРасчетаПоНастройкам") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОчередностьРасчета();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьОчередностьРасчета()
	
	ОчередностьРасчета = 0;
	Для Каждого Ведущий из ВедущиеВидыРасчета Цикл
		Если ОчередностьРасчета < (Ведущий.ВидРасчета.ОчередностьРасчета + 1) Тогда
			 ОчередностьРасчета = Ведущий.ВидРасчета.ОчередностьРасчета + 1;
		КонецЕсли;	 
	КонецЦикла;	
	
КонецПроцедуры

#КонецЕсли