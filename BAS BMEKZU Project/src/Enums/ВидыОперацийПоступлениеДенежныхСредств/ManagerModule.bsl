#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора         = ПолучитьДоступныеЗначения(Параметры.Отбор, Параметры.СтрокаПоиска).ДоступныеЗначения;
	
КонецПроцедуры

#КонецОбласти 

#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокДоступныхЗначений(Отбор, ЕстьНедоступные = Ложь) Экспорт
	
	СтруктураДоступныхЗначений = ПолучитьДоступныеЗначения(Отбор, Неопределено);
	
	ЕстьНедоступные = СтруктураДоступныхЗначений.ЕстьНедоступные;
	
	Возврат СтруктураДоступныхЗначений.ДоступныеЗначения;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Функция выполняет заполнение списка значений 
// данных выбора с учетом настроек параметров учета.
// Поддерживается параметр отбора.
// Обрабатывается также строка поиска.
//
Функция ПолучитьДоступныеЗначения(Отбор, СтрокаПоиска)
	
	Исключения = Новый Массив;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПокупкаПродажаВалюты);
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВедетсяРозничнаяТорговля") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам);
	КонецЕсли;
	
	ДоступныеЗначения = Новый СписокЗначений;
	ЕстьНедоступные   = Ложь;
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ЗначенияПеречисления Цикл
		
		Если ТипЗнч(СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(СтрокаПоиска)
			И Найти(НРег(ЗначениеПеречисления.Синоним), НРег(СтрокаПоиска)) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		Ссылка = Перечисления.ВидыОперацийПоступлениеДенежныхСредств[ЗначениеПеречисления.Имя];
		Если ТипЗнч(Отбор) = Тип("ПеречислениеСсылка.ВидыОперацийПоступлениеДенежныхСредств")
			И Отбор <> Ссылка Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ФиксированныйМассив")
			И Отбор.Найти(Ссылка) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Исключения.Найти(Ссылка) <> Неопределено Тогда
			ЕстьНедоступные = Истина;
			Продолжить;
		КонецЕсли;
		ДоступныеЗначения.Добавить(Ссылка, ЗначениеПеречисления.Синоним);
		
	КонецЦикла;
	
	Возврат Новый Структура("ДоступныеЗначения,ЕстьНедоступные", ДоступныеЗначения, ЕстьНедоступные);
	
КонецФункции

#КонецОбласти 

#КонецЕсли