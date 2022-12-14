
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПодборУдержаний = Параметры.ПодборУдержаний;
	ПодборНалогов = Параметры.ПодборНалогов;
	ПодборСредних = Параметры.ПодборСредних;
	
	Отбор = Неопределено;
	Если Не Параметры.Свойство("УсловияОтбора", Отбор) Тогда 
		Отбор = Новый Массив;
	КонецЕсли;	
	
	Если ПодборУдержаний Тогда 
		Элементы.СтраницыВидыРасчета.ТекущаяСтраница = Элементы.СтраницаУдержания; 
		Заголовок = НСтр("ru = 'Подбор удержаний';uk = 'Підбір утримань'");	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПоказыватьВидыРасчетаВАрхиве", 
			"Заголовок", НСтр("ru = 'Отображать в списке удержания, которые больше не используются';uk = 'Відображати утримання, які більше не використовуються'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВыбранныеВидыРасчета", 
			"Заголовок", НСтр("ru = 'Выбранные удержания';uk = 'Вибрані утримання'"));
		ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(ЭтотОбъект, "ПоказыватьВидыРасчетаВАрхиве",
			НСтр("ru = 'Установите флажок для того чтобы отобразить в списке все удержания, в т. ч. те, которые использовались ранее.';uk = 'Установіть прапорець для того, щоб відобразити в списку всі утримання, у т. ч. ті, які використовувалися раніше.'"));
	ИначеЕсли ПодборНалогов Тогда
		Элементы.СтраницыВидыРасчета.ТекущаяСтраница = Элементы.СтраницаНалоги; 
		Заголовок = НСтр("ru = 'Подбор налогов';uk = 'Підбір податків'");
		//Элементы.ПоказыватьВидыРасчетаВАрхиве.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВыбранныеВидыРасчета", 
			"Заголовок", НСтр("ru = 'Выбранные налоги';uk = 'Вибрані податки'"));
	ИначеЕсли ПодборСредних Тогда
		Элементы.СтраницыВидыРасчета.ТекущаяСтраница = Элементы.СтраницаСредние; 
		Заголовок = НСтр("ru = 'Подбор видов средней';uk = 'Підбір видів середньої'");
		//Элементы.ПоказыватьВидыРасчетаВАрхиве.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВыбранныеВидыРасчета", 
			"Заголовок", НСтр("ru = 'Выбранные виды средней';uk = 'Вибрані види середньої'"));
			
	Иначе
		Элементы.СтраницыВидыРасчета.ТекущаяСтраница = Элементы.СтраницаНачисления; 
		Заголовок = НСтр("ru = 'Подбор начислений';uk = 'Підбір нарахувань'");
	КонецЕсли;
	
	ЗаполнитьВидыРасчета(Параметры.МассивВидовРасчета, Отбор);
	
	УстановитьПараметрыСписков();
	УстановитьОтборСписков(Отбор);
	УстановитьОтборИспользуемых(ЭтотОбъект, ПоказыватьВидыРасчетаВАрхиве);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьВидыРасчетаВАрхивеПриИзменении(Элемент)
	
	УстановитьОтборИспользуемых(ЭтотОбъект, ПоказыватьВидыРасчетаВАрхиве);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокУдержаний

&НаКлиенте
Процедура СписокУдержанийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		СписокВидовРасчетаВыборНаСервере(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНалогов

&НаКлиенте
Процедура СписокНалоговВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		СписокВидовРасчетаВыборНаСервере(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(ИзмененныеВидыРасчетаСтруктура());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокНачисленийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		СписокВидовРасчетаВыборНаСервере(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыРасчета(МассивВидовРасчета, Отбор)
	
	ИсходныеВидыРасчета.ЗагрузитьЗначения(МассивВидовРасчета);
	ВыбранныеВидыРасчета.ЗагрузитьЗначения(МассивВидовРасчета);
	
	ВыбранныеВидыРасчета.СортироватьПоЗначению();
	
КонецПроцедуры

&НаСервере
Процедура СписокВидовРасчетаВыборНаСервере(ВидРасчета)
	
	ЭлементСписка = ВыбранныеВидыРасчета.НайтиПоЗначению(ВидРасчета);
	Если ЭлементСписка <> Неопределено Тогда
		ВыбранныеВидыРасчета.Удалить(ЭлементСписка);
	Иначе 
		ВыбранныеВидыРасчета.Добавить(ВидРасчета);
		ВыбранныеВидыРасчета.СортироватьПоЗначению();
	КонецЕсли;
	
	УстановитьПараметрыСписков();
	
КонецПроцедуры

&НаСервере
Функция ИзмененныеВидыРасчетаСтруктура()
	
	ТекущиеВидыРасчета = ВыбранныеВидыРасчета.ВыгрузитьЗначения();
	МассивИсходныхВидовРасчета = ИсходныеВидыРасчета.ВыгрузитьЗначения();
	
	УдаленныеВидыРасчета = ОбщегоНазначенияКлиентСервер.СократитьМассив(МассивИсходныхВидовРасчета, ТекущиеВидыРасчета);
	ДобавленныеВидыРасчета = ОбщегоНазначенияКлиентСервер.СократитьМассив(ТекущиеВидыРасчета, МассивИсходныхВидовРасчета);
	
	ИзмененныеВидыРасчета = Новый Структура;
	ИзмененныеВидыРасчета.Вставить("УдаленныеВидыРасчета", УдаленныеВидыРасчета);
	ИзмененныеВидыРасчета.Вставить("ДобавленныеВидыРасчета", ДобавленныеВидыРасчета);
	
	Возврат ИзмененныеВидыРасчета;
	
КонецФункции	

&НаСервере
Процедура УстановитьПараметрыСписков()

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНачислений, "СписокВидовРасчета", ВыбранныеВидыРасчета.ВыгрузитьЗначения());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокУдержаний, "СписокВидовРасчета", ВыбранныеВидыРасчета.ВыгрузитьЗначения());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНалогов, "СписокВидовРасчета", ВыбранныеВидыРасчета.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписков(Отбор)
	
	Если ПодборУдержаний Тогда
		Список = СписокУдержаний;
	ИначеЕсли ПодборНалогов Тогда
		Список = СписокНалогов;
	Иначе
		Список = СписокНачислений;
	КонецЕсли;	
	
	Для Каждого СтрокаОтбора Из Отбор Цикл 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, 
			СтрокаОтбора.ЛевоеЗначение, СтрокаОтбора.ПравоеЗначение, СтрокаОтбора.ВидСравнения);
	КонецЦикла;
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборИспользуемых(Форма, ПоказыватьВАрхиве)
	
	Если Форма.ПодборУдержаний Тогда
		Список = Форма.СписокУдержаний;
	ИначеЕсли Форма.ПодборНалогов Тогда
		Список = Форма.СписокНалогов;
	Иначе
		Список = Форма.СписокНачислений;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВАрхиве", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьВАрхиве);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСреднихВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		СписокВидовРасчетаВыборНаСервере(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти