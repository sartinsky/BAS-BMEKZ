#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.КатегорияРасчета = Перечисления.КатегорииРасчетов.Первичное;
		Объект.СпособРасчета = Перечисления.СпособыРасчетаНачислений.Взносы;
	КонецЕсли;
	
	Элементы.ВедущиеВидыРасчетаВидРасчета.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовРасчетаСсылка.ИНАГРО_Начисления");
	
	ВыполнитьЧтениеНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ВыполнитьЧтениеНаСервере();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЕСВПриИзменении(Элемент)
	
	Если Объект.ЕСВ Тогда
		Объект.СтавкаПоПериодуРегистрации = Истина;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура БазовыеВидыРасчетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УдалениеВыбранныхВидовРасчета(ВыбранноеЗначение.УдаленныеВидыРасчета, Объект.БазовыеВидыРасчета);
	
	Для Каждого Значение Из ВыбранноеЗначение.ДобавленныеВидыРасчета Цикл
		ОбработкаВыбранногоНачисления(Значение, Объект.БазовыеВидыРасчета, "БазовыеВидыРасчета");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборБазовые(Команда)
	
	МассивВидовРасчета = ИНАГРО_РасчетЗарплатыРасширенныйКлиентСервер.ВидыРасчетаКоллекции(Объект.БазовыеВидыРасчета);
	ПараметрыФормы = Новый Структура("МассивВидовРасчета", МассивВидовРасчета);
	ОткрытьФорму("ОбщаяФорма.ИНАГРО_ПодборВидовРасчета", ПараметрыФормы, Элементы.БазовыеВидыРасчета);

КонецПроцедуры

&НаКлиенте
Процедура ПодборВедущие(Команда)
	
	МассивВидовРасчета = ИНАГРО_РасчетЗарплатыРасширенныйКлиентСервер.ВидыРасчетаКоллекции(Объект.ВедущиеВидыРасчета);
	ПараметрыФормы = Новый Структура("МассивВидовРасчета", МассивВидовРасчета);
	ОткрытьФорму("ОбщаяФорма.ИНАГРО_ПодборВидовРасчета", ПараметрыФормы, Элементы.ВедущиеВидыРасчета);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьЧтениеНаСервере(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	УстановитьДоступность(ЭтаФорма);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)
	
	Форма.Элементы.СпособРасчета.ТолькоПросмотр = Форма.Объект.Предопределенный;
	Форма.Элементы.СпособРасчетаПоШкале.ТолькоПросмотр = Форма.Объект.Предопределенный;
	Форма.Элементы.ЕСВ.ТолькоПросмотр = Форма.Объект.Предопределенный;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбранногоНачисления(Значение, ТаблицаВидовРасчета, ИмяТаблицы)
	
	Если ТаблицаВидовРасчета.НайтиСтроки(Новый Структура("ВидРасчета", Значение)).Количество() = 0 Тогда
		ТаблицаВидовРасчета.Добавить().ВидРасчета = Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВедущиеВидыРасчетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
		
	УдалениеВыбранныхВидовРасчета(ВыбранноеЗначение.УдаленныеВидыРасчета, Объект.ВедущиеВидыРасчета);
	
	Для Каждого Значение Из ВыбранноеЗначение.ДобавленныеВидыРасчета Цикл
		ОбработкаВыбранногоНачисления(Значение, Объект.ВедущиеВидыРасчета, "ВедущиеВидыРасчета");
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УдалениеВыбранныхВидовРасчета(УдаленныеВидыРасчета, ТаблицаВидовРасчета)
	
	Для Каждого Значение Из УдаленныеВидыРасчета Цикл
		СтрокиДляУдаления = ТаблицаВидовРасчета.НайтиСтроки(Новый Структура("ВидРасчета", Значение));
		Для Каждого ТекСтрока Из СтрокиДляУдаления Цикл 
			ТаблицаВидовРасчета.Удалить(ТекСтрока);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти