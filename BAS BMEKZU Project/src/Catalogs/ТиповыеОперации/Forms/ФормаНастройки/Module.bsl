#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаЗначенийРегистры = ПолучитьИзВременногоХранилища(Параметры.АдресСпискаРегистров);
	ЗначениеВРеквизитФормы(ТаблицаЗначенийРегистры, "Регистры");
	
	Для Каждого СтрокаРегистра Из Регистры Цикл
		Если СтрокаРегистра.ТипРегистра = Перечисления.ТипыРегистров.РегистрНакопления Тогда
			СписокРегистровНакопления.Добавить(
				СтрокаРегистра.ИмяРегистра,
				СтрокаРегистра.Синоним,
				СтрокаРегистра.ЕстьДвижения,
				БиблиотекаКартинок.РегистрНакопления);
		ИначеЕсли СтрокаРегистра.ТипРегистра = Перечисления.ТипыРегистров.РегистрСведений Тогда
			СписокРегистровСведений.Добавить(
				СтрокаРегистра.ИмяРегистра,
				СтрокаРегистра.Синоним,
				СтрокаРегистра.ЕстьДвижения,
				БиблиотекаКартинок.РегистрСведений);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьНастройку(Команда)
	
	// Получим список изменений
	СписокИзменений = Новый СписокЗначений;
	
	Для Каждого Регистр Из Регистры Цикл
		
		СтрокаПользовательскогоСписка = НайтиВПользовательскомСписке(Регистр.ИмяРегистра, Регистр.ТипРегистра);
		
		Если СтрокаПользовательскогоСписка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаПользовательскогоСписка.Пометка <> Регистр.ЕстьДвижения Тогда
			СписокИзменений.Добавить(Регистр.ИмяРегистра, Регистр.Синоним, СтрокаПользовательскогоСписка.Пометка);
		КонецЕсли;
			
	КонецЦикла;
	
	// Вернем список изменений
	Закрыть(СписокИзменений);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартнуюНастройку(Команда)
	
	// Стандартная настройка - "включены" только те регистры, по которым есть движения
	
	ИзменитьФлажки(Ложь); // Снять
	
	Для Каждого Регистр Из Регистры Цикл
		
		Если НЕ Регистр.ЕстьДвижения Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПользовательскогоСписка = НайтиВПользовательскомСписке(Регистр.ИмяРегистра, Регистр.ТипРегистра);
		
		Если СтрокаПользовательскогоСписка <> Неопределено Тогда
			СтрокаПользовательскогоСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеФлажки(Команда)
	
	ИзменитьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)
	
	ИзменитьФлажки(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьФлажки(Пометка)
	
	Для Каждого СтрокаРегистра Из СписокРегистровНакопления Цикл
		СтрокаРегистра.Пометка = Пометка;
	КонецЦикла;
	
	Для Каждого СтрокаРегистра Из СписокРегистровСведений Цикл
		СтрокаРегистра.Пометка = Пометка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиВПользовательскомСписке(ИмяРегистра, ТипРегистра)
	
	Если ТипРегистра = ПредопределенноеЗначение("Перечисление.ТипыРегистров.РегистрНакопления") Тогда
		ПользовательскийСписок = СписокРегистровНакопления;
	ИначеЕсли ТипРегистра = ПредопределенноеЗначение("Перечисление.ТипыРегистров.РегистрСведений") Тогда
		ПользовательскийСписок = СписокРегистровСведений;
	Иначе
		ПользовательскийСписок = Новый СписокЗначений;
	КонецЕсли;
	
	Возврат ПользовательскийСписок.НайтиПоЗначению(ИмяРегистра);
	
КонецФункции

#КонецОбласти