
Процедура ПередУдалением(Отказ)
	//Отказ = Не МонопольныйРежим();
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Настроено = Ложь;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если не ЗначениеЗаполнено(ТипХранилища) Тогда
		ТипХранилища = Перечисления.скEDI_ТипыВнешнихХранилищСодержимогоЭлектронныхДокументов.MSSQLServer;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = ТипХранилища;
	КонецЕсли;
КонецПроцедуры
