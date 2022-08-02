#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 	
		
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьРеестрыТТН(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Реестр", "РеестрТТНВывозЖД");
		
	ОткрытьФорму("Обработка.ИНАГРО_ФормированиеРеестровТТН.Форма.Форма", ПараметрыФормы, ЭтаФорма, Новый УникальныйИдентификатор(), , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Команда.Имя = "ПодменюПечатьОбычное_Реестр" Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		
		ИмяКоманды      = Команда.Имя;
		АдресНастроек   = ЭтотОбъект.ПараметрыПодключаемыхКоманд.АдресТаблицыКоманд;
		ОписаниеКоманды = ПодключаемыеКомандыКлиентПовтИсп.ОписаниеКоманды(ИмяКоманды, АдресНастроек);
		
		Если ОписаниеКоманды.Идентификатор = "Пропуск_2021" Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Команда",              Команда);
			ДополнительныеПараметры.Вставить("ИдентификаторКоманды", ОписаниеКоманды.Идентификатор); 
			
			Оповещение = Новый ОписаниеОповещения("ВводЧислаЗавершение", ЭтотОбъект, ДополнительныеПараметры); 
			ПоказатьВводЧисла(Оповещение, 0, Нстр("ru='Введите количество экземпляров';uk='Введіть кількість екземплярів'"), 15, 0);
			
		Иначе
			ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
		КонецЕсли; 
		
	Иначе
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте 
Процедура ВводЧислаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 
	
	Если РезультатЗакрытия <> Неопределено Тогда
		ЗаписатьВыбранноеКоличество(РезультатЗакрытия, ДополнительныеПараметры.ИдентификаторКоманды);		
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, ДополнительныеПараметры.Команда, Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьВыбранноеКоличество(РезультатЗакрытия, ИдентификаторКоманды)
	
	Документы.ИНАГРО_ТТНВывоз.ЗаписатьВыбранноеКоличество(РезультатЗакрытия, ИдентификаторКоманды);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
