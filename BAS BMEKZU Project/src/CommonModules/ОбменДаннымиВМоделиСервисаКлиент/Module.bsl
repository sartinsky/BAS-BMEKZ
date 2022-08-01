////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными в модели сервиса".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик запуска клиентского сеанса приложения.
// Если запущен сеанс для автономного рабочего места, то выводит пользователю оповещение
// о необходимости выполнить синхронизацию данных с приложением в Интернете
// (если установлен соответствующий признак).
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.ЭтоАвтономноеРабочееМесто Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса";
		Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
			ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
		КонецЕсли;
		
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса"] =
			ПараметрыРаботыКлиента.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботы;
		
		Если ПараметрыРаботыКлиента.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботы Тогда
			
			ПоказатьОповещениеПользователя(НСтр("ru='Автономная работа';uk='Автономна робота'"), "e1cib/app/Обработка.ВыполнениеОбменаДанными",
				НСтр("ru='Рекомендуется синхронизировать данные с приложением в Интернете.';uk='Рекомендується синхронізувати дані з прикладною програмою в Інтернеті.'"), БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Отказ - Булево - Признак отказа от выхода из программы. Если в теле процедуры-обработчика установить
//                   данному параметру значение Истина, то работа с программой не будет завершена.
//  Предупреждения - Массив - в массив можно добавить элементы типа Структура,
//                            свойства которой см. в СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	ПараметрыАвтономнойРаботы = СтандартныеПодсистемыКлиент.ПараметрКлиента("ПараметрыАвтономнойРаботы");
	
	Если ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса"] = Истина
		И ПараметрыАвтономнойРаботы.СинхронизацияССервисомДавноНеВыполнялась Тогда
		
		ПараметрыПредупреждения = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
		ПараметрыПредупреждения.РасширеннаяПодсказка = НСтр("ru='В некоторых случаях синхронизация данных может занять длительное время:
            | - медленный канал связи;
            | - большой объем данных;
            | - доступно обновление приложения в Интернете.'
            |;uk='У деяких випадках синхронізація даних може забрати тривалий час:
            | - повільний канал зв''язку;
            | - великий обсяг даних;
            | - доступне оновлення додатка в Інтернеті.'");

		ПараметрыПредупреждения.ТекстПредупреждения = НСтр("ru='Не выполнена синхронизация данных с приложением в Интернете.';uk='Не виконана синхронізація даних з додатком в Інтернеті.'");
		ПараметрыПредупреждения.ТекстФлажка = НСтр("ru='Синхронизировать данные с приложением в Интернете';uk='Синхронізувати дані з прикладною програмою в Інтернеті'");
		ПараметрыПредупреждения.Приоритет = 80;
		
		ДействиеПриУстановленномФлажке = ПараметрыПредупреждения.ДействиеПриУстановленномФлажке;
		ДействиеПриУстановленномФлажке.Форма = "Обработка.ВыполнениеОбменаДанными.Форма.Форма";
		
		ПараметрыФормы = ПараметрыАвтономнойРаботы.ПараметрыФормыВыполненияОбменаДанными;
		ПараметрыФормы = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ПараметрыФормы);
		ПараметрыФормы.Вставить("ЗавершениеРаботыСистемы", Истина);
		ДействиеПриУстановленномФлажке.ПараметрыФормы = ПараметрыФормы;
		
		Предупреждения.Добавить(ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
