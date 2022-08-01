
// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальноеЗначениеВыбора = Параметры.НачальноеЗначениеВыбора;
	
	КлючевыеСловаПериодов = Новый СписокЗначений;
	КлючевыеСловаПериодов.Добавить("Месяц", НСтр("ru='ежемесячно';uk='щомісяця'"));
	КлючевыеСловаПериодов.Добавить("Квартал", НСтр("ru='ежеквартально';uk='щокварталу'"));
	КлючевыеСловаПериодов.Добавить("Полугодие", НСтр("ru='по полугодиям';uk='по півріччях'"));
	КлючевыеСловаПериодов.Добавить("Год", НСтр("ru='ежегодно';uk='щорічно'"));

	КромеМесяца = Новый СписокЗначений;
	КромеМесяца.Добавить(1, НСтр("ru='января';uk='січня'"));
	КромеМесяца.Добавить(2, НСтр("ru='февраля';uk='лютого'"));
	КромеМесяца.Добавить(3, НСтр("ru='марта';uk='березня'"));
	КромеМесяца.Добавить(4, НСтр("ru='апреля';uk='квітня'"));
	КромеМесяца.Добавить(5, НСтр("ru='мая';uk='травня'"));
	КромеМесяца.Добавить(6, НСтр("ru='июня';uk='червня'"));
	КромеМесяца.Добавить(7, НСтр("ru='июля';uk='липня'"));
	КромеМесяца.Добавить(8, НСтр("ru='августа';uk='серпня'"));
	КромеМесяца.Добавить(9, НСтр("ru='сентября';uk='вересня'"));
	КромеМесяца.Добавить(10, НСтр("ru='октября';uk='жовтня'"));
	КромеМесяца.Добавить(11, НСтр("ru='ноября';uk='листопада'"));
	КромеМесяца.Добавить(12, НСтр("ru='декабря';uk='грудня'"));
	
	КромеКвартала = Новый СписокЗначений;
	КромеКвартала.Добавить(1, НСтр("ru='1-го квартала';uk='1-го кварталу'"));
	КромеКвартала.Добавить(2, НСтр("ru='2-го квартала';uk='2-го кварталу'"));
	КромеКвартала.Добавить(3, НСтр("ru='3-го квартала';uk='3-го кварталу'"));
	КромеКвартала.Добавить(4, НСтр("ru='4-го квартала';uk='4-го кварталу'"));
	
	КромеПолугодия = Новый СписокЗначений;
	КромеПолугодия.Добавить(1, НСтр("ru='1-го полугодия';uk='1-го півріччя'"));
	КромеПолугодия.Добавить(2, НСтр("ru='2-го полугодия';uk='2-го півріччя'"));
	
	Кроме = Новый Структура("Месяц, Квартал, Полугодие, Год", КромеМесяца, КромеКвартала, КромеПолугодия, Новый СписокЗначений);

	ОшибкаПолученияСпискаФорм = Ложь;
	Попытка
		ПараметрыВнешнихРегламентированныхОтчетов = Неопределено;
		РеглОтчет = РегламентированнаяОтчетность.РеглОтчеты(НачальноеЗначениеВыбора.ИсточникОтчета);
		Попытка
			ТаблицаФормОтчета = РеглОтчет.Создать().ТаблицаФормОтчета();
			
			КЧ = Новый КвалификаторыЧисла(1, 0);
			Массив = Новый Массив;
			Массив.Добавить(Тип("Число"));
			ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,КЧ);
			ТаблицаФормОтчета.Колонки.Добавить("ИндексКартинки", ОписаниеТиповЧ);
			ЗначениеВДанныеФормы(ТаблицаФормОтчета, ФормыОтчета);
		Исключение
			ОшибкаПолученияСпискаФорм = Истина;
		КонецПопытки;
		Если ОшибкаПолученияСпискаФорм Тогда
			ВызватьИсключение Неопределено;
		КонецЕсли;
		
		Для Каждого Элемент Из ФормыОтчета Цикл
						
			Если (ТекущаяДатаСеанса() > Элемент.ДатаНачалоДействия ИЛИ НЕ ЗначениеЗаполнено(Элемент.ДатаНачалоДействия)) 
			   И (ТекущаяДатаСеанса() < Элемент.ДатаКонецДействия ИЛИ НЕ ЗначениеЗаполнено(Элемент.ДатаКонецДействия)) Тогда
			
				Элемент.ИндексКартинки = 0;
				
			Иначе
				
				Элемент.ИндексКартинки = 1;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Элемент.ДатаКонецДействия) Тогда
				Элемент.ДатаКонецДействия = НСтр("ru='По настоящее время';uk='По теперішній час'");
			КонецЕсли;
					
		КонецЦикла;
		
		ФормыОтчета.Сортировать("ДатаНачалоДействия");
		Элементы.ИнформацияОФормах.ТекущаяСтраница = Элементы.ИнформацияОФормахДоступна;
	Исключение
		Элементы.ФормыОтчета.Доступность = Ложь;
		Элементы.ИнформацияОФормах.ТекущаяСтраница = Элементы.ИнформацияОФормахНеДоступна;
	КонецПопытки;
	
	ИтоговаяСтрока = "";
	Периоды = НачальноеЗначениеВыбора.Периоды.Получить();
	Если Периоды <> Неопределено Тогда
		ТипЗнчПериоды = ТипЗнч(Периоды);
		Если ТипЗнчПериоды = Тип("Структура") Тогда
			ИтоговаяСтрока = ПолучитьСтрокуПредставленияПериодовДляЗаписи(Периоды);
		ИначеЕсли ТипЗнчПериоды = Тип("Соответствие") Тогда
			ТаблицаСтрокПредставлений = Новый ТаблицаЗначений;
			ТаблицаСтрокПредставлений.Колонки.Добавить("НачалоДействия");
			ТаблицаСтрокПредставлений.Колонки.Добавить("КонецДействия");
			ТаблицаСтрокПредставлений.Колонки.Добавить("Представление");
			Для Каждого ЗаписьПериода Из Периоды Цикл
				НовСтр = ТаблицаСтрокПредставлений.Добавить();
				НовСтр.НачалоДействия = ЗаписьПериода.Ключ;
				НовСтр.Представление = ПолучитьСтрокуПредставленияПериодовДляЗаписи(ЗаписьПериода.Значение);
			КонецЦикла;
			ТаблицаСтрокПредставлений.Сортировать("НачалоДействия");
			Для Инд = 0 По ТаблицаСтрокПредставлений.Количество() - 2 Цикл
				ТекСтр = ТаблицаСтрокПредставлений.Получить(Инд);
				СледующаяДатаНачала = ТаблицаСтрокПредставлений.Получить(Инд + 1).НачалоДействия;
				ТекСтр.КонецДействия = СледующаяДатаНачала;
			КонецЦикла;
			Для Каждого Стр Из ТаблицаСтрокПредставлений Цикл
				Если Стр.КонецДействия <> '00010101000000' И Стр.КонецДействия <> Неопределено Тогда
					Стр.КонецДействия = НачалоДня(Стр.КонецДействия - 1);
				КонецЕсли;
			КонецЦикла;
			КолСтрокТаблицыПредставлений = ТаблицаСтрокПредставлений.Количество();
			Для ОбратныйИндекс = 1 По КолСтрокТаблицыПредставлений Цикл
				Стр = ТаблицаСтрокПредставлений.Получить(КолСтрокТаблицыПредставлений - ОбратныйИндекс);
				СтрПериодДействия = "";
				Если Стр.НачалоДействия <> '00010101000000' И Стр.НачалоДействия <> Неопределено Тогда
					СтрПериодДействия = НСтр("ru='С ';uk='З '") + Формат(Стр.НачалоДействия, "ДФ=dd.MM.yyyy");
				КонецЕсли;
				Если Стр.КонецДействия <> '00010101000000' И Стр.КонецДействия <> Неопределено Тогда
					СтрПериодДействия = СтрПериодДействия + НСтр("ru=' до ';uk=' до '") + Формат(Стр.КонецДействия, "ДФ=dd.MM.yyyy");
				КонецЕсли;
				СтрПериодДействия = СокрЛП(СтрПериодДействия);
				Если НЕ ПустаяСтрока(СтрПериодДействия) Тогда
					ИтоговаяСтрока = ИтоговаяСтрока + ВРЕГ(Лев(СтрПериодДействия, 1)) + Сред(СтрПериодДействия, 2) + ": " + нрег(Стр.Представление) + Символы.ПС;
				Иначе
					ИтоговаяСтрока = ИтоговаяСтрока + Стр.Представление + Символы.ПС;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		ИтоговаяСтрока = НСтр("ru='Сведения о возможных периодах представления не определены.';uk='Відомості про можливі періоди подання не визначені.'");
	КонецЕсли;
	НадписьВозможныеПериоды = СокрЛП(ИтоговаяСтрока);
	
КонецПроцедуры // ПриСозданииНаСервере()

// ПолучитьСтрокуПредставленияПериодовДляЗаписи()
//
&НаСервере
Функция ПолучитьСтрокуПредставленияПериодовДляЗаписи(СтруктураПериодов)
	
	ИтоговаяСтрока = "";
	МассивСтрокиПериоды = Новый Массив;
	КлючевыеСловаПериодов.ЗаполнитьПометки(Ложь);
	Для Каждого Стр Из СтруктураПериодов Цикл
		
		Ключ = Стр.Ключ;
		КлючевоеСлово = Неопределено;
		Для Каждого Эл Из КлючевыеСловаПериодов Цикл
			Если Лев(Ключ, СтрДлина(Эл.Значение)) = Эл.Значение И Эл.Пометка <> Истина Тогда
				КлючевоеСлово = Эл.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если КлючевоеСлово = Неопределено Тогда
			Продолжить;
		Конецесли;
		Эл.Пометка = Истина;
		Значение = Стр.Значение;
		Если Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПериоды = КлючевыеСловаПериодов.НайтиПоЗначению(КлючевоеСлово).Представление;
		ПервыйПериодИсключение = Истина;
		РазрешенныеПериоды = Новый СписокЗначений;
		РазрешенныеПериоды.ЗагрузитьЗначения(Значение);
		Для Каждого Эл Из Кроме[КлючевоеСлово] Цикл
			Если РазрешенныеПериоды.НайтиПоЗначению(Эл.Значение) = Неопределено Тогда
				СтрокаПериоды = СтрокаПериоды + ?(ПервыйПериодИсключение, НСтр("ru=', кроме ';uk=', крім '"), ", ") + Эл.Представление;
				ПервыйПериодИсключение = Ложь;
			КонецЕсли;
		КонецЦикла;                                 	
		
		ИтоговаяСтрока = ИтоговаяСтрока + СтрокаПериоды + "; ";
		
	КонецЦикла;
	
	Если ПустаяСтрока(ИтоговаяСтрока) Тогда
		ИтоговаяСтрока = НСтр("ru='Не представляется.';uk='Не видається.'");
	Иначе
		ИтоговаяСтрока = Лев(ИтоговаяСтрока, СтрДлина(ИтоговаяСтрока) - 2);
		ИтоговаяСтрока = ВРег(Лев(ИтоговаяСтрока, 1)) + Сред(ИтоговаяСтрока, 2) + ".";
	КонецЕсли;
	
	Возврат ИтоговаяСтрока;
	
КонецФункции // ПолучитьСтрокуПредставленияПериодовДляЗаписи()
