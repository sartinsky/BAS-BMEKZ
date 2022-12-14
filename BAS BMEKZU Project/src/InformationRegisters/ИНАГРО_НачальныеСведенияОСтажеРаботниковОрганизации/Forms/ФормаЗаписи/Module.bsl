#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(Запись.ДатаСтажа) Тогда
		ПересчитатьСтаж(Запись.ИНАГРО_РежимНастройкиЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Запись.ИНАГРО_НачальныйСтаж = Строка(Год) + " р. " + Строка(Месяц) + " м. " + Строка(День) + " д. ";
	Запись.ДатаСтажа = ПересчитатьСтажВДату(Запись.Период, Ложь, - День, - Месяц, - Год);
	Запись.ДнейСтажа = (НачалоДня(Запись.Период) - НачалоДня(Запись.ДатаСтажа) ) / 86400;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСтажаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСтажаПриИзменении(Элемент)
	
	ПересчитатьСтаж(Ложь)
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПересчитатьСтаж(Запись.ИНАГРО_РежимНастройкиЗаписи)
	
КонецПроцедуры

&НаКлиенте
Процедура ИНАГРО_РежимНастройкиЗаписиПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	ПересчитатьСтаж(Запись.ИНАГРО_РежимНастройкиЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодМесяцДеньПриИзменении(Элемент)
	
	Если Запись.ДатаСтажа = Неопределено Тогда
		Запись.ДатаСтажа = ТекущаяДата();
	КонецЕсли;            
	
	Запись.ДатаСтажа = ПересчитатьСтажВДату(Запись.Период, , День, Месяц, Год);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект	 = Форма.Запись;	
	
	ЛьготныйСтаж = ВидСтажаЛьготный(Объект.ВидСтажа);
	
	Если Объект.ВидСтажа = ПредопределенноеЗначение("Справочник.ИНАГРО_ВидыСтажа.СтраховойСтажДляБольничного") Тогда
		Элементы.ДекорацияПериод.Заголовок = НСтр("ru='(за период до первых данных о стаже по данным реестра застрахованных лиц)';uk='(за період до перших даних про стаж по даним реєстру застрахованих осіб)'");
		Элементы.ДекорацияПериод1.Заголовок = НСтр("ru='(за период до первых данных о стаже по данным реестра застрахованных лиц)';uk='(за період до перших даних про стаж по даним реєстру застрахованих осіб)'");
	ИначеЕсли ЛьготныйСтаж Тогда
		Элементы.ДекорацияПериод.Заголовок = НСтр("ru='(дата действия льготного стажа)';uk='(дата дії пільгового стажу)'");
		Элементы.ДекорацияПериод1.Заголовок = НСтр("ru='(дата действия льготного стажа)';uk='(дата дії пільгового стажу)'");
	Иначе
		Элементы.ДекорацияПериод.Заголовок = НСтр("ru='(дата приема на нынеш. место работы)';uk='(дата прийому на нинішнє місце роботи)'");
		Элементы.ДекорацияПериод1.Заголовок = НСтр("ru='(дата приема на нынеш. место работы)';uk='(дата прийому на нинішнє місце роботи)'");
	КонецЕсли;
	
	Если Объект.ИНАГРО_РежимНастройкиЗаписи Тогда
		Элементы.ГруппаПериодыСтажа.ТекущаяСтраница = Элементы.ГруппаТрудоваяДеятельность;
		Элементы.Год.Доступность = Ложь;
		Элементы.Месяц.Доступность = Ложь;
		Элементы.День.Доступность = Ложь;
		Элементы.ДатаСтажа.Видимость = Ложь;
	Иначе
		Элементы.ГруппаПериодыСтажа.ТекущаяСтраница = Элементы.ГруппаЗаПериод;
		Элементы.Год.Доступность = Истина;
		Элементы.Месяц.Доступность = Истина;
		Элементы.День.Доступность = Истина;
		Элементы.ДатаСтажа.Видимость = Истина;
	КонецЕсли;
		 		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидСтажаЛьготный(ВидСтажа)
	
	Если ЗначениеЗаполнено(ВидСтажа) Тогда
		Возврат ВидСтажа.ЛьготныйСтаж;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ПересчитатьСтаж(ПерезаполнятьТЗ = Ложь)
	
	Если Не Запись.ИНАГРО_РежимНастройкиЗаписи Тогда
		Если ЗначениеЗаполнено(Запись.ДатаСтажа) И ЗначениеЗаполнено(Запись.Период) Тогда
			ИНАГРО_ПроведениеРасчетов.РазобратьРазностьДат(Запись.Период, Запись.ДатаСтажа, День, Месяц, Год);
		КонецЕсли;	
	Иначе
		Если ПерезаполнятьТЗ Тогда
			ТрудоваяДеятельность = Запись.Сотрудник.ФизическоеЛицо.ИНАГРО_ТрудоваяДеятельность.Выгрузить();
		КонецЕсли;
		РазностьДат = 0;
		КоличествоДней = 0 ;
		Для Каждого ПериодСтажа Из ТрудоваяДеятельность Цикл
			РазностьДат = ПериодСтажа.ДатаОкончания - ПериодСтажа.ДатаНачала+1;
			Если РазностьДат<> 0 Тогда
				КоличествоДней = КоличествоДней + РазностьДат/86400;
			КонецЕсли
			
		КонецЦикла;
		День = КоличествоДней;
		Запись.ДатаСтажа = Запись.Период - КоличествоДней*86400 - 1;
		ИНАГРО_ПроведениеРасчетов.РазобратьРазностьДат(Запись.Период, Запись.ДатаСтажа, День, Месяц, Год);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПересчитатьСтажВДату(ДатаНачала, Начало = ИСТИНА, Дней, Месяцев, Лет )
	
	Если Начало Тогда
		ДатаКонца = ДобавитьМесяц( ДатаНачала - 86400*Дней, -(Месяцев + Лет*12 ) );
	Иначе
		ДатаКонца = ДобавитьМесяц( ДатаНачала + 86400*Дней,  (Месяцев + Лет*12 ) );
	КонецЕсли;
	
	Возврат ДатаКонца;
	
КонецФункции

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.Сотрудник) И Не Запись.Сотрудник.ИНАГРО_ДоговорПодряда Тогда
		Запись.Период = РегистрыСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(,Новый Структура("Организация,Сотрудник",Запись.Организация, Запись.Сотрудник))[0].Период;
	Иначе
		Запись.Период = Дата(1, 1, 1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти
