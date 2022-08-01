#Область СлужебныйПрограммныйИнтерфейс

// Выполняет отправку и получение сообщений системы.
// 
Процедура ОтправитьИПолучитьСообщения() Экспорт
	
	Отказ = Ложь;
	
	ОбменСообщениямиВызовСервера.ОтправитьИПолучитьСообщения(Отказ);
	
	Если Отказ Тогда
		
		ПоказатьОповещениеПользователя(НСтр("ru='Возникли ошибки при отправке и получении сообщений.';uk='Виникли помилки при відправці та отриманні повідомлень.'"),,
				НСтр("ru='Используйте журнал регистрации для диагностики ошибок.';uk='Використовуйте журнал реєстрації для діагностики помилок.'"), БиблиотекаКартинок.Ошибка32);
		
	Иначе
		
		ПоказатьОповещениеПользователя(НСтр("ru='Отправка и получение сообщений успешно завершены.';uk='Відправка і отримання повідомлень успішно завершені.'"),,, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	Оповестить(ИмяСобытияВыполненаОтправкаИПолучениеСообщений());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
//
// Возвращаемое значение:
// Строка. 
//
Функция ИмяСобытияДобавленаКонечнаяТочка() Экспорт
	
	Возврат "ОбменСообщениями.ДобавленаКонечнаяТочка";
	
КонецФункции

// Только для внутреннего использования.
//
// Возвращаемое значение:
// Строка. 
//
Функция ИмяСобытияВыполненаОтправкаИПолучениеСообщений() Экспорт
	
	Возврат "ОбменСообщениями.ВыполненаОтправкаИПолучение";
	
КонецФункции

// Только для внутреннего использования.
//
// Возвращаемое значение:
// Строка. 
//
Функция ИмяСобытияЗакрытаФормаКонечнойТочки() Экспорт
	
	Возврат "ОбменСообщениями.ЗакрытаФормаКонечнойТочки";
	
КонецФункции

// Только для внутреннего использования.
//
// Возвращаемое значение:
// Строка. 
//
Функция ИмяСобытияУстановленаВедущаяКонечнаяТочка() Экспорт
	
	Возврат "ОбменСообщениями.УстановленаВедущаяКонечнаяТочка";
	
КонецФункции

#КонецОбласти
