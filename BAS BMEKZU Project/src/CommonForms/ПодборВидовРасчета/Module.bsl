
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПодборУдержаний = Ложь;
	Если Параметры.Свойство("ПодборУдержаний") Тогда 
		ПодборУдержаний = Истина;
	КонецЕсли;	
	
	Отбор = Неопределено;
	Если Не Параметры.Свойство("УсловияОтбора", Отбор) Тогда 
		Отбор = Новый Структура;
	КонецЕсли;	
	
	ЗаполнитьВидыРасчета(Параметры.МассивВидовРасчета, ПодборУдержаний, Отбор);
	
	Заголовок = ?(ПодборУдержаний, НСтр("ru='Подбор удержаний';uk='Підбір утримань'"), НСтр("ru='Подбор начислений';uk='Підбір нарахувань'"));
	
	Если ПодборУдержаний Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВидыРасчетаКодДоходаНДФЛ", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВидыРасчетаКодДоходаСтраховыеВзносы", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВыбранныеВидыРасчета", "Заголовок", НСтр("ru='Выбранные удержания';uk='Вибрані утримання'"));
	КонецЕсли;	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(ИзмененныеВидыРасчетаСтруктура());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьВидыРасчета(МассивВидовРасчета, ПодборУдержаний, Отбор)
	
	ИсходныеВидыРасчета.ЗагрузитьЗначения(МассивВидовРасчета);
	ВыбранныеВидыРасчета.ЗагрузитьЗначения(МассивВидовРасчета);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ИсходныеВидыРасчета", ИсходныеВидыРасчета);
	
	Если ПодборУдержаний Тогда 
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВидыРасчета.Ссылка КАК ВидРасчета,
		               |	ВидыРасчета.Код КАК Код,
		               |	ВЫБОР
		               |		КОГДА ВидыРасчета.Ссылка В (&ИсходныеВидыРасчета)
		               |			ТОГДА ИСТИНА
		               |		ИНАЧЕ ЛОЖЬ
		               |	КОНЕЦ КАК Выбран,
		               |	ВидыРасчета.КатегорияУдержания КАК Категория
		               |ИЗ
		               |	ПланВидовРасчета.Удержания КАК ВидыРасчета
		               |ГДЕ
		               |	&УсловиеОтбора
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	ВидыРасчета.РеквизитДопУпорядочивания";
					   
	Иначе 				   
	
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВидыРасчета.Ссылка КАК ВидРасчета,
		               |	ВидыРасчета.Код КАК Код,
		               |	ВидыРасчета.ДоходНДФЛ КАК КодДоходаНДФЛ,
		               |	ВидыРасчета.ВидЕСВ КАК ВидЕСВ,
		               |	ВЫБОР
		               |		КОГДА ВидыРасчета.Ссылка В (&ИсходныеВидыРасчета)
		               |			ТОГДА ИСТИНА
		               |		ИНАЧЕ ЛОЖЬ
		               |	КОНЕЦ КАК Выбран,
		               |	ВидыРасчета.КатегорияНачисленияИлиНеоплаченногоВремени  КАК Категория
		               |ИЗ
		               |	ПланВидовРасчета.Начисления КАК ВидыРасчета
		               |ГДЕ
		               |	&УсловиеОтбора
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	ВидыРасчета.РеквизитДопУпорядочивания";
					   
	КонецЕсли;
	
	Условие = "";
	Для каждого ЭлементОтбора Из Отбор Цикл
		Если НЕ ПустаяСтрока(Условие) Тогда
			Условие = Условие + Символы.ПС + "И ";
		КонецЕсли;
		Запрос.УстановитьПараметр(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
		Условие = Условие  + "ВидыРасчета." + ЭлементОтбора.Ключ + " = &" + ЭлементОтбора.Ключ;
	КонецЦикла;
	Условие = ?(ЗначениеЗаполнено(Условие), Условие, "Истина");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", Условие);
	
	ВидыРасчета.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ИзмененныеВидыРасчетаСтруктура()
	
	ВыбранныеСтроки = ВидыРасчета.НайтиСтроки(Новый Структура("Выбран", Истина));
	
	ТекущиеВидыРасчета = ОбщегоНазначения.ВыгрузитьКолонку(ВыбранныеСтроки, "ВидРасчета", Истина);
	МассивИсходныхВидовРасчета = ИсходныеВидыРасчета.ВыгрузитьЗначения();
	
	УдаленныеВидыРасчета = ОбщегоНазначенияКлиентСервер.СократитьМассив(МассивИсходныхВидовРасчета, ТекущиеВидыРасчета);
	ДобавленныеВидыРасчета = ОбщегоНазначенияКлиентСервер.СократитьМассив(ТекущиеВидыРасчета, МассивИсходныхВидовРасчета);
	
	ИзмененныеВидыРасчета = Новый Структура;
	ИзмененныеВидыРасчета.Вставить("УдаленныеВидыРасчета", УдаленныеВидыРасчета);
	ИзмененныеВидыРасчета.Вставить("ДобавленныеВидыРасчета", ДобавленныеВидыРасчета);
	
	Возврат ИзмененныеВидыРасчета;
	
КонецФункции	

&НаКлиенте
Процедура ВидыРасчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		
		Элемент.ТекущиеДанные.Выбран = Не Элемент.ТекущиеДанные.Выбран;
		
		ЭлементСписка = ВыбранныеВидыРасчета.НайтиПоЗначению(Элемент.ТекущиеДанные.ВидРасчета);
		Если ЭлементСписка <> Неопределено Тогда
			ВыбранныеВидыРасчета.Удалить(ЭлементСписка);
		Иначе 
			ВыбранныеВидыРасчета.Добавить(Элемент.ТекущиеДанные.ВидРасчета);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры
