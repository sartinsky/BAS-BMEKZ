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

#Область ПодготовкаПараметровПроведенияДокумента

Функция ПодготовитьПараметрыПроведения(Ссылка, Отказ) Экспорт 
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация
	|ИЗ
	|	Документ.ОтражениеЗарплатыВУчете КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, Ссылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	МассивСчетовУчетаЗарплаты = Новый Массив;
	МассивСчетовУчетаЗарплаты.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоЗаработнойПлате);
	МассивСчетовУчетаЗарплаты.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДепонентам);
	МассивСчетовУчетаЗарплаты.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДругимВыплатам);
	
	Запрос.УстановитьПараметр("СводныйУчетРасчетов", БухгалтерскийУчетПереопределяемый.ВедетсяУчетРасчетовПоЗарплатеСводно());
	Запрос.УстановитьПараметр("МассивСчетовУчетаЗарплаты", МассивСчетовУчетаЗарплаты);	
	
	НомераТаблиц = Новый Структура();
	   	
	Запрос.Текст = ТекстЗапросаРеквизиты(НомераТаблиц)
		+ ТекстЗапросаОтражениеВУчете(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для Каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаРеквизиты(НомераТаблиц)
	
	НомераТаблиц.Вставить("ТаблицаРеквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПериодРегистрации
	|ИЗ
	|	Документ.ОтражениеЗарплатыВУчете КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаОтражениеВУчете(НомераТаблиц)
	НомераТаблиц.Вставить("ТаблицаОтраженияВУчете",   НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОтражениеВУчете.Ссылка,
	|	ОтражениеВУчете.СчетДт,
	|	ОтражениеВУчете.СубконтоДт1,
	|	ОтражениеВУчете.СубконтоДт2,
	|	ОтражениеВУчете.СубконтоДт3,
	|	ОтражениеВУчете.СчетКт,
	|	ОтражениеВУчете.СубконтоКт1,
	|	ОтражениеВУчете.СубконтоКт2,
	|	ОтражениеВУчете.СубконтоКт3,
	|	ОтражениеВУчете.Сумма,
	|	ОтражениеВУчете.НалоговоеНазначениеДоходовИЗатрат,
	|	ОтражениеВУчете.НалоговоеНазначение,
	|	ОтражениеВУчете.НеОтражатьВБУ
	|ИЗ
	|	Документ.ОтражениеЗарплатыВУчете.ОтражениеВУчете КАК ОтражениеВУчете
	|ГДЕ
	|	ОтражениеВУчете.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли