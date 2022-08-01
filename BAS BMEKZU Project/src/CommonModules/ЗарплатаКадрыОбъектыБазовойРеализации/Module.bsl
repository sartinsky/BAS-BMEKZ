////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы объектов подсистемы ОбъектыБазовойРеализации.
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.1.70";
	Обработчик.Процедура = "ЗарплатаКадрыОбъектыБазовойРеализации.Обновление20170";
	Обработчик.Опциональный = Ложь;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.1.76";
	Обработчик.Процедура = "ЗарплатаКадрыОбъектыБазовойРеализации.Обновление20176";
	Обработчик.Опциональный = Ложь;
	Обработчик.НачальноеЗаполнение = Истина;
	
	
КонецПроцедуры

Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВедомостьНаВыплатуЗарплаты",	"ПериодРегистрации",	"Зарплата",	"Организация");
	
КонецПроцедуры

Процедура Обновление20170() Экспорт
	
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ИндексИнфляции");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПределыСтраховыхВзносов");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "МинимальнаяОплатаТруда");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПрожиточныеМинимумы");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "РазмерыЛьготНДФЛ");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "СтавкиНДФЛ");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ШкалаСтавокНалогов");
	
КонецПроцедуры

Процедура Обновление20176() Экспорт
	
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("Справочник", "Налоги");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("Справочник", "КатегорииЗастрахованныхЛицЕСВ");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("Справочник", "СтатьиНалоговыхДеклараций");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ИндексИнфляции");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПределыСтраховыхВзносов");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "МинимальнаяОплатаТруда");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПрожиточныеМинимумы");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ШкалаСтавокНалогов");
	Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект("РегистрСведений", "ПараметрыКатегорийЕСВ");
	
КонецПроцедуры
