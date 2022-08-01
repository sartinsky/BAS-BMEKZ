
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыполнитьЧтениеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЧтениеНаСервере()
	
	УстановитьИнформациюПоСпособуРасчета(ЭтаФорма);
	УстановитьОграничениеБазы(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КатегорияУдержанийПриИзменении(Элемент)
	
	НастройкаПараметровВидаРасчета(ЭтаФорма);
	УстановитьОграничениеБазы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаПриИзменении(Элемент)
	
	УстановитьИнформациюПоСпособуРасчета(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ БазовыеВидыРасчета

&НаКлиенте
Процедура БазовыеВидыРасчетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УдалениеВыбранныхВидовРасчета(ВыбранноеЗначение.УдаленныеВидыРасчета, Объект.БазовыеВидыРасчета);
	
	Для Каждого Значение Из ВыбранноеЗначение.ДобавленныеВидыРасчета Цикл
		ОбработкаВыбранногоНачисления(Значение, Объект.БазовыеВидыРасчета, "БазовыеВидыРасчета");
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодборБазовых(Команда)
	
	МассивВидовРасчета = ЗарплатаКадрыКлиентСервер.ВидыРасчетаКоллекции(Объект.БазовыеВидыРасчета);
	Если Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ПочтовыйСбор") Тогда
		ПараметрыФормы = Новый Структура("МассивВидовРасчета, ПодборУдержаний", МассивВидовРасчета, Истина);
	Иначе
		ПараметрыФормы = Новый Структура("МассивВидовРасчета", МассивВидовРасчета);
	КонецЕсли;	
	ОткрытьФорму("ОбщаяФорма.ПодборВидовРасчета", ПараметрыФормы, Элементы.БазовыеВидыРасчета);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура НастройкаПараметровВидаРасчета(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьРасчетаБазы(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.РасчетБазы.Доступность = 
	 (Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаУдержаний.Процентом")); 
	
 КонецПроцедуры
 
 &НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОграничениеБазы(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ПочтовыйСбор") Тогда
		Элементы.БазовыеВидыРасчетаВидРасчета.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Удержания");
	Иначе	
		Элементы.БазовыеВидыРасчетаВидРасчета.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"); 
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнформациюПоСпособуРасчета(Форма)
	
	УстановитьДоступностьРасчетаБазы(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбранногоНачисления(Значение, ТаблицаВидовРасчета, ИмяТаблицы)
	
	Если ТаблицаВидовРасчета.НайтиСтроки(Новый Структура("ВидРасчета", Значение)).Количество() = 0 Тогда
		ТаблицаВидовРасчета.Добавить().ВидРасчета = Значение;
	КонецЕсли;
	
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



