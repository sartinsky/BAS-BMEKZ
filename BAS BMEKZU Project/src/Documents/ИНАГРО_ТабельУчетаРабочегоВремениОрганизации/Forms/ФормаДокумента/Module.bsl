&НаКлиенте
Перем ТекущаяСтрокаОтработанногоВремениВЦеломЗаПериод;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	 // СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц, Организация, Ответственный, Подразделение", 
		"Объект.ПериодРегистрации",
		"Объект.Организация",
		"Объект.Ответственный",
		"Объект.ПодразделениеОрганизации");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		УстановитьФункциональныеОпцииФормы();
		
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока");
		Объект.СпособВводаДанных = Перечисления.ИНАГРО_СпособыВводаДанныхОВремени.Месяц;
		ПериодВводаДанныхОВремениПриИзмененииНаСервере();
		
		Если ТипЗнч(ЭтаФорма.ОписаниеВидовВремени) <> Тип("ФиксированноеСоответствие") Тогда
			ИНАГРО_УчетРабочегоВремени.ТабельПоместитьОписаниеВидовВремениВДанныеФормы(ЭтаФорма);
		КонецЕсли;
		УправлениеФормой(ЭтаФорма);
		
	КонецЕсли;
	 	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаполнитьСписокИменЯчеек(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Сотрудники") Тогда
		ДобавляемыеСотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ДобавляемыеСотрудники = ВыбранноеЗначение;
	КонецЕсли;

	ДобавитьСотрудников(ДобавляемыеСотрудники);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ГрупповоеЗаполнение"  И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		ВыполнитьГрупповоеЗаполнение(Параметр);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьФункциональныеОпцииФормы();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока");
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПодготовитьФормуНаСервере(); 
	

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
		
	УстановитьСостояниеДокумента();	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВводаДанныхПриИзменении(Элемент)
	
	ПериодВводаДанныхОВремениПриИзмененииНаСервере();
	ВыполнитьПерезаполнениеПоСпискуСотрудников();

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования,ЭтотОбъект,"Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.ДатаНачалаПериода) <> НачалоМесяца(Объект.ДатаОкончанияПериода) Тогда
		Объект.ДатаОкончанияПериода = КонецМесяца(Объект.ДатаНачалаПериода);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	ВыполнитьПерезаполнениеПоСпискуСотрудников();

КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.ДатаНачалаПериода) <> НачалоМесяца(Объект.ДатаОкончанияПериода) Тогда
		Объект.ДатаОкончанияПериода = КонецМесяца(Объект.ДатаНачалаПериода);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	ВыполнитьПерезаполнениеПоСпискуСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбработатьИзменениеОрганизацииНаСервере()
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизацииНаСервере()

	УстановитьФункциональныеОпцииФормы();

	ОчиститьТабличныеЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаПриИзменении(Элемент)
		
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока", Модифицированность);
	
	ПериодРегистрацииПриИзменении();
	
	ВыполнитьПерезаполнениеПоСпискуСотрудников();

КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзменении()
	ИНАГРО_УчетРабочегоВремени.ТабельПериодРегистрацииПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПериодВводаДанныхОВремениПриИзмененииНаСервере()
	ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельУстановитьПериодДокумента(ЭтаФорма);
	ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельУстановитьДоступностьЭлементовПериодаВводаДанных(ЭтаФорма);
	ПериодРегистрацииПриИзменении();	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
		
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрока", Направление, Модифицированность);
	ПериодРегистрацииПриИзменении();
	ВыполнитьПерезаполнениеПоСпискуСотрудников();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтработанноеВремя

&НаКлиенте
Процедура ОтработанноеВремяСотрудникПриИзменении(Элемент)
	
	СписокСотрудников = Новый СписокЗначений;
	ТекущиеДанные = Элементы.ОтработанноеВремя.ТекущиеДанные;
	ТекущиеДанные.Назначение = ТекущиеДанные.Сотрудник;
	СписокСотрудников.Добавить(ТекущиеДанные.Сотрудник);
		
	ЗаполнитьТаблицыТабеля(СписокСотрудников);

КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремя1СотрудникПриИзменении(Элемент)
	
	СписокСотрудников = Новый СписокЗначений;
	ТекущиеДанные = Элементы.ОтработанноеВремяОбщее.ТекущиеДанные;
	ТекущиеДанные.Назначение = ТекущиеДанные.Сотрудник;
	СписокСотрудников.Добавить(ТекущиеДанные.Сотрудник);
		
	ЗаполнитьТаблицыТабеля(СписокСотрудников);

КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееПриАктивизацииСтроки(Элемент)
	
	ОбновитьТекущуюСтрокуОтработанногоВремениВЦеломЗаПериод(Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ИНАГРО_УчетРабочегоВремениКлиент.ТабельДанныеОВремениПередОкончаниемРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СоответствиеДляПоискаСотрудника = Новый Структура;
	СоответствиеДляПоискаСотрудника.Вставить("Сотрудник",   Элементы.ОтработанноеВремяОбщее.ТекущиеДанные.Сотрудник);
	СоответствиеДляПоискаСотрудника.Вставить("ВидВремени",  ПредопределенноеЗначение("Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени.ПустаяСсылка"));
	СоответствиеДляПоискаСотрудника.Вставить("Назначение",  Элементы.ОтработанноеВремяОбщее.ТекущиеДанные.Назначение);
	МассивСтрок = Объект.ОтработанноеВремяВЦеломЗаПериод.НайтиСтроки(СоответствиеДляПоискаСотрудника);
	Для ИндексМассива = 0 По МассивСтрок.Количество()-1 Цикл
		Объект.ОтработанноеВремяВЦеломЗаПериод.Удалить(МассивСтрок[ИндексМассива]);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееВидВремениПриИзменении(Элемент)
	НомерЯчейки = Прав(Элементы.ОтработанноеВремяОбщее.ТекущийЭлемент.Имя, 1);
	ТекущаяСтрокаОтработанногоВремениВЦеломЗаПериод.ВидВремени = Элементы.ОтработанноеВремяОбщее.ТекущиеДанные["ВидВремени" + НомерЯчейки];
КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееДнейПриИзменении(Элемент)
	НомерЯчейки = Прав(Элементы.ОтработанноеВремяОбщее.ТекущийЭлемент.Имя, 1);
	ТекущаяСтрокаОтработанногоВремениВЦеломЗаПериод.Дней = Элементы.ОтработанноеВремяОбщее.ТекущиеДанные["Дней" + НомерЯчейки];
КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееЧасовПриИзменении(Элемент)
	НомерЯчейки = Прав(Элементы.ОтработанноеВремяОбщее.ТекущийЭлемент.Имя, 1);
	ТекущаяСтрокаОтработанногоВремениВЦеломЗаПериод.Часов = Элементы.ОтработанноеВремяОбщее.ТекущиеДанные["Часов" + НомерЯчейки];
КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееПередУдалением(Элемент, Отказ)
	
	СоответствиеДляПоискаСотрудника = Новый Структура;
	СоответствиеДляПоискаСотрудника.Вставить("Сотрудник",  Элементы.ОтработанноеВремяОбщее.ТекущиеДанные.Сотрудник);
	МассивСтрок = Объект.ОтработанноеВремяВЦеломЗаПериод.НайтиСтроки(СоответствиеДляПоискаСотрудника);
	Для ИндексМассива = 0 По МассивСтрок.Количество()-1 Цикл
		Объект.ОтработанноеВремяВЦеломЗаПериод.Удалить(МассивСтрок[ИндексМассива]);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяОбщееПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ОбновитьТекущуюСтрокуОтработанногоВремениВЦеломЗаПериод(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтработанноеВремяВремяПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	НомерКолонкиПредставление = СтрЗаменить(Элемент.Имя, "ОтработанноеВремяВремя", "");
	НомерКолонки = СтрЗаменить(НомерКолонкиПредставление, "Представление","");
	
	ОбработкаВводаДанныхВЯчейку(Элемент, Текст, СтандартнаяОбработка, НомерКолонки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	ПодобратьСотрудников(Истина);

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Если Объект.ОтработанноеВремя.Количество() > 0 Тогда
		 
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?';uk='Перед заповненям таблична частина буде очищена. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("ОчиститьТаблицыЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
		
	Объект.ОтработанноеВремя.Очистить();
	Объект.ОтработанноеВремяВЦеломЗаПериод.Очистить();
		
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, Истина)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента(); 
	
	ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельУстановитьДоступностьЭлементовПериодаВводаДанных(ЭтаФорма);
	ИНАГРО_УчетРабочегоВремени.ТабельУстановитьВидимостьКолонокДнейПериода(ЭтаФорма);
	ИНАГРО_УчетРабочегоВремени.ОформитьПоляТаблицыДнейМесяца(ЭтаФорма.Элементы, НачалоМесяца(Объект.ПериодРегистрации), "ОтработанноеВремяВремя%1Представление");
	
	Если ТипЗнч(ЭтаФорма.ОписаниеВидовВремени) <> Тип("ФиксированноеСоответствие") Тогда
		ИНАГРО_УчетРабочегоВремени.ТабельПоместитьОписаниеВидовВремениВДанныеФормы(ЭтаФорма);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
			
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, Объект.Дата);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой(Форма)
	
	МассивПриставок = Новый Массив(4);
	МассивПриставок[0] = "Первый";
	МассивПриставок[1] = "Второй";
	МассивПриставок[2] = "Третий";
	МассивПриставок[3] = "Четвертый";
	Если Объект.СпособВводаДанных <> Перечисления.ИНАГРО_СпособыВводаДанныхОВремени.ВЦеломЗаПериод Тогда
	ОбозначенияВидовВремени = ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельОбозначенияВидовВремени(Форма.ОписаниеВидовВремени);
	ДеньНачалаПериода = День(Объект.ДатаНачалаПериода);
	ДеньОкончанияПериода = День(Объект.ДатаОкончанияПериода);
		
		Для Каждого ОформлениеСтроки Из Объект.ОтработанноеВремя Цикл
			
			// Цикл по дням
			Для ИндексДня  = 1 По 31 Цикл
				ТекстЯчейки = "";
				СтрокаИндексДня = Строка(ИндексДня);
				// Цикл по значениям внутри дня
				Для ИндексМассиваПриставок = 0 По 3 Цикл
					НазваниеЯчейкиВидВремени = МассивПриставок[ИндексМассиваПриставок] + "ВидВремени"+СтрокаИндексДня;
					НазваниеЯчейкиДней = МассивПриставок[ИндексМассиваПриставок] + "Часов"+СтрокаИндексДня;
					КоличествоЧасов = Строка(ОформлениеСтроки[НазваниеЯчейкиДней]);

					Если КоличествоЧасов = "0" Тогда
						КоличествоЧасов = "";
					КонецЕсли;
					ВидВремени = ОформлениеСтроки[НазваниеЯчейкиВидВремени];
					
					Если НЕ ВидВремени.Пустая() Тогда
						ТекстЯчейки = ТекстЯчейки + Символы.ПС + ВидВремени.БуквенныйКод + " " + КоличествоЧасов;
					КонецЕсли;
					
				КонецЦикла;	
				ТекстЯчейки = Сред(ТекстЯчейки, 2);
				ОформлениеСтроки["Время" + СтрокаИндексДня + "Представление"] = ТекстЯчейки;
			КонецЦикла;
			
			ИНАГРО_УчетРабочегоВремениКлиентСервер.ТабельЗаполнитьИтогиПоСотруднику(ОформлениеСтроки, ОбозначенияВидовВремени, ДеньНачалаПериода, ДеньОкончанияПериода);
		КонецЦикла;
		
	Иначе	
	
		Для Каждого ОформлениеСтроки Из Объект.ОтработанноеВремя Цикл       
			ИскомыйСотрудник = ОформлениеСтроки.Сотрудник;
			ИскомоеНазначение = ОформлениеСтроки.Назначение;
			СоответствиеДляПоискаСотрудника = Новый Структура;
			Если ИскомыйСотрудник <> ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка") Тогда
				СоответствиеДляПоискаСотрудника.Очистить();
				СоответствиеДляПоискаСотрудника.Вставить("Сотрудник",  ИскомыйСотрудник);
				СоответствиеДляПоискаСотрудника.Вставить("Назначение",  ИскомоеНазначение);
				
				МассивСтрок = Объект.ОтработанноеВремяВЦеломЗаПериод.НайтиСтроки(СоответствиеДляПоискаСотрудника);
				Для ИндексМассива = 0 По МассивСтрок.Количество()-1 Цикл
					ОформлениеСтроки["ВидВремени"+Строка(ИндексМассива+1)] = МассивСтрок[ИндексМассива].ВидВремени;
					ОформлениеСтроки["Дней"+Строка(ИндексМассива+1)] = МассивСтрок[ИндексМассива].Дней;
					ОформлениеСтроки["Часов"+Строка(ИндексМассива+1)] = МассивСтрок[ИндексМассива].Часов;
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры 

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокИменЯчеек(Форма)
	
	СписокИменЯчеекДляОпределенияСтроки = Новый СписокЗначений;
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееВидВремени1");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееВидВремени2");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееВидВремени3");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееВидВремени4");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееВидВремени5");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееВидВремени6");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееДней1");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееДней2");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееДней3");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееДней4");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееДней5");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееДней6");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееЧасов1");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееЧасов2");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееЧасов3");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееЧасов4");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееЧасов5");
	СписокИменЯчеекДляОпределенияСтроки.Добавить("ОтработанноеВремяОбщееЧасов6");

КонецПроцедуры

&НаСервере
Процедура ОчиститьТабличныеЧасти()
	
	Объект.ОтработанноеВремя.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПерезаполнениеПоСпискуСотрудников()
	
	ТаблицаСотрудников = Объект.ОтработанноеВремя;
	
	СписокСотрудников = Новый СписокЗначений;
			
	Для Каждого СтрокаСписка Из ТаблицаСотрудников Цикл
		
		СтруктураПоиска = Новый Структура("Назначение", СтрокаСписка.Назначение);
		СписокСотрудников.Добавить(СтрокаСписка.Назначение);
		
	КонецЦикла;
	Объект.ОтработанноеВремя.Очистить();
	Объект.ОтработанноеВремяВЦеломЗаПериод.Очистить();
	
	ЗаполнитьТаблицыТабеля(СписокСотрудников);
	
КонецПроцедуры

&НаКлиенте
// Процедура устанваливает значение переменной ТекущаяСтрокаОтработанногоВремениВЦеломЗаПериод
// на строку таблицы ОтработанноеВремяВЦеломЗаПериод, соответствующую текущей редактируемой строке.
Процедура ОбновитьТекущуюСтрокуОтработанногоВремениВЦеломЗаПериод(Элемент)
	
	Если Элементы.ОтработанноеВремяОбщее.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СписокИменЯчеекДляОпределенияСтроки.НайтиПоЗначению(Элементы.ОтработанноеВремяОбщее.ТекущийЭлемент.Имя) <> Неопределено Тогда
		ФормаОтработанноеВремяВЦеломЗаПериод = Элементы.ОтработанноеВремяОбщее;
		ФормаОтработанноеВремяВЦеломЗаПериодТекущаяСтрока = ФормаОтработанноеВремяВЦеломЗаПериод.ТекущиеДанные;
		Если ФормаОтработанноеВремяВЦеломЗаПериодТекущаяСтрока <> Неопределено Тогда
			НомерЯчейки = Прав(Элементы.ОтработанноеВремяОбщее.ТекущийЭлемент.Имя, 1);
			ТекущаяСтрокаОтработанногоВремениВЦеломЗаПериод = ПолучитьТекущуюСтрокуТабличнойЧастиОтработанноеВремяВЦеломЗаПериод(
			ФормаОтработанноеВремяВЦеломЗаПериодТекущаяСтрока.Сотрудник,
			ФормаОтработанноеВремяВЦеломЗаПериодТекущаяСтрока.Назначение,
			ФормаОтработанноеВремяВЦеломЗаПериодТекущаяСтрока["ВидВремени"+НомерЯчейки]);			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
   	
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
        Возврат;
	КонецЕсли;
	
	Объект.ОтработанноеВремя.Очистить();
	Объект.ОтработанноеВремяВЦеломЗаПериод.Очистить();
	
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, Истина)
		     
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьГрупповоеЗаполнение(Параметр)
	
	ВыполнитьГрупповоеЗаполнениеНаСервере(Параметр);	
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьГрупповоеЗаполнениеНаСервере(Параметр)
	
	ТаблицаСотрудников = ПолучитьИзВременногоХранилища(Параметр.АдресТЗ);
	
	СписокСотрудников = Новый СписокЗначений;
			
	Для Каждого СтрокаСписка Из ТаблицаСотрудников Цикл
		
		СтруктураПоиска = Новый Структура("Сотрудник", СтрокаСписка.Сотрудник);
		Если Объект.ОтработанноеВремя.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			СписокСотрудников.Добавить(СтрокаСписка.Сотрудник);
		КонецЕсли;
		
	КонецЦикла;
	ЗаполнитьТаблицыТабеля(СписокСотрудников);
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицыТабеля(СписокСотрудников)
	
	Документ = РеквизитФормыВЗначение("Объект");
  	Документ.Автозаполнение(ЭтаФорма, ,СписокСотрудников, );
  	ЗначениеВРеквизитФормы(Документ, "Объект");	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

// Процедура проверяет введенное в ячейку значение на присутствие в
// Справочнике ИНАГРО_КлассификаторИспользованияРабочегоВремени, и нормирует значение.
&НаКлиенте
Функция ОбработкаВводаДанныхВЯчейку(Элемент, Текст, СтандартнаяОбработка, НомерДня)
	
	МассивПриставок = Новый Массив(4);
	МассивПриставок[0] = "Первый";
	МассивПриставок[1] = "Второй";
	МассивПриставок[2] = "Третий";
	МассивПриставок[3] = "Четвертый";
	
	Результат = ""; 
	
	ТекущиеДанные = Элементы.ОтработанноеВремя.ТекущиеДанные;
	Если НормироватьТекст(Текст, Результат) Тогда
		ТекущиеДанные["Время" + НомерДня + "Представление"] = Результат;
	Иначе
		Значение = Новый СписокЗначений;
		СтандартнаяОбработка = Ложь;
		Возврат Ложь;
	КонецЕсли;
	
	Для ИндексМассиваПриставок = 0 По 3 Цикл
		ТекущиеДанные[МассивПриставок[ИндексМассиваПриставок]+"ВидВремени"+НомерДня] = ПредопределенноеЗначение("Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени.ПустаяСсылка");
		ТекущиеДанные[МассивПриставок[ИндексМассиваПриставок]+"Часов"+НомерДня] = 0;
	КонецЦикла;
	
	СписокВремени = "";
	ИндексМассиваПриставок = 0;
	ПередаваемоеЗначениеЯчейки = ТекущиеДанные["Время" + НомерДня + "Представление"];
	ПередаваемоеЗначениеЯчейки = Лев(ПередаваемоеЗначениеЯчейки, СтрДлина(ПередаваемоеЗначениеЯчейки)-1);
	ПолучитьВидВремениИКоличествоЧасов(ПередаваемоеЗначениеЯчейки, СписокВремени);
	
	Для Инд = 0 По СписокВремени.Количество()-1 Цикл
		ЭлементСписка = СписокВремени.Получить(Инд);
		Если ИндексМассиваПриставок > 3 Тогда
			ТекстСообщения =НСтр("ru='В ячейку можно записать не больше чем 4 вида времени';uk='В комірку можна записати не більше ніж 4 види часу'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Прервать;
		Иначе
			ТекущиеДанные[МассивПриставок[ИндексМассиваПриставок]+"ВидВремени"+НомерДня] = ЭлементСписка.Значение;
			ТекущиеДанные[МассивПриставок[ИндексМассиваПриставок]+"Часов"+НомерДня] = Число(ЭлементСписка.Представление);
			ИндексМассиваПриставок = ИндексМассиваПриставок + 1;
		КонецЕсли;
	КонецЦикла;
		
	Возврат Истина;
КонецФункции // ОбработкаВводаДанныхВЯчейку()

// Функция проверяет введенные в таблице данные на правильность, 
// а также приводит их к нормальному виду.
// Параметры
// Текст
// Результат
// НеполныйФормат
// Возврат
//
&НаКлиенте
Функция НормироватьТекст(Текст, Результат, НеполныйФормат = Истина)
	
	Результат = "";
	Если ПустаяСтрока(Текст) Тогда
		Возврат Истина;
	КонецЕсли;
	
	БуквенныеОбозначения = ПолучитьБуквенныеОбозначения();
	
	Разделители = Новый Массив;
	Разделители.Добавить(Символы.ПС);
	Разделители.Добавить(" ");
	Разделители.Добавить("-");
	Разделители.Добавить(";");
	Разделители.Добавить("/");
	Разделители.Добавить(",");
	Разделители.Добавить(":");  
	
	РазделительВГруппе = " ";
	РазделительГрупп = Символы.ПС;
	КоличествоРазделителей = 0;
	
	Для Каждого Разделитель Из Разделители Цикл
		ПодСтроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, Разделитель);
		Если ПодСтроки.Количество() > 1 Тогда
			БылКод = Ложь;
			Для Каждого ПодСтрока Из Подстроки Цикл
				Код = БуквенныеОбозначения[СокрЛП(ВРег(ПодСтрока))];
				Если Код <> НеОпределено Тогда
					Если БылКод Тогда
						Возврат Ложь;
					КонецЕсли;
					Результат = Результат + ВРег(ПодСтрока);
					БылКод = Истина;
				ИначеЕсли ЭтоЧисло(СпецСокрЛП(ПодСтрока, Разделители)) И БылКод Тогда
					Результат = Результат + РазделительВГруппе + СпецСокрЛП(ПодСтрока, Разделители) + РазделительГрупп;
					БылКод = Ложь;
				Иначе
					ПодРезультат = "";
					Если НормироватьТекст(ПодСтрока, ПодРезультат, Ложь) Тогда
						Результат = Результат + ПодРезультат;
					Иначе
						Возврат Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ПустаяСтрока(Результат) Тогда
		Если НеполныйФормат Тогда
			Код = БуквенныеОбозначения[СокрЛП(ВРег(Текст))];
			Если Код <> НеОпределено Тогда
				Результат = СокрЛП(ВРег(Текст)) + РазделительВГруппе +"8" + РазделительГрупп;
				Возврат Истина;
			ИначеЕсли ЭтоЧисло(СпецСокрЛП(Текст, Разделители)) Тогда
				Результат = "Я" + РазделительВГруппе + СпецСокрЛП(Текст, Разделители) + РазделительГрупп;
				Возврат Истина;
			ИначеЕсли СокрЛП(Текст) = "0" Тогда
				
				Возврат Истина;
			Иначе
				Возврат Ложь;
			КонецЕсли;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		
		Возврат Истина;
	КонецЕсли;
КонецФункции 

// По тексту из ячейки (текст) возвращает соответствие: ВидВремени (классификатор) - Количество часов
// Параметры
// Текст
// Результат
&НаКлиенте
Функция ПолучитьВидВремениИКоличествоЧасов(Текст , Результат)
	
	Результат = Новый СписокЗначений;
	Если ПустаяСтрока(Текст) Тогда
        Возврат Истина;
	КонецЕсли;
	
	БуквенныеОбозначения = ПолучитьБуквенныеОбозначения();
	РазделительВГруппе = " ";
    РазделительГрупп = Символы.ПС;
    
	ПодСтроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, РазделительГрупп);
	Для ИндексМассива = 0 По ПодСтроки.Количество() - 1 Цикл
		ВидВремениИКоличество = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПодСтроки[ИндексМассива], РазделительВГруппе);
		Если ВидВремениИКоличество.Количество() = 2 Тогда
			Код = БуквенныеОбозначения[ВидВремениИКоличество[0]];
			Количество = Число(ВидВремениИКоличество[1]);
			Результат.Добавить(Код,Количество);  
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции // ПолучитьВидВремениИКоличествоЧасов()

&НаКлиенте
// Функция определяет, возможно ли переданную строку перевести в число
// Возвращает Истина, если Возможно, иначе Ложь
Функция ЭтоЧисло(Строка)
	Попытка
		Число = Число(Строка);
		Если Число = 0 Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

&НаКлиенте
// Функция, удаляет символы до разделителя слева и справа после разделителя.
Функция СпецСокрЛП(Строка, Разделители)
	НоваяСтрока = Строка;
	// удалим лишние символы слева
	Пока Истина Цикл
		Символ = Лев(НоваяСтрока, 1);
		ЭтоРазделитель = Ложь;
		Для Каждого Разделитель Из Разделители Цикл
			Если Символ = Разделитель Тогда
				ЭтоРазделитель = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЭтоРазделитель Тогда
			НоваяСтрока = Сред(НоваяСтрока, 2);
			Если ПустаяСтрока(НоваяСтрока) Тогда
				Прервать;
			КонецЕсли;    
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;        
	// удалим лишние символы справа
	Пока Истина Цикл
		Символ = Прав(НоваяСтрока, 1);
		ЭтоРазделитель = Ложь;
		Для Каждого Разделитель Из Разделители Цикл
			Если Символ = Разделитель Тогда
				ЭтоРазделитель = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЭтоРазделитель Тогда
			НоваяСтрока = Лев(НоваяСтрока, СтрДлина(НоваяСтрока) - 1);
			Если ПустаяСтрока(НоваяСтрока) Тогда
				Прервать;
			КонецЕсли;    
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат НоваяСтрока;
КонецФункции

&НаСервере
Функция ПолучитьБуквенныеОбозначения()
	
	БуквенныеОбозначения = Новый Соответствие;
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка, БуквенныйКод ИЗ Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		БуквенныеОбозначения[ВРег(Выборка.БуквенныйКод)] = Выборка.Ссылка;
	КонецЦикла;
	
	Возврат БуквенныеОбозначения;
	
КонецФункции

// Функция ищет строку в табличной части по параметрам: Сотрудник, ВидВремени, 
// Если строка не найдена, то вводится новая строка, и устанавливаются параметры
// Сотрудник, ВидВремени.
&НаКлиенте
Функция ПолучитьТекущуюСтрокуТабличнойЧастиОтработанноеВремяВЦеломЗаПериод(Сотрудник,Назначение, ВидВремени)
	
	ПоискСтроки = Новый Структура;
	ПоискСтроки.Вставить("Сотрудник", Сотрудник);
	ПоискСтроки.Вставить("ВидВремени", ВидВремени);
	ПоискСтроки.Вставить("Назначение", Назначение);
	МассивСтрок = Объект.ОтработанноеВремяВЦеломЗаПериод.НайтиСтроки(ПоискСтроки);
	Если МассивСтрок.Количество() > 0 Тогда
		ТекущаяСтрока = МассивСтрок[0];
	Иначе
		ТекущаяСтрока = Объект.ОтработанноеВремяВЦеломЗаПериод.Добавить();
		ТекущаяСтрока.Сотрудник = Сотрудник;
		ТекущаяСтрока.ВидВремени = ВидВремени;
		ТекущаяСтрока.Назначение = Назначение;
	КонецЕсли;
	
	Возврат ТекущаяСтрока;
	
КонецФункции // ПолучитьТекущуюСтрокуТабличнойЧастиОтработанноеВремяВЦеломЗаПериод()

&НаКлиенте
Процедура ПодобратьСотрудников(МножественныйВыбор)
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериоде(
		ЭтаФорма, Объект.Организация, Неопределено,
		Объект.Дата, КонецМесяца(Объект.Дата), МножественныйВыбор,
		АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСотрудников(Знач СписокСотрудников)
	
	СотрудникиКДобавлению = Новый Массив;
	
	Для каждого ДобавляемыйСотрудник Из СписокСотрудников Цикл
		
		Если Объект.ОтработанноеВремя.НайтиСтроки(Новый Структура("Сотрудник", ДобавляемыйСотрудник)).Количество() = 0 Тогда
			ТекущаяСтрока = Объект.ОтработанноеВремя.Добавить();
			ТекущаяСтрока.Сотрудник = ДобавляемыйСотрудник;
			ТекущаяСтрока.Назначение = ДобавляемыйСотрудник;
		
			ЗаполнитьТаблицыТабеля(СписокСотрудников);
			
		КонецЕсли; 
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ОтработанноеВремя.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти