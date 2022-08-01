
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаСервере
Процедура ЗаписатьПараметры(Отказ)
	
	Если ТолькоПросмотр Тогда
		Отказ = Истина;
		Возврат;		
	КонецЕсли;
	
	НеУдалосьЗаписать = Ложь;
	
	Если Вид = "Должности" Тогда
			
		Для Каждого СтрокаТаблицы ИЗ Шахтеры Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Ссылка) Тогда 
				Продолжить;
			КонецЕсли;			
			
			ДолжностьОбъект = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			
			Попытка
				
				Если НЕ ДолжностьОбъект.ЯвляетсяШахтерскойДолжностью Тогда
					ДолжностьОбъект.Заблокировать();
					ДолжностьОбъект.ЯвляетсяШахтерскойДолжностью = Истина;
					ДолжностьОбъект.Записать();
				КонецЕсли;
				
				ПараметрыОтбора = Новый Структура("Ссылка", СтрокаТаблицы.Ссылка);
				МассивДолжностей = ШахтерыПрежняя.НайтиСтроки(ПараметрыОтбора);				
				Для Каждого СтрокаМассива ИЗ МассивДолжностей Цикл					
					ШахтерыПрежняя.Удалить(СтрокаМассива);
				КонецЦикла;				
				
			Исключение
				ТекстСообщения = НСтр("ru='Не удалось заблокировать объект: ';uk=""Не вдалося заблокувати об'єкт: """) + ДолжностьОбъект + Символы.ПС + НСтр("ru='Запись данных о должности не выполнена.';uk='Запис даних про посади не виконаний.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				НеУдалосьЗаписать = Истина;
				Продолжить;		
			КонецПопытки;	
			
		КонецЦикла;	
		
		Для Каждого СтрокаТаблицы ИЗ ШахтерыПрежняя Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Ссылка) Тогда 
				Продолжить;
			КонецЕсли;			
			
			ДолжностьОбъект = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			
			Попытка
				
				ДолжностьОбъект.Заблокировать();
				ДолжностьОбъект.ЯвляетсяШахтерскойДолжностью = Ложь;
				ДолжностьОбъект.Записать();
								
			Исключение
				ТекстСообщения = НСтр("ru='Не удалось заблокировать объект: ';uk=""Не вдалося заблокувати об'єкт: """) + ДолжностьОбъект + Символы.ПС + НСтр("ru='Запись данных о должности не выполнена.';uk='Запис даних про посади не виконаний.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				НеУдалосьЗаписать = Истина;
				Продолжить;		
			КонецПопытки;	
			
		КонецЦикла;
		
		
	Иначе
		Возврат;		
	КонецЕсли;
	
	Модифицированность =  НеУдалосьЗаписать;
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьДолжности(Форма, ПараметрыДолжностей)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Должности.Ссылка,
	|	Должности.ЯвляетсяШахтерскойДолжностью
	|ИЗ
	|	Справочник.Должности КАК Должности
	|ГДЕ
	|	(Должности.ЯвляетсяШахтерскойДолжностью = &ЯвляетсяШахтерскойДолжностью)";
	
	Запрос.УстановитьПараметр("ЯвляетсяШахтерскойДолжностью",ПараметрыДолжностей.ИспользуетсяТрудШахтеров);
	
	Результат = Запрос.Выполнить().Выгрузить();

	Если ПараметрыДолжностей.ИспользуетсяТрудШахтеров Тогда
		
		ПараметрыОтбора = Новый Структура("ЯвляетсяШахтерскойДолжностью", Истина);
		МассивДолжностей = Результат.НайтиСтроки(ПараметрыОтбора);
		Если МассивДолжностей.Количество() <> 0 Тогда
			ТаблицаДолжностей = Результат.Скопировать(МассивДолжностей,"Ссылка");
		Иначе
			ТаблицаДолжностей = Результат.СкопироватьКолонки("Ссылка");
		КонецЕсли;
		
		ЗначениеВДанныеФормы(ТаблицаДолжностей, Форма.Шахтеры);
		ЗначениеВДанныеФормы(ТаблицаДолжностей, Форма.ШахтерыПрежняя);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ
//

&НаКлиенте
Процедура Записать(Команда)
	
	Отказ = Ложь;
	ЗаписатьПараметры(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	ЗаписатьПараметры(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Вид") Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		Вид = Параметры.Вид;
		Если Вид = "НДФЛ" Тогда
			Элементы.ГруппаЗаписать.Видимость = Ложь;
			Элементы.ГруппаДополнительныхДанных.ТекущаяСтраница = Элементы.ГруппаНДФЛ;
			ЭтаФорма.Заголовок = НСтр("ru='Дополнительные настройки НДФЛ';uk='Додаткові настройки ПДФО'");
		ИначеЕсли Вид = "СтраховыеВзносы" Тогда
			Элементы.ГруппаЗаписать.Видимость = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru='Дополнительные настройки страховых взносов';uk='Додаткові настройки страхових внесків'");
			Элементы.ГруппаДополнительныхДанных.ТекущаяСтраница = Элементы.ГруппаСтраховыеВзносы;
		ИначеЕсли Вид = "Нормативные" Тогда
			Элементы.ГруппаЗаписать.Видимость = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru='Нормативные величины для расчета зарплаты';uk='Нормативні величини для розрахунку зарплати'");
			Элементы.ГруппаДополнительныхДанных.ТекущаяСтраница = Элементы.ГруппаНормативныеВеличины;
		ИначеЕсли Вид = "Отражение" Тогда
			Элементы.ГруппаЗаписать.Видимость = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru='Дополнительные настройки отражения в учете';uk='Додаткові настройки відображення в обліку'");
			Элементы.ГруппаДополнительныхДанных.ТекущаяСтраница = Элементы.ГруппаОтражение;
		ИначеЕсли Вид = "Должности" Тогда			
			ЭтаФорма.Заголовок = НСтр("ru='Льготные категории должностей';uk='Пільгові категорії посад'");
			Элементы.ГруппаДополнительныхДанных.ТекущаяСтраница = Элементы.ГруппаДолжности;
			
			ПараметрыДолжностей = Параметры.ПараметрыДолжностей;
			Элементы.ГруппаШахтеры.Видимость       = ПараметрыДолжностей.ИспользуетсяТрудШахтеров;
			ПолучитьДолжности(ЭтаФорма, ПараметрыДолжностей);
		Иначе
			Отказ = Истина;
			Возврат;
		КонецЕсли
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", ЭтаФорма);
		ДополнительныеПараметры.Вставить("Отказ", Отказ);
	
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'");		
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемПродолжение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru='Конфигурация BAS';uk='Конфігурація BAS'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ЗаписатьПараметры(ДополнительныеПараметры.Отказ);
	
КонецПроцедуры


