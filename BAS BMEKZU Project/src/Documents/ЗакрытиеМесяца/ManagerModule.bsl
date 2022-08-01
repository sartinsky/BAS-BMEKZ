#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "СправкаРасчетСебестоимостиПродукцииИУслуг";
	КомандаПечати.Представление  = НСтр("ru='Справка-расчет ""Себестоимость продукции и услуг""';uk='Довідка-розрахунок ""Собівартість продукції й послуг""'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Справка-расчет ""Себестоимость продукции и услуг""';uk='Довідка-розрахунок ""Собівартість продукції й послуг""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиСправкиРасчета";
	КомандаПечати.СписокФорм     = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "СправкаРасчетКалькуляцияСебестоимости";
	КомандаПечати.Представление  = НСтр("ru='Справка-расчет ""Калькуляция себестоимости""';uk='Довідка-розрахунок ""Калькуляція собівартості""'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Справка-расчет ""Калькуляция себестоимости""';uk='Довідка-розрахунок ""Калькуляція собівартості""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиСправкиРасчета";
	КомандаПечати.СписокФорм     = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "СправкаРасчетРаспределенияКосвенныхРасходов";
	КомандаПечати.Представление  = НСтр("ru='Справка-расчет ""Распределения косвенных расходов""';uk='Довідка-розрахунок ""Розподілення непрямих витрат""'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Справка-расчет ""Распределения косвенных расходов""';uk='Довідка-розрахунок ""Розподілення непрямих витрат""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиСправкиРасчета";
	КомандаПечати.СписокФорм     = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "СправкаРасчетСписаниеРБП";
	КомандаПечати.Представление  = НСтр("ru='Справка-расчет ""Списание РБП""';uk='Довідка-розрахунок ""Списання ВМП""'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Справка-расчет ""Списание РБП""';uk='Довідка-розрахунок ""Списання ВМП""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиСправкиРасчета";
	КомандаПечати.СписокФорм     = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "СправкаРасчетПереоценкаВалютныхСредств";
	КомандаПечати.Представление  = НСтр("ru='Справка-расчет ""Переоценка валютных средств""';uk='Довідка-розрахунок ""Переоцінка валютних коштів""'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Справка-расчет ""Переоценка валютных средств""';uk='Довідка-розрахунок ""Переоцінка валютних коштів""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиСправкиРасчета";
	КомандаПечати.СписокФорм     = "ФормаСписка,ФормаВыбора,ФормаДокумента";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Реестр документов ""Закрытие месяца""';uk='Реєстр документів ""Закриття місяця""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли