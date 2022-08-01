Процедура ДобавитьАнонс(Форма, ИмяРаздела, ИмяПодраздела, ТаблицаАнонсов) Экспорт
	
	// Общая группа.
	ИмяГруппыПолезнаяИнформация = "ГруппаПолезнаяИнформация";
	ГруппаПолезнаяИнформация = Форма.Элементы.Найти(ИмяГруппыПолезнаяИнформация);
	Если ГруппаПолезнаяИнформация = Неопределено Тогда
		ГруппаПолезнаяИнформация = Форма.Элементы.Вставить("ГруппаПолезнаяИнформация", Тип("ГруппаФормы"),, Форма.ПодчиненныеЭлементы.Получить(0)); 
	КонецЕсли;
	ГруппаПолезнаяИнформация.Заголовок = НСтр("ru='Полезная информация';uk='Корисна інформація'");
	ГруппаПолезнаяИнформация.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаПолезнаяИнформация.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаПолезнаяИнформация.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаПолезнаяИнформация.ОтображатьЗаголовок = Ложь;
	
	// Группа для добавления ссылки.
	ГруппаСсылки = Форма.Элементы.Добавить("ГруппаПолезнаяИнформацияСсылки", Тип("ГруппаФормы"), ГруппаПолезнаяИнформация); 
	ГруппаСсылки.Заголовок = НСтр("ru='Полезная информация (ссылки)';uk='Корисна інформація (посилання)'");
	ГруппаСсылки.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСсылки.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаСсылки.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаСсылки.ОтображатьЗаголовок = Ложь;
	ГруппаСсылки.РастягиватьПоГоризонтали = Ложь;
	
	// Команда "Скрыть".
	ИмяКоманды = "ПолезнаяИнформацияСкрыть" + ИмяРаздела + ИмяПодраздела;
	
	НоваяКоманда = Форма.Команды.Добавить(ИмяКоманды);
	НоваяКоманда.Отображение = ОтображениеКнопки.Текст;
	НоваяКоманда.Заголовок = НСтр("ru='Скрыть';uk='Сховати'");
	НоваяКоманда.Подсказка = НСтр("ru='Скрыть это оповещение';uk='Приховати це оповіщення'");
	НоваяКоманда.Действие = "Подключаемый_СкрытьПолезнуюИнформацию";
	
	НовыйЭлемент = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаПолезнаяИнформация); 
	НовыйЭлемент.Вид = ВидКнопкиФормы.Гиперссылка;
	НовыйЭлемент.ИмяКоманды = ИмяКоманды;
	НовыйЭлемент.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
	
	// Ссылки.
	Для каждого СтрокаТаблицыАнонсов Из ТаблицаАнонсов Цикл
		ДобавитьГиперссылку(Форма, ГруппаСсылки, СтрокаТаблицыАнонсов.Картинка, СтрокаТаблицыАнонсов.Текст, СтрокаТаблицыАнонсов.Гиперссылка,, Истина);		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьГиперссылки(Форма, Группа, ИмяРаздела, ИмяПодраздела, МаксимальноеКоличествоСсылок = 10) Экспорт 
	
	ТаблицаСсылок = ПолучитьТаблицуСсылок(ИмяРаздела, ИмяПодраздела);
	
	Если ТаблицаСсылок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Счетчик = 1 По Мин(ТаблицаСсылок.Количество(), МаксимальноеКоличествоСсылок) Цикл
		
		СтрокаТаблицы = ТаблицаСсылок[Счетчик - 1];
		
		ДобавитьГиперссылку(Форма, Группа, СтрокаТаблицы.Картинка, СтрокаТаблицы.Текст, СтрокаТаблицы.Гиперссылка, СтрокаТаблицы.Важно);
		
		ДобавитьГиперссылкуВсеМатериалы(Форма, "ПолезнаяИнформация_ВсеМатериалы" + ИмяРаздела + ИмяПодраздела, СтрокаТаблицы.Текст, СтрокаТаблицы.Гиперссылка);
		
	КонецЦикла;
	
	Если ТаблицаСсылок.Количество() > МаксимальноеКоличествоСсылок Тогда
	
		Для Счетчик = (МаксимальноеКоличествоСсылок + 1) По ТаблицаСсылок.Количество() Цикл
			
			СтрокаТаблицы = ТаблицаСсылок[Счетчик - 1];
			
			ДобавитьГиперссылкуВсеМатериалы(Форма, "ПолезнаяИнформация_ВсеМатериалы" + ИмяРаздела + ИмяПодраздела, СтрокаТаблицы.Текст, СтрокаТаблицы.Гиперссылка);
			
		КонецЦикла;
	
		Если Счетчик > МаксимальноеКоличествоСсылок Тогда
			
			ИмяКоманды = "ПолезнаяИнформация_ВсеМатериалы" + ИмяРаздела + ИмяПодраздела;
			
			НовыйЭлемент = Форма.Элементы.Добавить(ИмяКоманды + "Отступ", Тип("ДекорацияФормы"), Группа); 
			НовыйЭлемент.Вид = ВидДекорацииФормы.Надпись;
			
			НоваяКоманда = Форма.Команды.Добавить(ИмяКоманды);
			НоваяКоманда.Заголовок = НСтр("ru='Все материалы';uk='Всі матеріали'");
			НоваяКоманда.Действие = "Подключаемый_ОткрытьВсеМатериалыПолезнойИнформации";
			
			НовыйЭлемент = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Группа); 
			НовыйЭлемент.Вид = ВидКнопкиФормы.Гиперссылка;
			НовыйЭлемент.ИмяКоманды = ИмяКоманды;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьГиперссылку(Форма, Группа, ИмяКартинки = "", ЗаголовокКоманды, Гиперссылка, Важно = Ложь, ОсобыйТекст = Ложь)
	
	ИмяКоманды = ПолучитьИмяНовогоЭлемента(Форма);
	
	НоваяКоманда = Форма.Команды.Добавить(ИмяКоманды);
	Если НЕ ПустаяСтрока(ИмяКартинки) Тогда
		НоваяКоманда.Картинка = БиблиотекаКартинок[ИмяКартинки];
	КонецЕсли;
	НоваяКоманда.Отображение = ОтображениеКнопки.КартинкаИТекст;
	НоваяКоманда.Заголовок = ЗаголовокКоманды;
	НоваяКоманда.Действие = "Подключаемый_ОткрытьГиперссылкуПолезнойИнформации";
	
	НовыйЭлемент = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Группа); 
	НовыйЭлемент.Вид = ВидКнопкиФормы.Гиперссылка;
	Если Важно Тогда
		НовыйЭлемент.Шрифт = Новый Шрифт(,, Истина);
	КонецЕсли; 
	Если ОсобыйТекст Тогда
		НовыйЭлемент.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
	КонецЕсли;
	НовыйЭлемент.ИмяКоманды = ИмяКоманды;
	
	// Ссылки на методическую поддержку.
	ИмяРеквизита = "ПолезнаяИнформация_Гиперссылки";
	РеквизитыФормы = Форма.ПолучитьРеквизиты();
	РеквизитФормыСуществует = Ложь;
	Для каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = ИмяРеквизита Тогда
			РеквизитФормыСуществует = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НЕ РеквизитФормыСуществует Тогда
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СписокЗначений")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
	Форма.ПолезнаяИнформация_Гиперссылки.Добавить(ИмяКоманды, Гиперссылка);
	
КонецПроцедуры

Процедура ДобавитьГиперссылкуВсеМатериалы(Форма, ИмяРеквизита, ЗаголовокКоманды, Гиперссылка)
	
	РеквизитыФормы = Форма.ПолучитьРеквизиты();
	РеквизитФормыСуществует = Ложь;
	Для каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = ИмяРеквизита Тогда
			РеквизитФормыСуществует = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НЕ РеквизитФормыСуществует Тогда
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("Строка")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
	ШаблонСсылки = "<p><a target='_blank' href='%2'>%1</a></p>";
	
	ТекстСсылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСсылки, ЗаголовокКоманды, Гиперссылка);
	
	Форма[ИмяРеквизита] = Форма[ИмяРеквизита] + ТекстСсылки;
	
КонецПроцедуры

Функция ПолучитьИмяНовогоЭлемента(Форма)
	
	ПрефиксИмениЭлемента = "ПолезнаяИнформацияЭлемент";
	
	Счетчик = 0;
	ИмяЭлемента = ПрефиксИмениЭлемента + Счетчик;
	
	Пока Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено Цикл
		Счетчик = Счетчик + 1;
		ИмяЭлемента = ПрефиксИмениЭлемента + Счетчик;
	КонецЦикла;
	
	Возврат ИмяЭлемента;
	
КонецФункции

Функция ПолучитьТаблицуСсылок(ИмяРаздела, ИмяПодраздела)

	ВерсияИБ = ОбновлениеИнформационнойБазы.ВерсияИБ(Метаданные.Имя);
	
	ТаблицаСсылок = Новый ТаблицаЗначений;
	ТаблицаСсылок.Колонки.Добавить("Раздел", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Подраздел", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Важно", Новый ОписаниеТипов("Булево"));
	ТаблицаСсылок.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Версия0", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Версия1", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Версия2", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Версия3", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Текст", Новый ОписаниеТипов("Строка"));
	ТаблицаСсылок.Колонки.Добавить("Гиперссылка", Новый ОписаниеТипов("Строка"));
	
	Макет = ПолучитьОбщийМакет("ПолезнаяИнформация");
	
	Для НомерСтр = 2 По Макет.ВысотаТаблицы Цикл
		
		// Перебираем строки макета.
		Раздел = СокрП(Макет.Область(НомерСтр, 1).Текст);
		Подраздел = СокрП(Макет.Область(НомерСтр, 2).Текст);
		Тип = СокрП(Макет.Область(НомерСтр, 3).Текст);
		Важно = СокрП(Макет.Область(НомерСтр, 4).Текст);
		Версия = СокрП(Макет.Область(НомерСтр, 5).Текст);
		Текст = СокрП(Макет.Область(НомерСтр, 6).Текст);
		Гиперссылка = СокрП(Макет.Область(НомерСтр, 7).Текст);
		
		Если Раздел = "###" Тогда
			Прервать;
		ИначеЕсли ПустаяСтрока(Раздел) Тогда
			Продолжить;
		ИначеЕсли Лев(Раздел, 1) = "#" Тогда
			Продолжить;
		ИначеЕсли ПустаяСтрока(Подраздел) Тогда
			Продолжить;
		ИначеЕсли Раздел <> ИмяРаздела Тогда
			Продолжить;
		ИначеЕсли Подраздел <> ИмяПодраздела Тогда
			Продолжить;
		Иначе
			
			// Коррекция версии.
			Если ПустаяСтрока(Версия) Тогда
				Версия = "0.0.0.0";
			КонецЕсли;
			
			ВерсияМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Версия, ".");
			Если ВерсияМассив.Количество() = 3 Тогда
				ВерсияМассив.Добавить("0");
				Версия = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(ВерсияМассив, ".");
			КонецЕсли;
			
			// Коррекция ссылки.
			Если Лев(Гиперссылка, 5) = "e1cib" 
			 ИЛИ Лев(Гиперссылка, 7) = "http://" Тогда
				Ссылка = Гиперссылка;
			Иначе
				Ссылка = "e1cib/navigationpoint/" + Гиперссылка + "/ОбщаяКоманда.ПолезнаяИнформацияПоРазделу" + Гиперссылка;
			КонецЕсли;
			
			// Коррекция картинки.
			Если Тип = "Документ" Тогда 
				Картинка = "ПолезнаяИнформацияСтатья";
			ИначеЕсли Тип = "Видео" Тогда
				Картинка = "ПолезнаяИнформацияВидео";
			Иначе
				Картинка = "";
			КонецЕсли;
			
			СтрокаТаблицы = ТаблицаСсылок.Добавить();
			СтрокаТаблицы.Раздел = Раздел;
			СтрокаТаблицы.Подраздел = Подраздел;
			СтрокаТаблицы.Картинка = Картинка;
			СтрокаТаблицы.Важно = ?(Важно = "1", Истина, Ложь);
			СтрокаТаблицы.Версия = Версия;
			СтрокаТаблицы.Версия0 = ВерсияМассив[0];
			СтрокаТаблицы.Версия1 = ВерсияМассив[1];
			СтрокаТаблицы.Версия2 = ВерсияМассив[2];
			СтрокаТаблицы.Версия3 = ВерсияМассив[3];
			СтрокаТаблицы.Текст = Текст;
			СтрокаТаблицы.Гиперссылка = Ссылка;
				
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат ТаблицаСсылок;

КонецФункции

Процедура ДобавитьПолезныеСсылки(МассивСсылок) Экспорт
	
	ОписаниеСсылки = ИнформационныйЦентрСервер.НовоеОписаниеПолезнойСсылки();
	ОписаниеСсылки.Имя			= НСтр("ru='Отвечает аудитор ';uk='Відповідає аудитор '");
	ОписаниеСсылки.Адрес		= "https://portal.bas-soft.eu/applications/54";
	ОписаниеСсылки.Пояснение	= НСтр("ru='Ответы на актуальные вопросы ';uk='Відповіді на актуальні запитання '");
	МассивСсылок.Добавить(ОписаниеСсылки);
	
КонецПроцедуры