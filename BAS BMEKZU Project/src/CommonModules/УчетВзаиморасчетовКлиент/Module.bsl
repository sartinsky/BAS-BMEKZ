///////////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции диалогов расчетных документов

Процедура ВыборРасчетногоДокумента(СтруктураПараметров,Элемент,ТипыДокументов) Экспорт

	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("Организация",СтруктураПараметров.Организация);
	ПараметрыОбъекта.Вставить("Контрагент",СтруктураПараметров.Контрагент);
	ПараметрыОбъекта.Вставить("ДоговорКонтрагента",СтруктураПараметров.ДоговорКонтрагента);
	ПараметрыОбъекта.Вставить("Счет",СтруктураПараметров.СчетДляОпределенияОстатков);
	ПараметрыОбъекта.Вставить("ОстаткиОбороты",?(СтруктураПараметров.СторонаСчета = "Дт", 0, 1));
	Если СтруктураПараметров.Свойство("РежимОтбораДокументов") Тогда 
		ПараметрыОбъекта.Вставить("РежимОтбораДокументов",СтруктураПараметров.РежимОтбораДокументов);
	КонецЕсли;
	ПараметрыОбъекта.Вставить("РежимВыбора",Истина);
	ПараметрыОбъекта.Вставить("мТипыДокументов",ТипыДокументов);

	Если СтруктураПараметров.Свойство("ЭтоНовыйДокумент") и СтруктураПараметров.ЭтоНовыйДокумент Тогда 
		ПараметрыОбъекта.Вставить("КонПериода",КонецДня(ТекущаяДата()));
	Иначе
		ПараметрыОбъекта.Вставить("КонПериода",СтруктураПараметров.КонецПериода);
	КонецЕсли;
	
	Если СтруктураПараметров.Свойство("НачалоПериода") Тогда
		ПараметрыОбъекта.Вставить("НачПериода",СтруктураПараметров.НачалоПериода);
		ПараметрыОбъекта.Вставить("мПереданИнтервал",Истина);
	Иначе
		ПараметрыОбъекта.Вставить("мПереданИнтервал",Ложь);
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыОбъекта", ПараметрыОбъекта);

	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент, Истина);

КонецПроцедуры

