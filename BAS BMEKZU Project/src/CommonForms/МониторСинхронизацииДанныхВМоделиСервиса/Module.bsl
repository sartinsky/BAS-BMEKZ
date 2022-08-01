
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(Неопределено, Истина, Ложь) Тогда
		ВызватьИсключение НСтр("ru='Нет прав на администрирование обменов данными.';uk='Немає прав на адміністрування обмінів даними.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбновитьСписокСостоянияУзлов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийВыгрузкиДанных(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.УзелИнформационнойБазы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(ТекущиеДанные.УзелИнформационнойБазы, ЭтотОбъект, "ВыгрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийЗагрузкиДанных(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.УзелИнформационнойБазы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(ТекущиеДанные.УзелИнформационнойБазы, ЭтотОбъект, "ЗагрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМонитор(Команда)
	
	ОбновитьДанныеМонитора();
	
КонецПроцедуры

&НаКлиенте
Процедура Подробно(Команда)
	
	ПодробноНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокСостоянияУзлов()
	
	СписокСостоянияУзлов.Очистить();
	
	СписокСостоянияУзлов.Загрузить(
		ОбменДаннымиВМоделиСервиса.ТаблицаМонитораОбменаДанными(ОбменДаннымиПовтИсп.РазделенныеПланыОбменаБСП()));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеМонитора()
	
	ИндексСтрокиСписокСостоянияУзлов = ПолучитьТекущийИндексСтроки("СписокСостоянияУзлов");
	
	// выполняем обновление таблиц монитора на сервере
	ОбновитьСписокСостоянияУзлов();
	
	// выполняем позиционирование курсора
	ВыполнитьПозиционированиеКурсора("СписокСостоянияУзлов", ИндексСтрокиСписокСостоянияУзлов);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущийИндексСтроки(ИмяТаблицы)
	
	// возвращаемое значение функции
	ИндексСтроки = Неопределено;
	
	// при обновлении монитора выполняем позиционирование курсора
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ИндексСтроки = ЭтотОбъект[ИмяТаблицы].Индекс(ТекущиеДанные);
		
	КонецЕсли;
	
	Возврат ИндексСтроки;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПозиционированиеКурсора(ИмяТаблицы, ИндексСтроки)
	
	Если ИндексСтроки <> Неопределено Тогда
		
		// выполняем проверки позиционирования курсора после получения новых данных
		Если ЭтотОбъект[ИмяТаблицы].Количество() <> 0 Тогда
			
			Если ИндексСтроки > ЭтотОбъект[ИмяТаблицы].Количество() - 1 Тогда
				
				ИндексСтроки = ЭтотОбъект[ИмяТаблицы].Количество() - 1;
				
			КонецЕсли;
			
			// позиционируем курсор
			Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтотОбъект[ИмяТаблицы][ИндексСтроки].ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодробноНаСервере()
	
	Элементы.СписокСостоянияУзловПодробно.Пометка = Не Элементы.СписокСостоянияУзловПодробно.Пометка;
	
	Элементы.СписокСостоянияУзловДатаПоследнейУспешнойВыгрузки.Видимость = Элементы.СписокСостоянияУзловПодробно.Пометка;
	Элементы.СписокСостоянияУзловДатаПоследнейУспешнойЗагрузки.Видимость = Элементы.СписокСостоянияУзловПодробно.Пометка;
	Элементы.СписокСостоянияУзловИмяПланаОбмена.Видимость = Элементы.СписокСостоянияУзловПодробно.Пометка;
	
КонецПроцедуры

#КонецОбласти
