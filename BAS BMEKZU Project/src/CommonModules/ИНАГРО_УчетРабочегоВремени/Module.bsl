#Область ПрограммныйИнтерфейс

// Формирует записи в регистре сведений "ГрафикиРаботыПоВидамВремени" на
//  для переданного графика работы.
//
// Параметры:
//		ГрафикРаботы - календарь, по которому необходимо сформировать записи о времени.
//		ДанныеГрафика - таблица (типизированная) значений со следующими колонками:
//          Дата - тип "Дата",
//			ВидУчетаВремени - вид учета времени (тип - "СправочникСсылка.ИНАГРО_ВидыИспользованияРабочегоВремени").
//			Часы - количество часов.
//			
Процедура ЗаписатьДанныеГрафика(ГрафикРаботы, ДанныеГрафика, НомерТекущегоГода, ДанныеПроизводственногоКалендаря) Экспорт

	
	ТаблицаДанныхГрафика = Новый ТаблицаЗначений;
	ТаблицаДанныхГрафика.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТаблицаДанныхГрафика.Колонки.Добавить("ВидУчетаВремени", Новый ОписаниеТипов("СправочникСсылка.ИНАГРО_КлассификаторИспользованияРабочегоВремени"));         
	ТаблицаДанныхГрафика.Колонки.Добавить("Часы", Новый ОписаниеТипов("Число"));
	                                                   
	Для Каждого ДанныеГрафикаЗаМесяц Из ДанныеГрафика Цикл 
		Месяц = Дата(НомерТекущегоГода, ДанныеГрафикаЗаМесяц.НомерМесяца, 1);
		КоличествоДнейВМесяце = ИНАГРО_УчетРабочегоВремениКлиентСервер.КоличествоДнейМесяца(Месяц);
		Для НомерДня = 1 По КоличествоДнейВМесяце Цикл
			ТекущийДень = Месяц + (НомерДня - 1) * 86400;
			
			ДанныеГрафикаЗаДату = ТаблицаДанныхГрафика.Добавить();
			ДанныеГрафикаЗаДату.Дата = ТекущийДень;
			ДанныеГрафикаЗаДату.ВидУчетаВремени = ДанныеГрафикаЗаМесяц.ВидВремени;
			ДанныеГрафикаЗаДату.Часы = ДанныеГрафикаЗаМесяц["День" + НомерДня];
		КонецЦикла;
		
	КонецЦикла;


	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеГрафика", ТаблицаДанныхГрафика);
	Запрос.УстановитьПараметр("Календари", ДанныеПроизводственногоКалендаря);
	Запрос.Текст = 
	"ВЫБРАТЬ

	|	ДанныеГрафика.Дата,
	|	ДанныеГрафика.Часы,
	|	ДанныеГрафика.ВидУчетаВремени
	|ПОМЕСТИТЬ ВТДанныеГрафика
	|ИЗ
	|	&ДанныеГрафика КАК ДанныеГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Календари.ДатаКалендаря,
	|	Календари.ВидДня
	|ПОМЕСТИТЬ ВТКалендари
	|ИЗ
	|	&Календари КАК Календари
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеГрафика.Дата КАК Дата,
	|	СУММА(ДанныеГрафика.Часы) КАК Часы,
	|	НАЧАЛОПЕРИОДА(ДанныеГрафика.Дата, МЕСЯЦ) КАК Месяц,
	|	ВТКалендари.ВидДня,
	|	ДанныеГрафика.ВидУчетаВремени
	|ИЗ
	|	ВТКалендари КАК ВТКалендари
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеГрафика КАК ДанныеГрафика
	|		ПО ВТКалендари.ДатаКалендаря = ДанныеГрафика.Дата
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеГрафика.Дата,
	|	ДанныеГрафика.ВидУчетаВремени,
	|	ВТКалендари.ВидДня

	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц,
	|	Дата";
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	Пока Выборка.СледующийПоЗначениюПоля("Месяц") Цикл 
				
		Пока Выборка.СледующийПоЗначениюПоля("Дата") Цикл
			
			НаборЗаписей = РегистрыСведений.ИНАГРО_ГрафикиРаботыПоВидамВремени.СоздатьНаборЗаписей();
			
			НаборЗаписей.Отбор.ГрафикРаботы.Установить(ГрафикРаботы);
			НаборЗаписей.Отбор.Дата.Установить(Выборка.Дата);
			
			РабочееВремяЧасы = 0;
			НеРабочееВремяЧасы = 0;
			
			Пока Выборка.Следующий() Цикл
				РабочееВремяДни = 1;
				РабочееВремяЧасы = РабочееВремяЧасы + Выборка.Часы;
				Если Выборка.ВидУчетаВремени = Справочники.ИНАГРО_КлассификаторИспользованияРабочегоВремени.Работа Тогда

					Запись = НаборЗаписей.Добавить();
					Запись.Дата = Выборка.Дата;
					Запись.ГрафикРаботы = ГрафикРаботы;
					Запись.Месяц = Выборка.Месяц;
					Запись.ВидУчетаВремени = Перечисления.ИНАГРО_ВидыУчетаВремени.ПоДням;
					Запись.ОсновноеЗначение = ?(Выборка.Часы > 0, 1, 0);
					Запись.ДополнительноеЗначение = Выборка.Часы;
					Если Выборка.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник Тогда
						Запись.ПроизводственныйКалендарьКалендарныеДни = 0;
					Иначе
						Запись.ПроизводственныйКалендарьКалендарныеДни = 1;
					КонецЕсли;
					Запись.ПроизводственныйКалендарьКалендарныеДниСПраздниками = 1;
					
					Запись = НаборЗаписей.Добавить();
					Запись.Дата = Выборка.Дата;
					Запись.ГрафикРаботы = ГрафикРаботы;
					Запись.Месяц = Выборка.Месяц;
					Запись.ВидУчетаВремени = Перечисления.ИНАГРО_ВидыУчетаВремени.ПоЧасам;
					Запись.ОсновноеЗначение = Выборка.Часы;
					Запись.ДополнительноеЗначение = ?(Выборка.Часы > 0, 1, 0);
					Если Выборка.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник Тогда
						Запись.ПроизводственныйКалендарьКалендарныеДни = 0;
					Иначе
						Запись.ПроизводственныйКалендарьКалендарныеДни = 1;
					КонецЕсли;
					Запись.ПроизводственныйКалендарьКалендарныеДниСПраздниками = 1;
						
				ИначеЕсли Выборка.ВидУчетаВремени = Справочники.ИНАГРО_КлассификаторИспользованияРабочегоВремени.Вечерние Тогда

					Запись = НаборЗаписей.Добавить();
					Запись.Дата = Выборка.Дата;
					Запись.ГрафикРаботы = ГрафикРаботы;
					Запись.Месяц = Выборка.Месяц;
					Запись.ВидУчетаВремени = Перечисления.ИНАГРО_ВидыУчетаВремени.ПоВечернимЧасам;
					Запись.ОсновноеЗначение = Выборка.Часы;
					
				ИначеЕсли Выборка.ВидУчетаВремени = Справочники.ИНАГРО_КлассификаторИспользованияРабочегоВремени.Ночные Тогда
					
					Запись = НаборЗаписей.Добавить();
					Запись.Дата = Выборка.Дата;
					Запись.ГрафикРаботы = ГрафикРаботы;
					Запись.Месяц = Выборка.Месяц;
					Запись.ВидУчетаВремени = Перечисления.ИНАГРО_ВидыУчетаВремени.ПоНочнымЧасам;
					Запись.ОсновноеЗначение = Выборка.Часы;	
					
				КонецЕсли;

			КонецЦикла;
			НаборЗаписей.Записать(Истина);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

// Выполняются необходимые действия
//
Процедура СоздатьВТПериоды(МенеджерВременныхТаблиц, НачалоИнтервала, ОкончаниеИнтервала, Периодичность = "МЕСЯЦ", ИмяПоляПериод = "Период", ИмяВТ = "ВТПериоды", ИспользоватьКонецПериода = Ложь) Экспорт
	
	Если НачалоИнтервала > ОкончаниеИнтервала Тогда
		ВызватьИсключение НСтр("ru='Дата окончания не может быть меньше даты начала.';uk='Дата закінчення не може бути менше дати початку'")
	КонецЕсли;                
	
	Запрос = ЗапросВТПериоды(НачалоИнтервала, ОкончаниеИнтервала, Периодичность, ИмяПоляПериод, ИмяВТ, ИспользоватьКонецПериода);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

// Выполняются необходимые действия
//
Процедура ТабельПериодРегистрацииПриИзменении(Форма) Экспорт
	Объект = Форма.Объект;
	
	ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельУстановитьПериодДокумента(Форма);
	
	ОформитьПоляТаблицыДнейМесяца(Форма.Элементы, НачалоМесяца(Объект.ПериодРегистрации), "ОтработанноеВремяВремя%1Представление");	
	
	ТабельУстановитьВидимостьКолонокДнейПериода(Форма);
	
	ТабельПоместитьОписаниеВидовВремениВДанныеФормы(Форма);
	
КонецПроцедуры

// Выполняются необходимые действия
//
Функция ЗаполненРегламентированныйПроизводственныйКалендарь(НачалоПериода, КонецПериода) Экспорт
	
	ТЗ = "ВЫБРАТЬ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря
	|ИЗ
	|	РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &НачалоПериода И &КонецПериода";
	
	Запрос = Новый Запрос(ТЗ);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериода);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

// Процедура проверяет отпука и больничные сотрудников
//
//  Параметры:
//		ПутевойЛист	- ДокументСсылка.ИНАГРО_ПутевойЛистГрузовогоАвтомобиля, ДокументСсылка.ИНАГРО_ПутевойЛистТрактористаМашиниста
//
//	Возвращаемое значение:
//  	Булево      - Истина, если сотрудник был в отпуске или на больничном   
// 
Функция ПроверитьОтпускаБольничныеСотрудников(ПутевойЛист) Экспорт
	
	Если ПутевойЛист.СводныйПутевойЛист Тогда
		
		Для Каждого СтрокаПутевогоЛиста Из ПутевойЛист.ПутевыеЛисты Цикл
			
			ОтпускБольничный                  = БольничныеОтпуска(ПутевойЛист.Водитель, СтрокаПутевогоЛиста.ДатаДокумента, СтрокаПутевогоЛиста.ДатаПо);
			СотрДляПроверкиБольничногоОтпуска = ?(ОтпускБольничный.Количество() > 0, ОтпускБольничный[0], Неопределено);
			
			Если  НЕ СотрДляПроверкиБольничногоОтпуска = Неопределено Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Сотрудник %1 отсутствовал и документ не будет проведен ';uk='Співробітник %1 був відсутній документ не буде проведено '"),ПутевойЛист.Водитель);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				ВР = ?(СотрДляПроверкиБольничногоОтпуска.Состояние <> Перечисления.ИНАГРО_СостоянияРаботникаОрганизации.Заболевание, НСтр("ru='в отпуске';uk='у відпустці'"), НСтр("ru='на больничном';uk='на лікарняному'")); 
				ТекстСообщения = НСтр("ru='В строке " + СтрокаПутевогоЛиста.НомерСтроки + " сотрудник " + ПутевойЛист.Водитель + " в периоде с " + Формат(СтрокаПутевогоЛиста.ДатаДокумента, "ДФ=dd.MM.yyyy") + " по " + Формат(СтрокаПутевогоЛиста.ДатаПо, "ДФ=dd.MM.yyyy") + " находился "+ ВР + " проверьте период начисления';uk='У рядку " + СтрокаПутевогоЛиста.НомерСтроки + " співробітник " + ПутевойЛист.Водитель + " в періоді з " + Формат(СтрокаПутевогоЛиста.ДатаДокумента, "ДФ=dd.MM.yyyy") + " по " + Формат(СтрокаПутевогоЛиста.ДатаПо, "ДФ=dd.MM.yyyy") + " знаходився "+ ВР + " перевірте період нарахування'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат  Истина;
			КонецЕсли;
			
		КонецЦикла
		
	Иначе
		
		ОтпускБольничный                  = БольничныеОтпуска(ПутевойЛист.Водитель, НачалоДня(ПутевойЛист.Дата), КонецДня(ПутевойЛист.Дата));
		СотрДляПроверкиБольничногоОтпуска = ?(ОтпускБольничный.Количество() > 0, ОтпускБольничный[0],Неопределено);
		
		Если  НЕ СотрДляПроверкиБольничногоОтпуска = Неопределено Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Сотрудник %1 отсутствовал и документ не будет проведен ';uk='Співробітник %1 був відсутній документ не буде проведено '"),ПутевойЛист.Водитель);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ВР = ?(СотрДляПроверкиБольничногоОтпуска.Состояние <> Перечисления.ИНАГРО_СостоянияРаботникаОрганизации.Заболевание, НСтр("ru='в отпуске';uk='у відпустці'"), НСтр("ru='на больничном';uk='на лікарняному'")); 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Сотрудник %1  на дату %2 находился %3 ';uk='Співробітник %1  на дату %2 знаходився %3 '"),ПутевойЛист.Водитель,Формат(ПутевойЛист.Дата, "ДФ=dd.MM.yyyy"),ВР);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат  Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает запрос, формирующий временную таблицу периодов с заданной периодичностью.
//
// Параметры:
//	ОписаниеНачалаИнтервала - Строка, имя параметра в тексте запроса ("&НачалоПериода", "ДАТАВРЕМЯ(2013, 1, 1)").
//							- Дата, начальная дата интервала, за который формируются периоды.
//	ОписаниеОкончанияИнтервала -  Строка, имя параметра в тексте запроса,
//							- Дата, конечная дата интервала, за который формируются периоды.
//	Периодичность - периодичность, на которую будет разбиваться интервал.
//		По умолчанию <МЕСЯЦ>. Может принимать значения:	ГОД, КВАРТАЛ, МЕСЯЦ, ДЕНЬ.
//	ИмяПоляПериод - наименование колонки во временной таблице периодов. 
//		По умолчанию <Период>.
//	ИмяВТ - наименование временной таблицы периодов, по умолчанию <ВТПериоды>.
//	ИспользоватьКонецПериода - булево, необязательный, по умолчанию - Ложь. 
//		Определяет необходимость использовать в качестве значения последнюю секунду периода. 
//		То есть если Истина, то для периодичности месяц, 
//		временная таблица будет заполнена датами конца каждого месяца, 
//		и если ложь, то - датами начала.
//
Функция ЗапросВТПериоды(Знач ОписаниеНачалаИнтервала, Знач ОписаниеОкончанияИнтервала, Периодичность = "МЕСЯЦ", ИмяПоляПериод = "Период", ИмяВТ = "ВТПериоды", ИспользоватьКонецПериода = Ложь) Экспорт
	
	Если ТипЗнч(ОписаниеНачалаИнтервала) = Тип("Дата")
		И ТипЗнч(ОписаниеОкончанияИнтервала) = Тип("Дата") Тогда
		
		Если ОписаниеОкончанияИнтервала < ОписаниеНачалаИнтервала Тогда
			
			ТекстИсключения = НСтр("ru='Дата окончания периода не может быть меньше даты начала';uk='Дата закінчення періоду не може бути менше дати початку'");
			ВызватьИсключение ТекстИсключения;
			
		Иначе
			
			ЛетВИнтервале = Год(ОписаниеОкончанияИнтервала) - Год(ОписаниеНачалаИнтервала);
			Если ЛетВИнтервале > 100 Тогда
				
				ТекстИсключения = НСтр("ru='Попытка получить данные за слишком большой интервал времени';uk='Спроба отримати дані за занадто великий інтервал часу'")
					+ " (%1 " + НСтр("ru='лет';uk='років'") + ": " + НСтр("ru='с';uk='з'")+ " %2 " + НСтр("ru='по';uk='по'") + " %3)";
				
				ТекстИсключения = Локализация.СтрШаблонУкр(ТекстИсключения, Формат(ЛетВИнтервале, "ЧГ="), Формат(ОписаниеНачалаИнтервала, "ДЛФ=D"), Формат(ОписаниеОкончанияИнтервала, "ДЛФ=D"));
				
				ВызватьИсключение ТекстИсключения;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	0 КАК Цифра
		|ПОМЕСТИТЬ ВТЦифры
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	1
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	3
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	5
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	6
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	7
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	8
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	9
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(&НачалоПериодаИнтервала, ЧАС, Цифры.Цифра + ЕСТЬNULL(Цифры10.Цифра, 0) * 10 + ЕСТЬNULL(Цифры100.Цифра, 0) * 100 + ЕСТЬNULL(Цифры1000.Цифра, 0) * 1000 + ЕСТЬNULL(Цифры10000.Цифра, 0) * 10000 + ЕСТЬNULL(Цифры100000.Цифра, 0) * 100000), ЧАС) КАК ИмяПоляПериод
		|ПОМЕСТИТЬ ИмяВТ
		|ИЗ
		|	ВТЦифры КАК Цифры
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦифры КАК Цифры10
		|		ПО (РАЗНОСТЬДАТ(&НачалоПериодаИнтервала, &ОкончаниеПериодаИнтервала, ЧАС) > 9)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦифры КАК Цифры100
		|		ПО (РАЗНОСТЬДАТ(&НачалоПериодаИнтервала, &ОкончаниеПериодаИнтервала, ЧАС) > 99)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦифры КАК Цифры1000
		|		ПО (РАЗНОСТЬДАТ(&НачалоПериодаИнтервала, &ОкончаниеПериодаИнтервала, ЧАС) > 999)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦифры КАК Цифры10000
		|		ПО (РАЗНОСТЬДАТ(&НачалоПериодаИнтервала, &ОкончаниеПериодаИнтервала, ЧАС) > 9999)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦифры КАК Цифры100000
		|		ПО (РАЗНОСТЬДАТ(&НачалоПериодаИнтервала, &ОкончаниеПериодаИнтервала, ЧАС) > 99999)
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(&НачалоПериодаИнтервала, ЧАС, Цифры.Цифра + ЕСТЬNULL(Цифры10.Цифра, 0) * 10 + ЕСТЬNULL(Цифры100.Цифра, 0) * 100 + ЕСТЬNULL(Цифры1000.Цифра, 0) * 1000 + ЕСТЬNULL(Цифры10000.Цифра, 0) * 10000 + ЕСТЬNULL(Цифры100000.Цифра, 0) * 100000), ЧАС) МЕЖДУ &НачалоИнтервала И &ОкончаниеИнтервала";
	
	Если ВРег(Периодичность) <> "ГОД"
		И ВРег(Периодичность) <> "КВАРТАЛ"
		И ВРег(Периодичность) <> "МЕСЯЦ"
		И ВРег(Периодичность) <> "ДЕНЬ" Тогда
		
		ВызватьИсключение НСтр("ru='Невозможно сформировать запрос с переданными параметрами.';uk='Неможливо сформувати запит з переданими параметрами'");
		
	КонецЕсли;
	
	Если ИспользоватьКонецПериода Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НАЧАЛОПЕРИОДА", "КОНЕЦПЕРИОДА");
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЧАС", Периодичность);
	ЗаменитьИмяСоздаваемойВременнойТаблицы(ТекстЗапроса, "ИмяВТ", ИмяВТ);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КАК ИмяПоляПериод", "КАК " + ИмяПоляПериод);
	
	Если ИспользоватьКонецПериода Тогда
		НачалоПериодаИнтервалаПредставление = "КОНЕЦПЕРИОДА(&НачалоИнтервала, " + ВРег(Периодичность) + ")";
		ОкончаниеПериодаИнтервалаПредставление = "КОНЕЦПЕРИОДА(&ОкончаниеИнтервала, " + ВРег(Периодичность) + ")";
	Иначе
		НачалоПериодаИнтервалаПредставление = "НАЧАЛОПЕРИОДА(&НачалоИнтервала, " + ВРег(Периодичность) + ")";
		ОкончаниеПериодаИнтервалаПредставление = "НАЧАЛОПЕРИОДА(&ОкончаниеИнтервала, " + ВРег(Периодичность) + ")";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&НачалоПериодаИнтервала", НачалоПериодаИнтервалаПредставление);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОкончаниеПериодаИнтервала", ОкончаниеПериодаИнтервалаПредставление);
	
	Если ТипЗнч(ОписаниеНачалаИнтервала) = Тип("Строка") Тогда
		НачалоИнтервалаПредставление = ОписаниеНачалаИнтервала;
	Иначе
		НачалоИнтервалаПредставление = "ДАТАВРЕМЯ(" + Формат(ОписаниеНачалаИнтервала, "ДФ='гггг, М, д, Ч, м, с'; ДП=") + ")";
	КонецЕсли;
	
	Если ТипЗнч(ОписаниеОкончанияИнтервала) = Тип("Строка") Тогда
		ОкончаниеИнтервалаПредставление = ОписаниеОкончанияИнтервала;
	Иначе
		ОкончаниеИнтервалаПредставление = "ДАТАВРЕМЯ(" + Формат(ОписаниеОкончанияИнтервала, "ДФ='гггг, М, д, Ч, м, с'; ДП=") + ")";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&НачалоИнтервала",
		"ВЫБОР КОГДА " + НачалоИнтервалаПредставление + " = ДАТАВРЕМЯ(1, 1, 1) ТОГДА ДАТАВРЕМЯ(1980, 1, 1) ИНАЧЕ " + НачалоИнтервалаПредставление + " КОНЕЦ");
	
	ИмяОкончаниеИнтервала = "ОкончаниеИнтервала" + СтрЗаменить(ИмяВТ, "_", "");
	Запрос.УстановитьПараметр(ИмяОкончаниеИнтервала, ДобавитьМесяц(ТекущаяДатаСеанса(), 60));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОкончаниеИнтервала",
		"ВЫБОР КОГДА " + ОкончаниеИнтервалаПредставление+ " = КОНЕЦПЕРИОДА(ДАТАВРЕМЯ(1, 1, 1), " + ВРег(Периодичность) + ") ТОГДА &" + ИмяОкончаниеИнтервала + " ИНАЧЕ " + ОкончаниеИнтервалаПредставление+ " КОНЕЦ");
	
	ДобавитьЗапросУничтоженияВременнойТаблицы(ТекстЗапроса, "ВТЦифры");
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос;
	
КонецФункции

// Осуществляет замену имени временной таблицы. Если не указано новое имя 
// временной таблицы, производится удаление из текста запроса строки, осуществляющей
// создание временной таблицы. Если новое имя временной таблицы передано, то производится
// замена всех фрагментов текста, содержащих старое имя временной таблицы на новое имя.
//
// Параметры:
//	ТекстЗапроса
//	ТекущееИмяТаблицы
//	НовоеИмяТаблицы
//
Процедура ЗаменитьИмяСоздаваемойВременнойТаблицы(ТекстЗапроса, ТекущееИмяТаблицы, НовоеИмяТаблицы = "") Экспорт
	
	Если ПустаяСтрока(НовоеИмяТаблицы) Тогда
		ЗамещаемыйТекст = "";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ " + ТекущееИмяТаблицы, "");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекущееИмяТаблицы, НовоеИмяТаблицы);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет к тексту запроса, переданному в параметре ТекстЗапроса, текст запроса
// уничтожения временной таблицы
//
// Параметры:
//		ТекстЗапроса - Строка
//		ИмяВременнойТаблицы - Строка
//
Процедура ДобавитьЗапросУничтоженияВременнойТаблицы(ТекстЗапроса, ИмяВременнойТаблицы) Экспорт
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = ?(ПустаяСтрока(ТекстЗапроса), "", ТекстЗапроса + РазделительЗапросов()) + "УНИЧТОЖИТЬ " + ИмяВременнойТаблицы;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает фрагмент текста запроса, отделяющего один запрос от другого.
//
Функция РазделительЗапросов() Экспорт
	
	Возврат "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
КонецФункции

// Процедура заполняет заголовки полей таблицы "подневного" ввода данных,
// а также делает невидимыми колонки с 29 по 31 
// в зависимости от количества дней в выбранном месяце.
//
// Параметры:
//	ЭлементыФормы - коллекция элементов формы.
//	Месяц - дата, начало выбранного месяца.
//	ШаблонИмениПоля - строка, имя поля дня, в котором номер дня обозначен "%1".
//
Процедура ОформитьПоляТаблицыДнейМесяца(ЭлементыФормы, Месяц, ШаблонИмениПоля) Экспорт
	
	ЦветРабочегоДня = ЦветаСтиля.ЦветТекстаФормы;
	ЦветВыходногоДня = ЦветаСтиля.ЦветОсобогоТекста;
	
	ПоследнийДеньМесяца = ИНАГРО_ЗарплатаКадрыРасширенныйКлиентСервер.КоличествоДнейМесяца(Месяц);
	
	Для НомерДня = 1 По ПоследнийДеньМесяца Цикл
		
		ТекущийДень = Дата(Год(Месяц), Месяц(Месяц), НомерДня);
		
		ДеньНедели = ДеньНедели(ТекущийДень);
		
		Элемент = ЭлементыФормы[СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениПоля, НомерДня)];
		Элемент.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								"%1%2%3", НомерДня, Символы.ПС, Формат(ТекущийДень, "ДФ=ddd"));
		Элемент.ЦветТекстаЗаголовка = ?(ДеньНедели = 6 Или ДеньНедели = 7, ЦветВыходногоДня, ЦветРабочегоДня);
		
	КонецЦикла;		
КонецПроцедуры	

Процедура ТабельУстановитьВидимостьКолонокДнейПериода(Форма) Экспорт
	ПервыйДеньПериода = День(Форма.Объект.ДатаНачалаПериода);
	ПоследнийДеньПериода = День(Форма.Объект.ДатаОкончанияПериода);
	
	Для НомерДня = 1 По ПервыйДеньПериода - 1 Цикл
		Форма.Элементы["ОтработанноеВремяВремя" + НомерДня + "Представление"].Видимость = Ложь;		
	КонецЦикла;	
	
	Для НомерДня = ПервыйДеньПериода По ПоследнийДеньПериода Цикл
		Форма.Элементы["ОтработанноеВремяВремя" + НомерДня + "Представление"].Видимость = Истина;		
	КонецЦикла;	
	
	Для НомерДня = ПоследнийДеньПериода + 1 По 31 Цикл
		Форма.Элементы["ОтработанноеВремяВремя" + НомерДня + "Представление"].Видимость = Ложь;		
	КонецЦикла;		
КонецПроцедуры	

Процедура ТабельПоместитьОписаниеВидовВремениВДанныеФормы(Форма) Экспорт
	
	БуквенныйКодИмяРеквизита = "БуквенныйКод";
	
	СоответствиеБуквенныхОбозначенийОписаниям = Новый Соответствие;
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Форма.Объект.Ссылка);
	
	ДоступныеВидыВремени = Менеджер.ДоступныеДляВводаВидыВремени();
	
	Выборка = СформироватьЗапросПоВидамВремени().Выбрать();	
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Выборка[БуквенныйКодИмяРеквизита]) Тогда
			Продолжить;
		КонецЕсли;	
		
		Описание = Новый ФиксированнаяСтруктура(Новый Структура("ВидВремени, Наименование", Выборка.ВидВремени, Выборка.Наименование)); 
		СоответствиеБуквенныхОбозначенийОписаниям.Вставить(ВРег(Выборка[БуквенныйКодИмяРеквизита]), Описание);	
	КонецЦикла;
	
	Форма.ОписаниеВидовВремени = Новый ФиксированноеСоответствие(СоответствиеБуквенныхОбозначенийОписаниям); 
КонецПроцедуры	

Функция СформироватьЗапросПоВидамВремени() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыИспользованияРабочегоВремени.Ссылка КАК ВидВремени,
	|	ВидыИспользованияРабочегоВремени.БуквенныйКод,
	|	ВидыИспользованияРабочегоВремени.ЦифровойКод,
	|	ВидыИспользованияРабочегоВремени.Наименование,
	|	ВидыИспользованияРабочегоВремени.РабочееВремя
	|ИЗ
	|	Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция БольничныеОтпуска(СписокСотрудников,НП,КП)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст="ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Период,
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Регистратор,
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.НомерСтроки,
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Активность,
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Сотрудник,
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Организация,
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Состояние
	             |ИЗ
	             |	РегистрСведений.ИНАГРО_СостояниеРаботниковОрганизаций КАК ИНАГРО_СостояниеРаботниковОрганизаций
	             |ГДЕ
	             |	ИНАГРО_СостояниеРаботниковОрганизаций.Период <= &КонецПериода
	             |	И ИНАГРО_СостояниеРаботниковОрганизаций.Период >= &НачалоПериода
	             |	И ИНАГРО_СостояниеРаботниковОрганизаций.Сотрудник В(&СписокСотрудников)
	             |	И ИНАГРО_СостояниеРаботниковОрганизаций.Состояние <> ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.Работает)
	             |	И ИНАГРО_СостояниеРаботниковОрганизаций.Состояние <> ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.НеИзменять)
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Период,
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Регистратор,
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.НомерСтроки,
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Активность,
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Сотрудник,
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Организация,
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Состояние
	             |ИЗ
	             |	РегистрСведений.ИНАГРО_СостояниеРаботниковОрганизаций.СрезПоследних(
	             |			&НачалоПериода,
	             |			Сотрудник В (&СписокСотрудников)
	             |				) КАК ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних
	             |ГДЕ
	             |	ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Состояние <> ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.Работает)
	             |	И ИНАГРО_СостояниеРаботниковОрганизацийСрезПоследних.Состояние <> ЗНАЧЕНИЕ(Перечисление.ИНАГРО_СостоянияРаботникаОрганизации.НеИзменять)";
	
	Запрос.УстановитьПараметр("КонецПериода",КП);
	Запрос.УстановитьПараметр("НачалоПериода",НП + 1);
	Запрос.УстановитьПараметр("СписокСотрудников",СписокСотрудников);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти